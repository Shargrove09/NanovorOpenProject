package com.arkadium.virmon.framework.asset.migration
{
   import com.arkadium.virmon.framework.asset.AssetLocation;
   import com.arkadium.virmon.framework.asset.IManifestMetadataLoaderConsumer;
   import com.arkadium.virmon.framework.asset.IManifestReference;
   import com.arkadium.virmon.framework.asset.ManifestMetadataLoader;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class RootMetadataChecker implements IManifestMetadataLoaderConsumer
   {
      
      private var _manifestMetadataLoader:ManifestMetadataLoader;
      
      private var _metadataFilename:String;
      
      private var _rootMetadataCheckerConsumer:IRootMetadataCheckerConsumer;
      
      private var _fileOperator:IFileOperator;
      
      public function RootMetadataChecker(param1:IFileOperator, param2:IRootMetadataCheckerConsumer)
      {
         super();
         _fileOperator = param1;
         _rootMetadataCheckerConsumer = param2;
         _metadataFilename = AssetLocation.MANIFEST_METADATA_FILE_NAME.name;
      }
      
      public function start() : void
      {
         log("start()");
         _manifestMetadataLoader = new ManifestMetadataLoader(_fileOperator,null);
         _manifestMetadataLoader.load(_metadataFilename,this as IManifestMetadataLoaderConsumer);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> RootMetadataChecker: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** RootMetadataChecker: " + param1);
      }
      
      public function handleManifestMetadataLoadComplete(param1:Boolean, param2:String, param3:IManifestReference) : void
      {
         log("handleManifestMetadataLoadComplete(): fileExists=" + param1 + ", posixFilePath=" + param2);
         _rootMetadataCheckerConsumer.handleRootMetadataCheckComplete(param1);
      }
      
      public function handleManifestMetadataLoadError(param1:String) : void
      {
         logError("handleManifestMetadataLoadError(): message=\"" + param1 + "\"");
         var _loc2_:String = Environment.posixToLocalPath(Environment.localApplicationPath + AssetLocation.ASSETS_DIRECTORY.name + "/" + AssetLocation.MANIFEST_METADATA_FILE_NAME.name);
         log("handleManifestMetadataLoadError(): going to delete metatdata file at: " + _loc2_);
         _fileOperator.deleteFile(_loc2_);
         _rootMetadataCheckerConsumer.handleRootMetadataCheckComplete(false);
      }
   }
}

