package com.arkadium.virmon.gameengine
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.WebClientManager;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.FileEncryptorChainLoadee;
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.gameengine.blocker.GameEngineUIBlocker;
   import com.arkadium.virmon.gameengine.buytokens.GameEngineBuyTokens;
   import com.arkadium.virmon.gameengine.dialog.GameEngineDialogUIController;
   import com.arkadium.virmon.gameengine.loadees.BuddyManagerInitializerLoadee;
   import com.arkadium.virmon.gameengine.loadees.BuddyPersistConnLoadee;
   import com.arkadium.virmon.gameengine.loadees.BuddyRPManagerInitializerLoadee;
   import com.arkadium.virmon.gameengine.stateinitializer.GameEngineStateManagerInitializer;
   import com.arkadium.virmon.gameengine.widgetinitializer.GameEngineWidgetLoader;
   import com.arkadium.virmon.help.HelpComponentsLoader;
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.musicmanager.IMusicManager;
   import com.arkadium.virmon.shared.breadcrumb.BreadcrumbProgressManager;
   import com.arkadium.virmon.shared.data.AssetListLoader;
   import com.arkadium.virmon.shared.data.EvoDataLoader;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.PermissionsManager;
   import com.arkadium.virmon.shared.data.TreeNamesLoader;
   import com.arkadium.virmon.shared.elements.ElementsLoader;
   import com.arkadium.virmon.shared.final.FinalComponentsLoader;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IDownloader;
   import com.arkadium.virmon.shared.utils.URLAssetChainLoadee;
   import com.arkadium.virmon.shared.utils.chainloadees.AnalyticsActionLoadee;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.arkadium.virmon.state.widgetmanager.WidgetInitializer;
   import com.arkadium.virmon.state.widgetmanager.WidgetManager;
   import com.arkadium.virmon.wrapper.BuyTokens;
   import com.arkadium.virmon.wrapper.Dialog;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.arkadium.virmon.wrapper.IBuyNanocashUIManager;
   import com.arkadium.virmon.wrapper.IDialogUIController;
   import com.arkadium.virmon.wrapper.SharedClassDeclarations;
   import com.arkadium.virmon.wrapper.statepackagestatusupdater.IStatePackageStatusUpdater;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.IEventDispatcher;
   
   public class GameEngine extends Sprite implements IGameEngine, IChainLoaderConsumer
   {
      
      private static const WIDTH:int = 1024;
      
      private static const HEIGHT:int = 768;
      
      private var _gameEngineWidgetLoader:GameEngineWidgetLoader;
      
      public var mcBuyTokens:BuyTokens;
      
      private var _consumer:IGameEngineInitializedHandler;
      
      private var _stateManagerInitializer:GameEngineStateManagerInitializer;
      
      private var _sharedClassDeclarations:SharedClassDeclarations;
      
      private var _chainLoader:ChainLoader;
      
      private var _dialogUIController:IDialogUIController;
      
      public var mcDialog:Dialog;
      
      public function GameEngine()
      {
         super();
         _sharedClassDeclarations = new SharedClassDeclarations();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameEngine>>\t" + param1);
      }
      
      public function get sprite() : Sprite
      {
         return this as Sprite;
      }
      
      private function createAndAddLayer(param1:Boolean = false) : Sprite
      {
         var _loc3_:Sprite = null;
         var _loc2_:Sprite = new Sprite();
         _loc2_.mouseEnabled = false;
         this.addChild(_loc2_);
         if(param1)
         {
            _loc3_ = new Sprite();
            _loc3_.graphics.beginFill(16711680,0);
            _loc3_.graphics.drawRect(0,0,WIDTH,HEIGHT);
            _loc3_.graphics.endFill();
            _loc3_.mouseEnabled = false;
            _loc2_.mask = _loc3_;
         }
         return _loc2_;
      }
      
      public function init(param1:IDownloader, param2:IEventDispatcher, param3:IUserProfile, param4:IMusicManager, param5:IMDMManager, param6:IServiceRequestBrokerManager, param7:WebClientManager, param8:IHomeBreadcrumbUIManager, param9:IApplicationExiter, param10:IStatePackageStatusUpdater, param11:IGameEngineInitializedHandler) : void
      {
         _consumer = param11;
         var _loc12_:IBuyNanocashUIManager = new GameEngineBuyTokens(param2,mcBuyTokens,param5,param6,param7,param3);
         var _loc13_:GameEngineUIBlocker = new GameEngineUIBlocker(param2,WIDTH,HEIGHT);
         _dialogUIController = new GameEngineDialogUIController(param2,mcDialog,param5,param8);
         Managers.buyNanocashUIManager = _loc12_;
         var _loc14_:Sprite = createAndAddLayer(true);
         var _loc15_:Sprite = createAndAddLayer(true);
         var _loc16_:Sprite = createAndAddLayer();
         var _loc17_:Sprite = createAndAddLayer();
         var _loc18_:Sprite = createAndAddLayer();
         var _loc19_:Sprite = createAndAddLayer();
         this.addChild(mcBuyTokens);
         this.addChild(mcDialog);
         this.addChild(_loc13_);
         var _loc20_:IWidgetManager = new WidgetManager(_loc15_);
         Managers.widgetManager = _loc20_;
         _stateManagerInitializer = new GameEngineStateManagerInitializer(param1,param9,_loc14_,_loc20_,_loc19_,_loc17_,_loc18_,param4,_loc16_);
         _loc20_.setWidgetInitializer(new WidgetInitializer(GameServiceProvider.getInstance().userGameService,GameServiceProvider.getInstance().battleGameService,param3,Managers.stateManager,Managers.analyticsManager,param8,Managers.breadcrumbProgressManager,Managers.assetRetrieverManager.avatarAssetRetriever,param10,_loc19_));
         _gameEngineWidgetLoader = new GameEngineWidgetLoader(_loc20_);
         loadChain();
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         Managers.breadcrumbProgressManager = new BreadcrumbProgressManager(Managers.storedSettingsManager,UserProfile.getInstance().screenname);
         var _loc2_:IStateManager = param1.getLoadedAsset(GameEngineStateManagerInitializer.NAME) as IStateManager;
         _chainLoader.destroy();
         _chainLoader = null;
         if(null != _consumer)
         {
            _consumer.handleGameEngineInitialized(_loc2_);
         }
      }
      
      private function loadChain() : void
      {
         log("handleGameServicesInitialized()");
         PermissionsManager.getInstance().setUserProfile(UserProfile.getInstance());
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         var _loc2_:IAssetRetrieverManager = Managers.assetRetrieverManager;
         var _loc3_:IMasterDataAssetRetriever = _loc2_.masterDataAssetRetriever;
         _loc1_.add(new URLAssetChainLoadee(_loc3_.getMasterDataURL(MasterDataAssetType.NANOVOR).url));
         _loc1_.add(new URLAssetChainLoadee(_loc3_.getMasterDataURL(MasterDataAssetType.EM).url));
         _loc1_.add(new URLAssetChainLoadee(_loc3_.getMasterDataURL(MasterDataAssetType.BADGE).url));
         _loc1_.add(new FileEncryptorChainLoadee(_loc3_.getMasterDataURL(MasterDataAssetType.NANOVOR).url));
         _loc1_.add(new AnalyticsActionLoadee(Action.LOGIN_MASTER_DATA_LOADED));
         _loc1_.add(new AssetListLoader(Managers.serviceRequestBrokerManager.getAssetListURL(),Managers.analyticsManager));
         _loc1_.add(new AnalyticsActionLoadee(Action.LOGIN_BANK_ASSET_DATA_LOADED));
         _loc1_.add(new EvoDataLoader(Managers.serviceRequestBrokerManager.bankURLRead + "/bankfe/resources/evolution?auth=" + Managers.serviceRequestBrokerManager.getLoginToken() + "&nocache=" + new Date().getTime()));
         _loc1_.add(UserProfile.getInstance());
         _loc1_.add(new BuddyPersistConnLoadee(GameServiceProvider.getInstance().buddyListGameService,GameServiceProvider.getInstance().userGameService));
         _loc1_.add(new BuddyManagerInitializerLoadee(Managers.analyticsManager));
         _loc1_.add(new BuddyRPManagerInitializerLoadee());
         _loc1_.add(PermissionsManager.getInstance());
         _loc1_.add(new TreeNamesLoader());
         _loc1_.add(new ElementsLoader());
         _loc1_.add(new FinalComponentsLoader());
         _loc1_.add(new HelpComponentsLoader());
         _loc1_.add(_stateManagerInitializer);
         _loc1_.add(_gameEngineWidgetLoader);
         _chainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
   }
}

