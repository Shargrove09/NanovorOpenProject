package com.arkadium.virmon.shared.components.infowindow
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   internal class PreReqText extends TextField
   {
      
      public function PreReqText(param1:String = "")
      {
         super();
         var _loc2_:EuroStileBoldCondensed = new EuroStileBoldCondensed();
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.font = _loc2_.fontName;
         _loc3_.size = 11;
         _loc3_.color = 16777215;
         _loc3_.bold = true;
         _loc3_.align = TextFormatAlign.LEFT;
         defaultTextFormat = _loc3_;
         embedFonts = true;
         text = param1;
         autoSize = TextFieldAutoSize.LEFT;
         multiline = true;
         wordWrap = true;
         selectable = false;
         antiAliasType = AntiAliasType.NORMAL;
      }
   }
}

