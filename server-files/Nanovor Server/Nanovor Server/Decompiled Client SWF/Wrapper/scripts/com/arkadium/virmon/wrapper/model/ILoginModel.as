package com.arkadium.virmon.wrapper.model
{
   import com.arkadium.communications.handlers.IServiceRequestBrokerHandler;
   
   public interface ILoginModel
   {
      
      function login(param1:String, param2:String, param3:String) : void;
      
      function loadLoginPanel() : void;
      
      function initializeServiceRequestBroker() : void;
      
      function addServiceRequestBrokerHandler(param1:IServiceRequestBrokerHandler) : void;
      
      function addLoginPanelLoadedHandler(param1:ILoginPanelLoadedHandler) : void;
      
      function addShardListReceivedHandler(param1:IShardListReceivedHandler) : void;
   }
}

