package com.arkadium.virmon.state.initializer
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.home.IHomeNewsBlocker;
   import com.arkadium.virmon.home.IHomeState;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   
   internal class HomeStateInitializer
   {
      
      private var _state:IHomeState;
      
      public function HomeStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as IHomeState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as IHomeState");
         }
      }
      
      public function initialize(param1:IApplicationExiter) : void
      {
         this._state.initialize(UserProfile.getInstance(),GameServiceProvider.getInstance().battleGameService,GameServiceProvider.getInstance().chatGameService,param1,Managers.stateManager,Managers.dialogManager as IHomeNewsBlocker,Managers.widgetManager,Managers.breadcrumbProgressManager,Managers.mdmManager,Managers.assetRetrieverManager.masterDataAssetRetriever,Managers.analyticsManager,Managers.webClientManager,new NanovorFactory(DataManager.getInstance().getVirmonManager()));
         Managers.homeBreadcrumbUIManager = this._state as IHomeBreadcrumbUIManager;
      }
   }
}

