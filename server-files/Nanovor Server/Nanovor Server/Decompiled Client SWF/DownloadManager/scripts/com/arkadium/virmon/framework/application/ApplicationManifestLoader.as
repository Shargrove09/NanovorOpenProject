package com.arkadium.virmon.framework.application
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   internal class ApplicationManifestLoader
   {
      
      private var _posixFilePath:String;
      
      private var _manifestXML:XML;
      
      private var _handler:IApplicationManifestLoaderConsumer;
      
      private var _manifestURLLoader:URLLoader;
      
      public function ApplicationManifestLoader(param1:String)
      {
         super();
         _posixFilePath = param1;
      }
      
      private function handleManifestLoadError(param1:IOErrorEvent) : void
      {
         _manifestURLLoader.removeEventListener(Event.COMPLETE,handleManifestLoadComplete);
         _manifestURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestLoadError);
         handleLoadError(param1.text);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationManifestLoader: " + param1);
      }
      
      public function loadManifest(param1:IApplicationManifestLoaderConsumer) : void
      {
         _handler = param1;
         _manifestURLLoader = new URLLoader();
         _manifestURLLoader.addEventListener(Event.COMPLETE,handleManifestLoadComplete);
         _manifestURLLoader.addEventListener(IOErrorEvent.IO_ERROR,handleManifestLoadError);
         _manifestURLLoader.load(new URLRequest(_posixFilePath));
      }
      
      public function get applicationManifestXML() : XML
      {
         return _manifestXML;
      }
      
      private function handleLoadError(param1:String) : void
      {
         _handler.handleManifestLoadError(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationManifestLoader: " + param1);
      }
      
      private function handleManifestLoadComplete(param1:Event) : void
      {
         var e:Event = param1;
         log("handleManifestLoadComplete()");
         _manifestURLLoader.removeEventListener(Event.COMPLETE,handleManifestLoadComplete);
         _manifestURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,handleManifestLoadError);
         try
         {
            _manifestXML = new XML(e.target.data);
         }
         catch(error:Error)
         {
            handleLoadError("Loaded XML is invalid: " + _posixFilePath);
            return;
         }
         _handler.handleManifestLoadComplete();
      }
   }
}

