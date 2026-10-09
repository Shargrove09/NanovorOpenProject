package com.arkadium.virmon.device.deviceswarmchooser
{
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonSmallComponent;
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class DeviceExitButton extends SpinningButtonSmallComponent
   {
      
      public static const LABEL_COLOR:uint = 11200521;
      
      public static const LABEL_TEXT:String = "CANCEL";
      
      public function DeviceExitButton(param1:DisplayObject = null)
      {
         super(param1);
         createLabel();
      }
      
      private function createLabel() : void
      {
         var _loc3_:TextField = null;
         var _loc1_:EuroStileBoldCondensed = new EuroStileBoldCondensed();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = _loc1_.fontName;
         _loc2_.size = 10;
         _loc2_.color = LABEL_COLOR;
         _loc2_.bold = true;
         _loc2_.align = TextFormatAlign.LEFT;
         _loc3_ = new TextField();
         log("createLabel(): euroStileFont (EuroStileBoldCondensed) ==> fontName = " + _loc1_.fontName + ", fontStyle = " + _loc1_.fontStyle + ", fontType = " + _loc1_.fontType);
         _loc3_.embedFonts = true;
         _loc3_.text = LABEL_TEXT;
         _loc3_.setTextFormat(_loc2_);
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.multiline = false;
         _loc3_.selectable = false;
         _loc3_.antiAliasType = AntiAliasType.NORMAL;
         _loc3_.x = -(_loc3_.textWidth + this.width / 2 + 4);
         _loc3_.y = -(_loc3_.textHeight / 2) - 1;
         addChild(_loc3_);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DeviceExitButton: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DeviceExitButton: " + param1);
      }
   }
}

