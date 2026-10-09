package com.arkadium.virmon.shared.ui.gameOptions
{
   public interface ICGameOptionsConsumer
   {
      
      function handleGameOptionsToggleHelp(param1:Boolean) : void;
      
      function handleGameOptionsChangeScreenSize(param1:String) : void;
      
      function handleGameOptionsClose() : void;
      
      function handleGameOptionsVolumeChanged(param1:Number, param2:String) : void;
   }
}

