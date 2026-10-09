package com.arkadium.virmon.shared.data
{
   public class PedigreeEm implements IPedigreeEm
   {
      
      private var _name:String;
      
      private var _id:int;
      
      private var _isOwned:Boolean;
      
      public function PedigreeEm(param1:int, param2:String, param3:Boolean)
      {
         super();
         _id = param1;
         _name = param2;
         _isOwned = param3;
      }
      
      public function get isOwned() : Boolean
      {
         return _isOwned;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set isOwned(param1:Boolean) : void
      {
         _isOwned = param1;
      }
      
      public function get id() : int
      {
         return _id;
      }
   }
}

