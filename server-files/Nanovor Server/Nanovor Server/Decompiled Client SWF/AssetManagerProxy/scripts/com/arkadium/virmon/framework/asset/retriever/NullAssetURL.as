package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class NullAssetURL extends AssetURL
   {
      
      public function NullAssetURL(param1:String = "")
      {
         super("",AssetURLType.NOT_FOUND,null);
         logError(param1 + "\n" + new Error("STACK TRACE").getStackTrace());
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NullAssetURL: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NullAssetURL: " + param1);
      }
   }
}

