package com.arkadium.virmon.shared.widgets
{
   public interface IWidget
   {
      
      function init(param1:Object = null) : void;
      
      function destroy() : void;
      
      function setMode(param1:String) : void;
      
      function get widgetName() : String;
   }
}

