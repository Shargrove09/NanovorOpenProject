package com.arkadium.virmon.shared.renders
{
   public interface ICellRenderer
   {
      
      function set x(param1:Number) : void;
      
      function set y(param1:Number) : void;
      
      function setSize(param1:Number, param2:Number) : void;
      
      function set data(param1:Object) : void;
      
      function get data() : Object;
   }
}

