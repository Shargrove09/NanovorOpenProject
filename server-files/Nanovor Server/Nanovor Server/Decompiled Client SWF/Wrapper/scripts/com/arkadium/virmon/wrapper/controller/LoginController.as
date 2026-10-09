package com.arkadium.virmon.wrapper.controller
{
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.loginpanel.IWaitPanel;
   import com.arkadium.virmon.wrapper.model.ILoginModel;
   import com.arkadium.virmon.wrapper.model.ILoginPanelLoadedHandler;
   
   public class LoginController implements ILoginController, ILoginPanelLoadedHandler
   {
      
      private var _model:ILoginModel;
      
      public function LoginController(param1:ILoginModel)
      {
         super();
         _model = param1;
         _model.addLoginPanelLoadedHandler(ILoginPanelLoadedHandler(this));
      }
      
      public function loadLoginPanel() : void
      {
         _model.loadLoginPanel();
      }
      
      public function login(param1:String, param2:String, param3:String) : void
      {
         _model.login(param1,param2,param3);
      }
      
      public function handleLoginPanelLoaded(param1:ILoginPanel, param2:IWaitPanel) : void
      {
         _model.initializeServiceRequestBroker();
      }
   }
}

