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
            this.logError("Parameter \"chainLoadeeList\" cannot be null.");
         }
         if(null == param2)
         {
            this.logError("Parameter \"chainLoaderConsumer\" cannot be null.");
         }
         if(0 == param1.length)
         {
            this.log("WARNING: parameter \"chainLoadeeList\" was empty.");
         }
         this._index = 0;
         this._chainLoadeeList = param1;
         this._chainLoaderConsumer = param2;
         this._loadedAssets = new Object();
         this._isDestroyed = false;
      }
      
      public function getLoadedAsset(param1:String) : Object
      {
         if(null == param1 || param1.length == 0)
         {
            throw new Error("Parameter \'key\' cannot be null or empty.");
         }
         return this._loadedAssets[param1];
      }
      
      public function resumeChainLoadAfterError() : void
      {
         ++this._index;
         this.loadNext();
      }
      
      public function handleChainLoadeeError() : void
      {
         throw new Error("Failed to load \'" + this._chainLoadeeList.at(this._index).name + "\'.");
      }
      
      public function load() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._chainLoadeeList.length)
         {
            this._chainLoadeeList.at(_loc1_).setChainLoader(this as IChainLoader);
            if(null != this._chainLoadeeList.chainCacheeAt(_loc1_))
            {
               this._chainLoadeeList.chainCacheeAt(_loc1_).setAssetCache(this as IAssetCache);
            }
            _loc1_++;
         }
         this.loadNext();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<ChainLoader>> " + param1);
      }
      
      public function destroy() : void
      {
         if(null != this._chainLoadeeList)
         {
            this._chainLoadeeList.destroy();
            this._chainLoadeeList = null;
         }
         this._loadedAssets = null;
         this._chainLoaderConsumer = null;
         this._isDestroyed = true;
      }
      
      public function handleChainLoadeeComplete(param1:Object = null) : void
      {
         if(this._isDestroyed)
         {
            return;
         }
         if(null != param1)
         {
            this._loadedAssets[this._chainLoadeeList.at(this._index).name] = param1;
            this.log("handleChainLoadeeComplete(): at _index=" + this._index + " got loaded data");
         }
         ++this._index;
         this.loadNext();
      }
      
      protected function loadNext() : void
      {
         if(this._isDestroyed)
         {
            return;
         }
         if(this._index >= this._chainLoadeeList.length)
         {
            if(null != this._chainLoaderConsumer)
            {
               this._chainLoaderConsumer.handleChainLoaderComplete(IAssetCache(this));
            }
            return;
         }
         this._chainLoadeeList.at(this._index).load();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<ChainLoader>> " + new Error(param1).getStackTrace());
      }
   }
}

