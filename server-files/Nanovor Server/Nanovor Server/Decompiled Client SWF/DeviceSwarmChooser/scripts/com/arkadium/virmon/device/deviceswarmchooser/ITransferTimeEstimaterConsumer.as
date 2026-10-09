package com.arkadium.virmon.device.deviceswarmchooser
{
   public interface ITransferTimeEstimaterConsumer
   {
      
      function acceptTimeEstimate() : void;
      
      function cancelTimeEstimate() : void;
   }
}

