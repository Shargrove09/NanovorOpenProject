package com.arkadium.virmon.wrapper.controller
{
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.wrapper.model.IGameEngineModel;
   import com.arkadium.virmon.wrapper.model.UserType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class GameEngineController implements IGameEngineController
   {
      
      private var _requiredAssetsDownloadComplete:Boolean;
      
      private var _assetRetrieverManager:IAssetRetrieverManager;
      
      private var _model:IGameEngineModel;
      
      private var _controller:IGameEngineNestedController;
      
      public function GameEngineController(param1:IGameEngineModel)
      {
         super();
         _model = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> GameEngineController: " + param1);
      }
      
      public function handleGameServiceLoginComplete() : void
      {
         log("handleGameServiceLoginComplete()");
         _controller.handleGameServiceLoginComplete();
      }
      
      public function handleRequiredAssetsDownloadComplete() : void
      {
         log("handleRequiredAssetsDownloadComplete()");
         if(_controller == null)
         {
            _requiredAssetsDownloadComplete = true;
            return;
         }
         _controller.handleRequiredAssetsDownloadComplete();
      }
      
      public function handleUserTypeResponse(param1:UserType) : void
      {
         log("handleUserTypeResponse(): userType: " + param1);
         if(UserType.NEW_USER == param1)
         {
            _controller = new GameEngineNewUserController(_model);
         }
         else
         {
            _controller = new GameEngineExistingUserController(_model);
         }
         if(_requiredAssetsDownloadComplete)
         {
            handleRequiredAssetsDownloadComplete();
         }
      }
      
      public function handleGameEngineInitialized(param1:IStateManager) : void
      {
         log("handleGameEngineInitialized()");
         _model.requestUserType();
      }
      
      public function handleAllAssetManifestsLoaded(param1:IAssetRetrieverManager) : void
      {
         log("handleAllAssetManifestsLoaded()");
         _assetRetrieverManager = param1;
         _model.loadGameService();
      }
      
      public function handleGameServicesInitialized() : void
      {
         log("handleGameServicesInitialized()");
         _model.loadGameEngine(_assetRetrieverManager);
      }
   }
}

