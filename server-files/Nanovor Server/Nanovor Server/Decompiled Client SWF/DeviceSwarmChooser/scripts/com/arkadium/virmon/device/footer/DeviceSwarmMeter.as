package com.arkadium.virmon.device.footer
{
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileBoldCondensed;
   import flash.display.MovieClip;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6")]
   public class DeviceSwarmMeter extends MovieClip
   {
      
      public static const METER_BOX_X:int = 122;
      
      public static const METER_BOX_Y:int = 14;
      
      public static const METER_BOX_SPACING:int = 44;
      
      public static const METER_BOXES:int = 10;
      
      public static const TALLY_TEXT_X:int = 28;
      
      public static const TALLY_TEXT_Y:int = 18;
      
      private var _tallyCount:int = 0;
      
      private var _meterBoxes:Array;
      
      private var _boxContainer:MovieClip;
      
      private var _tallyText:TextField;
      
      public var mcBG:MovieClip;
      
      public function DeviceSwarmMeter()
      {
         super();
         createMeter();
         createTallyText();
      }
      
      public function destroy() : void
      {
         while(_boxContainer.numChildren > 0)
         {
            _boxContainer.removeChildAt(0);
         }
         mcBG.stop();
      }
      
      public function addItem() : void
      {
         _meterBoxes[_tallyCount++].activate();
         updateTallyText();
      }
      
      public function reset() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < _tallyCount)
         {
            _meterBoxes[_loc1_].deactivate();
            _loc1_++;
         }
         _tallyCount = 0;
         updateTallyText();
      }
      
      private function createMeter() : void
      {
         var _loc2_:DeviceSwarmMeterBox = null;
         _boxContainer = new MovieClip();
         addChild(_boxContainer);
         this.swapChildren(mcBG,_boxContainer);
         _meterBoxes = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < METER_BOXES)
         {
            _loc2_ = new DeviceSwarmMeterBox();
            _loc2_.x = METER_BOX_X + _loc1_ * METER_BOX_SPACING;
            _loc2_.y = METER_BOX_Y;
            _boxContainer.addChild(_loc2_);
            _meterBoxes.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function updateTallyText() : void
      {
         _tallyText.text = String(_tallyCount) + " ON NANOSCOPE";
      }
      
      public function removeItem() : void
      {
         _meterBoxes[--_tallyCount].deactivate();
         updateTallyText();
      }
      
      private function createTallyText() : void
      {
         var _loc1_:EuroStileBoldCondensed = new EuroStileBoldCondensed();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = _loc1_.fontName;
         _loc2_.size = 12;
         _loc2_.color = 16777215;
         _loc2_.bold = true;
         _loc2_.align = TextFormatAlign.LEFT;
         _tallyText = new TextField();
         _tallyText.defaultTextFormat = _loc2_;
         _tallyText.embedFonts = true;
         _tallyText.text = "0 ON NANOSCOPE";
         _tallyText.autoSize = TextFieldAutoSize.LEFT;
         _tallyText.multiline = false;
         _tallyText.selectable = false;
         _tallyText.antiAliasType = AntiAliasType.NORMAL;
         _tallyText.x = TALLY_TEXT_X;
         _tallyText.y = TALLY_TEXT_Y;
         addChild(_tallyText);
      }
   }
}

