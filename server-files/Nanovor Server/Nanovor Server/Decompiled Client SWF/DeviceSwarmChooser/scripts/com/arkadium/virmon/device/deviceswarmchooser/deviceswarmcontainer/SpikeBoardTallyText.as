package com.arkadium.virmon.device.deviceswarmchooser.deviceswarmcontainer
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class SpikeBoardTallyText extends TextField
   {
      
      public var textFormat:TextFormat;
      
      public function SpikeBoardTallyText(param1:String, param2:uint = 16777215)
      {
         super();
         var _loc3_:EuroStileBoldCondensed = new EuroStileBoldCondensed();
         textFormat = new TextFormat();
         textFormat.font = _loc3_.fontName;
         textFormat.size = 10;
         textFormat.color = param2;
         textFormat.bold = true;
         textFormat.align = TextFormatAlign.LEFT;
         defaultTextFormat = textFormat;
         embedFonts = true;
         text = param1;
         autoSize = TextFieldAutoSize.LEFT;
         multiline = false;
         selectable = false;
         antiAliasType = AntiAliasType.NORMAL;
      }
      
      public function updateColor(param1:uint) : void
      {
         textColor = param1;
      }
      
      public function updateText(param1:String) : void
      {
         text = param1;
      }
   }
}

