package com.arkadium.virmon.gameengine.stateinitializer
{
   import com.arkadium.virmon.musicmanager.IMusicManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.ui.gameOptions.ICGameOptions;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.state.StateManager;
   import com.arkadium.virmon.state.initializer.IStateInitializer;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.transitions.TransitionManager;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class GameEngineStateManagerInitializer implements IChainLoadee, IChainLoaderConsumer
   {
      
      public static const NAME:String = "GameEngineStateManagerInitializer";
      
      private static const GENERIC_TRANSITION:String = "GenericTransition.swf";
      
      private static const GAME_OPTIONS:String = "gameOptions.swf";
      
      private static const STATE_INITIALIZER:String = "StateInitializer.swf";
      
      private var _downloader:IDownloader;
      
      private var _externalChainLoader:IChainLoader;
      
      private var _transitionsLayer:Sprite;
      
      private var _internalChainLoader:ChainLoader;
      
      private var _stateManager:StateManager;
      
      public function GameEngineStateManagerInitializer(param1:IDownloader, param2:IApplicationExiter, param3:Sprite, param4:IWidgetManager, param5:Sprite, param6:Sprite, param7:Sprite, param8:IMusicManager, param9:Sprite)
      {
         super();
         _downloader = param1;
         _stateManager = new StateManager(param2,param3,param4,param5,param6,param7,param8);
         Managers.stateManager = _stateManager;
         _transitionsLayer = param9;
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         var _loc2_:MovieClip = param1.getLoadedAsset(SWFLoadee.NAME + GENERIC_TRANSITION) as MovieClip;
         var _loc3_:ICGameOptions = param1.getLoadedAsset(SWFLoadee.NAME + GAME_OPTIONS) as ICGameOptions;
         var _loc4_:IStateInitializer = param1.getLoadedAsset(SWFLoadee.NAME + STATE_INITIALIZER) as IStateInitializer;
         _internalChainLoader.destroy();
         _internalChainLoader = null;
         _stateManager.init(new TransitionManager(_transitionsLayer,_loc2_),_loc3_,_loc4_,_downloader);
         _externalChainLoader.handleChainLoadeeComplete(_stateManager);
      }
      
      public function load() : void
      {
         log("load()");
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new SWFLoadee(GENERIC_TRANSITION,_loc1_));
         _loc2_.add(new SWFLoadee(GAME_OPTIONS,_loc1_));
         _loc2_.add(new SWFLoadee(STATE_INITIALIZER,_loc1_));
         _internalChainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _internalChainLoader.load();
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _externalChainLoader = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameEngineStateManagerInitializer>>\t" + param1);
      }
   }
}

