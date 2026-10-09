package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceReader implements IDeviceReader, IDeviceConnectionHandler, IDeviceNanovorRetrieverProvider, IDeviceMiniGameRetrieverProvider
   {
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _driveLetter:String;
      
      private var _deviceMiniGameRetriever:IDeviceMiniGameRetriever;
      
      private var _fileOperator:IFileOperator;
      
      private var _deviceNanovorRetriever:IDeviceNanovorRetriever;
      
      public function DeviceReader(param1:INanovorFactory, param2:IFileOperator, param3:IDeviceConnectionDetector, param4:String)
      {
         super();
         _nanovorFactory = param1;
         _fileOperator = param2;
         _driveLetter = param4;
         _deviceNanovorRetriever = new DeviceNanovorRetriever(_nanovorFactory,IDeviceNanovorRetrieverProvider(this),_fileOperator,_driveLetter);
         _deviceMiniGameRetriever = new DeviceMiniGameRetriever(IDeviceMiniGameRetrieverProvider(this),_fileOperator,_driveLetter);
         param3.addDeviceConnectionHandler(IDeviceConnectionHandler(this));
      }
      
      public function handleDeviceDisconnected() : void
      {
         _deviceNanovorRetriever = new NullDeviceNanovorRetriever();
         _deviceMiniGameRetriever = new NullDeviceMiniGameRetriever();
      }
      
      public function get deviceNanovorRetriever() : IDeviceNanovorRetriever
      {
         return _deviceNanovorRetriever;
      }
      
      public function handleDeviceConnected(param1:String) : void
      {
         _deviceNanovorRetriever = new DeviceNanovorRetriever(_nanovorFactory,IDeviceNanovorRetrieverProvider(this),_fileOperator,_driveLetter);
         _deviceMiniGameRetriever = new DeviceMiniGameRetriever(IDeviceMiniGameRetrieverProvider(this),_fileOperator,_driveLetter);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<Device>> " + param1);
      }
      
      private function getDeviceNanovor(param1:IDeviceNanovorReceiver) : void
      {
         log("getDeviceNanovor()");
         _deviceNanovorRetriever.getDeviceNanovor(param1);
      }
      
      public function get deviceMiniGameRetriever() : IDeviceMiniGameRetriever
      {
         return _deviceMiniGameRetriever;
      }
      
      public function resetDeviceNanovor(param1:IDeviceNanovorReceiver) : void
      {
         log("resetDeviceNanovor()");
         getDeviceNanovor(param1);
      }
      
      public function resetDeviceMiniGames(param1:IDeviceMiniGamesReceiver) : void
      {
         log("resetDeviceMiniGames()");
         getDeviceMiniGames(param1);
      }
      
      private function getDeviceMiniGames(param1:IDeviceMiniGamesReceiver) : void
      {
         log("getDeviceMiniGames()");
         _deviceMiniGameRetriever.getDeviceMiniGames(param1);
      }
   }
}

