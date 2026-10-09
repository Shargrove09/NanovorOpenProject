package com.arkadium.virmon.gameengine.loadees
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.BuddyManager;
   import com.arkadium.virmon.framework.IBuddyPersistConn;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainCachee;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BuddyManagerInitializerLoadee implements IChainLoadee, IChainCachee
   {
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _assetCache:IAssetCache;
      
      private var _chainLoader:IChainLoader;
      
      public function BuddyManagerInitializerLoadee(param1:IAnalyticsManager)
      {
         super();
         _analyticsManager = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BuddyManagerInitializerLoadee: " + param1);
      }
      
      public function load() : void
      {
         var _loc1_:IUserProfile = _assetCache.getLoadedAsset("UserProfile") as IUserProfile;
         if(_loc1_ == null || _loc1_.screenname == "")
         {
            logError("load(): Cached UserProfile is null or singleton has empty screenname -- probably an error!  Make sure the BuddyManagerIntializerLoadee occurs occurs after UserProfile loadee.");
         }
         var _loc2_:IBuddyPersistConn = _assetCache.getLoadedAsset("BuddyPersistConnLoadee") as IBuddyPersistConn;
         if(_loc2_ == null)
         {
            logError("load(): buddyPersistConn is null -- probably an error!  Make sure this loadee occurs after BuddyPersistConnLoadee.");
         }
         BuddyManager.getInstance().initialize(_analyticsManager,_loc1_.screenname,_loc2_);
         Managers.buddyManager = BuddyManager.getInstance();
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
         return "BuddyManagerInitializerLoadee";
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BuddyManagerInitializerLoadee: " + param1);
      }
   }
}

