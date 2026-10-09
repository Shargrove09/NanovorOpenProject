package com.arkadium.virmon.collection.substates.nanovor
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorInfoPanelComponent;
   import com.arkadium.virmon.shared.data.AttackPreviewGenerator;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.overrides.OverrideStat;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotWithRollout;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NanovorAttacksPanel extends NanovorInfoPanelComponent
   {
      
      private static const FADE_IN_TIME_SECONDS:Number = 0;
      
      private static const FADE_OUT_TIME_SECONDS:Number = 0.5;
      
      private static const ACTION_SLOT_FADE_SECONDS:Number = 0.3;
      
      private static const ACTION_SLOT_FADE_STAGGER_SECONDS:Number = 0.08;
      
      private static const ACTION_SLOT_FADE_OUT_IN_DELAY:Number = 0.05;
      
      private static const STATE_OPENED:String = "opened";
      
      private static const STATE_CLOSED:String = "closed";
      
      private static const BG_IN_OFFSET_Y:int = 0;
      
      private static const BG_OUT_OFFSET_Y:int = 260;
      
      private static const BG_TWEEN_IN_TIME:Number = 0.5;
      
      private static const BG_TWEEN_IN_DELAY:Number = 0;
      
      private var _actionSlots:Array = new Array();
      
      private var _currentNanovor:INanovor;
      
      private var _myPlayer:IPlayer;
      
      private var _actionSlotContainer:Sprite;
      
      private var _soundManager:ISoundManager;
      
      public function NanovorAttacksPanel(param1:ISoundManager, param2:IPlayer)
      {
         super();
         _soundManager = param1;
         _myPlayer = param2;
         init();
      }
      
      override public function destroy() : void
      {
         clearNanovorSelection();
         super.destroy();
      }
      
      private function onActionSlotRollOver(param1:MouseEvent) : void
      {
         var _loc2_:ActionSlotWithRollout = param1.target as ActionSlotWithRollout;
         _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_SOLID;
         _loc2_.showDescription();
         _loc2_.open();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorAttacksPanel: " + param1);
      }
      
      public function setNanovorAttacks(param1:INanovor) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ActionSlotWithRollout = null;
         var _loc6_:IAttack = null;
         var _loc7_:AttackStatement = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:IPlayer = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc2_:int = 0.3;
         if(_currentNanovor != null)
         {
            clearNanovorSelection();
         }
         param1.owner = _myPlayer;
         _myPlayer.swarmSize = 1;
         _myPlayer.selectedNanovor = param1;
         AttackPreviewGenerator.GenerateSelectedNanovorPreview(true,_myPlayer,[]);
         _currentNanovor = param1;
         log("setNanovor(): nanovor.name=" + param1.name);
         _actionSlots = new Array();
         _loc3_ = 0;
         while(_loc3_ < _currentNanovor.attacks.length)
         {
            _loc6_ = _currentNanovor.attacks[_loc3_];
            _loc8_ = _currentNanovor.owner.baseAttackPreviews[_currentNanovor.assetId][String(_loc6_.attackID)].players["0"];
            _loc5_ = new ActionSlotWithRollout(_soundManager,_loc6_);
            _loc5_.title = _loc6_.name;
            _loc5_.energyCost = _loc6_.cost;
            if(_loc6_.actionIconType == Icon.ACTION_OVERRIDE)
            {
               _loc14_ = OverrideStat.statIndexesFromAttackStatements(_loc6_.attackStatements);
               _loc5_.actionIcon = [_loc6_.actionIconType,_loc14_];
            }
            else
            {
               _loc5_.actionIcon = _loc6_.actionIconType;
            }
            _loc5_.mouseChildren = false;
            _loc5_.useHandCursor = false;
            _loc5_.y = ActionSlotComponent.HEIGHT * _loc3_ + _startY + 5;
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,onActionSlotRollOver,false,0,true);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,onActionSlotRollOut,false,0,true);
            for(_loc13_ in _loc8_)
            {
               _loc5_.addIcon(_loc13_,_loc8_[_loc13_].delta,_loc8_[_loc13_].type);
            }
            _actionSlots.push(_loc5_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _actionSlots.length)
         {
            _loc5_ = _actionSlots[_loc3_];
            _loc5_.alpha = 0;
            _actionSlotContainer.addChild(_loc5_);
            Tweener.removeTweens(_loc5_,alpha);
            Tweener.addTween(_loc5_,{
               "alpha":1,
               "time":ACTION_SLOT_FADE_SECONDS,
               "delay":_loc2_ + ACTION_SLOT_FADE_STAGGER_SECONDS * _loc3_,
               "transition":"easeOutQuart"
            });
            _loc3_++;
         }
         setInfoWindowNanovorProperties();
      }
      
      private function init() : void
      {
         viewField.text = "ATTACKS";
         _actionSlotContainer = new Sprite();
         _actionSlotContainer.x = 12;
         this.addChild(_actionSlotContainer);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorAttacksPanel: " + param1);
      }
      
      public function clearNanovorSelection(param1:Boolean = true) : void
      {
         var _loc2_:ActionSlotWithRollout = null;
         if(_currentNanovor != null)
         {
            while(_actionSlots.length > 0)
            {
               _loc2_ = _actionSlots.pop();
               _loc2_.removeEventListener(MouseEvent.ROLL_OVER,onActionSlotRollOver);
               _loc2_.removeEventListener(MouseEvent.ROLL_OUT,onActionSlotRollOut);
               clearActionSlot(_loc2_);
            }
            _currentNanovor = null;
         }
         if(param1)
         {
         }
      }
      
      private function clearActionSlot(param1:ActionSlotWithRollout) : void
      {
         if(Boolean(param1) && _actionSlotContainer.contains(param1))
         {
            _actionSlotContainer.removeChild(param1);
         }
      }
      
      private function onActionSlotRollOut(param1:MouseEvent) : void
      {
         var _loc2_:ActionSlotWithRollout = param1.target as ActionSlotWithRollout;
         log("onActionSlotRollOut() out of " + _loc2_ + " : " + param1.target);
         _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
         _loc2_.hideDescription();
         _loc2_.close();
      }
      
      private function setInfoWindowNanovorProperties() : void
      {
      }
   }
}

