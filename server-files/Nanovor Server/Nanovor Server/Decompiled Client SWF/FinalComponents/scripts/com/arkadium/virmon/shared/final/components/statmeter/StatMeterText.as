package com.arkadium.virmon.shared.final.components.statmeter
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldExtended2;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class StatMeterText extends TextField
   {
      
      public function StatMeterText(param1:String, param2:String, param3:int, param4:uint, param5:Boolean = true)
      {
         var _loc6_:* = undefined;
         super();
         var _loc7_:TextFormat = new TextFormat();
         switch(param1)
         {
            case "EuroStileBoldCondensed":
               _loc6_ = new EuroStileBoldCondensed();
               _loc7_.letterSpacing = 1.5;
               break;
            case "EuroStileBoldExtended2":
               _loc6_ = new EuroStileBoldExtended2();
         }
         _loc7_.font = _loc6_.fontName;
         _loc7_.size = param3;
         _loc7_.color = param4;
         _loc7_.bold = param5;
         _loc7_.align = TextFormatAlign.CENTER;
         defaultTextFormat = _loc7_;
         embedFonts = true;
         text = param2;
         autoSize = TextFieldAutoSize.CENTER;
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

