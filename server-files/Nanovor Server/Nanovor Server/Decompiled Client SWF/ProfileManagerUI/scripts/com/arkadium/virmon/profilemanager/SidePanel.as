package com.arkadium.virmon.profilemanager
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.nanobank.NanoBank;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol314")]
   public class SidePanel extends MovieClip
   {
      
      public static const TRAY_SELECTED:String = "traySelected";
      
      public static const NANOCODES_CLICK:String = "nanocodesClick";
      
      public static const GIFTCARDS_CLICK:String = "giftcardsClick";
      
      public static const REWARDS_CLICK:String = "rewardsClick";
      
      private const NANOBANK_URL:String = "elements/NanoBank.swf";
      
      private var _szCurrentTab:String = "PLAYER";
      
      public var mcAccountInfo:MovieClip;
      
      private var _dictTrayTabs:Dictionary = new Dictionary();
      
      public var mcTrayTabs:MovieClip;
      
      private var _aTrayTabLabels:Array = ["PLAYER","AVATARS","BADGES","REWARDS"];
      
      private var oNanoBank:NanoBank;
      
      private var _bNanoBankLoading:Boolean = false;
      
      private var ldrNanoBank:Loader;
      
      public var btnGiftcards:SimpleButton;
      
      private const NANOBANK_X:int = 123;
      
      private const NANOBANK_Y:int = 63;
      
      private var _bNanoBankLoadError:Boolean = false;
      
      private var _ldrAvatar:Loader;
      
      public var btnNanocodes:SimpleButton;
      
      private var _bNanoBankLoaded:Boolean = false;
      
      public function SidePanel()
      {
         addFrameScript(0,frame1,14,frame15);
         super();
         btnGiftcards.addEventListener(MouseEvent.CLICK,onGiftcardsBtnClick,false,0,true);
         btnNanocodes.addEventListener(MouseEvent.CLICK,onNanocodesBtnClick,false,0,true);
         EventManager.getInstance().addEventListener(FrameWorkEvent.USER_STATS_UPDATED,onUserStatsUpdated,false,0,true);
         fillTrayTabs();
         SmallTab(_dictTrayTabs["PLAYER"]).bSelected = true;
         loadNanoBank();
      }
      
      private function onUserStatsUpdated(param1:Event) : void
      {
         init();
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error("** PM SidePanel: " + param1);
      }
      
      public function init() : *
      {
         var _loc1_:UserProfile = UserProfile.getInstance();
         mcAccountInfo.stfScreenname.text = _loc1_.screenname;
         mcAccountInfo.stfEmail.text = _loc1_.email;
         mcAccountInfo.stfNMP.text = _loc1_.nmp.toString() + " NMP";
         if(!_bNanoBankLoading && !_bNanoBankLoaded)
         {
            loadNanoBank();
         }
         else if(_bNanoBankLoaded && !_bNanoBankLoadError)
         {
            oNanoBank.updateBalance();
         }
         loadAvatar(_loc1_.avatarId);
      }
      
      private function onNanoBankLoad(param1:Event) : void
      {
         log("onNanoBankLoad");
         ldrNanoBank.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanoBankLoad);
         ldrNanoBank.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanoBankLoadError);
         oNanoBank = NanoBank(param1.target.content);
         ldrNanoBank.unload();
         ldrNanoBank = null;
         mcAccountInfo.addChild(oNanoBank);
         oNanoBank.x = NANOBANK_X;
         oNanoBank.y = NANOBANK_Y;
         _bNanoBankLoaded = true;
         oNanoBank.updateBalance();
      }
      
      private function loadNanoBank() : void
      {
         log("loadNanoBank");
         _bNanoBankLoading = true;
         ldrNanoBank = new Loader();
         ldrNanoBank.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanoBankLoad,false,0,true);
         ldrNanoBank.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNanoBankLoadError,false,0,true);
         ldrNanoBank.load(new URLRequest(NANOBANK_URL));
      }
      
      private function onAvatarLoad(param1:Event) : void
      {
         _ldrAvatar.contentLoaderInfo.removeEventListener(Event.COMPLETE,onAvatarLoad);
         _ldrAvatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onAvatarLoadError);
         var _loc2_:Bitmap = param1.target.content as Bitmap;
         _ldrAvatar.unload();
         _ldrAvatar = null;
         while(mcAccountInfo.mcAvatar.mcHolder.numChildren > 0)
         {
            mcAccountInfo.mcAvatar.mcHolder.removeChildAt(0);
         }
         mcAccountInfo.mcAvatar.mcHolder.addChild(_loc2_);
      }
      
      private function onAvatarLoadError(param1:IOErrorEvent) : void
      {
         _ldrAvatar.contentLoaderInfo.removeEventListener(Event.COMPLETE,onAvatarLoad);
         _ldrAvatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onAvatarLoadError);
         _ldrAvatar.unload();
         _ldrAvatar = null;
         error("AVATAR LOAD ERROR: " + param1.text);
      }
      
      private function onGiftcardsBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(GIFTCARDS_CLICK));
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> PM SidePanel: " + param1);
      }
      
      internal function frame15() : *
      {
         stop();
         dispatchEvent(new Event("TIMELINE_SIDE_PANEL_OPEN"));
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> PM SidePanel: " + param1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function loadAvatar(param1:int) : void
      {
         var szAvatarUrl:String;
         var iAvatarId:int = param1;
         if(Boolean(_ldrAvatar))
         {
            try
            {
               _ldrAvatar.unload();
               _ldrAvatar.close();
            }
            catch(e:Error)
            {
            }
         }
         szAvatarUrl = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarURL(AvatarAssetType.LARGE,iAvatarId).url;
         _ldrAvatar = new Loader();
         _ldrAvatar.contentLoaderInfo.addEventListener(Event.COMPLETE,onAvatarLoad,false,0,true);
         _ldrAvatar.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onAvatarLoadError,false,0,true);
         _ldrAvatar.load(new URLRequest(szAvatarUrl));
      }
      
      private function dispatchTraySelect() : void
      {
         dispatchEvent(new CustomEvent(TRAY_SELECTED,{"szLabel":_szCurrentTab}));
      }
      
      public function clearListeners() : void
      {
         oNanoBank.destroy();
         EventManager.getInstance().removeEventListener(FrameWorkEvent.USER_STATS_UPDATED,onUserStatsUpdated);
         btnGiftcards.removeEventListener(MouseEvent.CLICK,onGiftcardsBtnClick);
         btnNanocodes.removeEventListener(MouseEvent.CLICK,onNanocodesBtnClick);
         var _loc1_:int = 0;
         while(_loc1_ < _aTrayTabLabels.length)
         {
            SmallTab(_dictTrayTabs[_aTrayTabLabels[_loc1_]]).clearListeners();
            SmallTab(_dictTrayTabs[_aTrayTabLabels[_loc1_]]).removeEventListener(SmallTab.SMALL_TAB_CLICK,onTabClick);
            _loc1_++;
         }
      }
      
      private function fillTrayTabs() : void
      {
         var _loc4_:SmallTab = null;
         var _loc1_:int = 9;
         var _loc2_:int = 5;
         var _loc3_:int = 88;
         var _loc5_:int = 0;
         while(_loc5_ < _aTrayTabLabels.length)
         {
            _loc4_ = new SmallTab(_aTrayTabLabels[_loc5_]);
            _loc4_.x = _loc2_ + _loc5_ * _loc3_;
            _loc4_.y = _loc1_;
            _loc4_.addEventListener(SmallTab.SMALL_TAB_CLICK,onTabClick,false,0,true);
            mcTrayTabs.addChild(_loc4_);
            _dictTrayTabs[_aTrayTabLabels[_loc5_]] = _loc4_;
            _loc5_++;
         }
      }
      
      private function onTabClick(param1:CustomEvent) : void
      {
         if(_szCurrentTab == param1.data.szLabel)
         {
            return;
         }
         SmallTab(_dictTrayTabs[_szCurrentTab]).bSelected = false;
         _szCurrentTab = param1.data.szLabel;
         dispatchTraySelect();
      }
      
      private function onNanoBankLoadError(param1:IOErrorEvent) : void
      {
         ldrNanoBank.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanoBankLoad);
         ldrNanoBank.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanoBankLoadError);
         ldrNanoBank.unload();
         ldrNanoBank = null;
         error("NANOBANK LOAD ERROR: " + param1.text);
         _bNanoBankLoadError = true;
         _bNanoBankLoaded = true;
      }
      
      private function translateMemberHistory(param1:Number) : String
      {
         if(param1 < 0)
         {
            return "N/A";
         }
         var _loc2_:int = int(Math.ceil(param1 / (1000 * 60 * 60 * 24)));
         return _loc2_ + " days";
      }
      
      private function onNanocodesBtnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(NANOCODES_CLICK));
      }
   }
}

