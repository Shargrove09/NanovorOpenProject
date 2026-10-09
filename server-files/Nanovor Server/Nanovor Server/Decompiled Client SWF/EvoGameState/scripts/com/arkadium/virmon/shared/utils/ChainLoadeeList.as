package com.arkadium.virmon.shared.utils
{
   public class ChainLoadeeList
   {
      
      private var _list:Array;
      
      public function ChainLoadeeList()
      {
         super();
         _list = new Array();
      }
      
      public function add(param1:IChainLoadee) : void
      {
         _list.push(param1);
      }
      
      public function at(param1:uint) : IChainLoadee
      {
         return _list[param1] as IChainLoadee;
      }
      
      public function get length() : uint
      {
         return _list.length;
      }
      
      public function chainCacheeAt(param1:uint) : IChainCachee
      {
         return _list[param1] as IChainCachee;
      }
      
      public function destroy() : void
      {
         _list = null;
      }
   }
}

