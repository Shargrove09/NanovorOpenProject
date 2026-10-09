package com.arkadium.virmon.evogame
{
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.final.elements.ButtonSpinner;
   import flash.display.MovieClip;
   
   public class EvoGameQuitButton extends MovieClip
   {
      
      private var _button:SpinningButtonComponent;
      
      private var _label:EvoGameBackLabel;
      
      private var _spinner:ButtonSpinner;
      
      public function EvoGameQuitButton()
      {
         super();
         _label = new EvoGameBackLabel();
         _spinner = new ButtonSpinner();
         _button = new SpinningButtonComponent(new SpinnerIconX());
         _label.x = -105;
         _button.color = SpinningButtonComponent.COLOR_RED;
         _button.open();
         _button.scaleX = _button.scaleY = 1.5;
         _spinner.scaleX = _spinner.scaleY = 1.5;
         addChild(_label);
         addChild(_spinner);
         addChild(_button);
      }
   }
}

