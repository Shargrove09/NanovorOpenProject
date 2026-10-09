package com.arkadium.virmon.evogame.substates
{
   import com.arkadium.virmon.evogame.IEvoGameStateUI;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class EvoGameSubStateInit extends AbstractSubState
   {
      
      private var _evoGameUI:IEvoGameStateUI;
      
      public function EvoGameSubStateInit(param1:IEvoGameStateUI)
      {
         super();
         _evoGameUI = param1;
      }
      
      override public function setSubState() : void
      {
         _evoGameUI.makeHopperTray();
         _evoGameUI.makeHeader();
         _evoGameUI.makeCircuits();
         _evoGameUI.makeDoors();
         _evoGameUI.makeFooter();
         _evoGameUI.makeBackButton();
         _evoGameUI.makeQuickTipsButton();
         _subStateController.changeSubState(EvoGameSubStateFactory.EVOGAME_SUBSTATE_GAME,0);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> EvoGameSubStateInit: " + param1);
      }
   }
}

