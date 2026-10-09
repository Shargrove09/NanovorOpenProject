package com.arkadium.communications
{
   import com.arkadium.virmon.loginpanel.ILoginPanel;
   
   public class ServiceRequestBrokerNoActionMessageParser
   {
      
      public static const REASON_GENERIC:int = 0;
      
      public static const REASON_BAD_USER_PASS:int = 1;
      
      public static const REASON_EMPTY_USER_PASS:int = 2;
      
      public static const REASON_ACCOUNT_DISABLED:int = 3;
      
      public static const REASON_ACCOUNT_NOT_ACTIVATED:int = 4;
      
      private var _responseString:String;
      
      private var _loginPanel:ILoginPanel;
      
      private var _parsedReason:int = 0;
      
      public function ServiceRequestBrokerNoActionMessageParser(param1:String, param2:ILoginPanel)
      {
         super();
         _responseString = param1;
         _loginPanel = param2;
      }
      
      public function parse() : int
      {
         _parsedReason = ServiceRequestBrokerNoActionMessageParser.REASON_GENERIC;
         _loginPanel.addStatusMessage(getErrorMessage(),"",true);
         _loginPanel.initAfterInvalidLogin();
         return _parsedReason;
      }
      
      public function get responseString() : String
      {
         return _responseString;
      }
      
      private function getErrorMessage() : String
      {
         if(_responseString.indexOf("code [101]") != -1)
         {
            return getUserMessageForCode101();
         }
         if(_responseString.indexOf("code [133]") != -1)
         {
            return "A server error occurred [code 133].  Please try again or contact support.";
         }
         if(_responseString.indexOf("code [1]") != -1)
         {
            return "A server error occurred [code 1].  Please try again or contact support.";
         }
         return "Error connecting to the Nanovor servers. Please check your Internet connection and try again.";
      }
      
      private function getUserMessageForCode101() : String
      {
         if(_responseString.indexOf("Wrong username/password") != -1)
         {
            _parsedReason = ServiceRequestBrokerNoActionMessageParser.REASON_BAD_USER_PASS;
            return "Username and/or password incorrect. Please try again.";
         }
         if(_responseString.indexOf("minLength \'1\' for type \'accountUsername\'") != -1)
         {
            _parsedReason = ServiceRequestBrokerNoActionMessageParser.REASON_EMPTY_USER_PASS;
            return "Username and/or password cannot be empty. Please try again.";
         }
         if(_responseString.indexOf("minLength \'1\' for type \'accountPassword\'") != -1)
         {
            _parsedReason = ServiceRequestBrokerNoActionMessageParser.REASON_EMPTY_USER_PASS;
            return "Username and/or password cannot be empty. Please try again.";
         }
         if(_responseString.indexOf("Account is disabled") != -1)
         {
            _parsedReason = ServiceRequestBrokerNoActionMessageParser.REASON_ACCOUNT_DISABLED;
            return "Account has been deactivated.\nPlease use an active account to login.";
         }
         if(_responseString.indexOf("Account has not been activated") != -1)
         {
            _parsedReason = ServiceRequestBrokerNoActionMessageParser.REASON_ACCOUNT_NOT_ACTIVATED;
            return "Account has not been activated.\nAccount activation is required before you can log in.";
         }
         if(_responseString.indexOf("503 Service Temporarily") != -1)
         {
            return "Service is temporarily unavailable. Please wait a minute and try again.";
         }
         return "Could not login to server.\nPlease try again or contact support.";
      }
   }
}

