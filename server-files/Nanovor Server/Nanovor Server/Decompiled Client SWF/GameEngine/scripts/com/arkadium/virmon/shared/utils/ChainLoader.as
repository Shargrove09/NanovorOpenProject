package com.arkadium.virmon.shared.utils
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   
   public class ChainLoader extends EventDispatcher implements IChainLoader, IAssetCache
   {
      
      private var _loadedAssets:Object;
      
      private var _chainLoaderConsumer:IChainLoaderConsumer;
      
      private var _isDestroyed:Boolean;
      
      private var _index:uint;
      
      private var _chainLoadeeList:ChainLoadeeList;
      
      public function ChainLoader(param1:ChainLoadeeList, param2:IChainLoaderConsumer)
      {
         super();
         if(null == param1)
         {
            logError("Parameter \"chainLoadeeList\" cannot be null.");
         }
         if(null == param2)
         {
            logError("Parameter \"chainLoaderConsumer\" cannot be null.");
         }
         if(0 == param1.length)
         {
            log("WARNING: parameter \"chainLoadeeList\" was empty.");
         }
         _index = 0;
         _chainLoadeeList = param1;
         _chainLoaderConsumer = param2;
         _loadedAssets = new Object();
         _isDestroyed = false;
      }
      
      public function getLoadedAsset(param1:String) : Object
      {
         if(null == param1 || param1.length == 0)
         {
            throw new Error("Parameter \'key\' cannot be null or empty.");
         }
         return _loadedAssets[param1];
      }
      
      public function resumeChainLoadAfterError() : void
      {
         ++_index;
         loadNext();
      }
      
      public function handleChainLoadeeError() : void
      {
         throw new Error("Failed to load \'" + _chainLoadeeList.at(_index).name + "\'.");
      }
      
      public function load() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < _chainLoadeeList.length)
         {
            _chainLoadeeList.at(_loc1_).setChainLoader(this as IChainLoader);
            if(null != _chainLoadeeList.chainCacheeAt(_loc1_))
            {
               _chainLoadeeList.chainCacheeAt(_loc1_).setAssetCache(this as IAssetCache);
            }
            _loc1_++;
         }
         loadNext();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<ChainLoader>> " + param1);
      }
      
      public function destroy() : void
      {
         if(null != _chainLoadeeList)
         {
            _chainLoadeeList.destroy();
            _chainLoadeeList = null;
         }
         _loadedAssets = null;
         _chainLoaderConsumer = null;
         _isDestroyed = true;
      }
      
      public function handleChainLoadeeComplete(param1:Object = null) : void
      {
         if(_isDestroyed)
         {
            return;
         }
         if(null != param1)
         {
            _loadedAssets[_chainLoadeeList.at(_index).name] = param1;
            log("handleChainLoadeeComplete(): at _index=" + _index + " got loaded data");
         }
         ++_index;
         loadNext();
      }
      
      protected function loadNext() : void
      {
         if(_isDestroyed)
         {
            return;
         }
         if(_index >= _chainLoadeeList.length)
         {
            if(null != _chainLoaderConsumer)
            {
               _chainLoaderConsumer.handleChainLoaderComplete(IAssetCache(this));
            }
            return;
         }
         _chainLoadeeList.at(_index).load();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<ChainLoader>> " + new Error(param1).getStackTrace());
      }
   }
}

