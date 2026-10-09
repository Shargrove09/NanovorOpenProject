package com.arkadium.communications.handlers
{
   public interface IGameServiceInitializedHandler
   {
      
      function handleGameServiceInitialized(param1:Object = null) : void;
      
      function handleGameServiceFailure(param1:String) : void;
   }
}

