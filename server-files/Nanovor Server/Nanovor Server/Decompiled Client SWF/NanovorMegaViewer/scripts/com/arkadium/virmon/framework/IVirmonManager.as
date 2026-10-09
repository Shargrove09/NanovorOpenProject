package com.arkadium.virmon.framework
{
   import flash.events.IEventDispatcher;
   
   public interface IVirmonManager extends IEventDispatcher
   {
      
      function getVirmonDataByAssetTypeId(param1:Number) : IVirmonData;
      
      function getAttackStatementById(param1:int) : Object;
      
      function getOverrideColor(param1:int) : String;
      
      function getVirmonDataList() : Array;
      
      function getVirmonMasterDataList() : Array;
      
      function getVirmonQuantity(param1:Number) : Array;
      
      function onInitialize() : *;
      
      function getAttackById(param1:int) : IVirmonAttackData;
      
      function getOverrideDescriptionByAttackStatementId(param1:int) : String;
      
      function loadInstanceDataXML(param1:String) : void;
      
      function setLists(param1:XML, param2:XML) : void;
      
      function getVirmonData(param1:String) : IVirmonData;
      
      function getCollectionSize() : int;
      
      function getVirmonMasterData(param1:Number) : IVirmonMasterData;
      
      function getOverrideDescriptionByAttackId(param1:int) : String;
      
      function getInstanceData() : XML;
      
      function getHackDescriptionByAttackId(param1:int) : String;
   }
}

