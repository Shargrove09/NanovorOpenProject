package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class ApplicationManifestParser implements IApplicationManifestParser
   {
      
      private var _applicationManifestMetadata:IApplicationManifestMetadata;
      
      public function ApplicationManifestParser(param1:IApplicationManifestMetadata)
      {
         super();
         _applicationManifestMetadata = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ApplicationManifestParser: " + param1);
      }
      
      public function parseManifest(param1:XML) : IApplicationManifest
      {
         var fileXML:XML = null;
         var packageXML:XML = null;
         var file:IApplicationFile = null;
         var appPackage:IApplicationPackage = null;
         var fileRefXML:XML = null;
         var packageRefXML:XML = null;
         var fileID:String = null;
         var depFile:IApplicationFile = null;
         var packageID:String = null;
         var depPackage:IApplicationPackage = null;
         var applicationManifestXML:XML = param1;
         var applicationManifest:ApplicationManifest = new ApplicationManifest(_applicationManifestMetadata);
         for each(fileXML in applicationManifestXML.Files.File)
         {
            file = new ApplicationFile(_applicationManifestMetadata,String(fileXML.@id),String(fileXML.@filename),String(fileXML.@CRC));
            applicationManifest.fileList.addFile(file);
         }
         for each(packageXML in applicationManifestXML.Packages.Package)
         {
            appPackage = new ApplicationPackage(applicationManifest,String(packageXML.@id),int(packageXML.@priority));
            applicationManifest.packageList.addPackage(appPackage);
         }
         for each(appPackage in applicationManifest.packageList.packages)
         {
            try
            {
               packageXML = applicationManifestXML.Packages.Package.(@id == appPackage.type.name)[0];
            }
            catch(e:Error)
            {
               logError("parseManifest(): FATAL ERROR: could not find previously found package: \'" + appPackage.type.name + "\'\n" + e.message);
               throw e;
            }
            for each(fileRefXML in packageXML.Dependencies.FileRef)
            {
               fileID = fileRefXML.@id;
               depFile = applicationManifest.fileList.getFile(fileID);
               if(depFile == null)
               {
                  logError("parseManifest(): Package [" + packageXML.@id + "] lists a dependency on file with id=\'" + fileID + "\' that could not be found in file list.");
               }
               else
               {
                  appPackage.addDependency(depFile);
               }
            }
            for each(packageRefXML in packageXML.Dependencies.PackageRef)
            {
               packageID = packageRefXML.@id;
               depPackage = applicationManifest.packageList.getPackage(PackageType.parse(packageID));
               if(depPackage == null)
               {
                  logError("parseManifest(): Package [" + appPackage.type.name + "] lists a dependency on package with id=\'" + packageID + "\' that could not be found in package list.");
               }
               else
               {
                  appPackage.addDependency(depPackage);
               }
            }
         }
         return applicationManifest;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ApplicationManifestParser: " + param1);
      }
   }
}

