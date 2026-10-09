package com.arkadium.virmon.framework.application
{
   public interface IApplicationFile extends IDependency
   {
      
      function set CRC(param1:String) : void;
      
      function get id() : String;
      
      function get CRC() : String;
      
      function get filename() : String;
   }
}

