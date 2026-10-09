package com.smithandtinker.nanovor.debug
{
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   
   public class DebugFilterReceiver extends LocalConnection
   {
      
      public static const FILTER_CONNECTION_KEY_BASE:String = "FilterClient";
      
      protected static const FILTER_CONNECTION_NAME_BASE:String = "Nanovor ";
      
      private var _key:String;
      
      private var _isUsernameSet:Boolean = false;
      
      private var _displayName:String;
      
      private var _debugFilterReceiverHandler:IDebugFilterReceiverHandler;
      
      private var _currentFilter:String = "";
      
      private var _disabled:Boolean = false;
      
      public function DebugFilterReceiver(param1:IDebugFilterReceiverHandler)
      {
         super();
         _debugFilterReceiverHandler = param1;
         openUniqueConnection();
         addEventListener(StatusEvent.STATUS,onStatusMessage,false,0,true);
         allowDomain("*");
         client = this;
      }
      
      public function registered() : void
      {
         _debugFilterReceiverHandler.handleReceiverRegistered();
      }
      
      public function updateWithUsername(param1:String) : Boolean
      {
         if(_disabled)
         {
            return false;
         }
         if(_isUsernameSet)
         {
            return false;
         }
         _displayName += ":" + param1;
         return true;
      }
      
      public function disable() : void
      {
         if(_disabled)
         {
            return;
         }
         _disabled = true;
      }
      
      public function registerFromPoll() : void
      {
         _debugFilterReceiverHandler.handlePolledRegistration();
      }
      
      public function get displayName() : String
      {
         return _displayName;
      }
      
      public function get currentFilter() : String
      {
         return _currentFilter;
      }
      
      private function onStatusMessage(param1:StatusEvent) : void
      {
      }
      
      public function ping() : void
      {
      }
      
      public function setFilter(param1:String) : void
      {
         if(param1 != _currentFilter)
         {
            _currentFilter = param1;
            _debugFilterReceiverHandler.handleFilterChange(param1);
         }
      }
      
      private function openUniqueConnection(param1:int = 1) : void
      {
         var iSeed:int = param1;
         try
         {
            connect(FILTER_CONNECTION_KEY_BASE + iSeed);
            _key = FILTER_CONNECTION_KEY_BASE + iSeed;
            _displayName = FILTER_CONNECTION_NAME_BASE + iSeed;
         }
         catch(e:Error)
         {
            openUniqueConnection(++iSeed);
         }
      }
      
      public function get key() : String
      {
         return _key;
      }
   }
}

