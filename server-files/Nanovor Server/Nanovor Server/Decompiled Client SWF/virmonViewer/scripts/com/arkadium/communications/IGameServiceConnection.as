package com.arkadium.communications
{
   import com.arkadium.communications.handlers.ILoginResultHandler;
   import flash.events.IEventDispatcher;
   
   public interface IGameServiceConnection extends IEventDispatcher
   {
      
      function logout() : void;
      
      function destroy() : void;
      
      function disconnect() : void;
      
      function loginToGameService(param1:ILoginResultHandler) : void;
   }
}

