package com.arkadium.virmon.shared.final.components.infowindow
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.stats.StatArmor;
   import com.arkadium.virmon.shared.elements.icons.stats.StatSpeed;
   import com.arkadium.virmon.shared.elements.icons.stats.StatStrength;
   import com.arkadium.virmon.shared.final.components.HealthBar;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class InfoWindowStats extends MovieClip
   {
      
      public static const STATS_NUM_DIGITS:int = 3;
      
      private static const STAT_TWEEN_SECONDS:Number = 0.4;
      
      private static const STAT_TWEEN_EASING:String = "easeInOutQuad";
      
      public var mcIconStrength:MovieClip;
      
      private var _iCalcArmor:int = 0;
      
      public var mcHealthBar:HealthBar;
      
      private var _iBaseArmor:int = 0;
      
      private var _iCalcSpeed:int = 0;
      
      private var _iBaseSpeed:int = 0;
      
      public var mcStatBubble1:MovieClip;
      
      private var _iBaseStrength:int = 0;
      
      private var _hacksXOffset:int = 0;
      
      private var _iCalcStrength:int = 0;
      
      private var _iconArmor:StatArmor;
      
      public var mcIconArmor:MovieClip;
      
      public var tfStrength:TextField;
      
      private var _iconSpeed:StatSpeed;
      
      public var mcIconSpeed:MovieClip;
      
      private var _iconStrength:StatStrength;
      
      public var mcHacksContainer:MovieClip;
      
      public var tfArmor:TextField;
      
      private var _tweenProp:TweenProp;
      
      public var tfSpeed:TextField;
      
      public function InfoWindowStats()
      {
         super();
         _tweenProp = new TweenProp(this);
         mcStatBubble1.mouseEnabled = false;
         mcStatBubble1.mouseChildren = false;
         mcStatBubble1.alpha = 0;
         _iconStrength = new StatStrength();
         _iconArmor = new StatArmor();
         _iconSpeed = new StatSpeed();
         mcIconStrength.addChild(_iconStrength);
         mcIconArmor.addChild(_iconArmor);
         mcIconSpeed.addChild(_iconSpeed);
         _iconStrength.addEventListener(MouseEvent.ROLL_OVER,onStrengthRollOver,false,0,true);
         _iconStrength.addEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble,false,0,true);
         _iconArmor.addEventListener(MouseEvent.ROLL_OVER,onArmorRollOver,false,0,true);
         _iconArmor.addEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble,false,0,true);
         _iconSpeed.addEventListener(MouseEvent.ROLL_OVER,onSpeedRollOver,false,0,true);
         _iconSpeed.addEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble,false,0,true);
      }
      
      public static function getDeltaString(param1:int, param2:int) : String
      {
         return "";
      }
      
      public function set strength(param1:int) : void
      {
         tweenStat(param1,Icon.STAT_STRENGTH);
      }
      
      public function addHack(param1:IAttackStatement) : void
      {
         if(param1 == null || param1.type != AttackStatementTypes.TYPE_HACK)
         {
            return;
         }
         var _loc2_:HackIcon = new HackIcon(param1,param1.currentDuration,_hacksXOffset != 0);
         _loc2_.x = _hacksXOffset;
         mcHacksContainer.addChild(_loc2_);
         log("Adding hack to mcHacksContainer");
         log("Hack X Offset = " + _hacksXOffset);
         _hacksXOffset += _loc2_.width + 2;
         _loc2_.addEventListener(MouseEvent.ROLL_OVER,onHackRollOver);
         _loc2_.addEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble);
      }
      
      public function set overrideArmor(param1:Boolean) : void
      {
         _iconArmor.isOverrideActive = param1;
      }
      
      public function setHealth(param1:int, param2:int) : void
      {
         mcHealthBar.setHealth(param1,param2);
      }
      
      public function set buffedSpeed(param1:Boolean) : void
      {
         _iconSpeed.isBuffed = param1;
      }
      
      public function get buffedStrength() : Boolean
      {
         return _iconStrength.isBuffed;
      }
      
      public function set speed(param1:int) : void
      {
         tweenStat(param1,Icon.STAT_SPEED);
      }
      
      public function updateHacks(param1:Array) : void
      {
         var _loc2_:HackIcon = null;
         while(mcHacksContainer.numChildren > 0)
         {
            _loc2_ = mcHacksContainer.removeChildAt(0) as HackIcon;
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,onHackRollOver);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble);
         }
         _hacksXOffset = 0;
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0)
         {
            addHack(param1[_loc3_]);
            _loc3_--;
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("InfoWindowStats >> " + param1);
      }
      
      public function get buffedArmor() : Boolean
      {
         return _iconArmor.isBuffed;
      }
      
      private function onArmorRollOver(param1:MouseEvent) : void
      {
         showBubble(new Point(mcIconArmor.x + mcIconArmor.width,mcIconArmor.y),"ARMOR");
      }
      
      public function get baseStrength() : int
      {
         return _iBaseStrength;
      }
      
      public function get overrideStrength() : Boolean
      {
         return _iconStrength.isOverrideActive;
      }
      
      public function get buffedSpeed() : Boolean
      {
         return _iconSpeed.isBuffed;
      }
      
      public function get calcStrength() : int
      {
         return _iCalcStrength;
      }
      
      private function onHackRollOver(param1:MouseEvent) : void
      {
         var _loc2_:HackIcon = param1.target as HackIcon;
         showBubble(new Point(_loc2_.x + _loc2_.width + mcHacksContainer.x,_loc2_.y + mcHacksContainer.y),_loc2_.description);
      }
      
      private function onSpeedRollOver(param1:MouseEvent) : void
      {
         showBubble(new Point(mcIconSpeed.x + mcIconSpeed.width,mcIconSpeed.y),"SPEED");
      }
      
      public function set overrideSpeed(param1:Boolean) : void
      {
         _iconSpeed.isOverrideActive = param1;
      }
      
      public function set buffedStrength(param1:Boolean) : void
      {
         _iconStrength.isBuffed = param1;
      }
      
      private function hideCurrentBubble(param1:MouseEvent) : void
      {
         Tweener.addTween(mcStatBubble1,{
            "alpha":0,
            "time":1
         });
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("InfoWindowStats >> " + param1);
      }
      
      private function onStrengthRollOver(param1:MouseEvent) : void
      {
         showBubble(new Point(mcIconStrength.x + mcIconStrength.width,mcIconStrength.y),"STRENGTH");
      }
      
      public function set calcArmor(param1:int) : void
      {
         _iCalcArmor = param1;
      }
      
      public function set baseArmor(param1:int) : void
      {
         _iBaseArmor = _iCalcArmor = param1;
         tfArmor.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS);
      }
      
      public function set buffedArmor(param1:Boolean) : void
      {
         _iconArmor.isBuffed = param1;
      }
      
      public function get overrideArmor() : Boolean
      {
         return _iconArmor.isOverrideActive;
      }
      
      public function set baseStrength(param1:int) : void
      {
         _iBaseStrength = _iCalcStrength = param1;
         tfStrength.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS);
      }
      
      private function tweenStat(param1:int, param2:String) : void
      {
         switch(param2)
         {
            case Icon.STAT_STRENGTH:
               Tweener.removeTweens(_tweenProp,"strength");
               Tweener.addTween(_tweenProp,{
                  "strength":param1,
                  "time":STAT_TWEEN_SECONDS,
                  "transition":STAT_TWEEN_EASING,
                  "rounded":true
               });
               break;
            case Icon.STAT_ARMOR:
               Tweener.removeTweens(_tweenProp,"armor");
               Tweener.addTween(_tweenProp,{
                  "armor":param1,
                  "time":STAT_TWEEN_SECONDS,
                  "transition":STAT_TWEEN_EASING,
                  "rounded":true
               });
               break;
            case Icon.STAT_SPEED:
               Tweener.removeTweens(_tweenProp,"speed");
               Tweener.addTween(_tweenProp,{
                  "speed":param1,
                  "time":STAT_TWEEN_SECONDS,
                  "transition":STAT_TWEEN_EASING,
                  "rounded":true
               });
         }
      }
      
      private function showBubble(param1:Point, param2:String = "") : void
      {
         if(mcStatBubble1.alpha == 0)
         {
            mcStatBubble1.x = param1.x;
            mcStatBubble1.y = param1.y;
         }
         Tweener.removeTweens(mcStatBubble1);
         mcStatBubble1.tfText.text = param2;
         Tweener.addTween(mcStatBubble1,{
            "x":param1.x,
            "y":param1.y,
            "alpha":1,
            "time":1.5,
            "rounded":true
         });
      }
      
      public function set calcSpeed(param1:int) : void
      {
         _iCalcSpeed = param1;
      }
      
      public function set baseSpeed(param1:int) : void
      {
         _iBaseSpeed = _iCalcSpeed = param1;
         tfSpeed.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS);
      }
      
      public function get baseArmor() : int
      {
         return _iBaseArmor;
      }
      
      public function get calcArmor() : int
      {
         return _iCalcArmor;
      }
      
      public function get overrideSpeed() : Boolean
      {
         return _iconSpeed.isOverrideActive;
      }
      
      public function get calcSpeed() : int
      {
         return _iCalcSpeed;
      }
      
      public function destroy() : void
      {
         _iconStrength.removeEventListener(MouseEvent.ROLL_OVER,onStrengthRollOver);
         _iconStrength.removeEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble);
         _iconArmor.removeEventListener(MouseEvent.ROLL_OVER,onArmorRollOver);
         _iconArmor.removeEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble);
         _iconSpeed.removeEventListener(MouseEvent.ROLL_OVER,onSpeedRollOver);
         _iconSpeed.removeEventListener(MouseEvent.ROLL_OUT,hideCurrentBubble);
      }
      
      public function set calcStrength(param1:int) : void
      {
         _iCalcStrength = param1;
      }
      
      public function set overrideStrength(param1:Boolean) : void
      {
         _iconStrength.isOverrideActive = param1;
      }
      
      public function get baseSpeed() : int
      {
         return _iBaseSpeed;
      }
      
      public function set armor(param1:int) : void
      {
         tweenStat(param1,Icon.STAT_ARMOR);
      }
   }
}

