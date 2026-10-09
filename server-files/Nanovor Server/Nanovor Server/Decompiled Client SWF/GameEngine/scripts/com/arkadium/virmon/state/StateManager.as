package com.arkadium.virmon.state
{
   import com.arkadium.virmon.battle.control.BattleEngineEvent;
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.help.attackchooser.HelpAttackChooser;
   import com.arkadium.virmon.help.attackchooser.IHelpAttackChooser;
   import com.arkadium.virmon.help.swarmchooser.HelpSwarmChooser;
   import com.arkadium.virmon.help.swarmchooser.IHelpSwarmChooser;
   import com.arkadium.virmon.home.IHomeNewsBlocker;
   import com.arkadium.virmon.musicmanager.IMusicManager;
   import com.arkadium.virmon.musicmanager.MusicTrack;
   import com.arkadium.virmon.shared.breadcrumb.BreadcrumbType;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.events.LoadQuicktipsEvent;
   import com.arkadium.virmon.shared.mdm.MDMBrowserKey;
   import com.arkadium.virmon.shared.ui.gameOptions.ICGameOptions;
   import com.arkadium.virmon.shared.ui.gameOptions.ICGameOptionsConsumer;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.state.initializer.IStateInitializer;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.transitions.ITransitionManager;
   import com.arkadium.virmon.transitions.ITransitionManagerConsumer;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class StateManager implements IStateManager, ICGameOptionsConsumer, ITransitionManagerConsumer, IStateChanger, IHomeNewsBlocker
   {
      
      private static const DEFAULT_QUICKTIPS_URL:String = "aRatherHelpfulMovie.swf";
      
      private var _settingState:StateType;
      
      private var _transitionManager:ITransitionManager;
      
      private var _states:Array;
      
      private var _defaultStateLoadTarget:Sprite;
      
      private var _curHelpViewCount:int;
      
      private var _isHelpOn:Boolean;
      
      private var _applicationExiter:IApplicationExiter;
      
      private var _stateLoader:StateLoader;
      
      private var _setStateArguments:Object;
      
      private var _gameOptionsInView:Boolean;
      
      private var mcCurQuickTip:MovieClip;
      
      private var _stateData:Dictionary;
      
      private var _quickTipsInView:Boolean;
      
      private var _curHelp:*;
      
      private var _transitionInView:Boolean;
      
      private var _curHelpHandler:*;
      
      private var quicktipsVolControl:SoundTransform;
      
      private var _curHelpTarget:*;
      
      private var _quickTipsHolder:Sprite;
      
      private var _state:AbstractState;
      
      private var _popupLoadTarget:Sprite;
      
      private var _musicManager:IMusicManager;
      
      private var _deferredStateDestructionTimer:Timer;
      
      private var _tradeCollectionSetData:Array = null;
      
      private var _widgetManager:IWidgetManager;
      
      private var _previousState:AbstractState;
      
      private var _mcGameOptions:ICGameOptions;
      
      private var _playersInBattle:Array;
      
      private var _helpHolder:Sprite;
      
      private var _stateInitializer:IStateInitializer;
      
      private var _quickTipsLoader:Loader;
      
      private var _deferredStatesToDestroy:Dictionary = new Dictionary();
      
      public function StateManager(param1:IApplicationExiter, param2:Sprite, param3:IWidgetManager, param4:Sprite, param5:Sprite, param6:Sprite, param7:IMusicManager)
      {
         super();
         _applicationExiter = param1;
         _defaultStateLoadTarget = param2;
         _widgetManager = param3;
         _popupLoadTarget = param4;
         _quickTipsHolder = param5;
         _helpHolder = param6;
         _musicManager = param7;
         _helpHolder.mouseChildren = false;
         _states = new Array();
         _stateLoader = new StateLoader();
         _stateData = new Dictionary();
         EventManager.getInstance().addEventListener(LoadQuicktipsEvent.LOAD_QUICKTIPS,onLoadQuicktipsEvent,false,0,true);
      }
      
      public function handleTransitionMidpoint() : void
      {
         if(null != _state)
         {
            _state.onTransitionOutComplete();
         }
         transitionToState(_setStateArguments.stateType);
      }
      
      private function quickTipsLoadCompleteHandler(param1:Event) : void
      {
         log("quickTips movie loaded");
         quicktipsVolControl = new SoundTransform();
         mcCurQuickTip = MovieClip(_quickTipsLoader.content);
         _quickTipsLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,quickTipsLoadCompleteHandler);
         _quickTipsLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,quickTipsLoadErrorHandler);
         _quickTipsHolder.visible = true;
         if(mcCurQuickTip != null)
         {
            mcCurQuickTip.tabChildren = false;
            _quickTipsHolder.addChild(mcCurQuickTip);
            _quickTipsInView = true;
         }
         _quickTipsHolder.addEventListener("CLOSE_QUICKTIPS",hideQuickTips);
         updateQuickTipsVolume(null);
         if(Managers.homeBreadcrumbUIManager != null)
         {
            Managers.homeBreadcrumbUIManager.stopBreadcrumb();
         }
         Managers.mdmManager.hideAllMdmBrowsers();
      }
      
      private function quickTipsLoadErrorHandler(param1:IOErrorEvent) : void
      {
         logError("Failed to load quick tips: " + _quickTipsLoader.contentLoaderInfo.url);
         _quickTipsLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,quickTipsLoadCompleteHandler);
         _quickTipsLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,quickTipsLoadErrorHandler);
         _quickTipsLoader = null;
      }
      
      public function get playersInBattle() : Array
      {
         return _playersInBattle;
      }
      
      private function handleStateLoaderComplete(param1:Event) : void
      {
         _stateLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleStateLoaderComplete);
         _stateLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleStateLoaderError);
         log("StateManager.handleStateLoaderComplete:: _state: " + _state + ", _settingState: " + _settingState);
         _states.push(param1.target.content);
         if(_settingState != null)
         {
            transitionToState(_setStateArguments.stateType);
         }
      }
      
      public function init(param1:ITransitionManager, param2:ICGameOptions, param3:IStateInitializer, param4:IDownloader) : void
      {
         _transitionManager = param1;
         _transitionManager.init(ITransitionManagerConsumer(this));
         if(null != param2 as Sprite)
         {
            _mcGameOptions = param2;
            _mcGameOptions.init(ICGameOptionsConsumer(this));
            log("setGameOptions() - Successfully added gameOptions to StateManager");
         }
         _stateInitializer = param3;
         _stateInitializer.init(param4,_applicationExiter);
      }
      
      public function getStateData(param1:StateType) : Object
      {
         return _stateData[param1];
      }
      
      private function showGameOptions() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         if(Managers.homeBreadcrumbUIManager != null)
         {
            Managers.homeBreadcrumbUIManager.stopBreadcrumb();
         }
         Managers.mdmManager.hideAllMdmBrowsers();
         log("showGameOptions()");
         if(null != _mcGameOptions)
         {
            _loc1_ = Number(Managers.soundManager.getMusicGlobalVolume());
            _loc2_ = Number(Managers.soundManager.getSoundGlobalVolume());
            _loc3_ = false;
            _loc4_ = Managers.storedSettingsManager.getSetting(StoredSetting.GAMEOPTIONS_QUALITY);
            _loc5_ = Managers.storedSettingsManager.getSetting(StoredSetting.GAMEOPTIONS_HELP);
            _mcGameOptions.setParams(_loc3_,_loc1_,_loc2_,_loc4_,_loc5_);
            _popupLoadTarget.addChild(_mcGameOptions as Sprite);
            _gameOptionsInView = true;
         }
      }
      
      public function handleQuitBattle(... rest) : void
      {
         log("quitting battle from widget");
         EventManager.getInstance().dispatchEvent(new BattleEngineEvent(BattleEngineEvent.QUIT_GAME));
         setState(StateType.HOME);
      }
      
      private function setUPCounts(param1:StateType) : void
      {
         if(Managers.homeBreadcrumbUIManager == null)
         {
            return;
         }
         var _loc2_:BreadcrumbType = Managers.homeBreadcrumbUIManager.currentBreadcrumbType;
         log("setUPCounts:: stateType: " + param1 + "; currentUIBreadcrumb = " + _loc2_);
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.stateTypeTriggers.indexOf(param1) != -1)
         {
            Managers.breadcrumbProgressManager.setBreadcrumbAsComplete(_loc2_);
         }
         else if(_loc2_.stateTypeTriggers.indexOf(StateType.NONE) != -1)
         {
            Managers.breadcrumbProgressManager.setBreadcrumbAsComplete(_loc2_);
         }
      }
      
      public function set playersInBattle(param1:Array) : void
      {
         _playersInBattle = param1;
      }
      
      public function getWidgetFromLimbo(param1:IWidget) : void
      {
         var _loc2_:Sprite = param1 as Sprite;
         if(null != _loc2_)
         {
            _loc2_.visible = true;
         }
      }
      
      public function getStateByName(param1:String) : AbstractState
      {
         var _loc2_:int = 0;
         while(_loc2_ < _states.length)
         {
            if(_states[_loc2_].stateName == param1)
            {
               return _states[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function logError(param1:String) : void
      {
         DebugLog.instance.error("!!<<StateManager ERROR>>!! -->\t" + param1);
      }
      
      public function log(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = param1 is Array ? "[Array]\n" : "";
         if(param1 is String)
         {
            param1 = [param1];
         }
         if(param1.length == 1)
         {
            _loc2_ = param1[0];
         }
         else
         {
            for(_loc3_ in param1)
            {
               _loc2_ += "\n\t[" + _loc3_ + "] " + param1[_loc3_];
            }
         }
         DebugLog.instance.log("<<StateManager>>\t" + param1);
      }
      
      public function set tradeCollectionSetData(param1:Array) : void
      {
         _tradeCollectionSetData = param1;
      }
      
      public function setState(param1:StateType, param2:Object = null, param3:Boolean = false) : void
      {
         log("StateManager.setState(): attempting to set state: " + param1.name);
         if(_state != null && param1.name == _state.stateName)
         {
            return;
         }
         if(param1.url == "")
         {
            return;
         }
         if(param3 && _state != null && !_state.attemptToLeaveState(param1,param2))
         {
            return;
         }
         Managers.buyNanocashUIManager.hideBuyNanocash();
         if(Boolean(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)))
         {
            IHeaderWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)).showLastButtonClickedAsCurrent();
         }
         _setStateArguments = {
            "stateType":param1,
            "stateData":param2
         };
         var _loc4_:String = MusicTrack.GetComponentMusicTrack(param1);
         log("setState::getting music track for : " + param1.name + " (" + _loc4_ + ")");
         _musicManager.FadeOutFadeInToTrack(Managers.assetRetrieverManager.soundAssetRetriever.getMusicURL(_loc4_));
         if(_state != getStateByName(StateType.LOGIN.name))
         {
            _transitionManager.startTransition();
            _transitionInView = true;
         }
         else
         {
            handleTransitionMidpoint();
         }
         if(null != _state)
         {
            if(null != _state.parent)
            {
               _state.parent.removeChild(_state);
            }
         }
         hideQuickTips();
      }
      
      private function onQuickTipsUnload(... rest) : void
      {
         _quickTipsLoader.contentLoaderInfo.removeEventListener(Event.UNLOAD,onQuickTipsUnload);
         Utils.gc();
      }
      
      private function updateQuickTipsVolume(param1:Event) : void
      {
         if(mcCurQuickTip == null)
         {
            return;
         }
         var _loc2_:Number = Number(Managers.soundManager.getSoundGlobalVolume());
         quicktipsVolControl.volume = _loc2_ / 100;
         mcCurQuickTip.soundTransform = quicktipsVolControl;
      }
      
      private function declineQuit(param1:Object) : void
      {
      }
      
      public function handleSettings(... rest) : void
      {
         showGameOptions();
      }
      
      public function handleGameOptionsClose() : void
      {
         updateQuickTipsVolume(null);
         if(Managers.homeBreadcrumbUIManager != null)
         {
            Managers.homeBreadcrumbUIManager.playBreadcrumb();
         }
         log("handleGameOptionsClose(): _state.name=" + _state.stateName);
         if(_state.stateName == StateType.HOME.name && (_state as IModedState != null && (_state as IModedState).getMode() != StateType.MODE_HOME))
         {
            Managers.mdmManager.pushFakeBrowserState(MDMBrowserKey.HOME_NEWS,{"visible":false});
         }
         Managers.mdmManager.restoreLastMdmBrowsersStates();
         var _loc1_:Sprite = _mcGameOptions as Sprite;
         if(null != _loc1_.parent)
         {
            _loc1_.parent.removeChild(_loc1_);
         }
         _gameOptionsInView = false;
      }
      
      public function saveAndCloseGameOptions() : void
      {
         log("saveAndCloseGameOptions()");
         if(_gameOptionsInView)
         {
            _mcGameOptions.saveAndClose();
         }
      }
      
      private function startStateDestructionDeferralTimer() : void
      {
         if(_deferredStateDestructionTimer == null)
         {
            _deferredStateDestructionTimer = new Timer(4000,1);
            _deferredStateDestructionTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onDeferredStateDestructionTimerComplete,false,0,true);
         }
         _deferredStateDestructionTimer.reset();
         _deferredStateDestructionTimer.start();
      }
      
      public function handleQuickTips(... rest) : void
      {
         var _loc2_:String = getQuickTipsURL();
         if(_loc2_ == null)
         {
            _loc2_ = DEFAULT_QUICKTIPS_URL;
         }
         loadQuickTips(_loc2_);
      }
      
      private function onDeferredStateDestructionTimerComplete(param1:TimerEvent) : void
      {
         var _loc2_:AbstractState = null;
         for each(_loc2_ in _deferredStatesToDestroy)
         {
            log("onDeferredStateDestructionTimerComplete: found state to destroy: " + _loc2_.stateName);
            _loc2_.destroy();
            delete _deferredStatesToDestroy[_loc2_];
         }
         Utils.gc();
         Utils.gc();
      }
      
      public function handleGameOptionsChangeScreenSize(param1:String) : void
      {
      }
      
      private function acceptQuit(param1:Object) : void
      {
         _applicationExiter.exitApplication();
      }
      
      public function handleHelp(param1:String, param2:*) : void
      {
         if(null == param2)
         {
            return;
         }
         _isHelpOn = Managers.storedSettingsManager.getSetting(StoredSetting.GAMEOPTIONS_HELP);
         _curHelpViewCount = 0;
         switch(param1)
         {
            case Const.HELP_SWARMCHOOSER:
               _curHelpViewCount = Managers.storedSettingsManager.getSettingOrSetDefault(StoredSetting.HELPVIEWS_SWARMCHOOSER,0);
               Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.HELPVIEWS_SWARMCHOOSER,++_curHelpViewCount);
               _curHelp = new HelpSwarmChooser();
               _curHelpHandler = IHelpSwarmChooser(_curHelp);
               break;
            case Const.HELP_ATTACKCHOOSER:
               _curHelpViewCount = Managers.storedSettingsManager.getSettingOrSetDefault(StoredSetting.HELPVIEWS_ATTACKCHOOSER,0);
               Managers.storedSettingsManager.storeSettingAndSave(StoredSetting.HELPVIEWS_ATTACKCHOOSER,++_curHelpViewCount);
               _curHelp = new HelpAttackChooser();
               _curHelpHandler = IHelpAttackChooser(_curHelp);
         }
         if(_isHelpOn || _curHelpViewCount <= Const.HELP_AUTOVIEWS)
         {
            _curHelpTarget = param2;
            toggleHelp(true);
         }
         else
         {
            toggleHelp(false);
         }
      }
      
      public function loadQuickTips(param1:String) : void
      {
         var quickTipsURL:String = param1;
         if(null != _quickTipsLoader)
         {
            try
            {
               _quickTipsLoader.close();
            }
            catch(e:Error)
            {
            }
            _quickTipsLoader = null;
         }
         log("loadQuickTips() - Number of quicktips: " + _quickTipsHolder.numChildren);
         while(_quickTipsHolder.numChildren > 0)
         {
            _quickTipsHolder.removeChildAt(0);
         }
         quickTipsURL = quickTipsURL.indexOf(Const.QUICKTIP_PATH) == -1 ? Const.QUICKTIP_PATH + quickTipsURL : quickTipsURL;
         log("loading quickTips movie: " + quickTipsURL);
         _quickTipsLoader = new Loader();
         _quickTipsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,quickTipsLoadCompleteHandler);
         _quickTipsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,quickTipsLoadErrorHandler);
         _quickTipsLoader.load(new URLRequest(quickTipsURL));
      }
      
      public function get state() : String
      {
         if(_state != null)
         {
            return _state.stateName;
         }
         return StateType.NONE.name;
      }
      
      public function setQuickTipsButton() : void
      {
         if(Boolean(getQuickTipsURL()))
         {
            if(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
            {
               IHeaderWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)).enableQuickTipsButton();
            }
         }
         else if(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
         {
            IHeaderWidget(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)).disableQuickTipsButton();
         }
      }
      
      public function sendWidgetToLimbo(param1:IWidget) : void
      {
         var _loc2_:Sprite = param1 as Sprite;
         if(null != _loc2_)
         {
            _loc2_.visible = false;
         }
      }
      
      public function handleQuit(... rest) : void
      {
         var _loc2_:CommonDialogBox = CommonDialogBox.MakeAndForce("confirm","Quit Game","Are you sure you want to quit Nanovor?",0,acceptQuit,declineQuit);
      }
      
      public function hideQuickTips(... rest) : void
      {
         if(Boolean(_quickTipsLoader))
         {
            mcCurQuickTip.stop();
            _quickTipsHolder.removeChild(mcCurQuickTip);
            _quickTipsInView = false;
            _quickTipsLoader.contentLoaderInfo.addEventListener(Event.UNLOAD,onQuickTipsUnload);
            _quickTipsLoader.unload();
            _quickTipsLoader = null;
            if(Managers.homeBreadcrumbUIManager != null)
            {
               Managers.homeBreadcrumbUIManager.playBreadcrumb();
            }
            Managers.mdmManager.restoreLastMdmBrowsersStates();
         }
      }
      
      public function handleGameOptionsVolumeChanged(param1:Number, param2:String) : void
      {
         Managers.soundManager.changeSoundVolume(param1,param2);
      }
      
      public function setStateData(param1:StateType, param2:Object) : void
      {
         _stateData[param1] = param2;
      }
      
      public function get tradeCollectionSetData() : Array
      {
         return _tradeCollectionSetData;
      }
      
      private function handleStateLoaderError(param1:IOErrorEvent) : void
      {
         _stateLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleStateLoaderComplete);
         _stateLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,handleStateLoaderError);
         logError("StateManager.handleStateLoaderError:: _state: " + _state + ", _settingState: " + _settingState);
      }
      
      private function destroyState(param1:AbstractState) : void
      {
         var _loc3_:* = undefined;
         if(StateType.HOME.name == param1.stateName)
         {
            return;
         }
         log("destroyState ->  callingState: " + param1 + "\n_states: " + _states);
         var _loc2_:uint = 0;
         while(_loc2_ < _states.length)
         {
            if(_states[_loc2_].stateName == param1.stateName)
            {
               _loc3_ = _states.splice(_loc2_,1);
               if(null != param1.parent)
               {
                  param1.parent.removeChild(param1);
               }
               deferStateDestruction(param1);
               startStateDestructionDeferralTimer();
            }
            _loc2_++;
         }
      }
      
      private function onLoadQuicktipsEvent(param1:LoadQuicktipsEvent) : void
      {
         loadQuickTips(param1.quicktipsUrl);
      }
      
      public function toggleHelp(param1:Boolean) : void
      {
         if(param1 && _curHelp != null)
         {
            _helpHolder.addChild(_curHelp);
            _curHelpTarget.setHelpHandler(_curHelpHandler);
         }
         else if(Boolean(_helpHolder.numChildren))
         {
            _helpHolder.removeChildAt(0);
            _curHelpTarget.setHelpHandler(null);
            if(null != _curHelpHandler)
            {
               _curHelpHandler.destroy();
            }
         }
         _helpHolder.visible = param1;
      }
      
      public function handleBattleNow(... rest) : void
      {
         log("going to Battle Now");
      }
      
      public function transitionToState(param1:StateType) : void
      {
         var stateType:StateType = param1;
         if(getStateByName(stateType.name) == null)
         {
            log("StateManager.setState::state not loaded.  Loading state: " + stateType.name);
            _settingState = stateType;
            _stateLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleStateLoaderComplete,false,0,true);
            _stateLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleStateLoaderError,false,0,true);
            _stateLoader.loadState(stateType.url,_defaultStateLoadTarget);
            return;
         }
         log("StateManager.setState::state loaded.  Switching to state: " + stateType.name);
         _previousState = _state;
         if(_previousState != null)
         {
            log("unsetting " + _previousState);
            _previousState.onUnsetState();
            destroyState(_previousState);
         }
         _state = getStateByName(stateType.name);
         _defaultStateLoadTarget.addChild(_state);
         try
         {
            _defaultStateLoadTarget.setChildIndex(_state,_defaultStateLoadTarget.numChildren - 1);
         }
         catch(e:Error)
         {
            try
            {
               logError("could not set child index for " + stateType + ":\n" + e.message + "\nParent of current child is: " + _state.parent);
            }
            catch(e:Error)
            {
               logError("could not log error: " + e.message);
            }
         }
         if(!_state.isInitialized)
         {
            _stateInitializer.initializeState(stateType,_state,_setStateArguments.stateData);
         }
         _state.onSetState();
         _settingState = null;
         if(_widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
         {
            _widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)["setStateButton"](stateType);
         }
         if(_previousState != getStateByName(StateType.LOGIN.name))
         {
            setUPCounts(StateType.getStateTypeByName(_state.stateName));
            _transitionManager.finishTransition();
         }
         else
         {
            handleTransitionComplete();
         }
         setQuickTipsButton();
      }
      
      public function get isActive() : Boolean
      {
         if(_gameOptionsInView)
         {
            return true;
         }
         if(_quickTipsInView)
         {
            return true;
         }
         return false;
      }
      
      public function handleLogout(... rest) : void
      {
         log("Logging out");
      }
      
      private function getQuickTipsURL() : String
      {
         var _loc1_:String = null;
         if(getStateByName(state) != null)
         {
            _loc1_ = StateType.getStateTypeByName(state).quickTipsURL;
            if(getStateByName(state).getQuicktipsURL() != _loc1_ && getStateByName(state).getQuicktipsURL() != null)
            {
               _loc1_ = getStateByName(state).getQuicktipsURL();
            }
         }
         return _loc1_;
      }
      
      public function handleGameOptionsToggleHelp(param1:Boolean) : void
      {
         toggleHelp(param1);
      }
      
      private function deferStateDestruction(param1:AbstractState) : void
      {
         if(_deferredStatesToDestroy[param1] != null)
         {
            return;
         }
         log("deferStateDestruction(): state = " + param1.stateName);
         _deferredStatesToDestroy[param1] = param1;
      }
      
      public function handleTransitionComplete() : void
      {
         if(_state != null)
         {
            _state.onTransitionInComplete();
         }
         _transitionInView = false;
      }
   }
}

