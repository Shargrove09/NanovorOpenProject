package com.arkadium.virmon.shared.data
{
   public class PedigreeBadge implements IPedigreeBadge
   {
      
      private var _progress:int;
      
      private var _isOwned:Boolean;
      
      private var _badgeId:int;
      
      private var _prereqDesc:String;
      
      private var _goal:Number;
      
      public function PedigreeBadge(param1:int, param2:Boolean, param3:String, param4:int, param5:Number)
      {
         super();
         _badgeId = param1;
         _isOwned = param2;
         _prereqDesc = param3;
         _progress = param4;
         _goal = param5;
      }
      
      public function set progress(param1:int) : void
      {
         _progress = param1;
      }
      
      public function get goal() : Number
      {
         return _goal;
      }
      
      public function get badgeId() : int
      {
         return _badgeId;
      }
      
      public function set goal(param1:Number) : void
      {
         _goal = param1;
      }
      
      public function get isOwned() : Boolean
      {
         return _isOwned;
      }
      
      public function get prereqDesc() : String
      {
         return _prereqDesc;
      }
      
      public function get progress() : int
      {
         return _progress;
      }
   }
}

