package com.arkadium.communications
{
   public class GameServiceConnectionData
   {
      
      private var _port:int;
      
      private var _ipAddress:String;
      
      private var _loginToken:String;
      
      public function GameServiceConnectionData(param1:String, param2:int, param3:String)
      {
         super();
         _ipAddress = param1;
         _port = param2;
         _loginToken = param3;
      }
      
      public function get port() : int
      {
         return _port;
      }
      
      public function get loginToken() : String
      {
         return _loginToken;
      }
      
      public function get ipAddress() : String
      {
         return _ipAddress;
      }
   }
}

