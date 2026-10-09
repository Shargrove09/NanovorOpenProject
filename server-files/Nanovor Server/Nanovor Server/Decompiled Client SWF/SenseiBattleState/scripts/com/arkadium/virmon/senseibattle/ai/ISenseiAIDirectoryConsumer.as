package com.arkadium.virmon.senseibattle.ai
{
   public interface ISenseiAIDirectoryConsumer
   {
      
      function handleSenseiAILoadFailure() : void;
      
      function handleSenseiAILoadComplete() : void;
   }
}

