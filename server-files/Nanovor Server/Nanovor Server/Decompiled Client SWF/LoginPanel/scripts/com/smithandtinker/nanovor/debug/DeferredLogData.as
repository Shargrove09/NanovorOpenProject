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
         this._message = param1;
         this._timeStamp = param2;
         this._tieBreaker = param3;
      }
      
      public function get tieBreaker() : int
      {
         return this._tieBreaker;
      }
      
      public function get timeStamp() : Number
      {
         return this._timeStamp;
      }
      
      public function get message() : String
      {
         return this._message;
      }
   }
}

