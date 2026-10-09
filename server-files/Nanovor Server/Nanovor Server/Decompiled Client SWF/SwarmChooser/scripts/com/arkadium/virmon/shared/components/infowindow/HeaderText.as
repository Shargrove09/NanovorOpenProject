package com.arkadium.virmon.shared.components.infowindow
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldExtended2;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   internal class HeaderText extends TextField
   {
      
      public function HeaderText(param1:String = "")
      {
         super();
         var _loc2_:EuroStileBoldExtended2 = new EuroStileBoldExtended2();
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.font = _loc2_.fontName;
         _loc3_.size = 12;
         _loc3_.color = 16777215;
         _loc3_.bold = true;
         _loc3_.align = TextFormatAlign.LEFT;
         defaultTextFormat = _loc3_;
         embedFonts = true;
         text = param1;
         autoSize = TextFieldAutoSize.LEFT;
         multiline = false;
         selectable = false;
         antiAliasType = AntiAliasType.NORMAL;
      }
   }
}

