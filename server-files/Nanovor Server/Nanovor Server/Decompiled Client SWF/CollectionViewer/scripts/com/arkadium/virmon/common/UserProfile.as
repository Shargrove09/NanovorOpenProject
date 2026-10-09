package com.arkadium.virmon.common
{
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.shared.breadcrumb.BreadcrumbType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.URLLoader;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class UserProfile extends EventDispatcher implements IUserProfile, IChainLoadee
   {
      
      private static var _oInstance:UserProfile;
      
      private static const NAME:String = "UserProfile";
      
      private var _ems:int;
      
      private var _fourPlayerGames:int;
      
      private var _speedJolts:int;
      
      private var _armorJolts:int;
      
      private var _stateInfoReceivedError:Boolean = false;
      
      private var _isLoaded:Boolean = false;
      
      private var _stateStatsReceived:Boolean = false;
      
      private var _threePlayerGames:int;
      
      private var _gamesPlayed:int;
      
      private var _nanocash:int;
      
      private var _nanovorCount:int;
      
      private var _magnamodKills:int;
      
      private var _userGameService:IUserGameService;
      
      private var _stateInfoReceived:Boolean = false;
      
      private var _velocitronKills:int;
      
      private var _chainLoader:IChainLoader;
      
      private var _nanovorCountUnique:int;
      
      private var _gamesWon:int;
      
      private var _battleCount:int = 0;
      
      private var _stateStatsReceivedError:Boolean = false;
      
      private var _stateEMDataReceived:Boolean = false;
      
      private var _oldSafeAvatarId:int;
      
      private var _tmrEMDataHack:Timer;
      
      private var _twoPlayerGames:int;
      
      private var _breadcrumbCount:int = 0;
      
      private var _totalKills:int;
      
      private var _memberHistory:Number;
      
      private var _screenname:String = null;
      
      private var _email:String;
      
      private var _avatarId:int;
      
      private var _hexiteKills:int;
      
      private var _id:int;
      
      private var _accountInfoXML:XML;
      
      private var _sPhoneNumber:String;
      
      private var _strengthJolts:int;
      
      private var _handlers:Dictionary;
      
      private var _healthJolts:int;
      
      private var _nmp:int;
      
      public function UserProfile()
      {
         super();
         _handlers = new Dictionary();
         _handlers[IUserProfileLoadCompleteHandler] = new Dictionary(true);
         EventManager.getInstance().addEventListener("NANOCASH_BALANCE_CHANGE",updateNanocashBalance,false,0,true);
      }
      
      public static function clearInstance() : void
      {
         _oInstance = null;
      }
      
      public static function getInstance() : UserProfile
      {
         if(!UserProfile._oInstance)
         {
            _oInstance = new UserProfile();
         }
         return UserProfile._oInstance;
      }
      
      public function getBattleCount() : int
      {
         _battleCount = Managers.storedSettingsManager.getSettingOrSetDefault(StoredSetting.BATTLE_COUNT,0);
         return _battleCount;
      }
      
      public function get loaded() : Boolean
      {
         return isLoaded();
      }
      
      private function nanocashBalanceUpdated(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,nanocashBalanceUpdateFailed);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,nanocashBalanceUpdated);
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = new XML(_loc2_);
         _loc3_ = Utils.StripXmlNamespace(_loc3_);
         if(_loc3_.name().localName == "error")
         {
            _stateInfoReceivedError = true;
            error("accountInfoReceived FAIL - Error returned in XML: \n" + "      type: " + _loc3_.type + "\n" + "      message: " + _loc3_.message);
         }
         else
         {
            _nanocash = _loc3_.child("token-balance");
            EventManager.getInstance().dispatchEvent(new Event("NANOCASH_BALANCE_UPDATED"));
         }
      }
      
      private function checkReceived() : void
      {
         var _loc1_:IUserProfileLoadCompleteHandler = null;
         if(_stateInfoReceived && _stateStatsReceived && _stateEMDataReceived)
         {
            if(_stateInfoReceivedError || _stateStatsReceivedError)
            {
               if(_chainLoader != null)
               {
                  _chainLoader.handleChainLoadeeError();
               }
               _chainLoader = null;
               dispatchEvent(new Event(UserProfileEvent.LOAD_ERROR_EVENT));
            }
            else
            {
               log("UserProfile.checkReceived(): load complete!");
               if(_chainLoader != null)
               {
                  _chainLoader.handleChainLoadeeComplete(this as IUserProfile);
               }
               _chainLoader = null;
               dispatchEvent(new Event(UserProfileEvent.LOAD_COMPLETE_EVENT));
               for each(_loc1_ in _handlers[IUserProfileLoadCompleteHandler])
               {
                  _loc1_.handleUserProfileLoadComplete();
               }
               _isLoaded = true;
            }
         }
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error(">> UserProfile: " + param1);
      }
      
      public function get gamesWon() : int
      {
         return _gamesWon;
      }
      
      public function get gamesPlayed() : int
      {
         return _gamesPlayed;
      }
      
      public function retrieveProfileData(param1:Boolean = false) : void
      {
         var _loc2_:IUserProfileLoadCompleteHandler = null;
         if(!param1 && loaded)
         {
            dispatchEvent(new Event(UserProfileEvent.LOAD_COMPLETE_EVENT));
            for each(_loc2_ in _handlers[IUserProfileLoadCompleteHandler])
            {
               _loc2_.handleUserProfileLoadComplete();
            }
            return;
         }
         _stateInfoReceived = _stateStatsReceived = _stateInfoReceivedError = _stateStatsReceivedError = _stateEMDataReceived = false;
         _tmrEMDataHack = new Timer(15);
         _tmrEMDataHack.addEventListener(TimerEvent.TIMER,onTimerDataHackTick,false,0,true);
         if(DataManager.getInstance().getEMManager().getEMDataList() !== null)
         {
            onTimerDataHackTick(null);
         }
         else
         {
            _tmrEMDataHack.start();
         }
         _memberHistory = calculateMemberHistory();
         retrieveNanovorCounts();
         Managers.serviceRequestBrokerManager.requestAccountInfo(accountInfoReceived,accountInfoFailed);
      }
      
      public function setId(param1:int) : void
      {
         _id = param1;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      private function onSaveAccountInfoSuccess(param1:Event) : void
      {
         URLLoader(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,onSaveAccountInfoError);
         URLLoader(param1.target).removeEventListener(Event.COMPLETE,onSaveAccountInfoSuccess);
         EventManager.getInstance().dispatchEvent(new Event(FrameWorkEvent.USER_STATS_UPDATED));
         _userGameService.updateAvatar(_avatarId);
      }
      
      public function get magnamodKills() : int
      {
         return _magnamodKills;
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> UserProfile: " + param1);
      }
      
      private function accountStatsFailed(param1:IOErrorEvent) : *
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,accountStatsReceived);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,accountStatsFailed);
         error("ACCOUNT STATS FAILED");
      }
      
      public function setJolts(param1:int, param2:int, param3:int, param4:int) : void
      {
         _healthJolts = param1;
         _armorJolts = param2;
         _strengthJolts = param4;
         _speedJolts = param3;
      }
      
      public function get avatarId() : int
      {
         return _avatarId;
      }
      
      public function get phoneNumber() : String
      {
         return _sPhoneNumber;
      }
      
      public function get fourPlayerGames() : int
      {
         return _fourPlayerGames;
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> UserProfile: " + param1);
      }
      
      private function onSaveAccountInfoError(param1:IOErrorEvent) : void
      {
         URLLoader(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,onSaveAccountInfoError);
         URLLoader(param1.target).removeEventListener(Event.COMPLETE,onSaveAccountInfoSuccess);
         _avatarId = _oldSafeAvatarId;
         error("++++++ onSaveAccountInfoError: " + param1.text);
      }
      
      private function retrieveNanovorCounts() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = DataManager.getInstance().getVirmonManager().getVirmonDataList();
         _nanovorCount = _loc1_.length;
         var _loc2_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc3_ = int((_loc1_[_loc4_] as IVirmonData).getAssetTypeID());
            if(_loc2_.indexOf(_loc3_) == -1)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         _nanovorCountUnique = _loc2_.length;
      }
      
      public function removeUserProfileLoadCompleteHandler(param1:IUserProfileLoadCompleteHandler) : void
      {
         delete _handlers[IUserProfileLoadCompleteHandler][param1];
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function accountStatsReceived(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,accountStatsReceived);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,accountStatsFailed);
         log("accountStatsReceived()");
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = new XML(_loc2_);
         _loc3_ = Utils.StripXmlNamespace(_loc3_);
         if(_loc3_.name().localName == "error")
         {
            _stateStatsReceivedError = true;
            error("accountStatsReceived FAIL - Error returned in XML: \n" + "      type: " + _loc3_.type + "\n" + "      message: " + _loc3_.message);
         }
         else
         {
            _nmp = _loc3_.child("virmon-master-rating");
            _totalKills = _loc3_.child("kill-count");
            _gamesPlayed = _loc3_.child("game-count");
            _gamesWon = _loc3_.child("win-count");
            _twoPlayerGames = _loc3_.child("two-player-game-count");
            _threePlayerGames = _loc3_.child("three-player-game-count");
            _fourPlayerGames = _loc3_.child("four-player-game-count");
            _hexiteKills = _loc3_.child("hexite-kill-count");
            _magnamodKills = _loc3_.child("magnamod-kill-count");
            _velocitronKills = _loc3_.child("virmon-master-rating");
         }
         _stateStatsReceived = true;
         checkReceived();
      }
      
      private function accountInfoReceived(param1:Event) : void
      {
         log("accountInfoReceived()");
         var _loc2_:String = String(param1.target.data);
         _accountInfoXML = new XML(_loc2_);
         _accountInfoXML = Utils.StripXmlNamespace(_accountInfoXML);
         if(_accountInfoXML.name().localName == "error")
         {
            _stateInfoReceivedError = true;
            error("accountInfoReceived FAIL - Error returned in XML: \n" + "      type: " + _accountInfoXML.type + "\n" + "      message: " + _accountInfoXML.message);
         }
         else
         {
            _screenname = String(_accountInfoXML.username).toLowerCase();
            _email = _accountInfoXML.child("email-address");
            _nanocash = _accountInfoXML.child("token-balance");
            _avatarId = _accountInfoXML.child("avatar-id");
            _sPhoneNumber = _accountInfoXML.child("phone-number");
            _healthJolts = _accountInfoXML.child("jolt_health_balance");
            _armorJolts = _accountInfoXML.child("jolt_armor_balance");
            _strengthJolts = _accountInfoXML.child("jolt_strength_balance");
            _speedJolts = _accountInfoXML.child("jolt_speed_balance");
         }
         _stateInfoReceived = true;
         Managers.serviceRequestBrokerManager.requestAccountStats(accountStatsReceived,accountStatsFailed);
      }
      
      public function resetBreadcrumbCount() : void
      {
         log("updating breadcrumb count");
         Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.BREADCRUMB_COUNT,0);
      }
      
      public function get armorJolts() : int
      {
         return _armorJolts;
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      private function accountInfoFailed(param1:IOErrorEvent) : *
      {
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,accountInfoFailed);
         error("GET ACCOUNT INFO FAILED");
         dispatchEvent(new Event(UserProfileEvent.LOAD_ERROR_EVENT));
      }
      
      public function get healthJolts() : int
      {
         return _healthJolts;
      }
      
      public function updateAvatar(param1:int) : void
      {
         _oldSafeAvatarId = _avatarId;
         _avatarId = param1;
         saveAccoutInfo();
      }
      
      public function get accountInfoXML() : XML
      {
         return _accountInfoXML;
      }
      
      public function get nmp() : int
      {
         return _nmp;
      }
      
      public function get memberHistory() : Number
      {
         return _memberHistory;
      }
      
      public function getBreadcrumbCount() : int
      {
         var _loc1_:int = Managers.storedSettingsManager.getSettingOrSetDefault(StoredSetting.BREADCRUMB_COUNT,0);
         _breadcrumbCount = Math.min(_loc1_,BreadcrumbType.breadcrumbTypes.length - 1);
         log("getBreadcrumbCount: returning " + _breadcrumbCount + ", length of breadcrumbTypes=" + BreadcrumbType.breadcrumbTypes.length);
         return _breadcrumbCount;
      }
      
      public function get velocitronKills() : int
      {
         return _velocitronKills;
      }
      
      public function get speedJolts() : int
      {
         return _speedJolts;
      }
      
      public function updateBattleCount() : void
      {
         ++_battleCount;
         log("updating battle count: " + _battleCount);
         Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.BATTLE_COUNT,_battleCount);
      }
      
      public function get hexiteKills() : int
      {
         return _hexiteKills;
      }
      
      public function get nanovorCount() : int
      {
         return _nanovorCount;
      }
      
      public function get email() : String
      {
         return _email;
      }
      
      public function get strengthJolts() : int
      {
         return _strengthJolts;
      }
      
      public function updateBreadcrumbCount(param1:int = 0) : void
      {
         if(param1 == _breadcrumbCount)
         {
            ++_breadcrumbCount;
            log("updated breadcrumb count: " + _breadcrumbCount);
            Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.BREADCRUMB_COUNT,_breadcrumbCount);
         }
         else
         {
            log("not updating breadcrumb due to insufficient index: " + param1 + ", _breadcrumbCount: " + _breadcrumbCount);
         }
      }
      
      public function get breadcrumbCount() : int
      {
         return _breadcrumbCount;
      }
      
      public function addUserProfileLoadCompleteHandler(param1:IUserProfileLoadCompleteHandler) : void
      {
         _handlers[IUserProfileLoadCompleteHandler][param1] = param1;
      }
      
      private function isLoaded() : Boolean
      {
         return _isLoaded;
      }
      
      private function calculateMemberHistory() : Number
      {
         var _loc4_:String = null;
         var _loc1_:Number = Number.MAX_VALUE;
         var _loc2_:Array = DataManager.getInstance().getVirmonManager().getVirmonDataList();
         var _loc3_:RegExp = /-/gi;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc4_ = (_loc2_[_loc5_] as IVirmonData).getBirthDate().replace(_loc3_,"/");
            if(Date.parse(_loc4_) < _loc1_)
            {
               _loc1_ = Date.parse(_loc4_);
            }
            _loc5_++;
         }
         if(_loc1_ == Number.MAX_VALUE)
         {
            return -1;
         }
         var _loc6_:Date = new Date();
         return _loc6_.getTime() - _loc1_;
      }
      
      public function setUserGameService(param1:IUserGameService) : void
      {
         _userGameService = param1;
      }
      
      public function get twoPlayerGames() : int
      {
         return _twoPlayerGames;
      }
      
      private function saveAccoutInfo() : void
      {
         var _loc1_:Boolean = _sPhoneNumber === null || _sPhoneNumber == "";
         var _loc2_:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<account-profile xmlns=\"http://smithandtinker.com/backend/xsd/account/account-profile.xsd\">\n" + (_loc1_ ? "" : "\t<phone-number>" + _sPhoneNumber + "</phone-number>\n") + "\t<avatar-id>" + _avatarId + "</avatar-id>\n" + "</account-profile>";
         Managers.serviceRequestBrokerManager.saveAccountInfo(XML(_loc2_),onSaveAccountInfoSuccess,onSaveAccountInfoError);
      }
      
      public function get ems() : int
      {
         return _ems;
      }
      
      public function load() : void
      {
         retrieveProfileData(true);
      }
      
      public function get nanocash() : int
      {
         return _nanocash;
      }
      
      public function get threePlayerGames() : int
      {
         return _threePlayerGames;
      }
      
      private function updateNanocashBalance(param1:Event) : void
      {
         Managers.serviceRequestBrokerManager.requestAccountInfo(nanocashBalanceUpdated,nanocashBalanceUpdateFailed);
      }
      
      private function onTimerDataHackTick(param1:TimerEvent) : void
      {
         if(DataManager.getInstance().getEMManager().getEMDataList() !== null)
         {
            log("UserProfile.onTimerDataHackTick(): EMManager found.");
            _tmrEMDataHack.stop();
            _tmrEMDataHack.removeEventListener(TimerEvent.TIMER,onTimerDataHackTick);
            _tmrEMDataHack = null;
            _ems = DataManager.getInstance().getEMManager().getEMDataList().length;
            _stateEMDataReceived = true;
            checkReceived();
         }
      }
      
      public function get totalKills() : int
      {
         return _totalKills;
      }
      
      public function get nanovorCountUnique() : int
      {
         return _nanovorCountUnique;
      }
      
      public function get screenname() : String
      {
         return _screenname;
      }
      
      private function nanocashBalanceUpdateFailed(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,nanocashBalanceUpdateFailed);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,nanocashBalanceUpdated);
         error("UPDATE NANOCASH BALANCE FAILED");
      }
   }
}

