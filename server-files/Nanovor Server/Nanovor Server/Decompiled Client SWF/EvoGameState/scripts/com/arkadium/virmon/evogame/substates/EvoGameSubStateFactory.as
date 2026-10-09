package com.arkadium.virmon.evogame.substates
{
   import com.arkadium.virmon.evogame.IEvoGameStateUI;
   import com.arkadium.virmon.shared.utils.substate.ISubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateFactory;
   
   public class EvoGameSubStateFactory implements ISubStateFactory
   {
      
      public static const EVOGAME_SUBSTATE_INIT:String = "evogamesubstateinit";
      
      public static const EVOGAME_SUBSTATE_GAME:String = "evogamesubstategame";
      
      public static const EVOGAME_SUBSTATE_VICTORY:String = "evogamesubstatevictory";
      
      private var _evoGameUI:IEvoGameStateUI;
      
      public function EvoGameSubStateFactory(param1:IEvoGameStateUI)
      {
         super();
         _evoGameUI = param1;
      }
      
      public function createSubState(param1:String, param2:Object = null) : ISubState
      {
         switch(param1)
         {
            case EVOGAME_SUBSTATE_INIT:
               return new EvoGameSubStateInit(_evoGameUI);
            case EVOGAME_SUBSTATE_GAME:
               return new EvoGameSubStateGame(_evoGameUI,param2 as int);
            case EVOGAME_SUBSTATE_VICTORY:
               return new EvoGameSubStateVictory(_evoGameUI,param2 as Array);
            default:
               return null;
         }
      }
   }
}

