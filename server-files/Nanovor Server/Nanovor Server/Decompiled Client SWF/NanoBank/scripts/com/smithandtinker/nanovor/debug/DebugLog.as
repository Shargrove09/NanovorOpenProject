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
         this._aPreFilterInitLogBuffer = new Array();
         super();
         this.__sClientReference = String(int(Math.random() * 100));
         this.__lcSender = new LocalConnection();
         this.__lcFilterSender = new LocalConnection();
         this._deferredLogSender = new DeferredLogSender(this,CONNECTION_NAME,this.__lcSender);
         this.__lcSender.addEventListener(StatusEvent.STATUS,this._statusHandler);
         this.__lcFilterSender.addEventListener(StatusEvent.STATUS,this._filterStatusHandler);
         this.__bDebug = false;
         this._debugFilterReceiver = new DebugFilterReceiver(this);
         try
         {
            this.__lcFilterSender.send(FILTER_CONNECTION_NAME,"registerFilterReceiver",this._debugFilterReceiver.key,this._debugFilterReceiver.displayName);
         }
         catch(e:Error)
         {
            _debugFilterReceiver.disable();
            handleReceiverRegistered();
         }
         EventManager.getInstance().addEventListener(GlobalLogEvent.LOG,this.onGlobalLogEvent,false,0,true);
         EventManager.getInstance().addEventListener(GlobalLogEvent.ERROR,this.onGlobalLogEvent,false,0,true);
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
         if(!this.__bDebug)
         {
            return;
         }
         if(!this._bFilterReceiverInited)
         {
            this._aPreFilterInitLogBuffer.push([param1,param2,param3,this._getTimeStamp()]);
            return;
         }
         if(param3 == -1 && !this.passesFilter(param1 + param2))
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
            param1 = this._getSender(param2) + " " + param1;
            if(param3 != -1)
            {
               param1 += "\n[ log split, continued with split id=" + param3 + "...]";
            }
         }
         this._deferredLogSender.log(param1,param4 == -1 ? this._getTimeStamp() : param4,this._iTieBreaker);
         if(Boolean(_loc5_.length))
         {
            this.log(_loc5_,param2,param3);
         }
      }
      
      private function _getSender(param1:*) : String
      {
         if(param1 === null)
         {
            if(this._username == null || this._username == "")
            {
               return this.__sClientReference;
            }
            return this._username;
         }
         return param1;
      }
      
      public function error(param1:String, param2:String = null, param3:Number = -1) : void
      {
         if(!this.__bDebug)
         {
            return;
         }
         trace(param1);
         if(param1.length > 10000)
         {
            param1 = param1.substr(0,10000) + "\n!!!! ---- ERROR MESSAGE TRUNCATED ---- !!!!";
         }
         param1 = this._getSender(param2) + " " + param1;
         this.__lcSender.send(CONNECTION_NAME,"error",param1,param3 == -1 ? this._getTimeStamp() : param3,this._iTieBreaker);
      }
      
      public function handleFilterChange(param1:String) : void
      {
         this._filter = param1.toLowerCase();
         this._filterUseAny = false;
         this._filterSplit = this._filter.split("|");
         if(this._filterSplit.length == 1)
         {
            this._filterUseAny = true;
            this._filterSplit = this._filter.split("&");
         }
      }
      
      public function handlePolledRegistration() : void
      {
         try
         {
            this.__lcFilterSender.send(FILTER_CONNECTION_NAME,"registerFilterReceiver",this._debugFilterReceiver.key,this._debugFilterReceiver.displayName,this._debugFilterReceiver.currentFilter);
         }
         catch(e:Error)
         {
            _debugFilterReceiver.disable();
         }
      }
      
      public function clear() : void
      {
         if(!this.__bDebug)
         {
            return;
         }
         this.__lcSender.send(CONNECTION_NAME,"clear");
      }
      
      public function passesFilter(param1:String) : Boolean
      {
         if(!this.__bDebug)
         {
            return false;
         }
         if(this._filter == "")
         {
            return true;
         }
         if(this._filterSplit.length > 1)
         {
            if(this.matchFilters(param1.toLowerCase(),this._filterSplit,this._filterUseAny))
            {
               return true;
            }
            return false;
         }
         return param1.toLowerCase().indexOf(this._filter) != -1;
      }
      
      public function comment(param1:String) : void
      {
         if(!this.__bDebug)
         {
            return;
         }
         trace(param1);
         param1 = this.__sClientReference + " " + param1;
         if(param1.length > 10000)
         {
            param1 = param1.substr(0,10000);
         }
         this.__lcSender.send(CONNECTION_NAME,"comment",param1,this._getTimeStamp(),this._iTieBreaker);
      }
      
      public function handleReceiverRegistered() : void
      {
         var _loc1_:Array = null;
         if(this._bFilterReceiverInited)
         {
            return;
         }
         this._bFilterReceiverInited = true;
         while(this._aPreFilterInitLogBuffer.length > 0)
         {
            _loc1_ = this._aPreFilterInitLogBuffer.shift();
            this.log(_loc1_[0],_loc1_[1],_loc1_[2],_loc1_[3]);
         }
      }
      
      private function _filterStatusHandler(param1:StatusEvent) : void
      {
         if(param1.level == "error")
         {
            this.handleReceiverRegistered();
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
                  return this.matchFilters(param1,_loc4_.split("&"),true);
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
         ++this._iTieBreaker;
         return _loc1_;
      }
      
      public function setUsername(param1:String) : void
      {
         if(this._username != null && this._username != "")
         {
            return;
         }
         this._username = param1;
         if(this._debugFilterReceiver.updateWithUsername(param1))
         {
            this.__lcFilterSender.send(FILTER_CONNECTION_NAME,"updateFilterReceiverDisplayName",this._debugFilterReceiver.key,this._debugFilterReceiver.displayName);
         }
      }
      
      public function get debug() : Boolean
      {
         return this.__bDebug;
      }
      
      protected function _statusHandler(param1:StatusEvent) : void
      {
      }
      
      public function set debug(param1:Boolean) : void
      {
         this.__bDebug = param1;
         if(!this.__bDebug)
         {
            this._deferredLogSender.clearBuffer();
         }
      }
      
      private function onGlobalLogEvent(param1:GlobalLogEvent) : void
      {
         if(!this.__bDebug)
         {
            return;
         }
         switch(param1.type)
         {
            case GlobalLogEvent.ERROR:
               this.error(param1.logMessage,param1.logSender,param1.logTimeStamp);
               break;
            case GlobalLogEvent.LOG:
            default:
               this.log(param1.logMessage,param1.logSender,-1,param1.logTimeStamp);
         }
      }
   }
}

