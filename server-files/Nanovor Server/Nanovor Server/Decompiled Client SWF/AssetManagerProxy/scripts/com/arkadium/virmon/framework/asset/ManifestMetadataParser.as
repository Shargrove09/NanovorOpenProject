package com.arkadium.virmon.framework.asset
{
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class ManifestMetadataParser implements IManifestMetadataParser
   {
      
      private var _posixFilePath:String;
      
      private var _fileOperator:IFileOperator;
      
      public function ManifestMetadataParser(param1:IFileOperator, param2:String)
      {
         super();
         _fileOperator = param1;
         _posixFilePath = param2;
      }
      
      public function parseManifestMetadata(param1:IManifestMetadataParserConsumer, param2:XML, param3:IManifestReference) : void
      {
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         if(null == param2 || param2.toXMLString() == "")
         {
            param1.handleManifestMetadataParseComplete(new AssetManifestMetadata(_fileOperator,_posixFilePath,new Dictionary(),new Dictionary(),new Date()),param3);
            return;
         }
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:Dictionary = new Dictionary();
         for each(_loc6_ in param2..Group)
         {
            _loc4_[String(_loc6_.@name).toLowerCase()] = new Dictionary();
            for each(_loc8_ in _loc6_.Asset)
            {
               _loc4_[String(_loc6_.@name).toLowerCase()][String(_loc8_.@Id)] = _loc8_.@CRC;
            }
         }
         for each(_loc7_ in param2..Manifest)
         {
            _loc5_[String(_loc7_.@name)] = _loc7_.@CRC;
         }
         param1.handleManifestMetadataParseComplete(new AssetManifestMetadata(_fileOperator,_posixFilePath,_loc4_,_loc5_,new Date(param2.@lastUpdate)),param3);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<ManifestMetadataParser>> " + param1);
      }
   }
}

