package com.arkadium.virmon.wrapper
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.mdm.MDMBrowserController;
   import com.arkadium.virmon.shared.mdm.MDMBrowserKey;
   import com.arkadium.virmon.shared.utils.ExitBtn;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.*;
   import mdm.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol28")]
   public class BuyTokens extends MovieClip
   {
      
      private var _webClientManager:*;
      
      public var mcScrim:MovieClip;
      
      private var _eventManager:IEventDispatcher;
      
      private var _userProfile:IUserProfile;
      
      public var mcExitBtn:ExitBtn;
      
      private var _browser:MDMBrowserController;
      
      private var _srbManager:*;
      
      private var _mdmManager:IMDMManager;
      
      public function BuyTokens()
      {
         super();
         initListeners();
      }
      
      public function hide() : void
      {
         if(!visible)
         {
            return;
         }
         _mdmManager.restoreLastMdmBrowsersStates();
         visible = false;
         hidePage();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BuyTokens: " + param1);
      }
      
      private function onLoadedNanocash(param1:Event) : void
      {
      }
      
      private function initListeners() : *
      {
         mcExitBtn.addEventListener("EXITBTN_CLICK",onExitClick);
      }
      
      private function loadPage() : void
      {
         var _loc1_:String = _srbManager.getAccountID();
         var _loc2_:String = _srbManager.getLoginToken();
         var _loc3_:String = _webClientManager.getWebClientHookUrl("buy-nanocash");
         var _loc4_:String = _loc3_ + "?user_id=" + _loc1_ + "&token=" + _loc2_;
         _browser = new MDMBrowserController(_mdmManager,MDMBrowserKey.BUY_NANOCASH,237,191,550,401,_loc4_,false);
         _mdmManager.registerBrowserController(_browser);
      }
      
      public function init(param1:IEventDispatcher, param2:IMDMManager, param3:*, param4:*, param5:IUserProfile) : void
      {
         _eventManager = param1;
         _mdmManager = param2;
         _srbManager = param3;
         _webClientManager = param4;
         _userProfile = param5;
      }
      
      private function onExitClick(param1:Event) : void
      {
         _userProfile.retrieveProfileData();
         _eventManager.dispatchEvent(new Event("NANOCASH_BALANCE_CHANGE"));
         hide();
      }
      
      private function hidePage() : void
      {
         if(Boolean(_browser))
         {
            _browser.close();
            _mdmManager.unregisterBrowserController(_browser);
            log("Refreshing profile data");
            _userProfile.retrieveProfileData();
         }
         _eventManager.dispatchEvent(new Event("RESUME_SIZZLE"));
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BuyTokens: " + param1);
      }
      
      public function show() : void
      {
         _mdmManager.hideAllMdmBrowsers();
         visible = true;
         loadPage();
      }
   }
}

