package com.arkadium.virmon.device
{
   public interface ILoadProgressUpdater
   {
      
      function handleItemCompleted() : void;
      
      function addStatusTextLine(param1:String) : void;
      
      function updateCurrentItemProgress(param1:Number) : void;
   }
}

