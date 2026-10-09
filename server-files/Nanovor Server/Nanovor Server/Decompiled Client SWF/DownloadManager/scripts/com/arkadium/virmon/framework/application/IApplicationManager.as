package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.framework.application.enum.PackagePriority;
   import com.arkadium.virmon.framework.application.enum.PackageType;
   
   public interface IApplicationManager
   {
      
      function init(param1:IApplicationManagerInitializedConsumer) : void;
      
      function initializerComplete(param1:IApplicationManifest, param2:IApplicationManifestMetadata) : void;
      
      function isPackageOutdated(param1:PackageType) : Boolean;
      
      function downloadItems(param1:IDownloadManagerStatusMediator, param2:PackagePriority) : void;
   }
}

