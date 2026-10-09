package com.arkadium.communications
{
   import flash.events.Event;
   
   public class ServiceRequestBrokerManagerEvent extends Event
   {
      
      public static const INITIALIZED:String = "serviceRequestBrokerManagerEventInitialized";
      
      public static const COMPLETE:String = "serviceRequestBrokerManagerEventComplete";
      
      public static const MAINTENANCE:String = "serviceRequestBrokerManagerEventMaintenance";
      
      public static const REFRESH:String = "serviceRequestBrokerManagerEventRefresh";
      
      public static const NO_ACTION:String = "serviceRequestBrokerManagerEventNoAction";
      
      public static const ERROR:String = "serviceRequestBrokerManagerEventError";
      
      public static const CORRUPTED_SETTINGS_FILE:String = "serviceRequestBrokerManagerEventCorruptedSettings";
      
      private var _responseString:String;
      
      public function ServiceRequestBrokerManagerEvent(param1:String, param2:String = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         _responseString = param2;
      }
      
      public function get responseString() : String
      {
         return _responseString;
      }
      
      override public function clone() : Event
      {
         return new ServiceRequestBrokerManagerEvent(type,responseString,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("ServiceRequestBrokerManagerEvent","type","responseString","bubbles","cancelable","eventPhase");
      }
   }
}

