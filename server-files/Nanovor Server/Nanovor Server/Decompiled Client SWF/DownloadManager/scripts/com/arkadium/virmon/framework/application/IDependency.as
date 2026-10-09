package com.arkadium.virmon.framework.application
{
   public interface IDependency
   {
      
      function get isOutdated() : Boolean;
      
      function toString() : String;
   }
}

