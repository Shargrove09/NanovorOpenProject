package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.actionslot.RolloutComponent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class EnemySwarmSlot extends ActionSlotComponent
   {
      
      public static const DISPLAY_UPDATED:String = "EnemySwarmSlot::displayUpdated";
      
      public static const DISPLAY_BRING_OUT_COMPLETE:String = "EnemySwarmSlot::displayBringOutComplete";
      
      public static const SWARM_ICON_SPACING:int = 51;
      
      private var _player:IPlayer;
      
      private const SWARM_Y:int = 1;
      
      private var _swarmContainer:Sprite;
      
      private var _rollout:RolloutComponent;
      
      private var _activeNanovor:INanovor = null;
      
      private var _szDirection:String;
      
      private var _iSwarmLoadCounter:int = 0;
      
      private const SWARM_X:int = 182;
      
      private var _bInited:Boolean = false;
      
      private var _aNanovorIcons:Array = new Array();
      
      public function EnemySwarmSlot(param1:IPlayer, param2:String, param3:Number)
      {
         super(null);
         super.hideEnergy();
         super.title = "Swarm";
         mcLine.visible = false;
         _player = param1;
         _szDirection = param2;
         _rollout = new RolloutComponent(ActionSlotComponent.WIDTH,param3 + SWARM_X);
         this.addChildAt(_rollout,0);
         this.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
         this.color = ActionSlotComponent.BACKGROUND_COLOR_RED;
         this.mouseEnabled = false;
         _swarmContainer = new Sprite();
         _swarmContainer.x = SWARM_X;
         _swarmContainer.y = SWARM_Y;
         addChild(_swarmContainer);
         if(_szDirection == ActionPickerEnemy.DIRECTION_LEFT)
         {
            _rollout.x -= param3 + 1;
            _swarmContainer.x = _rollout.x + 5;
         }
      }
      
      private function updateNextNanovorIcon() : void
      {
         var _loc1_:NanovorIcon = _aNanovorIcons[_iSwarmLoadCounter];
         _loc1_.addEventListener(NanovorIcon.LOADED,onNanovorIconUpdated,false,0,true);
         _loc1_.updateDisplay(Boolean(_loc1_.nanovor == _activeNanovor));
      }
      
      private function onNanovorIconLoaded(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconLoaded);
         log("onNanovorIconLoaded: counter=" + _iSwarmLoadCounter + ", assetId=" + (_player.swarm[_iSwarmLoadCounter] == null ? "[null]" : _player.swarm[_iSwarmLoadCounter].assetId) + ", _player.swarmSize=" + _player.swarmSize);
         if(++_iSwarmLoadCounter >= _player.swarmSize)
         {
            onDisplayUpdated();
         }
         else
         {
            loadNextNanovorIcon();
         }
      }
      
      public function set direction(param1:String) : void
      {
         if(param1 != "right")
         {
            _rollout.scaleX = -1;
            _rollout.x = ActionSlotComponent.WIDTH;
         }
         else
         {
            _rollout.scaleX = 1;
            _rollout.x = 0;
         }
      }
      
      override public function set color(param1:uint) : void
      {
         super.color = param1;
         _rollout.color = param1;
      }
      
      public function destroy() : void
      {
         var _loc2_:NanovorIcon = null;
         var _loc1_:int = 0;
         while(Boolean(_aNanovorIcons.length))
         {
            _loc2_ = _aNanovorIcons[_loc1_];
            _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconLoaded);
            _loc1_++;
         }
         if(_swarmContainer != null)
         {
            while(_swarmContainer.numChildren > 0)
            {
               _swarmContainer.removeChildAt(0);
            }
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> EnemySwarmSlot: " + param1);
      }
      
      private function loadNextNanovorIcon() : void
      {
         var _loc1_:NanovorIcon = new NanovorIcon();
         _loc1_.x = SWARM_ICON_SPACING * _iSwarmLoadCounter;
         _aNanovorIcons.push(_loc1_);
         _swarmContainer.addChild(_loc1_);
         _loc1_.addEventListener(NanovorIcon.LOADED,onNanovorIconLoaded,false,0,true);
         var _loc2_:INanovor = _player.swarm[_iSwarmLoadCounter] == null ? null : _player.swarm[_iSwarmLoadCounter];
         _loc1_.initialize(_loc2_,false,true,Boolean(_loc2_ == _activeNanovor));
      }
      
      public function open(param1:Boolean = false) : void
      {
         log("open");
         _rollout.open(param1);
      }
      
      private function updateDisplay() : void
      {
         log("updateDisplay: _bInited=" + _bInited);
         _iSwarmLoadCounter = 0;
         if(!_bInited)
         {
            loadNextNanovorIcon();
         }
         else
         {
            updateNextNanovorIcon();
         }
      }
      
      private function onNanovorIconUpdated(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconUpdated);
         log("onNanovorIconUpdated: counter=" + _iSwarmLoadCounter + ", _player.swarmSize=" + _player.swarmSize);
         if(++_iSwarmLoadCounter >= _player.swarmSize)
         {
            onDisplayUpdated();
         }
         else
         {
            updateNextNanovorIcon();
         }
      }
      
      private function onDisplayUpdated() : void
      {
         log("onDisplayUpdated (finished loading/updating swarm)");
         dispatchEvent(new Event(DISPLAY_UPDATED));
      }
      
      public function get player() : IPlayer
      {
         return _player;
      }
      
      public function updateSwarm() : void
      {
         log("updateSwarm");
         updateDisplay();
         _bInited = true;
      }
      
      public function close(param1:Boolean = false) : void
      {
         log("close");
         _rollout.close(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** EnemySwarmSlot: " + param1);
      }
      
      public function set activeNanovor(param1:INanovor) : void
      {
         if(_activeNanovor != null)
         {
         }
         _activeNanovor = param1;
         log("set _activeNanovor = " + param1);
      }
      
      public function get activeNanovor() : INanovor
      {
         return _activeNanovor;
      }
   }
}

