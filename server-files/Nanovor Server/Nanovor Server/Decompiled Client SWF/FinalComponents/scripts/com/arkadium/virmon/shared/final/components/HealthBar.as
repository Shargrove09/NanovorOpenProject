package com.arkadium.virmon.shared.final.components
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.elements.icons.stats.StatHealth;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol402")]
   public class HealthBar extends MovieClip
   {
      
      public static const HEALTH_BAR_TWEEN_SECONDS:Number = 0.4;
      
      public static const TWEEN_EASING:String = "easeInOutQuad";
      
      private static const HEALTH_BAR_FILL_FULL_Y:int = 0;
      
      private static const HEALTH_BAR_FILL_EMPTY_Y:int = 71;
      
      private static const HEALTH_BAR_FILL_PERCENT_DELTA:Number = Number(HEALTH_BAR_FILL_EMPTY_Y - HEALTH_BAR_FILL_FULL_Y) / 100;
      
      private static const HEALTH_ICON_BLINK_ALPHA:Number = 0.6;
      
      private static const HEALTH_ICON_BLINK_SECONDS:Number = 0.25;
      
      public var mcHealthBarFill:MovieClip;
      
      private var _bBlinking:Boolean = false;
      
      private var _iconHealth:StatHealth;
      
      private var _endHealth:Number = 0;
      
      private var _startHealth:Number = 0;
      
      public var mcHealthIcon:MovieClip;
      
      private var _baseHealth:Number = 0;
      
      private var _tweenProp:TweenProp;
      
      public var tfHealthText:TextField;
      
      public function HealthBar()
      {
         super();
         this._tweenProp = new TweenProp(this);
         this._iconHealth = new StatHealth();
         this.mcHealthIcon.addChild(this._iconHealth);
      }
      
      public function get blinking() : Boolean
      {
         return this._bBlinking;
      }
      
      public function set blinking(param1:Boolean) : void
      {
         if(param1 && this._bBlinking)
         {
            return;
         }
         Tweener.removeTweens(this.mcHealthIcon,"alpha");
         if(!this._bBlinking)
         {
            this.alternateBlinking();
         }
         this._bBlinking = param1;
      }
      
      public function set buffedHealth(param1:Boolean) : void
      {
         this._iconHealth.isBuffed = param1;
      }
      
      public function setHealth(param1:int, param2:int, param3:int = -1) : void
      {
         var _loc4_:Number = NaN;
         if(param3 == -1)
         {
            param3 == param2;
         }
         if(param3 != param2)
         {
            this.mcHealthBarFill.y = HEALTH_BAR_FILL_EMPTY_Y - param1 * 100 / Number(param2) * HEALTH_BAR_FILL_PERCENT_DELTA;
         }
         if(param2 <= 0)
         {
            _loc4_ = HEALTH_BAR_FILL_EMPTY_Y;
         }
         else
         {
            _loc4_ = HEALTH_BAR_FILL_EMPTY_Y - param1 * 100 / Number(param2) * HEALTH_BAR_FILL_PERCENT_DELTA;
         }
         Tweener.removeTweens(this.mcHealthBarFill,y);
         Tweener.removeTweens(this._tweenProp,this.tfHealthText);
         Tweener.addTween(this.mcHealthBarFill,{
            "y":_loc4_,
            "time":HEALTH_BAR_TWEEN_SECONDS,
            "transition":TWEEN_EASING
         });
         Tweener.addTween(this._tweenProp,{
            "healthText":param1,
            "time":HEALTH_BAR_TWEEN_SECONDS,
            "transition":TWEEN_EASING,
            "rounded":true
         });
      }
      
      private function alternateBlinking() : void
      {
         if(this.mcHealthIcon.alpha < 1)
         {
            Tweener.addTween(this.mcHealthIcon,{
               "alpha":1,
               "time":HEALTH_ICON_BLINK_SECONDS,
               "transition":TWEEN_EASING,
               "onComplete":this.alternateBlinking
            });
         }
         else
         {
            Tweener.addTween(this.mcHealthIcon,{
               "alpha":HEALTH_ICON_BLINK_ALPHA,
               "time":HEALTH_ICON_BLINK_SECONDS,
               "transition":TWEEN_EASING,
               "onComplete":this.alternateBlinking
            });
         }
      }
      
      public function playHealthChangeAnimation() : void
      {
         this.setHealth(this._endHealth,this._baseHealth,this._startHealth);
      }
      
      public function setHealthVars(param1:Number, param2:Number, param3:Number) : void
      {
         this._startHealth = param1;
         this._endHealth = param2;
         this._baseHealth = param3;
         var _loc4_:String = "HealthBar::setHealthVars";
         _loc4_ += "\n\t_startHealth = " + param1;
         _loc4_ += "\n\t_endHealth = " + param2;
         _loc4_ += "\n\t_baseHealth = " + param3;
         DebugLog.instance.log(_loc4_);
      }
      
      public function get buffedHealth() : Boolean
      {
         return this._iconHealth.isBuffed;
      }
   }
}

class TweenProp
{
   
   private var _ui:HealthBar;
   
   public function TweenProp(param1:HealthBar)
   {
      super();
      this._ui = param1;
   }
   
   public function get healthText() : String
   {
      return this._ui.tfHealthText.text;
   }
   
   public function set healthText(param1:String) : void
   {
      this._ui.tfHealthText.text = param1;
   }
}
