package com.arkadium.virmon.loginpanel.login.view
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.loginpanel.login.components.RememberMeCheckBox;
   import com.arkadium.virmon.loginpanel.login.controller.ILoginPanelLoginController;
   import com.arkadium.virmon.loginpanel.login.model.ILoginPanelLoginModel;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginEligible;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginError;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginShardInitializer;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginStatusMessageHandler;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginUsernameAutoFill;
   import com.arkadium.virmon.loginpanel.login.model.handlers.ILoginVersionReceived;
   import com.arkadium.virmon.shared.ui.dropdownmenu.DropDownMenu;
   import com.arkadium.virmon.shared.ui.dropdownmenu.IDropDownMenuHandler;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol79")]
   public class LoginPanelLoginView extends Sprite implements ILoginPanelLoginView, ILoginEligible, ILoginUsernameAutoFill, ILoginError, ILoginVersionReceived, ILoginShardInitializer, IDropDownMenuHandler, ILoginStatusMessageHandler
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      private static const TEXT_COLOR_ERROR:uint = 16711680;
      
      private static const TEXT_COLOR_STATUS:uint = 5229533;
      
      public var mcRememberMe:RememberMeCheckBox;
      
      public var tfVersion:TextField;
      
      public var btnForgotPassword:SimpleButton;
      
      public var mcShardMenu:DropDownMenu;
      
      public var tfUsername:TextField;
      
      public var btnNewAccount:SimpleButton;
      
      private var _model:ILoginPanelLoginModel;
      
      public var tfPassword:TextField;
      
      private var _controller:ILoginPanelLoginController;
      
      public var btnLogin:SimpleButton;
      
      public var tfError:TextField;
      
      public function LoginPanelLoginView(param1:ILoginPanelLoginModel, param2:ILoginPanelLoginController)
      {
         super();
         this._model = param1;
         this._controller = param2;
         this._model.addLoginEligibleHandler(ILoginEligible(this));
         this._model.addLoginUsernameAutoFillhandler(ILoginUsernameAutoFill(this));
         this._model.addLoginErrorHandler(ILoginError(this));
         this._model.addLoginShardInitializer(ILoginShardInitializer(this));
         this._model.addLoginStatusUpdateHandler(ILoginStatusMessageHandler(this));
         this._model.addLoginVersionHandler(ILoginVersionReceived(this));
         this.tabEnabled = false;
         this.mcShardMenu.tabEnabled = false;
         this.mcShardMenu.tabChildren = false;
         this.btnLogin.tabEnabled = false;
         this.btnNewAccount.tabEnabled = false;
         this.btnForgotPassword.tabEnabled = false;
         this.mcRememberMe.tabEnabled = false;
         this.btnLogin.visible = false;
         this.btnLogin.alpha = 0;
         this.mcShardMenu.visible = false;
         this.tfVersion.text = "";
         this.tfError.text = "";
         this.tfPassword.displayAsPassword = true;
         this.btnForgotPassword.addEventListener(MouseEvent.CLICK,this.handleForgotPasswordClick,false,0,true);
         this.btnNewAccount.addEventListener(MouseEvent.CLICK,this.handleNewAccountClick,false,0,true);
         this.btnLogin.addEventListener(MouseEvent.CLICK,this.handleLoginClick,false,0,true);
         this.tfPassword.addEventListener(Event.CHANGE,this.handleLoginCredentialChange,false,0,true);
         this.tfUsername.addEventListener(Event.CHANGE,this.handleLoginCredentialChange,false,0,true);
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
      }
      
      private function handleForgotPasswordClick(param1:MouseEvent) : void
      {
         this._controller.handleGotoForgotPassword();
      }
      
      public function handleShardDropDownMenuReceived(param1:Array, param2:int) : void
      {
         this.mcShardMenu.init(IDropDownMenuHandler(this),param1);
         this.mcShardMenu.visible = true;
         this.mcShardMenu.selectItem(param2);
      }
      
      private function handleStageKeyDown(param1:KeyboardEvent) : void
      {
         if(!this.btnLogin.mouseEnabled)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            this._controller.attemptLogin(this.tfUsername.text,this.tfPassword.text,this.mcRememberMe.isSelected);
         }
      }
      
      public function handleLoginUsernameAutoFill(param1:String, param2:String) : void
      {
         this.tfUsername.text = param1;
         this.tfPassword.text = param2;
         this.mcRememberMe.toggle(true);
      }
      
      public function handleUpdateStatusMessage(param1:String, param2:Boolean = false) : void
      {
         this.updateStatusMessage(param1,param2 ? TEXT_COLOR_ERROR : TEXT_COLOR_STATUS);
      }
      
      private function handleNewAccountClick(param1:MouseEvent) : void
      {
         this._controller.handleGotoNewAccount();
      }
      
      public function handleLoginEligible(param1:Boolean) : void
      {
         Tweener.removeTweens(this.btnLogin);
         var _loc2_:int = param1 ? 1 : 0;
         this.btnLogin.mouseEnabled = param1;
         Tweener.addTween(this.btnLogin,{
            "_autoAlpha":_loc2_,
            "base":TWEEN_BASE
         });
      }
      
      public function itemClicked(param1:int, param2:Boolean = false) : void
      {
         this.mcShardMenu.selectItem(param1);
         this._controller.updateShardIndex(param1);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleStageKeyDown);
      }
      
      private function updateStatusMessage(param1:String, param2:uint, param3:Boolean = false) : void
      {
         this.tfError.alpha = 1;
         if(param3)
         {
            this.tfError.alpha = 0;
            Tweener.addTween(this.tfError,{
               "alpha":1,
               "base":TWEEN_BASE
            });
         }
         this.tfError.textColor = param2;
         this.tfError.text = param1;
      }
      
      private function handleLoginClick(param1:MouseEvent) : void
      {
         this._controller.attemptLogin(this.tfUsername.text,this.tfPassword.text,this.mcRememberMe.isSelected);
      }
      
      private function handleLoginCredentialChange(param1:Event) : void
      {
         this._controller.updateLoginCredentials(this.tfUsername.text,this.tfPassword.text);
      }
      
      public function handleLoginVersionReceived(param1:String) : void
      {
         this.tfVersion.text = param1;
      }
      
      public function handleLoginError() : void
      {
         this._controller.updateLoginCredentials(this.tfUsername.text,this.tfPassword.text);
      }
   }
}

