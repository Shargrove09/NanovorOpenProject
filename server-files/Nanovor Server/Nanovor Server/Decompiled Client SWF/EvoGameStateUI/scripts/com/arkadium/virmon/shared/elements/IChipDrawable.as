package com.arkadium.virmon.shared.elements
{
   import flash.display.MovieClip;
   
   public interface IChipDrawable
   {
      
      function update() : void;
      
      function setData(param1:*, ... rest) : void;
      
      function clone() : MovieClip;
   }
}

