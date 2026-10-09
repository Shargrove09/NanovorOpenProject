package com.arkadium.communications
{
   import com.arkadium.virmon.framework.IVirmonData;
   import flash.events.IEventDispatcher;
   
   public interface IServiceRequestBrokerManager extends IEventDispatcher
   {
      
      function getBuildVersion() : String;
      
      function stopTokenRefresh() : void;
      
      function getLoginToken() : String;
      
      function get bankURLRead() : String;
      
      function requestAccountActivity(param1:Function, param2:Function) : void;
      
      function getGameServicePort() : int;
      
      function init() : void;
      
      function getRevision() : String;
      
      function getAccountID() : String;
      
      function get bankURL() : String;
      
      function getMajorVersion() : String;
      
      function getAssetListURL() : String;
      
      function requestShardData(param1:Function, param2:Function) : void;
      
      function getMinorVersion() : String;
      
      function requestEvolveNanovor(param1:int, param2:String, param3:Array, param4:Function, param5:Function) : void;
      
      function requestAccountStats(param1:Function, param2:Function) : void;
      
      function startTokenRefresh() : void;
      
      function getServiceRequestBrokerValue(param1:ServiceRequestBrokerValueType) : String;
      
      function get staticFileServiceURL() : String;
      
      function requestAccountInfo(param1:Function, param2:Function) : void;
      
      function requestAccountBadges(param1:Function, param2:Function) : void;
      
      function get isCheckForNanocashEnabled() : Boolean;
      
      function requestAssetBadges(param1:String, param2:Function, param3:Function) : void;
      
      function getNanoCashURL(param1:String) : String;
      
      function getCouponURL(param1:String) : String;
      
      function loadServiceRequestBroker(param1:String, param2:String, param3:IUserProfile, param4:String) : void;
      
      function requestJoltSpendOnNanovor(param1:IVirmonData, param2:Object, param3:Function, param4:Function) : void;
      
      function saveAccountInfo(param1:XML, param2:Function = null, param3:Function = null) : void;
   }
}

