package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import com.arkadium.virmon.battle.components.TargetReticle;
   import com.arkadium.virmon.battle.control.Attack;
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.overrides.OverrideStat;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ActionPickerEnemy extends ActionPicker
   {
      
      public static const DIRECTION_RIGHT:String = "right";
      
      public static const DIRECTION_LEFT:String = "left";
      
      private static const NUM_BLANK_ATTACKS:int = 4;
      
      private static const NANOVOR_HIT_AREA_HEIGHT:int = 415;
      
      private var _szSwarmDirection:String;
      
      private var _swarmSlot:EnemySwarmSlot = null;
      
      public function ActionPickerEnemy(param1:ISoundManager, param2:IPlayer, param3:Spotlight = null, param4:String = "left")
      {
         super(param1,param2,param3);
         if(Boolean(param3))
         {
            param3.color = Spotlight.RING_COLOR_RED;
         }
         _szSwarmDirection = param4;
         _actionSlotContainer.y = NUM_BLANK_ATTACKS * ActionSlotComponent.HEIGHT + 1;
         _attackActionSlotContainer.y = ActionSlotComponent.HEIGHT;
         _confirmReticle.color = TargetReticle.TARGET_RETICLE_COLOR_RED;
      }
      
      public function autoRollOver() : void
      {
         onNanovorRollOver(null);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         _nanovorHitArea.removeEventListener(MouseEvent.ROLL_OVER,onNanovorRollOver);
         _nanovorHitArea.removeEventListener(MouseEvent.ROLL_OUT,onNanovorRollOut);
      }
      
      public function autoRollOut() : void
      {
         onNanovorRollOut(null);
      }
      
      override public function setNanovor(param1:INanovor) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ActionSlotComponent = null;
         var _loc5_:Attack = null;
         var _loc6_:AttackStatement = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         log("setNanovor: oNanovor=" + param1);
         if(_nanovor != null)
         {
            logError("setNanovor called but nanovor is already set!");
            return false;
         }
         clearDisplay();
         if(param1 == null)
         {
            loadHasselhoff();
            _loc11_ = Boolean(param1 == null);
            _nanovor = param1;
            return _loc11_;
         }
         if(param1.isDead)
         {
            log("setNanovor: oNanovor.isDead ***");
            _nanovor = param1;
            _aActionSlots = _aAttackActionSlots.slice();
            _swarmSlot = new EnemySwarmSlot(_nanovor.owner,_szSwarmDirection,_player.swarmSize * EnemySwarmSlot.SWARM_ICON_SPACING + 5);
            _swarmSlot.activeNanovor = _nanovor;
            _swarmSlot.updateSwarm();
            _actionSlotContainer.addChild(_swarmSlot);
            _aActionSlots.push(_swarmSlot);
            return false;
         }
         _nanovor = param1;
         _loc2_ = 0;
         while(_loc2_ < _nanovor.attacks.length)
         {
            _loc5_ = _nanovor.attacks[_loc2_];
            log("setNanovor: [" + _nanovor.name + "], attack [" + _loc2_ + "] (" + _loc5_.name + ") ==> actionIconType=" + _loc5_.actionIconType);
            _loc7_ = _nanovor.owner.baseAttackPreviews[String(_nanovor.assetId)][String(_loc5_.attackID)].players["0"];
            _loc4_ = new ActionSlotComponent(_loc5_);
            _loc4_.title = _loc5_.name;
            _loc4_.energyCost = _loc5_.cost;
            if(_loc5_.actionIconType == Icon.ACTION_OVERRIDE)
            {
               _loc13_ = OverrideStat.statIndexesFromAttackStatements(_loc5_.attackStatements);
               _loc4_.actionIcon = [_loc5_.actionIconType,_loc13_];
            }
            else
            {
               _loc4_.actionIcon = _loc5_.actionIconType;
            }
            _loc4_.color = ActionSlotComponent.BACKGROUND_COLOR_RED;
            _loc4_.mouseEnabled = false;
            _loc4_.y = ActionSlotComponent.HEIGHT * _loc2_;
            for(_loc12_ in _loc7_)
            {
               _loc4_.addIcon(_loc12_,_loc7_[_loc12_].delta,_loc7_[_loc12_].type);
            }
            _attackActionSlotContainer.addChild(_loc4_);
            _aAttackActionSlots.push(_loc4_);
            _loc2_++;
         }
         _aActionSlots = _aAttackActionSlots.slice();
         _swarmSlot = new EnemySwarmSlot(_nanovor.owner,_szSwarmDirection,_player.swarmSize * EnemySwarmSlot.SWARM_ICON_SPACING + 5);
         _swarmSlot.activeNanovor = _nanovor;
         _swarmSlot.updateSwarm();
         _actionSlotContainer.addChild(_swarmSlot);
         _aActionSlots.push(_swarmSlot);
         update();
         return true;
      }
      
      override protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> ActionPickerEnemy: " + param1);
      }
      
      public function closeSwarm() : void
      {
         if(!_swarmSlot)
         {
            return;
         }
         _swarmSlot.close(true);
      }
      
      override protected function opened() : void
      {
         log("opened()");
         super.opened();
         openSwarm();
      }
      
      override public function open(param1:Boolean = false) : void
      {
         log("open (bFadeInstant=" + param1 + ") _nanovor=" + _nanovor);
         if(_nanovor == null || Boolean(_nanovor.isDead))
         {
            _attackActionSlotContainer.visible = false;
         }
         else
         {
            _attackActionSlotContainer.visible = true;
         }
         super.open(param1);
      }
      
      override protected function logError(param1:String) : void
      {
         DebugLog.instance.error("** ActionPickerEnemy: " + param1);
      }
      
      override protected function createHitAreas() : void
      {
         _nanovorHitArea = new Sprite();
         _nanovorHitArea.graphics.beginFill(65280,0);
         _nanovorHitArea.graphics.drawRect(0,HEIGHT - NANOVOR_HIT_AREA_HEIGHT,ActionSlotComponent.WIDTH,NANOVOR_HIT_AREA_HEIGHT);
         _nanovorHitArea.graphics.endFill();
         this.addChild(_nanovorHitArea);
         _nanovorHitArea.addEventListener(MouseEvent.ROLL_OVER,onNanovorRollOver,false,0,true);
         _nanovorHitArea.addEventListener(MouseEvent.ROLL_OUT,onNanovorRollOut,false,0,true);
      }
      
      public function openSwarm() : void
      {
         log("openSwarm()  _swarmSlot=" + _swarmSlot);
         if(_swarmSlot == null)
         {
            return;
         }
         _swarmSlot.open();
      }
   }
}

