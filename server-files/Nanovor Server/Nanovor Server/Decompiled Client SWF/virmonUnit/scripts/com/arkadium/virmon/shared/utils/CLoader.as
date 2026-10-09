package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.shared.elements.CCollectionVirmonUnit;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class CLoader extends Loader
   {
      
      private var cVirmon:IVirmon;
      
      private var _transferredData:* = null;
      
      private var cCollectionVirmonUnit:CCollectionVirmonUnit;
      
      public function CLoader()
      {
         super();
      }
      
      public static function loadFile(param1:String, ... rest) : CLoader
      {
         var urlReq:URLRequest;
         var loader:CLoader = null;
         var urlLoader:URLLoader = null;
         var byteLoadComplete:Function = null;
         var path:String = param1;
         var trData:Array = rest;
         byteLoadComplete = function(param1:Event):void
         {
            trace("BYTE LOADS COMPLETE::" + path);
            urlLoader.removeEventListener(Event.COMPLETE,byteLoadComplete);
            loader.loadBytes(urlLoader.data);
         };
         loader = new CLoader();
         loader.configureListeners(loader.contentLoaderInfo);
         if(trData.length > 0)
         {
            loader.setTransferredData(trData[0]);
         }
         urlReq = new URLRequest(path);
         urlLoader = new URLLoader();
         urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         urlLoader.addEventListener(Event.COMPLETE,byteLoadComplete,false,0,true);
         urlLoader.load(urlReq);
         return loader;
      }
      
      private function setTransferredData(param1:*) : void
      {
         _transferredData = param1;
      }
      
      private function configureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,completeHandler,false,0,true);
      }
      
      private function completeHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target.content;
         if(_transferredData != null)
         {
            _loc2_.setData(_transferredData);
         }
         _transferredData = null;
         this.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeHandler);
      }
   }
}

