package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import flash.utils.Dictionary;
   
   public class TreeViewMenuData implements ITreeViewMenuData
   {
      
      private var _nanovorsIdsInTrees:Array;
      
      private var _treeNames:Dictionary;
      
      private var _nanovors:Array;
      
      public function TreeViewMenuData(param1:INanovorFactory, param2:IEvoManager, param3:IVirmonManager)
      {
         super();
         _nanovorsIdsInTrees = param2.getNanovorIdsInTrees();
         _treeNames = param2.getTreeNames();
         var _loc4_:Array = param3.getVirmonDataList();
         _nanovors = new Array();
         var _loc5_:* = 0;
         while(_loc5_ < _loc4_.length)
         {
            _nanovors.push(param1.createNanovorInstanceById(_loc4_[_loc5_].getAssetID()));
            _loc5_++;
         }
      }
      
      public function get nanovors() : Array
      {
         return _nanovors;
      }
      
      public function get nanovorsIdsInTrees() : Array
      {
         return _nanovorsIdsInTrees;
      }
      
      public function get treeNames() : Dictionary
      {
         return _treeNames;
      }
   }
}

