package com.arkadium.virmon.device.ui
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol31")]
   public class UpdatePanelAchievementSlot extends Sprite
   {
      
      public var tfTitle:TextField;
      
      public var tfValue:TextField;
      
      public function UpdatePanelAchievementSlot()
      {
         super();
         this.cacheAsBitmap = true;
      }
      
      public function init(param1:String, param2:String) : void
      {
         tfTitle.text = param1;
         tfValue.text = param2;
      }
   }
}

