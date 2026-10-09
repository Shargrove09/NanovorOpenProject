package com.arkadium.virmon.evotree.grid
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.IEvoTreeEvoChecker;
   import com.arkadium.virmon.evotree.IEvoTreeEvolverFactory;
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.INanovorEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.IEvoTreeGridColorProvider;
   import com.arkadium.virmon.evotree.grid.positioner.IEvoTreeGridPositioner;
   import com.arkadium.virmon.evotree.grid.treebuilder.EvoTreeGridSubTreeController;
   import com.arkadium.virmon.evotree.grid.treebuilder.IEvoTreeGridSubTreeController;
   import com.arkadium.virmon.evotree.substates.home.IEvoTreeNanovorSelector;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.ITreeViewMenu;
   import com.arkadium.virmon.state.IStateChanger;
   import flash.utils.Dictionary;
   
   public class EvoTreeGridController implements IEvoTreeGridController
   {
      
      private var _nodePoisitioner:IEvoTreeGridPositioner;
      
      private var _treeViewMenu:ITreeViewMenu;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _currentTreeId:int;
      
      private var _evolverFactory:IEvoTreeEvolverFactory;
      
      private var _consumer:IEvoTreeGridControllerConsumer;
      
      private var _evoChecker:IEvoTreeEvoChecker;
      
      private var _stateChanager:IStateChanger;
      
      private var _currentNodeController:IEvoTreeGridNodeController;
      
      private var _treeControllers:Dictionary;
      
      private var _evoList:Array;
      
      private var _userProfile:IUserProfile;
      
      private var _virmonManager:IVirmonManager;
      
      private var _nanovorSelector:IEvoTreeNanovorSelector;
      
      private var _colorProvider:IEvoTreeGridColorProvider;
      
      private var _nodeControllers:Dictionary;
      
      private var _currentTreeController:IEvoTreeGridSubTreeController;
      
      public function EvoTreeGridController(param1:INanovorFactory, param2:Array, param3:IEvoTreeEvoChecker, param4:IVirmonManager, param5:IUserProfile, param6:IEvoTreeEvolverFactory, param7:IStateChanger, param8:IEvoTreeNanovorSelector, param9:IEvoTreeGridPositioner, param10:ITreeViewMenu, param11:IEvoTreeGridColorProvider)
      {
         super();
         _nanovorFactory = param1;
         _evoList = param2;
         _evoChecker = param3;
         _virmonManager = param4;
         _userProfile = param5;
         _evolverFactory = param6;
         _stateChanager = param7;
         _nanovorSelector = param8;
         _nodePoisitioner = param9;
         _treeViewMenu = param10;
         _colorProvider = param11;
         _treeControllers = new Dictionary();
         _nodeControllers = new Dictionary();
      }
      
      public function init(param1:IEvoTreeGridControllerConsumer) : void
      {
         _consumer = param1;
      }
      
      public function selectTree(param1:int) : void
      {
         if(null == _consumer)
         {
            return;
         }
         var _loc2_:EvoTreeGridSubTreeController = getTreeController(param1);
         var _loc3_:EvoTreeGridNodeController = _nodeControllers[param1];
         var _loc4_:INanovorEvoTreeGridNode = _loc2_.getRoot() as INanovorEvoTreeGridNode;
         var _loc5_:int = 0;
         if(null != _loc4_)
         {
            _loc5_ = int(_loc4_.assetTypeId);
         }
         if(_currentTreeId != param1)
         {
            if(null != _currentNodeController)
            {
               _currentNodeController.reset();
            }
            if(null != _currentTreeController)
            {
               _currentTreeController.reset();
            }
            _currentNodeController = _loc3_;
            _currentTreeController = _loc2_;
         }
         var _loc6_:Array = _treeViewMenu.getNanovorsOfType(_loc5_);
         selectNanovor(param1,_loc5_,_loc6_[0]);
      }
      
      public function selectNanovor(param1:int, param2:int, param3:INanovor = null) : void
      {
         if(null == _consumer)
         {
            return;
         }
         var _loc4_:EvoTreeGridSubTreeController = getTreeController(param1);
         var _loc5_:EvoTreeGridNodeController = _nodeControllers[param1];
         _loc4_.selectNodeByNanovor(param2);
         _loc5_.selectNanovor(param2,param3);
         var _loc6_:Boolean = Boolean(_currentTreeId != param1);
         var _loc7_:IEvoTreeGridNode = _loc4_.getRoot();
         _currentTreeId = param1;
         _consumer.handleNodeSelected(_loc7_,_loc6_,_nodePoisitioner);
      }
      
      private function getTreeController(param1:int) : EvoTreeGridSubTreeController
      {
         var _loc2_:EvoTreeGridNodeController = null;
         var _loc3_:EvoTreeGridSubTreeController = null;
         if(null == _treeControllers[param1])
         {
            _loc2_ = new EvoTreeGridNodeController(_nanovorFactory,_evoChecker,_virmonManager,_userProfile,_evolverFactory,_stateChanager,_nanovorSelector,_treeViewMenu,_colorProvider,_consumer);
            _loc3_ = new EvoTreeGridSubTreeController(param1,_evoList,_loc2_,_colorProvider);
            _nodeControllers[param1] = _loc2_;
            _treeControllers[param1] = _loc3_;
         }
         return _treeControllers[param1];
      }
   }
}

