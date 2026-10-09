package com.arkadium.virmon.evogame.substates
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.virmon.evogame.Circuit;
   import com.arkadium.virmon.evogame.IEvoGameStateUI;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   
   public class EvoGameSubStateGame extends AbstractSubState
   {
      
      private var _evoGameUI:IEvoGameStateUI;
      
      private var _currentCircuit:Circuit;
      
      private var _row:int;
      
      public function EvoGameSubStateGame(param1:IEvoGameStateUI, param2:int)
      {
         super();
         _evoGameUI = param1;
         _row = param2;
      }
      
      override public function setSubState() : void
      {
         _evoGameUI.resetHopperTray();
         _evoGameUI.openHopperTray();
         _evoGameUI.setCircuit(_row);
         _currentCircuit = _evoGameUI.getCircuit(_row);
         _currentCircuit.openClamps();
         _currentCircuit.getSwitch().addEventListener(MouseEvent.CLICK,onSwitchClick);
         _evoGameUI.getBackButton().addEventListener(MouseEvent.CLICK,quit);
         _evoGameUI.getQuickTipsButton().getButton().addEventListener(MouseEvent.CLICK,onQuickTipsClick);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoGameSubStateGame>>\t" + param1);
      }
      
      private function evolutionResultFromServer(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,evolutionResultFromServer);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,evolutionErrorFromServer);
         var _loc2_:XML = XML(param1.target.data);
         var _loc3_:String = String(param1.target.data);
         if(_loc3_ == "success")
         {
            Managers.analyticsManager.trackAction(Action.EVOLVE_GAME_SUCCESS);
            DataManager.getInstance().refreshData();
            onSuccessfulEvolution();
         }
         else if(_loc3_.substr(0,5) != "error")
         {
            Managers.analyticsManager.trackAction(Action.EVOLVE_GAME_FAIL);
            _loc4_ = int(_loc2_.child(0));
            _loc5_ = int(_loc2_.child(1)) - int(_loc2_.child(0));
            _currentCircuit.showHint(_loc4_,_loc5_);
            onFailedEvolution();
         }
         else
         {
            Managers.analyticsManager.trackAction(Action.EVOLVE_GAME_ERROR);
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"A server error occurred","This Nanovor cannot be evolved at this time, due to a server error.  Please try a different Nanovor, or try again later." + "\n[" + _loc3_.substring(5,_loc3_.indexOf(":")) + "]",0,quit,quit);
         }
      }
      
      public function quit(param1:Object = null) : void
      {
         _evoGameUI.destroy();
         destroyListeners();
         var _loc2_:String = Managers.stateManager.getStateData(StateType.EVOGAME).sourceVirmonId as String;
         Managers.stateManager.setStateData(StateType.EVOTREE,_loc2_);
         Managers.stateManager.setState(StateType.EVOTREE);
      }
      
      private function onSuccessfulEvolution() : void
      {
         destroyListeners();
         _currentCircuit.burnClamps(true);
         _subStateController.changeSubState(EvoGameSubStateFactory.EVOGAME_SUBSTATE_VICTORY,_currentCircuit.getTypeArray());
      }
      
      private function onQuickTipsClick(param1:MouseEvent) : void
      {
         Managers.stateManager.handleQuickTips();
      }
      
      private function destroyListeners() : void
      {
         _evoGameUI.getBackButton().removeEventListener(MouseEvent.CLICK,quit);
         _evoGameUI.getQuickTipsButton().getButton().removeEventListener(MouseEvent.CLICK,onQuickTipsClick);
         _currentCircuit.getSwitch().removeEventListener(MouseEvent.CLICK,onSwitchClick);
      }
      
      private function onSwitchClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = _currentCircuit.getArray();
         if(_loc2_ == null)
         {
            return;
         }
         _evoGameUI.lockHopperTray();
         _currentCircuit.switched();
         var _loc3_:Object = Managers.stateManager.getStateData(StateType.EVOGAME);
         Managers.serviceRequestBrokerManager.requestEvolveNanovor(_loc3_.evolutionId,_loc3_.sourceVirmonId,_loc2_,evolutionResultFromServer,evolutionErrorFromServer);
      }
      
      private function evolutionErrorFromServer(param1:IOErrorEvent) : void
      {
         Managers.analyticsManager.trackAction(Action.EVOLVE_GAME_LOAD_ERROR);
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,evolutionResultFromServer);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,evolutionErrorFromServer);
         CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"A server error occurred","This Nanovor cannot be evolved at this time, due to a server error.  Please try a different Nanovor, or try again later.",0,quit,quit);
      }
      
      private function restart(param1:Object = null) : void
      {
         destroyListeners();
         _subStateController.changeSubState(EvoGameSubStateFactory.EVOGAME_SUBSTATE_INIT);
      }
      
      private function onFailedEvolution() : void
      {
         destroyListeners();
         _currentCircuit.burnClamps(false);
         if(_row == 4)
         {
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Evolution failed!","Try again?",0,restart,quit,quit);
            return;
         }
         _evoGameUI.lockHopperTray(false);
         _subStateController.changeSubState(EvoGameSubStateFactory.EVOGAME_SUBSTATE_GAME,_row + 1);
      }
   }
}

