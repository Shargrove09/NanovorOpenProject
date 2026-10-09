package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoaderHandleError;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IChainLoaderErrorConsumer;
   import com.arkadium.virmon.shared.utils.URLAssetChainLoadee;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class SenseiAIDirectory implements ISenseiAIDirectory, IChainLoaderConsumer, IChainLoaderErrorConsumer
   {
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _chainLoader:IChainLoader;
      
      private var _comsumer:ISenseiAIDirectoryConsumer;
      
      private var _senseiPlayersURL:String;
      
      private var _senseiAITypes:Array;
      
      public function SenseiAIDirectory(param1:INanovorFactory, param2:ISenseiAIDirectoryConsumer, param3:IMasterDataAssetRetriever)
      {
         super();
         _nanovorFactory = param1;
         _comsumer = param2;
         _senseiPlayersURL = param3.getMasterDataURL(MasterDataAssetType.SENSEI_PLAYERS).url;
         _senseiAITypes = new Array();
         var _loc4_:ChainLoadeeList = new ChainLoadeeList();
         _loc4_.add(new URLAssetChainLoadee(_senseiPlayersURL));
         _chainLoader = new ChainLoaderHandleError(_loc4_,IChainLoaderConsumer(this),IChainLoaderErrorConsumer(this));
         _chainLoader.load();
      }
      
      public function getSenseiAITypes() : Array
      {
         return _senseiAITypes.slice();
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var senseiMasterData:XML = null;
         var senseiPlayerNode:XML = null;
         var senseiNanovors:Array = null;
         var nanovorNode:XML = null;
         var nanovor:INanovor = null;
         var assetCache:IAssetCache = param1;
         try
         {
            log("handleChainLoaderComplete()");
            senseiMasterData = XML(assetCache.getLoadedAsset(_senseiPlayersURL));
            for each(senseiPlayerNode in senseiMasterData.player)
            {
               senseiNanovors = new Array();
               for each(nanovorNode in senseiPlayerNode.swarm.nanovor)
               {
                  nanovor = _nanovorFactory.createNanovorTypeById(int(nanovorNode.@assetTypeId));
                  nanovor.assetId = nanovorNode.@assetId;
                  senseiNanovors.push(new SenseiNanovor(nanovor));
               }
               _senseiAITypes.push(new SenseiAIType(senseiPlayerNode.@name,int(senseiPlayerNode.@userRefId),senseiNanovors,Boolean(senseiPlayerNode.@show == "true")));
            }
         }
         catch(e:Error)
         {
            logError("handleChainLoaderComplete() - Error parsing the XML:\n" + e.getStackTrace());
            _comsumer.handleSenseiAILoadFailure();
            return;
         }
         _comsumer.handleSenseiAILoadComplete();
      }
      
      public function getSenseiIdByName(param1:String) : int
      {
         var _loc2_:SenseiAIType = null;
         for each(_loc2_ in _senseiAITypes)
         {
            if(_loc2_.aiName == param1)
            {
               return _loc2_.aiUserRefId;
            }
         }
         return -1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SenseiAIDirectory>>\t" + param1);
      }
      
      public function getSenseiAINames(param1:Boolean = false) : Array
      {
         var _loc3_:SenseiAIType = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in _senseiAITypes)
         {
            if(!(!param1 && !_loc3_.revealed))
            {
               _loc2_.push(_loc3_.aiName);
            }
         }
         return _loc2_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** <<SenseiAIDirectory>>\t" + param1);
      }
      
      public function getSenseiAINameByRefId(param1:int) : String
      {
         var _loc2_:SenseiAIType = null;
         for each(_loc2_ in _senseiAITypes)
         {
            if(_loc2_.aiUserRefId == param1)
            {
               return _loc2_.aiName;
            }
         }
         if(_senseiAITypes.length == 0)
         {
            return "";
         }
         return _senseiAITypes[0].aiName;
      }
      
      public function handleChainLoaderError() : void
      {
         logError("handleChainLoaderError() - Chain loader error");
         _comsumer.handleSenseiAILoadFailure();
      }
   }
}

