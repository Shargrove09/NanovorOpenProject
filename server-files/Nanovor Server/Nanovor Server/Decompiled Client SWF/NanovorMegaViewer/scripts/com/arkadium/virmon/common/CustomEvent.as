package com.arkadium.virmon.common
{
   import flash.events.Event;
   
   public class CustomEvent extends Event
   {
      
      public var data:Object;
      
      public function CustomEvent(param1:String, param2:Object, param3:Boolean = false)
      {
         super(param1,param3);
         data = param2;
      }
   }
}

