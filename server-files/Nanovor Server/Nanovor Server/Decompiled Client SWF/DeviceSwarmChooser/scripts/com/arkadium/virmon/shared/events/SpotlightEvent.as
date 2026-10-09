package com.arkadium.virmon.shared.events
{
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import flash.events.Event;
   
   public class SpotlightEvent extends Event
   {
      
      public static const SPOTLIGHT_CHASER_END:String = "spotlightChaserEnd";
      
      public static const SPOTLIGHT_CHASER_HALF_DONE:String = "spotlightChaserHalfBaked";
      
      public static const SPOTLIGHT_OPENED:String = "spotlightOpened";
      
      public static const SPOTLIGHT_CLOSED:String = "spotlightClosed";
      
      public static const SPOTLIGHT_LIGHT_OPENED:String = "spotlightLightOpened";
      
      public static const SPOTLIGHT_LIGHT_CLOSED:String = "spotlightLightClosed";
      
      public static const SPOTLIGHT_CHASERS_KILLED:String = "spotlightChaserKilled";
      
      public var spotlight:Spotlight;
      
      public function SpotlightEvent(param1:String, param2:Spotlight, param3:Boolean = false)
      {
         super(param1,param3);
         spotlight = param2;
      }
   }
}

