package com.arkadium.virmon.shared.utils
{
   public class ChainLoaderRetry extends ChainLoader
   {
      
      public static const RETRIES:int = 3;
      
      private var _currentAttempt:int = 0;
      
      private var _chainLoaderErrorConsumer:IChainLoaderErrorConsumer;
      
      public function ChainLoaderRetry(param1:ChainLoadeeList, param2:IChainLoaderConsumer, param3:IChainLoaderErrorConsumer)
      {
         super(param1,param2);
         _chainLoaderErrorConsumer = param3;
      }
      
      override public function handleChainLoadeeError() : void
      {
         if(_currentAttempt == RETRIES)
         {
            _currentAttempt = 0;
            _chainLoaderErrorConsumer.handleChainLoaderError();
         }
         else
         {
            ++_currentAttempt;
            this.loadNext();
         }
      }
      
      override public function handleChainLoadeeComplete(param1:Object = null) : void
      {
         _currentAttempt = 0;
         super.handleChainLoadeeComplete(param1);
      }
   }
}

