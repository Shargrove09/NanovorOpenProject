package com.arkadium.virmon.collection.substates.nanovor.components
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.collection.substates.nanovor.elements.BuffTextElement;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.elements.icons.stats.*;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonSmallComponent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol89")]
   public class NanovorStatViewComponent extends MovieClip
   {
      
      public var currentField:TextField;
      
      public var mcCircle:MovieClip;
      
      private var _currentVal:int;
      
      public var bar:MovieClip;
      
      public var joltsField:TextField;
      
      private var _minVal:int;
      
      private var _jolts:int;
      
      private var _type:String;
      
      public var mcJoltBalanceBG:MovieClip;
      
      public var masker:MovieClip;
      
      public var mcJoltCostLabel:MovieClip;
      
      private var _cost:int;
      
      public var costField:TextField;
      
      public var barBg:MovieClip;
      
      public var chevron:MovieClip;
      
      private var _startVal:int;
      
      private var _maxVal:int;
      
      private var _buffBtn:SpinningButtonComponent;
      
      private var _unbuffBtn:SpinningButtonSmallComponent;
      
      public var minField:TextField;
      
      private const MIN_WIDTH:int = 3;
      
      public var typeField:TextField;
      
      private var _color:Number;
      
      public var labelField:TextField;
      
      public var mcMax:MovieClip;
      
      public var bwIcon:MovieClip;
      
      public var colorIcon:MovieClip;
      
      public var maxField:TextField;
      
      public function NanovorStatViewComponent(param1:String, param2:Number)
      {
         super();
         _type = param1;
         _color = param2;
         init();
      }
      
      public function getDelta() : int
      {
         return _currentVal - _startVal;
      }
      
      private function init() : void
      {
         chevron.stop();
         initIcons();
         initButtons();
         initColor();
         addListeners();
         update();
      }
      
      private function updateButtons() : void
      {
         if(_currentVal < _maxVal && _jolts >= _cost)
         {
            if(!_buffBtn.isOpened)
            {
               _buffBtn.open();
            }
         }
         else if(_buffBtn.isOpened)
         {
            _buffBtn.close();
         }
         if(_currentVal > _startVal)
         {
            if(!_unbuffBtn.isOpened)
            {
               _unbuffBtn.open();
            }
         }
         else if(_unbuffBtn.isOpened)
         {
            _unbuffBtn.close();
         }
      }
      
      private function addListeners() : void
      {
         _buffBtn.mcHitArea.addEventListener(MouseEvent.CLICK,onBuffClick,false,0,true);
         _unbuffBtn.addEventListener(MouseEvent.CLICK,onUnbuffClick,false,0,true);
      }
      
      private function removeListeners() : void
      {
         _buffBtn.mcHitArea.removeEventListener(MouseEvent.CLICK,onBuffClick);
         _unbuffBtn.removeEventListener(MouseEvent.CLICK,onUnbuffClick);
      }
      
      public function setValue(param1:int, param2:int, param3:int) : *
      {
         if(param1 > _currentVal)
         {
            chevron.gotoAndPlay(1);
         }
         else
         {
            chevron.gotoAndStop(1);
         }
         _currentVal = param1;
         _cost = param2;
         _jolts = param3;
         update();
      }
      
      private function onUnbuffClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("unbuffEvent"));
      }
      
      private function initColor() : void
      {
         var _loc1_:ColorTransform = new ColorTransform();
         _loc1_.alphaMultiplier = 2 / 3;
         _loc1_.color = _color;
         bar.transform.colorTransform = _loc1_;
         _loc1_.alphaMultiplier = 1 / 3;
         barBg.transform.colorTransform = _loc1_;
         currentField.filters = [new GlowFilter(_color,1,10,10)];
      }
      
      public function get minValue() : int
      {
         return _minVal;
      }
      
      public function setData(param1:int, param2:int, param3:int, param4:Array, param5:int) : void
      {
         _minVal = param3;
         _maxVal = param2;
         _currentVal = Math.max(param3,param1);
         _startVal = _currentVal;
         _jolts = param5;
         _cost = _currentVal == param2 ? -1 : int(param4[_currentVal - param3]);
         update();
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(_currentVal == _minVal && _cost != -1)
         {
            Tweener.removeTweens(colorIcon);
            Tweener.removeTweens(currentField);
            Tweener.removeTweens(bar);
            Tweener.removeTweens(masker);
            Tweener.addTween(colorIcon,{
               "x":bwIcon.x,
               "time":0.5,
               "rounded":true
            });
            Tweener.addTween(bar,{
               "width":MIN_WIDTH,
               "time":0.5
            });
            currentField.x = barBg.x - currentField.width / 2 + 5;
            currentField.visible = false;
            chevron.x = 0;
            masker.width = 0;
         }
         else
         {
            _loc1_ = barBg.x;
            _loc2_ = barBg.width - 20;
            _loc3_ = _cost == -1 ? 1 : Math.max(0,(_currentVal - _minVal) / (_maxVal - _minVal));
            _loc4_ = _loc1_ + _loc3_ * _loc2_;
            Tweener.addTween(colorIcon,{
               "x":_loc4_,
               "time":0.5,
               "rounded":true
            });
            Tweener.addTween(currentField,{
               "x":_loc4_ + 10 - currentField.width / 2,
               "time":0.5,
               "rounded":true
            });
            Tweener.addTween(bar,{
               "width":_loc3_ * _loc2_,
               "time":0.5
            });
            Tweener.addTween(masker,{
               "width":_loc3_ * _loc2_,
               "time":0.5
            });
            chevron.x = _loc4_;
            currentField.visible = true;
         }
         updateFields();
         updateButtons();
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorStatView: " + param1);
      }
      
      private function onBuffClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("buffEvent"));
      }
      
      private function updateFields() : void
      {
         labelField.text = _type.toUpperCase();
         typeField.text = _type.toUpperCase() + " JOLTS";
         costField.text = _cost == -1 ? "MAXED" : "" + _cost;
         joltsField.text = "" + _jolts;
         maxField.text = "" + _maxVal;
         minField.text = "" + _minVal;
         currentField.text = "" + _currentVal;
      }
      
      private function initButtons() : void
      {
         _buffBtn = new SpinningButtonComponent(new BuffTextElement());
         _buffBtn.scaleX = 1.23;
         _buffBtn.scaleY = 1.23;
         _buffBtn.x = 239;
         _buffBtn.y = 32;
         _unbuffBtn = new SpinningButtonSmallComponent(new SpinnerIconX());
         _unbuffBtn.scaleX = 0.89;
         _unbuffBtn.scaleY = 0.89;
         _unbuffBtn.x = 262;
         _unbuffBtn.y = 52;
         _unbuffBtn.color = SpinningButtonSmallComponent.COLOR_RED;
         addChild(_buffBtn);
         addChild(_unbuffBtn);
      }
      
      private function initIcons() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         while(bwIcon.numChildren > 0)
         {
            bwIcon.removeChildAt(0);
         }
         while(colorIcon.numChildren > 0)
         {
            colorIcon.removeChildAt(0);
         }
         switch(_type.toLowerCase())
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
         colorIcon.addChild(_loc1_);
         bwIcon.addChild(_loc2_);
      }
      
      public function get maxValue() : int
      {
         return _maxVal;
      }
      
      public function get value() : int
      {
         return _currentVal;
      }
      
      public function destroy() : void
      {
         removeListeners();
         _buffBtn.destroy();
         _unbuffBtn.destroy();
      }
   }
}

