package com.arkadium.virmon.newuserexperience
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   
   public interface INewUserState
   {
      
      function initialize(param1:ISoundManager, param2:IPlayerFactory, param3:INanovorFactory, param4:IUserProfile, param5:IMasterDataAssetRetriever, param6:IOverlayAssetRetriever, param7:ICharacterAssetRetriever, param8:IWidgetManager, param9:IVirmonManager, param10:IStateManager) : void;
   }
}

