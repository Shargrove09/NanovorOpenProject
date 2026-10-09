package com.arkadium.virmon.wrapper.view
{
   import com.arkadium.virmon.common.AbstractComponentView;
   import com.arkadium.virmon.downloadmanager.handlers.IAllAssetManifestsLoadedHandler;
   import com.arkadium.virmon.downloadmanager.handlers.IRequiredAssetDownloadsCompleteHandler;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.gameengine.IGameEngine;
   import com.arkadium.virmon.gameengine.IGameEngineInitializedHandler;
   import com.arkadium.virmon.gameengine.gameservice.IGameEngineGameServiceControllerConsumer;
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   import com.arkadium.virmon.loginpanel.IWaitPanel;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.wrapper.controller.IGameEngineController;
   import com.arkadium.virmon.wrapper.model.IGameEngineLoadCompleteHandler;
   import com.arkadium.virmon.wrapper.model.IGameEngineModel;
   import com.arkadium.virmon.wrapper.model.ILoginPanelLoadedHandler;
   import com.arkadium.virmon.wrapper.model.IToggleWaitScreenHandler;
   import com.arkadium.virmon.wrapper.model.IUserTypeResponseHandler;
   import com.arkadium.virmon.wrapper.model.UserType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   
   public class GameEngineView extends AbstractComponentView implements ILoginPanelLoadedHandler, IUserTypeResponseHandler, IAllAssetManifestsLoadedHandler, IRequiredAssetDownloadsCompleteHandler, IGameEngineLoadCompleteHandler, IGameEngineInitializedHandler, IGameEngineGameServiceControllerConsumer, IToggleWaitScreenHandler
   {
      
      private var _model:IGameEngineModel;
      
      private var _loginPanel:ILoginPanel;
      
      private var _controller:IGameEngineController;
      
      public function GameEngineView(param1:IGameEngineModel, param2:IGameEngineController)
      {
         super();
         _model = param1;
         _model.addGameEngineLoadCompleteHandler(IGameEngineLoadCompleteHandler(this));
         _model.addGameEngineInitializedHandler(IGameEngineInitializedHandler(this));
         _model.addGameServiceLoadHandler(IGameEngineGameServiceControllerConsumer(this));
         _model.addUserTypeResponseHandler(IUserTypeResponseHandler(this));
         _model.addToggleWaitScreenHandler(IToggleWaitScreenHandler(this));
         _controller = param2;
      }
      
      public function handleGameServicesInitialized() : void
      {
         log("handleGameServicesInitialized()");
         _controller.handleGameServicesInitialized();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameEngineView>> " + param1);
      }
      
      public function handleLoginPanelLoaded(param1:ILoginPanel, param2:IWaitPanel) : void
      {
         log("handleLoginPanelLoaded()");
         _loginPanel = param1;
      }
      
      override public function destroy() : void
      {
      }
      
      public function handleGameEngineLoadComplete(param1:IGameEngine) : void
      {
         log("handleGameEngineLoadComplete()");
         addChild(param1.sprite);
         addChild(_loginPanel.sprite);
      }
      
      public function handleUserTypeResponse(param1:UserType) : void
      {
         log("handleUserTypeResponse(): " + param1);
         _controller.handleUserTypeResponse(param1);
      }
      
      public function handleRequiredAssetDownloadsComplete() : void
      {
         log("handleRequiredAssetDownloadsComplete()");
         _controller.handleRequiredAssetsDownloadComplete();
      }
      
      public function handleGameServiceLoginError(param1:String) : void
      {
         logError("handleGameServiceLoginError(): message: " + param1);
      }
      
      public function handleGameEngineInitialized(param1:IStateManager) : void
      {
         _controller.handleGameEngineInitialized(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>GameEngineView<< " + param1);
      }
      
      public function handleGameServiceLoginComplete() : void
      {
         log("handleGameServiceLoginComplete()");
         _controller.handleGameServiceLoginComplete();
      }
      
      private function handleLoginPanelFadeOutComplete() : void
      {
         if(null != _loginPanel.sprite.parent)
         {
            _loginPanel.sprite.parent.removeChild(_loginPanel.sprite);
         }
         _loginPanel.sprite.alpha = 1;
      }
      
      public function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void
      {
         log("handleAllAssetManifestsLoaded()");
         _controller.handleAllAssetManifestsLoaded(param1);
      }
      
      public function handleToggleWaitScreen(param1:Boolean) : void
      {
         var _loc2_:Sprite = _loginPanel.sprite;
         if(param1)
         {
            this.addChild(_loc2_);
         }
         else if(null != _loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      public function handleGoToHomeState() : void
      {
      }
   }
}

