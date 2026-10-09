package com.arkadium.virmon.battle.components
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.Attack;
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.overrides.OverrideStat;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindow;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol15")]
   public class NanovorPickerInfo extends Sprite
   {
      
      public static const EVENT_CLOSED:String = "NanovorPickerInfo::closed";
      
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
      
      private var _currentNanovor:INanovor = null;
      
      private var _actionSlotContainer:Sprite;
      
      public var mcBG:MovieClip;
      
      private var _infoWindow:InfoWindow;
      
      public var mcSelectNanovorText:MovieClip;
      
      private var _actionSlots:Array = new Array();
      
      private var _bFullyOpened:Boolean = false;
      
      public var mcActionSlotsMask:MovieClip;
      
      private var _currentState:String;
      
      public function NanovorPickerInfo()
      {
         super();
         this.alpha = 0;
         _currentState = STATE_CLOSED;
         mcBG.y = BG_OUT_OFFSET_Y;
         _actionSlotContainer = new Sprite();
         _actionSlotContainer.mouseEnabled = false;
         _actionSlotContainer.mouseChildren = false;
         this.addChild(_actionSlotContainer);
         _actionSlotContainer.mask = mcActionSlotsMask;
         _infoWindow = new InfoWindow();
         _infoWindow.x = 180;
         _infoWindow.y = 80;
         _infoWindow.title.hideSV();
         this.addChild(_infoWindow);
      }
      
      private function clearActionSlot(param1:ActionSlotComponent) : void
      {
         if(Boolean(param1) && _actionSlotContainer.contains(param1))
         {
            _actionSlotContainer.removeChild(param1);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorPickerInfo: " + param1);
      }
      
      public function open() : void
      {
         if(_currentState == STATE_OPENED)
         {
            return;
         }
         _currentState = STATE_OPENED;
         this.visible = true;
         Tweener.removeTweens(this,alpha);
         Tweener.addTween(this,{
            "alpha":1,
            "time":FADE_IN_TIME_SECONDS,
            "transition":"easeOutQuad",
            "onComplete":onTweenOpenComplete
         });
      }
      
      private function onTweenOpenComplete() : void
      {
         _bFullyOpened = true;
      }
      
      public function clearNanovorSelection(param1:Boolean = true) : void
      {
         var _loc2_:ActionSlotComponent = null;
         if(_currentNanovor != null)
         {
            while(_actionSlots.length > 0)
            {
               _loc2_ = _actionSlots.pop();
               clearActionSlot(_loc2_);
            }
            _currentNanovor = null;
         }
         if(param1)
         {
            _infoWindow.clearDisplay();
         }
      }
      
      private function setInfoWindowNanovorProperties() : void
      {
         _infoWindow.nanovorName = _currentNanovor.name;
         _infoWindow.nanovorNickName = _currentNanovor.safeNickName;
         _infoWindow.faction = _currentNanovor.faction;
         _infoWindow.sv = _currentNanovor.swarmValue;
         _infoWindow.baseStrength = _currentNanovor.baseStrength;
         _infoWindow.baseArmor = _currentNanovor.baseArmor;
         _infoWindow.baseSpeed = _currentNanovor.baseSpeed;
         _infoWindow.armor = _currentNanovor.moddedArmor;
         _infoWindow.speed = _currentNanovor.moddedSpeed;
         _infoWindow.strength = _currentNanovor.moddedStrength;
         _infoWindow.setHealth(_currentNanovor.health,_currentNanovor.baseHealth);
         _infoWindow.mcStats.buffedArmor = _currentNanovor.baseArmor > _currentNanovor.virmonMasterData.getBaseArmor();
         _infoWindow.mcStats.buffedSpeed = _currentNanovor.baseSpeed > _currentNanovor.virmonMasterData.getBaseSpeed();
         _infoWindow.mcStats.buffedStrength = _currentNanovor.baseStrength > _currentNanovor.virmonMasterData.getBaseStrength();
         _infoWindow.mcStats.mcHealthBar.buffedHealth = _currentNanovor.baseHealth > _currentNanovor.virmonMasterData.getBaseHealth();
         _infoWindow.mcStats.overrideArmor = _currentNanovor.checkStatOverride(Stat.ARMOR);
         _infoWindow.mcStats.overrideSpeed = _currentNanovor.checkStatOverride(Stat.SPEED);
         _infoWindow.mcStats.overrideStrength = _currentNanovor.checkStatOverride(Stat.STRENGTH);
      }
      
      public function setNanovor(param1:INanovor, param2:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ActionSlotComponent = null;
         var _loc7_:Attack = null;
         var _loc8_:AttackStatement = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Boolean = false;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         log("setNanovor: nanovor.name=" + param1.name + ", bAlreadyActive=" + param2);
         var _loc3_:int = 0.3;
         if(_currentNanovor != null)
         {
            clearNanovorSelection();
         }
         _currentNanovor = param1;
         mcSelectNanovorText.visible = !param1.isDead && !param2;
         _actionSlots = new Array();
         _loc4_ = 0;
         while(_loc4_ < _currentNanovor.attacks.length)
         {
            _loc7_ = _currentNanovor.attacks[_loc4_];
            _loc9_ = _currentNanovor.owner.baseAttackPreviews[String(_currentNanovor.assetId)][String(_loc7_.attackID)].players["0"];
            _loc6_ = new ActionSlotComponent(_loc7_);
            _loc6_.title = _loc7_.name;
            _loc6_.energyCost = _loc7_.cost;
            if(_loc7_.actionIconType == Icon.ACTION_OVERRIDE)
            {
               _loc14_ = OverrideStat.statIndexesFromAttackStatements(_loc7_.attackStatements);
               _loc6_.actionIcon = [_loc7_.actionIconType,_loc14_];
            }
            else
            {
               _loc6_.actionIcon = _loc7_.actionIconType;
            }
            _loc6_.mouseEnabled = false;
            _loc6_.y = ActionSlotComponent.HEIGHT * _loc4_;
            for(_loc13_ in _loc9_)
            {
               _loc6_.addIcon(_loc13_,_loc9_[_loc13_].delta,_loc9_[_loc13_].type);
            }
            _actionSlots.push(_loc6_);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _actionSlots.length)
         {
            _loc6_ = _actionSlots[_loc4_];
            _loc6_.alpha = 0;
            _actionSlotContainer.addChild(_loc6_);
            Tweener.removeTweens(_loc6_,alpha);
            Tweener.addTween(_loc6_,{
               "alpha":1,
               "time":ACTION_SLOT_FADE_SECONDS,
               "delay":_loc3_ + ACTION_SLOT_FADE_STAGGER_SECONDS * _loc4_,
               "transition":"easeOutQuart"
            });
            _loc4_++;
         }
         Tweener.removeTweens(mcBG,y);
         mcBG.y = BG_OUT_OFFSET_Y;
         Tweener.addTween(mcBG,{
            "y":BG_IN_OFFSET_Y,
            "time":BG_TWEEN_IN_TIME,
            "delay":BG_TWEEN_IN_DELAY,
            "transition":"easeOutQuad"
         });
         setInfoWindowNanovorProperties();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorPickerInfo: " + param1);
      }
      
      private function onOpened() : void
      {
      }
      
      private function onClosed() : void
      {
         clearNanovorSelection();
         this.visible = false;
      }
      
      public function close() : void
      {
         if(_currentState == STATE_CLOSED)
         {
            return;
         }
         _currentState = STATE_CLOSED;
         _bFullyOpened = false;
         Tweener.removeTweens(this,alpha);
         Tweener.addTween(this,{
            "alpha":0,
            "time":FADE_OUT_TIME_SECONDS,
            "transition":"easeOutQuad",
            "onComplete":onClosed
         });
      }
      
      public function destroy() : void
      {
         _infoWindow.destroy();
      }
      
      public function get infoWindow() : InfoWindow
      {
         return _infoWindow;
      }
   }
}

