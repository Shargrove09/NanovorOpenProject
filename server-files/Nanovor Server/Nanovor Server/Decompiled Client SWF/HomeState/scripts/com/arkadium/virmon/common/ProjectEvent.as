package com.arkadium.virmon.common
{
   import flash.events.Event;
   
   public class ProjectEvent extends Event
   {
      
      public static const SOME_EVENT:String = "ProjectEvent.onSomeEvent";
      
      public static const SHOW_TEXT_MESSAGE:String = "ProjectEvent.showTextMessage";
      
      public static const TOGGLE_WAITING_VISIBLE:String = "ProjectEvent.toggleWaitingLoopVisible";
      
      public static const GAME_LOAD_COMPLETE:String = "ProjectEvent.GameLoadComplete";
      
      public var params:Object;
      
      public function ProjectEvent(param1:String, param2:Object = null)
      {
         super(param1,true,true);
         this.params = param2;
      }
      
      override public function toString() : String
      {
         return "[Event ProjectEvent]";
      }
      
      override public function clone() : Event
      {
         return new ProjectEvent(this.type,this.params);
      }
   }
}

