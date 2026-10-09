package com.arkadium.virmon.common
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class EventManager extends EventDispatcher
   {
      
      private static var instance:EventManager = new EventManager();
      
      private static var isDashboard:Boolean = true;
      
      private static var isDialogOpen:Boolean = false;
      
      public function EventManager()
      {
         super();
         if(Boolean(instance))
         {
            throw new Error("EventManager is a Singleton and can only be accessed through EventManager.getInstance()");
         }
      }
      
      public static function getInstance() : EventManager
      {
         return instance;
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         return super.dispatchEvent(param1);
      }
   }
}

