package com.arkadium.virmon.shared.utils
{
   public interface IChainLoadee
   {
      
      function setChainLoader(param1:IChainLoader) : void;
      
      function get name() : String;
      
      function load() : void;
   }
}

