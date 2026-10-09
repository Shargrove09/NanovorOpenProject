package com.arkadium.virmon.shared.components
{
   public interface ISwarmometer
   {
      
      function setNanovorInfo(param1:String, param2:int, param3:String = "", param4:String = "", param5:int = 1) : void;
      
      function hide() : void;
      
      function clearMeters() : void;
      
      function get METER_POPUPS_OFFSET_ALT_LEFT() : int;
      
      function setMySwarmInfo(param1:Array) : void;
      
      function setSwarmCount(param1:int, param2:int) : void;
      
      function show() : void;
      
      function get METER_POPUPS_OFFSET_DEFAULT() : int;
      
      function sortMeters(param1:Number = 0.7, param2:Number = 0.5) : void;
   }
}

