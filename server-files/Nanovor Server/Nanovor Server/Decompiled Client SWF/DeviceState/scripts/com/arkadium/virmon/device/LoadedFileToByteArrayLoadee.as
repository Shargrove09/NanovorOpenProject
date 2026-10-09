package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class LoadedFileToByteArrayLoadee implements IChainLoadee
   {
      
      private var _loader:URLLoader;
      
      private var _location:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _consumer:IFileToByteArrayConsumer;
      
      public function LoadedFileToByteArrayLoadee(param1:String, param2:IFileToByteArrayConsumer)
      {
         super();
         _location = param1;
         _consumer = param2;
      }
      
      private function onFileLoaded(param1:Event) : void
      {
         _loader.removeEventListener(Event.COMPLETE,onFileLoaded);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR,onFileError);
         var _loc2_:ByteArray = ByteArray(param1.target.data);
         _consumer.setByteArray(_location,_loc2_);
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function onFileError(param1:IOErrorEvent) : void
      {
         _loader.removeEventListener(Event.COMPLETE,onFileLoaded);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR,onFileError);
         log("could not load file!");
         _chainLoader.handleChainLoadeeError();
      }
      
      public function load() : void
      {
         log("trying to load file! from: " + _location);
         var _loc1_:URLRequest = new URLRequest(_location);
         _loader = new URLLoader();
         _loader.dataFormat = URLLoaderDataFormat.BINARY;
         _loader.addEventListener(Event.COMPLETE,onFileLoaded);
         _loader.addEventListener(IOErrorEvent.IO_ERROR,onFileError);
         _loader.load(_loc1_);
      }
      
      public function get name() : String
      {
         return "LoadedFileToByteArrayLoadee";
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<LoadedFileToByteArrayLoadee>>\t" + param1);
      }
   }
}

