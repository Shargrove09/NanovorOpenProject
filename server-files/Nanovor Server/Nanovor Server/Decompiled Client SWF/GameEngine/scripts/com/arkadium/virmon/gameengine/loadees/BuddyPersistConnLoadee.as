package com.arkadium.virmon.gameengine.loadees
{
   import com.arkadium.communications.IBuddyListGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.BuddyPersistConn;
   import com.arkadium.virmon.framework.IBuddyPersistConn;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainCachee;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BuddyPersistConnLoadee implements IChainLoadee, IChainCachee
   {
      
      private var _assetCache:IAssetCache;
      
      private var _chainLoader:IChainLoader;
      
      private var _userGameService:IUserGameService;
      
      private var _buddyListGameService:IBuddyListGameService;
      
      public function BuddyPersistConnLoadee(param1:IBuddyListGameService, param2:IUserGameService)
      {
         super();
         _buddyListGameService = param1;
         _userGameService = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BuddyPersistConnLoadee: " + param1);
      }
      
      public function load() : void
      {
         log("load()");
         var _loc1_:IUserProfile = _assetCache.getLoadedAsset("UserProfile") as IUserProfile;
         var _loc2_:IBuddyPersistConn = new BuddyPersistConn(_buddyListGameService,_userGameService,_loc1_.id);
         _chainLoader.handleChainLoadeeComplete(_loc2_);
         _chainLoader = null;
         _assetCache = null;
      }
      
      public function get name() : String
      {
         return "BuddyPersistConnLoadee";
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function setAssetCache(param1:IAssetCache) : void
      {
         log("setAssetCache()");
         _assetCache = param1;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BuddyPersistConnLoadee: " + param1);
      }
   }
}

