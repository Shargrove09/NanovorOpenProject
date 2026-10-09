package com.arkadium.virmon.shared.final.elements
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldExtended2;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class EuroStileBoldExtended2Text extends TextField
   {
      
      public static var textFormat:TextFormat;
      
      public function EuroStileBoldExtended2Text(param1:String, param2:int, param3:uint, param4:String = "left")
      {
         super();
         var _loc5_:EuroStileBoldExtended2 = new EuroStileBoldExtended2();
         textFormat = new TextFormat();
         textFormat.font = _loc5_.fontName;
         textFormat.size = param2;
         textFormat.color = param3;
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
   }
}

