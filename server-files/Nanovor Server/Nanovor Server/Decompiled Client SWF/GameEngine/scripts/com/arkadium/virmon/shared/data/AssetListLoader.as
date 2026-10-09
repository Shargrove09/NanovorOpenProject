package com.arkadium.virmon.shared.data
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.virmon.framework.*;
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.URLAssetChainLoadee;
   import com.smithandtinker.nanovor.common.utils.FastCipher;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   
   public class AssetListLoader extends URLAssetChainLoadee
   {
      
      internal var _analyticsManager:IAnalyticsManager;
      
      public function AssetListLoader(param1:String, param2:IAnalyticsManager)
      {
         _analyticsManager = param2;
         super(param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AssetListLoader>> " + param1);
      }
      
      override protected function handleLoadComplete(param1:Event) : void
      {
         var _loc2_:IAssetCache = IAssetCache(_chainLoader);
         var _loc3_:String = String(_loc2_.getLoadedAsset(Managers.assetRetrieverManager.masterDataAssetRetriever.getMasterDataURL(MasterDataAssetType.NANOVOR).url));
         var _loc4_:XML = new XML(_loc3_);
         if(0 == _loc4_.children().length())
         {
            log("Decoding virmon master xml...");
            _loc4_ = decodeXML(_loc3_);
            log("Finished decoding virmon master xml.");
         }
         var _loc5_:XML = new XML(_loc2_.getLoadedAsset(Managers.assetRetrieverManager.masterDataAssetRetriever.getMasterDataURL(MasterDataAssetType.EM).url));
         var _loc6_:XML = new XML(_loc2_.getLoadedAsset(Managers.assetRetrieverManager.masterDataAssetRetriever.getMasterDataURL(MasterDataAssetType.BADGE).url));
         var _loc7_:XML = new XML(URLLoader(param1.currentTarget).data);
         DataManager.getInstance().getVirmonManager().setLists(_loc4_,_loc7_);
         DataManager.getInstance().getEMManager().setLists(_loc5_,_loc7_);
         DataManager.getInstance().getBadgeManager().setList(_loc6_);
         super.handleLoadComplete(param1);
      }
      
      private function decodeXML(param1:String) : XML
      {
         return new XML(FastCipher.decode(param1));
      }
      
      override public function load() : void
      {
         super.load();
         _analyticsManager.trackAction(Action.LOGIN_BANK_ASSET_DATA_REQUESTED);
      }
   }
}

