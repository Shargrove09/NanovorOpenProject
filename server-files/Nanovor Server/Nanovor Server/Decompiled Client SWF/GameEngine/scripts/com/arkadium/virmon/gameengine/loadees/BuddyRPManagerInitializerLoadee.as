package com.arkadium.virmon.gameengine.loadees
{
   import com.arkadium.virmon.framework.BuddyRPManager;
   import com.arkadium.virmon.framework.IBuddyPersistConn;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainCachee;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BuddyRPManagerInitializerLoadee implements IChainLoadee, IChainCachee
   {
      
      private var _assetCache:IAssetCache;
      
      private var _chainLoader:IChainLoader;
      
      public function BuddyRPManagerInitializerLoadee()
      {
         super();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BuddyManagerInitializerLoadee: " + param1);
      }
      
      public function load() : void
      {
         var _loc1_:IBuddyPersistConn = _assetCache.getLoadedAsset("BuddyPersistConnLoadee") as IBuddyPersistConn;
         if(_loc1_ == null)
         {
            logError("load(): buddyPersistConn is null -- probably an error!  Make sure the BuddyManagerIntializerLoadee occurs after UserProfile loadee.");
         }
         BuddyRPManager.getInstance().initialize(_loc1_);
         Managers.buddyRPManager = BuddyRPManager.getInstance();
         _chainLoader.handleChainLoadeeComplete();
         _chainLoader = null;
         _assetCache = null;
      }
      
      public function setAssetCache(param1:IAssetCache) : void
      {
         _assetCache = param1;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function get name() : String
      {
         return "BuddyRPManagerInitializerLoadee";
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BuddyManagerInitializerLoadee: " + param1);
      }
   }
}

