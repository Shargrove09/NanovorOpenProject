package com.arkadium.virmon.loginpanel
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.communications.IVersionDataProvider;
   import com.arkadium.virmon.loginpanel.login.controller.LoginPanelLoginController;
   import com.arkadium.virmon.loginpanel.login.model.LoginPanelLoginModel;
   import com.arkadium.virmon.loginpanel.login.view.LoginPanelLoginView;
   import com.arkadium.virmon.loginpanel.wait.controller.LoginPanelWaitController;
   import com.arkadium.virmon.loginpanel.wait.model.LoginPanelWaitModel;
   import com.arkadium.virmon.loginpanel.wait.view.LoginPanelWaitView;
   import com.arkadium.virmon.wrapper.view.ILoginSubmitHandler;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LoginPanel extends Sprite implements ILoginPanel, IWaitPanel
   {
      
      private static const ERROR_TEXT_INVALID_LOGIN:String = "Wrong user name or password";
      
      private static const ERROR_TEXT_DATA_RETRIEVAL_ERROR:String = "Unable to connect to game server";
      
      private static const PANEL_Y_OPEN:int = 548;
      
      private static const PANEL_Y_CLOSE:int = 768;
      
      private static const QUIT_BUTTON_X_OPEN:int = 0;
      
      private static const QUIT_BUTTON_X_CLOSE:int = -70;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeOutQuad
      };
      
      private var _loginPanelController:LoginPanelLoginController;
      
      private var _loginPanelModel:LoginPanelLoginModel;
      
      private var _isLoginPanelShown:Boolean;
      
      public var btnQuit:SimpleButton;
      
      private var _waitPanelController:LoginPanelWaitController;
      
      private var _isWaitShown:Boolean;
      
      private var _waitPanelView:LoginPanelWaitView;
      
      private var _consumer:ILoginPanelConsumer;
      
      private var _waitPanelModel:LoginPanelWaitModel;
      
      private var _loginPanelView:LoginPanelLoginView;
      
      public function LoginPanel()
      {
         super();
         this.tabEnabled = false;
         this.btnQuit.tabEnabled = false;
         this.btnQuit.x = QUIT_BUTTON_X_CLOSE;
         this._loginPanelModel = new LoginPanelLoginModel();
         this._loginPanelController = new LoginPanelLoginController(this._loginPanelModel);
         this._loginPanelView = new LoginPanelLoginView(this._loginPanelModel,this._loginPanelController);
         this.addChild(this._loginPanelView);
         this._waitPanelModel = new LoginPanelWaitModel();
         this._waitPanelController = new LoginPanelWaitController(this._waitPanelModel);
         this._waitPanelView = new LoginPanelWaitView(this._waitPanelModel,this._waitPanelController);
         this.addChild(this._waitPanelView);
         this._waitPanelView.y = PANEL_Y_OPEN;
         this._loginPanelView.y = PANEL_Y_OPEN;
         this._waitPanelView.y = PANEL_Y_CLOSE;
         this._loginPanelView.y = PANEL_Y_CLOSE;
         this.btnQuit.addEventListener(MouseEvent.CLICK,this.handleQuitButtonClick,false,0,true);
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleLoginPanelAddedToStage,false,0,true);
      }
      
      private function hideLoginPanel() : void
      {
         if(!this._isLoginPanelShown)
         {
            return;
         }
         this._isLoginPanelShown = false;
         Tweener.removeTweens(this._loginPanelView);
         Tweener.addTween(this._loginPanelView,{
            "y":PANEL_Y_CLOSE,
            "base":TWEEN_BASE
         });
      }
      
      public function init(param1:ILoginSubmitHandler, param2:ILoginPanelConsumer) : void
      {
         this._consumer = param2;
         this._loginPanelModel.init(param1,param2);
      }
      
      private function showWaitPanel() : void
      {
         if(this._isWaitShown)
         {
            return;
         }
         this._isWaitShown = true;
         Tweener.removeTweens(this._waitPanelView);
         Tweener.addTween(this._waitPanelView,{
            "y":PANEL_Y_OPEN,
            "base":TWEEN_BASE
         });
      }
      
      public function get password() : String
      {
         return this._loginPanelModel.password;
      }
      
      public function addStatusMessage(param1:String, param2:String = "", param3:Boolean = false) : void
      {
         this._loginPanelModel.setStatusMessage(param1,param3);
         this._waitPanelModel.updateStatusMessage(param1);
      }
      
      public function handleSuccessfulLogin() : void
      {
         this._loginPanelModel.handleSuccessfullLogin();
      }
      
      public function renderVersionInfo(param1:IVersionDataProvider) : void
      {
         var _loc2_:Array = [param1.getMajorVersion().replace(" ",""),param1.getMinorVersion().replace(" ",""),param1.getBuildVersion().replace(" ","")];
         this._loginPanelModel.setVersion(_loc2_.join("."));
      }
      
      private function handleLoginPanelAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleLoginPanelAddedToStage);
         this.showLoginPanel();
         Tweener.addTween(this.btnQuit,{
            "x":QUIT_BUTTON_X_OPEN,
            "base":TWEEN_BASE
         });
      }
      
      public function handleSRBInitialized() : void
      {
         this._loginPanelModel.handleSRBInitialized();
      }
      
      public function get gameServerIP() : String
      {
         return this._loginPanelModel.gameServerIP;
      }
      
      public function handleSRBConnected() : void
      {
         this._loginPanelModel.handleSRBConnected();
      }
      
      public function renderShardList(param1:Array) : void
      {
         this._loginPanelModel.initializeShardList(param1);
      }
      
      public function get sprite() : Sprite
      {
         return this as Sprite;
      }
      
      public function initAfterDataRetrievalError() : void
      {
         this._loginPanelModel.handleLoginError();
      }
      
      public function handleUpdateProgress(param1:Number, param2:Number) : void
      {
         this._waitPanelModel.updateProgress(param1,param2);
      }
      
      private function handleQuitButtonClick(param1:MouseEvent) : void
      {
         if(null != this._consumer)
         {
            this._consumer.handleExitApplication();
         }
      }
      
      public function replaceStatusMessage(param1:String, param2:String = "") : void
      {
         this._loginPanelModel.setStatusMessage(param1);
         this._waitPanelModel.updateStatusMessage(param1);
      }
      
      private function hideWaitPanel() : void
      {
         if(!this._isWaitShown)
         {
            return;
         }
         this._isWaitShown = false;
         Tweener.removeTweens(this._waitPanelView);
         Tweener.addTween(this._waitPanelView,{
            "y":PANEL_Y_CLOSE,
            "base":TWEEN_BASE
         });
      }
      
      public function autoFillUserName(param1:String) : void
      {
         this._loginPanelModel.autoFillUserName(param1);
      }
      
      public function handleStatusMessage(param1:String) : void
      {
         this.hideLoginPanel();
         this.showWaitPanel();
         this._waitPanelModel.updateStatusMessage(param1);
      }
      
      public function get userName() : String
      {
         return this._loginPanelModel.username;
      }
      
      private function showLoginPanel() : void
      {
         if(this._isLoginPanelShown)
         {
            return;
         }
         this._isLoginPanelShown = true;
         Tweener.removeTweens(this._loginPanelView);
         Tweener.addTween(this._loginPanelView,{
            "y":PANEL_Y_OPEN,
            "base":TWEEN_BASE
         });
      }
      
      public function initAfterInvalidLogin() : void
      {
         this._loginPanelModel.handleLoginError();
      }
   }
}

