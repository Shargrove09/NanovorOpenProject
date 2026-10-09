package com.arkadium.virmon.shared.elements.icons
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol592")]
   public class NanoscopeIcon extends MovieClip
   {
      
      public function NanoscopeIcon()
      {
         super();
      }
      
      public function set color(param1:uint) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = param1;
         this.transform.colorTransform = _loc2_;
      }
   }
}

