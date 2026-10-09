package com.arkadium.virmon.battle.substates.swarmchooser
{
   import com.arkadium.virmon.shared.data.INanovorFactory;
   
   public interface ISwarmChooser
   {
      
      function init(param1:INanovorFactory, param2:int, param3:int, param4:ISwarmChooserConsumer, param5:ISwarmContainerFactory) : void;
      
      function destroy() : void;
      
      function reset() : void;
   }
}

