package com.arkadium.virmon.evotree
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.evotree.substates.home.EvoTreeSubStateHome;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.ITreeViewMenuData;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenuData;
   import com.arkadium.virmon.shared.utils.substate.ISubState;
   import com.arkadium.virmon.shared.utils.substate.ISubStateFactory;
   import com.arkadium.virmon.state.IStateChanger;
   import flash.display.DisplayObjectContainer;
   
   public class EvoTreeSubStateFactory implements ISubStateFactory
   {
      
      public static const SUB_STATE_HOME:String = "subStateHome";
      
      private var _virmonManager:IVirmonManager;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _emManager:IEMManager;
      
      private var _badgeManager:IBadgeManager;
      
      private var _treeViewMenuData:ITreeViewMenuData;
      
      private var _evoManager:IEvoManager;
      
      private var _stateChanger:IStateChanger;
      
      private var _evolverFactory:IEvoTreeEvolverFactory;
      
      private var _uiContainer:DisplayObjectContainer;
      
      private var _evoList:Array;
      
      private var _userProfile:IUserProfile;
      
      public function EvoTreeSubStateFactory(param1:INanovorFactory, param2:IBadgeManager, param3:IEMManager, param4:DisplayObjectContainer, param5:IEvoManager, param6:IVirmonManager, param7:IUserProfile, param8:IEvoTreeEvolverFactory, param9:IStateChanger)
      {
         super();
         _uiContainer = param4;
         _evoManager = param5;
         _virmonManager = param6;
         _userProfile = param7;
         _evolverFactory = param8;
         _stateChanger = param9;
         _nanovorFactory = param1;
         _badgeManager = param2;
         _emManager = param3;
         _treeViewMenuData = new TreeViewMenuData(_nanovorFactory,_evoManager,_virmonManager);
         _evoList = _evoManager.getEvoList();
      }
      
      public function createSubState(param1:String, param2:Object = null) : ISubState
      {
         switch(param1)
         {
            case SUB_STATE_HOME:
               return new EvoTreeSubStateHome(_nanovorFactory,_evoManager,_badgeManager,_emManager,_uiContainer,_treeViewMenuData,_evoList,_virmonManager,_userProfile,_evolverFactory,_stateChanger,param2 as String);
            default:
               throw new Error("Unknown SubStateType: " + param1);
         }
      }
   }
}

