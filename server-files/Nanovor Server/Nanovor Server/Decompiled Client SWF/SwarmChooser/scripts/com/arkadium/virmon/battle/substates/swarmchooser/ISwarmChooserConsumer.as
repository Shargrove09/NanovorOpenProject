package com.arkadium.virmon.battle.substates.swarmchooser
{
   public interface ISwarmChooserConsumer
   {
      
      function handleTimeOut() : void;
      
      function handleSwarmSelected(param1:Array) : void;
   }
}

