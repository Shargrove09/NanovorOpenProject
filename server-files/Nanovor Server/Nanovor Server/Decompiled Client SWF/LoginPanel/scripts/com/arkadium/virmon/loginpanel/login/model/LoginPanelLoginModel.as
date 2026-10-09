package com.arkadium.virmon.loginpanel.login.model
{
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.arkadium.virmon.loginpanel.ILoginPanelConsumer;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginEligible;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginError;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginShardInitializer;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginStatusMessageHandler;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginUsernameAutoFill;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginVersionReceived;
   import com.arkadium.virmon.wrapper.view.ILoginSubmitHandler;
   import flash.utils.Dictionary;
   
   public class LoginPanelLoginModel implements ILoginPanelLoginModel
   {
      
      private var _currentGameServerIP:String;
      
      private var _srbInitialized:Boolean;
      
      private var _shardList:Array;
      
      private var _currentUsername:String;
      
      private var _loginSubmitHandler:ILoginSubmitHandler;
      
      private var _handlers:Dictionary;
      
      private var _consumer:ILoginPanelConsumer;
      
      private var _currentlyLoggingIn:Boolean;
      
      private var _rememberCredentials:Boolean;
      
      private var _currentPassword:String;
      
      public function LoginPanelLoginModel()
      {
         super();
         this._currentlyLoggingIn = false;
         this._srbInitialized = false;
         this._handlers = new Dictionary();
         this._handlers[ILoginEligible] = new Dictionary(true);
         this._handlers[ILoginUsernameAutoFill] = new Dictionary(true);
         this._handlers[ILoginError] = new Dictionary(true);
         this._handlers[ILoginVersionReceived] = new Dictionary(true);
         this._handlers[ILoginShardInitializer] = new Dictionary(true);
         this._handlers[ILoginStatusMessageHandler] = new Dictionary(true);
      }
      
      public function addLoginStatusUpdateHandler(param1:ILoginStatusMessageHandler) : void
      {
         this._handlers[ILoginStatusMessageHandler][param1] = param1;
      }
      
      public function addLoginErrorHandler(param1:ILoginError) : void
      {
         this._handlers[ILoginError][param1] = param1;
      }
      
      public function addLoginEligibleHandler(param1:ILoginEligible) : void
      {
         this._handlers[ILoginEligible][param1] = param1;
      }
      
      public function addLoginShardInitializer(param1:ILoginShardInitializer) : void
      {
         this._handlers[ILoginShardInitializer][param1] = param1;
      }
      
      public function init(param1:ILoginSubmitHandler, param2:ILoginPanelConsumer) : void
      {
         var _loc5_:ILoginUsernameAutoFill = null;
         this._loginSubmitHandler = param1;
         this._consumer = param2;
         var _loc3_:String = StoredSettingManager.getInstance().getSetting(StoredSetting.LOGIN_USERNAME);
         var _loc4_:String = StoredSettingManager.getInstance().getSetting(StoredSetting.LOGIN_PASSWORD);
         if(null != _loc3_ && "" != _loc3_ && null != _loc4_ && "" != _loc4_)
         {
            this._currentUsername = _loc3_;
            this._currentPassword = _loc4_;
            for each(_loc5_ in this._handlers[ILoginUsernameAutoFill])
            {
               _loc5_.handleLoginUsernameAutoFill(_loc3_,_loc4_);
            }
         }
      }
      
      public function addLoginVersionReceivedHandler(param1:ILoginVersionReceived) : void
      {
         this._handlers[ILoginVersionReceived][param1] = param1;
      }
      
      public function addLoginUsernameAutoFillhandler(param1:ILoginUsernameAutoFill) : void
      {
         this._handlers[ILoginUsernameAutoFill][param1] = param1;
      }
      
      public function get password() : String
      {
         return this._currentPassword;
      }
      
      public function attemptLogin(param1:String, param2:String, param3:Boolean) : void
      {
         var _loc4_:ILoginEligible = null;
         this._currentUsername = param1;
         this._currentPassword = param2;
         this._rememberCredentials = param3;
         for each(_loc4_ in this._handlers[ILoginEligible])
         {
            _loc4_.handleLoginEligible(false);
         }
         this.setStatusMessage("Logging In...");
         this._currentlyLoggingIn = true;
         this._loginSubmitHandler.handleLoginSubmit(param1,param2,this.gameServerIP);
      }
      
      public function setVersion(param1:String) : void
      {
         var _loc2_:ILoginVersionReceived = null;
         for each(_loc2_ in this._handlers[ILoginVersionReceived])
         {
            _loc2_.handleLoginVersionReceived(param1);
         }
      }
      
      public function handleSRBConnected() : void
      {
         var _loc1_:String = this._rememberCredentials ? this._currentUsername : "";
         var _loc2_:String = this._rememberCredentials ? this._currentPassword : "";
         StoredSettingManager.getInstance().storeSetting(StoredSetting.LOGIN_USERNAME,_loc1_);
         StoredSettingManager.getInstance().storeSetting(StoredSetting.LOGIN_PASSWORD,_loc2_);
         StoredSettingManager.getInstance().saveSettingsToDisk();
      }
      
      public function handleSRBInitialized() : void
      {
         this._srbInitialized = true;
      }
      
      public function updateLoginCredentials(param1:String, param2:String) : void
      {
         var _loc4_:ILoginEligible = null;
         var _loc3_:Boolean = this.checkIfEligibleForLogin(param1,param2);
         for each(_loc4_ in this._handlers[ILoginEligible])
         {
            _loc4_.handleLoginEligible(_loc3_);
         }
      }
      
      public function handleSuccessfullLogin() : void
      {
      }
      
      public function addLoginVersionHandler(param1:ILoginVersionReceived) : void
      {
         this._handlers[ILoginVersionReceived][param1] = param1;
      }
      
      public function updateShardIndex(param1:int) : void
      {
         if(null == this._shardList)
         {
            return;
         }
         if(null == this._shardList[param1])
         {
            return;
         }
         this._currentGameServerIP = this._shardList[param1].url;
         StoredSettingManager.getInstance().storeSettingAndSave(StoredSetting.SHARD_NAME,this._shardList[param1].name);
      }
      
      public function get gameServerIP() : String
      {
         return this._currentGameServerIP;
      }
      
      public function get username() : String
      {
         return this._currentUsername;
      }
      
      public function autoFillUserName(param1:String) : void
      {
      }
      
      public function handleGotoForgotPassword() : void
      {
         if(null != this._consumer)
         {
            this._consumer.handleForgotPassword();
         }
      }
      
      public function initializeShardList(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc7_:ILoginShardInitializer = null;
         var _loc8_:Boolean = false;
         var _loc9_:ILoginEligible = null;
         var _loc10_:Object = null;
         this._shardList = param1;
         var _loc2_:Array = new Array();
         var _loc4_:int = 0;
         var _loc5_:String = StoredSettingManager.getInstance().getSetting(StoredSetting.SHARD_NAME);
         var _loc6_:int = 0;
         while(_loc6_ < this._shardList.length)
         {
            _loc3_ = this._shardList[_loc6_] as Object;
            _loc10_ = new Object();
            _loc10_.name = _loc3_.population;
            _loc10_.full = _loc3_.full;
            _loc2_.push(_loc10_);
            if(_loc5_ == _loc3_.name && !_loc3_.full)
            {
               _loc4_ = _loc6_;
            }
            _loc6_++;
         }
         for each(_loc7_ in this._handlers[ILoginShardInitializer])
         {
            _loc7_.handleShardDropDownMenuReceived(_loc2_,_loc4_);
         }
         this.updateShardIndex(_loc4_);
         _loc8_ = this.checkIfEligibleForLogin();
         for each(_loc9_ in this._handlers[ILoginEligible])
         {
            _loc9_.handleLoginEligible(_loc8_);
         }
      }
      
      public function setStatusMessage(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:ILoginStatusMessageHandler = null;
         for each(_loc3_ in this._handlers[ILoginStatusMessageHandler])
         {
            _loc3_.handleUpdateStatusMessage(param1,param2);
         }
      }
      
      public function handleLoginError() : void
      {
         var _loc1_:ILoginError = null;
         this._currentlyLoggingIn = false;
         for each(_loc1_ in this._handlers[ILoginError])
         {
            _loc1_.handleLoginError();
         }
      }
      
      public function handleGotoNewAccount() : void
      {
         if(null != this._consumer)
         {
            this._consumer.handleNewAccount();
         }
      }
      
      private function checkIfEligibleForLogin(param1:String = null, param2:String = null) : Boolean
      {
         var _loc3_:String = null == param1 ? this._currentUsername : param1;
         var _loc4_:String = null == param2 ? this._currentPassword : param2;
         if(null == _loc3_ || "" == _loc3_)
         {
            return false;
         }
         if(null == _loc4_ || "" == _loc4_)
         {
            return false;
         }
         if(null == this._currentGameServerIP)
         {
            return false;
         }
         if(!this._srbInitialized)
         {
            return false;
         }
         if(this._currentlyLoggingIn)
         {
            return false;
         }
         return true;
      }
   }
}

