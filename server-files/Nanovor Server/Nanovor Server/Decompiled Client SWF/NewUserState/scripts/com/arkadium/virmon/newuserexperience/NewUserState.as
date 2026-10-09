package com.arkadium.virmon.newuserexperience
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.IAssetRetrieverManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.newuserexperience.substates.NewUserSubStateFactory;
   import com.arkadium.virmon.newuserexperience.substates.NewUserSubStates;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.substate.SubStateController;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import flash.display.Sprite;
   
   public class NewUserState extends AbstractState implements INewUserState, INewUserStateCompleteHandler
   {
      
      private var _widgetManager:IWidgetManager;
      
      private var _subStateController:SubStateController;
      
      private var _subStateFactory:NewUserSubStateFactory;
      
      private var _consumer:INewUserStateConsumer;
      
      private var _headerWidget:IHeaderWidget;
      
      private var _userProfile:IUserProfile;
      
      private var _assetRetrieverManager:IAssetRetrieverManager;
      
      private var _stateManager:IStateManager;
      
      public function NewUserState()
      {
         super();
         stateName = StateType.NEWUSER.name;
         _quicktipsURL = "";
      }
      
      override public function onSetState() : void
      {
         _headerWidget.setMode(WidgetType.MODE_BATTLE);
         _headerWidget.hideLeaveBattle();
         var _loc1_:IWidget = _widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name) as IWidget;
         var _loc2_:IAutoBattleWidget = _widgetManager.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) as IAutoBattleWidget;
         if(null != _loc1_)
         {
            _loc1_.setMode(WidgetType.MODE_HIDDEN);
         }
         if(null != _loc2_)
         {
            _loc2_.hide();
         }
      }
      
      public function initialize(param1:ISoundManager, param2:IPlayerFactory, param3:INanovorFactory, param4:IUserProfile, param5:IMasterDataAssetRetriever, param6:IOverlayAssetRetriever, param7:ICharacterAssetRetriever, param8:IWidgetManager, param9:IVirmonManager, param10:IStateManager) : void
      {
         isInitialized = true;
         _userProfile = param4;
         _widgetManager = param8;
         _headerWidget = _widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) as IHeaderWidget;
         _stateManager = param10;
         _consumer = _stateManager.getStateData(StateType.NEWUSER) as INewUserStateConsumer;
         _subStateFactory = new NewUserSubStateFactory(param1,param2,param3,Sprite(this),_userProfile,param5,param6,param7,_headerWidget,_widgetManager,param9.getVirmonDataList(),INewUserStateCompleteHandler(this));
         _subStateController = new SubStateController(_subStateFactory);
         _subStateController.changeSubState(NewUserSubStates.NEWUSER_SUBSTATE_INTRO);
      }
      
      public function handleNewUserStateError(param1:String) : void
      {
         _consumer.handleNewUserStateComplete(_stateManager);
      }
      
      override public function onUnsetState() : void
      {
         _subStateFactory.destroy();
         _subStateFactory = null;
         _subStateController.destroy();
         _subStateController = null;
         super.onUnsetState();
      }
      
      public function handleNewUserStateComplete() : void
      {
         StoredSettingManager.getInstance().storeSettingAndSave(StoredSetting.HAS_SEEN_NEW_USER_EXPERIENCE + "_" + _userProfile.screenname,true);
         _consumer.handleNewUserStateComplete(_stateManager);
      }
   }
}

