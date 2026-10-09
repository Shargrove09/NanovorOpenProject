package com.arkadium.virmon.collection.shared
{
   import com.arkadium.virmon.framework.EvoData;
   import flash.utils.Dictionary;
   
   public interface ICollectionViewerDataHandler
   {
      
      function getEvoDataByDestinationId(param1:int) : EvoData;
      
      function destroy() : void;
      
      function getTreeIds() : Array;
      
      function get evoTreeData() : Array;
      
      function get treeNames() : Dictionary;
      
      function get virmonList() : Array;
      
      function get evoList() : Array;
   }
}

