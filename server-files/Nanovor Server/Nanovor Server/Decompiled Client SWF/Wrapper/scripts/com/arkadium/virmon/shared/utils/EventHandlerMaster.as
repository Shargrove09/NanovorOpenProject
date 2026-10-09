package com.arkadium.virmon.shared.utils
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   
   public class EventHandlerMaster
   {
      
      public static var listenersAdded:int = 0;
      
      public static var listenersRemoved:int = 0;
      
      private static var _listeners:Dictionary = new Dictionary();
      
      public function EventHandlerMaster()
      {
         super();
      }
      
      public static function dumpDanglers() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         for(_loc1_ in _listeners)
         {
            if(null != _listeners[_loc1_])
            {
               for(_loc2_ in _listeners[_loc1_])
               {
                  if(null != _listeners[_loc1_][_loc2_])
                  {
                     for(_loc3_ in _listeners[_loc1_][_loc2_])
                     {
                        if(null == _listeners[_loc1_][_loc2_][_loc3_])
                        {
                           DebugLog.instance.log("<<EventHandlerMaster>> (( NULL ListenerData!)) target: " + _loc1_ + " type: " + _loc2_ + ", listenerName: " + _loc3_);
                        }
                        else
                        {
                           DebugLog.instance.log("<<EventHandlerMaster>> type: " + _loc2_ + ", function: " + ListenerData(_listeners[_loc1_][_loc2_][_loc3_]).listenerName + "\n-> " + ListenerData(_listeners[_loc1_][_loc2_][_loc3_]).classPath + ":" + ListenerData(_listeners[_loc1_][_loc2_][_loc3_]).lineNumber);
                        }
                     }
                  }
               }
            }
         }
         DebugLog.instance.log("<<EventHandlerMaster>> dumpDanglers(): " + listenersDelta);
      }
      
      public static function RemoveEventListener(param1:*, param2:String, param3:String, param4:Function, param5:Boolean = false) : void
      {
         if(null == param1)
         {
            throw new Error("Parameter \"target\" cannot be null.");
         }
         param1.removeEventListener(param3,param4,param5);
         var _loc6_:Dictionary = getTargetDict(param3,param1);
         if(_loc6_[param2] != null)
         {
            delete _loc6_[param2];
            ++listenersRemoved;
            cleanUpTarget(param3,param1);
         }
      }
      
      public static function AddEventListener(param1:*, param2:String, param3:String, param4:Function, param5:Boolean = false, param6:int = 0, param7:Boolean = false) : void
      {
         var _loc8_:String = new Error().getStackTrace();
         var _loc9_:String = _loc8_;
         var _loc10_:String = _loc8_.match(/(?<=:)[0-9]*(?=])/g)[1];
         param1.addEventListener(param3,param4,param5,param6,param7);
         var _loc11_:Dictionary = getTargetDict(param3,param1);
         if(_loc11_[param2] == null)
         {
            ++listenersAdded;
            _loc11_[param2] = new ListenerData(param2,_loc9_,_loc10_,_loc8_);
         }
      }
      
      public static function dumpDanglerCount() : void
      {
         DebugLog.instance.log("<<EventHandlerMaster>> dumpDanglerCount(): " + listenersDelta);
      }
      
      private static function cleanUpTarget(param1:String, param2:*) : void
      {
         var _loc4_:* = undefined;
         if(_listeners[param2] == null)
         {
            return;
         }
         if(_listeners[param2][param1] == null)
         {
            return;
         }
         var _loc3_:int = 0;
         for(_loc4_ in _listeners[param2][param1])
         {
            _loc3_++;
         }
         if(_loc3_ == 0)
         {
            delete _listeners[param2][param1];
         }
         _loc3_ = 0;
         for(_loc4_ in _listeners[param2])
         {
            _loc3_++;
         }
         if(_loc3_ == 0)
         {
            delete _listeners[param2];
         }
      }
      
      public static function get listenersDelta() : int
      {
         return listenersAdded - listenersRemoved;
      }
      
      private static function getTargetDict(param1:String, param2:IEventDispatcher) : Dictionary
      {
         if(_listeners[param2] == null)
         {
            _listeners[param2] = new Dictionary();
         }
         if(_listeners[param2][param1] == null)
         {
            _listeners[param2][param1] = new Dictionary();
         }
         return _listeners[param2][param1];
      }
   }
}

class ListenerData
{
   
   private var _stackTrace:String;
   
   private var _classPath:String;
   
   private var _lineNumber:String;
   
   private var _listenerName:String;
   
   public function ListenerData(param1:String, param2:String, param3:String, param4:String = null)
   {
      super();
      _listenerName = param1;
      _classPath = param2;
      _lineNumber = param3;
      _stackTrace = param4;
   }
   
   public function get classPath() : String
   {
      return _classPath;
   }
   
   public function get stackTrace() : String
   {
      return _stackTrace;
   }
   
   public function get lineNumber() : String
   {
      return _lineNumber;
   }
   
   public function get listenerName() : String
   {
      return _listenerName;
   }
}
