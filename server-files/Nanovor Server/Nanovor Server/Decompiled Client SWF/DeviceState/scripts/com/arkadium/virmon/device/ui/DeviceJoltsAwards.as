package com.arkadium.virmon.device.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.elements.icons.stats.StatArmor;
   import com.arkadium.virmon.shared.elements.icons.stats.StatHealth;
   import com.arkadium.virmon.shared.elements.icons.stats.StatSpeed;
   import com.arkadium.virmon.shared.elements.icons.stats.StatStrength;
   import com.arkadium.virmon.shared.utils.Utils;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class DeviceJoltsAwards extends Sprite
   {
      
      public static const TYPE_HEALTH:String = "typeHealth";
      
      public static const TYPE_STRENGTH:String = "typeStrength";
      
      public static const TYPE_ARMOR:String = "typeArmor";
      
      public static const TYPE_SPEED:String = "typeSpeed";
      
      private static const JOLTS_VALUE_LENGTH:int = 6;
      
      private static const TWEEN_BASE:Object = {
         "time":1,
         "transition":Equations.easeInOutQuad
      };
      
      private var _joltsSpeed:int;
      
      private var _joltsHealth:int;
      
      public var tfUpdates:TextField;
      
      public var mcArmor:Sprite;
      
      public var mcSpeed:Sprite;
      
      public var tfStrength:TextField;
      
      public var tfSpeedJolts:TextField;
      
      public var mcHealth:Sprite;
      
      public var tfArmorJolts:TextField;
      
      private var _joltsArmor:int;
      
      private var _joltsStrength:int;
      
      private var _tweenProp:TweenProp;
      
      public var tfStrengthJolts:TextField;
      
      public var tfArmor:TextField;
      
      public var tfHealth:TextField;
      
      public var mcStrength:Sprite;
      
      public var tfHealthJolts:TextField;
      
      public var tfSpeed:TextField;
      
      public var tfNMP:TextField;
      
      public function DeviceJoltsAwards()
      {
         super();
         _tweenProp = new TweenProp(this);
         mcHealth.addChild(new StatHealth());
         mcStrength.addChild(new StatStrength());
         mcArmor.addChild(new StatArmor());
         mcSpeed.addChild(new StatSpeed());
         setJolts(TYPE_HEALTH,0);
         setJolts(TYPE_STRENGTH,0);
         setJolts(TYPE_ARMOR,0);
         setJolts(TYPE_SPEED,0);
      }
      
      public function setJolts(param1:String, param2:int) : void
      {
         switch(param1)
         {
            case TYPE_HEALTH:
               _joltsHealth = param2;
               break;
            case TYPE_STRENGTH:
               _joltsStrength = param2;
               break;
            case TYPE_ARMOR:
               _joltsArmor = param2;
               break;
            case TYPE_SPEED:
               _joltsSpeed = param2;
         }
      }
      
      public function open() : void
      {
         tfHealth.alpha = 0;
         tfStrength.alpha = 0;
         tfArmor.alpha = 0;
         tfSpeed.alpha = 0;
         tfHealthJolts.text = Utils.zeroPreFill(0,JOLTS_VALUE_LENGTH);
         tfStrengthJolts.text = Utils.zeroPreFill(0,JOLTS_VALUE_LENGTH);
         tfArmorJolts.text = Utils.zeroPreFill(0,JOLTS_VALUE_LENGTH);
         tfSpeedJolts.text = Utils.zeroPreFill(0,JOLTS_VALUE_LENGTH);
         _tweenProp.joltsHealth = 0;
         _tweenProp.joltsStrength = 0;
         _tweenProp.joltsArmor = 0;
         _tweenProp.joltsSpeed = 0;
         Tweener.addTween(this,{
            "_autoAlpha":1,
            "delay":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(tfHealth,{
            "_autoAlpha":1,
            "delay":1.1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(tfStrength,{
            "_autoAlpha":1,
            "delay":1.2,
            "base":TWEEN_BASE
         });
         Tweener.addTween(tfArmor,{
            "_autoAlpha":1,
            "delay":1.3,
            "base":TWEEN_BASE
         });
         Tweener.addTween(tfSpeed,{
            "_autoAlpha":1,
            "delay":1.4,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_tweenProp,{
            "joltsHealth":_joltsHealth,
            "delay":1.65,
            "base":TWEEN_BASE,
            "rounded":true,
            "time":2
         });
         Tweener.addTween(_tweenProp,{
            "joltsStrength":_joltsStrength,
            "delay":1.9,
            "base":TWEEN_BASE,
            "rounded":true,
            "time":2
         });
         Tweener.addTween(_tweenProp,{
            "joltsArmor":_joltsArmor,
            "delay":2.15,
            "base":TWEEN_BASE,
            "rounded":true,
            "time":2
         });
         Tweener.addTween(_tweenProp,{
            "joltsSpeed":_joltsSpeed,
            "delay":2.4,
            "base":TWEEN_BASE,
            "rounded":true,
            "time":2
         });
      }
      
      public function setGameName(param1:String, param2:String) : void
      {
         switch(param1)
         {
            case TYPE_HEALTH:
               tfHealth.text = param2;
               break;
            case TYPE_STRENGTH:
               tfStrength.text = param2;
               break;
            case TYPE_ARMOR:
               tfArmor.text = param2;
               break;
            case TYPE_SPEED:
               tfSpeed.text = param2;
         }
      }
      
      private function prependZeros(param1:int, param2:int) : String
      {
         var _loc3_:String = param1.toString();
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
   }
}

