package com.arkadium.virmon.shared.elements.icons.stats
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class AbstractStat extends Sprite
   {
      
      public var mcSpinner:MovieClip;
      
      public var mcBuffGlow2:Sprite;
      
      private var _bIsOverrideActive:Boolean = true;
      
      public var mcBuffGlow1:Sprite;
      
      private var _bIsBuffed:Boolean = true;
      
      public function AbstractStat()
      {
         super();
         this.setOverrideActive(false);
         this.setIsBuffed(false);
      }
      
      private function setOverrideActive(param1:Boolean) : void
      {
         if(this._bIsOverrideActive == param1)
         {
            return;
         }
         this._bIsOverrideActive = param1;
         if(param1)
         {
            this.mcSpinner.play();
            this.mcSpinner.visible = true;
         }
         else
         {
            this.mcSpinner.stop();
            this.mcSpinner.visible = false;
         }
      }
      
      private function setIsBuffed(param1:Boolean) : void
      {
         if(this._bIsBuffed == param1)
         {
            return;
         }
         this._bIsBuffed = param1;
         if(param1)
         {
            this.mcBuffGlow1.visible = true;
            this.mcBuffGlow2.visible = true;
         }
         else
         {
            this.mcBuffGlow1.visible = false;
            this.mcBuffGlow2.visible = false;
         }
      }
      
      public function set isBuffed(param1:Boolean) : void
      {
         this.setIsBuffed(param1);
      }
      
      public function get isBuffed() : Boolean
      {
         return this._bIsBuffed;
      }
      
      public function set isOverrideActive(param1:Boolean) : void
      {
         this.setOverrideActive(param1);
      }
      
      public function get isOverrideActive() : Boolean
      {
         return this._bIsOverrideActive;
      }
   }
}

