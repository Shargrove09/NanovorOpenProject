package com.arkadium.virmon.loginpanel
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class ShardData
   {
      
      private var _shards:Array;
      
      private var _handler:IShardDataHandler;
      
      public function ShardData(param1:IShardDataHandler, param2:IServiceRequestBrokerManager)
      {
         super();
         _handler = param1;
         param2.requestShardData(shardDataReceived,shardDataError);
      }
      
      private function shardDataError(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,shardDataReceived);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,shardDataError);
         _handler.shardDataError(param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("ShardMenu >> " + param1);
      }
      
      private function sortOnUsers(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = param1.maxcapacity - param1.usedcapacity;
         var _loc4_:int = param2.maxcapacity - param2.usedcapacity;
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      private function shardDataReceived(param1:Event) : void
      {
         var fullShards:Array;
         var xmlString:String;
         var i:int;
         var k:*;
         var totalShards:int;
         var xml:XML = null;
         var curShard:XML = null;
         var data:Object = null;
         var locales:XML = null;
         var totalLocales:int = 0;
         var j:* = undefined;
         var e:Event = param1;
         e.target.removeEventListener(Event.COMPLETE,shardDataReceived);
         e.target.removeEventListener(IOErrorEvent.IO_ERROR,shardDataError);
         xmlString = String(e.target.data);
         try
         {
            xml = new XML(xmlString);
         }
         catch(err:Error)
         {
            _handler.shardDataEmpty("Invalid XML loaded.  Error details: " + err.message);
            return;
         }
         xml = Utils.StripXmlNamespace(XML(xmlString));
         totalShards = int(xml.child("shard").length());
         if(totalShards == 0)
         {
            _handler.shardDataEmpty("No shard choices found in server response.");
            return;
         }
         _shards = new Array();
         fullShards = new Array();
         i = 0;
         while(i < totalShards)
         {
            curShard = xml.child("shard")[i];
            data = new Object();
            data.name = String(curShard.child("name")[0]);
            data.url = String(curShard.child("url")[0]);
            data.maxcapacity = int(curShard.child("max-capacity")[0]);
            data.usedcapacity = int(curShard.child("used-capacity")[0]);
            data.nice = int(curShard.child("nice")[0]);
            data.population = String(curShard.child("population")[0]);
            data.locales = new Array();
            locales = curShard.child("locales")[0];
            totalLocales = int(locales.child("locale").length());
            j = 0;
            while(j < totalLocales)
            {
               data.locales[j] = String(locales.child("locale")[j]);
               j++;
            }
            data.full = false;
            if(data.usedcapacity >= data.maxcapacity)
            {
               data.full = true;
               fullShards.push(data);
            }
            else
            {
               _shards.push(data);
            }
            i++;
         }
         _shards.sort(sortOnUsers);
         k = 0;
         while(k < fullShards.length)
         {
            _shards.push(fullShards.pop());
            k++;
         }
         _handler.shardDataReceived(_shards);
      }
      
      public function get shardList() : Array
      {
         return _shards;
      }
   }
}

