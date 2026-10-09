package com.arkadium.virmon.battle.substates.gameover
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleExiter;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class BattleSubStateGameOver extends AbstractSubState implements IChainLoaderConsumer
   {
      
      private static const GAMEOVER_SWF_PATH:String = "GameOver.swf";
      
      private var _roundControllerNanovorChooser:IRoundControllerNanovorChooser;
      
      private var _gameOver:IGameOver;
      
      private var _battleExiter:IBattleExiter;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _uiContainer:DisplayObjectContainer;
      
      private var _showGameOverNMP:Boolean;
      
      private var _gameOverSubStateData:BattleSubStateGameOverData;
      
      private var _battleData:IBattleData;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _showGameOverBadges:Boolean;
      
      private var _chainLoader:ChainLoader;
      
      private var _stateManager:IStateManager;
      
      private var _soundManager:ISoundManager;
      
      public function BattleSubStateGameOver(param1:INanovorFactory, param2:IStateManager, param3:IAnalyticsManager, param4:ISoundManager, param5:IRoundControllerNanovorChooser, param6:DisplayObjectContainer, param7:IBattleExiter, param8:BattleSubStateGameOverData, param9:Boolean, param10:Boolean, param11:IBattleGameService, param12:IBattleData)
      {
         super();
         _nanovorFactory = param1;
         _stateManager = param2;
         _analyticsManager = param3;
         _soundManager = param4;
         _roundControllerNanovorChooser = param5;
         _uiContainer = param6;
         _battleExiter = param7;
         _gameOverSubStateData = param8;
         _showGameOverBadges = param9;
         _showGameOverNMP = param10;
         _battleData = param12;
         param11.quitGame();
      }
      
      public function destroy() : void
      {
         if(null != _chainLoader)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
         if(null != _gameOver)
         {
            _gameOver.destroy();
            _gameOver = null;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleSubStateGameOver>>\t" + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _gameOver = param1.getLoadedAsset(SWFLoadee.NAME + GAMEOVER_SWF_PATH) as IGameOver;
         if(null == _gameOver)
         {
            throw new Error(GAMEOVER_SWF_PATH + " failed to load");
         }
         _chainLoader.destroy();
         _uiContainer.addChild(_gameOver as DisplayObject);
         var _loc2_:Array = _gameOverSubStateData.spotlights;
         var _loc3_:GameOverInfo = _gameOverSubStateData.gameOverInfo;
         var _loc4_:IPlayer = _gameOverSubStateData.myPlayer;
         var _loc5_:int = _gameOverSubStateData.myNMP;
         _gameOver.init(_nanovorFactory,_soundManager,_roundControllerNanovorChooser,_battleExiter,_loc2_,_loc3_,_loc4_,_loc5_,_showGameOverBadges,_showGameOverNMP);
         sendAnalytics();
      }
      
      override public function setSubState() : void
      {
         log("setSubState()");
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(GAMEOVER_SWF_PATH,_loc1_));
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      private function sendAnalytics() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         if(_stateManager.state == StateType.SENSEI_BATTLE.name)
         {
            _loc1_ = "";
            _loc2_ = int(_battleData.battleType);
            if(_gameOverSubStateData.gameOverInfo.isWinner)
            {
               _loc1_ = View.SENSEI_GAMEOVER_WIN.name.replace("%AI_PLAYER_ID%",_loc2_);
            }
            else
            {
               _loc1_ = View.SENSEI_GAMEOVER_LOSE.name.replace("%AI_PLAYER_ID%",_loc2_);
            }
            _analyticsManager.trackView(View.createDynamic(_loc1_));
         }
      }
   }
}

