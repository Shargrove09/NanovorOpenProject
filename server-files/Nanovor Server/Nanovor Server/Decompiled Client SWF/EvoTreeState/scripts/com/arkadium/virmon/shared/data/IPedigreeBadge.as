package com.arkadium.virmon.shared.data
{
   public interface IPedigreeBadge
   {
      
      function get goal() : Number;
      
      function set goal(param1:Number) : void;
      
      function set progress(param1:int) : void;
      
      function get isOwned() : Boolean;
      
      function get prereqDesc() : String;
      
      function get progress() : int;
      
      function get badgeId() : int;
   }
}

