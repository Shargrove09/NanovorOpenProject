package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   public interface ITreeViewMenu
   {
      
      function autoSelectFirstTree() : void;
      
      function autoSelectByAssetTypeId(param1:int) : void;
      
      function getNanovorsOfType(param1:int) : Array;
      
      function autoSelectFirstRoot() : void;
      
      function autoSelectByAssetId(param1:String) : void;
      
      function showCollectionTiles(param1:Boolean) : void;
      
      function handleTileScrollerPaging(param1:int) : void;
      
      function allowEmptyTreeSelect() : void;
   }
}

