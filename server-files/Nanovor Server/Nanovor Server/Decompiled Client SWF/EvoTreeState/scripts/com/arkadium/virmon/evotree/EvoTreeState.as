package com.arkadium.virmon.evotree
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.evotree.evolver.EvoTreeEvolver;
   import com.arkadium.virmon.evotree.evolver.IEvoTreeEvolver;
   import com.arkadium.virmon.framework.EvoData;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.utils.substate.SubStateController;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.IAutoBattleWidget;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.IStateChanger;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import flash.display.DisplayObjectContainer;
   
   public class EvoTreeState extends AbstractState implements IEvoTreeEvolverFactory, IEvoTreeState
   {
      
      private var _chatWidget:IWidget;
      
      private var _autoBattleWidget:IAutoBattleWidget;
      
      private var _subStateController:SubStateController;
      
      private var _headerWidget:IWidget;
      
      private var _stateManager:IStateManager;
      
      public function EvoTreeState()
      {
         super();
         stateName = StateType.EVOTREE.name;
      }
      
      override public function onUnsetState() : void
      {
         _subStateController.destroy();
         _stateManager.setStateData(StateType.EVOTREE,null);
         super.onUnsetState();
      }
      
      override public function onSetState() : void
      {
         _headerWidget.setMode(WidgetType.MODE_HOME);
         _chatWidget.setMode(WidgetType.MODE_HIDDEN);
         _autoBattleWidget.show();
         var _loc1_:String = _stateManager.getStateData(StateType.EVOTREE) as String;
         _subStateController.changeSubState(EvoTreeSubStateFactory.SUB_STATE_HOME,_loc1_);
      }
      
      public function initialize(param1:INanovorFactory, param2:IBadgeManager, param3:IEMManager, param4:IUserProfile, param5:IVirmonManager, param6:IEvoManager, param7:IStateManager, param8:IWidgetManager) : void
      {
         _stateManager = param7;
         _chatWidget = param8.getWidgetByName(WidgetType.WIDGET_CHAT.name);
         _autoBattleWidget = param8.getWidgetByName(WidgetType.WIDGET_AUTO_BATTLE.name) as IAutoBattleWidget;
         _headerWidget = param8.getWidgetByName(WidgetType.WIDGET_HEADER.name) as IWidget;
         var _loc9_:EvoTreeSubStateFactory = new EvoTreeSubStateFactory(param1,param2,param3,DisplayObjectContainer(this),param6,param5,param4,IEvoTreeEvolverFactory(this),_stateManager as IStateChanger);
         _subStateController = new SubStateController(_loc9_);
      }
      
      public function createEvoTreeEvolver(param1:String, param2:EvoData) : IEvoTreeEvolver
      {
         return new EvoTreeEvolver(param1,param2,_stateManager as IStateChanger);
      }
   }
}

