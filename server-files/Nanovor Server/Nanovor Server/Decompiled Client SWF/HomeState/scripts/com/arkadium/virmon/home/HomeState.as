package com.arkadium.virmon.home
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.WebClientManager;
   import com.arkadium.virmon.avatar.IAvatarSpinnerCloseHandler;
   import com.arkadium.virmon.avatar.IAvatarSpinnerOpenHandler;
   import com.arkadium.virmon.avatar.IAvatarSpinnerProvider;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.device.DeviceDetectionManager;
   import com.arkadium.virmon.framework.FileEncryptorChainLoadee;
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.senseibattle.ai.ISenseiAIDirectoryConsumer;
   import com.arkadium.virmon.senseibattle.ai.SenseiAIDirectory;
   import com.arkadium.virmon.shared.breadcrumb.Breadcrumb;
   import com.arkadium.virmon.shared.breadcrumb.BreadcrumbType;
   import com.arkadium.virmon.shared.breadcrumb.IBreadcrumbProgressManager;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.events.JumpToBattleEvent;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.mdm.MDMBrowserKey;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.shared.utils.chainloadees.WidgetChainLoadee;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.shared.widgets.megawidget.IMegaWidget;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IModedState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class HomeState extends AbstractState implements IModedState, IChainLoaderConsumer, IHomeBreadcrumbUIManager, IAvatarSpinnerCloseHandler, IAvatarSpinnerOpenHandler, ISenseiAIDirectoryConsumer, IHomeState
   {
      
      private var _isStateSet:Boolean;
      
      private var _deviceDetectionManager:DeviceDetectionManager;
      
      public var sizzleVolume:Number;
      
      private var _battleGameService:IBattleGameService;
      
      private var _sizzlePlaying:Boolean = false;
      
      private var _nextStateData:Object;
      
      public var mcBGScrim:MovieClip;
      
      private var _homeNewsController:HomeNewsController;
      
      private var _applicationExiter:IApplicationExiter;
      
      public var mcSizzleHolder:MovieClip;
      
      private var _playNextSizzle:Boolean = false;
      
      private var _masterDataAssetRetriever:IMasterDataAssetRetriever;
      
      public var mcBG:MovieClip;
      
      public var _trData:*;
      
      private var _chainLoader:ChainLoader;
      
      private var _newsBlockers:Dictionary = new Dictionary(true);
      
      private var _userProfile:IUserProfile;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _chatGameService:IChatGameService;
      
      private var _isInitializedAndLoaded:Boolean;
      
      private var _mdmManager:IMDMManager;
      
      private var _currentBreadcrumbType:BreadcrumbType;
      
      private var _nextStateType:StateType;
      
      private var _stateManager:IStateManager;
      
      private var _breadcrumbProgressManager:IBreadcrumbProgressManager;
      
      private var _autoBattleWidget:IAutoBattleWidget;
      
      private var _webClientManager:WebClientManager;
      
      private var _widgetManager:IWidgetManager;
      
      private var _senseiDirectoryLoaded:Boolean = false;
      
      private var _sizzleLoader:Loader;
      
      private var _currentSizzle:Breadcrumb;
      
      private var _senseiDirectory:SenseiAIDirectory;
      
      private var _currentMode:String;
      
      public function HomeState()
      {
         super();
         addFrameScript(0,frame1);
         stateName = StateType.HOME.name;
         EventManager.getInstance().addEventListener(JumpToBattleEvent.SOLO_BATTLE,onJumpToBattleEvent,false,0,true);
         EventManager.getInstance().addEventListener(JumpToBattleEvent.AUTO_BATTLE,onJumpToBattleEvent,false,0,true);
      }
      
      public function handleSenseiAILoadComplete() : void
      {
         _senseiDirectoryLoaded = true;
      }
      
      public function registerNewsBlocker(param1:IHomeNewsBlocker) : *
      {
         _newsBlockers[param1] = param1;
      }
      
      private function onConfirmLeaveStateYes(param1:Object) : void
      {
         if(canSetState())
         {
            _stateManager.setState(_nextStateType,_nextStateData);
         }
         IMegaWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).reset();
      }
      
      private function sizzleSkipped(param1:Event = null) : void
      {
         log("sizzleSkipped()");
         _breadcrumbProgressManager.setBreadcrumbAsComplete(_currentBreadcrumbType);
         setSizzleBasedOnBreadcrumb();
         unloadSizzle(true);
      }
      
      override public function logError(param1:String) : void
      {
         DebugLog.instance.error(">>HomeState<< " + param1);
      }
      
      override public function setMode(param1:String) : void
      {
         switch(param1)
         {
            case StateType.MODE_HOME:
               if(null != _autoBattleWidget)
               {
                  _autoBattleWidget.show();
               }
               break;
            case StateType.MODE_BATTLE:
               if(null != _autoBattleWidget)
               {
                  _autoBattleWidget.hide();
               }
               if(_currentStateIsHome && _currentModeIsHome && _homeNewsController != null)
               {
                  _homeNewsController.hide();
               }
         }
         _currentMode = param1;
      }
      
      override public function onUnsetState() : void
      {
         IAvatarSpinnerProvider(_widgetManager.getWidgetByName(WidgetType.WIDGET_AVATAR.name)).closeAvatarSpinners();
         if(_nextStateType != null && _nextStateType.name != StateType.BATTLE.name)
         {
            _chatGameService.exitChatRoom();
            _battleGameService.quitGame();
            IMegaWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).reset();
            clearNextStateRefs();
         }
         stopBreadcrumb();
         if(Boolean(_autoBattleWidget))
         {
            _autoBattleWidget.hide();
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name) != null)
         {
            _stateManager.sendWidgetToLimbo(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name));
            _widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)["handleStateChange"]();
            _widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name).setMode(WidgetType.MODE_HIDDEN);
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) != null)
         {
            _autoBattleWidget = IAutoBattleWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name));
         }
         EventManager.getInstance().removeEventListener(Const.SIZZLE_FINISHED,sizzleFinished);
         EventManager.getInstance().removeEventListener(Const.SIZZLE_SKIPPED,sizzleSkipped);
         stopBreadcrumb();
         unloadSizzle();
      }
      
      public function getMode() : String
      {
         return _currentMode;
      }
      
      public function setData(param1:*) : void
      {
         _trData = param1;
      }
      
      private function canSetState() : Boolean
      {
         if(StateType.DEVICEMANAGER != _nextStateType)
         {
            return true;
         }
         if(_deviceDetectionManager.isDeviceConnected)
         {
            return true;
         }
         return false;
      }
      
      override public function log(param1:*) : void
      {
         DebugLog.instance.log("<<HomeState>> " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _chainLoader.destroy();
         _chainLoader = null;
         if(null == _deviceDetectionManager)
         {
            _deviceDetectionManager = new DeviceDetectionManager(_mdmManager,_stateManager,IHeaderWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)),_chatGameService,_applicationExiter);
            _deviceDetectionManager.startDeviceCheck();
         }
         _autoBattleWidget = IAutoBattleWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name));
         registerNewsBlocker(_autoBattleWidget as IHomeNewsBlocker);
         var _loc2_:IAvatarSpinnerProvider = IAvatarSpinnerProvider(_widgetManager.getWidgetByName(WidgetType.WIDGET_AVATAR.name));
         if(_loc2_ != null)
         {
            log("found AvatarWidget, adding handlers.");
            _loc2_.addAvatarSpinnerCloseHandler(this as IAvatarSpinnerCloseHandler);
            _loc2_.addAvatarSpinnerOpenHandler(this as IAvatarSpinnerOpenHandler);
         }
         else
         {
            log("handleChainLoaderComplete() - AvatarWidget is null");
         }
         _isInitializedAndLoaded = true;
         trySetAndLoadSizzle();
      }
      
      override public function onSetState() : void
      {
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) != null)
         {
            _autoBattleWidget = IAutoBattleWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name));
         }
         var _loc1_:Object = _stateManager.getStateData(StateType.HOME);
         if(_loc1_ != null && _loc1_.mode != null)
         {
            setMode(_loc1_.mode);
            _stateManager.setStateData(StateType.HOME,null);
         }
         else
         {
            setMode(StateType.MODE_HOME);
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name).setMode(WidgetType.MODE_HOME);
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name).setMode(WidgetType.MODE_HOME);
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_AVATAR.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_AVATAR.name).setMode(WidgetType.MODE_HOME);
         }
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name) != null)
         {
            _stateManager.getWidgetFromLimbo(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name));
            _widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name).setMode(WidgetType.MODE_HOME);
         }
         EventManager.getInstance().addEventListener(Const.SIZZLE_FINISHED,sizzleFinished);
         EventManager.getInstance().addEventListener(Const.SIZZLE_SKIPPED,sizzleSkipped);
         _isStateSet = true;
         trySetAndLoadSizzle();
         _analyticsManager.trackView(View.HOME_LANDING);
      }
      
      public function playBreadcrumb() : void
      {
         var _loc1_:String = null;
         if(!_currentStateIsHome)
         {
            return;
         }
         if(!_currentModeIsHome)
         {
            return;
         }
         if(_sizzlePlaying)
         {
            return;
         }
         if(!mcSizzleHolder.visible)
         {
            return;
         }
         if(_currentSizzle == null)
         {
            return;
         }
         _sizzlePlaying = true;
         _currentSizzle.play();
         _currentSizzle.setListeners();
         _currentSizzle.soundTransform.volume = sizzleVolume;
         if(_currentBreadcrumbType != null)
         {
            _loc1_ = View.HOME_BREADCRUMB.name.replace("%NAME%",_currentBreadcrumbType.name + "-" + _currentBreadcrumbType.url);
            _analyticsManager.trackView(View.createDynamic(_loc1_));
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      private function trySetAndLoadSizzle() : void
      {
         if(!_isStateSet)
         {
            return;
         }
         if(!_isInitializedAndLoaded)
         {
            return;
         }
         setSizzleBasedOnBreadcrumb();
         loadSizzle();
      }
      
      override public function attemptToLeaveState(param1:StateType, param2:Object = null) : Boolean
      {
         var _loc5_:Boolean = false;
         log("attemptToLeaveState(): stateType.name = " + param1.name);
         _nextStateType = param1;
         var _loc3_:String = "";
         var _loc4_:String = "";
         if(param1 != null && param1.name != StateType.BATTLE.name)
         {
            if(_battleGameService.battleName != "")
            {
               _loc5_ = Boolean(_battleGameService.isCreator);
               _loc3_ = "About To Leave Battle Game";
               _loc4_ = "Are you sure you want to leave the battle game you " + (_loc5_ ? "created?" : "joined?");
            }
            else if(_chatGameService.privateChatRoomName != "" && _chatGameService.privateChatRoomName != null)
            {
               _loc3_ = "About To Leave Private Chat";
               _loc4_ = "Are you sure you want to leave private chat?";
            }
         }
         if(_loc3_ == "")
         {
            IMegaWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).reset();
            return true;
         }
         _nextStateData = param2;
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_CONFIRM,_loc3_,_loc4_,0,onConfirmLeaveStateYes,onConfirmLeaveStateNo,onConfirmLeaveStateNo);
         return false;
      }
      
      private function clearNextStateRefs() : void
      {
         _nextStateType = null;
         _nextStateData = null;
      }
      
      private function onSizzleLoaded(param1:Event) : void
      {
         var _loc2_:String = null;
         log("sizzle loaded");
         _sizzleLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onSizzleLoaded);
         _sizzleLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onSizzleLoadError);
         _currentSizzle = Breadcrumb(_sizzleLoader.contentLoaderInfo.content);
         if(_currentBreadcrumbType != null)
         {
            _loc2_ = View.HOME_BREADCRUMB.name.replace("%NAME%",_currentBreadcrumbType.name + "-" + _currentBreadcrumbType.url);
            _analyticsManager.trackView(View.createDynamic(_loc2_));
         }
         mcSizzleHolder.addChild(_currentSizzle);
         sizzleVolume = _currentSizzle.soundTransform.volume;
         showBreadcrumb();
         playBreadcrumb();
         if(_currentBreadcrumbType == BreadcrumbType.REWARDS && _userProfile.gamesPlayed > 0)
         {
            _breadcrumbProgressManager.setBreadcrumbAsComplete(BreadcrumbType.REWARDS);
         }
      }
      
      private function get _currentStateIsHome() : Boolean
      {
         return Boolean(_stateManager.state == StateType.HOME.name);
      }
      
      public function get isNewsBlockerActive() : Boolean
      {
         var _loc1_:IHomeNewsBlocker = null;
         for each(_loc1_ in _newsBlockers)
         {
            if(_loc1_.isActive)
            {
               return true;
            }
         }
         return false;
      }
      
      private function setSizzleBasedOnBreadcrumb() : void
      {
         _currentBreadcrumbType = _breadcrumbProgressManager.getNextBreadcrumbType();
      }
      
      private function get _currentModeIsHome() : Boolean
      {
         return Boolean(_currentMode == StateType.MODE_HOME);
      }
      
      public function initialize(param1:IUserProfile, param2:IBattleGameService, param3:IChatGameService, param4:IApplicationExiter, param5:IStateManager, param6:IHomeNewsBlocker, param7:IWidgetManager, param8:IBreadcrumbProgressManager, param9:IMDMManager, param10:IMasterDataAssetRetriever, param11:IAnalyticsManager, param12:WebClientManager, param13:INanovorFactory) : void
      {
         if(null == param1)
         {
            throw new Error("Parameter \"userProfile\" cannot be null.");
         }
         if(null == param2)
         {
            throw new Error("Parameter \"battleGameService\" cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \"chatGameService\" cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \"applicationExiter\" cannot be null.");
         }
         if(null == param5)
         {
            throw new Error("Parameter \"stateManager\" cannot be null.");
         }
         if(null == param6)
         {
            throw new Error("Parameter \"dialogNewsBlocker\" cannot be null.");
         }
         if(null == param7)
         {
            throw new Error("Parameter \"widgetManager\" cannot be null.");
         }
         if(null == param8)
         {
            throw new Error("Parameter \"breadcrumbProgressManager\" cannot be null.");
         }
         if(null == param9)
         {
            throw new Error("Parameter \"mdmManager,\" cannot be null.");
         }
         if(null == param10)
         {
            throw new Error("Parameter \"masterDataAssetRetriever\" cannot be null.");
         }
         if(null == param11)
         {
            throw new Error("Parameter \"analyticsManager\" cannot be null.");
         }
         if(null == param12)
         {
            throw new Error("Parameter \"webClientManager\" cannot be null.");
         }
         if(null == param13)
         {
            throw new Error("Parameter \"nanovorFactory\" cannot be null.");
         }
         if(isInitialized)
         {
            return;
         }
         _userProfile = param1;
         _battleGameService = param2;
         _chatGameService = param3;
         _applicationExiter = param4;
         _stateManager = param5;
         _stateManager.setStateData(StateType.HOME,null);
         registerNewsBlocker(param6);
         registerNewsBlocker(_stateManager as IHomeNewsBlocker);
         _widgetManager = param7;
         _breadcrumbProgressManager = param8;
         _mdmManager = param9;
         _masterDataAssetRetriever = param10;
         _senseiDirectory = new SenseiAIDirectory(param13,ISenseiAIDirectoryConsumer(this),_masterDataAssetRetriever);
         _analyticsManager = param11;
         _webClientManager = param12;
         var _loc14_:ChainLoadeeList = new ChainLoadeeList();
         _loc14_.add(new WidgetChainLoadee(_widgetManager,WidgetType.WIDGET_CHAT));
         _loc14_.add(new WidgetChainLoadee(_widgetManager,WidgetType.WIDGET_HEADER));
         _loc14_.add(new WidgetChainLoadee(_widgetManager,WidgetType.WIDGET_AUTO_BATTLE));
         _loc14_.add(new WidgetChainLoadee(_widgetManager,WidgetType.WIDGET_AVATAR));
         _loc14_.add(new WidgetChainLoadee(_widgetManager,WidgetType.WIDGET_MEGA_WIDGET));
         _loc14_.add(new FileEncryptorChainLoadee(_masterDataAssetRetriever.getMasterDataURL(MasterDataAssetType.CHAT).url));
         _chainLoader = new ChainLoader(_loc14_,IChainLoaderConsumer(this));
         _chainLoader.load();
         isInitialized = true;
         log("HOME state is initialized");
      }
      
      private function loadSizzle() : void
      {
         mcSizzleHolder.visible = false;
         _sizzleLoader = new Loader();
         _sizzleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onSizzleLoaded);
         _sizzleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onSizzleLoadError);
         var _loc1_:String = Const.BREADCRUMB_PATH + _currentBreadcrumbType.url;
         log("loadSizzle(): loading sizzle: " + _loc1_);
         _sizzleLoader.load(new URLRequest(_loc1_));
      }
      
      public function handleSenseiAILoadFailure() : void
      {
         logError("handleSenseiAILoadFailure()");
      }
      
      private function onJumpToBattleEvent(param1:JumpToBattleEvent) : void
      {
         var _loc2_:String = null;
         if(!_senseiDirectoryLoaded)
         {
            return;
         }
         switch(param1.type)
         {
            case JumpToBattleEvent.SOLO_BATTLE:
               _loc2_ = _senseiDirectory.getSenseiAINameByRefId(param1.aiPlayerId);
               _stateManager.setState(StateType.SENSEI_BATTLE,{
                  "senseiName":_loc2_,
                  "senseiId":param1.aiPlayerId
               },true);
               break;
            case JumpToBattleEvent.AUTO_BATTLE:
            default:
               IMegaWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).startAutoBattle();
               setMode(StateType.MODE_BATTLE);
         }
      }
      
      private function onSizzleLoadError(param1:IOErrorEvent) : void
      {
         _sizzleLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onSizzleLoaded);
         _sizzleLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onSizzleLoadError);
         logError("FAILED TO LOAD SIZZLE, will attempt to skip this breadcrumb and go to the next\n: " + param1.text);
         if(!_breadcrumbProgressManager.getIsBreadcrumbComplete(_currentBreadcrumbType))
         {
            _breadcrumbProgressManager.setBreadcrumbAsComplete(_currentBreadcrumbType);
            setSizzleBasedOnBreadcrumb();
            unloadSizzle(true);
         }
      }
      
      public function stopBreadcrumb() : void
      {
         if(!_currentStateIsHome)
         {
            return;
         }
         if(!_sizzlePlaying)
         {
            return;
         }
         if(_currentSizzle == null)
         {
            return;
         }
         _sizzlePlaying = false;
         _currentSizzle.stop();
         _currentSizzle.removeListeners();
         _currentSizzle.soundTransform.volume = 0;
      }
      
      public function handleAvatarSpinnerClose() : void
      {
         if(_homeNewsController != null && _currentModeIsHome)
         {
            _homeNewsController.show();
         }
      }
      
      private function sizzleFinished(param1:Event) : void
      {
         log("sizzleFinished");
         if(_currentBreadcrumbType == BreadcrumbType.INTRO_EPISODE)
         {
            _breadcrumbProgressManager.setBreadcrumbAsComplete(BreadcrumbType.INTRO_EPISODE);
            setSizzleBasedOnBreadcrumb();
            unloadSizzle(true);
         }
      }
      
      public function handleAvatarSpinnerOpen() : void
      {
         if(_homeNewsController != null && _currentModeIsHome)
         {
            _homeNewsController.hide();
         }
      }
      
      public function get currentBreadcrumbType() : BreadcrumbType
      {
         return _currentBreadcrumbType;
      }
      
      public function unregisterNewsBlocker(param1:IHomeNewsBlocker) : *
      {
         delete _newsBlockers[param1];
      }
      
      public function get activeNewsBlockerCount() : int
      {
         var _loc2_:IHomeNewsBlocker = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _newsBlockers)
         {
            if(_loc2_.isActive)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function showBreadcrumb() : void
      {
         if(!_currentStateIsHome)
         {
            return;
         }
         if(!_currentModeIsHome)
         {
            return;
         }
         if(mcSizzleHolder.visible)
         {
            return;
         }
         if(_currentSizzle == null)
         {
            return;
         }
         mcSizzleHolder.visible = true;
         playBreadcrumb();
         if(_currentBreadcrumbType == BreadcrumbType.NEWS)
         {
            if(_homeNewsController == null)
            {
               _homeNewsController = new HomeNewsController(_mdmManager,_webClientManager,_widgetManager,this,_currentSizzle);
            }
            Tweener.addTween(mcBGScrim,{
               "_autoAlpha":0,
               "time":0.5,
               "transition":"easeOutQuad"
            });
            _homeNewsController.show();
         }
      }
      
      public function hideBreadcrumb() : void
      {
         if(!_currentStateIsHome)
         {
            return;
         }
         if(!mcSizzleHolder.visible)
         {
            return;
         }
         mcSizzleHolder.visible = false;
         stopBreadcrumb();
         if(_currentBreadcrumbType == BreadcrumbType.NEWS && _homeNewsController != null)
         {
            _homeNewsController.hide();
            Tweener.addTween(mcBGScrim,{
               "_autoAlpha":1,
               "time":0.5,
               "transition":"easeOutQuad"
            });
         }
      }
      
      private function unloadSizzle(param1:Boolean = false) : void
      {
         var i:uint;
         var child:* = undefined;
         var playNextSizzle:Boolean = param1;
         _playNextSizzle = playNextSizzle;
         if(Boolean(_currentSizzle))
         {
            _currentSizzle.soundTransform.volume = 0;
         }
         i = 0;
         while(i < mcSizzleHolder.numChildren)
         {
            child = mcSizzleHolder.getChildAt(i);
            if(child != null)
            {
               child.removeListeners();
               mcSizzleHolder.removeChild(child);
               Utils.clearAllChildren(child);
            }
            i++;
         }
         if(_sizzleLoader != null)
         {
            try
            {
               _sizzleLoader.unload();
            }
            catch(e:*)
            {
            }
         }
         if(_homeNewsController != null)
         {
            _homeNewsController.destroy();
            _homeNewsController = null;
         }
         if(_mdmManager.getBrowserController(MDMBrowserKey.HOME_NEWS) != null)
         {
            _mdmManager.unregisterBrowserController(_mdmManager.getBrowserController(MDMBrowserKey.HOME_NEWS));
         }
         _currentSizzle = null;
         log("sizzle unloaded");
         _sizzleLoader = null;
         if(_playNextSizzle)
         {
            loadSizzle();
         }
         _playNextSizzle = false;
      }
      
      private function onConfirmLeaveStateNo(param1:Object) : void
      {
         clearNextStateRefs();
      }
   }
}

