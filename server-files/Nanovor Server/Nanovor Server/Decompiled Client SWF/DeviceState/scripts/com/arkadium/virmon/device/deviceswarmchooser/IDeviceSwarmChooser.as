package com.arkadium.virmon.device.deviceswarmchooser
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.device.IDevicePanelController;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   
   public interface IDeviceSwarmChooser
   {
      
      function init(param1:INanovorFactory, param2:IPlayerFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile, param7:IDevicePanelController, param8:IDeviceSwarmChooserUIInstructions, param9:ITransferTimeEstimater, param10:ICharacterAssetTypeCache, param11:ISoundManager) : void;
      
      function destroy() : void;
      
      function open(param1:Array) : void;
   }
}

