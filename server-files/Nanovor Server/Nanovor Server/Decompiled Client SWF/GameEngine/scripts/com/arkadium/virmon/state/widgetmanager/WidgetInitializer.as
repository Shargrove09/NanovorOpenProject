package com.arkadium.virmon.state.widgetmanager
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.asset.retriever.IAvatarAssetRetriever;
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.shared.breadcrumb.IBreadcrumbProgressManager;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.wrapper.statepackagestatusupdater.IStatePackageStatusUpdater;
   import flash.display.Sprite;
   
   public class WidgetInitializer implements IWidgetInitializer
   {
      
      private var _avatarAssetRetriever:IAvatarAssetRetriever;
      
      private var _statePackageStatusUpdater:IStatePackageStatusUpdater;
      
      private var _breadcrumbProgressManager:IBreadcrumbProgressManager;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _userProfile:IUserProfile;
      
      private var _battleGameService:IBattleGameService;
      
      private var _topMostPopupLayer:Sprite;
      
      private var _homeBreadcrumbUIManager:IHomeBreadcrumbUIManager;
      
      private var _userGameService:IUserGameService;
      
      private var _stateManager:IStateManager;
      
      public function WidgetInitializer(param1:IUserGameService, param2:IBattleGameService, param3:IUserProfile, param4:IStateManager, param5:IAnalyticsManager, param6:IHomeBreadcrumbUIManager, param7:IBreadcrumbProgressManager, param8:IAvatarAssetRetriever, param9:IStatePackageStatusUpdater, param10:Sprite)
      {
         super();
         _userGameService = param1;
         _battleGameService = param2;
         _userProfile = param3;
         _stateManager = param4;
         _analyticsManager = param5;
         _homeBreadcrumbUIManager = param6;
         _breadcrumbProgressManager = param7;
         _statePackageStatusUpdater = param9;
         _avatarAssetRetriever = param8;
         _topMostPopupLayer = param10;
      }
      
      public function initializeWidget(param1:WidgetType, param2:IWidget) : void
      {
         var _loc3_:Object = new Object();
         switch(param1)
         {
            case WidgetType.WIDGET_HEADER:
               _loc3_.userGameService = _userGameService;
               _loc3_.battleGameService = _battleGameService;
               _loc3_.userProfile = _userProfile;
               _loc3_.stateManager = _stateManager;
               _loc3_.analyticsManager = _analyticsManager;
               _loc3_.homeBreadcrumbUIManager = _homeBreadcrumbUIManager;
               _loc3_.breadcrumbProgressManager = _breadcrumbProgressManager;
               _loc3_.statePackageUpdater = _statePackageStatusUpdater;
               _loc3_.avatarAssetRetriever = _avatarAssetRetriever;
               break;
            case WidgetType.WIDGET_AUTO_BATTLE:
               _loc3_.popupContainer = _topMostPopupLayer;
         }
         param2.init(_loc3_);
      }
   }
}

