package com.arkadium.virmon.downloadmanager
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   
   public interface IDownloadManager
   {
      
      function init(param1:IDownloadManagerStatusMediator, param2:IUserProfile, param3:IDownloader, param4:IServiceRequestBrokerManager, param5:IFileOperator, param6:IVirmonDataRetriever, param7:IEvoDataRetriever, param8:IAnalyticsManager) : void;
      
      function isPackageOutdated(param1:PackageType) : Boolean;
   }
}

