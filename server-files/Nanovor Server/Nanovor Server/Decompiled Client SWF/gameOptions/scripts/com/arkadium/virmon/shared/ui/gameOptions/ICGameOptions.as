package com.arkadium.virmon.shared.ui.gameOptions
{
   public interface ICGameOptions
   {
      
      function init(param1:ICGameOptionsConsumer) : void;
      
      function saveAndClose() : void;
      
      function setParams(param1:Boolean = false, param2:Number = 0.5, param3:Number = 0.5, param4:String = "high", param5:Boolean = false) : void;
   }
}

