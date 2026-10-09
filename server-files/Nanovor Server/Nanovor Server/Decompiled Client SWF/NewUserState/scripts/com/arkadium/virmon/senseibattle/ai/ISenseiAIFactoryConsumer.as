package com.arkadium.virmon.senseibattle.ai
{
   public interface ISenseiAIFactoryConsumer
   {
      
      function handleSenseiAILoadFailure() : void;
      
      function handleSenseiAILoadComplete() : void;
   }
}

