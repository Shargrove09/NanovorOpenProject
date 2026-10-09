package com.arkadium.virmon.framework.asset
{
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class ManifestMetadataLoader implements IManifestMetadataLoader
   {
      
      private static const _MAX_RETRIES:int = 2;
      
      private var _manifestMetadataURLLoader:URLLoader;
      
      private var _handler:IManifestMetadataLoaderConsumer;
      
      private var _posixFilePath:String;
      
      private var _retryAttempts:int;
      
      private var _manifestMetadataXML:XML;
      
      private var _manifestReference:IManifestReference;
      
      private var _fileOperator:IFileOperator;
      
      public function ManifestMetadataLoader(param1:IFileOperator, param2:IManifestReference)
      {
         super();
         _fileOperator = param1;
         _manifestReference = param2;
         _manifestMetadataXML = null;
         _retryAttempts = 0;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ManifestMetadataLoader: " + param1);
      }
      
      public function load(param1:String, param2:IManifestMetadataLoaderConsumer) : void
      {
         _handler = param2;
         _posixFilePath = AssetLocation.ASSETS_DIRECTORY.name + "/" + param1;
         _manifestMetadataURLLoader = new URLLoader();
         _manifestMetadataURLLoader.addEventListener(Event.COMPLETE,handleManifestMetadataLoadComplete);
         _manifestMetadataURLLoader.addEventListener(IOErrorEvent.IO_ERROR,handleManifestMetadataLoadError);
         _manifestMetadataURLLoader.load(new URLRequest(_posixFilePath));
      }
      
      private function handleManifestMetadataLoadComplete(param1:Event) : void
      {
         var e:Event = param1;
         _manifestMetadataURLLoader.removeEventListener(Event.COMPLETE,handleManifestMetadataLoadComplete);
         _manifestMetadataURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestMetadataLoadError);
         try
         {
            _manifestMetadataXML = new XML(e.target.data);
         }
         catch(error:Error)
         {
            if(_retryAttempts < _MAX_RETRIES)
            {
               ++_retryAttempts;
               _fileOperator.deleteFile(Environment.posixToLocalPath(_posixFilePath));
               logError("Loaded XML was invalid; attempting to delete metadata file : " + _posixFilePath + "\n" + "... and call load() again.");
               load(_posixFilePath.replace(AssetLocation.ASSETS_DIRECTORY.name + "/",""),_handler);
               return;
            }
            _handler.handleManifestMetadataLoadError("Loaded XML was invalid, so the metadata file was deleted: " + _posixFilePath);
            _handler = null;
            return;
         }
         handleLoadComplete(true);
      }
      
      private function handleLoadComplete(param1:Boolean) : void
      {
         _handler.handleManifestMetadataLoadComplete(param1,_posixFilePath,_manifestReference);
         _handler = null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ManifestMetadataLoader: " + param1);
      }
      
      public function get manifestMetadataXML() : XML
      {
         return _manifestMetadataXML;
      }
      
      private function handleManifestMetadataLoadError(param1:IOErrorEvent) : void
      {
         log("handleManifestMetadataLoadError(): Not an error necessarily, just couldn\'t find/open the file:\n" + param1.text);
         _manifestMetadataURLLoader.removeEventListener(Event.COMPLETE,handleManifestMetadataLoadComplete);
         _manifestMetadataURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestMetadataLoadError);
         handleLoadComplete(false);
      }
   }
}

