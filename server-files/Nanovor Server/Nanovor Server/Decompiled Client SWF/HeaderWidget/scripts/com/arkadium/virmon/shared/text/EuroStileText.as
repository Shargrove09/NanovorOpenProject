package com.arkadium.virmon.shared.text
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldExtended2;
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileCondensed;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class EuroStileText extends TextField
   {
      
      public static const EUROSTILE_CONDENSED:String = "EuroStileCondensed";
      
      public static const EUROSTILE_BOLD_CONDENSED:String = "EuroStileBoldCondensed";
      
      public static const EUROSTILE_BOLD_EXTENDED_2:String = "EuroStileBoldExtended2";
      
      public function EuroStileText(param1:String, param2:String, param3:int, param4:uint = 0, param5:String = "center", param6:String = "center", param7:Boolean = false, param8:Boolean = false)
      {
         var _loc9_:* = undefined;
         super();
         var _loc10_:TextFormat = new TextFormat();
         var _loc11_:Boolean = false;
         switch(param2)
         {
            case EuroStileText.EUROSTILE_CONDENSED:
               _loc9_ = new EuroStileCondensed();
               break;
            case EuroStileText.EUROSTILE_BOLD_CONDENSED:
               _loc9_ = new EuroStileBoldCondensed();
               _loc11_ = true;
               break;
            case EuroStileText.EUROSTILE_BOLD_EXTENDED_2:
               _loc9_ = new EuroStileBoldExtended2();
               _loc11_ = true;
         }
         _loc10_.font = _loc9_.fontName;
         _loc10_.size = param3;
         _loc10_.color = param4;
         _loc10_.bold = _loc11_;
         _loc10_.align = param5;
         defaultTextFormat = _loc10_;
         embedFonts = true;
         text = param1;
         autoSize = param6;
         multiline = param7;
         selectable = param8;
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

