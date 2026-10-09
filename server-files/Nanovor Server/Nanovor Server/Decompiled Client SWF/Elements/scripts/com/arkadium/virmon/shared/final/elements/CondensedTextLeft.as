package com.arkadium.virmon.shared.final.elements
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol208")]
   public class CondensedTextLeft extends Sprite
   {
      
      public var textfield:TextField;
      
      public function CondensedTextLeft(param1:String = "")
      {
         super();
         text = param1;
      }
      
      public function set text(param1:String) : void
      {
         textfield.text = param1;
         textfield.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function get text() : String
      {
         return textfield.text;
      }
   }
}

