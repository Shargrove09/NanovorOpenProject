package com.arkadium.virmon.state.initializer
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.device.IDeviceState;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.shared.data.PlayerFactory;
   import com.arkadium.virmon.shared.utils.FileOperator;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.state.IState;
   
   internal class DeviceStateInitializer
   {
      
      private var _state:IDeviceState;
      
      public function DeviceStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as IDeviceState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as IDeviceState");
         }
      }
      
      public function initialize(param1:IDownloader) : void
      {
         var _loc2_:INanovorFactory = new NanovorFactory(DataManager.getInstance().getVirmonManager());
         this._state.initialize(param1,GameServiceProvider.getInstance().chatGameService,UserProfile.getInstance(),_loc2_,new PlayerFactory(_loc2_,UserProfile.getInstance()),Managers.stateManager,DataManager.getInstance(),new FileOperator(Managers.mdmManager),Managers.serviceRequestBrokerManager,Managers.analyticsManager,Managers.assetRetrieverManager.characterAssetRetriever,Managers.widgetManager,Managers.assetManager,Managers.soundManager);
      }
   }
}

