package com.arkadium.virmon.wrapper
{
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.mdm.MDMBrowserController;
   import com.arkadium.virmon.shared.mdm.MDMBrowserKey;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5")]
   public class InternalWebBrowser extends MovieClip
   {
      
      private static const EXIT_BUTTON_POINT:Point = new Point(907,712);
      
      private var _autoCloseTimer:Timer;
      
      private var _email:String;
      
      private var _exitBtn:SpinningButtonComponent;
      
      private var _closeTime:Number;
      
      private var _accountId:String;
      
      private var _isNewAccountRegistration:Boolean;
      
      private var _browser:MDMBrowserController;
      
      private var _redirectURL:String;
      
      private var _username:String;
      
      public function InternalWebBrowser()
      {
         super();
      }
      
      public function hide() : void
      {
         visible = false;
         if(Boolean(_browser))
         {
            _browser.close();
            Managers.mdmManager.unregisterBrowserController(_browser);
            _browser = null;
         }
         Managers.mdmManager.restoreLastMdmBrowsersStates();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> InternalWebBroswer: " + param1);
      }
      
      private function createExitButton() : void
      {
         _exitBtn = new SpinningButtonComponent(new SpinnerIconX());
         addChild(_exitBtn);
         _exitBtn.x = EXIT_BUTTON_POINT.x;
         _exitBtn.y = EXIT_BUTTON_POINT.y;
         _exitBtn.color = SpinningButtonComponent.COLOR_RED;
         _exitBtn.open();
      }
      
      private function checkAccountCreationStatus(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         if(_browser.source.indexOf("<!-- New Account") >= 0)
         {
            _browser.onDocumentComplete = null;
            _loc3_ = Number(_browser.source.indexOf("<!-- New Account"));
            _loc4_ = Number(_browser.source.indexOf("New Account -->"));
            _loc2_ = _browser.source.substring(_loc3_,_loc4_);
            _loc5_ = _loc2_.split("|");
            _accountId = _loc5_[1];
            _username = _loc5_[2];
            _email = _loc5_[3];
            _closeTime = Number(_loc5_[4]);
            _redirectURL = _loc5_[5] + "?accountId=" + _accountId + "&username=" + _username + "&email=" + _email;
            _autoCloseTimer = new Timer(_closeTime * 1000,1);
            _autoCloseTimer.addEventListener(TimerEvent.TIMER,onAutoCloseTimer,false,0,true);
            _autoCloseTimer.start();
         }
      }
      
      private function removeListeners() : void
      {
         _exitBtn.removeEventListener(MouseEvent.CLICK,onExitClick);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** InternalWebBroswer: " + param1);
      }
      
      private function addListeners() : void
      {
         _exitBtn.addEventListener(MouseEvent.CLICK,onExitClick,false,0,true);
      }
      
      private function onExitClick(param1:MouseEvent) : void
      {
         hide();
      }
      
      private function onBrowserLoadComplete(param1:Object) : void
      {
         _browser.onDocumentComplete = null;
         _browser.visible = true;
         if(_isNewAccountRegistration)
         {
            _browser.onDocumentComplete = checkAccountCreationStatus;
         }
      }
      
      private function onAutoCloseTimer(param1:TimerEvent) : void
      {
         _autoCloseTimer.removeEventListener(TimerEvent.TIMER,onAutoCloseTimer);
         _autoCloseTimer.stop();
         _autoCloseTimer = null;
         hide();
         if(_accountId != "0")
         {
            navigateToURL(new URLRequest(_redirectURL),"_blank");
         }
         ILoginPanel(Managers.stateManager.getStateByName(StateType.LOGIN.name)).autoFillUserName(_username);
      }
      
      public function show(param1:String, param2:Boolean = false) : void
      {
         _isNewAccountRegistration = param2;
         if(!_exitBtn)
         {
            createExitButton();
            addListeners();
         }
         Managers.mdmManager.hideAllMdmBrowsers();
         visible = true;
         _browser = new MDMBrowserController(Managers.mdmManager,MDMBrowserKey.DEFAULT_INTERNAL_BROWSER,112,84,800,600,param1,false);
         _browser.visible = false;
         _browser.onDocumentComplete = onBrowserLoadComplete;
         Managers.mdmManager.registerBrowserController(_browser);
      }
   }
}

