package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.URLAssetChainLoadee;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoaderDataFormat;
   import flash.utils.ByteArray;
   
   public class DeviceLogChainLoadee extends URLAssetChainLoadee
   {
      
      private var _deviceID:String;
      
      private var _logUploader:ILogUploader;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceLogChainLoadee(param1:String, param2:ILogUploader, param3:IFileOperator, param4:String)
      {
         super(param1,URLLoaderDataFormat.BINARY);
         _logUploader = param2;
         _fileOperator = param3;
         _deviceID = param4;
      }
      
      private function handleUploadLogFailure(param1:IOErrorEvent) : void
      {
         logError("handleUploadLogFailure(): " + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleUploadLogSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleUploadLogFailure);
         _chainLoader.handleChainLoadeeError();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceLogChainLoadee>> " + param1);
      }
      
      private function handleUploadLogSuccess(param1:Event) : void
      {
         log("handleUploadLogSuccess()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleUploadLogSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleUploadLogFailure);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         var _loc3_:int = int(_loc2_.elements("total-updates"));
         var _loc4_:int = int(_loc2_.elements("successful-updates"));
         _fileOperator.deleteFile(_url);
         _chainLoader.handleChainLoadeeComplete(_loc4_);
      }
      
      override protected function handleLoadComplete(param1:Event) : void
      {
         log("handleLoadComplete()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleLoadError);
         _logUploader.uploadLog(ByteArray(param1.currentTarget.data),handleUploadLogSuccess,handleUploadLogFailure);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("**<<DeviceLogChainLoadee>>** " + param1);
      }
   }
}

