package com.arkadium.virmon.collection.shared
{
   import com.arkadium.virmon.framework.EvoData;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class CollectionViewerDataHandler implements ICollectionViewerDataHandler
   {
      
      private var _virmonManager:IVirmonManager;
      
      private var _evoManager:IEvoManager;
      
      private var _loadingNanovorIds:Array;
      
      private var _nanovorBadges:Dictionary;
      
      public function CollectionViewerDataHandler(param1:IEvoManager, param2:IVirmonManager)
      {
         super();
         _loadingNanovorIds = new Array();
         _nanovorBadges = new Dictionary(false);
         _evoManager = param1;
         _virmonManager = param2;
      }
      
      public function get evoList() : Array
      {
         return _evoManager.getEvoList();
      }
      
      public function getTreeIds() : Array
      {
         return _evoManager.getTreeIds();
      }
      
      public function get evoTreeData() : Array
      {
         return _evoManager.getNanovorIdsInTrees();
      }
      
      public function getEvoDataByDestinationId(param1:int) : EvoData
      {
         var _loc3_:EvoData = null;
         var _loc2_:Array = _evoManager.getEvoList();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getDestinationTypeID() == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function destroy() : void
      {
         _nanovorBadges = null;
         _loadingNanovorIds = null;
      }
      
      public function get treeNames() : Dictionary
      {
         return _evoManager.getTreeNames();
      }
      
      public function get virmonList() : Array
      {
         return _virmonManager.getVirmonDataList();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<CollectionViewerDataHandler>>\t" + param1);
      }
   }
}

