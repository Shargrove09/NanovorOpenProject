package com.arkadium.virmon.shared.final.elements
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class CondensedTextLeft extends Sprite
   {
      
      public var textfield:TextField;
      
      public function CondensedTextLeft(param1:String = "")
      {
         super();
         this.text = param1;
      }
      
      public function set text(param1:String) : void
      {
         this.textfield.text = param1;
         this.textfield.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function get text() : String
      {
         return this.textfield.text;
      }
   }
}

