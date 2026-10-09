package com.arkadium.virmon.shared.data
{
   import com.arkadium.virmon.framework.EvoData;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class EvoCriteria
   {
      
      private var _evoBranches:Array;
      
      public function EvoCriteria(param1:IEvoManager)
      {
         super();
         init(param1);
      }
      
      private function init(param1:IEvoManager) : void
      {
         var _loc3_:EvoData = null;
         var _loc4_:EvoBranch = null;
         _evoBranches = new Array();
         var _loc2_:Array = param1.getEvoList();
         for each(_loc3_ in _loc2_)
         {
            if(null == getBranch(_loc3_.getSourceTypeID(),_loc3_.getDestinationTypeID()))
            {
               _loc4_ = new EvoBranch(_loc3_.getSourceTypeID(),_loc3_.getDestinationTypeID(),_loc3_.getAssetBadgeIDs(),_loc3_.getAccountBadgeIDs(),_loc3_.getReqEMIds());
               _evoBranches.push(_loc4_);
            }
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoCriteria>> " + param1);
      }
      
      public function getBranches(param1:int) : Array
      {
         var _loc3_:EvoBranch = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in _evoBranches)
         {
            if(_loc3_.sourceID == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function getBranch(param1:int, param2:int) : EvoBranch
      {
         var _loc3_:EvoBranch = null;
         for each(_loc3_ in _evoBranches)
         {
            if(_loc3_.sourceID == param1 && _loc3_.destID == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

