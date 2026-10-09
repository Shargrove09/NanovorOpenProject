package com.arkadium.virmon.shared.widgets.megawidget
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MegaWidgetButtonController
   {
      
      private var _handler:Function;
      
      private var _base:MovieClip;
      
      private var _button:SpinningButtonComponent;
      
      public function MegaWidgetButtonController(param1:MovieClip)
      {
         super();
         _base = param1;
         _button = _base.mcButton;
         _button.addEventListener(MouseEvent.CLICK,onButtonClick);
         _base.alpha = 0;
         _base.mouseEnabled = false;
         _base.mouseChildren = false;
         removeButton();
      }
      
      public function set clickHandler(param1:Function) : void
      {
         _handler = param1;
      }
      
      public function open() : void
      {
         _base.mouseEnabled = true;
         _base.mouseChildren = true;
         _base.addChild(_button);
         _button.open();
         Tweener.addTween(_base,{
            "_autoAlpha":1,
            "time":0.5
         });
      }
      
      public function get button() : SpinningButtonComponent
      {
         return _button;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         if(_handler != null)
         {
            _handler.call(this);
         }
      }
      
      public function close() : void
      {
         _base.mouseEnabled = false;
         _base.mouseChildren = false;
         _button.close();
         Tweener.addTween(_base,{
            "_autoAlpha":0,
            "time":0.5,
            "onComplete":removeButton
         });
      }
      
      public function destroy() : void
      {
         _button.destroy();
      }
      
      private function removeButton() : void
      {
         if(null != _button.parent)
         {
            _button.parent.removeChild(_button);
         }
      }
   }
}

