package com.arkadium.virmon.framework.application
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ApplicationManifestComparator
   {
      
      private var _downloadItemList:ApplicationDownloadItemList;
      
      public function ApplicationManifestComparator()
      {
         super();
      }
      
      public function prioritizeOutdatedFiles(param1:IApplicationManifest) : void
      {
         var _loc2_:IApplicationFile = null;
         var _loc3_:IApplicationPackageList = null;
         var _loc4_:ApplicationDownloadItem = null;
         var _loc5_:IApplicationPackage = null;
         log("prioritizeOutdatedFiles()");
         _downloadItemList = new ApplicationDownloadItemList();
         for each(_loc2_ in param1.fileList.files)
         {
            _loc3_ = new ApplicationPackageList();
            if(_loc2_.isOutdated)
            {
               _loc4_ = new ApplicationDownloadItem(_loc2_,_loc3_);
               for each(_loc5_ in param1.packageList.packages)
               {
                  if(_loc5_.hasFileDependency(_loc2_.id))
                  {
                     _loc4_.priority = Math.min(_loc4_.priority,_loc5_.priority);
                     _loc3_.addPackage(_loc5_);
                  }
               }
               if(_loc4_.priority != int.MAX_VALUE)
               {
                  _downloadItemList.push(_loc4_);
               }
            }
         }
         _downloadItemList.sort();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationManifestComparator: " + param1);
      }
      
      public function get downloadItemList() : ApplicationDownloadItemList
      {
         return _downloadItemList;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationManifestComparator: " + param1);
      }
   }
}

