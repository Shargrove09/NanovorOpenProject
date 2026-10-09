package com.smithandtinker.smartfox
{
   import com.arkadium.communications.*;
   import com.arkadium.communications.handlers.*;
   import com.arkadium.communications.handlers.user.*;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   
   public class SmartFoxUserGameService extends AbstractSmartFoxGameService implements IUserGameService
   {
      
      private static const EXTENSION_NAME:String = "loginXt";
      
      private static const REQUEST_UPDATE_USER_TOKEN:String = "updateUserToken";
      
      private static const REQUEST_UPDATE_AVATAR:String = "updateAvatar";
      
      private static const REQUEST_GET_BUDDY_AVATAR:String = "getBuddyAvatar";
      
      private static const SERVER_UPDATED_AVATAR:String = "avatarUpdated";
      
      private static const SERVER_RESPONSE_BUDDY_AVATAR:String = "responseBuddyAvatar";
      
      private static const SERVER_BUDDY_AVATAR_DATA:String = "buddyAvatarData";
      
      private static const SERVER_FORCED_LOG_OUT:String = "forcedLogOut";
      
      private static const EXTENSION_RESPONSE_COMMAND_LOGIN_OK:String = "logOK";
      
      private static const REQUEST_UPDATE_NANOVOR_COUNT:String = "updateNanovorCount";
      
      private var _hasBeenForcedToLogOut:Boolean;
      
      private var _consumer:IGameServiceProviderInitConsumer;
      
      private var _applicationExiter:IApplicationExiter;
      
      public function SmartFoxUserGameService(param1:IUserProfile, param2:SmartFoxConnection, param3:IGameServiceProviderInitConsumer, param4:IApplicationExiter)
      {
         super(param1,param2,EXTENSION_NAME);
         _consumer = param3;
         _hasBeenForcedToLogOut = false;
         _applicationExiter = param4;
         _userProfile.setUserGameService(this);
      }
      
      override public function destroy() : void
      {
         _gameServiceConnection.removeEventListener(SFSEvent.onExtensionResponse,handleExtensionResponse);
         _gameServiceConnection.removeEventListener(SFSEvent.onConnectionLost,handleConnectionLost);
         removeAllHandlers(IAvatarUpdatedHandler);
         removeAllHandlers(IBuddyAvatarDataHandler);
         removeAllHandlers(IForcedLogOutHandler);
         super.destroy();
      }
      
      public function addBuddyAvatarDataHandler(param1:IBuddyAvatarDataHandler) : void
      {
         addHandler(IBuddyAvatarDataHandler,param1);
      }
      
      public function removeForcedLogOutHandler(param1:IForcedLogOutHandler) : void
      {
         removeHandler(IForcedLogOutHandler,param1);
      }
      
      private function handleUpdatedAvatar(param1:Object = null) : void
      {
         var _loc2_:IAvatarUpdatedHandler = null;
         for each(_loc2_ in _handlers[IAvatarUpdatedHandler])
         {
            if(null != _loc2_)
            {
               _loc2_.handleAvatarUpdated(param1);
            }
         }
      }
      
      public function addForcedLogOutHandler(param1:IForcedLogOutHandler) : void
      {
         addHandler(IForcedLogOutHandler,param1);
      }
      
      private function handleBuddyAvatarData(param1:Object = null) : void
      {
         var _loc2_:IBuddyAvatarDataHandler = null;
         for each(_loc2_ in _handlers[IBuddyAvatarDataHandler])
         {
            if(null != _loc2_)
            {
               log("handleBuddyAvatarData(userRefId == " + param1.userRefId + ", avatarId == " + param1.avatarId + ", nmp == " + param1.nmp + ")");
               _loc2_.handleBuddyAvatarData(param1);
            }
         }
      }
      
      public function addAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void
      {
         addHandler(IAvatarUpdatedHandler,param1);
      }
      
      public function updateNanovorCount() : void
      {
         sendRequestToServer(REQUEST_UPDATE_NANOVOR_COUNT,null);
      }
      
      override public function init(param1:IGameServiceInitializedHandler) : void
      {
         DebugLog.instance.log("SmartFoxUserGameService.init()");
         if(null == param1)
         {
            throw new Error("SmartFoxUserGameService.init(): Parameter \"handler\" cannot be null.");
         }
         _gameServiceConnection.addEventListener(SFSEvent.onExtensionResponse,handleExtensionResponse);
         _gameServiceConnection.addEventListener(SFSEvent.onConnectionLost,handleConnectionLost);
         super.init(param1);
      }
      
      public function getBuddyAvatar(param1:String) : void
      {
         log("getBuddyAvatar(userName == " + param1 + ")");
         sendRequestToServer(REQUEST_GET_BUDDY_AVATAR,{"name":param1});
      }
      
      public function updateAvatar(param1:int) : void
      {
         sendRequestToServer(REQUEST_UPDATE_AVATAR,{"avatarId":param1});
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SmartFoxUserGameService>> " + param1);
      }
      
      override public function handleLoginResult(param1:Object = null) : void
      {
         super.handleLoginResult(param1);
         if(LoginResultType.LOGIN_FAILURE == LoginResultType(param1.loginResultType))
         {
            _consumer.handleGameServicesInvalidLogin();
         }
      }
      
      public function removeBuddyAvatarDataHandler(param1:IBuddyAvatarDataHandler) : void
      {
         removeHandler(IBuddyAvatarDataHandler,param1);
      }
      
      private function handleExtensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:String = param1.params.type;
         var _loc3_:Object = param1.params.dataObj;
         var _loc4_:String = _loc3_._cmd;
         var _loc5_:Boolean = true;
         switch(_loc4_)
         {
            case EXTENSION_RESPONSE_COMMAND_LOGIN_OK:
               updateAvatar(_userProfile.avatarId);
               break;
            case SERVER_UPDATED_AVATAR:
               handleUpdatedAvatar(_loc3_);
               break;
            case SERVER_BUDDY_AVATAR_DATA:
            case SERVER_RESPONSE_BUDDY_AVATAR:
               handleBuddyAvatarData(_loc3_);
               break;
            case SERVER_FORCED_LOG_OUT:
               handleForcedLogOut(_loc3_);
               break;
            default:
               _loc5_ = false;
         }
         if(_loc5_)
         {
            log(">>SMF>><< handleExtensionResponse [" + EXTENSION_NAME + "]: found case for: " + _loc4_);
         }
      }
      
      private function handleForcedLogOut(param1:Object = null) : void
      {
         var _loc2_:IForcedLogOutHandler = null;
         log("handleForcedLogOut()");
         for each(_loc2_ in _handlers[IForcedLogOutHandler])
         {
            if(null != _loc2_)
            {
               _loc2_.handleForcedLogOut(param1);
            }
         }
         _hasBeenForcedToLogOut = true;
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Another Login","Your login has been used from another location.\nClick OK to close the game, then restart it.",0,handleAcceptQuit,handleAcceptQuit);
         EventManager.getInstance().dispatchEvent(new Event("CLIENT_DISCONNECTED"));
      }
      
      private function handleConnectionLost(param1:SFSEvent) : void
      {
         log("handleConnectionLost(): _hasBeenForcedToLogOut: " + _hasBeenForcedToLogOut);
         if(_hasBeenForcedToLogOut)
         {
            return;
         }
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Disconnected","You have been disconnected from the server.\nClick OK to close the game, then restart it.",0,handleAcceptQuit,handleAcceptQuit);
         EventManager.getInstance().dispatchEvent(new Event("CLIENT_DISCONNECTED"));
      }
      
      public function removeAvatarUpdatedHandler(param1:IAvatarUpdatedHandler) : void
      {
         removeHandler(IAvatarUpdatedHandler,param1);
      }
      
      override protected function createHandlersDictionary() : void
      {
         _handlers = new Dictionary();
         _handlers[IAvatarUpdatedHandler] = new Dictionary(true);
         _handlers[IBuddyAvatarDataHandler] = new Dictionary(true);
         _handlers[IForcedLogOutHandler] = new Dictionary(true);
      }
      
      public function updateUserToken(param1:String, param2:String) : void
      {
         log("updateUserToken(): userName: " + param1 + ", token: " + param2);
         sendRequestToServer(REQUEST_UPDATE_USER_TOKEN,{
            "username":param1.toLowerCase(),
            "token":param2
         });
      }
      
      private function handleAcceptQuit(param1:Object) : void
      {
         log("handleAcceptQuit()");
         _applicationExiter.exitApplication(true);
      }
   }
}

