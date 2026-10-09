package com.arkadium.virmon.shared.renders
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class CCellRenderer extends MovieClip implements ICellRenderer
   {
      
      protected var _data:Object;
      
      protected var _uiItemIndex:uint;
      
      protected var _uiRow:uint;
      
      protected var _uiColumn:uint;
      
      public function CCellRenderer()
      {
         super();
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
      }
      
      private function removeFromStage(param1:Event) : void
      {
         if(param1.target == this)
         {
            destroy();
         }
      }
      
      public function set data(param1:Object) : void
      {
         _data = param1;
      }
      
      public function get column() : uint
      {
         return _uiColumn;
      }
      
      public function get row() : uint
      {
         return _uiRow;
      }
      
      public function CellRenderer() : void
      {
      }
      
      public function set column(param1:uint) : void
      {
         _uiColumn = param1;
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function set row(param1:uint) : void
      {
         _uiRow = param1;
      }
      
      public function destroy() : void
      {
      }
      
      public function set itemIndex(param1:uint) : void
      {
         _uiItemIndex = param1;
      }
      
      public function get itemIndex() : uint
      {
         return _uiItemIndex;
      }
   }
}

