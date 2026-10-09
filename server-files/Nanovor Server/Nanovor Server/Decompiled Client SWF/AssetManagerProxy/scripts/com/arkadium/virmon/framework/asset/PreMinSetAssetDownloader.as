package com.arkadium.virmon.framework.asset
{
   import com.arkadium.communications.IStaticFileServiceURLProvider;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class PreMinSetAssetDownloader extends AbstractRequiredAssetDownloader
   {
      
      public function PreMinSetAssetDownloader(param1:IAssetDownloadItemList, param2:IDownloadManagerStatusMediator, param3:IDownloader, param4:IStaticFileServiceURLProvider)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function log(param1:String) : void
      {
         DebugLog.instance.log("<<PreMinAssetDownloader>> " + param1);
      }
      
      override protected function logError(param1:String) : void
      {
         DebugLog.instance.error("<<PreMinAssetDownloader>> " + param1);
      }
   }
}

