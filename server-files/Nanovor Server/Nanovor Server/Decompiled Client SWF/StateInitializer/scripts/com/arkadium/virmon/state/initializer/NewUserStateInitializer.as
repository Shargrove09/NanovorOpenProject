package com.arkadium.virmon.state.initializer
{
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.newuserexperience.INewUserState;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.shared.data.PlayerFactory;
   import com.arkadium.virmon.state.IState;
   
   public class NewUserStateInitializer
   {
      
      private var _state:INewUserState;
      
      public function NewUserStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as INewUserState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as INewUserState");
         }
      }
      
      public function initialize() : void
      {
         var _loc1_:INanovorFactory = new NanovorFactory(DataManager.getInstance().getVirmonManager());
         this._state.initialize(Managers.soundManager,new PlayerFactory(_loc1_,UserProfile.getInstance()),_loc1_,UserProfile.getInstance(),Managers.assetRetrieverManager.masterDataAssetRetriever,Managers.assetRetrieverManager.overlayAssetRetriever,Managers.assetRetrieverManager.characterAssetRetriever,Managers.widgetManager,DataManager.getInstance().getVirmonManager(),Managers.stateManager);
      }
   }
}

