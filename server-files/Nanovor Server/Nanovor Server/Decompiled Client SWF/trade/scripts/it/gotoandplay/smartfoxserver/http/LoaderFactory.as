package it.gotoandplay.smartfoxserver.http
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   
   public class LoaderFactory
   {
      
      private static const DEFAULT_POOL_SIZE:int = 8;
      
      private var currentLoaderIndex:int;
      
      private var loadersPool:Array;
      
      public function LoaderFactory(param1:Function, param2:Function, param3:int = 8)
      {
         var _loc5_:URLLoader = null;
         super();
         loadersPool = [];
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = new URLLoader();
            _loc5_.dataFormat = URLLoaderDataFormat.TEXT;
            _loc5_.addEventListener(Event.COMPLETE,param1);
            _loc5_.addEventListener(IOErrorEvent.IO_ERROR,param2);
            _loc5_.addEventListener(IOErrorEvent.NETWORK_ERROR,param2);
            loadersPool.push(_loc5_);
            _loc4_++;
         }
         currentLoaderIndex = 0;
      }
      
      public function getLoader() : URLLoader
      {
         var _loc1_:URLLoader = loadersPool[currentLoaderIndex];
         ++currentLoaderIndex;
         if(currentLoaderIndex >= loadersPool.length)
         {
            currentLoaderIndex = 0;
         }
         return _loc1_;
      }
   }
}

