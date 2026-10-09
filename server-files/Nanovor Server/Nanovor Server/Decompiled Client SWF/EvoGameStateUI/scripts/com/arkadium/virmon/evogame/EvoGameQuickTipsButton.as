package com.arkadium.virmon.evogame
{
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconQuestion;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3")]
   public class EvoGameQuickTipsButton extends MovieClip
   {
      
      private var _button:SpinningButtonComponent;
      
      public function EvoGameQuickTipsButton()
      {
         super();
         _button = new SpinningButtonComponent(new SpinnerIconQuestion());
         _button.open();
         addChild(_button);
      }
      
      public function getButton() : SpinningButtonComponent
      {
         return _button;
      }
   }
}

