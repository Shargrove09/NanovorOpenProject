package com.arkadium.virmon.shared.final.components.spotlight
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldExtended2;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class SpotlightText extends TextField
   {
      
      public static var textFormat:TextFormat;
      
      public function SpotlightText(param1:String = "")
      {
         var _loc2_:EuroStileBoldExtended2 = null;
         super();
         if(textFormat == null)
         {
            _loc2_ = new EuroStileBoldExtended2();
            textFormat = new TextFormat();
            textFormat.font = _loc2_.fontName;
            textFormat.size = 18;
            textFormat.color = 16777215;
            textFormat.bold = true;
            textFormat.align = TextFormatAlign.CENTER;
         }
         defaultTextFormat = textFormat;
         embedFonts = true;
         text = param1;
         autoSize = TextFieldAutoSize.LEFT;
         multiline = true;
         selectable = false;
         antiAliasType = AntiAliasType.NORMAL;
      }
   }
}

