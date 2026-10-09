package com.arkadium.virmon.framework.asset.migration
{
   import com.arkadium.virmon.framework.asset.AssetLocation;
   import com.arkadium.virmon.framework.asset.AssetManifestMetadata;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class ManifestConverter implements IHonorableManifestCheckerConsumer, IManifestConverterConsumer
   {
      
      private static const FILES_TO_DISCARD:Array = ["manifest.xml_minsetIncomplete","manifest.xml_incomplete","manifest-props.xml"];
      
      private static const FILES_TO_HONOR:Array = ["manifest.xml","manifest.xml_minsetComplete"];
      
      private var _manifestConverters:Array = [];
      
      private var _honorableFileName:String;
      
      private var _posixDirectoryPath:String;
      
      private var _honorableManifestChecker:HonorableManifestChecker;
      
      private var _consumer:IManifestConverterConsumer;
      
      private var _fileOperator:IFileOperator;
      
      private var _manifestMetadata:AssetManifestMetadata;
      
      private var _filesToCheck:Array;
      
      private var _name:String;
      
      public function ManifestConverter(param1:IFileOperator, param2:String, param3:String)
      {
         super();
         _fileOperator = param1;
         _posixDirectoryPath = param2;
         _name = param3;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ManifestConverter: " + param1);
      }
      
      private function loadNextManifest() : void
      {
         if(_manifestConverters.length == 0)
         {
            _manifestMetadata.writeToFile();
            _consumer.handleManifestConverterComplete();
            return;
         }
         var _loc1_:ManifestConverter = _manifestConverters.shift();
         _loc1_.start(this as IManifestConverterConsumer);
      }
      
      private function getPosixDirectoryPathForNestedManifest(param1:String) : String
      {
         return Utils.DOStoPOSIXpath(_posixDirectoryPath + "/" + param1.replace("\\manifest.xml",""));
      }
      
      public function handleManifestConverterComplete() : void
      {
         loadNextManifest();
      }
      
      public function handleHonorableManifestCheckComplete(param1:Boolean) : void
      {
         log("handleHonorableManifestCheckComplete(): validDataFound=" + param1);
         if(!param1)
         {
            _fileOperator.deleteFile(_honorableManifestChecker.localFilePath);
            _honorableManifestChecker = null;
            checkNextFile();
            return;
         }
         _manifestMetadata = parseManifestXML(_honorableManifestChecker.manifestXML);
         loadNextManifest();
      }
      
      public function start(param1:IManifestConverterConsumer) : void
      {
         var _loc2_:String = null;
         log("start() [" + _posixDirectoryPath + " :: " + _name + "]");
         _consumer = param1;
         for each(_loc2_ in FILES_TO_DISCARD)
         {
            _fileOperator.deleteFile(Environment.posixToLocalPath(Environment.localApplicationPath + _posixDirectoryPath + "/" + _loc2_));
         }
         _filesToCheck = FILES_TO_HONOR.concat();
         checkNextFile();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ManifestConverter: " + param1);
      }
      
      private function checkNextFile() : void
      {
         if(_filesToCheck.length == 0)
         {
            _consumer.handleManifestConverterComplete();
            return;
         }
         _honorableFileName = _filesToCheck.shift();
         _honorableManifestChecker = new HonorableManifestChecker(_fileOperator);
         _honorableManifestChecker.checkFile(_posixDirectoryPath + "/" + _honorableFileName,this as IHonorableManifestCheckerConsumer);
      }
      
      private function parseManifestXML(param1:XML) : AssetManifestMetadata
      {
         var _loc4_:XML = null;
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc2_:String = _posixDirectoryPath + "/" + AssetLocation.MANIFEST_METADATA_FILE_NAME.name;
         var _loc3_:AssetManifestMetadata = new AssetManifestMetadata(_fileOperator,_loc2_,new Dictionary(),new Dictionary(),new Date());
         for each(_loc4_ in param1.Assets.Group)
         {
            _loc6_ = String(_loc4_.@name).toLowerCase();
            for each(_loc7_ in _loc4_.Asset)
            {
               _loc3_.updateAsset(_loc6_,_loc7_.@Id,_loc7_.@CRC);
            }
         }
         for each(_loc5_ in param1..Manifest)
         {
            _manifestConverters[_manifestConverters.length] = new ManifestConverter(_fileOperator,getPosixDirectoryPathForNestedManifest(_loc5_.@Filename),_loc5_.@name);
         }
         return _loc3_;
      }
   }
}

