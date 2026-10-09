package com.arkadium.virmon.battle.substates.gameover
{
   import flash.events.Event;
   
   public class GameOverSlotColumnEvent extends Event
   {
      
      public static const COLUMN_OPENED:String = "opened";
      
      public static const COLUMN_CLOSED:String = "closed";
      
      public static const BADGES_COLUMN_OPENED:String = "badgesOpened";
      
      public static const BADGES_COLUMN_CLOSED:String = "badgesClosed";
      
      public static const COLUMN_PLACEMENT_OPENED:String = "columnPlacementOpened";
      
      public static const PLAYER_BADGES_CLICK:String = "playerBadgesClick";
      
      public static const NANOVOR_BADGES_CLICK:String = "nanovorBadgesClick";
      
      public function GameOverSlotColumnEvent(param1:String, param2:Boolean = false)
      {
         super(param1,param2);
      }
   }
}

