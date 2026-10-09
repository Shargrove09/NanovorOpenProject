package com.arkadium.virmon.battle.substates.swarmchooser
{
   import com.arkadium.virmon.shared.utils.NanovorLoaderAndSequencer;
   
   internal class SwarmContainerNanovorStack
   {
      
      private var _nanovor:NanovorLoaderAndSequencer;
      
      private var _actionPicker:ActionPickerSwarm;
      
      public function SwarmContainerNanovorStack(param1:ActionPickerSwarm, param2:NanovorLoaderAndSequencer)
      {
         super();
         _actionPicker = param1;
         _nanovor = param2;
      }
      
      public function get actionPicker() : ActionPickerSwarm
      {
         return _actionPicker;
      }
      
      public function get nanovor() : NanovorLoaderAndSequencer
      {
         return _nanovor;
      }
   }
}

