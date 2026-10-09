package com.arkadium.virmon.evotree.grid
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.collection.substates.nanovor.CollectionPreSelectData;
   import com.arkadium.virmon.evotree.IEvoTreeCanEvolveResponse;
   import com.arkadium.virmon.evotree.IEvoTreeEvoChecker;
   import com.arkadium.virmon.evotree.IEvoTreeEvoCheckerConsumer;
   import com.arkadium.virmon.evotree.IEvoTreeEvolverFactory;
   import com.arkadium.virmon.evotree.evolver.IEvoTreeEvolver;
   import com.arkadium.virmon.evotree.grid.gridinfo.EvoTreeGridInfo;
   import com.arkadium.virmon.evotree.grid.node.EvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.INanovorEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.INanovorEvoTreeGridNodeConsumer;
   import com.arkadium.virmon.evotree.grid.node.NanovorEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.IEvoTreeGridColorProvider;
   import com.arkadium.virmon.evotree.substates.home.IEvoTreeNanovorSelector;
   import com.arkadium.virmon.evotree.ui.EvoTreeGridNodePuckModes;
   import com.arkadium.virmon.evotree.ui.evolvebutton.EvolveButton;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.ITreeViewMenu;
   import com.arkadium.virmon.state.IStateChanger;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class EvoTreeGridNodeController implements IEvoTreeGridNodeController, IEvoTreeEvoCheckerConsumer
   {
      
      private var _treeViewMenu:ITreeViewMenu;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _currentNanovor:INanovor;
      
      private var _stateChanger:IStateChanger;
      
      private var _controllerConsumer:IEvoTreeGridControllerConsumer;
      
      private var _evolverFactory:IEvoTreeEvolverFactory;
      
      private var _evoChecker:IEvoTreeEvoChecker;
      
      private var _currentNode:INanovorEvoTreeGridNode;
      
      private var _userProfile:IUserProfile;
      
      private var _virmonManager:IVirmonManager;
      
      private var _nanovorSelector:IEvoTreeNanovorSelector;
      
      private var _nodeSelector:EvoTreeGridNodeConsumerSelect;
      
      private var _nodes:Dictionary;
      
      private var _colorProvider:IEvoTreeGridColorProvider;
      
      public function EvoTreeGridNodeController(param1:INanovorFactory, param2:IEvoTreeEvoChecker, param3:IVirmonManager, param4:IUserProfile, param5:IEvoTreeEvolverFactory, param6:IStateChanger, param7:IEvoTreeNanovorSelector, param8:ITreeViewMenu, param9:IEvoTreeGridColorProvider, param10:IEvoTreeGridControllerConsumer)
      {
         super();
         _nanovorFactory = param1;
         _evoChecker = param2;
         _virmonManager = param3;
         _userProfile = param4;
         _evolverFactory = param5;
         _stateChanger = param6;
         _nanovorSelector = param7;
         _treeViewMenu = param8;
         _colorProvider = param9;
         _controllerConsumer = param10;
         _nodes = new Dictionary();
         _nodeSelector = new EvoTreeGridNodeConsumerSelect(param7);
      }
      
      public function createEvoTreeGridNode(param1:int, param2:Boolean, param3:int, param4:int) : IEvoTreeGridNode
      {
         var _loc5_:int = int(_treeViewMenu.getNanovorsOfType(param1).length);
         var _loc6_:EvoTreeGridInfo = new EvoTreeGridInfo(_nanovorFactory,param1,_treeViewMenu,_nanovorSelector,IEvoTreeGridNodeController(this));
         var _loc7_:Boolean = Boolean(_virmonManager.getVirmonDataByAssetTypeId(param1) != null);
         var _loc8_:NanovorEvoTreeGridNode = new NanovorEvoTreeGridNode(param1,param2,_loc7_,param3,param4,_loc6_,_loc5_,_colorProvider);
         _loc8_.setConsumer(INanovorEvoTreeGridNodeConsumer(_nodeSelector));
         _nodes[param1] = _loc8_;
         return _loc8_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoTreeGridNodeController>>\t" + param1);
      }
      
      public function selectNanovor(param1:int, param2:INanovor) : void
      {
         var _loc4_:INanovorEvoTreeGridNode = null;
         var _loc5_:EvoTreeGridNodePuckModes = null;
         log("selectNanovor()");
         if(null != _currentNode)
         {
            _currentNode.toggleClick(true);
         }
         _currentNanovor = param2;
         var _loc3_:INanovorEvoTreeGridNode = _nodes[param1];
         _currentNode = _loc3_;
         _currentNode.toggleClick(false);
         for each(_loc4_ in _nodes)
         {
            _loc5_ = _loc4_ !== _loc3_ ? EvoTreeGridNodePuckModes.MODE_INACTIVE : EvoTreeGridNodePuckModes.MODE_SELECTED;
            _loc4_.setIconMode(_loc5_);
            _loc4_.setConsumer(INanovorEvoTreeGridNodeConsumer(_nodeSelector));
         }
         _currentNode.clearEvolveButtons();
         if(null != param2)
         {
            log("selectNanovor() - Looking at Nanovor assetId: " + param2.assetId);
            _currentNode.preselectSpecificNanovor(param2);
            _evoChecker.setConsumer(IEvoTreeEvoCheckerConsumer(this));
            _evoChecker.canEvolve(param2);
         }
      }
      
      public function reset() : void
      {
         var _loc1_:INanovorEvoTreeGridNode = null;
         for each(_loc1_ in _nodes)
         {
            _loc1_.setLineColor(_colorProvider.lineColorDefault);
            _loc1_.setIconMode(EvoTreeGridNodePuckModes.MODE_INACTIVE);
            _loc1_.setConsumer(_nodeSelector);
         }
      }
      
      private function processCanEvolveResponse(param1:IEvoTreeCanEvolveResponse) : void
      {
         var _loc2_:INanovorEvoTreeGridNode = _nodes[param1.destinationTypeId];
         if(null == _loc2_)
         {
            return;
         }
         var _loc3_:Boolean = Boolean(param1.canEvolve());
         var _loc4_:EvoTreeGridNodePuckModes = _loc3_ ? EvoTreeGridNodePuckModes.MODE_CAN_EVOLVE : EvoTreeGridNodePuckModes.MODE_CANT_EVOLVE;
         log("processCanEvolveResponse() - Evolve " + _currentNanovor.assetId + " " + _loc3_);
         var _loc5_:IEvoTreeEvolver = null;
         _evolverFactory;
         if(_loc3_)
         {
            _loc5_ = _evolverFactory.createEvoTreeEvolver(_currentNanovor.assetId,_loc2_.getEvoData());
         }
         var _loc6_:EvolveButton = new EvolveButton(param1,_loc5_,true);
         _currentNode.setEvolutionButtons(_loc2_,_loc6_);
         _loc2_.setIconMode(_loc4_);
         _loc2_.lineBackToSource(_loc3_);
         if(!_loc3_)
         {
            _loc2_.setCantEvolveReasons(param1);
         }
      }
      
      public function createConnectingEvoTreeGridNode(param1:int, param2:int) : IEvoTreeGridNode
      {
         return new EvoTreeGridNode(param1,param2,_colorProvider.lineColorInactive);
      }
      
      public function handleCanEvolve(param1:Array) : void
      {
         var _loc2_:IEvoTreeCanEvolveResponse = null;
         log("handleCanEvolve()");
         for each(_loc2_ in param1)
         {
            processCanEvolveResponse(_loc2_);
         }
      }
      
      public function gotoCollection(param1:INanovor) : void
      {
         var _loc2_:CollectionPreSelectData = null;
         if(null != param1)
         {
            _loc2_ = new CollectionPreSelectData();
            _loc2_.setPreSelectNanovor(param1);
            _stateChanger.setState(StateType.COLLECTION,_loc2_);
         }
      }
      
      private function findRoot() : IEvoTreeGridNode
      {
         var _loc1_:IEvoTreeGridNode = null;
         var _loc2_:INanovorEvoTreeGridNode = null;
         var _loc3_:int = 0;
         var _loc4_:* = _nodes;
         for each(_loc2_ in _loc4_)
         {
            _loc1_ = _loc2_ as IEvoTreeGridNode;
         }
         while(null != _loc1_.source)
         {
            _loc1_ = _loc1_.source;
         }
         return _loc1_;
      }
   }
}

