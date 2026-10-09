package com.arkadium.virmon.battle.substates.combatgame
{
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.CRef;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.battle.substates.combatgame.animation.CAnimation;
   import com.arkadium.virmon.battle.substates.combatgame.attackchooser.AttackChooser;
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOverData;
   import com.arkadium.virmon.battle.substates.gameover.GameOverInfo;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.framework.memorywatcher.MemoryWatcher;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class CombatGamePanel extends Sprite implements ICombatGamePanel
   {
      
      public static const _SPOTLIGHT_POINTS_2PLAYER:Array = [61,543];
      
      public static const _SPOTLIGHT_POINTS_3PLAYER:Array = [61,427,784];
      
      public static const _SPOTLIGHT_POINTS_4PLAYER:Array = [61,302,543,784];
      
      public static const _SPOTLIGHT_POINT_Y:Number = 100;
      
      private var _battleHeaderController:IBattleHeaderController;
      
      private var _gameOverInfo:GameOverInfo;
      
      private var _cAnim:CAnimation;
      
      public var spPlayerWidgetContainer:Sprite;
      
      public var spMoviePlayerMask:Sprite;
      
      private var _aSpotlights:Array;
      
      public var spAttackChooserContainer:Sprite;
      
      private var _userProfile:IUserProfile;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      public var spSpotlightContainer:Sprite;
      
      public var spMoviePlayerContainer:Sprite;
      
      private var _attackChooserTimeoutSeconds:int;
      
      private var _attackChooser:AttackChooser;
      
      private var _consumer:ICombatGamePanelConsumer;
      
      public var spGameOverContainer:Sprite;
      
      private var _combatUIController:CombatUIController;
      
      private var _soundManager:ISoundManager;
      
      public function CombatGamePanel()
      {
         super();
         _aSpotlights = new Array();
         _attackChooserTimeoutSeconds = 60;
      }
      
      private function checkIfLose() : Boolean
      {
         var _loc2_:IPlayer = null;
         var _loc1_:int = 0;
         if(_combatUIController == null || _combatUIController.players == null || _combatUIController.players.length < 3 || _combatUIController.WatchAccepted)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _combatUIController.players.length)
         {
            _loc2_ = _combatUIController.players[_loc3_];
            if(!_loc2_.leftGame && _loc2_.userRefId != _userProfile.id)
            {
               _loc1_++;
            }
            _loc3_++;
         }
         if(_loc1_ > 1 && !hasAnotherLiveNanovor() && _combatUIController.myPlayer.selectedNanovor.health <= 0)
         {
            return true;
         }
         return false;
      }
      
      public function get animation() : CAnimation
      {
         return _cAnim;
      }
      
      public function readyForTurnSelection() : void
      {
         log("%%% readyForTurnSelection");
         _attackChooser.updatePickers();
         if(_attackChooser.bringIn())
         {
            if(Managers.stateManager.state == StateType.SENSEI_BATTLE.name)
            {
               Managers.analyticsManager.trackView(View.SENSEI_ATTACK_CHOOSER);
            }
            else
            {
               Managers.analyticsManager.trackView(View.BATTLE_ATTACK_CHOOSER);
            }
         }
      }
      
      private function showGameOverMessage() : void
      {
         log("showGameOverMessage()");
         _combatUIController.updateUIState(true);
         if(Boolean(_attackChooser))
         {
            _attackChooser.addEventListener(AttackChooser.BRING_OUT_COMPLETE,onBringOutComplete_destroyAttackChooser,false,0,true);
            _attackChooser.bringOut();
         }
         makeSpotlights();
         var _loc1_:BattleSubStateGameOverData = new BattleSubStateGameOverData(_aSpotlights,_gameOverInfo,_combatUIController.myPlayer,_userProfile.nmp);
         _consumer.handleGameOver(_loc1_);
      }
      
      public function init(param1:ISoundManager, param2:IPlayerFactory, param3:IBattleGameService, param4:IBattleData, param5:ICombatGamePanelConsumer, param6:Array, param7:IBattleHeaderController, param8:IUserProfile, param9:IBuddyRPManager, param10:ICharacterAssetTypeCache, param11:IOverlayAssetRetriever) : void
      {
         log("init()");
         _soundManager = param1;
         _consumer = param5;
         _battleHeaderController = param7;
         _buddyRPManager = param9;
         _attackChooserTimeoutSeconds = param4.combatTimeout;
         spMoviePlayerMask.cacheAsBitmap = true;
         spMoviePlayerContainer.cacheAsBitmap = true;
         spMoviePlayerContainer.mask = spMoviePlayerMask;
         _cAnim = new CAnimation(param10,param11);
         _userProfile = param8;
         CRef.setBattleRef(this);
         _combatUIController = new CombatUIController(param2,this,param3,param4,_battleHeaderController,param10,param11);
         _combatUIController.init(_userProfile.id,param6);
         _combatUIController.readyForTurn();
         MemoryWatcher.registerObject(_combatUIController,"CombatUIController");
      }
      
      public function destroy() : void
      {
         if(null != _combatUIController)
         {
            _combatUIController.destroy();
            _combatUIController = null;
         }
         if(Boolean(_cAnim))
         {
            _cAnim.clearBattle();
            _cAnim.removeEventListener(CAnimation.ON_TURN_COMPLETE,onAnimationComplete);
            _cAnim = null;
         }
         if(null != _attackChooser)
         {
            _attackChooser.destroy();
            _attackChooser.removeEventListener(AttackChooser.BRING_OUT_COMPLETE,onBringOutComplete_destroyAttackChooser);
            _attackChooser = null;
         }
         if(null != _cAnim && _cAnim.hasEventListener(CAnimation.ON_TURN_COMPLETE))
         {
            log("::closePanel --> removing ON_TURN_COMPLETE<onAnimationComplete> listener from _cAnim: " + _cAnim);
            _cAnim.removeEventListener(CAnimation.ON_TURN_COMPLETE,onAnimationComplete);
            _cAnim.clearBattle();
         }
         CRef.setBattleRef(null);
         CRef.battleController = null;
         CRef.combatUIController = null;
         CRef.roundController = null;
         _consumer = null;
         _battleHeaderController = null;
         _gameOverInfo = null;
         _userProfile = null;
         _buddyRPManager = null;
      }
      
      private function loadAnimationComplete(param1:Event) : *
      {
         log("CombatGamePanel::loadAnimationComplete  fma");
         param1.target.removeEventListener(CAnimation.ON_LOAD,loadAnimationComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,loadAnimationComplete);
         _cAnim.removeEventListener(CAnimation.ON_LOAD,loadAnimationComplete);
         _cAnim.addEventListener(CAnimation.ON_TURN_COMPLETE,onAnimationComplete,false,0,true);
         _combatUIController.battleController.roundController.preloadMoviePlayer();
      }
      
      public function initializeAttackChooser() : void
      {
         log("initializeAttackChooser()");
         makeSpotlights();
         if(Boolean(_attackChooser))
         {
            _attackChooser.destroy();
         }
         _attackChooser = new AttackChooser(_soundManager,_combatUIController,_aSpotlights,_attackChooserTimeoutSeconds);
         MemoryWatcher.registerObject(_attackChooser,"AttackChooser");
         spAttackChooserContainer.addChild(_attackChooser);
         _combatUIController.battleController.roundController.initAnimation(spMoviePlayerContainer,loadAnimationComplete);
         log("CombatGamePanel::initAnimation -- adding listener (ON_LOAD) to call loadAnimationComplete fma");
         _cAnim.addEventListener(CAnimation.ON_LOAD,loadAnimationComplete,false,0,true);
      }
      
      public function getPlayerIndexById(param1:int) : int
      {
         var _loc2_:IPlayer = null;
         var _loc3_:int = 0;
         while(_loc3_ < _combatUIController.players.length)
         {
            _loc2_ = _combatUIController.players[_loc3_];
            if(_loc2_.userRefId == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function makeSpotlights() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Spotlight = null;
         if(_aSpotlights.length > 0)
         {
            return;
         }
         switch(_combatUIController.players.length)
         {
            case 2:
               _loc1_ = _SPOTLIGHT_POINTS_2PLAYER;
               break;
            case 3:
               _loc1_ = _SPOTLIGHT_POINTS_3PLAYER;
               break;
            case 4:
               _loc1_ = _SPOTLIGHT_POINTS_4PLAYER;
               break;
            default:
               logError("initializeAttackChooser -- unexpected number of players!!!");
               return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _combatUIController.players.length)
         {
            _loc2_ = new Spotlight();
            _loc2_.y = _SPOTLIGHT_POINT_Y;
            _loc2_.x = _loc1_[_loc3_];
            spSpotlightContainer.addChild(_loc2_);
            _aSpotlights.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function hideAttackChooser() : void
      {
         _attackChooser.bringOut();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<CombatGamePanel>>\t" + param1);
      }
      
      private function onAnimationComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:IPlayer = null;
         if(null == _gameOverInfo)
         {
            if(!_combatUIController)
            {
               logError("closeCurtain(): NO CONTROL");
               return;
            }
            if(!_combatUIController.battleController)
            {
               logError("closeCurtain(): NO BATTLE CONTROLLER");
               return;
            }
            if(!_combatUIController.battleController.players)
            {
               logError("closeCurtain(): NO PLAYERS");
               return;
            }
            _loc2_ = 0;
            for each(_loc3_ in _combatUIController.battleController.players)
            {
               if(!_loc3_.isDead)
               {
                  _loc2_++;
               }
            }
            _combatUIController.onCurtainClosed();
            if(checkIfLose() && _loc2_ >= 2)
            {
               CommonDialogBox.MakeAndQueue("confirm","You lost!","Do you want to continue watching?",0,_combatUIController.onAcceptWatch,_combatUIController.onDeclineWatch,_combatUIController.onDeclineWatch);
            }
         }
         else
         {
            log("onAnimationComplete() - Animation not playing, showing GameOver");
            showGameOverMessage();
         }
      }
      
      public function get roundControllerNanovorChooser() : IRoundControllerNanovorChooser
      {
         return _combatUIController.roundControllerNanovorChooser;
      }
      
      public function onAcceptWatch() : void
      {
         _attackChooser.destroy();
         _attackChooser.removeEventListener(AttackChooser.BRING_OUT_COMPLETE,onBringOutComplete_destroyAttackChooser);
      }
      
      private function hasAnotherLiveNanovor() : Boolean
      {
         var _loc1_:INanovor = null;
         var _loc2_:uint = 0;
         while(_loc2_ < _combatUIController.myPlayer.swarm.length)
         {
            _loc1_ = _combatUIController.myPlayer.swarm[_loc2_];
            if(_loc1_ != null && _loc1_ != _combatUIController.myPlayer.selectedNanovor && !_loc1_.isDead)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function onBringOutComplete_destroyAttackChooser(param1:Event) : void
      {
         _attackChooser.removeEventListener(AttackChooser.BRING_OUT_COMPLETE,onBringOutComplete_destroyAttackChooser);
         _attackChooser.destroy();
         _attackChooser = null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<CombatGamePanel>>\t" + param1);
      }
      
      public function gameOver(param1:int, param2:Object) : void
      {
         log("gameOver()");
         _gameOverInfo = new GameOverInfo(_combatUIController.players,Boolean(param1 == _combatUIController.myPlayer.userRefId),param2 as Array);
         if(null == _attackChooser || false == _combatUIController.oneRoundCompleted)
         {
            _consumer.handleGameOver(null);
            return;
         }
         _battleHeaderController.updateAllAvatarsAndNMPs();
         if(!_combatUIController.isAnimationPlaying)
         {
            showGameOverMessage();
         }
      }
      
      public function opponentLeaveGame(param1:uint) : void
      {
         var _loc2_:IBuddyData = null;
         var _loc3_:String = null;
         var _loc4_:CommonDialogBox = null;
         if(null == _gameOverInfo)
         {
            _loc2_ = _buddyRPManager.getBuddy(param1);
            if(_loc2_ !== null)
            {
               if(_loc2_.Status > -1)
               {
                  _loc3_ = "User " + _loc2_.Name.toUpperCase() + " has left the game.";
               }
               else
               {
                  _loc3_ = "User " + _loc2_.Name.toUpperCase() + " has left the game, and has gone offline.";
               }
               _loc4_ = CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Player Left Battle",_loc3_,10,null,null,null,CommonDialogBox.GenericTimeoutKill);
            }
            else
            {
               logError("opponentLeaveGame: buddy with uid [" + param1 + "] was not found in BuddyRPManager, so no dialog box was queued/forced!");
            }
         }
         _battleHeaderController.playerLeftBattle(int(param1));
      }
      
      public function onDeclineWatch() : void
      {
         _consumer.handleGameOver(null);
      }
   }
}

