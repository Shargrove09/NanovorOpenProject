package com.arkadium.virmon.loginpanel
{
   import flash.events.IOErrorEvent;
   
   public interface IShardDataHandler
   {
      
      function shardDataError(param1:IOErrorEvent) : void;
      
      function shardDataReceived(param1:Array) : void;
      
      function shardDataEmpty(param1:String) : void;
   }
}

