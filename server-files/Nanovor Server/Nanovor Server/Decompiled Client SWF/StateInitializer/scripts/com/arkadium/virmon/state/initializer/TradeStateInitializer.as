package com.arkadium.virmon.state.initializer
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.state.IState;
   import com.arkadium.virmon.trade.ITradeState;
   
   internal class TradeStateInitializer
   {
      
      private var _state:ITradeState;
      
      public function TradeStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as ITradeState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as ITradeState");
         }
      }
      
      public function initialize() : void
      {
         this._state.initialize(Managers.analyticsManager,UserProfile.getInstance(),DataManager.getInstance(),Managers.assetRetrieverManager.emAssetRetriever,Managers.assetRetrieverManager.characterAssetRetriever,Managers.stateManager,Managers.widgetManager,Managers.permissionsManager,GameServiceProvider.getInstance().tradeGameService,Managers.soundManager,Managers.buddyManager,Managers.buddyRPManager);
      }
   }
}

