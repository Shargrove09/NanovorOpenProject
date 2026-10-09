package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   
   public interface IAssociatedDevices extends IChainLoadee
   {
      
      function refreshAssociatedDevices(param1:IAssociatedDevicesRefreshedHandler = null) : void;
      
      function isDeviceAssociated(param1:String) : Boolean;
   }
}

