package com.arkadium.virmon.loginpanel.login.controller
{
   import com.arkadium.virmon.loginpanel.login.model.ILoginPanelLoginModel;
   
   public class LoginPanelLoginController implements ILoginPanelLoginController
   {
      
      private var _model:ILoginPanelLoginModel;
      
      public function LoginPanelLoginController(param1:ILoginPanelLoginModel)
      {
         super();
         this._model = param1;
      }
      
      public function attemptLogin(param1:String, param2:String, param3:Boolean) : void
      {
         this._model.attemptLogin(param1,param2,param3);
      }
      
      public function updateShardIndex(param1:int) : void
      {
         this._model.updateShardIndex(param1);
      }
      
      public function handleGotoForgotPassword() : void
      {
         this._model.handleGotoForgotPassword();
      }
      
      public function handleGotoNewAccount() : void
      {
         this._model.handleGotoNewAccount();
      }
      
      public function updateLoginCredentials(param1:String, param2:String) : void
      {
         this._model.updateLoginCredentials(param1,param2);
      }
   }
}

