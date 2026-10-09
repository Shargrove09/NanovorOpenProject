package com.arkadium.virmon.senseibattle.ai
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.framework.asset.retriever.IMasterDataAssetRetriever;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class SenseiAIFactory implements ISenseiAIFactory, ISenseiAIDirectoryConsumer
   {
      
      private var _playerFactory:IPlayerFactory;
      
      private var _chainLoader:IChainLoader;
      
      private var _senseiDirectory:ISenseiAIDirectory;
      
      private var _consumer:ISenseiAIFactoryConsumer;
      
      public function SenseiAIFactory(param1:INanovorFactory, param2:IPlayerFactory, param3:IMasterDataAssetRetriever, param4:ISenseiAIFactoryConsumer)
      {
         super();
         _playerFactory = param2;
         _consumer = param4;
         _senseiDirectory = new SenseiAIDirectory(param1,ISenseiAIDirectoryConsumer(this),param3);
      }
      
      public function handleSenseiAILoadFailure() : void
      {
         _consumer.handleSenseiAILoadFailure();
      }
      
      public function handleSenseiAILoadComplete() : void
      {
         _consumer.handleSenseiAILoadComplete();
      }
      
      public function createAI(param1:IPlayer, param2:ISenseiAIBattleTracker, param3:ISenseiAIMoveGenerator, param4:String = "") : ISenseiAI
      {
         var _loc7_:INanovor = null;
         var _loc5_:SenseiAIType = getSenseiAITypeByName(param4);
         if(null == _loc5_)
         {
            _loc5_ = _senseiDirectory.getSenseiAITypes()[0] as SenseiAIType;
         }
         var _loc6_:IPlayer = _playerFactory.createPlayer(_loc5_.aiName,_loc5_.aiUserRefId);
         for each(_loc7_ in _loc5_.nanovors)
         {
            _loc6_.addNanovorToSwarm(_loc7_);
         }
         param2.init(_loc6_,param1);
         return new SenseiAICrappy(_loc6_,param1,param2,param3);
      }
      
      private function getSenseiAITypeById(param1:int) : SenseiAIType
      {
         var _loc2_:SenseiAIType = null;
         if(-100 == param1)
         {
            return null;
         }
         for each(_loc2_ in _senseiDirectory.getSenseiAITypes())
         {
            if(_loc2_.aiUserRefId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function getSenseiAITypeByName(param1:String) : SenseiAIType
      {
         var _loc2_:SenseiAIType = null;
         if(null == param1)
         {
            return null;
         }
         for each(_loc2_ in _senseiDirectory.getSenseiAITypes())
         {
            if(_loc2_.aiName.toLowerCase() == param1.toLowerCase())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function createAIById(param1:IPlayer, param2:ISenseiAIBattleTracker, param3:ISenseiAIMoveGenerator, param4:int = -100) : ISenseiAI
      {
         var _loc7_:INanovor = null;
         var _loc5_:SenseiAIType = getSenseiAITypeById(param4);
         if(-100 == param4)
         {
            _loc5_ = _senseiDirectory.getSenseiAITypes()[0] as SenseiAIType;
         }
         var _loc6_:IPlayer = _playerFactory.createPlayer(_loc5_.aiName,_loc5_.aiUserRefId);
         for each(_loc7_ in _loc5_.nanovors)
         {
            _loc6_.addNanovorToSwarm(_loc7_);
         }
         param2.init(_loc6_,param1);
         return new SenseiAICrappy(_loc6_,param1,param2,param3);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SenseiAIFactory>>\t" + param1);
      }
   }
}

