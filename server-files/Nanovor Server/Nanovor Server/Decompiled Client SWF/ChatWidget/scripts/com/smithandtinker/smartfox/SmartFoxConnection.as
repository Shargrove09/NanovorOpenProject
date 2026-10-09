package com.smithandtinker.smartfox
{
   import com.arkadium.communications.GameServiceConnectionData;
   import com.arkadium.communications.IGameServiceConnection;
   import com.arkadium.communications.handlers.*;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   
   public class SmartFoxConnection extends SmartFoxClient implements IGameServiceConnection
   {
      
      private static const SFS_SERVER_ZONE:String = "nanovor_sim";
      
      public static const EXTENSION_RESPONSE_COMMAND_LOGIN_OK:String = "logOK";
      
      private static const EXTENSION_RESPONSE_COMMAND_LOGIN_FAILED:String = "loginFailed";
      
      private static const EXTENSION_RESPONSE_COMMAND_FORCED_LOG_OUT:String = "forcedLogOut";
      
      private var _loginStatusType:LoginStatusType;
      
      private var _loginResultHandler:ILoginResultHandler;
      
      private var _gameServiceConnectionData:GameServiceConnectionData;
      
      private var _commonDialogBox:CommonDialogBox;
      
      public function SmartFoxConnection(param1:GameServiceConnectionData, param2:Boolean = false)
      {
         super(param2);
         this._gameServiceConnectionData = param1;
         this._loginStatusType = LoginStatusType.OFFLINE;
      }
      
      private function handleAdminMessage(param1:SFSEvent) : void
      {
         this._commonDialogBox = CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Admin Message",String(param1.params.message),0,this.handleOKAdminMessageDialog,this.handleExitAdminMessageDialog,null,null);
      }
      
      public function destroy() : void
      {
         this._loginResultHandler = null;
      }
      
      private function handleOKAdminMessageDialog(param1:Object) : void
      {
         this._commonDialogBox.kill();
      }
      
      private function addLoginResultHandler(param1:ILoginResultHandler) : void
      {
         this._loginResultHandler = param1;
      }
      
      public function loginToGameService(param1:ILoginResultHandler) : void
      {
         DebugLog.instance.log("SmartFoxConnection.loginToGameService()");
         if(false == isConnected)
         {
            DebugLog.instance.log("SmartFoxConnection.loginToGameService(): not connected so connecting...");
            this._loginStatusType = LoginStatusType.OFFLINE;
            addEventListener(SFSEvent.onConfigLoadFailure,this.handleConfigLoadFailure);
            addEventListener(SFSEvent.onConnection,this.handleConnection);
            addEventListener(SFSEvent.onAdminMessage,this.handleAdminMessage);
            this.addLoginResultHandler(param1);
            connect(this._gameServiceConnectionData.ipAddress,this._gameServiceConnectionData.port);
            return;
         }
         switch(this._loginStatusType)
         {
            case LoginStatusType.LOGGED_IN:
               param1.handleLoginResult({"loginResultType":LoginResultType.LOGIN_SUCCESS});
               break;
            case LoginStatusType.LOGGING_IN:
               this.addLoginResultHandler(param1);
               break;
            default:
               this._loginStatusType = LoginStatusType.LOGGING_IN;
               this.addLoginResultHandler(param1);
               this.loginToSmartFox();
         }
      }
      
      override public function logout() : void
      {
         super.logout();
         this._loginStatusType = LoginStatusType.OFFLINE;
      }
      
      private function handleExtensionResponse(param1:SFSEvent) : void
      {
         DebugLog.instance.log("SmartFoxConnection.handleExtensionResponse(): command: " + param1.params.dataObj._cmd);
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = param1.params.dataObj;
         switch(String(_loc3_._cmd))
         {
            case EXTENSION_RESPONSE_COMMAND_LOGIN_OK:
               DebugLog.instance.log("SmartFoxConnection.handleExtensionResponse(): login successful: current room: " + _loc3_.chatRoomName);
               this._loginStatusType = LoginStatusType.LOGGED_IN;
               myUserName = _loc3_.username;
               addEventListener(SFSEvent.onJoinRoom,this.handleJoinRoom);
               addEventListener(SFSEvent.onJoinRoomError,this.handleJoinRoomError);
               autoJoin();
               break;
            case EXTENSION_RESPONSE_COMMAND_LOGIN_FAILED:
               this._loginStatusType = LoginStatusType.OFFLINE;
               this.handleLoginResult(LoginResultType.LOGIN_FAILURE);
               this.disconnect();
               break;
            case EXTENSION_RESPONSE_COMMAND_FORCED_LOG_OUT:
               this._loginStatusType = LoginStatusType.OFFLINE;
               this.disconnect();
         }
      }
      
      private function handleConfigLoadFailure(param1:SFSEvent) : void
      {
         removeEventListener(SFSEvent.onConnection,this.handleConnection);
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         this.handleLoginResult(LoginResultType.CONFIG_LOAD_FAILURE);
         DebugLog.instance.log("SmartFoxConnection.handleConfigLoadFailure()");
      }
      
      private function handleJoinRoomError(param1:SFSEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(SFSEvent.onJoinRoom,this.handleJoinRoom);
         IEventDispatcher(param1.currentTarget).removeEventListener(SFSEvent.onJoinRoomError,this.handleJoinRoomError);
         this.handleLoginResult(LoginResultType.LOGIN_FAILURE);
      }
      
      override public function disconnect() : void
      {
         super.disconnect();
         this._loginStatusType = LoginStatusType.OFFLINE;
      }
      
      private function handleLoginResult(param1:LoginResultType) : void
      {
         DebugLog.instance.log("SmartFoxConnection.handleLoginResult(): loginResultType==" + param1.toString());
         if(null == this._loginResultHandler)
         {
            throw new Error("SmartFoxConnection.handleLoginResult(): _loginResultHandler cannot be null: did you pass a valid handler to loginToGameService()?");
         }
         this._loginResultHandler.handleLoginResult({"loginResultType":param1});
         this._loginResultHandler = null;
      }
      
      private function handleConnection(param1:SFSEvent) : void
      {
         DebugLog.instance.log("SmartFoxConnection.handleConnection()");
         removeEventListener(SFSEvent.onConfigLoadFailure,this.handleConfigLoadFailure);
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         if(false == Boolean(param1.params.success))
         {
            DebugLog.instance.error("SmartFoxConnection.handleConnection(): failed to connect: " + param1.params.error);
            this.handleLoginResult(LoginResultType.CONNECTION_FAILURE);
            return;
         }
         this.loginToSmartFox();
      }
      
      private function loginToSmartFox() : void
      {
         DebugLog.instance.log("SmartFoxConnection.loginToSmartFox()");
         addEventListener(SFSEvent.onExtensionResponse,this.handleExtensionResponse);
         login(SFS_SERVER_ZONE,"n",this._gameServiceConnectionData.loginToken);
      }
      
      private function handleJoinRoom(param1:SFSEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(SFSEvent.onJoinRoom,this.handleJoinRoom);
         IEventDispatcher(param1.currentTarget).removeEventListener(SFSEvent.onJoinRoomError,this.handleJoinRoomError);
         this.handleLoginResult(LoginResultType.LOGIN_SUCCESS);
      }
      
      private function handleExitAdminMessageDialog(param1:Object) : void
      {
         this._commonDialogBox.kill();
      }
   }
}

class LoginStatusType
{
   
   internal static const LOGGING_IN:LoginStatusType = new LoginStatusType();
   
   internal static const LOGGED_IN:LoginStatusType = new LoginStatusType();
   
   internal static const OFFLINE:LoginStatusType = new LoginStatusType();
   
   private static var _isLocked:Boolean = false;
   
   _isLocked = true;
   
   public function LoginStatusType()
   {
      super();
      if(_isLocked)
      {
         throw new Error("Cannot instantiate enum \'LoginStatusType\'.");
      }
   }
}
