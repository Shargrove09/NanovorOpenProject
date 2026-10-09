package com.arkadium.virmon.state.widgetmanager
{
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.chainloadees.SWFLoadee;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.IWidgetLoadedHandler;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   
   public class WidgetManager implements IWidgetManager, IChainLoaderConsumer
   {
      
      private var _widgetLoadedHandlers:Dictionary;
      
      private var _widgetLoading:Array;
      
      private var _loaderContext:LoaderContext;
      
      private var _widgetContainer:DisplayObjectContainer;
      
      private const _WIDGET_UI_ORDER:Array = [WidgetType.WIDGET_MEGA_WIDGET,WidgetType.WIDGET_HEADER,WidgetType.WIDGET_AUTO_BATTLE,WidgetType.WIDGET_CHAT,WidgetType.WIDGET_AVATAR];
      
      private var _widgetQueue:Array;
      
      private var _widgets:Dictionary;
      
      private var _chainLoader:IChainLoader;
      
      private var _widgetInitializer:IWidgetInitializer;
      
      public function WidgetManager(param1:DisplayObjectContainer)
      {
         super();
         if(null == param1)
         {
            throw new Error("WidgetContainer is null");
         }
         _widgetContainer = param1;
         _widgetLoadedHandlers = new Dictionary();
         _widgets = new Dictionary();
         _widgetQueue = new Array();
         _widgetLoading = new Array();
         _loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
      }
      
      public function addWidgetLoadedHandler(param1:WidgetType, param2:IWidgetLoadedHandler) : void
      {
         if(_widgetLoadedHandlers[param1] == null)
         {
            _widgetLoadedHandlers[param1] = new Dictionary(true);
         }
         _widgetLoadedHandlers[param1][param2] = param2;
      }
      
      public function setWidgetInitializer(param1:IWidgetInitializer) : void
      {
         _widgetInitializer = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<WidgetManager>>\t" + param1);
      }
      
      private function checkIfWidgetIsLoadingOrLoaded(param1:WidgetType) : Boolean
      {
         if(null != _widgets[param1.name])
         {
            return true;
         }
         if(-1 != _widgetLoading.indexOf(param1))
         {
            return true;
         }
         if(-1 != _widgetQueue.indexOf(param1))
         {
            return true;
         }
         return false;
      }
      
      public function loadWidget(param1:WidgetType) : void
      {
         if(null == param1)
         {
            return;
         }
         if(checkIfWidgetIsLoadingOrLoaded(param1))
         {
            return;
         }
         _widgetQueue.push(param1);
         processQueue();
      }
      
      public function addWidget(param1:WidgetType) : void
      {
         var _loc2_:DisplayObject = _widgets[param1.name] as DisplayObject;
         if(null != _loc2_)
         {
            log("addWidget() - adding widget");
            _widgetContainer.addChild(_loc2_);
         }
         reorderWidgets();
      }
      
      public function getWidgetByName(param1:String) : IWidget
      {
         return _widgets[param1];
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc2_:WidgetType = null;
         var _loc3_:IWidget = null;
         log("handleChainLoaderComplete() - Done loading queue of widgets.  Length: " + _widgetLoading.length);
         for each(_loc2_ in _widgetLoading)
         {
            _loc3_ = param1.getLoadedAsset(SWFLoadee.NAME + _loc2_.url) as IWidget;
            _widgetContainer.addChild(_loc3_ as DisplayObject);
            _widgets[_loc2_.name] = _loc3_;
            _widgetInitializer.initializeWidget(_loc2_,_loc3_);
            dispatchWidgetLoadHandlers(_loc2_,_loc3_);
         }
         reorderWidgets();
         _chainLoader.destroy();
         _chainLoader = null;
         processQueue();
      }
      
      public function removeWidget(param1:WidgetType) : void
      {
         var _loc2_:DisplayObject = _widgets[param1.name] as DisplayObject;
         if(null != _loc2_ && null != _loc2_.parent)
         {
            log("removeWidget() - Removing the widget");
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      private function processQueue() : void
      {
         var _loc1_:ChainLoadeeList = null;
         var _loc2_:WidgetType = null;
         if(null == _chainLoader && _widgetQueue.length > 0)
         {
            _loc1_ = new ChainLoadeeList();
            for each(_loc2_ in _widgetQueue)
            {
               _loc1_.add(new SWFLoadee(_loc2_.url,_loaderContext));
            }
            _chainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
            _chainLoader.load();
            _widgetLoading = _widgetQueue;
            _widgetQueue = new Array();
         }
      }
      
      private function dispatchWidgetLoadHandlers(param1:WidgetType, param2:IWidget) : void
      {
         var _loc3_:IWidgetLoadedHandler = null;
         if(null != _widgetLoadedHandlers[param1])
         {
            for each(_loc3_ in _widgetLoadedHandlers[param1])
            {
               log("handleChainLoaderComplete() - calling widgetLoadedHandler");
               _loc3_.handleWidgetLoaded(param2);
            }
         }
      }
      
      public function addLoadedWidget(param1:WidgetType, param2:IWidget) : void
      {
         log("addLoadedWidget()");
         _widgetContainer.addChild(param2 as DisplayObject);
         _widgets[param1.name] = param2;
         _widgetInitializer.initializeWidget(param1,param2);
         reorderWidgets();
         dispatchWidgetLoadHandlers(param1,param2);
      }
      
      private function reorderWidgets() : void
      {
         var _loc1_:WidgetType = null;
         var _loc2_:DisplayObject = null;
         for each(_loc1_ in _WIDGET_UI_ORDER)
         {
            _loc2_ = _widgets[_loc1_.name] as DisplayObject;
            if(null != _loc2_ && _widgetContainer.contains(_loc2_))
            {
               _widgetContainer.addChild(_loc2_);
            }
         }
      }
   }
}

