package com.arkadium.communications
{
   public class ServiceRequestBrokerValueType
   {
      
      public static const GAME_SERVICE_IP:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Game Service IP");
      
      public static const LOGIN_TOKEN:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Login Token");
      
      public static const BANK_URL:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Web service bankfe");
      
      public static const BANK_URL_READ:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Web service bankfe read");
      
      public static const ACCOUNT_ID:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("AccountId");
      
      public static const USER_NAME:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("User name");
      
      public static const COUPON_HOST_URL:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Web service cpnfe");
      
      public static const NANOCASH_CARD_HOST_URL:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Web service gftfe");
      
      public static const SFS_URL:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Static File Service IP");
      
      public static const DOWNLOAD_SERVICE_IP:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Download Service IP");
      
      public static const DOWNLOAD_SERVICE_URL:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Download Service URL");
      
      public static const ACTION:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Action");
      
      public static const MESSAGE:ServiceRequestBrokerValueType = new ServiceRequestBrokerValueType("Message");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function ServiceRequestBrokerValueType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'ServiceRequestBrokerValueType\'.");
         }
         this._name = param1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}

