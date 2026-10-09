package com.arkadium.virmon.transitions
{
   public interface ITransitionManager
   {
      
      function init(param1:ITransitionManagerConsumer) : void;
      
      function finishTransition() : void;
      
      function startTransition() : void;
   }
}

