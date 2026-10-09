package com.arkadium.virmon.battle.control
{
   import flash.events.Event;
   
   public class BattleEngineEvent extends Event
   {
      
      public static const UPDATE_PLAYER_WIDGET:String = "updatePlayerWidget";
      
      public static const INITIALIZE:String = "initialize";
      
      public static const QUIT_GAME:String = "quitGame";
      
      protected var _rowIndex:int;
      
      protected var _data:Object;
      
      public function BattleEngineEvent(param1:String, param2:* = null)
      {
         super(param1,false,false);
         _data = param2;
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      override public function toString() : String
      {
         return formatToString("BattleEngineEvent","type","bubbles","cancelable","data");
      }
   }
}

