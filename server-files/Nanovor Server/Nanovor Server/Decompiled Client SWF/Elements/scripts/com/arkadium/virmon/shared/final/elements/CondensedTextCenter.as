package com.arkadium.virmon.shared.final.elements
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol210")]
   public class CondensedTextCenter extends Sprite
   {
      
      public var textfield:TextField;
      
      public function CondensedTextCenter(param1:String = "")
      {
         super();
         text = param1;
      }
      
      public function set text(param1:String) : void
      {
         textfield.text = param1;
         textfield.autoSize = TextFieldAutoSize.CENTER;
      }
      
      public function get text() : String
      {
         return textfield.text;
      }
   }
}

