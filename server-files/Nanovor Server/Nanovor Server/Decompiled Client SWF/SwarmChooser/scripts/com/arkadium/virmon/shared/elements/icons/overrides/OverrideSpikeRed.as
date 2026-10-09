package com.arkadium.virmon.shared.elements.icons.overrides
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class OverrideSpikeRed extends Sprite
   {
      
      public function OverrideSpikeRed(param1:Boolean = false)
      {
         var spinner:MovieClip = null;
         var bStatic:Boolean = param1;
         super();
         if(bStatic)
         {
            try
            {
               spinner = getChildAt(1) as MovieClip;
               spinner.visible = false;
               spinner.stop();
               this.cacheAsBitmap = true;
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}

