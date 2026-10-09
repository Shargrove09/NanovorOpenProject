package com.arkadium.communications.handlers
{
   import com.arkadium.communications.IVersionDataProvider;
   
   public interface IServiceRequestBrokerHandler extends IServiceRequestBrokerCompleteHandler
   {
      
      function handleServiceRequestBrokerRefresh(param1:Boolean) : void;
      
      function handleServiceRequestBrokerNoAction(param1:String) : void;
      
      function handleServiceRequestBrokerCorruptedSettingsFile() : void;
      
      function handleServiceRequestBrokerMaintenance(param1:String) : void;
      
      function handleServiceRequestBrokerInitialized(param1:IVersionDataProvider) : void;
      
      function handleServiceRequestBrokerError() : void;
   }
}

