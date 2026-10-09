package com.arkadium.virmon.shared.utils
{
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class URLAssetChainLoadee implements IChainLoadee
   {
      
      private static const NAME:String = "URLAssetChainLoadee";
      
      private var _dataType:String;
      
      protected var _url:String;
      
      protected var _chainLoader:IChainLoader;
      
      public function URLAssetChainLoadee(param1:String, param2:String = "")
      {
         super();
         if(param2 == "")
         {
            _dataType = URLLoaderDataFormat.TEXT;
         }
         else
         {
            _dataType = param2;
         }
         if(null == param1 || 0 == param1.length)
         {
            throw new Error("Parameter \'url\' cannot be null or empty.");
         }
         _url = param1;
      }
      
      protected function handleLoadError(param1:IOErrorEvent) : void
      {
         log("handleLoadError(): " + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,handleLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleLoadError);
         _chainLoader.handleChainLoadeeError();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<URLAssetChainLoadee>> " + param1);
      }
      
      protected function handleLoadComplete(param1:Event) : void
      {
         log("handleLoadComplete(): successfully loaded \'" + _url + "\'.");
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,handleLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleLoadError);
         _chainLoader.handleChainLoadeeComplete(URLLoader(param1.currentTarget).data);
      }
      
      public function get name() : String
      {
         return _url;
      }
      
      public function load() : void
      {
         if(null == _chainLoader)
         {
            throw new Error("_chainLoader cannot be null: you must call setChainLoader() before calling load().");
         }
         log("load(): \'" + _url + "\'");
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,handleLoadComplete);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,handleLoadError);
         _loc1_.dataFormat = _dataType;
         var _loc2_:URLRequest = new URLRequest(Utils.appendKillCache(_url));
         _loc1_.load(_loc2_);
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

