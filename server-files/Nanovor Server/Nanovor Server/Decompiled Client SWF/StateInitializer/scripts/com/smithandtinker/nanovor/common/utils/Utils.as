package com.smithandtinker.nanovor.common.utils
{
   import flash.display.DisplayObject;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   
   public class Utils
   {
      
      public function Utils()
      {
         super();
      }
      
      public static function appendCacheVersion(param1:String, param2:String) : String
      {
         if(-1 == param1.search(/https?:\/\//))
         {
            return param1;
         }
         param1 = param1.replace(/[&?]cversion=[^&]*/g,"");
         param1 += param1.indexOf("?") == -1 ? "?" : "&";
         return param1 + "cversion=" + param2;
      }
      
      public static function IntToCommaFormat(param1:int) : String
      {
         var _loc3_:Number = NaN;
         var _loc2_:Array = new Array();
         var _loc4_:Number = String(param1).length;
         while(_loc4_ > 0)
         {
            _loc3_ = Math.max(_loc4_ - 3,0);
            _loc2_.unshift(String(param1).slice(_loc3_,_loc4_));
            _loc4_ = _loc3_;
         }
         return _loc2_.join(",");
      }
      
      public static function DOStoPOSIXpath(param1:String) : String
      {
         var _loc2_:RegExp = /\\/gi;
         return param1.replace(_loc2_,"/");
      }
      
      public static function DuplicateDisplayObject(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc3_:Class = Object(param1).constructor;
         var _loc4_:DisplayObject = new _loc3_();
         if(!param2)
         {
            return _loc4_;
         }
         _loc4_.transform = param1.transform;
         _loc4_.cacheAsBitmap = param1.cacheAsBitmap;
         _loc4_.filters = param1.filters;
         _loc4_.opaqueBackground = param1.opaqueBackground;
         return _loc4_;
      }
      
      public static function FullScreenThresholdReached() : Boolean
      {
         var _loc1_:Number = Capabilities.screenResolutionX;
         var _loc2_:Number = Capabilities.screenResolutionY;
         return _loc1_ <= 1024 || _loc2_ <= 800;
      }
      
      public static function appendKillCache(param1:String) : String
      {
         if(-1 == param1.search(/https?:\/\//))
         {
            return param1;
         }
         param1 = param1.replace(/[&?]killcache=[^&]*/g,"");
         param1 += param1.indexOf("?") == -1 ? "?" : "&";
         return param1 + "killcache=" + new Date().getTime();
      }
      
      public static function ObjectToString(param1:*, param2:int = 1, param3:int = 4) : String
      {
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc4_:String = typeof param1;
         var _loc5_:String = "";
         var _loc6_:int = 0;
         while(_loc6_ < param2)
         {
            _loc5_ += ".";
            _loc9_ = 0;
            while(_loc9_ < param3)
            {
               _loc5_ += " ";
               _loc9_++;
            }
            _loc6_++;
         }
         var _loc7_:String = "[" + (_loc4_ == "object" ? "object|array" : _loc4_) + "] ";
         if(_loc4_ == "string" || _loc4_ == "number" || _loc4_ == "boolean")
         {
            return _loc7_ + String(param1);
         }
         if(_loc4_ == "function")
         {
            return _loc7_;
         }
         if(_loc4_ == "xml")
         {
            return _loc7_ + XML(param1).toXMLString();
         }
         if(_loc4_ != "object")
         {
            return _loc7_ + "?? unknown ??";
         }
         for(_loc8_ in param1)
         {
            _loc7_ += "\n" + _loc5_ + _loc8_ + " : " + ObjectToString(param1[_loc8_],param2 + 1);
         }
         return _loc7_;
      }
      
      public static function StripXmlNamespace(param1:XML) : XML
      {
         var _loc2_:String = param1.toXMLString();
         var _loc3_:RegExp = /xmlns[^"]*"[^"]*"/gi;
         var _loc4_:RegExp = /xsi:[^"]*"[^"]*"/gi;
         var _loc5_:RegExp = new RegExp("<(/*)[^>]+:","gi");
         var _loc6_:String = _loc2_.replace(_loc3_,"");
         _loc6_ = _loc6_.replace(_loc4_,"");
         _loc6_ = _loc6_.replace(_loc5_,"<$1");
         return new XML(_loc6_);
      }
      
      public static function Clone(param1:Object) : *
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
   }
}

