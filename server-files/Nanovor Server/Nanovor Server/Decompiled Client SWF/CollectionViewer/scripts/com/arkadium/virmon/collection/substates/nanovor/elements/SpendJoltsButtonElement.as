package com.arkadium.virmon.collection.substates.nanovor.elements
{
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol95")]
   public class SpendJoltsButtonElement extends Sprite
   {
      
      private var _btn:SpinningButtonComponent;
      
      public function SpendJoltsButtonElement()
      {
         super();
         _btn = new SpinningButtonComponent(new JoltIconElement());
         _btn.scaleX = 1.24;
         _btn.scaleY = 1.24;
         _btn.x = 131;
         _btn.y = 27;
         addChild(_btn);
         _btn.open();
      }
      
      public function destroy() : void
      {
         _btn.destroy();
      }
      
      public function get btn() : SpinningButtonComponent
      {
         return _btn;
      }
   }
}

