package com.arkadium.virmon.evotree.grid.treebuilder
{
   import com.arkadium.virmon.evotree.grid.IEvoTreeGridNodeController;
   import com.arkadium.virmon.evotree.grid.node.IEvoTreeGridNode;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.IEvoTreeGridColorProvider;
   import com.arkadium.virmon.framework.EvoData;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class AbstractEvoTreeGridSubTreeController implements IEvoTreeGridSubTreeController
   {
      
      protected var _root:IEvoTreeGridNode;
      
      protected var _evoTreeGridNodes:Dictionary;
      
      protected var _colorProvider:IEvoTreeGridColorProvider;
      
      protected var _nodeController:IEvoTreeGridNodeController;
      
      public function AbstractEvoTreeGridSubTreeController(param1:int, param2:Array, param3:IEvoTreeGridNodeController, param4:IEvoTreeGridColorProvider)
      {
         super();
         _nodeController = param3;
         _colorProvider = param4;
         _evoTreeGridNodes = new Dictionary();
         var _loc5_:Array = getTreeEvoList(param1,param2);
         createNodes(_loc5_);
         createPaths(_loc5_);
         findRoot();
      }
      
      private function createNodes(param1:Array) : void
      {
         var _loc2_:EvoData = null;
         var _loc3_:IEvoTreeGridNode = null;
         var _loc4_:IEvoTreeGridNode = null;
         for each(_loc2_ in param1)
         {
            if(null == _evoTreeGridNodes[_loc2_.getSourceTypeID()])
            {
               _loc4_ = _nodeController.createEvoTreeGridNode(_loc2_.getSourceTypeID(),true,_loc2_.getSourceXPos(),_loc2_.getSourceYPos());
               log("createNodes() - Created source node typeId: " + _loc2_.getSourceTypeID());
               _evoTreeGridNodes[_loc2_.getSourceTypeID()] = _loc4_;
            }
            _loc3_ = _evoTreeGridNodes[_loc2_.getDestinationTypeID()];
            if(null == _loc3_)
            {
               _loc3_ = _nodeController.createEvoTreeGridNode(_loc2_.getDestinationTypeID(),_loc2_.getIsDiscovered(),_loc2_.getDestinationXPos(),_loc2_.getDestinationYPos());
               log("createNodes() - Created destination node typeId: " + _loc2_.getSourceTypeID());
               _evoTreeGridNodes[_loc2_.getDestinationTypeID()] = _loc3_;
            }
            _loc3_.setEvoData(_loc2_);
         }
      }
      
      protected function setLineColors(param1:IEvoTreeGridNode) : void
      {
         var _loc2_:IEvoTreeGridNode = null;
         var _loc3_:IEvoTreeGridNode = null;
         for each(_loc2_ in _evoTreeGridNodes)
         {
            _loc2_.setLineColor(_colorProvider.lineColorInactive);
         }
         _loc3_ = param1;
         while(null != _loc3_)
         {
            _loc3_.setLineColor(_colorProvider.lineColorActive);
            _loc3_ = _loc3_.source;
         }
      }
      
      private function getTreeEvoList(param1:int, param2:Array) : Array
      {
         var _loc4_:EvoData = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param2)
         {
            if(_loc4_.getTreeID() == param1)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AbstractEvoTreeTreeBuilder>>\t" + param1);
      }
      
      public function reset() : void
      {
         var _loc1_:IEvoTreeGridNode = null;
         _root.setOffset(0);
         for each(_loc1_ in _evoTreeGridNodes)
         {
            _loc1_.setLineColor(_colorProvider.lineColorInactive);
            _loc1_.drawLineToParent();
         }
      }
      
      public function selectNodeByNanovor(param1:int) : void
      {
         throw new Error("selectNodeByNanovor must be override by derived classes");
      }
      
      private function createPaths(param1:Array) : void
      {
         var _loc3_:EvoData = null;
         var _loc4_:IEvoTreeGridNode = null;
         var _loc5_:IEvoTreeGridNode = null;
         var _loc6_:IEvoTreeGridNode = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            log("createPaths() - source: " + _loc3_.getSourceTypeID());
            log("createPaths() - destination: " + _loc3_.getDestinationTypeID());
            _loc4_ = _evoTreeGridNodes[_loc3_.getSourceTypeID()];
            _loc5_ = _evoTreeGridNodes[_loc3_.getDestinationTypeID()];
            _loc6_ = null;
            if(_loc4_.positionY != _loc5_.positionY)
            {
               _loc6_ = _nodeController.createConnectingEvoTreeGridNode(_loc4_.positionX,_loc5_.positionY);
               _evoTreeGridNodes["NullNode" + _loc2_.toString()] = _loc6_;
               _loc2_++;
               _loc6_.setSource(_loc4_);
               _loc6_.setDestination(_loc5_);
               _loc4_.setDestination(_loc6_);
               _loc5_.setSource(_loc6_);
            }
            else
            {
               _loc4_.setDestination(_loc5_);
               _loc5_.setSource(_loc4_);
            }
         }
      }
      
      public function getRoot() : IEvoTreeGridNode
      {
         return _root;
      }
      
      private function findRoot() : void
      {
         var _loc1_:IEvoTreeGridNode = null;
         for each(_loc1_ in _evoTreeGridNodes)
         {
            if(null == _loc1_.source)
            {
               _root = _loc1_;
               return;
            }
         }
      }
   }
}

