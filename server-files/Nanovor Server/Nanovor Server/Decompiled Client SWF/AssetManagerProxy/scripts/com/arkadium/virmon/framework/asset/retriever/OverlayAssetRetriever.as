package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAssetManager;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.enum.OverlayAssetType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class OverlayAssetRetriever implements IOverlayAssetRetriever
   {
      
      private var _assetManager:IAssetManager;
      
      public function OverlayAssetRetriever(param1:IAssetManager)
      {
         super();
         _assetManager = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> OverlayAssetRetriever: " + param1);
      }
      
      public function getOverlayURL(param1:OverlayAssetType, param2:int) : IAssetURL
      {
         var _loc3_:IAssetURL = _assetManager.getAssetURL("Overlays",param1.name,param2.toString());
         if(_loc3_.assetURLType == AssetURLType.NOT_FOUND)
         {
            logError("getOverlayURL(): asset not found: manifest <Overlays> group <" + param1.name + "> id <" + param2.toString() + ">");
         }
         return _loc3_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** OverlayAssetRetriever: " + param1);
      }
   }
}

