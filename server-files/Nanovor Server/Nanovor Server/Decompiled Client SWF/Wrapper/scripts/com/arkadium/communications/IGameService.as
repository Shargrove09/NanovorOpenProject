package com.arkadium.communications
{
   import com.arkadium.communications.handlers.IGameServiceInitializedHandler;
   
   public interface IGameService
   {
      
      function init(param1:IGameServiceInitializedHandler) : void;
      
      function destroy() : void;
      
      function disconnect() : void;
      
      function get isConnected() : Boolean;
   }
}

