package com.arkadium.virmon.shared.data
{
   public interface IPedigreeEm
   {
      
      function get name() : String;
      
      function get id() : int;
      
      function get isOwned() : Boolean;
      
      function set isOwned(param1:Boolean) : void;
   }
}

