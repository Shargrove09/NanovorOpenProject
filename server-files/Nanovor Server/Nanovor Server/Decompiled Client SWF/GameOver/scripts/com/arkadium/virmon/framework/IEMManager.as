package com.arkadium.virmon.framework
{
   import flash.events.IEventDispatcher;
   
   public interface IEMManager extends IEventDispatcher
   {
      
      function getEMDataListByMasterID(param1:int) : Array;
      
      function loadInstanceDataXML(param1:String) : *;
      
      function setLists(param1:XML, param2:XML) : void;
      
      function getEMCountByMasterId(param1:int) : int;
      
      function onInitialize() : void;
      
      function getEMData(param1:String) : EMData;
      
      function getEMQuantity(param1:Number) : Array;
      
      function getEMMasterData(param1:int) : EMMasterData;
      
      function getEMDataList() : Array;
      
      function getEMMasterDataList() : Array;
   }
}

