package com.arkadium.virmon.newuserexperience.substates.solobattle
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.BattleData;
   import com.arkadium.virmon.battle.BattleHeaderController;
   import com.arkadium.virmon.battle.BattlePlayer;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.newuserexperience.substates.NewUserSubStates;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.NewUserSoloBattleSubStateFactory;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.NewUserSoloBattleSubStates;
   import com.arkadium.virmon.senseibattle.IBattleGameServerConsumer;
   import com.arkadium.virmon.senseibattle.IBattleGameServiceHandler;
   import com.arkadium.virmon.senseibattle.SenseiBattleGameService;
   import com.arkadium.virmon.senseibattle.SenseiBattleGameServiceHandler;
   import com.arkadium.virmon.senseibattle.SenseiBattleServerImitator;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAI;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAIFactory;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAIFactoryConsumer;
   import com.arkadium.virmon.senseibattle.ai.PatienceAttackGenerator;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIBattleTracker;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIFactory;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIMoveGenerator;
   import com.arkadium.virmon.senseibattle.battlelogic.BattleLogic;
   import com.arkadium.virmon.senseibattle.battlelogic.IBattleLogic;
   import com.arkadium.virmon.senseibattle.ui.SenseiBattleHeaderAvatarFactory;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.shared.utils.substate.SubStateController;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import flash.display.Sprite;
   
   public class NewUserSubStateBattle extends AbstractSubState implements ISenseiAIFactoryConsumer, INewUserSubStateSoloBattle
   {
      
      private static const DEFAULT_SENSEI_NAME:String = "Unknown";
      
      private static const DEFAULT_SENSEI_ID:int = -5;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _uiContainer:Sprite;
      
      private var _chararacterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _overlayAssetRetriever:IOverlayAssetRetriever;
      
      private var _masterDataAssetRetriever:IMasterDataAssetRetriever;
      
      private var _headerWidget:IHeaderWidget;
      
      private var _userProfile:IUserProfile;
      
      private var _senseiAIFactory:ISenseiAIFactory;
      
      private var _internalSubStateController:SubStateController;
      
      private var _virmonList:Array;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _substateFactory:NewUserSoloBattleSubStateFactory;
      
      private var _soundManager:ISoundManager;
      
      public function NewUserSubStateBattle(param1:ISoundManager, param2:IPlayerFactory, param3:INanovorFactory, param4:Sprite, param5:IUserProfile, param6:IMasterDataAssetRetriever, param7:IOverlayAssetRetriever, param8:ICharacterAssetTypeCache, param9:IHeaderWidget, param10:Array)
      {
         super();
         _soundManager = param1;
         _playerFactory = param2;
         _nanovorFactory = param3;
         _uiContainer = param4;
         _userProfile = param5;
         _masterDataAssetRetriever = param6;
         _overlayAssetRetriever = param7;
         _chararacterAssetTypeCache = param8;
         _headerWidget = param9;
         _virmonList = param10;
      }
      
      override public function setSubState() : void
      {
         _senseiAIFactory = new SenseiAIFactory(_nanovorFactory,_playerFactory,_masterDataAssetRetriever,ISenseiAIFactoryConsumer(this));
      }
      
      public function destroy() : void
      {
         if(null != _substateFactory)
         {
            _substateFactory.destroy();
         }
      }
      
      public function handleSenseiAILoadComplete() : void
      {
         var _loc1_:BattleData = new BattleData(1000,0,0,DEFAULT_SENSEI_ID.toString());
         var _loc2_:BattlePlayer = _loc1_.addPlayer(_userProfile.screenname,_userProfile.id);
         var _loc3_:IPlayer = _playerFactory.createPlayer(_loc2_.playerName,_loc2_.playerId);
         var _loc4_:ISenseiAI = _senseiAIFactory.createAIById(_loc3_,new SenseiAIBattleTracker(),new SenseiAIMoveGenerator(new PatienceAttackGenerator()),DEFAULT_SENSEI_ID);
         _loc1_.addPlayer(_loc4_.getPlayerName(),_loc4_.getPlayerId());
         var _loc5_:SenseiBattleGameServiceHandler = new SenseiBattleGameServiceHandler();
         var _loc6_:IBattleLogic = new BattleLogic(_loc1_,_masterDataAssetRetriever);
         var _loc7_:IBattleGameService = new SenseiBattleGameService(new SenseiBattleServerImitator(_nanovorFactory,_loc4_,_loc1_,_loc6_,IBattleGameServerConsumer(_loc5_)),IBattleGameServiceHandler(_loc5_));
         var _loc8_:IBattleHeaderController = new BattleHeaderController(_headerWidget,null,new SenseiBattleHeaderAvatarFactory());
         _loc8_.setBattleMode(_loc1_,_userProfile.screenname);
         _substateFactory = new NewUserSoloBattleSubStateFactory(_soundManager,_playerFactory,_uiContainer,INewUserSubStateSoloBattle(this),_loc7_,_loc1_,_loc8_,_userProfile,_chararacterAssetTypeCache,_overlayAssetRetriever,_virmonList);
         _internalSubStateController = new SubStateController(_substateFactory);
         _internalSubStateController.changeSubState(NewUserSoloBattleSubStates.SUB_STATE_SWARM_CHOOSER);
      }
      
      public function handleSoloBattleError(param1:String) : void
      {
         _subStateController.changeSubState(NewUserSubStates.NEWUSER_SUBSTATE_ERROR,param1);
      }
      
      public function handleSoloBattleComplete() : void
      {
         _subStateController.changeSubState(NewUserSubStates.NEWUSER_SUBSTATE_COMPLETE);
      }
      
      public function handleSenseiAILoadFailure() : void
      {
         handleSoloBattleError("Failed to load AI players.");
      }
   }
}

