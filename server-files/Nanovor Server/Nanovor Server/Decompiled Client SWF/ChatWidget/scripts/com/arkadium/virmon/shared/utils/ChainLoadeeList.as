package com.arkadium.virmon.shared.utils
{
   public class ChainLoadeeList
   {
      
      private var _list:Array;
      
      public function ChainLoadeeList()
      {
         super();
         this._list = new Array();
      }
      
      public function add(param1:IChainLoadee) : void
      {
         this._list.push(param1);
      }
      
      public function at(param1:uint) : IChainLoadee
      {
         return this._list[param1] as IChainLoadee;
      }
      
      public function get length() : uint
      {
         return this._list.length;
      }
      
      public function chainCacheeAt(param1:uint) : IChainCachee
      {
         return this._list[param1] as IChainCachee;
      }
      
      public function destroy() : void
      {
         this._list = null;
      }
   }
}

