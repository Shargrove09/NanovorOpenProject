package com.arkadium.virmon.shared.components.avatar
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class EBCText extends TextField
   {
      
      public static var textFormat:TextFormat;
      
      public function EBCText(param1:String = "")
      {
         var _loc2_:EuroStileBoldCondensed = null;
         super();
         if(textFormat == null)
         {
            _loc2_ = new EuroStileBoldCondensed();
            textFormat = new TextFormat();
            textFormat.font = _loc2_.fontName;
            textFormat.size = 13;
            textFormat.color = 16777215;
            textFormat.bold = true;
            textFormat.align = TextFormatAlign.CENTER;
         }
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

