package com.arkadium.virmon.shared.utils
{
   public interface IChainLoader
   {
      
      function handleChainLoadeeComplete(param1:Object = null) : void;
      
      function handleChainLoadeeError() : void;
      
      function destroy() : void;
      
      function load() : void;
   }
}

