package com.arkadium.virmon.transitions
{
   public interface ITransitionManagerConsumer
   {
      
      function handleTransitionMidpoint() : void;
      
      function handleTransitionComplete() : void;
   }
}

