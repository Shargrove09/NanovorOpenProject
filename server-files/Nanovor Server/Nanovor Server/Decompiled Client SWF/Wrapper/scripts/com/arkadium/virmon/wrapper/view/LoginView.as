package com.arkadium.virmon.wrapper.view
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.IVersionDataProvider;
   import com.arkadium.communications.ServiceRequestBrokerNoActionMessageParser;
   import com.arkadium.communications.handlers.IServiceRequestBrokerCompleteHandler;
   import com.arkadium.communications.handlers.IServiceRequestBrokerHandler;
   import com.arkadium.virmon.common.AbstractCompositeView;
   import com.arkadium.virmon.common.IComponentView;
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.loginpanel.IWaitPanel;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.wrapper.controller.ILoginController;
   import com.arkadium.virmon.wrapper.model.ILoginModel;
   import com.arkadium.virmon.wrapper.model.ILoginPanelLoadedHandler;
   import com.arkadium.virmon.wrapper.model.IShardListReceivedHandler;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class LoginView extends AbstractCompositeView implements ILoginSubmitHandler, ILoginPanelLoadedHandler, IServiceRequestBrokerHandler, IShardListReceivedHandler
   {
      
      private var _model:ILoginModel;
      
      private var _loginPanel:ILoginPanel;
      
      private var _controller:ILoginController;
      
      public function LoginView(param1:ILoginModel, param2:ILoginController)
      {
         super();
         _model = param1;
         _controller = param2;
         _model.addLoginPanelLoadedHandler(ILoginPanelLoadedHandler(this));
         _model.addShardListReceivedHandler(IShardListReceivedHandler(this));
         _model.addServiceRequestBrokerHandler(IServiceRequestBrokerHandler(this));
      }
      
      public function handleServiceRequestBrokerRefresh(param1:Boolean) : void
      {
         if(param1)
         {
            _loginPanel.addStatusMessage("You must update the client!");
         }
         else
         {
            _loginPanel.addStatusMessage("You must update the client.  Please login as an Administrator to update.");
         }
      }
      
      public function handleServiceRequestBrokerComplete() : void
      {
         var _loc1_:IServiceRequestBrokerCompleteHandler = null;
         log("handleServiceRequestBrokerComplete()");
         _loginPanel.handleSRBConnected();
         DebugLog.instance.setUsername(_loginPanel.userName);
         for each(_loc1_ in getChildrenOfType(IServiceRequestBrokerCompleteHandler))
         {
            _loc1_.handleServiceRequestBrokerComplete();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<LoginView>> " + param1);
      }
      
      public function handleShardListRecievedHandler(param1:Array) : void
      {
         _loginPanel.renderShardList(param1);
      }
      
      public function handleLoginPanelLoaded(param1:ILoginPanel, param2:IWaitPanel) : void
      {
         var _loc3_:IComponentView = null;
         _loginPanel = param1;
         addChild(_loginPanel.sprite);
         for each(_loc3_ in getChildrenOfType(ILoginPanelLoadedHandler))
         {
            ILoginPanelLoadedHandler(_loc3_).handleLoginPanelLoaded(param1,param2);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(null != parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function handleServiceRequestBrokerInitialized(param1:IVersionDataProvider) : void
      {
         log("handleServiceRequestBrokerInitialized()");
         _loginPanel.renderVersionInfo(param1);
         _loginPanel.handleSRBInitialized();
      }
      
      private function handleSRBLoginFailure(param1:String = "") : void
      {
         log("handleSRBLoginFailure() responseString=" + param1);
         switch(new ServiceRequestBrokerNoActionMessageParser(param1,_loginPanel).parse())
         {
            case ServiceRequestBrokerNoActionMessageParser.REASON_BAD_USER_PASS:
               Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_BAD_USER_PASS);
               break;
            case ServiceRequestBrokerNoActionMessageParser.REASON_EMPTY_USER_PASS:
               Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_EMPTY_USER_PASS);
               break;
            case ServiceRequestBrokerNoActionMessageParser.REASON_ACCOUNT_DISABLED:
               Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_ACCT_DISABLED);
               break;
            case ServiceRequestBrokerNoActionMessageParser.REASON_ACCOUNT_NOT_ACTIVATED:
               Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_ACCT_NOT_ACTIVATED);
               break;
            case ServiceRequestBrokerNoActionMessageParser.REASON_GENERIC:
            default:
               Managers.analyticsManager.trackAction(Action.LOGIN_SRB_RESPONSE_FAILED);
         }
         Managers.analyticsManager.trackAction(Action.LOGIN_SRB_LOAD_ERROR);
      }
      
      public function handleLoginSubmit(param1:String, param2:String, param3:String) : void
      {
         _controller.login(param1,param2,param3);
      }
      
      public function handleServiceRequestBrokerNoAction(param1:String) : void
      {
         log("handleServiceRequestBrokerNoAction()");
         handleSRBLoginFailure(param1);
      }
      
      public function handleServiceRequestBrokerError() : void
      {
         log("handleServiceRequestBrokerError()");
         _loginPanel.addStatusMessage("Error loading data from SRB");
         handleSRBLoginFailure();
      }
      
      public function handleServiceRequestBrokerCorruptedSettingsFile() : void
      {
         log("handleServiceRequestBrokerCorruptedSettingsFile()");
         handleSRBLoginFailure();
      }
      
      public function handleServiceRequestBrokerMaintenance(param1:String) : void
      {
         log("handleServiceRequestBrokerMaintenance()");
         _loginPanel.addStatusMessage(param1,"",true);
         _loginPanel.initAfterInvalidLogin();
      }
   }
}

