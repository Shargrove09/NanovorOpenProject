package com.arkadium.virmon.device
{
   public class DeviceConnectionHandler implements IDeviceConnectionHandler
   {
      
      private var _isConnected:Boolean;
      
      private var _deviceConnectionHandler:IDeviceConnectionHandler;
      
      public function DeviceConnectionHandler(param1:IDeviceConnectionHandler)
      {
         super();
         _isConnected = false;
         _deviceConnectionHandler = param1;
      }
      
      public function get isConnected() : Boolean
      {
         return _isConnected;
      }
      
      public function handleDeviceDisconnected() : void
      {
         if(false == _isConnected)
         {
            return;
         }
         _deviceConnectionHandler.handleDeviceDisconnected();
         _isConnected = false;
      }
      
      public function handleDeviceConnected(param1:String) : void
      {
         if(_isConnected)
         {
            return;
         }
         _deviceConnectionHandler.handleDeviceConnected(param1);
         _isConnected = true;
      }
   }
}

