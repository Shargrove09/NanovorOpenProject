package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   
   public interface IDeviceWriteFailureConsumer
   {
      
      function onDeviceWriteFailure() : CommonDialogBox;
   }
}

