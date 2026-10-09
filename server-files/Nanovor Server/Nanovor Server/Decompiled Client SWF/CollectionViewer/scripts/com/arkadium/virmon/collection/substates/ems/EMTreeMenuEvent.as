package com.arkadium.virmon.collection.substates.ems
{
   import flash.events.Event;
   
   public class EMTreeMenuEvent extends Event
   {
      
      public static const FACTIONTILE_ROLLOVER:String = "factionTileRollOver";
      
      public static const FACTIONTILE_ROLLOUT:String = "factionTileRollOut";
      
      public static const FACTIONTILE_CLICK:String = "factionTileClick";
      
      public static const EMTILE_ROLLOVER:String = "emTileRollOver";
      
      public static const EMTILE_ROLLOUT:String = "emTileRollOut";
      
      public static const EMTILE_CLICK:String = "emTileClick";
      
      public static const EM_OPENED:String = "emOpened";
      
      public var data:Object;
      
      public function EMTreeMenuEvent(param1:String, param2:Object, param3:Boolean = false)
      {
         super(param1,param3);
         data = param2;
      }
   }
}

