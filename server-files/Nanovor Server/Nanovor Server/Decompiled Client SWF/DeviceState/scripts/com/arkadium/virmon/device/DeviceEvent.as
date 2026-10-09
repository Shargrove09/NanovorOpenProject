package com.arkadium.virmon.device
{
   import flash.events.Event;
   
   public class DeviceEvent extends Event
   {
      
      public static const ASSOC_DEVICES_RECEIVED:String = "assoc_devices_received";
      
      public static const MINI_GAMES_LIST_RECEIVED:String = "mini_games_list_received";
      
      public static const FIRMWARE_RECEIVED:String = "firmware_received";
      
      public static const SIGNATURE_RECEIVED:String = "signature_received";
      
      public static const ASSET_BINARY_RECEIVED:String = "asset_binary_received";
      
      public static const ACCOUNT_BINARY_RECEIVED:String = "account_binary_received";
      
      public static const DEVICE_FILES_UPLOADED:String = "device_files_uploaded";
      
      public static const TEXT_UPDATE:String = "text_update";
      
      public static const DEVICE_MANIFEST_RECEIVED:String = "device_manifest_received";
      
      private var _oData:*;
      
      public function DeviceEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:* = null)
      {
         super(param1,param2,param3);
         _oData = param4;
      }
      
      public function get data() : *
      {
         return _oData;
      }
      
      public function set data(param1:*) : *
      {
         _oData = param1;
      }
      
      override public function toString() : String
      {
         return formatToString("DeviceEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new DeviceEvent(type,bubbles,cancelable);
      }
   }
}

