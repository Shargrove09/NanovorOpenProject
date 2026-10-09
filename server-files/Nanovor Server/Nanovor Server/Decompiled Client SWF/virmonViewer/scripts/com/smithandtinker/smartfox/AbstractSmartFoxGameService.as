package com.smithandtinker.smartfox
{
   import com.arkadium.communications.AbstractGameService;
   import com.arkadium.communications.IUserProfile;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import it.gotoandplay.smartfoxserver.SmartFoxClient;
   
   public class AbstractSmartFoxGameService extends AbstractGameService
   {
      
      private var _extensionName:String;
      
      protected var _userProfile:IUserProfile;
      
      public function AbstractSmartFoxGameService(param1:IUserProfile, param2:SmartFoxConnection, param3:String)
      {
         super(param2);
         _userProfile = param1;
         if(false == _gameServiceConnection is SmartFoxConnection)
         {
            throw new Error("Member \'_gameServiceConnection\' must be of type SmartFoxConnection.");
         }
         _extensionName = param3;
      }
      
      protected function sendRequestToServer(param1:String, param2:*) : void
      {
         DebugLog.instance.log(">>SMF>>>> ASFGS:sendRequestToServer [" + _extensionName + "]: " + param1 + "\nparamObj=" + Utils.ObjectToString(param2));
         SmartFoxConnection(_gameServiceConnection).sendXtMessage(_extensionName,param1,param2,SmartFoxClient.XTMSG_TYPE_JSON);
      }
      
      override public function get isConnected() : Boolean
      {
         return SmartFoxClient(_gameServiceConnection).isConnected;
      }
   }
}

