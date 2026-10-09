package com.arkadium.virmon.device
{
   public interface IDeviceAssociatorConsumer
   {
      
      function handleDeviceAssociationSuccess() : void;
      
      function handleDeviceAssociationFailure() : void;
   }
}

