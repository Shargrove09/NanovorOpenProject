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
         this._debugFilterReceiverHandler = param1;
         this.openUniqueConnection();
         addEventListener(StatusEvent.STATUS,this.onStatusMessage,false,0,true);
         allowDomain("*");
         client = this;
      }
      
      public function registered() : void
      {
         this._debugFilterReceiverHandler.handleReceiverRegistered();
      }
      
      public function updateWithUsername(param1:String) : Boolean
      {
         if(this._disabled)
         {
            return false;
         }
         if(this._isUsernameSet)
         {
            return false;
         }
         this._displayName += ":" + param1;
         return true;
      }
      
      public function disable() : void
      {
         if(this._disabled)
         {
            return;
         }
         this._disabled = true;
      }
      
      public function registerFromPoll() : void
      {
         this._debugFilterReceiverHandler.handlePolledRegistration();
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
      
      public function get currentFilter() : String
      {
         return this._currentFilter;
      }
      
      private function onStatusMessage(param1:StatusEvent) : void
      {
      }
      
      public function ping() : void
      {
      }
      
      public function setFilter(param1:String) : void
      {
         if(param1 != this._currentFilter)
         {
            this._currentFilter = param1;
            this._debugFilterReceiverHandler.handleFilterChange(param1);
         }
      }
      
      private function openUniqueConnection(param1:int = 1) : void
      {
         var iSeed:int = param1;
         try
         {
            connect(FILTER_CONNECTION_KEY_BASE + iSeed);
            this._key = FILTER_CONNECTION_KEY_BASE + iSeed;
            this._displayName = FILTER_CONNECTION_NAME_BASE + iSeed;
         }
         catch(e:Error)
         {
            openUniqueConnection(++iSeed);
         }
      }
      
      public function get key() : String
      {
         return this._key;
      }
   }
}

