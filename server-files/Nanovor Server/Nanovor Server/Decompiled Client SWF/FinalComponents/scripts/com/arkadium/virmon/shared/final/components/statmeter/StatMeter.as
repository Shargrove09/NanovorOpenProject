package com.arkadium.virmon.shared.final.components.statmeter
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.elements.icons.stats.StatArmor;
   import com.arkadium.virmon.shared.elements.icons.stats.StatHealth;
   import com.arkadium.virmon.shared.elements.icons.stats.StatSpeed;
   import com.arkadium.virmon.shared.elements.icons.stats.StatStrength;
   import fl.motion.AdjustColor;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol505")]
   public class StatMeter extends MovieClip implements IStatMeter
   {
      
      private static const ICON_WIDTH:int = 18;
      
      private static const ICON_HEIGHT:int = 18;
      
      private static const MAX_TWEEN_TIME:Number = 3;
      
      private static const CHEVRON_LOOPS:int = 3;
      
      private var _currentValueTickerTimer:Timer;
      
      private var _minValueLabel:StatMeterText;
      
      private var _maxValueLabel:StatMeterText;
      
      private var _bwIcon:MovieClip;
      
      private var _chevronMask:Shape;
      
      private var _type:String;
      
      private var _minValue:int;
      
      public var mcProgressBar:MovieClip;
      
      private var _curChevronLoop:int;
      
      private var _maxValue:int;
      
      public var mcChevrons:MovieClip;
      
      private var _maxLabel:StatMeterText;
      
      private var _currentValue:int;
      
      public var mcBG:MovieClip;
      
      private var _currentValueLabel:StatMeterText;
      
      private var _color:uint;
      
      private var _typeLabel:StatMeterText;
      
      private var _colorIcon:MovieClip;
      
      private var _iconDestX:Number;
      
      public function StatMeter(param1:String, param2:uint)
      {
         super();
         this._type = param1;
         this._color = param2;
         this.init();
      }
      
      private function setBGColor() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.setTint(this._color,1);
         this.mcBG.transform.colorTransform = _loc1_;
      }
      
      private function init() : void
      {
         this.setBGColor();
         this.loadIcons();
         this.makeTextLabels();
         this.initProgressBar();
         this.initChevrons();
      }
      
      private function makeTextLabels() : void
      {
         this._typeLabel = new StatMeterText("EuroStileBoldCondensed",this._type.toUpperCase(),10,13421772);
         addChild(this._typeLabel);
         this._typeLabel.x = this._bwIcon.x - (this._typeLabel.width - ICON_WIDTH) / 2;
         this._typeLabel.y = this._bwIcon.y - this._typeLabel.textHeight - 3;
         this._minValueLabel = new StatMeterText("EuroStileBoldExtended2","0",8,16777215);
         addChild(this._minValueLabel);
         this._minValueLabel.x = this._bwIcon.x - (this._minValueLabel.width - ICON_WIDTH) / 2;
         this._minValueLabel.y = this._bwIcon.y + ICON_HEIGHT - 1;
         this._maxValueLabel = new StatMeterText("EuroStileBoldExtended2","0",8,6671832);
         addChild(this._maxValueLabel);
         this._maxValueLabel.x = this.mcBG.x + this.mcBG.width - 15;
         this._maxValueLabel.y = this._minValueLabel.y;
         this._currentValueLabel = new StatMeterText("EuroStileBoldExtended2","0",10,16777215);
         addChild(this._currentValueLabel);
         this._currentValueLabel.x = this._minValueLabel.x;
         this._currentValueLabel.y = this._minValueLabel.y;
         this._currentValueLabel.visible = false;
         var _loc1_:GlowFilter = new GlowFilter(this._color,1,10,10,1,3);
         this._currentValueLabel.filters = [_loc1_];
         this._maxLabel = new StatMeterText("EuroStileBoldCondensed","MAX",8,6671832,false);
         addChild(this._maxLabel);
         this._maxLabel.x = this.mcBG.x + this.mcBG.width - this._maxLabel.textWidth;
         this._maxLabel.y = this.mcBG.y - this._maxLabel.textHeight - 2;
      }
      
      private function startCurrentValueTicker() : void
      {
         this._currentValueLabel.updateText(String(this._minValue));
         this._currentValueTickerTimer = new Timer(250,0);
         this._currentValueTickerTimer.addEventListener(TimerEvent.TIMER,this.updateCurrentValueTicker,false,0,true);
         this._currentValueTickerTimer.start();
      }
      
      public function setData(param1:int, param2:int, param3:int = 0) : void
      {
         this._minValue = param1;
         this._maxValue = param2;
         this._currentValue = param3;
         this._minValueLabel.updateText(String(this._minValue));
         this._maxValueLabel.updateText(String(this._maxValue));
         this._currentValueLabel.updateText(String(this._currentValue));
         this.adjustLevel();
      }
      
      private function adjustLevel() : void
      {
         var _loc1_:int = this._maxValue - this._minValue;
         var _loc2_:Number = (this._currentValue - this._minValue) / _loc1_;
         this._iconDestX = Math.floor(this.mcBG.x + this.mcBG.width * _loc2_);
         var _loc3_:Number = this._iconDestX - (this._currentValueLabel.width - ICON_WIDTH) / 2;
         var _loc4_:Number = (this._iconDestX + ICON_WIDTH / 2) / this.mcBG.width;
         var _loc5_:Number = MAX_TWEEN_TIME * _loc2_;
         this._colorIcon.x = 0;
         this._currentValueLabel.x = this._colorIcon.x - (this._currentValueLabel.width - ICON_WIDTH) / 2;
         this._currentValueLabel.visible = true;
         if(_loc2_ > 0)
         {
            this.startCurrentValueTicker();
            Tweener.addTween(this._colorIcon,{
               "x":this._iconDestX,
               "time":_loc5_,
               "transition":"easeOutQuad",
               "onComplete":this.stopCurrentValueTicker
            });
            Tweener.addTween(this._currentValueLabel,{
               "x":_loc3_,
               "time":_loc5_,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(this.mcProgressBar,{
               "scaleX":_loc4_,
               "time":_loc5_,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(this._chevronMask,{
               "scaleX":_loc4_,
               "time":_loc5_,
               "transition":"easeOutQuad"
            });
            this._curChevronLoop = CHEVRON_LOOPS;
            this.playChevrons(this._iconDestX,_loc5_ / CHEVRON_LOOPS);
         }
      }
      
      private function stopCurrentValueTicker() : void
      {
         this._currentValueTickerTimer.stop();
         this._currentValueTickerTimer.removeEventListener(TimerEvent.TIMER,this.updateCurrentValueTicker);
         this._currentValueLabel.updateText(String(this._currentValue));
      }
      
      private function updateCurrentValueTicker(param1:TimerEvent) : void
      {
         var _loc2_:int = this._currentValue - this._minValue;
         var _loc3_:Number = this._colorIcon.x / this._iconDestX;
         var _loc4_:Number = this._minValue + Math.floor(_loc2_ * _loc3_);
         this._currentValueLabel.updateText(String(_loc4_));
      }
      
      private function loadIcons() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         this._bwIcon = new MovieClip();
         this._colorIcon = new MovieClip();
         addChild(this._bwIcon);
         addChild(this._colorIcon);
         switch(this._type.toLowerCase())
         {
            case "health":
               _loc1_ = new StatHealth();
               _loc2_ = new StatHealth();
               break;
            case "strength":
               _loc1_ = new StatStrength();
               _loc2_ = new StatStrength();
               break;
            case "armor":
               _loc1_ = new StatArmor();
               _loc2_ = new StatArmor();
               break;
            case "speed":
               _loc1_ = new StatSpeed();
               _loc2_ = new StatSpeed();
         }
         this._bwIcon.addChild(_loc1_);
         this._colorIcon.addChild(_loc2_);
         _loc1_.scaleX = _loc1_.scaleY = this._colorIcon.scaleX = this._colorIcon.scaleY = 0.9;
         this.initIcons();
      }
      
      private function getMask(param1:int, param2:int) : Shape
      {
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(0);
         _loc3_.graphics.drawRect(0,0,param1,param2);
         _loc3_.graphics.endFill();
         return _loc3_;
      }
      
      private function playChevrons(param1:Number, param2:Number) : void
      {
         this.mcChevrons.x = this.mcBG.x - this.mcChevrons.width;
         if(this._curChevronLoop > 0)
         {
            Tweener.addTween(this.mcChevrons,{
               "x":param1,
               "time":param2,
               "transition":"linear",
               "onComplete":this.playChevrons,
               "onCompleteParams":[param1,param2]
            });
            --this._curChevronLoop;
         }
      }
      
      private function initIcons() : void
      {
         var _loc1_:AdjustColor = new AdjustColor();
         _loc1_.brightness = 0;
         _loc1_.contrast = 0;
         _loc1_.saturation = -100;
         _loc1_.hue = 0;
         this._bwIcon.filters = [new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray())];
         this._bwIcon.x = this.mcBG.x - ICON_WIDTH - 7;
         this._bwIcon.y = this.mcBG.y - (ICON_HEIGHT - this.mcBG.height) / 2;
         this._colorIcon.x = this._bwIcon.x;
         this._colorIcon.y = this._bwIcon.y;
      }
      
      private function initChevrons() : void
      {
         this._chevronMask = this.getMask(this.mcBG.width,this.mcBG.height);
         addChild(this._chevronMask);
         this.mcChevrons.x = this.mcBG.x - this.mcChevrons.width;
         this.mcChevrons.mask = this._chevronMask;
         this._chevronMask.scaleX = 0;
      }
      
      private function initProgressBar() : void
      {
         var _loc1_:Color = new Color();
         _loc1_.setTint(this._color,1);
         this.mcProgressBar.transform.colorTransform = _loc1_;
         this.mcProgressBar.scaleX = 0;
      }
   }
}

