package com.arkadium.virmon.shared.utils.chainloadees
{
   public interface IHTTPChainLoadeeConsumer
   {
      
      function handleHTTPError() : void;
      
      function handleHTTPComplete(param1:String) : void;
      
      function handleHTTPProgress(param1:int, param2:int) : void;
   }
}

