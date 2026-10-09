package com.arkadium.virmon.shared.data
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.WebClientManager;
   import com.arkadium.virmon.common.MainConfigManager;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.arkadium.virmon.framework.IBuddyManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.asset.AssetManager;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.shared.breadcrumb.IBreadcrumbProgressManager;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.wrapper.IBuyNanocashUIManager;
   import com.arkadium.virmon.wrapper.IDialogManager;
   import flash.utils.getDefinitionByName;
   
   public class Managers
   {
      
      private static var _assetManager:AssetManager;
      
      private static var _analyticsManager:IAnalyticsManager;
      
      private static var _assetRetrieverManager:IAssetRetrieverManager;
      
      private static var _buddyRPManager:IBuddyRPManager;
      
      private static var _friendManager:*;
      
      private static var _permissionsManager:PermissionsManager;
      
      private static var _homeBreadcrumbUIManager:IHomeBreadcrumbUIManager;
      
      private static var _stateManager:IStateManager;
      
      private static var _mdmManager:IMDMManager;
      
      private static var _breadcrumbProgressManager:IBreadcrumbProgressManager;
      
      private static var _widgetManager:IWidgetManager;
      
      private static var _webClientManager:WebClientManager;
      
      private static var _dialogManager:IDialogManager;
      
      private static var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private static var _profileManager:*;
      
      private static var _buddyManager:IBuddyManager;
      
      private static var _storedSettingsManager:StoredSettingManager;
      
      private static var _buyNanocashUIManager:IBuyNanocashUIManager;
      
      private static var _soundManager:ISoundManager;
      
      public static const BATTLE_CONTROLLER:String = "BattleController";
      
      private static var _variableManagers:Array = [];
      
      public function Managers()
      {
         super();
         throw new Error("Managers class can not be instantiated.  Static functionality only.");
      }
      
      public static function set breadcrumbProgressManager(param1:IBreadcrumbProgressManager) : void
      {
         _breadcrumbProgressManager = param1;
      }
      
      public static function get buddyManager() : IBuddyManager
      {
         return _buddyManager;
      }
      
      public static function set profileManager(param1:*) : void
      {
         _profileManager = param1;
      }
      
      public static function get permissionsManager() : IPermissionsManager
      {
         return PermissionsManager.getInstance();
      }
      
      public static function set dialogManager(param1:IDialogManager) : void
      {
         _dialogManager = param1;
      }
      
      public static function set analyticsManager(param1:IAnalyticsManager) : void
      {
         _analyticsManager = param1;
      }
      
      public static function get buddyRPManager() : IBuddyRPManager
      {
         return _buddyRPManager;
      }
      
      public static function set widgetManager(param1:IWidgetManager) : void
      {
         _widgetManager = param1;
      }
      
      public static function get buyNanocashUIManager() : IBuyNanocashUIManager
      {
         return _buyNanocashUIManager;
      }
      
      public static function set buddyManager(param1:IBuddyManager) : void
      {
         _buddyManager = param1;
      }
      
      public static function get mdmManager() : IMDMManager
      {
         return _mdmManager;
      }
      
      public static function set buyNanocashUIManager(param1:IBuyNanocashUIManager) : void
      {
         _buyNanocashUIManager = param1;
      }
      
      public static function set buddyRPManager(param1:IBuddyRPManager) : void
      {
         _buddyRPManager = param1;
      }
      
      public static function get assetManager() : AssetManager
      {
         return AssetManager.getInstance();
      }
      
      public static function get soundManager() : ISoundManager
      {
         return _soundManager;
      }
      
      public static function get serviceRequestBrokerManager() : IServiceRequestBrokerManager
      {
         return _serviceRequestBrokerManager;
      }
      
      public static function get assetRetrieverManager() : IAssetRetrieverManager
      {
         return _assetRetrieverManager;
      }
      
      public static function set mdmManager(param1:IMDMManager) : void
      {
         _mdmManager = param1;
      }
      
      public static function set serviceRequestBrokerManager(param1:IServiceRequestBrokerManager) : void
      {
         _serviceRequestBrokerManager = param1;
      }
      
      public static function set assetManager(param1:AssetManager) : void
      {
         _assetManager = param1;
      }
      
      public static function set soundManager(param1:ISoundManager) : void
      {
         _soundManager = param1;
      }
      
      public static function set stateManager(param1:IStateManager) : void
      {
         _stateManager = param1;
      }
      
      public static function unsetManager(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < _variableManagers.length)
         {
            if(_variableManagers[_loc2_].managerName == param1)
            {
               _variableManagers.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public static function get dialogManager() : IDialogManager
      {
         return _dialogManager;
      }
      
      public static function get friendManager() : *
      {
         return _friendManager;
      }
      
      public static function get widgetManager() : IWidgetManager
      {
         return _widgetManager;
      }
      
      public static function get profileManager() : *
      {
         return _profileManager;
      }
      
      public static function set storedSettingsManager(param1:*) : void
      {
         _storedSettingsManager = param1;
      }
      
      public static function get mainConfigManager() : MainConfigManager
      {
         return MainConfigManager.getInstance();
      }
      
      public static function set webClientManager(param1:WebClientManager) : void
      {
         _webClientManager = param1;
      }
      
      public static function set assetRetrieverManager(param1:IAssetRetrieverManager) : void
      {
         _assetRetrieverManager = param1;
      }
      
      public static function set friendManager(param1:*) : void
      {
         _friendManager = param1;
      }
      
      public static function get storedSettingsManager() : StoredSettingManager
      {
         return StoredSettingManager.getInstance();
      }
      
      public static function get analyticsManager() : IAnalyticsManager
      {
         return _analyticsManager;
      }
      
      public static function get breadcrumbProgressManager() : IBreadcrumbProgressManager
      {
         return _breadcrumbProgressManager;
      }
      
      public static function setManager(param1:String, param2:*) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < _variableManagers.length)
         {
            if(_variableManagers[_loc3_].managerName == param1)
            {
               return;
            }
            _loc3_++;
         }
         _variableManagers.push({
            "managerName":param1,
            "managerReference":param2
         });
      }
      
      public static function get webClientManager() : WebClientManager
      {
         return WebClientManager.getInstance();
      }
      
      public static function get stateManager() : IStateManager
      {
         return _stateManager;
      }
      
      public static function set homeBreadcrumbUIManager(param1:IHomeBreadcrumbUIManager) : void
      {
         _homeBreadcrumbUIManager = param1;
      }
      
      public static function getManager(param1:String) : *
      {
         var manager:* = undefined;
         var managerName:String = param1;
         var i:uint = 0;
         while(i < _variableManagers.length)
         {
            if(_variableManagers[i].managerName == managerName)
            {
               return _variableManagers[i].managerReference;
            }
            i++;
         }
         try
         {
            manager = getDefinitionByName(managerName);
            if(manager.getInstance is Function)
            {
               return manager.getInstance();
            }
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      public static function get homeBreadcrumbUIManager() : IHomeBreadcrumbUIManager
      {
         return _homeBreadcrumbUIManager;
      }
   }
}

