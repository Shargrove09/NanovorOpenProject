package com.arkadium.virmon.trade
{
   import caurina.transitions.*;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.handlers.trade.IAddedToCartHandler;
   import com.arkadium.communications.handlers.trade.ICollectionSetHandler;
   import com.arkadium.communications.handlers.trade.IOfferAcceptedHandler;
   import com.arkadium.communications.handlers.trade.IOfferMadeHandler;
   import com.arkadium.communications.handlers.trade.IOtherPlayerJoinTradeHandler;
   import com.arkadium.communications.handlers.trade.IPlayerJoinTradeHandler;
   import com.arkadium.communications.handlers.trade.IRemovedFromCartHandler;
   import com.arkadium.communications.handlers.trade.ITradeOtherPlayerQuitHandler;
   import com.arkadium.communications.handlers.trade.ITradeOverHandler;
   import com.arkadium.communications.handlers.trade.ITradeQuitHandler;
   import com.arkadium.communications.handlers.trade.ITradeStartedHandler;
   import com.arkadium.communications.handlers.trade.ITransactionConfirmedHandler;
   import com.arkadium.virmon.avatar.AvatarSpinner;
   import com.arkadium.virmon.common.CustomEvent;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.GUIManager;
   import com.arkadium.virmon.common.GUIPanel;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.framework.IBuddyManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.IDataManager;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.data.DataProvider;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconQuestion;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.elements.viewer.CVirmonViewer;
   import com.arkadium.virmon.shared.elements.viewer.TopTabsPane;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.renders.TradeEmsRender;
   import com.arkadium.virmon.shared.renders.TradeVirmonRender;
   import com.arkadium.virmon.shared.ui.DragTileList;
   import com.arkadium.virmon.shared.utils.CEm;
   import com.arkadium.virmon.shared.utils.CTween;
   import com.arkadium.virmon.shared.utils.CVirmon;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.trade.transitions.TransitionScreen;
   import com.arkadium.virmon.trade.ui.collections.EmsCollection;
   import com.arkadium.virmon.trade.ui.collections.VirmonCollection;
   import com.arkadium.virmon.trade.ui.utils.BalanceMeter;
   import com.arkadium.virmon.trade.ui.utils.CUserInfo;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol273")]
   public class TradePanel extends GUIPanel implements ICollectionSetHandler, IOfferAcceptedHandler, IOfferMadeHandler, IRemovedFromCartHandler, IAddedToCartHandler, ITransactionConfirmedHandler, IOtherPlayerJoinTradeHandler, IPlayerJoinTradeHandler, ITradeOtherPlayerQuitHandler, ITradeQuitHandler, ITradeOverHandler, ITradeStartedHandler
   {
      
      private static const TRADE_STATE_OFFER:String = "OFFER";
      
      private static const TRADE_STATE_ACCEPT:String = "ACCEPT";
      
      private static const TRADE_STATE_CONFIRM:String = "CONFIRM";
      
      private static const TRADE_STATE_WAITING:String = "WAITING";
      
      private var _bConfirmPressed:Boolean = false;
      
      private var _mcQuickTips:SpinningButtonComponent;
      
      private var _isPlayer:Boolean = false;
      
      public var tfWire:TextField;
      
      private var _bAcceptedPressed:Boolean = false;
      
      private var _tradegameData:Object;
      
      private var _mcSpinner:AvatarSpinner;
      
      public var _cTransitionScreen:TransitionScreen;
      
      private var emsPlCollection:EmsCollection;
      
      private var _iPlayerMarketValue:int = 0;
      
      private var tcPlayer:TradingCart;
      
      public var bottomCover:MovieClip;
      
      public var _tabOpponent:TabSelector;
      
      private var _sStateTrade:String;
      
      private var tween:CTween;
      
      private const TWEEN_VIEWER_ATTACKS_POSITION:Number = 449;
      
      public var _mcOpponentInfo:CUserInfo;
      
      public var mcMainButton:MovieClip;
      
      private const TWEEN_VIEWER_CLOSE_POSITION:Number = 472;
      
      private var _dpVirmonPlayer:DataProvider;
      
      private var _cViewVirmon:CVirmonViewer;
      
      private var _dpEmsPlayer:DataProvider;
      
      private var _bMessage:Boolean = false;
      
      private var _iOpponentMarketValue:int = 0;
      
      private var _isConfirm:Boolean = false;
      
      private var _tradeGameService:ITradeGameService;
      
      private var _cdbMsg:CommonDialogBox;
      
      private var _bOpponentCollectionLoaded:Boolean = false;
      
      public var _mcDoor01:*;
      
      public var _mcDoor02:*;
      
      public var _mcDoor03:*;
      
      public var _mcDoor04:MovieClip;
      
      private var _cTradeEmsCell:TradeEmsRender;
      
      private var _iOpponentAvatarId:int = -1;
      
      private var _bSwfEventAnimStart:Boolean = false;
      
      private var _dataManager:IDataManager;
      
      public var _mcBalance:BalanceMeter;
      
      private var tcOpponent:TradingCart;
      
      private var vrmOppCollection:VirmonCollection;
      
      private var _iIDOpponent:int = -1;
      
      private var _dpVirmonOpponent:DataProvider;
      
      public var _stfInstructionMsg:TextField;
      
      private var _sNameOpponent:String;
      
      private var _dpEmsOpponent:DataProvider;
      
      private var _iCnt:int = 0;
      
      private var _bVirmonViewerLoaded:Boolean = false;
      
      private const TWEEN_VIEWER_DURATION:Number = 0.5;
      
      private var mainTextGlow:GlowFilter;
      
      private var mainButtonFunction:Function = nuthin;
      
      public var _mcPlayerInfo:CUserInfo;
      
      public var tfSubMain:TextField;
      
      private var _tmrDelay:Timer;
      
      public var tfMain:TextField;
      
      private var _bMyCollectionLoaded:Boolean = false;
      
      public var _tabPlayer:TabSelector;
      
      private var _szViewerTabSelected:String = null;
      
      private var vrmPlCollection:VirmonCollection;
      
      private var _cTradeVirmonCell:TradeVirmonRender;
      
      private var _lVirmonViewer:Loader;
      
      private var _mcCancelTrade:SpinningButtonComponent;
      
      private var _bStateTrade:Boolean = false;
      
      private var _userProfile:IUserProfile;
      
      private var emsOppCollection:EmsCollection;
      
      private var _analyticsManager:IAnalyticsManager;
      
      public var _mcViewVirmon:MovieClip;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      private const TWEEN_VIEWER_PEDIGREE_POSITION:Number = 305;
      
      private var _stateManager:IStateManager;
      
      private var _uiBoardID:uint;
      
      private var _buddyManager:IBuddyManager;
      
      public var _mcDisableWin:MovieClip;
      
      public function TradePanel()
      {
         super();
         addFrameScript(28,frame29);
         gotoAndStop(1);
         super.registerPanel(this,"TEST_PANEL",GUIManager(parent));
         createSpinningButtons();
         _mcSpinner = new AvatarSpinner();
         _mcSpinner.scaleX = _mcSpinner.scaleY = 1.417;
         _mcSpinner.x = 509;
         _mcSpinner.y = 697;
         _mcSpinner.lockClamps = true;
         _mcSpinner.showSpinnerClamps = true;
         addChildAt(_mcSpinner,getChildIndex(tfWire) + 1);
         mcMainButton.alpha = 0;
         mcMainButton.buttonMode = true;
         mcMainButton.addEventListener(MouseEvent.CLICK,onMainButtonClick);
         _mcCancelTrade.addEventListener(MouseEvent.CLICK,onCancelTradeButtonClick);
         _mcQuickTips.addEventListener(MouseEvent.CLICK,onQuickTipsClick);
         mainTextGlow = tfMain.filters[0];
         tfWire.text = "";
         tfSubMain.mouseEnabled = false;
         tfMain.mouseEnabled = false;
         tfWire.mouseEnabled = false;
         _mcSpinner.mouseEnabled = false;
         tfSubMain.text = "CLICK TO";
         tfMain.text = TRADE_STATE_OFFER;
         tfWire.text = "SEND OFFER";
         _mcSpinner.color = AvatarSpinner.COLOR_ORANGE;
         mainTextGlow.color = AvatarSpinner.COLOR_ORANGE;
         _mcSpinner.open();
         _mcCancelTrade.open();
         _mcQuickTips.open();
      }
      
      private function onAddCartReceive(param1:Object) : void
      {
         var _loc5_:IVirmon = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:CEm = null;
         var _loc2_:DataProvider = new DataProvider();
         var _loc3_:DataProvider = new DataProvider();
         var _loc4_:uint = 0;
         if(!_bStateTrade)
         {
            if(int(param1.userRefId) != _userProfile.id)
            {
               _loc2_ = vrmOppCollection.dataProvider;
               _loc3_ = emsOppCollection.dataProvider;
            }
            else
            {
               _loc2_ = vrmPlCollection.dataProvider;
               _loc3_ = emsPlCollection.dataProvider;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_.getItemAt(_loc4_).virmon.getID() == param1.assetId)
               {
                  _loc2_.getItemAt(_loc4_).state = 3;
                  if(Boolean(_loc2_.getItemAt(_loc4_).content))
                  {
                     _loc2_.getItemAt(_loc4_).state = 3;
                     _loc2_.getItemAt(_loc4_).content.gotoAndStop("disable");
                  }
                  _loc5_ = _loc2_.getItemAt(_loc4_).virmon;
                  if(int(param1.userRefId) != _userProfile.id)
                  {
                     tcOpponent.addItem({"virmon":_loc5_},TradingCart.VIRMON);
                     _iOpponentMarketValue += _loc5_.getMarketValue();
                  }
                  else
                  {
                     tcPlayer.addItem({"virmon":_loc5_},TradingCart.VIRMON);
                     _iPlayerMarketValue += _loc5_.getMarketValue();
                  }
                  _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
                  return;
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc6_ = _loc3_.getItemAt(_loc4_);
               _loc7_ = 0;
               while(_loc7_ < _loc6_.ids.length)
               {
                  if(_loc6_.ids[_loc7_] == param1.assetId)
                  {
                     _loc6_.id.pop();
                     _loc6_.em.count = _loc6_.count = _loc6_.id.length;
                     if(Boolean(_loc6_.content) && _loc6_.count == 0)
                     {
                        _loc6_.state = 3;
                     }
                     _loc8_ = _loc3_.getItemAt(_loc4_).em;
                     _loc8_.setID(param1.assetId);
                     if(int(param1.userRefId) != _userProfile.id)
                     {
                        emsOppCollection.updateState(_loc6_);
                        tcOpponent.addItem({
                           "id":_loc8_.getID(),
                           "mid":_loc8_.masterID,
                           "em":_loc8_
                        },TradingCart.EMS);
                        _iOpponentMarketValue += _loc8_.marketValue;
                        break;
                     }
                     emsPlCollection.updateState(_loc6_);
                     tcPlayer.addItem({
                        "id":_loc8_.getID(),
                        "mid":_loc8_.masterID,
                        "em":_loc8_
                     },TradingCart.EMS);
                     _iPlayerMarketValue += _loc8_.marketValue;
                     break;
                  }
                  _loc7_++;
               }
               _loc4_++;
            }
         }
         _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
      }
      
      private function showPlayerInfo(param1:Event) : *
      {
         _tradeGameService.getBadgeList(_userProfile.id.toString(),param1.currentTarget.data.getID().toString());
         showVirmon(param1.currentTarget.data,uint(_userProfile.id),false);
      }
      
      private function createSpinningButtons() : void
      {
         _mcCancelTrade = new SpinningButtonComponent(new SpinnerIconX());
         _mcCancelTrade.color = SpinningButtonComponent.COLOR_RED;
         _mcCancelTrade.x = 640.35;
         _mcCancelTrade.y = 742.1 - bottomCover.y;
         bottomCover.addChild(_mcCancelTrade);
         _mcQuickTips = new SpinningButtonComponent(new SpinnerIconQuestion());
         _mcQuickTips.x = 932.1;
         _mcQuickTips.y = 736.7 - bottomCover.y;
         bottomCover.addChild(_mcQuickTips);
      }
      
      public function handleAddedToCart(param1:Object = null) : void
      {
         log("handleAddedToCart");
         onAddCartReceive(param1);
      }
      
      private function onOk(param1:Object = null) : void
      {
         _bMessage = false;
         onClose();
         _stateManager.setState(StateType.HOME);
      }
      
      private function onMainButtonClick(param1:MouseEvent) : void
      {
         log("onMainButtonClick");
         mainButtonFunction();
      }
      
      private function onSelectVirmon(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         if(_tmrDelay != null)
         {
            _tmrDelay.stop();
            _tmrDelay.removeEventListener(TimerEvent.TIMER,onSelectVirmon);
            _tmrDelay = null;
         }
         if(vrmPlCollection.dataProvider.length > 0)
         {
            _loc2_ = vrmPlCollection.dataProvider.getItemAt(0);
            _loc2_.state = 2;
            vrmPlCollection.updateState(_loc2_);
            vrmPlCollection.index = 0;
            showVirmon(_loc2_.virmon,uint(_userProfile.id),false);
         }
         _mcDisableWin.visible = false;
      }
      
      private function onVirmonViewerPedigreeOpening() : void
      {
         Tweener.removeTweens(_mcViewVirmon,y);
         Tweener.addTween(_mcViewVirmon,{
            "y":TWEEN_VIEWER_PEDIGREE_POSITION,
            "time":TWEEN_VIEWER_DURATION,
            "transition":"easeInOutQuad"
         });
      }
      
      private function onViewerLoaded(param1:Event) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,onViewerLoaded);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onViewerLoadError);
         _cViewVirmon = param1.target.content;
         _cViewVirmon.redSelect = false;
         _cViewVirmon.showHolderVertical();
         _cViewVirmon.TopTabsClip.addEventListener(TopTabsPane.EVENT_TAB_CHANGED,onVirmonViewerDrawerTabChange,false,0,true);
         _cViewVirmon.addEventListener(CVirmonViewer.DRAWER_CLOSE_COMPLETE,onVirmonViewerDrawerClosed,false,0,true);
         _bVirmonViewerLoaded = true;
         checkAnimationReadyGo();
      }
      
      public function handleTradeOtherPlayerQuit(param1:Object = null) : void
      {
         log("handleTradeOtherPlayerQuit");
         _analyticsManager.trackAction(Action.TRADE_CANCELLED);
         sendQuitTradeAndClearStateData();
         onOk();
      }
      
      public function handleOfferMade(param1:Object = null) : void
      {
         log("handleOfferMade");
         handleOfferAccepted(param1);
      }
      
      public function setMainButton(param1:String, param2:Function) : void
      {
         tfMain.text = param1;
         tfWire.text = param1;
         if(param2 is Function)
         {
            mainButtonFunction = param2;
         }
         else
         {
            mainButtonFunction = nuthin;
         }
         switch(param1)
         {
            case TRADE_STATE_OFFER:
               tfSubMain.text = "CLICK TO";
               tfMain.text = TRADE_STATE_OFFER;
               tfWire.text = "SEND OFFER";
               _mcSpinner.color = AvatarSpinner.COLOR_ORANGE;
               mainTextGlow.color = AvatarSpinner.COLOR_ORANGE;
               break;
            case TRADE_STATE_ACCEPT:
               tfSubMain.text = "CLICK TO";
               tfMain.text = TRADE_STATE_ACCEPT;
               tfWire.text = "ACCEPT TRADE";
               _mcSpinner.color = 11069549;
               mainTextGlow.color = 11069549;
               break;
            case TRADE_STATE_CONFIRM:
               tfSubMain.text = "CLICK TO";
               tfMain.text = TRADE_STATE_CONFIRM;
               tfWire.text = "CONFIRM TRADE";
               _mcSpinner.color = AvatarSpinner.COLOR_BLUE;
               mainTextGlow.color = AvatarSpinner.COLOR_BLUE;
               break;
            case TRADE_STATE_WAITING:
               tfSubMain.text = "";
               tfMain.text = TRADE_STATE_WAITING;
               tfWire.text = "WAITING";
               _mcSpinner.color = 13421772;
               mainTextGlow.color = 13421772;
         }
         tfMain.filters = [mainTextGlow];
      }
      
      public function handleTransactionConfirmed(param1:Object = null) : void
      {
         log("handleTransactionConfirmed");
         handleTradeOver({"reason":204});
      }
      
      internal function frame29() : *
      {
         stop();
      }
      
      public function handleTradeQuit(param1:Object = null) : void
      {
         log("handleTradeQuit");
         sendQuitTradeAndClearStateData();
         _stateManager.setState(StateType.HOME);
      }
      
      private function onCancelTradeConfirm(param1:Object) : void
      {
         sendQuitTradeAndClearStateData();
         onOk(param1);
         _analyticsManager.trackAction(Action.TRADE_CANCELLED);
      }
      
      public function handleBadgeListReceived(param1:Object = null) : void
      {
         log("handleBadgeListReceived");
         log("Badge List: " + param1.badgeList);
      }
      
      private function onCancelTradeButtonClick(param1:MouseEvent) : void
      {
         _cdbMsg = CommonDialogBox.MakeAndQueue("confirm","Are You Sure?","Do you really want to exit?",0,onCancelTradeConfirm,decline,decline);
      }
      
      public function handleTradeStarted(param1:Object = null) : void
      {
         log("handleTradeStarted");
         vrmPlCollection.isDragActive = vrmOppCollection.isDragActive = emsPlCollection.isDragActive = emsOppCollection.isDragActive = tcPlayer.isDragActive = tcOpponent.isDragActive = false;
         if(param1.userRefId == _userProfile.id)
         {
            vrmPlCollection.isDragActive = vrmOppCollection.isDragActive = emsPlCollection.isDragActive = emsOppCollection.isDragActive = tcPlayer.isDragActive = tcOpponent.isDragActive = _bStateTrade = true;
            updateTurnUI(true);
         }
         else
         {
            updateTurnUI(false);
         }
         _tmrDelay = new Timer(5000,1);
         _tmrDelay.addEventListener(TimerEvent.TIMER,onSelectVirmon,false,0,true);
         _tmrDelay.start();
      }
      
      override public function onInitialize() : *
      {
         log("onInitialize -- overrided.. do nothing");
      }
      
      public function nuthin() : void
      {
         log("nothin hit");
      }
      
      public function handleOfferAccepted(param1:Object = null) : void
      {
         if(int(param1.code) == 1)
         {
            _isConfirm = true;
            _sStateTrade = TRADE_STATE_CONFIRM;
            setMainButton(_sStateTrade,onCheckPlayerReady);
            EventManager.getInstance().dispatchEvent(new ProjectEvent("CHANGE_NAVIGATION_MAIN_BTN",{
               "title":_sStateTrade,
               "func":onCheckPlayerReady
            }));
            return;
         }
         if(int(param1.userRefId) == _userProfile.id)
         {
            _bStateTrade = true;
            _sStateTrade = TRADE_STATE_ACCEPT;
            setMainButton(_sStateTrade,onCheckPlayerReady);
            EventManager.getInstance().dispatchEvent(new ProjectEvent("CHANGE_NAVIGATION_MAIN_BTN",{
               "title":_sStateTrade,
               "func":onCheckPlayerReady
            }));
            updateTurnUI(true);
         }
         else
         {
            updateTurnUI(false);
            _bStateTrade = false;
         }
         vrmPlCollection.isDragActive = vrmOppCollection.isDragActive = emsPlCollection.isDragActive = emsOppCollection.isDragActive = tcPlayer.isDragActive = tcOpponent.isDragActive = _bStateTrade;
      }
      
      private function onCollectionContentNotification(param1:Object) : void
      {
         var _loc2_:IVirmon = null;
         var _loc3_:* = undefined;
         var _loc6_:IVirmonData = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:IVirmonMasterData = null;
         var _loc11_:IBadgeManager = null;
         var _loc12_:Object = null;
         log("onCollectionContentNotification -- userRefId: " + param1.userRefId + ", nanoCount: " + param1.nanovorList.length + ", emCount: " + param1.emList.length);
         var _loc4_:int = 0;
         var _loc5_:uint = uint(_userProfile.id);
         if(uint(param1.userRefId) != _userProfile.id)
         {
            _dpVirmonOpponent.removeAll();
            _dpEmsOpponent.removeAll();
         }
         else
         {
            _dpVirmonPlayer.removeAll();
            _dpEmsPlayer.removeAll();
         }
         _loc3_ = 0;
         while(_loc3_ < param1.nanovorList.length)
         {
            _loc9_ = param1.nanovorList[_loc3_];
            _loc10_ = _dataManager.getVirmonManager().getVirmonMasterData(int(_loc9_.type));
            _loc2_ = new CVirmon();
            _loc2_.setID(_loc9_.id);
            _loc2_.setMasterId(int(_loc9_.type));
            _loc2_.setName(_loc9_.name);
            _loc2_.setNickName(_loc9_.nick);
            _loc2_.setSpeed(int(_loc9_.spd));
            _loc2_.setStrength(int(_loc9_.str));
            _loc2_.setArmor(int(_loc9_.arm));
            _loc2_.setCurrentHealth(int(_loc9_.hp));
            _loc2_.setHealth(int(_loc9_.hp));
            _loc2_.setSV(int(_loc9_.pv));
            _loc2_.setMarketValue(int(_loc9_.val));
            _loc2_.setCurrentState(0);
            _loc2_.setFaction(_loc10_.getFaction());
            _loc2_.setBirthDate(_loc9_.bday);
            _loc2_.setEvolveDate(_loc9_.evo);
            _loc2_.setProductionNumber(int(_loc9_.srl));
            _loc2_.setBattleCount(int(_loc9_.btls));
            _loc2_.setKillCount(int(_loc9_.kils));
            _loc11_ = _dataManager.getBadgeManager();
            _loc2_.setAttackList(_loc10_.getAttackList());
            if(int(param1.userRefId) != _userProfile.id)
            {
               _dpVirmonOpponent.addItem({"virmon":_loc2_});
            }
            else
            {
               _dpVirmonPlayer.addItem({"virmon":_loc2_});
            }
            _loc3_++;
         }
         var _loc7_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < param1.emList.length)
         {
            _loc12_ = param1.emList[_loc3_];
            if(int(param1.userRefId) != _userProfile.id)
            {
               _loc7_ = false;
               _loc4_ = 0;
               while(_loc4_ < _dpEmsOpponent.length)
               {
                  _loc8_ = _dpEmsOpponent.getItemAt(_loc4_);
                  if(_loc8_.mid == int(_loc12_.type))
                  {
                     _loc8_.count += 1;
                     _loc8_.id.push(_loc12_.id);
                     _loc8_.ids.push(_loc12_.id);
                     _loc7_ = true;
                     _dpEmsOpponent.replaceItemAt(_loc8_,_loc4_);
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc7_)
               {
                  _dpEmsOpponent.addItem({
                     "id":[int(_loc12_.id)],
                     "ids":[int(_loc12_.id)],
                     "mid":int(_loc12_.type),
                     "val":int(_loc12_.val),
                     "count":1
                  });
               }
            }
            else
            {
               _loc7_ = false;
               _loc4_ = 0;
               while(_loc4_ < _dpEmsPlayer.length)
               {
                  _loc8_ = _dpEmsPlayer.getItemAt(_loc4_);
                  if(_loc8_.mid == int(_loc12_.type))
                  {
                     _loc8_.count += 1;
                     _loc8_.id.push(_loc12_.id);
                     _loc8_.ids.push(_loc12_.id);
                     _loc7_ = true;
                     _dpEmsPlayer.replaceItemAt(_loc8_,_loc4_);
                     break;
                  }
                  _loc4_++;
               }
               if(!_loc7_)
               {
                  _dpEmsPlayer.addItem({
                     "id":[int(_loc12_.id)],
                     "ids":[int(_loc12_.id)],
                     "mid":int(_loc12_.type),
                     "val":int(_loc12_.val),
                     "count":1
                  });
               }
            }
            _loc3_++;
         }
         if(int(param1.userRefId) != _userProfile.id)
         {
            emsOppCollection.dataProvider = _dpEmsOpponent;
            _tabOpponent.init();
            _tradeGameService.startTrade();
            _bOpponentCollectionLoaded = true;
            checkAnimationReadyGo();
         }
         else
         {
            emsPlCollection.dataProvider = _dpEmsPlayer;
            _tabPlayer.init();
            _sStateTrade = TRADE_STATE_OFFER;
            setMainButton(_sStateTrade,onCheckPlayerReady);
            _bMyCollectionLoaded = true;
            checkAnimationReadyGo();
         }
      }
      
      private function checkAnimationReadyGo() : void
      {
         if(_bSwfEventAnimStart && _bVirmonViewerLoaded && _bMyCollectionLoaded && _bOpponentCollectionLoaded)
         {
            gotoAndPlay(2);
         }
      }
      
      private function onViewerLoadError(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,onViewerLoaded);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onViewerLoadError);
         logError("onViewerLoadError: " + param1.text);
      }
      
      private function decline(... rest) : void
      {
      }
      
      private function onRemoveVirmonCart(param1:Event) : void
      {
         param1.target.removeEventListener(TradingCart.REMOVE_VIRMON,onRemoveVirmonCart);
         var _loc2_:IVirmon = param1.target.data;
         if(_isPlayer)
         {
            _iPlayerMarketValue -= _loc2_.getMarketValue();
            _tradeGameService.removeFromCart(String(_userProfile.id),String(_loc2_.getID()));
         }
         else
         {
            _iOpponentMarketValue -= _loc2_.getMarketValue();
            _tradeGameService.removeFromCart(String(_iIDOpponent),String(_loc2_.getID()));
         }
         _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
         _sStateTrade = TRADE_STATE_OFFER;
         setMainButton(_sStateTrade,onCheckPlayerReady);
      }
      
      private function onStartAnimation(... rest) : void
      {
         EventManager.getInstance().removeEventListener("START_ANIMATION",onStartAnimation);
         _bSwfEventAnimStart = true;
         checkAnimationReadyGo();
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            this["_mcDoor0" + String(_loc2_ + 1)].gotoAndPlay("open");
            _loc2_++;
         }
      }
      
      private function accept(... rest) : void
      {
         log("accept hit???");
         _cTransitionScreen.addEventListener(TransitionScreen.PANEL_CLOSE,onDestroy,false,0,true);
         _cTransitionScreen.close();
      }
      
      public function handleTradeOver(param1:Object = null) : void
      {
         var _loc2_:CommonDialogBox = null;
         log("handleTradeOver:");
         sendQuitTradeAndClearStateData();
         if(int(param1.reason) == 204)
         {
            _loc2_ = CommonDialogBox.MakeAndQueue("info","Congratulations!","Trade Game is complete!",0,onOk,onOk);
            _dataManager.refreshData();
            EventManager.getInstance().dispatchEvent(new Event("NANOCASH_BALANCE_CHANGE"));
            log("handleTradeOver() - NANOCASH_BALANCE_CHANGE dispatched");
            _analyticsManager.trackAction(Action.TRADE_SUCCESSFUL);
         }
         else
         {
            if(!_bMessage)
            {
               _loc2_ = CommonDialogBox.MakeAndQueue("info","Trade has failed!","Please try again",0,onOk,onOk);
               _bMessage = true;
            }
            _analyticsManager.trackAction(Action.TRADE_ERROR);
         }
      }
      
      private function onDestroy(param1:Event = null) : void
      {
         _cTransitionScreen.removeEventListener(TransitionScreen.PANEL_CLOSE,onDestroy);
         EventManager.getInstance().dispatchEvent(new ProjectEvent("HIDE_TRADE_MANAGER"));
      }
      
      private function onCheckPlayerReady(... rest) : void
      {
         log("onCheckPlayerReady");
         if(tcOpponent.length == 0 || tcPlayer.length == 0)
         {
            return;
         }
         if(_isConfirm)
         {
            _tradeGameService.confirmTransaction();
            setMainButton(TRADE_STATE_WAITING,nuthin);
            return;
         }
         _tradeGameService.makeOffer();
         if(_sStateTrade == TRADE_STATE_ACCEPT)
         {
            vrmPlCollection.isDragActive = vrmOppCollection.isDragActive = emsPlCollection.isDragActive = emsOppCollection.isDragActive = tcPlayer.isDragActive = tcOpponent.isDragActive = false;
         }
         if(_sStateTrade == "OFFER")
         {
            setMainButton(_sStateTrade,onCheckPlayerReady);
         }
      }
      
      public function handleRemovedFromCart(param1:Object = null) : void
      {
         var _loc5_:IVirmon = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:CEm = null;
         log("handleRemovedFromCart");
         var _loc2_:DataProvider = new DataProvider();
         var _loc3_:DataProvider = new DataProvider();
         var _loc4_:uint = 0;
         if(!_bStateTrade)
         {
            if(int(param1.userRefId) != _userProfile.id)
            {
               _loc2_ = vrmOppCollection.dataProvider;
               _loc3_ = emsOppCollection.dataProvider;
            }
            else
            {
               _loc2_ = vrmPlCollection.dataProvider;
               _loc3_ = emsPlCollection.dataProvider;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_.getItemAt(_loc4_).id == param1.assetId)
               {
                  _loc2_.getItemAt(_loc4_).state = 1;
                  _loc2_.invalidateItemAt(_loc4_);
                  if(Boolean(_loc2_.getItemAt(_loc4_).content))
                  {
                     _loc2_.getItemAt(_loc4_).state = 1;
                     _loc2_.getItemAt(_loc4_).content.gotoAndStop("normal");
                  }
                  _loc5_ = _loc2_.getItemAt(_loc4_).virmon;
                  if(int(param1.userRefId) != _userProfile.id)
                  {
                     tcOpponent.removeItem(param1.assetId,TradingCart.VIRMON);
                  }
                  else
                  {
                     tcPlayer.removeItem(param1.assetId,TradingCart.VIRMON);
                  }
                  if(param1.userRefId != _userProfile.id)
                  {
                     _iOpponentMarketValue -= _loc5_.getMarketValue();
                     break;
                  }
                  _iPlayerMarketValue -= _loc5_.getMarketValue();
                  break;
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc6_ = _loc3_.getItemAt(_loc4_);
               _loc7_ = 0;
               while(_loc7_ < _loc6_.ids.length)
               {
                  if(_loc6_.ids[_loc7_] == param1.assetId)
                  {
                     _loc8_ = _loc6_.em;
                     _loc8_.setID(param1.assetId);
                     _loc6_.state = 1;
                     _loc6_.id.push(String(_loc8_.getID()));
                     _loc6_.em.count = _loc6_.count = _loc6_.id.length;
                     if(int(param1.userRefId) != _userProfile.id)
                     {
                        emsOppCollection.updateState(_loc6_);
                        tcOpponent.removeItem(param1.assetId,TradingCart.EMS);
                        _iOpponentMarketValue -= _loc8_.marketValue;
                        break;
                     }
                     emsPlCollection.updateState(_loc6_);
                     tcPlayer.removeItem(param1.assetId,TradingCart.EMS);
                     _iPlayerMarketValue -= _loc8_.marketValue;
                     break;
                  }
                  _loc7_++;
               }
               _loc4_++;
            }
         }
         _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<ERROR::TradePanel>>: " + param1);
      }
      
      private function onAddVirmonCart(param1:Event) : void
      {
         log("onAddVirmonCart");
         param1.target.removeEventListener(VirmonCollection.VIRMON_CHECK,onAddVirmonCart);
         var _loc2_:IVirmon = param1.target.data;
         if(_isPlayer)
         {
            _iPlayerMarketValue += _loc2_.getMarketValue();
            _tradeGameService.addToCart(String(_userProfile.id),String(_loc2_.getID()));
         }
         else
         {
            _iOpponentMarketValue += _loc2_.getMarketValue();
            _tradeGameService.addToCart(String(_iIDOpponent),String(_loc2_.getID()));
         }
         _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
         _sStateTrade = TRADE_STATE_OFFER;
         setMainButton(TRADE_STATE_OFFER,onCheckPlayerReady);
      }
      
      public function handlePlayerJoinTrade(param1:Object = null) : void
      {
         log("handlePlayerJoinTrade");
      }
      
      private function onHit(param1:MouseEvent) : void
      {
         var _loc4_:IVirmon = null;
         var _loc5_:CEm = null;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         vrmPlCollection.target = vrmOppCollection.target = null;
         tcPlayer._target = tcOpponent._target = null;
         if(vrmPlCollection.isMoveSelectedItem && tcPlayer.hitTestPoint(mouseX,mouseY,true))
         {
            _isPlayer = true;
            vrmPlCollection.addEventListener(VirmonCollection.VIRMON_CHECK,onAddVirmonCart,false,0,true);
            vrmPlCollection.target = tcPlayer;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
         if(emsPlCollection.isMoveSelectedItem && tcPlayer.hitTestPoint(mouseX,mouseY,true))
         {
            _isPlayer = true;
            emsPlCollection.addEventListener(EmsCollection.EMS_CHECK,onAddEmsCart,false,0,true);
            emsPlCollection.target = tcPlayer;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
         if(vrmOppCollection.isMoveSelectedItem && tcOpponent.hitTestPoint(mouseX,mouseY,true))
         {
            _isPlayer = false;
            vrmOppCollection.addEventListener(VirmonCollection.VIRMON_CHECK,onAddVirmonCart,false,0,true);
            vrmOppCollection.target = tcOpponent;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
         if(emsOppCollection.isMoveSelectedItem && tcOpponent.hitTestPoint(mouseX,mouseY,true))
         {
            _isPlayer = false;
            emsOppCollection.addEventListener(EmsCollection.EMS_CHECK,onAddEmsCart,false,0,true);
            emsOppCollection.target = tcOpponent;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
         if(tcOpponent.isMove && vrmOppCollection.hitTestPoint(mouseX,mouseY,true) && tcOpponent.type == TradingCart.VIRMON)
         {
            _isPlayer = false;
            tcOpponent.addEventListener(TradingCart.REMOVE_VIRMON,onRemoveVirmonCart,false,0,true);
            tcOpponent._target = vrmOppCollection;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
         if(tcOpponent.isMove && emsOppCollection.hitTestPoint(mouseX,mouseY,true) && tcOpponent.type == TradingCart.EMS)
         {
            _isPlayer = false;
            tcOpponent.addEventListener(TradingCart.REMOVE_EMS,onRemoveEmsCart,false,0,true);
            tcOpponent._target = emsOppCollection;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
         if(tcPlayer.isMove && vrmPlCollection.hitTestPoint(mouseX,mouseY,true) && tcPlayer.type == TradingCart.VIRMON)
         {
            _isPlayer = true;
            tcPlayer.addEventListener(TradingCart.REMOVE_VIRMON,onRemoveVirmonCart,false,0,true);
            tcPlayer._target = vrmPlCollection;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
         if(tcPlayer.isMove && emsPlCollection.hitTestPoint(mouseX,mouseY,true) && tcPlayer.type == TradingCart.EMS)
         {
            _isPlayer = true;
            tcPlayer.addEventListener(TradingCart.REMOVE_EMS,onRemoveEmsCart,false,0,true);
            tcPlayer._target = emsPlCollection;
            if(!_cViewVirmon.bClose)
            {
               closeVirmonDrawer();
            }
         }
      }
      
      private function showOpponentInfo(param1:Event) : *
      {
         _tradeGameService.getBadgeList(_iIDOpponent.toString(),param1.currentTarget.data.getID().toString());
         showVirmon(param1.currentTarget.data,uint(_iIDOpponent),true);
      }
      
      private function onVirmonViewerDrawerTabChange(param1:CustomEvent) : void
      {
         _szViewerTabSelected = param1.data.tabName;
         if(_szViewerTabSelected == TopTabsPane.ATTACKS)
         {
            onVirmonViewerAttacksOpening();
         }
         if(_szViewerTabSelected == TopTabsPane.PEDIGREE)
         {
            onVirmonViewerPedigreeOpening();
         }
      }
      
      private function onClose(param1:Event = null) : void
      {
         var e:Event = param1;
         stop();
         if(_cdbMsg != null)
         {
            _cdbMsg.kill();
         }
         _mcCancelTrade.destroy();
         _mcQuickTips.destroy();
         _dpEmsPlayer.removeAll();
         _dpEmsOpponent.removeAll();
         _dpVirmonPlayer.removeAll();
         _dpVirmonOpponent.removeAll();
         tcPlayer.destroy();
         tcOpponent.destroy();
         vrmOppCollection.clearAll();
         vrmPlCollection.clearAll();
         emsOppCollection.clearAll();
         emsPlCollection.clearAll();
         vrmOppCollection.destroy();
         vrmPlCollection.destroy();
         emsOppCollection.destroy();
         emsPlCollection.destroy();
         vrmOppCollection = vrmPlCollection = null;
         emsOppCollection = emsPlCollection = null;
         tcOpponent = tcPlayer = null;
         try
         {
            _cViewVirmon.clearAll();
            _lVirmonViewer.unload();
            _mcViewVirmon.removeChild(_lVirmonViewer);
            _cViewVirmon = null;
            _lVirmonViewer.close();
         }
         catch(e:*)
         {
         }
         _lVirmonViewer = null;
         removeEventListener(MouseEvent.MOUSE_UP,onHit);
         EventManager.getInstance().removeEventListener("UNLOAD",onClose);
         _tradeGameService.removeOtherPlayerJoinTradeHandler(IOtherPlayerJoinTradeHandler(this));
         _tradeGameService.removeAddedToCartHandler(IAddedToCartHandler(this));
         _tradeGameService.removeCollectionSetHandler(ICollectionSetHandler(this));
         _tradeGameService.removeOfferAcceptedHandler(IOfferAcceptedHandler(this));
         _tradeGameService.removeOfferMadeHandler(IOfferMadeHandler(this));
         _tradeGameService.removePlayerJoinTradeHandler(IPlayerJoinTradeHandler(this));
         _tradeGameService.removeRemovedFromCartHandler(IRemovedFromCartHandler(this));
         _tradeGameService.removeTradeOtherPlayerQuitHandler(ITradeOtherPlayerQuitHandler(this));
         _tradeGameService.removeTradeOverHandler(ITradeOverHandler(this));
         _tradeGameService.removeTradeQuitHandler(ITradeQuitHandler(this));
         _tradeGameService.removeTradeStartedHandler(ITradeStartedHandler(this));
         _tradeGameService.removeTransactionConfirmedHandler(ITransactionConfirmedHandler(this));
         _mcOpponentInfo.destroy();
         _mcPlayerInfo.destroy();
         _mcBalance.destroy();
         Utils.clearAllChildren(this);
         _rGUIManager = null;
         EventManager.getInstance().dispatchEvent(new ProjectEvent("CLEAR_TRADE_MANAGER"));
      }
      
      private function onVirmonViewerDrawerClosed(param1:Event) : void
      {
         Tweener.removeTweens(_mcViewVirmon,y);
         if(_cViewVirmon.OpenAfterClosed == null)
         {
            Tweener.addTween(_mcViewVirmon,{
               "y":TWEEN_VIEWER_CLOSE_POSITION,
               "time":TWEEN_VIEWER_DURATION,
               "transition":"easeInOutQuad"
            });
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<TradePanel>>: " + param1);
      }
      
      private function onQuickTipsClick(param1:MouseEvent) : void
      {
         _stateManager.handleQuickTips();
      }
      
      public function initialize(param1:IUserProfile, param2:IAnalyticsManager, param3:IDataManager, param4:IEMAssetRetriever, param5:ICharacterAssetRetriever, param6:IStateManager, param7:ITradeGameService, param8:ISoundManager, param9:IBuddyManager, param10:IBuddyRPManager) : void
      {
         var _loc12_:String = null;
         var _loc13_:IBuddyData = null;
         log("initialize()");
         _userProfile = param1;
         _analyticsManager = param2;
         _dataManager = param3;
         _stateManager = param6;
         _buddyManager = param9;
         _buddyRPManager = param10;
         TradeVirmonRender.initializeStaticMembers(param5);
         TradeEmsRender.initializeStaticMembers(param4,_dataManager.getEMManager());
         _dpVirmonPlayer = new DataProvider();
         _dpVirmonOpponent = new DataProvider();
         _dpEmsPlayer = new DataProvider();
         _dpEmsOpponent = new DataProvider();
         vrmPlCollection = _tabPlayer._cmVirmon._tlCollection;
         vrmPlCollection.init(param5,param8);
         emsPlCollection = _tabPlayer._cmEms._tlCollection;
         emsPlCollection.init(_dataManager.getEMManager(),param4,param8);
         vrmOppCollection = _tabOpponent._cmVirmon._tlCollection;
         vrmOppCollection.init(param5,param8);
         emsOppCollection = _tabOpponent._cmEms._tlCollection;
         emsOppCollection.init(_dataManager.getEMManager(),param4,param8);
         vrmPlCollection.column = emsPlCollection.column = 2;
         vrmOppCollection.column = emsOppCollection.column = 2;
         vrmPlCollection.rowCount = emsPlCollection.rowCount = 5;
         vrmOppCollection.rowCount = emsOppCollection.rowCount = 5;
         vrmPlCollection.isDragActive = vrmOppCollection.isDragActive = false;
         vrmPlCollection.dataProvider = _dpVirmonPlayer;
         vrmOppCollection.dataProvider = _dpVirmonOpponent;
         emsPlCollection.dataProvider = _dpEmsPlayer;
         emsOppCollection.dataProvider = _dpEmsOpponent;
         vrmPlCollection.moveArea = vrmOppCollection.moveArea = this;
         emsPlCollection.moveArea = emsOppCollection.moveArea = this;
         vrmOppCollection.scrollParent = _tabOpponent._mcVirmonScroll;
         vrmPlCollection.scrollParent = _tabPlayer._mcVirmonScroll;
         emsOppCollection.scrollParent = _tabOpponent._mcEmsScroll;
         emsPlCollection.scrollParent = _tabPlayer._mcEmsScroll;
         vrmOppCollection.xScrollPosition = vrmOppCollection.width + 10;
         vrmPlCollection.xScrollPosition = vrmPlCollection.width + 11;
         emsOppCollection.xScrollPosition = emsOppCollection.width + 10;
         emsPlCollection.xScrollPosition = emsPlCollection.width + 11;
         tcPlayer = _tabPlayer._tcCart;
         tcPlayer.init(param5,param4,_dataManager.getEMManager());
         tcOpponent = _tabOpponent._tcCart;
         tcOpponent.init(param5,param4,_dataManager.getEMManager());
         _tabPlayer.color = 35071;
         _tabOpponent.color = 16711680;
         _tabPlayer.duration = _tabOpponent.duration = 1;
         _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
         _lVirmonViewer = new Loader();
         _lVirmonViewer.contentLoaderInfo.addEventListener(Event.COMPLETE,onViewerLoaded,false,0,true);
         _lVirmonViewer.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onViewerLoadError,false,0,true);
         _lVirmonViewer.load(new URLRequest("elements/virmonViewer.swf"));
         _mcViewVirmon.addChild(_lVirmonViewer);
         _tradeGameService = param7;
         _tradeGameService.addCollectionSetHandler(ICollectionSetHandler(this));
         _tradeGameService.addOfferAcceptedHandler(IOfferAcceptedHandler(this));
         _tradeGameService.addOfferMadeHandler(IOfferMadeHandler(this));
         _tradeGameService.addPlayerJoinTradeHandler(IPlayerJoinTradeHandler(this));
         _tradeGameService.addRemovedFromCartHandler(IRemovedFromCartHandler(this));
         _tradeGameService.addAddedToCartHandler(IAddedToCartHandler(this));
         _tradeGameService.addTradeOtherPlayerQuitHandler(ITradeOtherPlayerQuitHandler(this));
         _tradeGameService.addTradeQuitHandler(ITradeQuitHandler(this));
         _tradeGameService.addOtherPlayerJoinTradeHandler(IOtherPlayerJoinTradeHandler(this));
         _tradeGameService.addTransactionConfirmedHandler(ITransactionConfirmedHandler(this));
         _tradeGameService.addTradeStartedHandler(ITradeStartedHandler(this));
         _tradeGameService.addTradeOverHandler(ITradeOverHandler(this));
         super.onInitialize();
         _mcDisableWin.visible = true;
         _sStateTrade = TRADE_STATE_OFFER;
         EventManager.getInstance().addEventListener("UNLOAD",onClose,false,0,true);
         EventManager.getInstance().addEventListener("START_ANIMATION",onStartAnimation,false,0,true);
         super.showMe(true);
         this.addEventListener(MouseEvent.MOUSE_UP,onHit,false,0,true);
         vrmPlCollection.addEventListener(DragTileList.SELECT_VIRMON,showPlayerInfo,false,0,true);
         vrmOppCollection.addEventListener(DragTileList.SELECT_VIRMON,showOpponentInfo,false,0,true);
         tcPlayer.addEventListener(DragTileList.SELECT_VIRMON,showPlayerInfo,false,0,true);
         tcOpponent.addEventListener(DragTileList.SELECT_VIRMON,showOpponentInfo,false,0,true);
         _tradegameData = _stateManager.getStateData(StateType.TRADEGAME);
         var _loc11_:String = "_tradegameData:";
         for(_loc12_ in _tradegameData)
         {
            _loc11_ += "\n\t" + _loc12_ + ": " + _tradegameData[_loc12_];
         }
         _iIDOpponent = _tradegameData.inviterId == _userProfile.id ? int(_tradegameData.inviteeId) : int(_tradegameData.inviterId);
         log(_loc11_);
         if(_tradegameData.inviterId != _userProfile.id)
         {
            _tradeGameService.joinAndGetCollections(_tradegameData.tradeName);
         }
         else
         {
            if(_iOpponentAvatarId == -1)
            {
               if(_tradegameData.avatarId == null || _tradegameData.avatarId == "")
               {
                  logError("onInitialize -- trying to compensate for race condition with avatarId, but it was not set!  looking for buddy now.");
                  _loc13_ = _buddyManager.getBuddy(_iIDOpponent);
                  if(_loc13_ == null)
                  {
                     _loc13_ = _buddyRPManager.getBuddy(_iIDOpponent);
                  }
                  if(_loc13_ == null)
                  {
                     logError("onInitialize -- could not find buddy in BuddyManager or BuddyRPManager!!!!!");
                     _mcOpponentInfo.AvatarID = 0;
                  }
                  else
                  {
                     _mcOpponentInfo.AvatarID = _loc13_.Avatar;
                     _sNameOpponent = _loc13_.Name;
                  }
               }
               else
               {
                  _iOpponentAvatarId = _tradegameData.avatarId;
                  _sNameOpponent = _tradegameData.inviteeName;
                  _mcOpponentInfo.AvatarID = _iOpponentAvatarId;
                  _mcOpponentInfo.name = _sNameOpponent;
                  _mcOpponentInfo.status = "?";
               }
            }
            _mcPlayerInfo.name = _userProfile.screenname;
            _mcPlayerInfo.status = "?";
            _mcPlayerInfo.AvatarID = _userProfile.avatarId;
            if(_stateManager.tradeCollectionSetData != null && _stateManager.tradeCollectionSetData.length > 0)
            {
               log("who\'s yer daddy -- got tradeCollectionSetData from stateManager");
               while(_stateManager.tradeCollectionSetData.length > 0)
               {
                  handleCollectionSet(_stateManager.tradeCollectionSetData.shift());
               }
            }
            else
            {
               log("not sure who yer daddy is -- did not get tradeCollectionSetData");
            }
         }
         onStartAnimation();
      }
      
      public function handleOtherPlayerJoinTrade(param1:Object = null) : void
      {
         var _loc2_:IBuddyData = null;
         log("handleOtherPlayerJoinTrade");
         if(_iIDOpponent == -1)
         {
            _iIDOpponent = int(param1.userRefId);
         }
         _sNameOpponent = String(param1.username);
         _mcOpponentInfo.name = _sNameOpponent;
         _mcOpponentInfo.status = "?";
         if(param1.avatarId != null && param1.avatarId != "")
         {
            _iOpponentAvatarId = int(param1.avatarId);
            _mcOpponentInfo.AvatarID = _iOpponentAvatarId;
         }
         else
         {
            logError("handleOtherPlayerJoinTrade -- did not receive avatarId in data packet");
            _loc2_ = _buddyManager.getBuddy(_iIDOpponent);
            if(_loc2_ == null)
            {
               _loc2_ = _buddyRPManager.getBuddy(_iIDOpponent);
            }
            if(_loc2_ == null)
            {
               logError("handleOtherPlayerJoinTrade -- could not find buddy in BuddyManager or BuddyRPManager either!!");
               _mcOpponentInfo.AvatarID = 0;
            }
            else
            {
               _mcOpponentInfo.AvatarID = _loc2_.Avatar;
            }
         }
         _mcPlayerInfo.name = _userProfile.screenname;
         _mcPlayerInfo.status = "?";
         _mcPlayerInfo.AvatarID = _userProfile.avatarId;
      }
      
      public function handleCollectionSet(param1:Object = null) : void
      {
         log("handleCollectionSet");
         onCollectionContentNotification(param1);
      }
      
      private function onJoin(param1:XMLList) : void
      {
         _uiBoardID = param1.@board_id;
      }
      
      private function sendQuitTradeAndClearStateData() : void
      {
         if(_tradeGameService != null)
         {
            _tradeGameService.quitTrade();
         }
         _stateManager.setStateData(StateType.TRADEGAME,null);
      }
      
      private function onVirmonViewerAttacksOpening() : *
      {
         Tweener.removeTweens(_mcViewVirmon,y);
         Tweener.addTween(_mcViewVirmon,{
            "y":TWEEN_VIEWER_ATTACKS_POSITION,
            "time":TWEEN_VIEWER_DURATION,
            "transition":"easeInOutQuad"
         });
      }
      
      private function onRemoveEmsCart(param1:Event) : void
      {
         param1.target.removeEventListener(TradingCart.REMOVE_EMS,onRemoveEmsCart);
         var _loc2_:CEm = param1.target.data;
         if(_isPlayer)
         {
            _iPlayerMarketValue -= _loc2_.marketValue;
            _tradeGameService.removeFromCart(String(_userProfile.id),String(_loc2_.getID()));
         }
         else
         {
            _iOpponentMarketValue -= _loc2_.marketValue;
            _tradeGameService.removeFromCart(String(_iIDOpponent),String(_loc2_.getID()));
         }
         _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
         _sStateTrade = TRADE_STATE_OFFER;
         setMainButton(_sStateTrade,onCheckPlayerReady);
      }
      
      private function onAddEmsCart(param1:Event) : void
      {
         log("onAddEmsCart");
         param1.target.removeEventListener(EmsCollection.EMS_CHECK,onAddEmsCart);
         var _loc2_:CEm = param1.target.data;
         if(_isPlayer)
         {
            _iPlayerMarketValue += _loc2_.marketValue;
            _tradeGameService.addToCart(String(_userProfile.id),String(_loc2_.getID()));
         }
         else
         {
            _iOpponentMarketValue += _loc2_.marketValue;
            _tradeGameService.addToCart(String(_iIDOpponent),String(_loc2_.getID()));
         }
         _mcBalance.balance(_iPlayerMarketValue,_iOpponentMarketValue);
         _sStateTrade = TRADE_STATE_OFFER;
         setMainButton(TRADE_STATE_OFFER,onCheckPlayerReady);
      }
      
      private function showVirmon(param1:IVirmon, param2:uint, param3:Boolean = false) : void
      {
         var _loc4_:IVirmonData = null;
         _cViewVirmon.redSelect = param3;
         if(param2 == _userProfile.id)
         {
            _loc4_ = _dataManager.getVirmonManager().getVirmonData(param1.getID());
            if(_loc4_ != null)
            {
               param1.setNickName(_loc4_.getNickName());
            }
         }
         _cViewVirmon.showVirmon(param1,param2,true,_cViewVirmon.DrawerState);
      }
      
      private function closeVirmonDrawer() : void
      {
         _szViewerTabSelected = null;
         _cViewVirmon.CloseDrawer(true);
      }
      
      private function updateTurnUI(param1:Boolean) : void
      {
         _mcPlayerInfo.status = param1 ? "TRADING" : "WAITING";
         _mcOpponentInfo.status = !param1 ? "TRADING" : "WAITING";
         if(param1)
         {
            _mcPlayerInfo.mcGlow.gotoAndPlay("on");
            _mcOpponentInfo.mcGlow.gotoAndPlay("off");
         }
         else
         {
            _mcPlayerInfo.mcGlow.gotoAndPlay("off");
            _mcOpponentInfo.mcGlow.gotoAndPlay("on");
         }
         var _loc2_:Function = param1 ? onCheckPlayerReady : null;
         if(param1)
         {
            setMainButton(_sStateTrade,_loc2_);
         }
         else
         {
            setMainButton(TRADE_STATE_WAITING,_loc2_);
         }
         if(_sStateTrade != TRADE_STATE_ACCEPT)
         {
         }
         _mcOpponentInfo.name = _sNameOpponent;
         _mcPlayerInfo.name = _userProfile.screenname;
      }
   }
}

