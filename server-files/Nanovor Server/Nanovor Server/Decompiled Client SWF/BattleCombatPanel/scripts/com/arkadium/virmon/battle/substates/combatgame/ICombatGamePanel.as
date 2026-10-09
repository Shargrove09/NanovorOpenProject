package com.arkadium.virmon.battle.substates.combatgame
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   
   public interface ICombatGamePanel
   {
      
      function init(param1:ISoundManager, param2:IPlayerFactory, param3:IBattleGameService, param4:IBattleData, param5:ICombatGamePanelConsumer, param6:Array, param7:IBattleHeaderController, param8:IUserProfile, param9:IBuddyRPManager, param10:ICharacterAssetTypeCache, param11:IOverlayAssetRetriever) : void;
      
      function destroy() : void;
      
      function get roundControllerNanovorChooser() : IRoundControllerNanovorChooser;
   }
}

