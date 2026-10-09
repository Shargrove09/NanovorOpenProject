package com.arkadium.virmon.shared.final.elements
{
   import com.arkadium.virmon.shared.elements.icons.FatSwirl;
   import flash.display.MovieClip;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol206")]
   public class AlertBubble extends MovieClip
   {
      
      public var mcHolder:MovieClip;
      
      public var tfNumber:TextField;
      
      private var _dropShadow:DropShadowFilter;
      
      public function AlertBubble(param1:int = -1)
      {
         super();
         mcHolder.addChild(new FatSwirl());
         if(param1 != -1)
         {
            this.number = param1;
         }
         else
         {
            tfNumber.text = "1";
         }
         _dropShadow = new DropShadowFilter(2,45,0,0.5);
         this.filters = [_dropShadow];
      }
      
      public function set number(param1:int) : void
      {
         tfNumber.text = param1.toString();
      }
      
      public function get number() : int
      {
         return int(tfNumber.text);
      }
      
      public function set color(param1:uint) : void
      {
      }
   }
}

