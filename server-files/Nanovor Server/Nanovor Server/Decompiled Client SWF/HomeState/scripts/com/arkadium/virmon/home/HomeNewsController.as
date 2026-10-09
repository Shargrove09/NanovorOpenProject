package com.arkadium.virmon.home
{
   import caurina.transitions.Tweener;
   import com.arkadium.communications.WebClientManager;
   import com.arkadium.virmon.shared.breadcrumb.Breadcrumb;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.mdm.MDMBrowserController;
   import com.arkadium.virmon.shared.mdm.MDMBrowserKey;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class HomeNewsController
   {
      
      private var _loadedPartBanner:Boolean = false;
      
      private var _newsLoadStatus:MovieClip = null;
      
      private var _webClientManager:WebClientManager;
      
      private var _newsNotAvailable:Boolean = false;
      
      private var _widgetManager:IWidgetManager;
      
      private var _bannerHolder:MovieClip = null;
      
      private var _breadcrumb:Breadcrumb;
      
      private var _loaded:Boolean = false;
      
      private var _browser:MDMBrowserController;
      
      private var _loadedPartBrowser:Boolean = false;
      
      private var _mdmManager:IMDMManager;
      
      private var _homeBreadcrumbUIManager:IHomeBreadcrumbUIManager;
      
      private var _bannerLoader:Loader;
      
      public function HomeNewsController(param1:IMDMManager, param2:WebClientManager, param3:IWidgetManager, param4:IHomeBreadcrumbUIManager, param5:Breadcrumb)
      {
         super();
         _mdmManager = param1;
         _webClientManager = param2;
         _widgetManager = param3;
         _homeBreadcrumbUIManager = param4;
         if(param5 == null)
         {
            logError("HomeNewsController(): newsBreadcrumb cannot be null!\n" + new Error("STACK TRACE").getStackTrace());
            return;
         }
         _breadcrumb = param5;
         if(_breadcrumb.mcContent != null)
         {
            if(_breadcrumb.mcContent.mcNoNewsAvailable != null)
            {
               _newsNotAvailable = true;
               return;
            }
            _newsNotAvailable = false;
            log("constructor: _newsNotAvailable = " + _newsNotAvailable);
            if(_breadcrumb.mcContent.mcFooterHolder != null)
            {
               _bannerHolder = _breadcrumb.mcContent.mcFooterHolder;
            }
            if(_breadcrumb.mcContent.mcNewsLoadStatus != null)
            {
               _newsLoadStatus = _breadcrumb.mcContent.mcNewsLoadStatus;
               _newsLoadStatus.cacheAsBitmap = true;
               _newsLoadStatus.visible = false;
               _newsLoadStatus.alpha = 0;
            }
         }
      }
      
      public function hide() : void
      {
         if(Boolean(_browser))
         {
            _browser.visible = false;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> HomeNewsController: " + param1);
      }
      
      private function startNewsLoadStatusFadeLoop() : void
      {
         Tweener.removeTweens(_newsLoadStatus);
         if(_newsLoadStatus == null)
         {
            return;
         }
         if(_loadedPartBrowser)
         {
            return;
         }
         Tweener.addTween(_newsLoadStatus,{
            "_autoAlpha":1,
            "time":0.5,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(_newsLoadStatus,{
            "_autoAlpha":0,
            "time":0.5,
            "delay":0.5,
            "transition":"easeInQuad",
            "onComplete":startNewsLoadStatusFadeLoop
         });
      }
      
      private function onBannerLoadError(param1:IOErrorEvent) : void
      {
         var e:IOErrorEvent = param1;
         _bannerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBannerLoaded);
         _bannerLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onBannerLoadError);
         try
         {
            _bannerLoader.unload();
         }
         catch(e:*)
         {
         }
         _bannerLoader = null;
         logError("FAILED TO LOAD BANNER: " + e.text);
         _loadedPartBanner = true;
         onLoadPartsComplete();
      }
      
      private function onBannerLoaded(param1:Event) : void
      {
         _bannerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBannerLoaded);
         _bannerLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onBannerLoadError);
         if(_bannerHolder != null)
         {
            _bannerHolder.addChild(_bannerLoader);
         }
         else
         {
            logError("onBannerLoaded: banner loaded but _bannerHolder == null! ... breadcrumb children:\n" + Utils.ChildrenToString(_breadcrumb));
         }
         _loadedPartBanner = true;
         onLoadPartsComplete();
      }
      
      private function loadParts() : void
      {
         if(_loaded)
         {
            onLoadPartsComplete();
            return;
         }
         _loaded = true;
         _loadedPartBanner = false;
         _loadedPartBrowser = false;
         startNewsLoadStatusFadeLoop();
         var _loc1_:String = _webClientManager.getWebClientHookUrl("news");
         var _loc2_:String = _webClientManager.getWebClientHookUrl("news-banner");
         _browser = new MDMBrowserController(_mdmManager,MDMBrowserKey.HOME_NEWS,371,162,653,458,_loc1_,false,true);
         _browser.visible = false;
         _browser.onDocumentComplete = onBrowserLoaded;
         _mdmManager.registerBrowserController(_browser);
         loadBanner(_loc2_);
      }
      
      private function onLoadPartsComplete() : void
      {
         if(!_loadedPartBanner)
         {
            return;
         }
         if(!_loadedPartBrowser)
         {
            return;
         }
         var _loc1_:IAutoBattleWidget = _widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) as IAutoBattleWidget;
         if(_homeBreadcrumbUIManager.isNewsBlockerActive)
         {
            _mdmManager.pushFakeBrowserState(_browser.browserKey,{"visible":true});
         }
         else
         {
            _browser.visible = true;
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** HomeNewsController: " + param1);
      }
      
      private function loadBanner(param1:String) : void
      {
         _bannerLoader = new Loader();
         _bannerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBannerLoaded,false,0,true);
         _bannerLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onBannerLoadError,false,0,true);
         _bannerLoader.load(new URLRequest(param1));
      }
      
      private function onBrowserLoaded(param1:Object) : void
      {
         _browser.onDocumentComplete = null;
         _loadedPartBrowser = true;
         onLoadPartsComplete();
      }
      
      public function destroy() : void
      {
         unload();
         _bannerHolder = null;
         _newsLoadStatus = null;
      }
      
      public function show() : void
      {
         if(_newsNotAvailable)
         {
            return;
         }
         loadParts();
      }
      
      public function unload() : void
      {
         if(!_loaded)
         {
            return;
         }
         _loaded = false;
         if(_browser != null)
         {
            _browser.close();
            _mdmManager.unregisterBrowserController(_browser);
            _browser = null;
         }
         if(_bannerLoader != null)
         {
            if(_bannerHolder != null && _bannerHolder.contains(_bannerLoader))
            {
               _bannerHolder.removeChild(_bannerLoader);
            }
            try
            {
               _bannerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBannerLoaded);
               _bannerLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onBannerLoadError);
               Utils.clearAllChildren(_bannerLoader);
               _bannerLoader.unload();
            }
            catch(e:Error)
            {
            }
            _bannerLoader = null;
         }
         if(_newsLoadStatus != null)
         {
            Tweener.removeTweens(_newsLoadStatus);
            _newsLoadStatus.visible = false;
            _newsLoadStatus.alpha = 0;
         }
      }
   }
}

