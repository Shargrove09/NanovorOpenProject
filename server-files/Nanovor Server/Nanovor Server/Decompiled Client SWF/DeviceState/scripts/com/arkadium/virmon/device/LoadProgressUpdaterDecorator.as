package com.arkadium.virmon.device
{
   public class LoadProgressUpdaterDecorator implements ILoadProgressUpdater
   {
      
      private var _currentItemIndex:int;
      
      private var _totalItems:int;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      public function LoadProgressUpdaterDecorator(param1:int, param2:ILoadProgressUpdater)
      {
         super();
         if(null == param2)
         {
            throw new Error("Parameter \'loadProgressUpdater\' cannot be null.");
         }
         _loadProgressUpdater = param2;
         _totalItems = param1;
         _currentItemIndex = 0;
      }
      
      private function refreshProgress(param1:Number) : void
      {
         _loadProgressUpdater.updateCurrentItemProgress((_currentItemIndex + param1) / _totalItems);
         if(1 == param1)
         {
            ++_currentItemIndex;
         }
      }
      
      public function handleItemCompleted() : void
      {
         refreshProgress(1);
      }
      
      public function addStatusTextLine(param1:String) : void
      {
         _loadProgressUpdater.addStatusTextLine(param1);
      }
      
      public function updateCurrentItemProgress(param1:Number) : void
      {
         refreshProgress(param1);
      }
   }
}

