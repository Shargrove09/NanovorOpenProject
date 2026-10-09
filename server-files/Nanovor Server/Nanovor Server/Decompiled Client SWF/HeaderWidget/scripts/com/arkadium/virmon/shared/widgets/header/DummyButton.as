package com.arkadium.virmon.shared.widgets.header
{
   internal class DummyButton extends MainButton
   {
      
      public function DummyButton(param1:Number)
      {
         super("");
         this.buttonMode = false;
         this.mouseEnabled = false;
         this.mcBGButton.width = param1;
         this.mcDivider.x = param1 - PADDING;
         this.tfLabel.text = "";
      }
   }
}

