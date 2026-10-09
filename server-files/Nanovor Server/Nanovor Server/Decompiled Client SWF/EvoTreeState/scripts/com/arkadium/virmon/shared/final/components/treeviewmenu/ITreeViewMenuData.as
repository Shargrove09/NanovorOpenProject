package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import flash.utils.Dictionary;
   
   public interface ITreeViewMenuData
   {
      
      function get treeNames() : Dictionary;
      
      function get nanovors() : Array;
      
      function get nanovorsIdsInTrees() : Array;
   }
}

