package com.arkadium.virmon.battle.substates.swarmchooser
{
   import com.arkadium.virmon.battle.control.INanovor;
   import flash.events.Event;
   
   public class SwarmContainerEvent extends Event
   {
      
      public static const NANOVOR_REMOVED:String = "nanovorRemoved";
      
      public var nanovor:INanovor;
      
      public function SwarmContainerEvent(param1:String, param2:INanovor, param3:Boolean = false)
      {
         super(param1,param3);
         nanovor = param2;
      }
   }
}

