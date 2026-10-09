package com.arkadium.virmon.device
{
   import flash.events.IEventDispatcher;
   
   public interface IDownload extends IEventDispatcher
   {
      
      function downloadRequiredFiles(param1:Array, param2:IDeviceManagerCommunicator, param3:String, param4:ILoadProgressUpdater) : void;
      
      function destroy() : void;
   }
}

