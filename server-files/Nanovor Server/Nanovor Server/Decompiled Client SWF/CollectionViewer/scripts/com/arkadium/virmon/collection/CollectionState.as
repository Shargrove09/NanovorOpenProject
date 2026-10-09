package com.arkadium.virmon.collection
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.collection.shared.CollectionViewerDataHandler;
   import com.arkadium.virmon.collection.substates.nanovor.ICollectionPreSelectData;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.substate.ISubStateController;
   import com.arkadium.virmon.shared.utils.substate.SubStateController;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   
   public class CollectionState extends AbstractState implements ICollectionState
   {
      
      private var _dataHandler:CollectionViewerDataHandler;
      
      public var selectedEM:MovieClip;
      
      public var selectedNanovor:MovieClip;
      
      private var _preSelectedNanovor:ICollectionPreSelectData;
      
      private var _headerWidget:IWidget;
      
      private var _subStateChanger:CollectionSubStateChanger;
      
      private var _collectionSubStateFactory:CollectionSubStateFactory;
      
      private var _userProfile:IUserProfile;
      
      private var _analyticsManager:IAnalyticsManager;
      
      public var btnTempNanovor:SimpleButton;
      
      private var _stateManager:IStateManager;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _tempNextStateType:StateType;
      
      private var _autoBattleWidget:IAutoBattleWidget;
      
      private var _subStateController:ISubStateController;
      
      private var _subStateContainer:Sprite;
      
      private var _chatWidget:IWidget;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      public var _trData:*;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      public var btnTempEM:SimpleButton;
      
      private var _soundManager:ISoundManager;
      
      public function CollectionState()
      {
         super();
         stateName = StateType.COLLECTION.name;
         btnTempNanovor.visible = false;
         btnTempEM.visible = false;
         selectedNanovor.visible = false;
         selectedEM.visible = false;
      }
      
      override public function destroy() : void
      {
         if(_collectionSubStateFactory != null)
         {
            _collectionSubStateFactory.destroy();
         }
         if(_subStateChanger != null)
         {
            _subStateChanger.destroy();
         }
         super.destroy();
      }
      
      private function handleExitCancelled(param1:Object) : void
      {
      }
      
      public function initialize(param1:Object, param2:ICharacterAssetRetriever, param3:INanovorFactory, param4:IPlayerFactory, param5:ISoundManager, param6:IUserProfile, param7:IServiceRequestBrokerManager, param8:IAnalyticsManager, param9:IWidget, param10:IWidget, param11:IAutoBattleWidget, param12:IStateManager, param13:IEvoManager, param14:IVirmonManager) : void
      {
         if(isInitialized)
         {
            return;
         }
         isInitialized = true;
         _characterAssetRetriever = param2;
         _nanovorFactory = param3;
         _playerFactory = param4;
         _soundManager = param5;
         _userProfile = param6;
         _serviceRequestBrokerManager = param7;
         _analyticsManager = param8;
         _headerWidget = param9;
         _chatWidget = param10;
         _autoBattleWidget = param11;
         _stateManager = param12;
         _quicktipsURL = Const.QUICKTIP_COLLECTION;
         _subStateChanger = new CollectionSubStateChanger(btnTempNanovor,btnTempEM,selectedNanovor,selectedEM);
         _subStateContainer = new Sprite();
         addChildAt(_subStateContainer,1);
         _dataHandler = new CollectionViewerDataHandler(param13,param14);
         log("COLLECTION state is technically initialized");
         _preSelectedNanovor = param1 as ICollectionPreSelectData;
         log("init() - StateData null? " + Boolean(null == param1));
         log("init() - PreSelectData null? " + Boolean(null == _preSelectedNanovor));
      }
      
      private function handleExitConfirmed(param1:Object) : void
      {
         _stateManager.setState(_tempNextStateType,null);
      }
      
      override public function onUnsetState() : void
      {
         _autoBattleWidget.hide();
      }
      
      public function setData(param1:*) : void
      {
         _trData = param1;
      }
      
      override public function onTransitionInComplete() : void
      {
         _collectionSubStateFactory = new CollectionSubStateFactory(_soundManager,_playerFactory.createMyPlayer(),_nanovorFactory,_subStateContainer,_userProfile,_serviceRequestBrokerManager,_analyticsManager,_dataHandler,_subStateChanger,_characterAssetRetriever);
         _subStateController = new SubStateController(_collectionSubStateFactory);
         log("COLLECTION state is now \"really\" being initialized");
         _analyticsManager.trackView(View.COLLECTION_LANDING);
         _subStateController.changeSubState(CollectionSubStateFactory.COLLECTION_SUBSTATE_NANOVOR,_preSelectedNanovor);
         _subStateChanger.onSubStateChange(CollectionSubStateFactory.COLLECTION_SUBSTATE_NANOVOR);
      }
      
      override public function onSetState() : void
      {
         _headerWidget.setMode(WidgetType.MODE_HOME);
         _chatWidget.setMode(WidgetType.MODE_HIDDEN);
         _autoBattleWidget.show();
      }
      
      public function get pendingChanges() : Boolean
      {
         if(_collectionSubStateFactory == null)
         {
            return false;
         }
         if(_collectionSubStateFactory.nanovorBuffController == null)
         {
            return false;
         }
         return _collectionSubStateFactory.nanovorBuffController.pendingChanges;
      }
      
      override public function attemptToLeaveState(param1:StateType, param2:Object = null) : Boolean
      {
         if(pendingChanges)
         {
            _tempNextStateType = param1;
            CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_ALERT,"UNSAVED CHANGES","You have made changes to your Nanovor\'s stats.  If you leave now, these changes will go unsaved.  Are you sure you want to exit?",0,handleExitConfirmed,handleExitCancelled);
            return false;
         }
         return true;
      }
   }
}

