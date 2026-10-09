package com.arkadium.virmon.device.deviceswarmchooser
{
   public interface ITransferTimeEstimater
   {
      
      function promptTransferTimeDialog(param1:Array, param2:ITransferTimeEstimaterConsumer) : void;
      
      function killDialogs() : void;
   }
}

