package com.arkadium.virmon.evotree
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   
   public interface IEvoTreeState
   {
      
      function initialize(param1:INanovorFactory, param2:IBadgeManager, param3:IEMManager, param4:IUserProfile, param5:IVirmonManager, param6:IEvoManager, param7:IStateManager, param8:IWidgetManager) : void;
   }
}

