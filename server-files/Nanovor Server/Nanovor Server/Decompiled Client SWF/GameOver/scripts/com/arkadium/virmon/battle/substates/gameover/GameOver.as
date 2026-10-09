package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.battle.IBattleExiter;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.common.UserProfileEvent;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.events.SpotlightEvent;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GameOver extends MovieClip implements IGameOver
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = false;
      
      private var _battleExiter:IBattleExiter;
      
      private var _placementOrder:Array;
      
      private var _myPlayer:IPlayer;
      
      private var _showNMP:Boolean;
      
      public var mcBadgeHeader:MovieClip;
      
      public var mcVictory:MovieClip;
      
      private var _columns:Array = new Array();
      
      private var _userProfile:UserProfile;
      
      public var placement3rd:MovieClip;
      
      private var _gameOverInfo:GameOverInfo;
      
      public var placement4th:MovieClip;
      
      private var _gameOverSlotColumnBadges:GameOverSlotColumnBadges;
      
      private var _showBadges:Boolean;
      
      public var mcSelectionSpinner:MovieClip;
      
      private var _remainingPlayers:int;
      
      private var _roundControllerNanovorChooser:IRoundControllerNanovorChooser;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _spotlights:Array;
      
      private var _mySpotlight:Spotlight;
      
      private var _playerBadgesPreBattle:Array;
      
      public var placement1st:MovieClip;
      
      private var _myNMP:int;
      
      public var placement2nd:MovieClip;
      
      private var _playerBadgesPostBattle:Array;
      
      private var _badgeManager:IBadgeManager;
      
      private var _activeOverlay:MovieClip;
      
      public var mcDefeat:MovieClip;
      
      private var _soundManager:ISoundManager;
      
      public function GameOver()
      {
         super();
         placement1st.visible = false;
         placement2nd.visible = false;
         placement3rd.visible = false;
         placement4th.visible = false;
         mcSelectionSpinner.useHandCursor = true;
         mcSelectionSpinner.buttonMode = true;
         mcSelectionSpinner.visible = false;
         mcVictory.visible = false;
         mcDefeat.visible = false;
         mcVictory.stop();
         mcDefeat.stop();
         mcBadgeHeader.visible = false;
      }
      
      public function destroy() : void
      {
         mcSelectionSpinner.removeEventListener(MouseEvent.CLICK,handleSpinnerExitBattleClick);
         if(null != _gameOverSlotColumnBadges)
         {
            _gameOverSlotColumnBadges.destroy();
         }
         _columns = null;
         _placementOrder = null;
         _mySpotlight = null;
         _spotlights = null;
         _myPlayer = null;
         _userProfile = null;
         _gameOverInfo = null;
         _playerBadgesPreBattle = null;
         _playerBadgesPostBattle = null;
         _badgeManager = null;
         _battleExiter = null;
         Utils.clearAllChildren(this);
      }
      
      private function onSelectionSpinnerClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(!_showBadges)
         {
            _battleExiter.exitBattle();
            return;
         }
         _activeOverlay.removeEventListener(Event.COMPLETE,onOverlayComplete);
         mcSelectionSpinner.removeEventListener(MouseEvent.CLICK,onSelectionSpinnerClick);
         Tweener.addTween(mcSelectionSpinner,{
            "alpha":0,
            "time":2,
            "onComplete":moveSelectionSpinner
         });
         var _loc3_:int = int(_columns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_columns[_loc2_].spotlight != _mySpotlight)
            {
               _columns[_loc2_].spotlight.close();
            }
            if(_loc2_ == 0)
            {
               _columns[_loc2_].addEventListener(GameOverSlotColumnEvent.COLUMN_CLOSED,onColumnClosed);
            }
            _columns[_loc2_].close();
            _loc2_++;
         }
         Tweener.addTween(_activeOverlay,{
            "_autoAlpha":0,
            "time":1,
            "onComplete":_activeOverlay.gotoAndStop,
            "onCompleteParams":[_activeOverlay.totalFrames]
         });
      }
      
      public function init(param1:INanovorFactory, param2:ISoundManager, param3:IRoundControllerNanovorChooser, param4:IBattleExiter, param5:Array, param6:GameOverInfo, param7:IPlayer, param8:int = 0, param9:Boolean = true, param10:Boolean = true) : void
      {
         _nanovorFactory = param1;
         _soundManager = param2;
         _roundControllerNanovorChooser = param3;
         _battleExiter = param4;
         _myPlayer = param7;
         _myNMP = param8;
         _showBadges = param9;
         _showNMP = param10;
         _userProfile = UserProfile.getInstance();
         _userProfile.addEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUserProfileLoadComplete,false,0,true);
         _userProfile.addEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onUserProfileLoadFailure,false,0,true);
         _userProfile.retrieveProfileData(true);
         _spotlights = param5;
         _gameOverInfo = param6;
         _badgeManager = DataManager.getInstance().getBadgeManager();
         _playerBadgesPreBattle = _badgeManager.getUserBadgeList();
      }
      
      private function onPlayerBadgesLoaded(param1:FrameWorkEvent) : void
      {
         _badgeManager.removeEventListener(FrameWorkEvent.BM_ACCOUNT_BADGES_UPDATED,onPlayerBadgesLoaded);
         _playerBadgesPostBattle = _badgeManager.getUserBadgeList();
         log("BADGES POST BATTLE: " + _playerBadgesPostBattle.length);
         initBadgesColumn();
      }
      
      private function createSpotlightsAndColumns(param1:Array, param2:GameOverInfo) : void
      {
         var _loc3_:GameOverSlotColumn = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _placementOrder = param2.getPlacementIndexes();
         var _loc6_:int = param2.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc5_ == 0)
            {
               _mySpotlight = param1[_loc5_];
               _loc3_ = new GameOverSlotColumn(param1[_loc5_],false);
            }
            else
            {
               _loc3_ = new GameOverSlotColumn(param1[_loc5_],true);
            }
            _loc3_.addSlot(param2.getDamageByIndex(_loc5_).toString() + " DAMAGE DEALT");
            _loc3_.addSlot(param2.getKillsByIndex(_loc5_).toString() + " KILLS");
            if(_showNMP)
            {
               _loc3_.addSlot("+" + param2.getUserNMPDiffByIndex(_loc5_) + " NMP");
            }
            _loc3_.x = param1[_loc5_].x;
            _loc3_.y = param1[_loc5_].y;
            this.addChild(_loc3_);
            _loc4_ = param2.getPlacementByIndex(_loc5_);
            DebugLog.instance.log(_loc4_ + " place");
            _loc3_.placementPosition = 4 - param2.length + (_loc4_ - 1);
            if(_loc4_ > param2.length)
            {
               _loc3_.placementPosition = 3;
            }
            switch(_loc4_)
            {
               case 1:
                  _loc3_.placementImage = placement1st;
                  break;
               case 2:
                  _loc3_.placementImage = placement2nd;
                  break;
               case 3:
                  _loc3_.placementImage = placement3rd;
                  break;
               case 4:
                  _loc3_.placementImage = placement4th;
            }
            if(param2.getPlacementByIndex(_loc5_) == -1)
            {
               _loc3_.visible = false;
            }
            _columns.push(_loc3_);
            _loc5_++;
         }
      }
      
      private function onLastSpotlightOpened(param1:SpotlightEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Spotlight = param1.target as Spotlight;
         _loc2_.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onLastSpotlightOpened);
         var _loc4_:int = int(_columns.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            Tweener.addCaller(this,{
               "onComplete":_columns[_loc3_].cascadeOpenSlots,
               "time":0,
               "delay":0.25,
               "count":1
            });
            _loc3_++;
         }
         showNextButton();
      }
      
      private function startWinLoseChain() : void
      {
         var _loc1_:int = 0;
         _remainingPlayers = _placementOrder.length;
         var _loc2_:int = _remainingPlayers;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _columns[_placementOrder[_loc1_]].addEventListener(GameOverSlotColumnEvent.COLUMN_PLACEMENT_OPENED,onPlacementOpened);
            Tweener.addCaller(this,{
               "onComplete":_columns[_placementOrder[_loc1_]].openPlacement,
               "delay":0.25 * _loc1_,
               "count":1,
               "time":0
            });
            _loc1_++;
         }
      }
      
      private function handleSpinnerExitBattleClick(param1:MouseEvent) : void
      {
         _battleExiter.exitBattle();
      }
      
      private function onOverlayComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         _activeOverlay.removeEventListener(Event.COMPLETE,onOverlayComplete);
         var _loc3_:int = int(_columns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _columns[_loc2_].slidePlacement();
            _loc2_++;
         }
      }
      
      private function onUserProfileLoadFailure(param1:Event) : void
      {
         throw new Error("UserProfile failed to load");
      }
      
      private function onPlacementOpened(param1:GameOverSlotColumnEvent) : void
      {
         var _loc2_:GameOverSlotColumn = param1.currentTarget as GameOverSlotColumn;
         _loc2_.removeEventListener(GameOverSlotColumnEvent.COLUMN_PLACEMENT_OPENED,onPlacementOpened);
         --_remainingPlayers;
         if(_remainingPlayers == 0)
         {
            _loc2_.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onLastSpotlightOpened);
         }
         _loc2_.spotlight.open();
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<GameOver>>\t" + param1);
         }
      }
      
      private function initBadgesColumn() : void
      {
         log("Initializing BadgesColumn");
         mcBadgeHeader.alpha = 0;
         mcBadgeHeader.visible = true;
         Tweener.addTween(mcBadgeHeader,{
            "alpha":1,
            "time":2
         });
         _gameOverSlotColumnBadges.init(_playerBadgesPreBattle,_playerBadgesPostBattle);
         _gameOverSlotColumnBadges.visible = true;
         _gameOverSlotColumnBadges.open();
      }
      
      private function showNextButton() : void
      {
         mcSelectionSpinner.alpha = 0;
         mcSelectionSpinner.visible = true;
         mcSelectionSpinner.x = _mySpotlight.x + GameOverSlot.WIDTH / 2;
         mcSelectionSpinner.y = _mySpotlight.y + 390;
         Tweener.addTween(mcSelectionSpinner,{
            "delay":1,
            "alpha":1,
            "time":2
         });
      }
      
      private function onUserProfileLoadComplete(param1:Event) : void
      {
         _userProfile.removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onUserProfileLoadComplete);
         _userProfile.removeEventListener(UserProfileEvent.LOAD_ERROR_EVENT,onUserProfileLoadFailure);
         if(_gameOverInfo.isWinner)
         {
            _activeOverlay = mcVictory;
            Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_GameOver_WinnerReveal",true,SoundManagerConst.soundApplicationDomain));
         }
         else
         {
            _activeOverlay = mcDefeat;
            _activeOverlay.addEventListener("WIPE_UP_START",onDefeatWipeUpStart,false,0,true);
            Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_GameOver_LoserReveal_Alt1",true,SoundManagerConst.soundApplicationDomain));
         }
         _activeOverlay.addEventListener(Event.COMPLETE,onOverlayComplete);
         _activeOverlay.visible = true;
         _activeOverlay.gotoAndPlay(1);
         createSpotlightsAndColumns(_spotlights,_gameOverInfo);
         if(_showBadges)
         {
            createGameOverSlotColumnBadges();
         }
         Tweener.addCaller(this,{
            "onComplete":startWinLoseChain,
            "time":0,
            "count":1,
            "delay":1
         });
         mcSelectionSpinner.addEventListener(MouseEvent.CLICK,onSelectionSpinnerClick);
         this.setChildIndex(mcSelectionSpinner,this.numChildren - 1);
         if(Managers.stateManager.state != StateType.SENSEI_BATTLE.name)
         {
            Managers.analyticsManager.trackView(View.BATTLE_GAMEOVER_PLACES);
         }
      }
      
      private function createGameOverSlotColumnBadges() : void
      {
         _gameOverSlotColumnBadges = new GameOverSlotColumnBadges(_nanovorFactory,_soundManager,_roundControllerNanovorChooser,_myPlayer);
         _gameOverSlotColumnBadges.visible = false;
         _gameOverSlotColumnBadges.x = _mySpotlight.x;
         _gameOverSlotColumnBadges.y = _mySpotlight.y;
         this.addChild(_gameOverSlotColumnBadges);
      }
      
      private function moveSelectionSpinner() : void
      {
         mcSelectionSpinner.x = 920;
         mcSelectionSpinner.y = 630;
         mcSelectionSpinner.alpha = 0;
         Tweener.addTween(mcSelectionSpinner,{
            "alpha":1,
            "time":3
         });
         mcSelectionSpinner.addEventListener(MouseEvent.CLICK,handleSpinnerExitBattleClick);
      }
      
      private function onDefeatWipeUpStart(param1:Event) : void
      {
         param1.target.removeEventListener("WIPE_UP_START",onDefeatWipeUpStart);
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_GameOver_LoserWipeUp",true,SoundManagerConst.soundApplicationDomain));
      }
      
      private function onColumnClosed(param1:GameOverSlotColumnEvent) : void
      {
         param1.target.removeEventListener(GameOverSlotColumnEvent.COLUMN_CLOSED,onColumnClosed);
         _badgeManager.addEventListener(FrameWorkEvent.BM_ACCOUNT_BADGES_UPDATED,onPlayerBadgesLoaded,false,0,true);
         _badgeManager.loadAndParseAccountBadges();
         Managers.analyticsManager.trackView(View.BATTLE_GAMEOVER_BADGES);
      }
   }
}

