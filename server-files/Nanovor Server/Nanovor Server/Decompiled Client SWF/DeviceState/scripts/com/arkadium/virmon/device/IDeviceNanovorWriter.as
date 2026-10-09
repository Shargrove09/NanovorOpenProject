package com.arkadium.virmon.device
{
   public interface IDeviceNanovorWriter
   {
      
      function destroy() : void;
      
      function writeDeviceNanovorList(param1:Array, param2:ILoadProgressMonitor, param3:Function) : void;
   }
}

