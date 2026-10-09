package com.arkadium.virmon.evotree.ui
{
   public class EvoTreeGridNodePuckModes
   {
      
      public static const MODE_SELECTED:EvoTreeGridNodePuckModes = new EvoTreeGridNodePuckModes("modeSelected");
      
      public static const MODE_ACTIVE:EvoTreeGridNodePuckModes = new EvoTreeGridNodePuckModes("modeActive");
      
      public static const MODE_INACTIVE:EvoTreeGridNodePuckModes = new EvoTreeGridNodePuckModes("modeInactive");
      
      public static const MODE_CAN_EVOLVE:EvoTreeGridNodePuckModes = new EvoTreeGridNodePuckModes("modeCanEvolve");
      
      public static const MODE_CANT_EVOLVE:EvoTreeGridNodePuckModes = new EvoTreeGridNodePuckModes("modeCantEvolve");
      
      private static var _runTimeLock:Boolean = false;
      
      _runTimeLock = true;
      
      private var _mode:String;
      
      public function EvoTreeGridNodePuckModes(param1:String)
      {
         super();
         if(_runTimeLock)
         {
            throw new Error("Additional EvoTreeGridNodePuckModes cannot be instantiated during runtime.");
         }
         _mode = param1;
      }
   }
}

