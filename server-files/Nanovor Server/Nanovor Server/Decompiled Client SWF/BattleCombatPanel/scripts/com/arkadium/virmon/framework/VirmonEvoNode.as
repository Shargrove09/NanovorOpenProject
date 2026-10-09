package com.arkadium.virmon.framework
{
   public class VirmonEvoNode
   {
      
      private var _aChildNodes:Array;
      
      private var _iVirmonClassID:int;
      
      private var _iEvoLevel:int;
      
      public function VirmonEvoNode()
      {
         super();
         _iVirmonClassID = undefined;
         _iEvoLevel = undefined;
         _aChildNodes = undefined;
      }
      
      public function getVirmonClassID() : int
      {
         return _iVirmonClassID;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         _iVirmonClassID = param1.@id;
         _iEvoLevel = param1.@level;
         var _loc2_:XMLList = param1.virmon;
         _aChildNodes = new Array(_loc2_.length());
         var _loc3_:int = 0;
         while(_loc3_ < _aChildNodes.length)
         {
            _aChildNodes[_loc3_] = new VirmonEvoNode();
            _aChildNodes[_loc3_].parseXMLData(_loc2_[_loc3_]);
            _loc3_++;
         }
         trace(_iVirmonClassID);
      }
      
      public function getChildNodes() : Array
      {
         return _aChildNodes;
      }
      
      public function getEvoLevel() : int
      {
         return _iEvoLevel;
      }
   }
}

