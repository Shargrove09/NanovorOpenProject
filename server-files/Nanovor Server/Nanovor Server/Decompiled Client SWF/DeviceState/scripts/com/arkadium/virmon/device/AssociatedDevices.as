package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   
   public class AssociatedDevices implements IAssociatedDevices
   {
      
      private var _associatedDevicesRefreshedHandler:IAssociatedDevicesRefreshedHandler;
      
      private var _accountID:String;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _chainLoader:IChainLoader;
      
      private var _associatedDevices:Array;
      
      public function AssociatedDevices(param1:String, param2:IDeviceManagerCommunicator)
      {
         super();
         _associatedDevices = new Array();
         _accountID = param1;
         _deviceManagerCommunicator = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AssociatedDevices: " + param1);
      }
      
      public function isDeviceAssociated(param1:String) : Boolean
      {
         var _loc2_:uint = 0;
         while(_loc2_ < _associatedDevices.length)
         {
            log("DeviceID:" + Number(param1) + " AssociatedDevices: " + Number(_associatedDevices[_loc2_]));
            if(Number(param1) == Number(_associatedDevices[_loc2_]))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function getAssociatedDevicesError(param1:IOErrorEvent) : *
      {
         log("getAssociatedDevicesError");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,getAssociatedDevicesComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,getAssociatedDevicesError);
         if(null != _chainLoader)
         {
            _chainLoader.handleChainLoadeeError();
            _chainLoader = null;
         }
      }
      
      public function get name() : String
      {
         return "AssociatedDevices";
      }
      
      private function addDevice(param1:int) : *
      {
         log("addDevice");
         _associatedDevices.push(param1);
      }
      
      private function getAssociatedDevicesComplete(param1:Event) : *
      {
         var _loc5_:XML = null;
         log("getAssociatedDevicesComplete: " + param1.target.data);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,getAssociatedDevicesComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,getAssociatedDevicesError);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         var _loc3_:XMLList = _loc2_.elements("device");
         var _loc4_:Array = new Array();
         clearAssociatedDevices();
         for each(_loc5_ in _loc3_)
         {
            addDevice(_loc5_.attribute("id"));
         }
         if(null != _associatedDevicesRefreshedHandler)
         {
            _associatedDevicesRefreshedHandler.handleAssociatedDevicesRefreshed();
            _associatedDevicesRefreshedHandler = null;
         }
         if(null != _chainLoader)
         {
            _chainLoader.handleChainLoadeeComplete();
            _chainLoader = null;
         }
      }
      
      public function refreshAssociatedDevices(param1:IAssociatedDevicesRefreshedHandler = null) : void
      {
         _associatedDevicesRefreshedHandler = param1;
         _deviceManagerCommunicator.getAssociatedDevices(_accountID,getAssociatedDevicesComplete,getAssociatedDevicesError);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> AssociatedDevices: " + param1);
      }
      
      private function clearAssociatedDevices() : void
      {
         _associatedDevices = new Array();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function load() : void
      {
         refreshAssociatedDevices();
      }
   }
}

