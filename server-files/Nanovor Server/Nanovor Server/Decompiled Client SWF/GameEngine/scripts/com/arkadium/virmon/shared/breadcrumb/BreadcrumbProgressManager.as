package com.arkadium.virmon.shared.breadcrumb
{
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BreadcrumbProgressManager implements IBreadcrumbProgressManager
   {
      
      private var _storedSettingKey:String;
      
      private var _progressBitField:int;
      
      private var _storedSettingManager:StoredSettingManager;
      
      public function BreadcrumbProgressManager(param1:StoredSettingManager, param2:String)
      {
         super();
         _storedSettingManager = param1;
         _storedSettingKey = StoredSetting.BREADCRUMB_PROGRESS + "_" + param2;
         if(_storedSettingManager.getSetting(StoredSetting.BREADCRUMB_COUNT) != null)
         {
            _storedSettingManager.deleteSettingAndSave(StoredSetting.BREADCRUMB_COUNT);
            setAllAsCompleteBeforeSpecificBreadcrumb(BreadcrumbType.NEWS);
         }
         _progressBitField = _storedSettingManager.getSettingOrSetDefault(_storedSettingKey,0);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BreadcrumbProgressManager: " + param1);
      }
      
      private function setAllAsCompleteBeforeSpecificBreadcrumb(param1:BreadcrumbType) : void
      {
         var _loc2_:BreadcrumbType = null;
         log("setAllAsCompleteBeforeSpecificBreadcrumb(): breackcrumpType.bitKey=" + param1.bitKey + " (" + param1.url + ")");
         for each(_loc2_ in BreadcrumbType.breadcrumbTypes)
         {
            if(_loc2_ != param1)
            {
               _progressBitField |= _loc2_.bitKey;
            }
         }
         _storedSettingManager.storeSettingAndSave(_storedSettingKey,_progressBitField);
      }
      
      public function getNextBreadcrumbType() : BreadcrumbType
      {
         var _loc1_:BreadcrumbType = null;
         for each(_loc1_ in BreadcrumbType.breadcrumbTypes)
         {
            if(!getIsBreadcrumbComplete(_loc1_))
            {
               return _loc1_;
            }
         }
         return BreadcrumbType.breadcrumbTypes[BreadcrumbType.breadcrumbTypes.length - 1] as BreadcrumbType;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BreadcrumbProgressManager: " + param1);
      }
      
      public function setBreadcrumbAsComplete(param1:BreadcrumbType) : void
      {
         if(param1 == null)
         {
            logError("setBreadcrumbAsComplete(): called with null breadcrumbType!");
            return;
         }
         if(getIsBreadcrumbComplete(param1))
         {
            return;
         }
         _progressBitField |= param1.bitKey;
         _storedSettingManager.storeSettingAndSave(_storedSettingKey,_progressBitField);
      }
      
      public function getIsBreadcrumbComplete(param1:BreadcrumbType) : Boolean
      {
         return Boolean((_progressBitField & param1.bitKey) == param1.bitKey);
      }
   }
}

