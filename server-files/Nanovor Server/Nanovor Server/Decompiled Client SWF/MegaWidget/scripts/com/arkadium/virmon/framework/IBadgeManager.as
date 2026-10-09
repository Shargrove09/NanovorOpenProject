package com.arkadium.virmon.framework
{
   import flash.events.IEventDispatcher;
   
   public interface IBadgeManager extends IEventDispatcher
   {
      
      function setList(param1:XML) : void;
      
      function getUserBadge(param1:int) : IBadgeData;
      
      function getAssetBadgeData(param1:int) : BadgeMasterData;
      
      function getAccountBadgeData(param1:int) : BadgeMasterData;
      
      function getUserBadgeList() : Array;
      
      function loadAndParseAccountBadges() : void;
      
      function onInitialize() : void;
   }
}

