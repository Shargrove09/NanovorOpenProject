package com.arkadium.virmon.shared.utils
{
   public class ChainLoaderHandleError extends ChainLoader
   {
      
      private var _chainLoaderErrorConsumer:IChainLoaderErrorConsumer;
      
      public function ChainLoaderHandleError(param1:ChainLoadeeList, param2:IChainLoaderConsumer, param3:IChainLoaderErrorConsumer)
      {
         super(param1,param2);
         _chainLoaderErrorConsumer = param3;
      }
      
      override public function handleChainLoadeeError() : void
      {
         if(null != _chainLoaderErrorConsumer)
         {
            _chainLoaderErrorConsumer.handleChainLoaderError();
         }
      }
   }
}

