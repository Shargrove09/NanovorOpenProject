package com.arkadium.virmon.nanomall
{
   import caurina.transitions.*;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.common.UserProfileEvent;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.IBoosterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.utils.*;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.wrapper.IBuyNanocashUIManager;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.system.System;
   
   public class NanoMall extends AbstractState implements INanomallState
   {
      
      private var curCollectionItemDrag:Sprite;
      
      private const COLLECTIONPANEL_OUT_X:int = 1058;
      
      private const VIEW_DROPZONE_Y:int = 695;
      
      private const VIEW_DROPZONE_X:int = 837;
      
      private const NEWS_OUT_X:int = 1041;
      
      private var xUserDataResponse:XML;
      
      private const BUYPANEL_IN_X:int = -22;
      
      private var curCollectionItemOriginal:CollectionPanelItem;
      
      private var oCurSKUSelect:IBoosterItemData;
      
      private const NAVIGATEPANEL_X:int = 50;
      
      public var mcClips:Clips;
      
      private const NANOVIEWER_Y:int = 550;
      
      private const NAVIGATEPANEL_Y:int = 610;
      
      private var curBoosterItemDrag:BoosterItemDrag;
      
      private const NSF_MESSAGE_SUPPORT:String = "You don\'t have enough NANOCASH to make this purchase.\nClick OK to get more NANOCASH, or click Cancel to continue.";
      
      private var isChipInClip:Boolean = false;
      
      private const COLLECTIONPANEL_IN_X:int = 454;
      
      private var _userGameService:IUserGameService;
      
      public var mcBG:MovieClip;
      
      private var _boosterAssetRetriever:IBoosterAssetRetriever;
      
      private const BUYCONFIRM_IN_X:int = 553;
      
      private var bCollectionPanel:Boolean = false;
      
      private var iUserBalance:int = 0;
      
      public var mcTruck:LaserTruck;
      
      private var _buyNanocashUIManager:IBuyNanocashUIManager;
      
      private var _emManager:IEMManager;
      
      private const NSF_MESSAGE_MAIN:String = "Unable to make purchase";
      
      private var _stageTarget:Stage;
      
      private var _commonDialogBox:CommonDialogBox;
      
      private var boosterItemDrag1:BoosterItemDrag;
      
      private var boosterItemDrag2:BoosterItemDrag;
      
      public var mcMainButton:MovieClip;
      
      private const BUYCONFIRM_OUT_X:int = 373;
      
      private var _virmonManager:IVirmonManager;
      
      private var iCurBoosterSelectItem:int = 0;
      
      public var mcNews:News;
      
      public var mcBottomFrame:BottomFrame;
      
      public var mcBuyConfirm:BuyConfirm;
      
      private const ITEM_WIDTH:int = 100;
      
      private const NANOVIEWER_IN_X:int = 580;
      
      private var mallConnector:NanoMallConnector;
      
      public var mcCollectionPanel:CollectionPanel;
      
      public var mcSpinner:MovieClip;
      
      private const NEWS_IN_X:int = 621;
      
      private const BUY_DROPZONE_X:int = 510;
      
      private const BUY_DROPZONE_Y:int = 357;
      
      private var xBuySKUResponse:XML;
      
      private var _userProfile:IUserProfile;
      
      private var _stateManager:IStateManager;
      
      private var bIsBuyConfirm:Boolean = false;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _widgetManager:IWidgetManager;
      
      private var _emAssetRetriever:IEMAssetRetriever;
      
      public var mcTopFrame:TopFrame;
      
      private const ITEM_HEIGHT:int = 100;
      
      public var mcBuyPanel:BuyPanel;
      
      private const NANOVIEWER_OUT_X:int = 1100;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var xSKUResponse:XML;
      
      private var nanoViewer:NanoViewer;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      public function NanoMall()
      {
         super();
         mcNews.visible = false;
         mcNews.mouseChildren = false;
         mcNews.mouseEnabled = false;
         stateName = StateType.NANOMALL.name;
         nanoViewer = new NanoViewer();
         addChild(nanoViewer);
         nanoViewer.setNanovorName("SELECT ITEM");
         nanoViewer.x = NANOVIEWER_OUT_X;
         nanoViewer.y = NANOVIEWER_Y;
         boosterItemDrag1 = new BoosterItemDrag();
         addChild(boosterItemDrag1);
         boosterItemDrag2 = new BoosterItemDrag();
         addChild(boosterItemDrag2);
         curBoosterItemDrag = boosterItemDrag1;
         mcBuyPanel.mcBG.mouseEnabled = false;
         mcTruck.visible = false;
         if(null != mcBuyConfirm.parent)
         {
            mcBuyConfirm.parent.removeChild(mcBuyConfirm);
         }
         mcClips.visible = false;
         mcClips.x = BUY_DROPZONE_X;
         mcClips.y = BUY_DROPZONE_Y;
         mcSpinner.mouseEnabled = false;
         mcMainButton.alpha = 0;
         mcMainButton.buttonMode = true;
         mcMainButton.addEventListener(MouseEvent.CLICK,onMainButtonClick,false,0,true);
         EventManager.getInstance().addEventListener("NANOCASH_BALANCE_UPDATED",updateNanocashBalance,false,0,true);
         this.addEventListener(Event.ADDED_TO_STAGE,onStateAddedToStage);
      }
      
      private function onBackToWaveListClick(param1:Event) : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent("CHANGE_NAVIGATION_BLUE_BTN",{
            "title":"HOME",
            "func":onBackButtonClick
         }));
         if(bIsBuyConfirm)
         {
            hideBuyConfirm();
            curBoosterItemDrag.hideItems();
            mcBuyPanel.showBoosterSelectItem(iCurBoosterSelectItem);
            iCurBoosterSelectItem = 0;
            isChipInClip = false;
         }
         if(bCollectionPanel)
         {
            mcCollectionPanel.reset();
            hideCollectionPanel();
            hideNanoViewer();
         }
         mcClips.visible = false;
         mcBuyPanel.closePortal();
         mcBuyPanel.closeBoosterSelect();
         mcBuyPanel.hideBoosterSelectBackBtn();
         mcTruck.visible = false;
      }
      
      private function updateUserBalance() : void
      {
         mallConnector.addEventListener("USER_DATA_SUCCESS",onGetUpdatedUserDataSuccess,false,0,true);
         mallConnector.getUserData();
      }
      
      private function onProfileRefreshed(param1:Event) : void
      {
      }
      
      private function onMainButtonClick(param1:MouseEvent) : void
      {
         _buyNanocashUIManager.showBuyNanocash();
      }
      
      private function onBackButtonClick(param1:MouseEvent) : void
      {
         close();
      }
      
      private function onStateAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,onStateAddedToStage);
         _stageTarget = this.stage;
      }
      
      private function onGetUserDataError(param1:Event) : void
      {
         mallConnector.removeEventListener("USER_DATA_SUCCESS",onGetUserDataSuccess);
         mallConnector.removeEventListener("USER_DATA_ERROR",onGetUserDataError);
         logError("GET USER DATA FAILED");
         EventManager.getInstance().dispatchEvent(new ProjectEvent("HIDE_NANOMALL"));
      }
      
      override public function onUnsetState() : void
      {
         if(null != _stageTarget)
         {
            _stageTarget.removeEventListener(MouseEvent.MOUSE_UP,onCollectionPanelItemDragUp);
         }
      }
      
      private function onBuySKUError(param1:Event) : void
      {
         mallConnector.removeEventListener("BUY_SKU_SUCCESS",onBuySKUSuccess);
         mallConnector.removeEventListener("BUY_SKU_ERROR",onBuySKUError);
         logError("BUY SKU FAILED");
         Tweener.removeTweens(curBoosterItemDrag);
         onBuyCancel(null);
         mcBuyPanel.enableBoosterSelectBackBtn();
         mcBuyPanel.enableBoosterSelectItems();
         onTruckLightningZap(null);
         _analyticsManager.trackAction(Action.NANOMALL_SKU_PURCHASE_ERROR);
         _commonDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Error Buying Booster","There was a problem buying this booster pack. Please try your purchase again.",0,onCDBClick,onCDBClick);
      }
      
      private function hideBuyConfirm() : void
      {
         bIsBuyConfirm = false;
         mcBuyConfirm.x = BUYCONFIRM_OUT_X;
         if(null != mcBuyConfirm.parent)
         {
            mcBuyConfirm.parent.removeChild(mcBuyConfirm);
         }
      }
      
      private function showCollectionPanel() : void
      {
         bCollectionPanel = true;
         Tweener.addTween(mcCollectionPanel,{
            "x":COLLECTIONPANEL_IN_X,
            "time":1,
            "transition":"easeOutQuint",
            "onComplete":mcCollectionPanel.buildCollection
         });
         mcCollectionPanel.openTabs();
      }
      
      private function isOverViewDropZone() : Boolean
      {
         var _loc1_:Point = new Point(VIEW_DROPZONE_X,VIEW_DROPZONE_Y);
         return curCollectionItemDrag.hitTestPoint(_loc1_.x,_loc1_.y,true);
      }
      
      override public function onSetState() : void
      {
         log("onSetState(): System.totalMemory: " + System.totalMemory);
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name).setMode(WidgetType.MODE_HOME);
         }
         if(null != _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name))
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name).setMode(WidgetType.MODE_HIDDEN);
         }
      }
      
      private function onGetUserDataSuccess(param1:CustomEvent) : void
      {
         mallConnector.removeEventListener("USER_DATA_SUCCESS",onGetUserDataSuccess);
         mallConnector.removeEventListener("USER_DATA_ERROR",onGetUserDataError);
         xUserDataResponse = XML(param1.data);
         iUserBalance = int(xUserDataResponse.child("token-balance")[0]);
         mcBuyPanel.init(_analyticsManager,_boosterAssetRetriever,xSKUResponse);
         reveal();
      }
      
      private function canAfford(param1:int) : Boolean
      {
         return iUserBalance >= param1;
      }
      
      private function onWaveListBuyBtnClick(param1:BoosterItemEvent) : void
      {
         oCurSKUSelect = param1.boosterItemData;
         boosterItemDrag1.init(oCurSKUSelect,_boosterAssetRetriever);
         boosterItemDrag2.init(oCurSKUSelect,_boosterAssetRetriever);
         mcBuyPanel.initBoosterSelect(oCurSKUSelect);
         mcBuyPanel.openBoosterSelect();
         mcBuyPanel.addEventListener("PORTAL_OPENED",onPortalOpened,false,0,true);
         mcBuyPanel.openPortal(0.5);
         mcBuyPanel.showBoosterSelectBackBtn();
         mcTruck.visible = true;
         mcTruck.gotoAndPlay("enter");
      }
      
      private function showBuyConfirm() : void
      {
         bIsBuyConfirm = true;
         mcBuyConfirm.updatePrice(oCurSKUSelect.price);
         this.addChild(mcBuyConfirm);
         Tweener.addTween(mcBuyConfirm,{
            "x":BUYCONFIRM_IN_X,
            "time":0.5,
            "transition":"easeOutBack"
         });
         _analyticsManager.trackAction(Action.NANOMALL_SKU_PURCHASE_SELECT);
      }
      
      private function hideCollectionPanel() : void
      {
         bCollectionPanel = false;
         Tweener.addTween(mcCollectionPanel,{
            "x":COLLECTIONPANEL_OUT_X,
            "time":1,
            "transition":"easeOutQuint"
         });
         mcCollectionPanel.closeTabs();
      }
      
      private function onPortalOpened(param1:Event) : void
      {
         mcBuyPanel.removeEventListener("PORTAL_OPENED",onPortalOpened);
         mcClips.visible = true;
         mcClips.cock();
      }
      
      private function onCollectionPanelItemDragUp(param1:MouseEvent) : void
      {
         curCollectionItemDrag.stopDrag();
         if(null != _stageTarget)
         {
            _stageTarget.removeEventListener(MouseEvent.MOUSE_UP,onCollectionPanelItemDragUp);
         }
         if(isOverViewDropZone())
         {
            curCollectionItemDrag.x = VIEW_DROPZONE_X - ITEM_WIDTH / 2;
            curCollectionItemDrag.y = VIEW_DROPZONE_Y - ITEM_HEIGHT / 2;
            if(curCollectionItemOriginal.chipType == "virmon")
            {
               nanoViewer.showVirmon(curCollectionItemOriginal.virmonData);
            }
            else if(curCollectionItemOriginal.chipType == "em")
            {
               nanoViewer.showEM(curCollectionItemOriginal.emMasterData);
            }
            _analyticsManager.trackView(View.NANOMALL_NEW_ASSET_INSPECTED);
         }
         removeChild(curCollectionItemDrag);
      }
      
      private function onDialogOpened(param1:Event) : void
      {
         EventManager.getInstance().removeEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened);
         curBoosterItemDrag.removeEventListener("BOOSTER_DRAGITEM_UP",onBoosterItemDragUp);
         curBoosterItemDrag.removeEventListener("BOOSTER_DRAGITEM_DOWN",onBoosterItemDragDown);
         if(Boolean(curBoosterItemDrag))
         {
            curBoosterItemDrag.stopDrag();
            curBoosterItemDrag.hideItems();
            mcBuyPanel.showBoosterSelectItem(iCurBoosterSelectItem);
            iCurBoosterSelectItem = 0;
         }
         if(Boolean(curCollectionItemDrag))
         {
            removeChild(curCollectionItemDrag);
            _stageTarget.removeEventListener(MouseEvent.MOUSE_UP,onCollectionPanelItemDragUp);
         }
      }
      
      private function onGetSKUsError(param1:Event) : void
      {
         logError("GET SKU LIST FAILED");
         EventManager.getInstance().dispatchEvent(new ProjectEvent("HIDE_NANOMALL"));
      }
      
      private function onBoosterItemDragUp(param1:Event) : void
      {
         EventManager.getInstance().removeEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened);
         if(isOverBuyDropZone())
         {
            curBoosterItemDrag.x = BUY_DROPZONE_X - curBoosterItemDrag.width / 2;
            curBoosterItemDrag.y = BUY_DROPZONE_Y - curBoosterItemDrag.height / 2;
            showBuyConfirm();
            mcClips.lock();
            clipsAboveChip(true);
            isChipInClip = true;
            if(bCollectionPanel)
            {
               mcCollectionPanel.reset();
               hideCollectionPanel();
               hideNanoViewer();
            }
         }
         else
         {
            curBoosterItemDrag.hideItems();
            mcBuyPanel.showBoosterSelectItem(iCurBoosterSelectItem);
            iCurBoosterSelectItem = 0;
         }
      }
      
      private function onBoosterSelectItemDown(param1:CustomEvent) : void
      {
         if(isChipInClip)
         {
            curBoosterItemDrag.hideItems();
            mcBuyPanel.showBoosterSelectItem(iCurBoosterSelectItem);
            mcClips.reset();
            if(curBoosterItemDrag == boosterItemDrag1)
            {
               curBoosterItemDrag = boosterItemDrag2;
            }
            else
            {
               curBoosterItemDrag = boosterItemDrag1;
            }
            isChipInClip = false;
         }
         iCurBoosterSelectItem = int(param1.data.pos);
         mcBuyPanel.hideBoosterSelectItem(iCurBoosterSelectItem);
         curBoosterItemDrag.alpha = 1;
         curBoosterItemDrag.showItem(param1.data.pos);
         curBoosterItemDrag.x = this.mouseX - param1.data.mouseX;
         curBoosterItemDrag.y = this.mouseY - param1.data.mouseY;
         clipsAboveChip(false);
         hideBuyConfirm();
         curBoosterItemDrag.startDrag();
         curBoosterItemDrag.addEventListener("BOOSTER_DRAGITEM_UP",onBoosterItemDragUp);
         curBoosterItemDrag.addEventListener("BOOSTER_DRAGITEM_DOWN",onBoosterItemDragDown);
         EventManager.getInstance().addEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened,false,0,true);
      }
      
      private function onKeepShopping(param1:Event) : void
      {
         mcCollectionPanel.reset();
         hideCollectionPanel();
         hideNanoViewer();
      }
      
      private function handleNSFDialogClickOK(param1:Object) : void
      {
         if(null != _commonDialogBox)
         {
            _commonDialogBox.kill();
         }
         _buyNanocashUIManager.showBuyNanocash();
      }
      
      private function onBuyConfirm(param1:Event) : void
      {
         var e:Event = param1;
         if(canAfford(int(oCurSKUSelect.price)))
         {
            _analyticsManager.trackAction(Action.NANOMALL_SKU_PURCHASE_SUBMIT);
            mallConnector.addEventListener("BUY_SKU_SUCCESS",onBuySKUSuccess,false,0,true);
            mallConnector.addEventListener("BUY_SKU_ERROR",onBuySKUError,false,0,true);
            mallConnector.buySKU(oCurSKUSelect);
            mcClips.zap();
            Tweener.addTween(curBoosterItemDrag,{
               "alpha":0,
               "time":0.5,
               "delay":0.25,
               "transition":"easeOutQuint",
               "onComplete":function():*
               {
                  curBoosterItemDrag.alpha = 1;
                  curBoosterItemDrag.hideItems();
               }
            });
            mcBuyPanel.disableBoosterSelectBackBtn();
            mcBuyPanel.disableBoosterSelectItems();
            EventManager.getInstance().dispatchEvent(new ProjectEvent("SHOW_BLOCKER"));
            _analyticsManager.trackView(View.NANOMALL_SKU_PURCHASED);
         }
         else
         {
            onBuyCancel(null);
            _commonDialogBox = CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_ALERT,NSF_MESSAGE_MAIN,NSF_MESSAGE_SUPPORT,0,handleNSFDialogClickOK,handleNSFDialogClickCancel);
         }
         hideBuyConfirm();
      }
      
      private function onBoosterItemDragDown(param1:Event) : void
      {
         isChipInClip = false;
         curBoosterItemDrag.startDrag();
         mcClips.reset();
         clipsAboveChip(false);
         hideBuyConfirm();
         EventManager.getInstance().addEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened,false,0,true);
      }
      
      private function onBuySKUSuccess(param1:CustomEvent) : void
      {
         log("BUY SKU SUCCESS");
         mallConnector.removeEventListener("BUY_SKU_SUCCESS",onBuySKUSuccess);
         mallConnector.removeEventListener("BUY_SKU_ERROR",onBuySKUError);
         if(mcBuyPanel.areBoosterItemsExhausted())
         {
            mcBuyPanel.replenishBoosterItems();
         }
         iCurBoosterSelectItem = 0;
         isChipInClip = false;
         mcBuyPanel.altStrobeLights();
         mcCollectionPanel.disableUI();
         xBuySKUResponse = XML(param1.data);
         DataManager.getInstance().getVirmonManager().addEventListener(FrameWorkEvent.DM_DATA_UPDATED,onDMDataUpdated,false,0,true);
         DataManager.getInstance().refreshData();
         EventManager.getInstance().dispatchEvent(new Event("NANOCASH_BALANCE_CHANGE"));
         _userGameService.updateNanovorCount();
         _analyticsManager.trackAction(Action.NANOMALL_SKU_PURCHASE_SUCCESS);
      }
      
      private function onBuyCancel(param1:Event) : void
      {
         hideBuyConfirm();
         curBoosterItemDrag.hideItems();
         mcClips.reset();
         mcBuyPanel.showBoosterSelectItem(iCurBoosterSelectItem);
         iCurBoosterSelectItem = 0;
         isChipInClip = false;
         if(param1 != null)
         {
            _analyticsManager.trackAction(Action.NANOMALL_SKU_PURCHASE_CANCEL);
         }
      }
      
      private function handleNSFDialogClickCancel(param1:Object) : void
      {
         if(null != _commonDialogBox)
         {
            _commonDialogBox.kill();
         }
      }
      
      private function showNanoViewer(param1:Number = 0) : void
      {
         Tweener.addTween(nanoViewer,{
            "x":NANOVIEWER_IN_X,
            "time":1,
            "delay":param1,
            "transition":"easeOutQuint"
         });
      }
      
      private function onGetSKUsSuccess(param1:CustomEvent) : void
      {
         xSKUResponse = XML(param1.data);
         mallConnector.addEventListener("USER_DATA_SUCCESS",onGetUserDataSuccess,false,0,true);
         mallConnector.addEventListener("USER_DATA_ERROR",onGetUserDataError,false,0,true);
         mallConnector.getUserData();
      }
      
      private function setEventListeners() : void
      {
         mcBuyPanel.addEventListener(BoosterItemEvent.WAVELIST_BUYBTN_CLICK,onWaveListBuyBtnClick,false,0,true);
         mcBuyPanel.addEventListener("BACK_TO_WAVELIST",onBackToWaveListClick,false,0,true);
         mcBuyPanel.addEventListener("BOOSTERSELECTITEM_DOWN",onBoosterSelectItemDown,false,0,true);
         mcBuyConfirm.addEventListener("BUY_CONFIRM",onBuyConfirm,false,0,true);
         mcBuyConfirm.addEventListener("BUY_CANCEL",onBuyCancel,false,0,true);
         mcCollectionPanel.addEventListener("KEEP_SHOPPING",onBackToWaveListClick,false,0,true);
         mcCollectionPanel.addEventListener("VIEW_COLLECTION",onViewCollection,false,0,true);
         mcCollectionPanel.addEventListener(CollectionPanelItem.ITEM_DOWN,onCollectionPanelItemDown,false,0,true);
      }
      
      public function initialize(param1:IUserProfile, param2:IAnalyticsManager, param3:IBuyNanocashUIManager, param4:IStateManager, param5:IWidgetManager, param6:IServiceRequestBrokerManager, param7:IBoosterAssetRetriever, param8:IUserGameService, param9:IVirmonManager, param10:ICharacterAssetRetriever, param11:IEMManager, param12:IEMAssetRetriever) : void
      {
         if(isInitialized)
         {
            return;
         }
         isInitialized = true;
         _userProfile = param1;
         _analyticsManager = param2;
         _buyNanocashUIManager = param3;
         _stateManager = param4;
         _widgetManager = param5;
         _serviceRequestBrokerManager = param6;
         _boosterAssetRetriever = param7;
         _userGameService = param8;
         _virmonManager = param9;
         _characterAssetRetriever = param10;
         _emManager = param11;
         _emAssetRetriever = param12;
         _userProfile.addEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onProfileRefreshed,false,0,true);
         mallConnector = new NanoMallConnector(_serviceRequestBrokerManager.bankURL,_serviceRequestBrokerManager.bankURLRead,_serviceRequestBrokerManager.getLoginToken(),_serviceRequestBrokerManager.getAccountID());
         mallConnector.addEventListener("SKU_SUCCESS",onGetSKUsSuccess,false,0,true);
         mallConnector.addEventListener("SKU_ERROR",onGetSKUsError,false,0,true);
         mallConnector.getSKUs();
         _analyticsManager.trackView(View.NANOMALL_LANDING);
         log("NANOMALL state is initialized");
      }
      
      private function hideNanoViewer(param1:Number = 0) : void
      {
         Tweener.addTween(nanoViewer,{
            "x":NANOVIEWER_OUT_X,
            "time":1,
            "delay":param1,
            "transition":"easeOutQuint",
            "onComplete":nanoViewer.reset
         });
      }
      
      private function onGetUpdatedUserDataSuccess(param1:CustomEvent) : void
      {
         mallConnector.removeEventListener("USER_DATA_SUCCESS",onGetUpdatedUserDataSuccess);
         xUserDataResponse = XML(param1.data);
         iUserBalance = int(xUserDataResponse.child("token-balance")[0]);
      }
      
      private function reveal() : void
      {
         mcBottomFrame.gotoAndPlay("enter");
         mcTopFrame.gotoAndPlay("enter");
         Tweener.addTween(mcBuyPanel,{
            "x":BUYPANEL_IN_X,
            "time":0.25,
            "delay":0.5,
            "transition":"easeOutQuad"
         });
         mcBuyPanel.openPortalDock(1);
         setEventListeners();
      }
      
      private function clipsAboveChip(param1:Boolean) : void
      {
         var _loc2_:int = getChildIndex(mcClips);
         var _loc3_:int = getChildIndex(curBoosterItemDrag);
         if(param1)
         {
            if(_loc3_ > _loc2_)
            {
               swapChildren(curBoosterItemDrag,mcClips);
            }
         }
         else if(_loc3_ < _loc2_)
         {
            swapChildren(curBoosterItemDrag,mcClips);
         }
      }
      
      private function isOverBuyDropZone() : Boolean
      {
         var _loc1_:Point = new Point(BUY_DROPZONE_X,BUY_DROPZONE_Y);
         if(curBoosterItemDrag.hitTestPoint(_loc1_.x,_loc1_.y,true))
         {
            return true;
         }
         return false;
      }
      
      private function onDMDataUpdated(param1:FrameWorkEvent) : void
      {
         DataManager.getInstance().getVirmonManager().removeEventListener(FrameWorkEvent.DM_DATA_UPDATED,onDMDataUpdated);
         _userProfile.retrieveProfileData();
         mcCollectionPanel.init(_virmonManager,_characterAssetRetriever,_emManager,_emAssetRetriever,xBuySKUResponse);
         showCollectionPanel();
         mcClips.reset();
         mcTruck.gotoAndPlay("zap");
         mcTruck.addEventListener("LIGHTNING_ZAP",onTruckLightningZap,false,0,true);
      }
      
      private function updateNanocashBalance(param1:Event) : void
      {
         log("updateNanocashBalance");
         iUserBalance = _userProfile.nanocash;
      }
      
      private function onTruckLightningZap(param1:Event) : void
      {
         mcTruck.removeEventListener("LIGHTNING_ZAP",onTruckLightningZap);
         if(param1 != null)
         {
            mcCollectionPanel.alignItems();
         }
         mcBuyPanel.enableBoosterSelectBackBtn();
         mcBuyPanel.enableBoosterSelectItems();
         mcCollectionPanel.enableUI();
         showNanoViewer(1);
         mcBuyPanel.cwStrobeLights();
         EventManager.getInstance().dispatchEvent(new ProjectEvent("HIDE_BLOCKER"));
      }
      
      private function onViewCollection(param1:Event) : void
      {
         _stateManager.setState(StateType.COLLECTION);
      }
      
      private function onCDBClick(param1:Object) : void
      {
      }
      
      private function close() : void
      {
         Utils.clearAllChildren(this);
         EventManager.getInstance().dispatchEvent(new ProjectEvent("HIDE_NANOMALL"));
      }
      
      override public function destroy() : void
      {
         if(Boolean(nanoViewer))
         {
            nanoViewer.destroy();
         }
         EventManager.getInstance().removeEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened);
         EventManager.getInstance().removeEventListener("NANOCASH_BALANCE_UPDATED",updateNanocashBalance);
         _userProfile.removeEventListener(UserProfileEvent.LOAD_COMPLETE_EVENT,onProfileRefreshed);
         DataManager.getInstance().getVirmonManager().removeEventListener(FrameWorkEvent.DM_DATA_UPDATED,onDMDataUpdated);
         mcMainButton.removeEventListener(MouseEvent.CLICK,onMainButtonClick);
         mallConnector.removeEventListener("SKU_SUCCESS",onGetSKUsSuccess);
         mallConnector.removeEventListener("SKU_ERROR",onGetSKUsError);
         mcBuyPanel.removeEventListener("PORTAL_OPENED",onPortalOpened);
         mcBuyPanel.removeEventListener(BoosterItemEvent.WAVELIST_BUYBTN_CLICK,onWaveListBuyBtnClick);
         mcBuyPanel.removeEventListener("BACK_TO_WAVELIST",onBackToWaveListClick);
         mcBuyPanel.removeEventListener("BOOSTERSELECTITEM_DOWN",onBoosterSelectItemDown);
         mcBuyConfirm.removeEventListener("BUY_CONFIRM",onBuyConfirm);
         mcBuyConfirm.removeEventListener("BUY_CANCEL",onBuyCancel);
         mcCollectionPanel.removeEventListener("KEEP_SHOPPING",onBackToWaveListClick);
         mcCollectionPanel.removeEventListener("VIEW_COLLECTION",onViewCollection);
         mcCollectionPanel.removeEventListener(CollectionPanelItem.ITEM_DOWN,onCollectionPanelItemDown);
         mallConnector.removeEventListener("USER_DATA_SUCCESS",onGetUpdatedUserDataSuccess);
         curBoosterItemDrag.removeEventListener("BOOSTER_DRAGITEM_UP",onBoosterItemDragUp);
         curBoosterItemDrag.removeEventListener("BOOSTER_DRAGITEM_DOWN",onBoosterItemDragDown);
         boosterItemDrag1.removeEventListener("BOOSTER_DRAGITEM_UP",onBoosterItemDragUp);
         boosterItemDrag1.removeEventListener("BOOSTER_DRAGITEM_DOWN",onBoosterItemDragDown);
         boosterItemDrag2.removeEventListener("BOOSTER_DRAGITEM_UP",onBoosterItemDragUp);
         boosterItemDrag2.removeEventListener("BOOSTER_DRAGITEM_DOWN",onBoosterItemDragDown);
         mcCollectionPanel.destroy();
         boosterItemDrag1.destroy();
         boosterItemDrag2.destroy();
         curBoosterItemDrag.destroy();
         mcBuyPanel.destroy();
         mcBuyConfirm.destroy();
         if(null != _commonDialogBox)
         {
            _commonDialogBox.kill();
         }
         super.destroy();
         log("onUnsetState(): System.totalMemory: " + System.totalMemory);
      }
      
      private function onCollectionPanelItemDown(param1:CustomEvent) : void
      {
         curCollectionItemOriginal = param1.target as CollectionPanelItem;
         curCollectionItemDrag = new MovieClip();
         curCollectionItemDrag.addChild(curCollectionItemOriginal.getBitmap());
         curCollectionItemDrag.x = this.mouseX - param1.data.mouseX;
         curCollectionItemDrag.y = this.mouseY - param1.data.mouseY;
         if(null != _stageTarget)
         {
            _stageTarget.addEventListener(MouseEvent.MOUSE_UP,onCollectionPanelItemDragUp,false,0,true);
         }
         addChild(curCollectionItemDrag);
         curCollectionItemDrag.startDrag();
         EventManager.getInstance().addEventListener(CommonDialogBox.DIALOG_BOX_OPENED_EVENT,onDialogOpened,false,0,true);
         nanoViewer.reset();
      }
   }
}

