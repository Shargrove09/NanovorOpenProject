package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   
   public class GameOverSlotColumnBadges extends Sprite
   {
      
      private static const TOP_PADDING:int = 100;
      
      private var _roundControllerNanovorChooser:IRoundControllerNanovorChooser;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _player:IPlayer;
      
      private var _playerBadges:GameOverSlotBadges;
      
      private var _slotContainer:Sprite;
      
      private var _currentOpen:Sprite;
      
      private var _yOffset:Number = 0;
      
      private var _nanovorBadges:GameOverSlotNanovors;
      
      private var _soundManager:ISoundManager;
      
      public function GameOverSlotColumnBadges(param1:INanovorFactory, param2:ISoundManager, param3:IRoundControllerNanovorChooser, param4:IPlayer)
      {
         super();
         _nanovorFactory = param1;
         _soundManager = param2;
         _roundControllerNanovorChooser = param3;
         _player = param4;
         _slotContainer = new Sprite();
         _slotContainer.y = TOP_PADDING;
         this.addChild(_slotContainer);
         this.alpha = 0;
         this.visible = false;
         createSliderPlayerBadges();
         createSliderNanovorBadges();
         hideSlots();
      }
      
      public function destroy() : void
      {
         _nanovorBadges.removeEventListener(GameOverSlotColumnEvent.NANOVOR_BADGES_CLICK,onNanovorBadgesClick);
         _playerBadges.removeEventListener(GameOverSlotColumnEvent.PLAYER_BADGES_CLICK,onPlayerBadgesClick);
         _nanovorBadges.destroy();
         _playerBadges.destroy();
      }
      
      public function open() : void
      {
         Tweener.addTween(this,{
            "alpha":1,
            "time":1,
            "onComplete":_playerBadges.open
         });
         _currentOpen = _playerBadges;
         cascadeOpenSlots();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> GameOverSlotColumnBadges: " + param1);
      }
      
      private function createSliderPlayerBadges() : void
      {
         _playerBadges = new GameOverSlotBadges("PLAYER BADGES",910);
         _playerBadges.addEventListener(GameOverSlotColumnEvent.PLAYER_BADGES_CLICK,onPlayerBadgesClick);
         _slotContainer.addChild(_playerBadges);
         _yOffset += GameOverSlotBadges.HEIGHT;
      }
      
      private function onNanovorBadgesClick(param1:GameOverSlotColumnEvent) : void
      {
         if(_currentOpen != _nanovorBadges)
         {
            _nanovorBadges.open();
            if(_currentOpen != null)
            {
               (_currentOpen as GameOverSlotBadges).close();
            }
            _currentOpen = _nanovorBadges;
            return;
         }
         _nanovorBadges.close();
         _currentOpen = null;
      }
      
      private function hideSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = _slotContainer.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Tweener.addTween(_slotContainer.getChildAt(_loc1_),{
               "alpha":0,
               "time":1,
               "delay":0.1 * _loc1_
            });
            _loc1_++;
         }
      }
      
      public function init(param1:Array, param2:Array) : void
      {
         _nanovorBadges.init(_player.swarm);
         populateNewPlayerBadges(param1,param2);
      }
      
      private function onPlayerBadgesClick(param1:GameOverSlotColumnEvent) : void
      {
         if(_currentOpen != _playerBadges)
         {
            _playerBadges.open();
            if(_currentOpen != null)
            {
               (_currentOpen as GameOverSlotNanovors).close();
            }
            _currentOpen = _playerBadges;
            return;
         }
         _playerBadges.close();
         _currentOpen = null;
      }
      
      private function populateNewPlayerBadges(param1:Array, param2:Array) : void
      {
         var _loc4_:BadgeAward = null;
         var _loc5_:GameOverBadge = null;
         var _loc6_:Boolean = false;
         var _loc9_:int = 0;
         var _loc3_:Number = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < param2.length)
         {
            _loc6_ = true;
            _loc9_ = 0;
            while(_loc9_ < param1.length)
            {
               if(param2[_loc8_].getID() == param1[_loc9_].getID())
               {
                  _loc6_ = false;
                  break;
               }
               _loc9_++;
            }
            if(_loc6_)
            {
               _loc7_++;
            }
            _loc5_ = new GameOverBadge(param2[_loc8_],_loc6_);
            _loc5_.x = _loc3_;
            _playerBadges.addBadge(_loc5_,_loc6_);
            _loc3_ += 40;
            _loc8_++;
         }
         _playerBadges.slider.refresh();
         _playerBadges.alertNumber = _loc7_;
      }
      
      private function createSliderNanovorBadges() : void
      {
         _nanovorBadges = new GameOverSlotNanovors(_nanovorFactory,_soundManager,_roundControllerNanovorChooser,_player,"NANOVOR BADGES",910);
         _nanovorBadges.addEventListener(GameOverSlotColumnEvent.NANOVOR_BADGES_CLICK,onNanovorBadgesClick);
         _nanovorBadges.y = _yOffset;
         _slotContainer.addChild(_nanovorBadges);
         _yOffset += GameOverSlotNanovors.HEIGHT;
         var _loc1_:GameOverSlotBadgesEmpty = new GameOverSlotBadgesEmpty(910);
         _loc1_.y = _yOffset;
         _slotContainer.addChild(_loc1_);
         _yOffset += GameOverSlotBadgesEmpty.HEIGHT;
         _nanovorBadges.badgesSlot = _loc1_;
      }
      
      public function cascadeOpenSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = _slotContainer.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Tweener.addTween(_slotContainer.getChildAt(_loc1_),{
               "alpha":1,
               "time":1,
               "delay":0.1 * _loc1_
            });
            _loc1_++;
         }
      }
      
      public function close() : void
      {
         Tweener.addTween(this,{
            "alpha":0,
            "time":1
         });
         hideSlots();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> GameOverSlotColumnBadges: " + param1);
      }
      
      public function addSlot(param1:String) : void
      {
         var _loc2_:GameOverSlot = new GameOverSlot(param1);
         _loc2_.y = _yOffset;
         _loc2_.alpha = 0;
         _slotContainer.addChild(_loc2_);
         _yOffset += GameOverSlot.HEIGHT;
      }
   }
}

