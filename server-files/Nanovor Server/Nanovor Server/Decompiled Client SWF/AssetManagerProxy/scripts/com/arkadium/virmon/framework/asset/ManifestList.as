package com.arkadium.virmon.framework.asset
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public dynamic class ManifestList extends Dictionary implements IManifestList
   {
      
      private var _manifestCount:uint;
      
      public function ManifestList(param1:Boolean = false)
      {
         super(param1);
         _manifestCount = 0;
      }
      
      public function addManifest(param1:IAssetManifest) : void
      {
         if(null != this[param1.name])
         {
            return;
         }
         ++_manifestCount;
         this[param1.name] = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ManifestList: " + param1);
      }
      
      public function getManifest(param1:String) : IAssetManifest
      {
         return this[param1] as IAssetManifest;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ManifestList: " + param1);
      }
      
      public function get length() : uint
      {
         return _manifestCount;
      }
   }
}

