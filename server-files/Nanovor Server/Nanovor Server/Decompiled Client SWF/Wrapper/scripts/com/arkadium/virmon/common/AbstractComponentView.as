package com.arkadium.virmon.common
{
   import flash.display.Sprite;
   import flash.errors.IllegalOperationError;
   
   public class AbstractComponentView extends Sprite implements IComponentView
   {
      
      public function AbstractComponentView()
      {
         super();
      }
      
      public function destroy() : void
      {
         throw new IllegalOperationError("Method destroy() is abstract and must be implemented by subclasses.");
      }
      
      public function get sprite() : Sprite
      {
         return this;
      }
   }
}

