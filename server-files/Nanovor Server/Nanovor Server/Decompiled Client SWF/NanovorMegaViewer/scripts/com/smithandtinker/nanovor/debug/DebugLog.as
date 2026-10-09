package com.smithandtinker.nanovor.debug
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.shared.events.GlobalLogEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   
   public class DebugLog implements IFilterChecker, IDebugFilterReceiverHandler
   {
      
      protected static var __instance:DebugLog;
      
      protected static const CONNECTION_NAME:String = "DebugLog";
      
      protected static const FILTER_CONNECTION_NAME:String = "DebugLogFilterChannel";
      
      private var _debugFilterReceiver:DebugFilterReceiver;
      
      private var _filterSplit:Array;
      
      protected var __lcFilterSender:LocalConnection;
      
      private var _iTieBreaker:Number = 0;
      
      private var _aPreFilterInitLogBuffer:Array;
      
      private var _filter:String = "";
      
      private var _bFilterReceiverInited:Boolean = false;
      
      private var _filterUseAny:Boolean;
      
      protected var __lcSender:LocalConnection;
      
      protected var __sClientReference:String;
      
      protected var __bDebug:Boolean;
      
      private var _username:String;
      
      private var _deferredLogSender:DeferredLogSender;
      
      public function DebugLog()
      {
         _aPreFilterInitLogBuffer = new Array();
         super();
         __sClientReference = String(int(Math.random() * 100));
         __lcSender = new LocalConnection();
         __lcFilterSender = new LocalConnection();
         _deferredLogSender = new DeferredLogSender(this,CONNECTION_NAME,__lcSender);
         __lcSender.addEventListener(StatusEvent.STATUS,_statusHandler);
         __lcFilterSender.addEventListener(StatusEvent.STATUS,_filterStatusHandler);
         __bDebug = false;
         _debugFilterReceiver = new DebugFilterReceiver(this);
         try
         {
            __lcFilterSender.send(FILTER_CONNECTION_NAME,"registerFilterReceiver",_debugFilterReceiver.key,_debugFilterReceiver.displayName);
         }
         catch(e:Error)
         {
            _debugFilterReceiver.disable();
            handleReceiverRegistered();
         }
         EventManager.getInstance().addEventListener(GlobalLogEvent.LOG,onGlobalLogEvent,false,0,true);
         EventManager.getInstance().addEventListener(GlobalLogEvent.ERROR,onGlobalLogEvent,false,0,true);
      }
      
      public static function get instance() : DebugLog
      {
         if(__instance == null)
         {
            __instance = new DebugLog();
         }
         return __instance;
      }
      
      public function log(param1:String, param2:String = null, param3:int = -1, param4:Number = -1) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(!__bDebug)
         {
            return;
         }
         if(!_bFilterReceiverInited)
         {
            _aPreFilterInitLogBuffer.push([param1,param2,param3,_getTimeStamp()]);
            return;
         }
         if(param3 == -1 && !passesFilter(param1 + param2))
         {
            return;
         }
         trace(param1);
         var _loc5_:String = "";
         if(param1.length > 10000)
         {
            _loc6_ = false;
            if(param3 == -1)
            {
               param3 = int(Math.random() * 1000000);
               _loc6_ = true;
            }
            _loc7_ = int(param1.indexOf("\n",param1.length - 10000));
            _loc7_ = 1 + (_loc7_ == -1 ? param1.length - 10000 : _loc7_);
            _loc5_ = param1.substr(0,_loc7_);
            param1 = "[... log split for large packet, id=" + param3 + "]\n" + param1.substring(_loc5_.length);
            if(_loc6_)
            {
               param1 += "\n[ TOTAL END for log split id=" + param3 + " ]";
            }
            else
            {
               param1 += "\n[ log split chunk END, continued with split id=" + param3 + "...]";
            }
         }
         else
         {
            param1 = _getSender(param2) + " " + param1;
            if(param3 != -1)
            {
               param1 += "\n[ log split, continued with split id=" + param3 + "...]";
            }
         }
         _deferredLogSender.log(param1,param4 == -1 ? _getTimeStamp() : param4,_iTieBreaker);
         if(Boolean(_loc5_.length))
         {
            log(_loc5_,param2,param3);
         }
      }
      
      private function _getSender(param1:*) : String
      {
         if(param1 === null)
         {
            if(_username == null || _username == "")
            {
               return __sClientReference;
            }
            return _username;
         }
         return param1;
      }
      
      public function error(param1:String, param2:String = null, param3:Number = -1) : void
      {
         if(!__bDebug)
         {
            return;
         }
         trace(param1);
         if(param1.length > 10000)
         {
            param1 = param1.substr(0,10000) + "\n!!!! ---- ERROR MESSAGE TRUNCATED ---- !!!!";
         }
         param1 = _getSender(param2) + " " + param1;
         __lcSender.send(CONNECTION_NAME,"error",param1,param3 == -1 ? _getTimeStamp() : param3,_iTieBreaker);
      }
      
      public function handleFilterChange(param1:String) : void
      {
         _filter = param1.toLowerCase();
         _filterUseAny = false;
         _filterSplit = _filter.split("|");
         if(_filterSplit.length == 1)
         {
            _filterUseAny = true;
            _filterSplit = _filter.split("&");
         }
      }
      
      public function handlePolledRegistration() : void
      {
         try
         {
            __lcFilterSender.send(FILTER_CONNECTION_NAME,"registerFilterReceiver",_debugFilterReceiver.key,_debugFilterReceiver.displayName,_debugFilterReceiver.currentFilter);
         }
         catch(e:Error)
         {
            _debugFilterReceiver.disable();
         }
      }
      
      public function clear() : void
      {
         if(!__bDebug)
         {
            return;
         }
         __lcSender.send(CONNECTION_NAME,"clear");
      }
      
      public function passesFilter(param1:String) : Boolean
      {
         if(!__bDebug)
         {
            return false;
         }
         if(_filter == "")
         {
            return true;
         }
         if(_filterSplit.length > 1)
         {
            if(matchFilters(param1.toLowerCase(),_filterSplit,_filterUseAny))
            {
               return true;
            }
            return false;
         }
         return param1.toLowerCase().indexOf(_filter) != -1;
      }
      
      public function comment(param1:String) : void
      {
         if(!__bDebug)
         {
            return;
         }
         trace(param1);
         param1 = __sClientReference + " " + param1;
         if(param1.length > 10000)
         {
            param1 = param1.substr(0,10000);
         }
         __lcSender.send(CONNECTION_NAME,"comment",param1,_getTimeStamp(),_iTieBreaker);
      }
      
      public function handleReceiverRegistered() : void
      {
         var _loc1_:Array = null;
         if(_bFilterReceiverInited)
         {
            return;
         }
         _bFilterReceiverInited = true;
         while(_aPreFilterInitLogBuffer.length > 0)
         {
            _loc1_ = _aPreFilterInitLogBuffer.shift();
            log(_loc1_[0],_loc1_[1],_loc1_[2],_loc1_[3]);
         }
      }
      
      private function _filterStatusHandler(param1:StatusEvent) : void
      {
         if(param1.level == "error")
         {
            handleReceiverRegistered();
         }
      }
      
      private function matchFilters(param1:String, param2:*, param3:Boolean = false) : Boolean
      {
         var _loc4_:String = null;
         for each(_loc4_ in param2)
         {
            if(param3)
            {
               if(param1.indexOf(_loc4_) != -1)
               {
                  return true;
               }
            }
            else
            {
               if(_loc4_.indexOf("&") != -1)
               {
                  return matchFilters(param1,_loc4_.split("&"),true);
               }
               if(param1.indexOf(_loc4_) == -1)
               {
                  return false;
               }
            }
         }
         return !param3;
      }
      
      private function _getTimeStamp() : Number
      {
         var _loc1_:Number = Number(new Date().getTime());
         ++_iTieBreaker;
         return _loc1_;
      }
      
      public function setUsername(param1:String) : void
      {
         if(_username != null && _username != "")
         {
            return;
         }
         _username = param1;
         if(_debugFilterReceiver.updateWithUsername(param1))
         {
            __lcFilterSender.send(FILTER_CONNECTION_NAME,"updateFilterReceiverDisplayName",_debugFilterReceiver.key,_debugFilterReceiver.displayName);
         }
      }
      
      public function get debug() : Boolean
      {
         return __bDebug;
      }
      
      protected function _statusHandler(param1:StatusEvent) : void
      {
      }
      
      public function set debug(param1:Boolean) : void
      {
         __bDebug = param1;
         if(!__bDebug)
         {
            _deferredLogSender.clearBuffer();
         }
      }
      
      private function onGlobalLogEvent(param1:GlobalLogEvent) : void
      {
         if(!__bDebug)
         {
            return;
         }
         switch(param1.type)
         {
            case GlobalLogEvent.ERROR:
               error(param1.logMessage,param1.logSender,param1.logTimeStamp);
               break;
            case GlobalLogEvent.LOG:
            default:
               log(param1.logMessage,param1.logSender,-1,param1.logTimeStamp);
         }
      }
   }
}

