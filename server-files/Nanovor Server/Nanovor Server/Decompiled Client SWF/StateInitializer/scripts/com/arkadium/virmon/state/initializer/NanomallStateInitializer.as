package com.arkadium.virmon.state.initializer
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.nanomall.INanomallState;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.state.IState;
   
   public class NanomallStateInitializer
   {
      
      private var _state:INanomallState;
      
      public function NanomallStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as INanomallState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as INanomallState");
         }
      }
      
      public function initialize() : void
      {
         this._state.initialize(UserProfile.getInstance(),Managers.analyticsManager,Managers.buyNanocashUIManager,Managers.stateManager,Managers.widgetManager,Managers.serviceRequestBrokerManager,Managers.assetRetrieverManager.boosterAssetRetriever,GameServiceProvider.getInstance().userGameService,DataManager.getInstance().getVirmonManager(),Managers.assetRetrieverManager.characterAssetRetriever,DataManager.getInstance().getEMManager(),Managers.assetRetrieverManager.emAssetRetriever);
      }
   }
}

