package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   
   internal class NewUserStatusDeterminator
   {
      
      private static const _NEW_USER_ACTIVITY_THRESHOLD:int = 7;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _handler:INewUserStatusDeterminatorHandler;
      
      private var _userProfile:IUserProfile;
      
      public function NewUserStatusDeterminator(param1:IServiceRequestBrokerManager, param2:IUserProfile)
      {
         super();
         _serviceRequestBrokerManager = param1;
         _userProfile = param2;
      }
      
      private function hasNotExceededActivityThreshold(param1:XML) : Boolean
      {
         var accountActivityXML:XML = param1;
         return accountActivityXML["activity-type"].(text() == "ACCOUNT_LOGIN").length() > _NEW_USER_ACTIVITY_THRESHOLD;
      }
      
      private function handleAccountActivityLoadComplete(param1:Event) : void
      {
         var xml:XML = null;
         var e:Event = param1;
         (e.currentTarget as IEventDispatcher).removeEventListener(Event.COMPLETE,handleAccountActivityLoadComplete);
         (e.currentTarget as IEventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR,handleAccountActivityLoadError);
         try
         {
            xml = new XML((e.currentTarget as URLLoader).data);
            handleNewUserStatusDetermined(hasNotExceededActivityThreshold(xml));
         }
         catch(e:Error)
         {
            _handler.handleNewUserStatusDeterminatorError("Account activity response XML was invalid.");
         }
      }
      
      private function handleAccountActivityLoadError(param1:IOErrorEvent) : void
      {
         (param1.currentTarget as IEventDispatcher).removeEventListener(Event.COMPLETE,handleAccountActivityLoadComplete);
         (param1.currentTarget as IEventDispatcher).removeEventListener(IOErrorEvent.IO_ERROR,handleAccountActivityLoadError);
         _handler.handleNewUserStatusDeterminatorError("Account activity response returned an error: " + param1.text);
      }
      
      private function handleNewUserStatusDetermined(param1:Boolean) : void
      {
         _handler.handleNewUserStatusDeterminatorComplete(param1);
      }
      
      public function determineNewUserStatus(param1:INewUserStatusDeterminatorHandler) : void
      {
         _handler = param1;
         if(!_userProfile.loaded)
         {
            return _handler.handleNewUserStatusDeterminatorError("UserProfile not loaded -- cannot determine new user status");
         }
         if(true == StoredSettingManager.getInstance().getSettingOrSetDefault(StoredSetting.HAS_SEEN_NEW_USER_EXPERIENCE + "_" + _userProfile.screenname,false))
         {
            return handleNewUserStatusDetermined(false);
         }
         if(_userProfile.gamesPlayed == 0)
         {
            return handleNewUserStatusDetermined(true);
         }
         if(_userProfile.nmp == 0)
         {
            return handleNewUserStatusDetermined(true);
         }
         _serviceRequestBrokerManager.requestAccountActivity(handleAccountActivityLoadComplete,handleAccountActivityLoadError);
      }
   }
}

