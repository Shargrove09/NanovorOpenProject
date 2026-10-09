package com.arkadium.communications.handlers
{
   public interface IGameServiceProviderInitConsumer
   {
      
      function handleGameServicesInitFailure(param1:String) : void;
      
      function handleGameServicesLoginSuccess() : void;
      
      function handleGameServicesInitSuccess() : void;
      
      function handleGameServicesInvalidLogin() : void;
   }
}

