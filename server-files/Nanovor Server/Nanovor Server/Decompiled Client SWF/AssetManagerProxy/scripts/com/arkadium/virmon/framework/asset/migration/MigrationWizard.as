package com.arkadium.virmon.framework.asset.migration
{
   import com.arkadium.virmon.framework.asset.AssetLocation;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class MigrationWizard implements IMigrationWizard, IRootMetadataCheckerConsumer, IManifestConverterConsumer
   {
      
      private var _rootMetadataChecker:RootMetadataChecker;
      
      private var _handlers:Dictionary;
      
      private var _manifestConverter:ManifestConverter;
      
      private var _fileOperator:IFileOperator;
      
      public function MigrationWizard(param1:IFileOperator)
      {
         super();
         _fileOperator = param1;
         _handlers = new Dictionary();
         _handlers[IMigrationWizardCompleteHandler] = new Dictionary(true);
      }
      
      public function destroy() : void
      {
         var _loc1_:IMigrationWizardCompleteHandler = null;
         for each(_loc1_ in _handlers[IMigrationWizardCompleteHandler])
         {
            delete _handlers[IMigrationWizardCompleteHandler][_loc1_];
         }
         delete _handlers[IMigrationWizardCompleteHandler];
         _handlers = null;
         _rootMetadataChecker = null;
         _fileOperator = null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** MigrationWizard: " + param1);
      }
      
      public function handleRootMetadataCheckComplete(param1:Boolean) : void
      {
         log("handleRootMetadataCheckComplete(): validMetadataFound=" + param1);
         if(param1)
         {
            callCompleteHandlers();
            return;
         }
         _manifestConverter = new ManifestConverter(_fileOperator,AssetLocation.ASSETS_DIRECTORY.name,"");
         _manifestConverter.start(this as IManifestConverterConsumer);
      }
      
      public function start() : void
      {
         log("start()");
         _rootMetadataChecker = new RootMetadataChecker(_fileOperator,this as IRootMetadataCheckerConsumer);
         _rootMetadataChecker.start();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> MigrationWizard: " + param1);
      }
      
      public function handleManifestConverterComplete() : void
      {
         callCompleteHandlers();
      }
      
      private function callCompleteHandlers() : void
      {
         var _loc1_:IMigrationWizardCompleteHandler = null;
         for each(_loc1_ in _handlers[IMigrationWizardCompleteHandler])
         {
            _loc1_.migrationComplete();
            removeMigrationWizardCompleteHandler(_loc1_);
         }
      }
      
      public function addMigrationWizardCompleteHandler(param1:IMigrationWizardCompleteHandler) : void
      {
         _handlers[IMigrationWizardCompleteHandler][param1] = param1;
      }
      
      public function removeMigrationWizardCompleteHandler(param1:IMigrationWizardCompleteHandler) : void
      {
         delete _handlers[IMigrationWizardCompleteHandler][param1];
      }
   }
}

