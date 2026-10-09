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
         this._handlers = new Dictionary();
         this._handlers[IUserProfileLoadCompleteHandler] = new Dictionary(true);
         EventManager.getInstance().addEventListener("NANOCASH_BALANCE_CHANGE",this.updateNanocashBalance,false,0,true);
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
         this._battleCount = Managers.storedSettingsManager.getSettingOrSetDefault(StoredSetting.BATTLE_COUNT,0);
         return this._battleCount;
      }
      
      public function get loaded() : Boolean
      {
         return this.isLoaded();
      }
      
      private function nanocashBalanceUpdated(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.nanocashBalanceUpdateFailed);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,this.nanocashBalanceUpdated);
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = new XML(_loc2_);
         _loc3_ = Utils.StripXmlNamespace(_loc3_);
         if(_loc3_.name().localName == "error")
         {
            this._stateInfoReceivedError = true;
            this.error("accountInfoReceived FAIL - Error returned in XML: \n" + "      type: " + _loc3_.type + "\n" + "      message: " + _loc3_.message);
         }
         else
         {
            this._nanocash = _loc3_.child("token-balance");
            EventManager.getInstance().dispatchEvent(new Event("NANOCASH_BALANCE_UPDATED"));
         }
      }
      
      private function checkReceived() : void
      {
         var _loc1_:IUserProfileLoadCompleteHandler = null;
         if(this._stateInfoReceived && this._stateStatsReceived && this._stateEMDataReceived)
         {
            if(this._stateInfoReceivedError || this._stateStatsReceivedError)
            {
               if(this._chainLoader != null)
               {
                  this._chainLoader.handleChainLoadeeError();
               }
               this._chainLoader = null;
               dispatchEvent(new Event(UserProfileEvent.LOAD_ERROR_EVENT));
            }
            else
            {
               this.log("UserProfile.checkReceived(): load complete!");
               if(this._chainLoader != null)
               {
                  this._chainLoader.handleChainLoadeeComplete(this as IUserProfile);
               }
               this._chainLoader = null;
               dispatchEvent(new Event(UserProfileEvent.LOAD_COMPLETE_EVENT));
               for each(_loc1_ in this._handlers[IUserProfileLoadCompleteHandler])
               {
                  _loc1_.handleUserProfileLoadComplete();
               }
               this._isLoaded = true;
            }
         }
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error(">> UserProfile: " + param1);
      }
      
      public function get gamesWon() : int
      {
         return this._gamesWon;
      }
      
      public function get gamesPlayed() : int
      {
         return this._gamesPlayed;
      }
      
      public function retrieveProfileData(param1:Boolean = false) : void
      {
         var _loc2_:IUserProfileLoadCompleteHandler = null;
         if(!param1 && this.loaded)
         {
            dispatchEvent(new Event(UserProfileEvent.LOAD_COMPLETE_EVENT));
            for each(_loc2_ in this._handlers[IUserProfileLoadCompleteHandler])
            {
               _loc2_.handleUserProfileLoadComplete();
            }
            return;
         }
         this._stateInfoReceived = this._stateStatsReceived = this._stateInfoReceivedError = this._stateStatsReceivedError = this._stateEMDataReceived = false;
         this._tmrEMDataHack = new Timer(15);
         this._tmrEMDataHack.addEventListener(TimerEvent.TIMER,this.onTimerDataHackTick,false,0,true);
         if(DataManager.getInstance().getEMManager().getEMDataList() !== null)
         {
            this.onTimerDataHackTick(null);
         }
         else
         {
            this._tmrEMDataHack.start();
         }
         this._memberHistory = this.calculateMemberHistory();
         this.retrieveNanovorCounts();
         Managers.serviceRequestBrokerManager.requestAccountInfo(this.accountInfoReceived,this.accountInfoFailed);
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      private function onSaveAccountInfoSuccess(param1:Event) : void
      {
         URLLoader(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.onSaveAccountInfoError);
         URLLoader(param1.target).removeEventListener(Event.COMPLETE,this.onSaveAccountInfoSuccess);
         EventManager.getInstance().dispatchEvent(new Event(FrameWorkEvent.USER_STATS_UPDATED));
         this._userGameService.updateAvatar(this._avatarId);
      }
      
      public function get magnamodKills() : int
      {
         return this._magnamodKills;
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> UserProfile: " + param1);
      }
      
      private function accountStatsFailed(param1:IOErrorEvent) : *
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.accountStatsReceived);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.accountStatsFailed);
         this.error("ACCOUNT STATS FAILED");
      }
      
      public function setJolts(param1:int, param2:int, param3:int, param4:int) : void
      {
         this._healthJolts = param1;
         this._armorJolts = param2;
         this._strengthJolts = param4;
         this._speedJolts = param3;
      }
      
      public function get avatarId() : int
      {
         return this._avatarId;
      }
      
      public function get phoneNumber() : String
      {
         return this._sPhoneNumber;
      }
      
      public function get fourPlayerGames() : int
      {
         return this._fourPlayerGames;
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> UserProfile: " + param1);
      }
      
      private function onSaveAccountInfoError(param1:IOErrorEvent) : void
      {
         URLLoader(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.onSaveAccountInfoError);
         URLLoader(param1.target).removeEventListener(Event.COMPLETE,this.onSaveAccountInfoSuccess);
         this._avatarId = this._oldSafeAvatarId;
         this.error("++++++ onSaveAccountInfoError: " + param1.text);
      }
      
      private function retrieveNanovorCounts() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = DataManager.getInstance().getVirmonManager().getVirmonDataList();
         this._nanovorCount = _loc1_.length;
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
         this._nanovorCountUnique = _loc2_.length;
      }
      
      public function removeUserProfileLoadCompleteHandler(param1:IUserProfileLoadCompleteHandler) : void
      {
         delete this._handlers[IUserProfileLoadCompleteHandler][param1];
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         this._chainLoader = param1;
      }
      
      private function accountStatsReceived(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,this.accountStatsReceived);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.accountStatsFailed);
         this.log("accountStatsReceived()");
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = new XML(_loc2_);
         _loc3_ = Utils.StripXmlNamespace(_loc3_);
         if(_loc3_.name().localName == "error")
         {
            this._stateStatsReceivedError = true;
            this.error("accountStatsReceived FAIL - Error returned in XML: \n" + "      type: " + _loc3_.type + "\n" + "      message: " + _loc3_.message);
         }
         else
         {
            this._nmp = _loc3_.child("virmon-master-rating");
            this._totalKills = _loc3_.child("kill-count");
            this._gamesPlayed = _loc3_.child("game-count");
            this._gamesWon = _loc3_.child("win-count");
            this._twoPlayerGames = _loc3_.child("two-player-game-count");
            this._threePlayerGames = _loc3_.child("three-player-game-count");
            this._fourPlayerGames = _loc3_.child("four-player-game-count");
            this._hexiteKills = _loc3_.child("hexite-kill-count");
            this._magnamodKills = _loc3_.child("magnamod-kill-count");
            this._velocitronKills = _loc3_.child("virmon-master-rating");
         }
         this._stateStatsReceived = true;
         this.checkReceived();
      }
      
      private function accountInfoReceived(param1:Event) : void
      {
         this.log("accountInfoReceived()");
         var _loc2_:String = String(param1.target.data);
         this._accountInfoXML = new XML(_loc2_);
         this._accountInfoXML = Utils.StripXmlNamespace(this._accountInfoXML);
         if(this._accountInfoXML.name().localName == "error")
         {
            this._stateInfoReceivedError = true;
            this.error("accountInfoReceived FAIL - Error returned in XML: \n" + "      type: " + this._accountInfoXML.type + "\n" + "      message: " + this._accountInfoXML.message);
         }
         else
         {
            this._screenname = String(this._accountInfoXML.username).toLowerCase();
            this._email = this._accountInfoXML.child("email-address");
            this._nanocash = this._accountInfoXML.child("token-balance");
            this._avatarId = this._accountInfoXML.child("avatar-id");
            this._sPhoneNumber = this._accountInfoXML.child("phone-number");
            this._healthJolts = this._accountInfoXML.child("jolt_health_balance");
            this._armorJolts = this._accountInfoXML.child("jolt_armor_balance");
            this._strengthJolts = this._accountInfoXML.child("jolt_strength_balance");
            this._speedJolts = this._accountInfoXML.child("jolt_speed_balance");
         }
         this._stateInfoReceived = true;
         Managers.serviceRequestBrokerManager.requestAccountStats(this.accountStatsReceived,this.accountStatsFailed);
      }
      
      public function resetBreadcrumbCount() : void
      {
         this.log("updating breadcrumb count");
         Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.BREADCRUMB_COUNT,0);
      }
      
      public function get armorJolts() : int
      {
         return this._armorJolts;
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      private function accountInfoFailed(param1:IOErrorEvent) : *
      {
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.accountInfoFailed);
         this.error("GET ACCOUNT INFO FAILED");
         dispatchEvent(new Event(UserProfileEvent.LOAD_ERROR_EVENT));
      }
      
      public function get healthJolts() : int
      {
         return this._healthJolts;
      }
      
      public function updateAvatar(param1:int) : void
      {
         this._oldSafeAvatarId = this._avatarId;
         this._avatarId = param1;
         this.saveAccoutInfo();
      }
      
      public function get accountInfoXML() : XML
      {
         return this._accountInfoXML;
      }
      
      public function get nmp() : int
      {
         return this._nmp;
      }
      
      public function get memberHistory() : Number
      {
         return this._memberHistory;
      }
      
      public function getBreadcrumbCount() : int
      {
         var _loc1_:int = Managers.storedSettingsManager.getSettingOrSetDefault(StoredSetting.BREADCRUMB_COUNT,0);
         this._breadcrumbCount = Math.min(_loc1_,BreadcrumbType.breadcrumbTypes.length - 1);
         this.log("getBreadcrumbCount: returning " + this._breadcrumbCount + ", length of breadcrumbTypes=" + BreadcrumbType.breadcrumbTypes.length);
         return this._breadcrumbCount;
      }
      
      public function get velocitronKills() : int
      {
         return this._velocitronKills;
      }
      
      public function get speedJolts() : int
      {
         return this._speedJolts;
      }
      
      public function updateBattleCount() : void
      {
         ++this._battleCount;
         this.log("updating battle count: " + this._battleCount);
         Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.BATTLE_COUNT,this._battleCount);
      }
      
      public function get hexiteKills() : int
      {
         return this._hexiteKills;
      }
      
      public function get nanovorCount() : int
      {
         return this._nanovorCount;
      }
      
      public function get email() : String
      {
         return this._email;
      }
      
      public function get strengthJolts() : int
      {
         return this._strengthJolts;
      }
      
      public function updateBreadcrumbCount(param1:int = 0) : void
      {
         if(param1 == this._breadcrumbCount)
         {
            ++this._breadcrumbCount;
            this.log("updated breadcrumb count: " + this._breadcrumbCount);
            Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.BREADCRUMB_COUNT,this._breadcrumbCount);
         }
         else
         {
            this.log("not updating breadcrumb due to insufficient index: " + param1 + ", _breadcrumbCount: " + this._breadcrumbCount);
         }
      }
      
      public function get breadcrumbCount() : int
      {
         return this._breadcrumbCount;
      }
      
      public function addUserProfileLoadCompleteHandler(param1:IUserProfileLoadCompleteHandler) : void
      {
         this._handlers[IUserProfileLoadCompleteHandler][param1] = param1;
      }
      
      private function isLoaded() : Boolean
      {
         return this._isLoaded;
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
         this._userGameService = param1;
      }
      
      public function get twoPlayerGames() : int
      {
         return this._twoPlayerGames;
      }
      
      private function saveAccoutInfo() : void
      {
         var _loc1_:Boolean = this._sPhoneNumber === null || this._sPhoneNumber == "";
         var _loc2_:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" + "<account-profile xmlns=\"http://smithandtinker.com/backend/xsd/account/account-profile.xsd\">\n" + (_loc1_ ? "" : "\t<phone-number>" + this._sPhoneNumber + "</phone-number>\n") + "\t<avatar-id>" + this._avatarId + "</avatar-id>\n" + "</account-profile>";
         Managers.serviceRequestBrokerManager.saveAccountInfo(XML(_loc2_),this.onSaveAccountInfoSuccess,this.onSaveAccountInfoError);
      }
      
      public function get ems() : int
      {
         return this._ems;
      }
      
      public function load() : void
      {
         this.retrieveProfileData(true);
      }
      
      public function get nanocash() : int
      {
         return this._nanocash;
      }
      
      public function get threePlayerGames() : int
      {
         return this._threePlayerGames;
      }
      
      private function updateNanocashBalance(param1:Event) : void
      {
         Managers.serviceRequestBrokerManager.requestAccountInfo(this.nanocashBalanceUpdated,this.nanocashBalanceUpdateFailed);
      }
      
      private function onTimerDataHackTick(param1:TimerEvent) : void
      {
         if(DataManager.getInstance().getEMManager().getEMDataList() !== null)
         {
            this.log("UserProfile.onTimerDataHackTick(): EMManager found.");
            this._tmrEMDataHack.stop();
            this._tmrEMDataHack.removeEventListener(TimerEvent.TIMER,this.onTimerDataHackTick);
            this._tmrEMDataHack = null;
            this._ems = DataManager.getInstance().getEMManager().getEMDataList().length;
            this._stateEMDataReceived = true;
            this.checkReceived();
         }
      }
      
      public function get totalKills() : int
      {
         return this._totalKills;
      }
      
      public function get nanovorCountUnique() : int
      {
         return this._nanovorCountUnique;
      }
      
      public function get screenname() : String
      {
         return this._screenname;
      }
      
      private function nanocashBalanceUpdateFailed(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.nanocashBalanceUpdateFailed);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,this.nanocashBalanceUpdated);
         this.error("UPDATE NANOCASH BALANCE FAILED");
      }
   }
}

