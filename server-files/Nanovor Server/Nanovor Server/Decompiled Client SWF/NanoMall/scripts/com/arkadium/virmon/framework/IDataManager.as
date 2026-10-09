package com.arkadium.virmon.framework
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import flash.events.IEventDispatcher;
   
   public interface IDataManager extends IEventDispatcher
   {
      
      function getBadgeManager() : IBadgeManager;
      
      function getEvoManager() : IEvoManager;
      
      function onInitialize(param1:IServiceRequestBrokerManager) : *;
      
      function getVirmonManager() : IVirmonManager;
      
      function refreshData() : void;
      
      function getEMManager() : IEMManager;
   }
}

