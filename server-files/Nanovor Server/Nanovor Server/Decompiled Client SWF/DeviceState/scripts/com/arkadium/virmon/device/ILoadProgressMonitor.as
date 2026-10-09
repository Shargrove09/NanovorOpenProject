package com.arkadium.virmon.device
{
   public interface ILoadProgressMonitor
   {
      
      function addStatusTextLine(param1:String) : void;
      
      function replaceLastStatusTextLine(param1:String) : void;
      
      function updateProgress(param1:Number) : void;
   }
}

