package com.arkadium.communications
{
   import com.arkadium.virmon.device.ILoginTokenProvider;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class ServiceRequestBrokerManager extends EventDispatcher implements IServiceRequestBrokerManager, IStaticFileServiceURLProvider, ILoginTokenProvider, IVersionDataProvider
   {
      
      private static const VERSION_INI_URL:String = "version.INI";
      
      private static const CONNECTION_SETTINGS_URL:String = "Config/connection_settings.xml";
      
      private static const SYSTEM_SETTINGS_URL:String = "Config/LoginScreenConfig.xml";
      
      private static const TOKEN_REFRESH_TIMER_DELAY:Number = 1800000;
      
      private var _gameServerIP:String;
      
      private var _userProfile:IUserProfile;
      
      private var _serviceRequestBrokerParser:ServiceRequestBrokerParser;
      
      private var _majorVersion:String;
      
      private var _revision:String;
      
      private var _minorVersion:String;
      
      private var _tokenRefreshTimer:Timer;
      
      private var _userName:String;
      
      private var _buildVersion:String;
      
      public function ServiceRequestBrokerManager()
      {
         super();
      }
      
      public function getBuildVersion() : String
      {
         return _buildVersion;
      }
      
      public function getLoginToken() : String
      {
         return getServiceRequestBrokerValue(ServiceRequestBrokerValueType.LOGIN_TOKEN);
      }
      
      public function getRevision() : String
      {
         return _revision;
      }
      
      public function init() : void
      {
         log("init(): loading version.ini");
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,handleVersionINILoadComplete,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,handleVersionINILoadError,false,0,true);
         _loc1_.load(new URLRequest(VERSION_INI_URL));
      }
      
      public function getMinorVersion() : String
      {
         return _minorVersion;
      }
      
      private function handleVersionINILoadComplete(param1:Event) : void
      {
         log("handleVersionINILoadComplete()");
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleVersionINILoadError);
         var _loc3_:URLLoader = URLLoader(param1.target);
         var _loc4_:String = _loc3_.data;
         _loc4_ = _loc4_.split("\n").join("");
         var _loc5_:Array = _loc4_.split("\r");
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(String(_loc5_[_loc6_]).toLocaleLowerCase().indexOf("major") > -1)
            {
               _majorVersion = _loc5_[_loc6_].split("=")[1];
            }
            else if(String(_loc5_[_loc6_]).toLocaleLowerCase().indexOf("minor") > -1)
            {
               _minorVersion = _loc5_[_loc6_].split("=")[1];
            }
            else if(String(_loc5_[_loc6_]).toLocaleLowerCase().indexOf("build") > -1)
            {
               _buildVersion = _loc5_[_loc6_].split("=")[1];
            }
            else if(String(_loc5_[_loc6_]).toLocaleLowerCase().indexOf("revision") > -1)
            {
               _revision = _loc5_[_loc6_].split("=")[1];
            }
            _loc6_++;
         }
         log("handleVersionINI: " + _majorVersion + " " + _minorVersion + " " + _buildVersion + " " + _revision);
         _serviceRequestBrokerParser = new ServiceRequestBrokerParser(IVersionDataProvider(this));
         loadConnectionSettings();
      }
      
      public function get bankURL() : String
      {
         return encodeURI(defaultURLPrefixToHttp(_serviceRequestBrokerParser.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.BANK_URL)));
      }
      
      private function handleSystemSettingsLoadComplete(param1:Event) : void
      {
         log("handleSystemSettingsLoadComplete()");
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleSystemSettingsLoadError);
         _serviceRequestBrokerParser.parseSystemSettingsXml(new XML(param1.target.data));
         dispatchEvent(new ServiceRequestBrokerManagerEvent(ServiceRequestBrokerManagerEvent.INITIALIZED));
      }
      
      public function requestAccountStats(param1:Function, param2:Function) : void
      {
         log("requestAccountStats()");
         requestFromBank(bankURLRead,"/stat/account/","?auth=",param1,param2);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ServiceRequestBrokerManager: " + param1);
      }
      
      public function startTokenRefresh() : void
      {
         log("startTokenRefresh()");
         if(null == _tokenRefreshTimer)
         {
            _tokenRefreshTimer = new Timer(TOKEN_REFRESH_TIMER_DELAY);
            _tokenRefreshTimer.addEventListener(TimerEvent.TIMER,handleTokenRefreshTimer,false,0,true);
         }
         _tokenRefreshTimer.start();
      }
      
      private function handleSRBResponseLoadError(param1:IOErrorEvent) : void
      {
         logError("handleSRBResponseLoadError: " + param1.text);
         dispatchEvent(new ServiceRequestBrokerManagerEvent(ServiceRequestBrokerManagerEvent.ERROR));
      }
      
      private function loadConnectionSettings() : void
      {
         log("loadConnectionSettings()");
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,handleConnectionSettingsLoadComplete,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,handleConnectionSettingsLoadError,false,0,true);
         _loc1_.load(new URLRequest(CONNECTION_SETTINGS_URL));
      }
      
      private function handleSystemSettingsLoadError(param1:IOErrorEvent) : void
      {
         logError("handleSystemSettingsLoadError: " + param1.text);
         handleCorruptedSettingsFile();
      }
      
      private function requestFromBank(param1:String, param2:String, param3:String, param4:Function, param5:Function) : void
      {
         var _loc6_:String = getServiceRequestBrokerValue(ServiceRequestBrokerValueType.ACCOUNT_ID);
         var _loc7_:String = encodeURI(Utils.appendKillCache(param1 + param2 + _loc6_ + param3 + getLoginToken()));
         var _loc8_:URLLoader = new URLLoader();
         _loc8_.addEventListener(Event.COMPLETE,param4,false,0,true);
         _loc8_.addEventListener(IOErrorEvent.IO_ERROR,param5,false,0,true);
         var _loc9_:URLRequest = new URLRequest(_loc7_);
         _loc8_.load(_loc9_);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<ServiceRequestBrokerManager>> " + param1);
      }
      
      public function requestAssetBadges(param1:String, param2:Function, param3:Function) : void
      {
         log("requestAssetBadges()");
         var _loc4_:String = encodeURI(Utils.appendKillCache(bankURLRead + "/bankfe/resources/asset/" + param1 + "/badge?auth=" + getLoginToken()));
         var _loc5_:URLLoader = new URLLoader();
         _loc5_.addEventListener(Event.COMPLETE,param2,false,0,true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,param3,false,0,true);
         var _loc6_:URLRequest = new URLRequest(_loc4_);
         _loc5_.load(_loc6_);
      }
      
      public function getNanoCashURL(param1:String) : String
      {
         var _loc2_:String = defaultURLPrefixToHttp(_serviceRequestBrokerParser.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.NANOCASH_CARD_HOST_URL));
         return encodeURI(Utils.appendKillCache(_loc2_ + "/gftfe/giftCard/" + escape(param1) + "?auth=" + getLoginToken()));
      }
      
      public function getCouponURL(param1:String) : String
      {
         var _loc2_:String = defaultURLPrefixToHttp(_serviceRequestBrokerParser.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.COUPON_HOST_URL));
         return encodeURI(Utils.appendKillCache(_loc2_ + "/cpnfe/coupon/" + escape(param1) + "?auth=" + getLoginToken()));
      }
      
      public function loadServiceRequestBroker(param1:String, param2:String, param3:IUserProfile, param4:String) : void
      {
         log("loadServiceRequestBroker()");
         _gameServerIP = param4;
         _userName = param1;
         _userProfile = param3;
         _serviceRequestBrokerParser.setLoginCredentials(param1,param2);
         var _loc5_:String = encodeURI(Utils.appendKillCache(_serviceRequestBrokerParser.srbURL));
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         _loc6_.data = "<?xml version=\"1.0\"?>\n" + _serviceRequestBrokerParser.srbPostData;
         log("posting to " + _loc5_ + ":\nData:\n<?xml version=\"1.0\"?>\n" + _serviceRequestBrokerParser.debugSrbPostData);
         _loc6_.method = URLRequestMethod.POST;
         var _loc7_:URLLoader = new URLLoader();
         _loc7_.addEventListener(Event.COMPLETE,handleSRBResponseLoadComplete,false,0,true);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,handleSRBResponseLoadError,false,0,true);
         _loc7_.load(_loc6_);
      }
      
      public function get staticFileServiceURL() : String
      {
         return encodeURI(defaultURLPrefixToHttp(_serviceRequestBrokerParser.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.SFS_URL)));
      }
      
      private function handleTokenRefreshFailure(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleTokenRefreshSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleTokenRefreshFailure);
         logError("Token refresh failed. Another token refresh attempt will occur in 5 minutes.");
      }
      
      public function saveAccountInfo(param1:XML, param2:Function = null, param3:Function = null) : void
      {
         log("saveAccountInfo()");
         var _loc4_:String = getServiceRequestBrokerValue(ServiceRequestBrokerValueType.ACCOUNT_ID);
         var _loc5_:String = encodeURI(Utils.appendKillCache(bankURLRead + "/bankfe/resources/account/" + _loc4_ + "/profile?auth=" + getLoginToken()));
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         _loc6_.contentType = "application/xml";
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = param1;
         var _loc7_:URLLoader = new URLLoader();
         if(param2 != null)
         {
            _loc7_.addEventListener(Event.COMPLETE,param2,false,0,true);
         }
         if(param3 != null)
         {
            _loc7_.addEventListener(IOErrorEvent.IO_ERROR,param3,false,0,true);
         }
         _loc7_.load(_loc6_);
      }
      
      public function requestEvolveNanovor(param1:int, param2:String, param3:Array, param4:Function, param5:Function) : void
      {
         var _loc6_:String = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" + "<evolution-attempt xmlns=\"http://smithandtinker.com/backend/xsd/evolution/evolution-attempt.xsd\"><source-asset-id>" + param2 + "</source-asset-id>";
         var _loc7_:int = 0;
         while(_loc7_ < param3.length)
         {
            _loc6_ += "<em-asset-id>" + param3[_loc7_] + "</em-asset-id>";
            _loc7_++;
         }
         _loc6_ += "</evolution-attempt>";
         var _loc8_:URLRequest = new URLRequest(encodeURI(Utils.appendKillCache(bankURL + "/bankfe/resources/evolution/" + param1 + "?auth=" + getLoginToken())));
         log("EVOURL " + _loc8_.url);
         _loc8_.contentType = "application/xml";
         _loc8_.method = URLRequestMethod.POST;
         _loc8_.data = new XML(_loc6_);
         var _loc9_:URLLoader = new URLLoader();
         _loc9_.addEventListener(Event.COMPLETE,param4,false,0,true);
         _loc9_.addEventListener(IOErrorEvent.IO_ERROR,param5,false,0,true);
         _loc9_.load(_loc8_);
      }
      
      private function handleConnectionSettingsLoadComplete(param1:Event) : void
      {
         log("handleConnectionSettingsLoadComplete()");
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleConnectionSettingsLoadError);
         _serviceRequestBrokerParser.parseConnectionSettings(new XML(param1.target.data));
         loadSystemSettings();
      }
      
      public function getGameServicePort() : int
      {
         return _serviceRequestBrokerParser.gameServicePort;
      }
      
      public function get bankURLRead() : String
      {
         if(_serviceRequestBrokerParser.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.BANK_URL_READ) == null)
         {
            return encodeURI(defaultURLPrefixToHttp(_serviceRequestBrokerParser.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.BANK_URL)));
         }
         return encodeURI(defaultURLPrefixToHttp(_serviceRequestBrokerParser.getServiceRequestBrokerValue(ServiceRequestBrokerValueType.BANK_URL_READ)));
      }
      
      private function handleTokenRefreshSuccess(param1:Event) : void
      {
         log("handleTokenRefreshSuccess()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleTokenRefreshSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleTokenRefreshFailure);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         GameServiceProvider.getInstance().userGameService.updateUserToken(_userName.toLowerCase(),String(_loc2_.child("token")[0]));
         _serviceRequestBrokerParser.updateLoginToken(String(_loc2_.child("token")[0]));
      }
      
      public function stopTokenRefresh() : void
      {
         log("stopTokenRefresh()");
         _tokenRefreshTimer.stop();
      }
      
      public function requestAccountActivity(param1:Function, param2:Function) : void
      {
         log("requestAccountActivity()");
         requestFromBank(bankURLRead,"/bankfe/resources/account/","/account-activity?auth=",param1,param2);
      }
      
      public function getAssetListURL() : String
      {
         var _loc1_:String = getServiceRequestBrokerValue(ServiceRequestBrokerValueType.ACCOUNT_ID);
         return encodeURI(Utils.appendKillCache(bankURLRead + "/bankfe/resources/account/" + _loc1_ + "/asset?auth=" + getLoginToken()));
      }
      
      private function handleConnectionSettingsLoadError(param1:IOErrorEvent) : void
      {
         logError("handleConnectionSettingsLoadError: " + param1.text);
         handleCorruptedSettingsFile();
      }
      
      private function handleSRBResponseLoadComplete(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleSRBResponseLoadError);
         var _loc3_:XML = XML(param1.target.data);
         log("handleSRBResponseLoadComplete():\n " + _loc3_);
         _serviceRequestBrokerParser.parseSRBResponse(_loc3_);
         handleSRBResponse(_serviceRequestBrokerParser.getActionType(),_loc3_.params.param.value.array.data.value);
      }
      
      public function getAccountID() : String
      {
         return getServiceRequestBrokerValue(ServiceRequestBrokerValueType.ACCOUNT_ID);
      }
      
      private function defaultURLPrefixToHttp(param1:String) : String
      {
         if(param1 == null || param1 == "")
         {
            return param1;
         }
         return param1.search(/^https?:/) == -1 ? "http://" + param1 : param1;
      }
      
      public function requestJoltSpendOnNanovor(param1:IVirmonData, param2:Object, param3:Function, param4:Function) : void
      {
         var _loc5_:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "<jolt-spend xmlns=\"http://smithandtinker.com/backend/stat/xsd/jolt-spend.xsd\">" + "  <armor-delta>" + param2.armor + "</armor-delta>" + "  <health-delta>" + param2.health + "</health-delta>" + "  <speed-delta>" + param2.speed + "</speed-delta>" + "  <strength-delta>" + param2.strength + "</strength-delta>" + "</jolt-spend>";
         log("requestJoltSpendOnNanovor() xml: " + _loc5_);
         var _loc6_:URLRequest = new URLRequest(encodeURI(Utils.appendKillCache(bankURL + "/bankfe/resources/asset/" + param1.getAssetID() + "/jolt?auth=" + getLoginToken())));
         _loc6_.contentType = "application/xml";
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = new XML(_loc5_);
         var _loc7_:URLLoader = new URLLoader();
         _loc7_.addEventListener(Event.COMPLETE,param3,false,0,true);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,param4,false,0,true);
         _loc7_.load(_loc6_);
      }
      
      private function handleCorruptedSettingsFile() : void
      {
         dispatchEvent(new ServiceRequestBrokerManagerEvent(ServiceRequestBrokerManagerEvent.CORRUPTED_SETTINGS_FILE));
      }
      
      public function requestShardData(param1:Function, param2:Function) : void
      {
         var _loc3_:String = Utils.appendKillCache(_serviceRequestBrokerParser.shardListURL);
         var _loc4_:URLLoader = new URLLoader();
         _loc4_.addEventListener(Event.COMPLETE,param1,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,param2,false,0,true);
         _loc4_.load(new URLRequest(_loc3_));
      }
      
      public function requestAccountInfo(param1:Function, param2:Function) : void
      {
         log("requestAccountInfo()");
         requestFromBank(bankURLRead,"/bankfe/resources/account/","?auth=",param1,param2);
      }
      
      public function getMajorVersion() : String
      {
         return _majorVersion;
      }
      
      private function handleVersionINILoadError(param1:IOErrorEvent) : void
      {
         handleCorruptedSettingsFile();
      }
      
      public function getServiceRequestBrokerValue(param1:ServiceRequestBrokerValueType) : String
      {
         if(param1 == ServiceRequestBrokerValueType.GAME_SERVICE_IP)
         {
            if(null != _gameServerIP)
            {
               return _gameServerIP;
            }
         }
         return _serviceRequestBrokerParser.getServiceRequestBrokerValue(param1);
      }
      
      public function requestAccountBadges(param1:Function, param2:Function) : void
      {
         log("requestAccountBadges()");
         requestFromBank(bankURL,"/bankfe/resources/account/","/badge?auth=",param1,param2);
      }
      
      public function get isCheckForNanocashEnabled() : Boolean
      {
         return _serviceRequestBrokerParser.isCheckForNanocashEnabled;
      }
      
      private function loadSystemSettings() : void
      {
         log("loadSystemSettings()");
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,handleSystemSettingsLoadComplete,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,handleSystemSettingsLoadError,false,0,true);
         _loc1_.load(new URLRequest(SYSTEM_SETTINGS_URL));
      }
      
      private function handleTokenRefreshTimer(param1:TimerEvent) : void
      {
         log("handleTokenRefreshTimer()");
         var _loc2_:String = encodeURI(Utils.appendKillCache(bankURL + "/bankfe/resources/account/refresh-login?auth=" + getLoginToken()));
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,handleTokenRefreshSuccess,false,0,true);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,handleTokenRefreshFailure,false,0,true);
         var _loc4_:URLRequest = new URLRequest(_loc2_);
         _loc4_.contentType = "application/xml";
         _loc4_.method = URLRequestMethod.POST;
         _loc4_.data = <empty/>;
         _loc3_.load(_loc4_);
      }
      
      private function handleSRBResponse(param1:ActionType, param2:String) : void
      {
         switch(param1)
         {
            case ActionType.CONNECT:
               _userProfile.setId(int(getServiceRequestBrokerValue(ServiceRequestBrokerValueType.ACCOUNT_ID)));
               dispatchEvent(new ServiceRequestBrokerManagerEvent(ServiceRequestBrokerManagerEvent.COMPLETE));
               break;
            case ActionType.REFRESH:
               dispatchEvent(new ServiceRequestBrokerManagerEvent(ServiceRequestBrokerManagerEvent.REFRESH));
               break;
            case ActionType.MAINTENANCE:
               dispatchEvent(new ServiceRequestBrokerManagerEvent(ServiceRequestBrokerManagerEvent.MAINTENANCE));
               break;
            default:
               dispatchEvent(new ServiceRequestBrokerManagerEvent(ServiceRequestBrokerManagerEvent.NO_ACTION,param2));
         }
      }
   }
}

