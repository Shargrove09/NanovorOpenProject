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
         this._iVirmonClassID = undefined;
         this._iEvoLevel = undefined;
         this._aChildNodes = undefined;
      }
      
      public function getVirmonClassID() : int
      {
         return this._iVirmonClassID;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         this._iVirmonClassID = param1.@id;
         this._iEvoLevel = param1.@level;
         var _loc2_:XMLList = param1.virmon;
         this._aChildNodes = new Array(_loc2_.length());
         var _loc3_:int = 0;
         while(_loc3_ < this._aChildNodes.length)
         {
            this._aChildNodes[_loc3_] = new VirmonEvoNode();
            this._aChildNodes[_loc3_].parseXMLData(_loc2_[_loc3_]);
            _loc3_++;
         }
         trace(this._iVirmonClassID);
      }
      
      public function getChildNodes() : Array
      {
         return this._aChildNodes;
      }
      
      public function getEvoLevel() : int
      {
         return this._iEvoLevel;
      }
   }
}

