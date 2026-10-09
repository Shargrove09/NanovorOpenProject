package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IDownloader;
   
   public interface IDeviceManager extends IChainLoadee
   {
      
      function isDeviceAssociated() : Boolean;
      
      function get download() : IDownload;
      
      function startDeviceRecovery(param1:String) : void;
      
      function deleteAllRootFilesExceptJolts() : void;
      
      function get driveLetter() : String;
      
      function get deviceID() : String;
      
      function associateDevice(param1:IDeviceAssociatorConsumer) : void;
      
      function get communicator() : IDeviceManagerCommunicator;
      
      function destroy() : void;
      
      function get downloader() : IDownloader;
      
      function get firmwareVersion() : int;
      
      function handleErrorLogFound() : void;
   }
}

