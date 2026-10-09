package com.arkadium.virmon.device
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class DeviceNanovorRetriever implements IDeviceNanovorRetriever
   {
      
      private static const CHARACTER_COUNT:int = 10;
      
      private static const ASSET_INFO_FILE:String = "VINFO.BBB";
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _driveLetter:String;
      
      private var _deviceNanovorRetrieverProvider:IDeviceNanovorRetrieverProvider;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceNanovorRetriever(param1:INanovorFactory, param2:IDeviceNanovorRetrieverProvider, param3:IFileOperator, param4:String)
      {
         super();
         _nanovorFactory = param1;
         _deviceNanovorRetrieverProvider = param2;
         _fileOperator = param3;
         _driveLetter = param4;
      }
      
      public function getDeviceNanovor(param1:IDeviceNanovorReceiver, param2:Array = null, param3:int = 1) : void
      {
         var assetFilePath:String;
         var folderName:String;
         var loader:URLLoader = null;
         var deviceFileFormat:String = null;
         var request:URLRequest = null;
         var deviceNanovorReceiver:IDeviceNanovorReceiver = param1;
         var deviceNanovorList:Array = param2;
         var folderIndex:int = param3;
         log("getDeviceNanovor(): folderIndex: " + folderIndex);
         if(null == deviceNanovorList)
         {
            deviceNanovorList = new Array();
         }
         folderName = _driveLetter + "v" + folderIndex;
         assetFilePath = folderName + "\\" + ASSET_INFO_FILE;
         if(_fileOperator.doesFolderExist(folderName))
         {
            if(_fileOperator.doesFileExist(assetFilePath))
            {
               log("AssetFilePath: " + assetFilePath);
               loader = new URLLoader();
               deviceFileFormat = URLLoaderDataFormat.BINARY;
               loader.dataFormat = deviceFileFormat;
               loader.addEventListener(Event.COMPLETE,function(param1:Event):void
               {
                  IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
                  IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,onAssetFileError);
                  handleAssetFileLoaded(ByteArray(param1.target.data),deviceNanovorReceiver,deviceNanovorList,folderIndex);
               });
               loader.addEventListener(IOErrorEvent.IO_ERROR,onAssetFileError);
               request = new URLRequest(assetFilePath);
               try
               {
                  loader.load(request);
               }
               catch(error:Error)
               {
                  trace("error loading assetFilePath");
               }
            }
            else
            {
               folderIndex++;
               if(folderIndex > CHARACTER_COUNT)
               {
                  deviceNanovorReceiver.handleDeviceNanovorReceived(deviceNanovorList);
               }
               else
               {
                  getDeviceNanovor(deviceNanovorReceiver,deviceNanovorList,folderIndex);
               }
            }
         }
         else
         {
            folderIndex++;
            log("folderIndex: " + folderIndex.toString());
            if(folderIndex > CHARACTER_COUNT)
            {
               deviceNanovorReceiver.handleDeviceNanovorReceived(deviceNanovorList);
            }
            else
            {
               getDeviceNanovor(deviceNanovorReceiver,deviceNanovorList,folderIndex);
            }
         }
      }
      
      private function convertLongToDecimal(param1:String) : String
      {
         var _loc7_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         log("convertLongToDecimal(): value: " + param1);
         var _loc2_:uint = 16;
         var _loc3_:int = Math.log(uint.MAX_VALUE) * (Math.LOG2E / 4);
         var _loc4_:int = Math.round(_loc3_);
         if(param1.length > _loc2_)
         {
            throw new Error("value is more then 64-bits");
         }
         var _loc5_:String = param1.slice(0,-_loc4_);
         var _loc6_:String = param1.slice(-_loc4_);
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ += "0";
            _loc7_++;
         }
         var _loc8_:Number = parseInt(_loc5_,_loc2_);
         var _loc9_:Number = parseInt(_loc6_,_loc2_);
         var _loc10_:String = "";
         var _loc11_:int = 10;
         _loc7_ = 20;
         while(Boolean(_loc7_--))
         {
            _loc12_ = Math.pow(_loc11_,_loc7_);
            _loc13_ = Math.floor(_loc8_ / _loc12_ + _loc9_ / _loc12_);
            _loc10_ += _loc13_.toString();
            _loc13_ *= _loc12_;
            _loc14_ = Math.floor(_loc13_ / uint.MAX_VALUE) * (uint.MAX_VALUE + 1);
            _loc15_ = _loc13_ - _loc14_;
            _loc8_ -= _loc14_;
            _loc9_ -= _loc15_;
         }
         while(_loc10_.charAt(0) == "0")
         {
            _loc10_ = _loc10_.slice(1);
            log("dec: " + _loc10_);
         }
         return _loc10_;
      }
      
      private function handleAssetFileLoaded(param1:ByteArray, param2:IDeviceNanovorReceiver, param3:Array, param4:int) : void
      {
         log("handleAssetFileLoaded()");
         param1.position = 0;
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.endian = Endian.LITTLE_ENDIAN;
         param1.position = 6;
         param1.readBytes(_loc5_,0,8);
         log("assetID: " + _loc5_.readInt());
         var _loc6_:String = convertAssetByteArrayToLong(_loc5_);
         var _loc7_:String = convertLongToDecimal(_loc6_);
         var _loc8_:int = param1.readByte();
         var _loc9_:ByteArray = new ByteArray();
         var _loc10_:int = 0;
         var _loc11_:uint = 154;
         while(_loc11_ < 283)
         {
            param1.position = _loc11_;
            if(param1[_loc11_] != 0)
            {
               _loc9_[_loc10_] = param1[_loc11_];
               _loc10_++;
            }
            _loc11_++;
         }
         log("trying to add nanovor: assetID: " + _loc7_);
         var _loc12_:INanovor = _nanovorFactory.createNanovorInstanceById(_loc7_);
         if(null != _loc12_)
         {
            param3.push(_loc12_);
         }
         log("deviceNanovorList length: " + param3.length);
         param4++;
         if(param4 > CHARACTER_COUNT)
         {
            param2.handleDeviceNanovorReceived(param3);
         }
         else
         {
            _deviceNanovorRetrieverProvider.deviceNanovorRetriever.getDeviceNanovor(param2,param3,param4);
         }
      }
      
      private function convertAssetByteArrayToLong(param1:ByteArray) : String
      {
         var _loc4_:String = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < 8)
         {
            param1.position = _loc3_;
            _loc4_ = param1[_loc3_].toString(16).toUpperCase();
            while(2 > _loc4_.length)
            {
               _loc4_ = "0" + _loc4_;
            }
            _loc2_ = _loc4_ + _loc2_;
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function onAssetFileError(param1:IOErrorEvent) : void
      {
         log("onAssetFileError(): " + param1.text);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceNanovorRetriever>> " + param1);
      }
   }
}

