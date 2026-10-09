package com.arkadium.virmon.device.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class DeviceCenterStripe extends Sprite
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.25,
         "transition":Equations.easeInOutQuad
      };
      
      private static const TEXT_FIELD_X:Number = -300;
      
      private static const TEXT_FIELD_TWEEN_X:Number = 50;
      
      private static const TITLE_Y:int = 13;
      
      private static const TITLE_CENTER_Y:int = 5;
      
      public var tfSubtitle1:TextField;
      
      public var tfSubtitle2:TextField;
      
      public var tfTitle1:TextField;
      
      public var tfTitle2:TextField;
      
      private var _currentSubtitle:TextField;
      
      private var _currentTitle:TextField;
      
      public function DeviceCenterStripe()
      {
         super();
         _currentTitle = tfTitle1;
         _currentSubtitle = tfTitle1;
      }
      
      public function hide() : void
      {
         toggleAlpha(0);
      }
      
      private function toggleAlpha(param1:Number) : void
      {
         Tweener.addTween(this,{
            "_autoAlpha":param1,
            "base":TWEEN_BASE
         });
      }
      
      public function setText(param1:String, param2:String) : void
      {
         Tweener.addTween(_currentTitle,{
            "_autoAlpha":0,
            "x":TEXT_FIELD_X + TEXT_FIELD_TWEEN_X,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_currentSubtitle,{
            "_autoAlpha":0,
            "x":TEXT_FIELD_X + TEXT_FIELD_TWEEN_X,
            "base":TWEEN_BASE
         });
         _currentTitle = _currentTitle === tfTitle1 ? tfTitle2 : tfTitle1;
         _currentSubtitle = _currentSubtitle === tfSubtitle1 ? tfSubtitle2 : tfSubtitle1;
         _currentTitle.y = "" == param2 ? TITLE_CENTER_Y : TITLE_Y;
         _currentTitle.text = param1;
         _currentSubtitle.text = param2;
         _currentTitle.x = TEXT_FIELD_X - TEXT_FIELD_TWEEN_X;
         _currentSubtitle.x = TEXT_FIELD_X - TEXT_FIELD_TWEEN_X;
         Tweener.addTween(_currentTitle,{
            "_autoAlpha":1,
            "x":TEXT_FIELD_X,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_currentSubtitle,{
            "_autoAlpha":1,
            "x":TEXT_FIELD_X,
            "base":TWEEN_BASE
         });
      }
      
      public function show() : void
      {
         toggleAlpha(1);
      }
   }
}

