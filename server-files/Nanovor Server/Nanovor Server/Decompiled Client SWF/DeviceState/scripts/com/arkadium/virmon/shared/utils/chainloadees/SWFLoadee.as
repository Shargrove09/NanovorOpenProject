package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class SWFLoadee implements IChainLoadee
   {
      
      public static const NAME:String = "SWFLoadee";
      
      private static const SHOW_LOGGING:Boolean = false;
      
      private var _swfPath:String;
      
      private var _hash:String;
      
      private var _loader:Loader;
      
      private var _chainLoader:IChainLoader;
      
      private var _loaderContext:LoaderContext;
      
      public function SWFLoadee(param1:String, param2:LoaderContext = null, param3:String = "")
      {
         super();
         _swfPath = param1;
         _loaderContext = param2;
         _hash = param3;
      }
      
      public function load() : void
      {
         log("load(): " + _swfPath);
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderComplete,false,0,false);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoaderFailure,false,0,false);
         _loader.load(new URLRequest(_swfPath),_loaderContext);
      }
      
      private function destroy() : void
      {
         if(null != _loader)
         {
            try
            {
               _loader.close();
            }
            catch(e:Error)
            {
            }
            _loader.unload();
            _loader = null;
         }
      }
      
      public function get name() : String
      {
         return NAME + _swfPath + _hash;
      }
      
      private function removeLoaderListeners() : void
      {
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaderComplete);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoaderFailure);
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         log("onLoaderComplete(): " + _swfPath);
         removeLoaderListeners();
         var _loc2_:Object = _loader.content;
         if(null != _chainLoader)
         {
            _chainLoader.handleChainLoadeeComplete(_loc2_);
            _chainLoader = null;
         }
         destroy();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function log(param1:String) : void
      {
         if(SHOW_LOGGING)
         {
            DebugLog.instance.log("<<SWFLoadee>>\t" + param1);
         }
      }
      
      private function onLoaderFailure(param1:IOErrorEvent) : void
      {
         log("onLoaderFailure(): " + _swfPath);
         removeLoaderListeners();
         destroy();
         if(null != _chainLoader)
         {
            _chainLoader.handleChainLoadeeError();
            _chainLoader = null;
         }
      }
   }
}

