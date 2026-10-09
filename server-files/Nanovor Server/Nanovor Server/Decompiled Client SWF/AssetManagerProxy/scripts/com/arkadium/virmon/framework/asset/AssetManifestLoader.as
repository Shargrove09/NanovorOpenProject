package com.arkadium.virmon.framework.asset
{
   import com.arkadium.communications.IStaticFileServiceURLProvider;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class AssetManifestLoader implements IDownloaderConsumer, IManifestLoader
   {
      
      private static const FILE_DELIMETER:String = "\\";
      
      private var _fileOperator:IFileOperator;
      
      private var _assetManifestURLLoader:URLLoader;
      
      private var _posixFileName:String;
      
      private var _staticFileServiceURLProvider:IStaticFileServiceURLProvider;
      
      private var _manifestLoaderConsumer:IManifestLoaderConsumer;
      
      private var _downloader:IDownloader;
      
      private var _manifestReference:IManifestReference;
      
      private var _assetManifestXML:XML;
      
      public function AssetManifestLoader(param1:IManifestReference, param2:IFileOperator, param3:IDownloader, param4:IStaticFileServiceURLProvider)
      {
         super();
         _manifestReference = param1;
         _fileOperator = param2;
         _downloader = param3;
         _staticFileServiceURLProvider = param4;
      }
      
      private function handleLoadComplete() : void
      {
         _manifestReference.updateManifestReferenceInMetadata();
         _manifestLoaderConsumer.handleManifestLoadComplete(_manifestReference);
         _manifestLoaderConsumer = null;
      }
      
      private function handleLoadError(param1:String) : void
      {
         logError("handleLoadError()");
         _manifestLoaderConsumer.handleManifestLoadError(param1);
      }
      
      public function get posixFileName() : String
      {
         return _posixFileName;
      }
      
      private function handleManifestLoadError(param1:IOErrorEvent) : void
      {
         logError("handleManifestLoadError():\n" + param1.text);
         _assetManifestURLLoader.removeEventListener(Event.COMPLETE,handleManifestLoadComplete);
         _assetManifestURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestLoadError);
         handleLoadError("Failed to load manifest file.");
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AssetManifestLoader>> " + param1);
      }
      
      private function downloadManifestFile() : void
      {
         var _loc1_:String = AssetLocation.ASSETS_DIRECTORY.name + FILE_DELIMETER + _posixFileName.replace(/\//g,"\\");
         _fileOperator.makeFolder(_loc1_.substr(0,_loc1_.lastIndexOf(FILE_DELIMETER)));
         _downloader.downloadFile(IDownloaderConsumer(this),convertFilePathToServerURL(_posixFileName),_loc1_,_manifestReference.CRC);
      }
      
      private function handleManifestLoadComplete(param1:Event) : void
      {
         var e:Event = param1;
         _assetManifestURLLoader.removeEventListener(Event.COMPLETE,handleManifestLoadComplete);
         _assetManifestURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestLoadError);
         try
         {
            _assetManifestXML = new XML(e.target.data);
         }
         catch(error:Error)
         {
            handleLoadError("Loaded XML is invalid: " + _posixFileName);
            return;
         }
         handleLoadComplete();
      }
      
      public function get assetManifestXML() : XML
      {
         return _assetManifestXML;
      }
      
      public function load(param1:IManifestLoaderConsumer) : void
      {
         _manifestLoaderConsumer = param1;
         _posixFileName = Utils.DOStoPOSIXpath(_manifestReference.fileName);
         if(_manifestReference.isOutdated)
         {
            downloadManifestFile();
            return;
         }
         loadManifest();
      }
      
      public function handleDownloadError(param1:String) : void
      {
         logError("handleManifestDownloadError()");
         handleLoadError(param1);
      }
      
      public function handleDownloadComplete(param1:String, param2:String) : void
      {
         loadManifest();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<AssetManifestLoader>> " + param1);
      }
      
      public function handleDownloadProgress(param1:Number, param2:Number) : void
      {
      }
      
      private function loadManifest() : void
      {
         _assetManifestURLLoader = new URLLoader();
         _assetManifestURLLoader.addEventListener(Event.COMPLETE,handleManifestLoadComplete);
         _assetManifestURLLoader.addEventListener(IOErrorEvent.IO_ERROR,handleManifestLoadError);
         _assetManifestURLLoader.load(new URLRequest(AssetLocation.ASSETS_DIRECTORY.name + "/" + _posixFileName));
      }
      
      private function convertFilePathToServerURL(param1:String) : String
      {
         return _staticFileServiceURLProvider.staticFileServiceURL + "/" + param1;
      }
   }
}

