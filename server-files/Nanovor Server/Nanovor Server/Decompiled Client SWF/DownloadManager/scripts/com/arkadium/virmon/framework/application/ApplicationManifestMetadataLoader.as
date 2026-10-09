package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ApplicationManifestMetadataLoader implements IApplicationManifestMetadataLoader
   {
      
      private var _manifestMetadataURLLoader:URLLoader;
      
      private var _handler:IApplicationManifestMetadataLoaderConsumer;
      
      private var _posixFilePath:String;
      
      private var _fileExists:Boolean;
      
      private var _manifestMetadataXML:XML;
      
      private var _fileOperator:IFileOperator;
      
      public function ApplicationManifestMetadataLoader(param1:IFileOperator, param2:String)
      {
         super();
         _fileOperator = param1;
         _posixFilePath = param2;
         _manifestMetadataXML = null;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationManifestMetadataLoader: " + param1);
      }
      
      public function load(param1:IApplicationManifestMetadataLoaderConsumer) : void
      {
         log("load()");
         _handler = param1;
         _fileExists = _fileOperator.doesFileExist(Environment.posixToLocalPath(_posixFilePath));
         if(false == _fileExists)
         {
            log("load(): manifest metadata file does not exist: " + _posixFilePath);
            handleLoadComplete();
            return;
         }
         log("load(): about to load manifest metadata... filePath=" + _posixFilePath);
         _manifestMetadataURLLoader = new URLLoader();
         _manifestMetadataURLLoader.addEventListener(Event.COMPLETE,handleManifestMetadataLoadComplete);
         _manifestMetadataURLLoader.addEventListener(IOErrorEvent.IO_ERROR,handleManifestMetadataLoadError);
         _manifestMetadataURLLoader.load(new URLRequest(_posixFilePath));
      }
      
      private function handleLoadComplete() : void
      {
         log("handleLoadComplete()");
         _handler.handleManifestMetadataLoadComplete(_fileExists);
         _handler = null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationManifestMetadataLoader: " + param1);
      }
      
      public function get manifestMetadataXML() : XML
      {
         return _manifestMetadataXML;
      }
      
      private function handleManifestMetadataLoadError(param1:IOErrorEvent) : void
      {
         logError("handleManifestMetadataLoadError():\n" + param1.text);
         _manifestMetadataURLLoader.removeEventListener(Event.COMPLETE,handleManifestMetadataLoadComplete);
         _manifestMetadataURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestMetadataLoadError);
      }
      
      private function handleManifestMetadataLoadComplete(param1:Event) : void
      {
         var e:Event = param1;
         log("handleManifestMetadataLoadComplete(): " + _posixFilePath);
         _manifestMetadataURLLoader.removeEventListener(Event.COMPLETE,handleManifestMetadataLoadComplete);
         _manifestMetadataURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestMetadataLoadError);
         try
         {
            _manifestMetadataXML = new XML(e.target.data);
         }
         catch(error:Error)
         {
            _handler.handleManifestMetadataLoadError("Loaded XML is invalid: " + _posixFilePath);
            _handler = null;
            return;
         }
         handleLoadComplete();
      }
   }
}

