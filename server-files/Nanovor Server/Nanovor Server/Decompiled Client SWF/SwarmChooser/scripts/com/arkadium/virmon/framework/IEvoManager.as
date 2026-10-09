package com.arkadium.virmon.framework
{
   import flash.utils.Dictionary;
   
   public interface IEvoManager
   {
      
      function init(param1:XML) : void;
      
      function getEvoData(param1:int) : EvoData;
      
      function getTreeNames() : Dictionary;
      
      function getEvoList() : Array;
      
      function getNanovorIdsInTrees() : Array;
      
      function initTreeNames(param1:XML) : void;
      
      function getTreeIds() : Array;
      
      function onInitialize() : void;
   }
}

