package com.arkadium.virmon.framework.asset
{
   import com.arkadium.virmon.framework.EvoData;
   import com.arkadium.virmon.framework.IEvoDataRetriever;
   import com.arkadium.virmon.framework.IVirmonDataRetriever;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class OptionalDownloadPrioritizer implements IOptionalDownloadPrioritizer
   {
      
      private var _virmonDataRetriever:IVirmonDataRetriever;
      
      private var _evoTreeSourceMap:Dictionary;
      
      private var _optionalDownloadList:IAssetDownloadItemList;
      
      public function OptionalDownloadPrioritizer(param1:IVirmonDataRetriever, param2:IEvoDataRetriever, param3:IAssetDownloadItemList)
      {
         super();
         _virmonDataRetriever = param1;
         _optionalDownloadList = param3;
         createEvoTreeSourceMap(param2.getEvoList());
      }
      
      private function createEvoTreeSourceMap(param1:Array) : void
      {
         var _loc2_:EvoData = null;
         _evoTreeSourceMap = new Dictionary();
         for each(_loc2_ in param1)
         {
            _evoTreeSourceMap[_loc2_.getDestinationTypeID()] = _loc2_.getSourceTypeID();
         }
      }
      
      public function prioritize() : void
      {
         var _loc2_:IAssetDownloadItem = null;
         var _loc3_:ICharacterAsset = null;
         var _loc1_:int = 0;
         while(_loc1_ < _optionalDownloadList.length)
         {
            _loc2_ = _optionalDownloadList.getItem(_loc1_);
            _loc3_ = _loc2_.asset as ICharacterAsset;
            if(null == _loc3_)
            {
               log("prioritize(): setting priority to 25001 on non-character asset: " + _loc2_.asset.fileName);
               _loc2_.priority = 25001;
            }
            else
            {
               if(isOwnedNanovor(_loc3_.characterTypeId))
               {
                  _loc2_.priority += 50000;
               }
               _loc2_.priority -= getEvolutionTreeLevel(_loc3_.characterTypeId) * 2000;
               _loc2_.priority -= _loc3_.characterTypeId;
            }
            _loc1_++;
         }
      }
      
      private function isOwnedNanovor(param1:int) : Boolean
      {
         return Boolean(null != _virmonDataRetriever.getVirmonDataByAssetTypeId(param1));
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> OptionalDownloadPrioritizer: " + param1);
      }
      
      private function getEvolutionTreeLevel(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:uint = param1;
         while(null != _evoTreeSourceMap[_loc3_])
         {
            _loc2_++;
            _loc3_ = uint(_evoTreeSourceMap[_loc3_]);
         }
         return _loc2_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** OptionalDownloadPrioritizer: " + param1);
      }
   }
}

