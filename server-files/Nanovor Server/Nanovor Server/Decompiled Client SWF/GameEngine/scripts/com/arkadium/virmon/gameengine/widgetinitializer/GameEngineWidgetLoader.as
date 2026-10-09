package com.arkadium.virmon.gameengine.widgetinitializer
{
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class GameEngineWidgetLoader implements IChainLoadee, IChainLoaderConsumer
   {
      
      private static const WIDGET_TO_LOAD:Array = [WidgetType.WIDGET_HEADER];
      
      private var _externalChainLoader:IChainLoader;
      
      private var _widgetManager:IWidgetManager;
      
      private var _internalChainLoader:ChainLoader;
      
      public function GameEngineWidgetLoader(param1:IWidgetManager)
      {
         super();
         _widgetManager = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameEngineWidgetLoader>>\t" + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc2_:WidgetType = null;
         var _loc3_:IWidget = null;
         log("handleChainLoaderComplete()");
         for each(_loc2_ in WIDGET_TO_LOAD)
         {
            _loc3_ = param1.getLoadedAsset(SWFLoadee.NAME + _loc2_.url) as IWidget;
            if(null != _loc3_)
            {
               _widgetManager.addLoadedWidget(_loc2_,_loc3_);
            }
         }
         _internalChainLoader.destroy();
         _internalChainLoader = null;
         _externalChainLoader.handleChainLoadeeComplete();
      }
      
      public function load() : void
      {
         var _loc3_:WidgetType = null;
         log("load()");
         var _loc1_:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         for each(_loc3_ in WIDGET_TO_LOAD)
         {
            _loc2_.add(new SWFLoadee(_loc3_.url,_loc1_));
         }
         _internalChainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _internalChainLoader.load();
      }
      
      public function get name() : String
      {
         return "GameEngineWidgetLoader";
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _externalChainLoader = param1;
      }
   }
}

