package com.smithandtinker.nanovor.debug
{
   internal class DeferredLogData
   {
      
      private var _timeStamp:Number;
      
      private var _message:String;
      
      private var _tieBreaker:int;
      
      public function DeferredLogData(param1:String, param2:Number, param3:int)
      {
         super();
         _message = param1;
         _timeStamp = param2;
         _tieBreaker = param3;
      }
      
      public function get tieBreaker() : int
      {
         return _tieBreaker;
      }
      
      public function get timeStamp() : Number
      {
         return _timeStamp;
      }
      
      public function get message() : String
      {
         return _message;
      }
   }
}

