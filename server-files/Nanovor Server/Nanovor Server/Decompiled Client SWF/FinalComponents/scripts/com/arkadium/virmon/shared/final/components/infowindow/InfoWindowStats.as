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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol407")]
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
         this._tweenProp = new TweenProp(this);
         this.mcStatBubble1.mouseEnabled = false;
         this.mcStatBubble1.mouseChildren = false;
         this.mcStatBubble1.alpha = 0;
         this._iconStrength = new StatStrength();
         this._iconArmor = new StatArmor();
         this._iconSpeed = new StatSpeed();
         this.mcIconStrength.addChild(this._iconStrength);
         this.mcIconArmor.addChild(this._iconArmor);
         this.mcIconSpeed.addChild(this._iconSpeed);
         this._iconStrength.addEventListener(MouseEvent.ROLL_OVER,this.onStrengthRollOver,false,0,true);
         this._iconStrength.addEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble,false,0,true);
         this._iconArmor.addEventListener(MouseEvent.ROLL_OVER,this.onArmorRollOver,false,0,true);
         this._iconArmor.addEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble,false,0,true);
         this._iconSpeed.addEventListener(MouseEvent.ROLL_OVER,this.onSpeedRollOver,false,0,true);
         this._iconSpeed.addEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble,false,0,true);
      }
      
      public static function getDeltaString(param1:int, param2:int) : String
      {
         return "";
      }
      
      public function set strength(param1:int) : void
      {
         this.tweenStat(param1,Icon.STAT_STRENGTH);
      }
      
      public function addHack(param1:IAttackStatement) : void
      {
         if(param1 == null || param1.type != AttackStatementTypes.TYPE_HACK)
         {
            return;
         }
         var _loc2_:HackIcon = new HackIcon(param1,param1.currentDuration,this._hacksXOffset != 0);
         _loc2_.x = this._hacksXOffset;
         this.mcHacksContainer.addChild(_loc2_);
         this.log("Adding hack to mcHacksContainer");
         this.log("Hack X Offset = " + this._hacksXOffset);
         this._hacksXOffset += _loc2_.width + 2;
         _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onHackRollOver);
         _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble);
      }
      
      public function set overrideArmor(param1:Boolean) : void
      {
         this._iconArmor.isOverrideActive = param1;
      }
      
      public function setHealth(param1:int, param2:int) : void
      {
         this.mcHealthBar.setHealth(param1,param2);
      }
      
      public function set buffedSpeed(param1:Boolean) : void
      {
         this._iconSpeed.isBuffed = param1;
      }
      
      public function get buffedStrength() : Boolean
      {
         return this._iconStrength.isBuffed;
      }
      
      public function set speed(param1:int) : void
      {
         this.tweenStat(param1,Icon.STAT_SPEED);
      }
      
      public function updateHacks(param1:Array) : void
      {
         var _loc2_:HackIcon = null;
         while(this.mcHacksContainer.numChildren > 0)
         {
            _loc2_ = this.mcHacksContainer.removeChildAt(0) as HackIcon;
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,this.onHackRollOver);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble);
         }
         this._hacksXOffset = 0;
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0)
         {
            this.addHack(param1[_loc3_]);
            _loc3_--;
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("InfoWindowStats >> " + param1);
      }
      
      public function get buffedArmor() : Boolean
      {
         return this._iconArmor.isBuffed;
      }
      
      private function onArmorRollOver(param1:MouseEvent) : void
      {
         this.showBubble(new Point(this.mcIconArmor.x + this.mcIconArmor.width,this.mcIconArmor.y),"ARMOR");
      }
      
      public function get baseStrength() : int
      {
         return this._iBaseStrength;
      }
      
      public function get overrideStrength() : Boolean
      {
         return this._iconStrength.isOverrideActive;
      }
      
      public function get buffedSpeed() : Boolean
      {
         return this._iconSpeed.isBuffed;
      }
      
      public function get calcStrength() : int
      {
         return this._iCalcStrength;
      }
      
      private function onHackRollOver(param1:MouseEvent) : void
      {
         var _loc2_:HackIcon = param1.target as HackIcon;
         this.showBubble(new Point(_loc2_.x + _loc2_.width + this.mcHacksContainer.x,_loc2_.y + this.mcHacksContainer.y),_loc2_.description);
      }
      
      private function onSpeedRollOver(param1:MouseEvent) : void
      {
         this.showBubble(new Point(this.mcIconSpeed.x + this.mcIconSpeed.width,this.mcIconSpeed.y),"SPEED");
      }
      
      public function set overrideSpeed(param1:Boolean) : void
      {
         this._iconSpeed.isOverrideActive = param1;
      }
      
      public function set buffedStrength(param1:Boolean) : void
      {
         this._iconStrength.isBuffed = param1;
      }
      
      private function hideCurrentBubble(param1:MouseEvent) : void
      {
         Tweener.addTween(this.mcStatBubble1,{
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
         this.showBubble(new Point(this.mcIconStrength.x + this.mcIconStrength.width,this.mcIconStrength.y),"STRENGTH");
      }
      
      public function set calcArmor(param1:int) : void
      {
         this._iCalcArmor = param1;
      }
      
      public function set baseArmor(param1:int) : void
      {
         this._iBaseArmor = this._iCalcArmor = param1;
         this.tfArmor.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS);
      }
      
      public function set buffedArmor(param1:Boolean) : void
      {
         this._iconArmor.isBuffed = param1;
      }
      
      public function get overrideArmor() : Boolean
      {
         return this._iconArmor.isOverrideActive;
      }
      
      public function set baseStrength(param1:int) : void
      {
         this._iBaseStrength = this._iCalcStrength = param1;
         this.tfStrength.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS);
      }
      
      private function tweenStat(param1:int, param2:String) : void
      {
         switch(param2)
         {
            case Icon.STAT_STRENGTH:
               Tweener.removeTweens(this._tweenProp,"strength");
               Tweener.addTween(this._tweenProp,{
                  "strength":param1,
                  "time":STAT_TWEEN_SECONDS,
                  "transition":STAT_TWEEN_EASING,
                  "rounded":true
               });
               break;
            case Icon.STAT_ARMOR:
               Tweener.removeTweens(this._tweenProp,"armor");
               Tweener.addTween(this._tweenProp,{
                  "armor":param1,
                  "time":STAT_TWEEN_SECONDS,
                  "transition":STAT_TWEEN_EASING,
                  "rounded":true
               });
               break;
            case Icon.STAT_SPEED:
               Tweener.removeTweens(this._tweenProp,"speed");
               Tweener.addTween(this._tweenProp,{
                  "speed":param1,
                  "time":STAT_TWEEN_SECONDS,
                  "transition":STAT_TWEEN_EASING,
                  "rounded":true
               });
         }
      }
      
      private function showBubble(param1:Point, param2:String = "") : void
      {
         if(this.mcStatBubble1.alpha == 0)
         {
            this.mcStatBubble1.x = param1.x;
            this.mcStatBubble1.y = param1.y;
         }
         Tweener.removeTweens(this.mcStatBubble1);
         this.mcStatBubble1.tfText.text = param2;
         Tweener.addTween(this.mcStatBubble1,{
            "x":param1.x,
            "y":param1.y,
            "alpha":1,
            "time":1.5,
            "rounded":true
         });
      }
      
      public function set calcSpeed(param1:int) : void
      {
         this._iCalcSpeed = param1;
      }
      
      public function set baseSpeed(param1:int) : void
      {
         this._iBaseSpeed = this._iCalcSpeed = param1;
         this.tfSpeed.text = Utils.zeroPreFill(param1,InfoWindowStats.STATS_NUM_DIGITS);
      }
      
      public function get baseArmor() : int
      {
         return this._iBaseArmor;
      }
      
      public function get calcArmor() : int
      {
         return this._iCalcArmor;
      }
      
      public function get overrideSpeed() : Boolean
      {
         return this._iconSpeed.isOverrideActive;
      }
      
      public function get calcSpeed() : int
      {
         return this._iCalcSpeed;
      }
      
      public function destroy() : void
      {
         this._iconStrength.removeEventListener(MouseEvent.ROLL_OVER,this.onStrengthRollOver);
         this._iconStrength.removeEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble);
         this._iconArmor.removeEventListener(MouseEvent.ROLL_OVER,this.onArmorRollOver);
         this._iconArmor.removeEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble);
         this._iconSpeed.removeEventListener(MouseEvent.ROLL_OVER,this.onSpeedRollOver);
         this._iconSpeed.removeEventListener(MouseEvent.ROLL_OUT,this.hideCurrentBubble);
      }
      
      public function set calcStrength(param1:int) : void
      {
         this._iCalcStrength = param1;
      }
      
      public function set overrideStrength(param1:Boolean) : void
      {
         this._iconStrength.isOverrideActive = param1;
      }
      
      public function get baseSpeed() : int
      {
         return this._iBaseSpeed;
      }
      
      public function set armor(param1:int) : void
      {
         this.tweenStat(param1,Icon.STAT_ARMOR);
      }
   }
}

