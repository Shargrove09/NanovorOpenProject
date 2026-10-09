package com.arkadium.virmon.gameengine.gameservice
{
   public interface IGameEngineGameServiceControllerConsumer
   {
      
      function handleGameServiceLoginError(param1:String) : void;
      
      function handleGameServicesInitialized() : void;
      
      function handleGameServiceLoginComplete() : void;
   }
}

