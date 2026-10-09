package com.arkadium.virmon.state.initializer
{
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.evotree.IEvoTreeState;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.NanovorFactory;
   import com.arkadium.virmon.state.IState;
   
   internal class EvoTreeStateInitializer
   {
      
      private var _state:IEvoTreeState;
      
      public function EvoTreeStateInitializer(param1:IState)
      {
         super();
         this._state = param1 as IEvoTreeState;
         if(this._state == null)
         {
            throw new Error("Could not cast state argument as IEvoTreeState");
         }
      }
      
      public function initialize() : void
      {
         this._state.initialize(new NanovorFactory(DataManager.getInstance().getVirmonManager()),DataManager.getInstance().getBadgeManager(),DataManager.getInstance().getEMManager(),UserProfile.getInstance(),DataManager.getInstance().getVirmonManager(),DataManager.getInstance().getEvoManager(),Managers.stateManager,Managers.widgetManager);
      }
   }
}

