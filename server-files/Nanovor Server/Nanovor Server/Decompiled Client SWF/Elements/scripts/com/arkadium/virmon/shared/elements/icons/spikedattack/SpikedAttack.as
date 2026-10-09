package com.arkadium.virmon.shared.elements.icons.spikedattack
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol446")]
   public class SpikedAttack extends MovieClip
   {
      
      public static const SPIKE_BLUE:int = 1;
      
      public static const SPIKE_RED:int = 2;
      
      public static const SPIKE_YELLOW:int = 3;
      
      public static const OTHER_CONDITIONAL:int = 4;
      
      private var _sprStatIcon:Sprite = null;
      
      private var _iSpikeColor:int = 0;
      
      private var _bSpikeActive:Boolean = false;
      
      public var mcStat:MovieClip;
      
      public var mcSpike:MovieClip;
      
      public var mcTextDef:MovieClip;
      
      public var mcSpinner:MovieClip;
      
      public var mcTextSpike:MovieClip;
      
      public function SpikedAttack(param1:int = 0, param2:Sprite = null, param3:Boolean = false)
      {
         super();
         spikeColor = param1;
         statIcon = param2;
         spikeActive = param3;
         defaultText = "";
         spikedText = "";
         spinTextEnabled = false;
      }
      
      private function calcSpikeIcon() : Sprite
      {
         switch(_iSpikeColor)
         {
            case SPIKE_BLUE:
               return new SmallBlueSpike();
            case SPIKE_RED:
               return new SmallRedSpike();
            case SPIKE_YELLOW:
               return new SmallYellowSpike();
            default:
               return new QuestionMark();
         }
      }
      
      private function calcSpikeColorMatrix() : ColorMatrixFilter
      {
         var _loc1_:Array = new Array();
         switch(_iSpikeColor)
         {
            case SPIKE_BLUE:
               _loc1_ = [1,0,0,0,88,0,1,0,0,41,0,0,1,0,255,0,0,0,1,0];
               break;
            case SPIKE_RED:
               _loc1_ = [1,0,0,0,255,0,1,0,0,-33,0,0,1,0,58,0,0,0,1,0];
               break;
            case SPIKE_YELLOW:
               _loc1_ = [1,0,0,0,255,0,1,0,0,255,0,0,1,0,115,0,0,0,1,0];
         }
         if(_loc1_.length == 0)
         {
            return null;
         }
         return new ColorMatrixFilter(_loc1_);
      }
      
      public function set spikedText(param1:String) : void
      {
         mcTextSpike.tfText.text = param1;
      }
      
      public function set spikeActive(param1:Boolean) : void
      {
         _bSpikeActive = mcSpinner.visible = param1;
         if(param1)
         {
            mcSpinner.play();
         }
         else
         {
            mcSpinner.stop();
         }
      }
      
      public function set statIcon(param1:Sprite) : void
      {
         while(mcStat.numChildren > 0)
         {
            mcStat.removeChildAt(0);
         }
         _sprStatIcon = param1;
         if(param1 != null)
         {
            param1.x = param1.y = -10;
            mcStat.addChild(param1);
         }
      }
      
      public function set defaultText(param1:String) : void
      {
         mcTextDef.tfText.text = param1;
      }
      
      public function get defaultText() : String
      {
         return mcTextDef.tfText.text;
      }
      
      public function set spinTextEnabled(param1:Boolean) : void
      {
         mcTextDef.visible = mcTextSpike.visible = param1;
      }
      
      public function get spikedText() : String
      {
         return mcTextSpike.tfText.text;
      }
      
      public function get spikeActive() : Boolean
      {
         return _bSpikeActive;
      }
      
      public function get statIcon() : Sprite
      {
         return _sprStatIcon;
      }
      
      public function set spikeColor(param1:int) : void
      {
         _iSpikeColor = param1;
         var _loc2_:Sprite = calcSpikeIcon();
         _loc2_.x = -10;
         _loc2_.y = -10;
         var _loc3_:ColorMatrixFilter = calcSpikeColorMatrix();
         while(mcSpike.numChildren > 0)
         {
            mcSpike.removeChildAt(0);
         }
         mcSpike.addChild(_loc2_);
         if(_loc3_ == null)
         {
            mcSpinner.filters = [];
         }
         else
         {
            mcSpinner.filters = [_loc3_];
         }
      }
      
      public function get spikeColor() : int
      {
         return _iSpikeColor;
      }
   }
}

