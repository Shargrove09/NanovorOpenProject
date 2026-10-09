package com.arkadium.virmon.device
{
   public interface IDeviceMiniGameWriter
   {
      
      function destroy() : void;
      
      function writeDeviceMiniGameList(param1:Array, param2:ILoadProgressUpdater, param3:Function) : void;
   }
}

