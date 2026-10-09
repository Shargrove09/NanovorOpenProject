package com.arkadium.virmon.battle.substates.swarmchooser
{
   import com.arkadium.virmon.battle.control.INanovor;
   import flash.events.IEventDispatcher;
   
   public interface ISwarmContainer extends IEventDispatcher
   {
      
      function swarmIsNotFull() : void;
      
      function removeNanovor(param1:ActionPickerSwarm) : void;
      
      function addCandidate() : void;
      
      function prepareForWaitScreen() : void;
      
      function showCandidate(param1:INanovor) : void;
      
      function hideCandidate() : void;
      
      function get isSwarmSelected() : Boolean;
      
      function open() : void;
      
      function showSelectNanovor() : void;
      
      function set mode(param1:String) : void;
      
      function swarmIsFull() : void;
      
      function set isSwarmSelected(param1:Boolean) : void;
      
      function destroy() : void;
   }
}

