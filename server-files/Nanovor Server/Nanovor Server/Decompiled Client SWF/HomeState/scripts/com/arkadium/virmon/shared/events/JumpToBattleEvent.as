package com.arkadium.virmon.shared.events
{
   import flash.events.Event;
   
   public class JumpToBattleEvent extends Event
   {
      
      public static const SOLO_BATTLE:String = "JumpToBattleEvent::soloBattle";
      
      public static const AUTO_BATTLE:String = "JumpToBattleEvent::autoBattle";
      
      private var _aiPlayerId:int;
      
      public function JumpToBattleEvent(param1:String, param2:int = 0, param3:Boolean = false, param4:Boolean = false)
      {
         _aiPlayerId = param2;
         super(param1,param3,param4);
      }
      
      override public function toString() : String
      {
         return formatToString("JumpToBattleEvent","type","aiPlayerId","bubbles","cancelable","eventPhase");
      }
      
      public function get aiPlayerId() : int
      {
         return _aiPlayerId;
      }
      
      override public function clone() : Event
      {
         return new JumpToBattleEvent(type,_aiPlayerId,bubbles,cancelable);
      }
   }
}

