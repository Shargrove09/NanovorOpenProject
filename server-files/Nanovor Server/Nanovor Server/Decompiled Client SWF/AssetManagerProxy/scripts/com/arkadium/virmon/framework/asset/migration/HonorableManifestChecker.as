package com.arkadium.virmon.framework.asset.migration
{
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class HonorableManifestChecker
   {
      
      private var _urlLoader:URLLoader;
      
      private var _posixFilePath:String;
      
      private var _manifestXML:XML;
      
      private var _consumer:IHonorableManifestCheckerConsumer;
      
      private var _fileOperator:IFileOperator;
      
      public function HonorableManifestChecker(param1:IFileOperator)
      {
         super();
         _fileOperator = param1;
      }
      
      public function get posixFilePath() : String
      {
         return _posixFilePath;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** HonorableManifestChecker: " + param1);
      }
      
      public function get manifestXML() : XML
      {
         return _manifestXML;
      }
      
      public function checkFile(param1:String, param2:IHonorableManifestCheckerConsumer) : void
      {
         log("checkFile(): posixFilePath=" + param1);
         _consumer = param2;
         _posixFilePath = param1;
         if(!_fileOperator.doesFileExist(localFilePath))
         {
            log("checkFile(): file does not exist: localFilePath=" + localFilePath);
            return handleFileCheckComplete(false);
         }
         _urlLoader = new URLLoader();
         _urlLoader.addEventListener(Event.COMPLETE,onUrlLoaderComplete,false,0,true);
         _urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onUrlLoaderError,false,0,true);
         _urlLoader.load(new URLRequest(param1));
      }
      
      public function get localFilePath() : String
      {
         return Environment.posixToLocalPath(Environment.localApplicationPath + _posixFilePath);
      }
      
      private function onUrlLoaderError(param1:IOErrorEvent) : void
      {
         _urlLoader.removeEventListener(Event.COMPLETE,onUrlLoaderComplete);
         _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onUrlLoaderError);
         logError("onUrlLoaderError(): " + param1.text);
         handleFileCheckComplete(false);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> HonorableManifestChecker: " + param1);
      }
      
      private function onUrlLoaderComplete(param1:Event) : void
      {
         var e:Event = param1;
         _urlLoader.removeEventListener(Event.COMPLETE,onUrlLoaderComplete);
         _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onUrlLoaderError);
         try
         {
            _manifestXML = new XML((e.target as URLLoader).data);
         }
         catch(e:Error)
         {
            logError("onUrlLoaderComplete(): _manifestXML was invalid!!");
            return handleFileCheckComplete(false);
         }
         if(_manifestXML == null || _manifestXML.toXMLString() == "")
         {
            log("onUrlLoaderComplete(): _manifestXML is null or empty");
            return handleFileCheckComplete(false);
         }
         handleFileCheckComplete(true);
      }
      
      private function handleFileCheckComplete(param1:Boolean) : void
      {
         _consumer.handleHonorableManifestCheckComplete(param1);
         _consumer = null;
         _urlLoader = null;
      }
   }
}

