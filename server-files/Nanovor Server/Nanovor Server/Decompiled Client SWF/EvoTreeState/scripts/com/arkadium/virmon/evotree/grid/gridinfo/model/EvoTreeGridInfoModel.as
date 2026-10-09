package com.arkadium.virmon.evotree.grid.gridinfo.model
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.grid.IEvoTreeGridNodeController;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.ITreeViewMenu;
   import flash.utils.Dictionary;
   
   public class EvoTreeGridInfoModel implements IEvoTreeGridInfoModel
   {
      
      private var _treeViewMenu:ITreeViewMenu;
      
      private var _gridNodeController:IEvoTreeGridNodeController;
      
      private var _currentNanovorIndex:int;
      
      private var _currentNanovor:INanovor;
      
      private var _currentTreeId:int;
      
      private var _consumers:Dictionary;
      
      private var _allNanovorsOfThisType:Array;
      
      public function EvoTreeGridInfoModel(param1:int, param2:ITreeViewMenu, param3:IEvoTreeGridNodeController)
      {
         super();
         _treeViewMenu = param2;
         _gridNodeController = param3;
         _consumers = new Dictionary(true);
         _currentNanovorIndex = 0;
         _allNanovorsOfThisType = _treeViewMenu.getNanovorsOfType(param1);
      }
      
      private function updateSelectedNanovor() : void
      {
         var _loc1_:INanovor = _allNanovorsOfThisType[_currentNanovorIndex] as INanovor;
         _gridNodeController.selectNanovor(_loc1_.assetTypeId,_loc1_);
         handleNanovorSelected(_loc1_,_currentNanovorIndex,_allNanovorsOfThisType.length);
      }
      
      public function selectNanovor(param1:INanovor) : void
      {
         var _loc5_:INanovor = null;
         var _loc2_:int = 0;
         var _loc3_:INanovor = null;
         var _loc4_:int = 0;
         while(_loc4_ < _allNanovorsOfThisType.length)
         {
            _loc5_ = _allNanovorsOfThisType[_loc4_];
            if(_loc5_.assetId == param1.assetId)
            {
               _loc2_ = _loc4_;
               _loc3_ = _loc5_;
               break;
            }
            _loc4_++;
         }
         if(null != _loc3_)
         {
            _currentNanovorIndex = _loc2_;
            handleNanovorSelected(_loc3_,_currentNanovorIndex,_allNanovorsOfThisType.length);
         }
      }
      
      public function addConsumer(param1:IEvoTreeGridInfoModelConsumer) : void
      {
         _consumers[param1] = param1;
      }
      
      public function init() : void
      {
         handleNanovorSelected(_allNanovorsOfThisType[_currentNanovorIndex],_currentNanovorIndex,_allNanovorsOfThisType.length);
      }
      
      public function selectPreviousNanovor() : void
      {
         --_currentNanovorIndex;
         _currentNanovorIndex += _allNanovorsOfThisType.length;
         _currentNanovorIndex %= _allNanovorsOfThisType.length;
         updateSelectedNanovor();
      }
      
      private function handleNanovorSelected(param1:INanovor, param2:int, param3:int) : void
      {
         var _loc4_:IEvoTreeGridInfoModelConsumer = null;
         for each(_loc4_ in _consumers)
         {
            _loc4_.handleNanovorSelected(param1,param2,param3);
         }
      }
      
      public function gotoCollection() : void
      {
         _gridNodeController.gotoCollection(_allNanovorsOfThisType[_currentNanovorIndex]);
      }
      
      public function selectNextNanovor() : void
      {
         ++_currentNanovorIndex;
         _currentNanovorIndex %= _allNanovorsOfThisType.length;
         updateSelectedNanovor();
      }
   }
}

