package com.smithandtinker.nanovor.common.event
{
   import flash.events.Event;
   
   public class PanelEvent extends Event
   {
      
      public static const UNREGISTER:String = "PANEL_EVENT::UNREGISTER";
      
      public static const START_EVOLUTION:String = "PANEL_EVENT::START_EVOLUTION";
      
      private var _data:Object;
      
      public function PanelEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
      {
         _data = param4;
         super(param1,param2,param3);
      }
      
      public function get data() : Object
      {
         return _data;
      }
   }
}

