package com.arkadium.virmon.profilemanager
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.common.UserProfileEvent;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.soundmanager.*;
   import com.smithandtinker.nanovor.common.event.PanelEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol316")]
   public class ProfileManagerUI extends MovieClip
   {
      
      public var trayBadges:TrayBadges;
      
      public var trayPlayerDetails:TrayPlayerDetails;
      
      public var trayRewards:TrayRewards;
      
      public var trayAvatars:TrayAvatars;
      
      private var _userProfile:UserProfile;
      
      public var modalNanocodeEntry:ModalNanocodeEntry;
      
      private var _iModalInPosition:int;
      
      private var _iModalOutPosition:int;
      
      private var _iTrayOutPosition:int;
      
      private var _iTrayInPosition:int;
      
      public var mcModalScrim:MovieClip;
      
      private var _nLastTakeOutTime:Number = 0;
      
      public var modalGiftcardEntry:ModalGiftcardEntry;
      
      private var _szCurrentTray:String = null;
      
      public var sidePanel:SidePanel;
      
      public function ProfileManagerUI()
      {
         super();
         log("ProfileManagerUI() constructor");
         sidePanel.addEventListener(SidePanel.TRAY_SELECTED,onTraySelected,false,0,true);
         sidePanel.addEventListener(SidePanel.NANOCODES_CLICK,onNanocodesClick,false,0,true);
         sidePanel.addEventListener(SidePanel.GIFTCARDS_CLICK,onGiftcardsClick,false,0,true);
         sidePanel.addEventListener("TIMELINE_SIDE_PANEL_OPEN",onSidePanelOpen,false,0,true);
         trayAvatars.addEventListener(TrayAvatars.AVATAR_SELECTED,onAvatarSelected,false,0,true);
         modalGiftcardEntry.addEventListener(ModalGiftcardEntry.EVENT_EXIT,onGiftcardEntryExit,false,0,true);
         modalNanocodeEntry.addEventListener(ModalNanocodeEntry.EVENT_EXIT,onNanocodeEntryExit,false,0,true);
         trayAvatars.addEventListener(TrayAvatars.PASSWORD_CHANGE_CLICK,onPasswordChangeClick,false,0,true);
         trayBadges.addEventListener(TrayBadges.PASSWORD_CHANGE_CLICK,onPasswordChangeClick,false,0,true);
         trayRewards.addEventListener(TrayRewards.PASSWORD_CHANGE_CLICK,onPasswordChangeClick,false,0,true);
         trayPlayerDetails.addEventListener(TrayPlayerDetails.PASSWORD_CHANGE_CLICK,onPasswordChangeClick,false,0,true);
         _iTrayInPosition = trayPlayerDetails.x;
         _iTrayOutPosition = _iTrayInPosition - (trayPlayerDetails.width + 2);
         _iModalInPosition = modalGiftcardEntry.x;
         _iModalOutPosition = _iModalInPosition - (modalGiftcardEntry.width + modalGiftcardEntry.x + 10);
         trayPlayerDetails.x = _iTrayOutPosition;
         trayAvatars.x = _iTrayOutPosition;
         trayBadges.x = _iTrayOutPosition;
         trayRewards.x = _iTrayOutPosition;
         modalGiftcardEntry.x = _iModalOutPosition;
         modalNanocodeEntry.x = _iModalOutPosition;
         trayPlayerDetails.visible = false;
         trayAvatars.visible = false;
         trayBadges.visible = false;
         trayRewards.visible = false;
         mcModalScrim.visible = false;
         mcModalScrim.alpha = 0;
         Tweener.addTween(sidePanel,{
            "x":0,
            "time":0.6,
            "delay":1.2,
            "transition":"easeOutQuad",
            "onStart":onSidePanelSlideInStart,
            "onComplete":onSidePanelSlideInComplete
         });
         sidePanel.gotoAndPlay("delayedOpen");
         modalNanocodeEntry.visible = false;
         modalGiftcardEntry.visible = false;
         _userProfile = UserProfile.getInstance();
         _userProfile.addEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUserProfileLoadComplete,false,0,true);
         _userProfile.addEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onUserProfileLoadError,false,0,true);
         _userProfile.retrieveProfileData(true);
      }
      
      private function onUserProfileLoadError(param1:Event) : void
      {
         _userProfile.removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUserProfileLoadComplete);
         _userProfile.removeEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onUserProfileLoadError);
         error("onUserProfileLoadError");
      }
      
      protected function error(param1:String) : void
      {
         DebugLog.instance.error(">> ProfileManagerUI: " + param1);
      }
      
      private function modalNanocodeEntryOut() : void
      {
         modalNanocodeEntry.visible = false;
         sidePanel.init();
         trayPlayerDetails.init();
         modalNanocodeEntry.init();
      }
      
      private function switchTray(param1:String) : void
      {
         log("switching to tray " + param1);
         switch(_szCurrentTray)
         {
            case "PLAYER":
               trayTakeOut(trayPlayerDetails);
               break;
            case "AVATARS":
               trayTakeOut(trayAvatars);
               break;
            case "BADGES":
               trayTakeOut(trayBadges);
               break;
            case "REWARDS":
               trayTakeOut(trayRewards);
         }
         _szCurrentTray = param1;
         switch(_szCurrentTray)
         {
            case "PLAYER":
               trayBringIn(trayPlayerDetails);
               Managers.analyticsManager.trackView(View.PROFILEMANAGER_DETAILS);
               break;
            case "AVATARS":
               trayBringIn(trayAvatars);
               Managers.analyticsManager.trackView(View.PROFILEMANAGER_AVATARS);
               break;
            case "BADGES":
               trayBringIn(trayBadges);
               Managers.analyticsManager.trackView(View.PROFILEMANAGER_BADGES);
               break;
            case "REWARDS":
               trayBringIn(trayRewards);
               Managers.analyticsManager.trackView(View.PROFILEMANAGER_REWARDS);
         }
      }
      
      private function trayTakeOutComplete(param1:DisplayObject) : void
      {
         param1.visible = false;
      }
      
      private function trayBringInComplete(param1:DisplayObject) : void
      {
      }
      
      private function initPanels() : void
      {
         sidePanel.init();
         trayPlayerDetails.init();
         trayAvatars.init();
         trayBadges.init();
         trayRewards.init();
         modalGiftcardEntry.init();
         modalNanocodeEntry.init();
      }
      
      private function trayBringInStart() : void
      {
      }
      
      private function modalGiftcardEntryOut() : void
      {
         modalGiftcardEntry.visible = false;
         sidePanel.init();
         trayPlayerDetails.init();
         modalGiftcardEntry.init();
      }
      
      public function dispose() : void
      {
         Tweener.removeTweens(modalGiftcardEntry);
         Tweener.removeTweens(mcModalScrim);
         Tweener.removeTweens(modalNanocodeEntry);
         sidePanel.removeEventListener(SidePanel.TRAY_SELECTED,onTraySelected);
         sidePanel.removeEventListener(SidePanel.GIFTCARDS_CLICK,onGiftcardsClick);
         sidePanel.removeEventListener(SidePanel.NANOCODES_CLICK,onNanocodesClick);
         sidePanel.removeEventListener("TIMELINE_SIDE_PANEL_OPEN",onSidePanelOpen);
         trayAvatars.removeEventListener(TrayAvatars.AVATAR_SELECTED,onAvatarSelected);
         trayAvatars.removeEventListener(TrayAvatars.PASSWORD_CHANGE_CLICK,onPasswordChangeClick);
         trayBadges.removeEventListener(TrayBadges.PASSWORD_CHANGE_CLICK,onPasswordChangeClick);
         trayPlayerDetails.removeEventListener(TrayPlayerDetails.PASSWORD_CHANGE_CLICK,onPasswordChangeClick);
         modalGiftcardEntry.removeEventListener(ModalGiftcardEntry.EVENT_EXIT,onGiftcardEntryExit);
         modalNanocodeEntry.removeEventListener(ModalNanocodeEntry.EVENT_EXIT,onNanocodeEntryExit);
         sidePanel.clearListeners();
         trayAvatars.clearListeners();
         trayBadges.clearListeners();
         trayPlayerDetails.clearListeners();
         modalGiftcardEntry.clearListeners();
         modalNanocodeEntry.clearListeners();
         clear();
      }
      
      private function onGiftcardEntryExit(param1:Event) : void
      {
         Tweener.addTween(modalGiftcardEntry,{
            "x":_iModalOutPosition,
            "time":0.6,
            "transition":"easeInBack",
            "transitionParams":{"overshoot":1}
         });
         Tweener.addTween(mcModalScrim,{
            "_autoAlpha":0,
            "time":0.4,
            "delay":0.6,
            "transition":"easeOutQuad",
            "onComplete":modalGiftcardEntryOut
         });
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"GenericWhoosh2",true,SoundManagerConst.soundApplicationDomain));
      }
      
      private function onSidePanelSlideInStart() : void
      {
      }
      
      private function onPasswordChangeClick(param1:Event) : void
      {
         EventManager.getInstance().dispatchEvent(new FrameWorkEvent(FrameWorkEvent.MDM_OPEN_BROWSER_HOOK,false,false,"password-change"));
      }
      
      private function onSidePanelOpen(param1:Event) : void
      {
         sidePanel.removeEventListener("TIMELINE_SIDE_PANEL_OPEN",onSidePanelOpen);
         if(_szCurrentTray == null)
         {
            switchTray("PLAYER");
         }
      }
      
      private function trayTakeOut(param1:DisplayObject) : void
      {
         Tweener.removeTweens(param1,x);
         _nLastTakeOutTime = (param1.x - _iTrayOutPosition) / (_iTrayInPosition - _iTrayOutPosition) * 0.5;
         Tweener.addTween(param1,{
            "x":_iTrayOutPosition,
            "time":_nLastTakeOutTime,
            "transition":"easeInOutQuad",
            "onComplete":trayTakeOutComplete,
            "onCompleteParams":[param1]
         });
      }
      
      private function trayBringIn(param1:DisplayObject, param2:Boolean = true) : void
      {
         Tweener.removeTweens(param1,x);
         param1.visible = true;
         var _loc3_:Number = (_iTrayInPosition - param1.x) / (_iTrayInPosition - _iTrayOutPosition) * 0.5;
         Tweener.addTween(param1,{
            "x":_iTrayInPosition,
            "time":_loc3_,
            "delay":_nLastTakeOutTime,
            "transition":"easeInOutQuad",
            "onStart":trayBringInStart,
            "onComplete":trayBringInComplete,
            "onCompleteParams":[param1]
         });
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> ProfileManagerUI: " + param1);
      }
      
      public function clear() : void
      {
      }
      
      private function onAvatarSelected(param1:CustomEvent) : void
      {
         var _loc2_:int = int(param1.data);
         _userProfile.updateAvatar(_loc2_);
         Managers.analyticsManager.trackAction(Action.PROFILE_AVATAR_CHANGE);
      }
      
      private function onGiftcardsClick(param1:Event) : void
      {
         modalGiftcardEntry.visible = true;
         Tweener.addTween(mcModalScrim,{
            "_autoAlpha":0.6,
            "time":0.3,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(modalGiftcardEntry,{
            "x":_iModalInPosition,
            "time":0.6,
            "delay":0.3,
            "transition":"easeOutBack",
            "onComplete":modalGiftcardEntryIn,
            "transitionParams":{"overshoot":1}
         });
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"GenericWhoosh3",true,SoundManagerConst.soundApplicationDomain));
         Managers.analyticsManager.trackView(View.PROFILEMANAGER_NANOCASH_CARDS);
      }
      
      private function onUserProfileLoadComplete(param1:Event) : void
      {
         _userProfile.removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUserProfileLoadComplete);
         _userProfile.removeEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onUserProfileLoadError);
         initPanels();
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(">> ProfileManagerUI: " + param1);
      }
      
      private function onSidePanelSlideInComplete() : void
      {
         sidePanel.gotoAndPlay("open");
      }
      
      private function modalGiftcardEntryIn() : void
      {
         modalGiftcardEntry.flash();
         modalGiftcardEntry.focus();
      }
      
      protected function _unregisterHandler(param1:PanelEvent) : void
      {
         dispatchEvent(new PanelEvent(PanelEvent.UNREGISTER));
      }
      
      private function modalNanocodeEntryIn() : void
      {
         modalNanocodeEntry.flash();
         modalNanocodeEntry.focus();
      }
      
      private function onNanocodesClick(param1:Event) : void
      {
         modalNanocodeEntry.visible = true;
         Tweener.addTween(mcModalScrim,{
            "_autoAlpha":0.6,
            "time":0.3,
            "transition":"easeOutQuart"
         });
         Tweener.addTween(modalNanocodeEntry,{
            "x":_iModalInPosition,
            "time":0.6,
            "delay":0.3,
            "transition":"easeOutBack",
            "onComplete":modalNanocodeEntryIn,
            "transitionParams":{"overshoot":1}
         });
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"GenericWhoosh3",true,SoundManagerConst.soundApplicationDomain));
         Managers.analyticsManager.trackView(View.PROFILEMANAGER_COUPON_CODE);
      }
      
      private function onNanocodeEntryExit(param1:Event) : void
      {
         Tweener.addTween(modalNanocodeEntry,{
            "x":_iModalOutPosition,
            "time":0.6,
            "transition":"easeInBack",
            "transitionParams":{"overshoot":1}
         });
         Tweener.addTween(mcModalScrim,{
            "_autoAlpha":0,
            "time":0.4,
            "delay":0.6,
            "transition":"easeOutQuad",
            "onComplete":modalNanocodeEntryOut
         });
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"GenericWhoosh2",true,SoundManagerConst.soundApplicationDomain));
      }
      
      private function onTraySelected(param1:CustomEvent) : void
      {
         var _loc2_:String = param1.data.szLabel;
         if(_loc2_ == _szCurrentTray)
         {
            return;
         }
         switchTray(_loc2_);
      }
   }
}

