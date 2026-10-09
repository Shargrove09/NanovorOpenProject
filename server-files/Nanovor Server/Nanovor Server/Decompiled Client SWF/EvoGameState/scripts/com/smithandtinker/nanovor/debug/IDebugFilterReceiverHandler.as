package com.smithandtinker.nanovor.debug
{
   public interface IDebugFilterReceiverHandler
   {
      
      function handleFilterChange(param1:String) : void;
      
      function handleReceiverRegistered() : void;
      
      function handlePolledRegistration() : void;
   }
}

