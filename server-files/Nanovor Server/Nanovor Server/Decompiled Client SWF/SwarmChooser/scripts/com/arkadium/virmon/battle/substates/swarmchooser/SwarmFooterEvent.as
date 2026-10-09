package com.arkadium.virmon.battle.substates.swarmchooser
{
   import flash.events.Event;
   
   public class SwarmFooterEvent extends Event
   {
      
      public static const STARTBATTLE_CLICK:String = "startBattleClick";
      
      public static const TIMER_COMPLETE:String = "timerComplete";
      
      public var data:Object;
      
      public function SwarmFooterEvent(param1:String, param2:Object = null, param3:Boolean = false)
      {
         super(param1,param3);
         data = param2;
      }
   }
}

