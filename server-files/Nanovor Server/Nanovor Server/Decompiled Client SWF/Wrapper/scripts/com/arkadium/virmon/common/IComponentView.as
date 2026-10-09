package com.arkadium.virmon.common
{
   import flash.display.Sprite;
   
   public interface IComponentView
   {
      
      function destroy() : void;
      
      function get sprite() : Sprite;
   }
}

