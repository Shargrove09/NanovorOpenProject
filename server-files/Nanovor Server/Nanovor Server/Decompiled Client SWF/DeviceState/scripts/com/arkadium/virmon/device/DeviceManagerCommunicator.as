package com.arkadium.virmon.device
{
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.utils.ByteArray;
   
   public class DeviceManagerCommunicator implements IDeviceManagerCommunicator
   {
      
      private var _loginTokenProvider:ILoginTokenProvider;
      
      private var _staticFileServiceURL:String;
      
      private var _bankURL:String;
      
      public function DeviceManagerCommunicator(param1:ILoginTokenProvider, param2:String, param3:String)
      {
         super();
         if(null == param1)
         {
            throw new Error("Parameter \"loginTokenProvider\" cannot be null.");
         }
         if(null == param2 || 0 == param2.length)
         {
            throw new Error("Parameter \"bankURL\" cannot be null or empty.");
         }
         if(null == param3 || 0 == param3.length)
         {
            throw new Error("Parameter \"staticFileServiceURL\" cannot be null or empty.");
         }
         _loginTokenProvider = param1;
         _bankURL = param2;
         _staticFileServiceURL = param3;
      }
      
      public function getAssociatedDevices(param1:String, param2:Function, param3:Function) : void
      {
         var _loc4_:String = encodeURI(Utils.appendKillCache(_bankURL + "/bankfe/resources/account/" + param1 + "/device?auth=" + getLoginToken()));
         log("getAssociatedDevices(): sURL: " + _loc4_);
         var _loc5_:URLLoader = new URLLoader();
         _loc5_.addEventListener(Event.COMPLETE,param2,false,0,true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR,param3,false,0,true);
         var _loc6_:URLRequest = new URLRequest(_loc4_);
         _loc5_.load(_loc6_);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceManagerCommunicator>> " + param1);
      }
      
      public function uploadJolts(param1:String, param2:ByteArray, param3:Function, param4:Function) : void
      {
         var _loc5_:String = encodeURI(Utils.appendKillCache(_bankURL + "/device/" + param1 + "/jolt?auth=" + getLoginToken()));
         log("uploadJolts(): url: " + _loc5_);
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         var _loc7_:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
         _loc6_.requestHeaders.push(_loc7_);
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = param2;
         var _loc8_:URLLoader = new URLLoader();
         _loc8_.addEventListener(Event.COMPLETE,param3,false,0,true);
         _loc8_.addEventListener(IOErrorEvent.IO_ERROR,param4,false,0,true);
         _loc8_.load(_loc6_);
      }
      
      public function uploadSenseiLog(param1:String, param2:ByteArray, param3:Function, param4:Function) : void
      {
         var _loc5_:String = _bankURL + getLoginToken();
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         _loc6_.contentType = "application/xml";
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = "";
         var _loc7_:URLLoader = new URLLoader();
         _loc7_.addEventListener(Event.COMPLETE,param3);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,param4);
         _loc7_.load(_loc6_);
      }
      
      public function getDeviceManifestXml(param1:Function, param2:Function) : void
      {
         log("getDeviceManifestXml()");
         var _loc3_:String = encodeURI(Utils.appendKillCache(_staticFileServiceURL + "/device/device-manifest.xml"));
         var _loc4_:URLLoader = new URLLoader();
         _loc4_.addEventListener(Event.COMPLETE,param1,false,0,true);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,param2,false,0,true);
         _loc4_.load(new URLRequest(_loc3_));
      }
      
      private function getLoginToken() : String
      {
         return _loginTokenProvider.getLoginToken();
      }
      
      public function getFirmwareSignature(param1:String, param2:Function, param3:Function) : void
      {
         log("getFirmwareSignature()");
         var _loc4_:String = encodeURI(Utils.appendKillCache(_bankURL + "/device/" + param1 + "/firmware/signature?auth=" + getLoginToken()));
         var _loc5_:URLRequest = new URLRequest(_loc4_);
         var _loc6_:URLLoader = new URLLoader();
         _loc6_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc6_.addEventListener(Event.COMPLETE,param2,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,param3,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      public function getAssetBinary(param1:String, param2:String, param3:Function, param4:Function) : void
      {
         if("" == param2)
         {
            throw new Error("Parameter \"nanovorAssetID\" cannot be empty.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \"successHandler\" cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \"errorHandler\" cannot be null.");
         }
         if(null == param1)
         {
            throw new Error("Parameter \"deviceID\" cannot be null.");
         }
         var _loc5_:String = encodeURI(Utils.appendKillCache(_bankURL + "/device/" + param1 + "/asset/" + param2 + "/sign/vinfo?auth=" + getLoginToken()));
         log("getAssetBinary(): url: " + _loc5_ + "\ndeviceID: " + param1 + ", nanovorAssetID: " + param2);
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         var _loc7_:URLLoader = new URLLoader();
         _loc7_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc7_.addEventListener(Event.COMPLETE,param3);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,param4);
         _loc7_.load(_loc6_);
      }
      
      public function getDeviceManifestBinary(param1:String, param2:Function, param3:Function) : void
      {
         var _loc4_:String = encodeURI(Utils.appendKillCache(_bankURL + "/device/" + param1 + "/manifest?auth=" + getLoginToken()));
         var _loc5_:URLRequest = new URLRequest(_loc4_);
         var _loc6_:URLLoader = new URLLoader();
         _loc6_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc6_.addEventListener(Event.COMPLETE,param2,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,param3,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      public function getNewPrivKey(param1:String, param2:Function, param3:Function) : void
      {
         var _loc4_:String = "NewPrivKey\\privkey.bbb";
         log("getNewPrivKey() - URL: " + _loc4_);
         var _loc5_:URLRequest = new URLRequest(_loc4_);
         _loc5_.method = URLRequestMethod.POST;
         var _loc6_:URLLoader = new URLLoader();
         _loc6_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc6_.addEventListener(Event.COMPLETE,param2,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,param3,false,0,true);
         _loc6_.load(_loc5_);
      }
      
      public function getDevicePlayerInfo(param1:String, param2:String, param3:Function, param4:Function) : void
      {
         var _loc5_:String = encodeURI(Utils.appendKillCache(_bankURL + "/device/" + param2 + "/account/" + param1 + "/sign/plyinfo?auth=" + getLoginToken()));
         log("getDevicePlayerInfo() - URL: " + _loc5_);
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         var _loc7_:URLLoader = new URLLoader();
         _loc7_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc7_.addEventListener(Event.COMPLETE,param3,false,0,true);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,param4,false,0,true);
         _loc7_.load(_loc6_);
      }
      
      public function uploadBattleLog(param1:String, param2:ByteArray, param3:Function, param4:Function) : void
      {
         var _loc5_:String = encodeURI(Utils.appendKillCache(_bankURL + "/device/" + param1 + "/battle-log?auth=" + getLoginToken()));
         var _loc6_:URLRequest = new URLRequest(_loc5_);
         var _loc7_:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
         _loc6_.requestHeaders.push(_loc7_);
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = param2;
         var _loc8_:URLLoader = new URLLoader();
         _loc8_.addEventListener(Event.COMPLETE,param3);
         _loc8_.addEventListener(IOErrorEvent.IO_ERROR,param4);
         _loc8_.load(_loc6_);
      }
      
      public function associateDevice(param1:ByteArray, param2:Function = null, param3:Function = null) : void
      {
         log("associateDevice()");
         var _loc4_:String = encodeURI(Utils.appendKillCache(_bankURL + "/device/associate?auth=" + getLoginToken()));
         var _loc5_:URLRequest = new URLRequest(_loc4_);
         var _loc6_:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
         _loc5_.requestHeaders.push(_loc6_);
         _loc5_.data = param1;
         _loc5_.method = URLRequestMethod.POST;
         var _loc7_:URLLoader = new URLLoader();
         _loc7_.addEventListener(Event.COMPLETE,param2,false,0,true);
         if(null != param3)
         {
            _loc7_.addEventListener(IOErrorEvent.IO_ERROR,param3,false,0,true);
         }
         _loc7_.load(_loc5_);
      }
   }
}

