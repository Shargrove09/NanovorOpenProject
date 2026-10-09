package com.arkadium.virmon.shared.final
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class FinalComponentsLoader extends EventDispatcher implements IChainLoadee
   {
      
      private static const FINAL_COMPONENTS_SWF:String = "FinalComponents.swf";
      
      private static var _isLoaded:Boolean = false;
      
      private var _ldrLib:Loader;
      
      private var _chainLoader:IChainLoader;
      
      private var _loaderContext:LoaderContext;
      
      public function FinalComponentsLoader()
      {
         super();
         _loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         _ldrLib = new Loader();
      }
      
      private function onLdrLibComplete(param1:Event) : void
      {
         DebugLog.instance.log("FinalComponentsLoader rocks!");
         _isLoaded = true;
         _ldrLib.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrLibComplete);
         _ldrLib.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLdrLibFail);
         FinalExportsReference.addLoadeeReference(_ldrLib.content);
         _ldrLib = null;
         this.dispatchEvent(new Event(Event.COMPLETE));
         if(_chainLoader != null)
         {
            _chainLoader.handleChainLoadeeComplete();
         }
      }
      
      public function load() : void
      {
         DebugLog.instance.log("LOADING");
         if(_isLoaded)
         {
            onLdrLibComplete(null);
            return;
         }
         _isLoaded = true;
         loadLibrary();
      }
      
      private function onLdrLibFail(param1:IOErrorEvent) : void
      {
         _ldrLib.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrLibComplete);
         _ldrLib.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLdrLibFail);
         this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
         DebugLog.instance.error("FinalComponentsLoader failed horribly: " + param1.toString());
         if(_chainLoader != null)
         {
            _chainLoader.handleChainLoadeeError();
         }
      }
      
      public function get name() : String
      {
         return "FinalComponentsLoader";
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function loadLibrary() : void
      {
         _ldrLib.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrLibComplete,false,0,true);
         _ldrLib.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLdrLibFail,false,0,true);
         _ldrLib.load(new URLRequest(FINAL_COMPONENTS_SWF),_loaderContext);
      }
   }
}

