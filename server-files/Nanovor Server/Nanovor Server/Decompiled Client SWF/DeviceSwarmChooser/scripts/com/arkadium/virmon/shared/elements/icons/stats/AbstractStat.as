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
         setOverrideActive(false);
         setIsBuffed(false);
      }
      
      private function setOverrideActive(param1:Boolean) : void
      {
         if(_bIsOverrideActive == param1)
         {
            return;
         }
         _bIsOverrideActive = param1;
         if(param1)
         {
            mcSpinner.play();
            mcSpinner.visible = true;
         }
         else
         {
            mcSpinner.stop();
            mcSpinner.visible = false;
         }
      }
      
      private function setIsBuffed(param1:Boolean) : void
      {
         if(_bIsBuffed == param1)
         {
            return;
         }
         _bIsBuffed = param1;
         if(param1)
         {
            mcBuffGlow1.visible = true;
            mcBuffGlow2.visible = true;
         }
         else
         {
            mcBuffGlow1.visible = false;
            mcBuffGlow2.visible = false;
         }
      }
      
      public function set isBuffed(param1:Boolean) : void
      {
         setIsBuffed(param1);
      }
      
      public function get isBuffed() : Boolean
      {
         return _bIsBuffed;
      }
      
      public function set isOverrideActive(param1:Boolean) : void
      {
         setOverrideActive(param1);
      }
      
      public function get isOverrideActive() : Boolean
      {
         return _bIsOverrideActive;
      }
   }
}

