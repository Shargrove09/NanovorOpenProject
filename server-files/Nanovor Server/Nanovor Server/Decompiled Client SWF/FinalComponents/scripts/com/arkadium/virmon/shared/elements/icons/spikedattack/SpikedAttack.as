package com.arkadium.virmon.shared.elements.icons.spikedattack
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   
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
         this.spikeColor = param1;
         this.statIcon = param2;
         this.spikeActive = param3;
         this.defaultText = "";
         this.spikedText = "";
         this.spinTextEnabled = false;
      }
      
      private function calcSpikeIcon() : Sprite
      {
         switch(this._iSpikeColor)
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
         switch(this._iSpikeColor)
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
         this.mcTextSpike.tfText.text = param1;
      }
      
      public function set spikeActive(param1:Boolean) : void
      {
         this._bSpikeActive = this.mcSpinner.visible = param1;
         if(param1)
         {
            this.mcSpinner.play();
         }
         else
         {
            this.mcSpinner.stop();
         }
      }
      
      public function set statIcon(param1:Sprite) : void
      {
         while(this.mcStat.numChildren > 0)
         {
            this.mcStat.removeChildAt(0);
         }
         this._sprStatIcon = param1;
         if(param1 != null)
         {
            param1.x = param1.y = -10;
            this.mcStat.addChild(param1);
         }
      }
      
      public function set defaultText(param1:String) : void
      {
         this.mcTextDef.tfText.text = param1;
      }
      
      public function get defaultText() : String
      {
         return this.mcTextDef.tfText.text;
      }
      
      public function set spinTextEnabled(param1:Boolean) : void
      {
         this.mcTextDef.visible = this.mcTextSpike.visible = param1;
      }
      
      public function get spikedText() : String
      {
         return this.mcTextSpike.tfText.text;
      }
      
      public function get spikeActive() : Boolean
      {
         return this._bSpikeActive;
      }
      
      public function get statIcon() : Sprite
      {
         return this._sprStatIcon;
      }
      
      public function set spikeColor(param1:int) : void
      {
         this._iSpikeColor = param1;
         var _loc2_:Sprite = this.calcSpikeIcon();
         _loc2_.x = -10;
         _loc2_.y = -10;
         var _loc3_:ColorMatrixFilter = this.calcSpikeColorMatrix();
         while(this.mcSpike.numChildren > 0)
         {
            this.mcSpike.removeChildAt(0);
         }
         this.mcSpike.addChild(_loc2_);
         if(_loc3_ == null)
         {
            this.mcSpinner.filters = [];
         }
         else
         {
            this.mcSpinner.filters = [_loc3_];
         }
      }
      
      public function get spikeColor() : int
      {
         return this._iSpikeColor;
      }
   }
}

