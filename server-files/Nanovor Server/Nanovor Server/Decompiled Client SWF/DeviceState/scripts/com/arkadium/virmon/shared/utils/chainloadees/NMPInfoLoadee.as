package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class NMPInfoLoadee implements IChainLoadee
   {
      
      public static const NAME:String = "NMPInfoLoadee";
      
      private var _hash:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      public function NMPInfoLoadee(param1:IServiceRequestBrokerManager, param2:String = "")
      {
         super();
         _serviceRequestBrokerManager = param1;
         _hash = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<NMPInfoLoadee>>\t" + param1);
      }
      
      public function load() : void
      {
         _serviceRequestBrokerManager.requestAccountStats(handleFetchSuccess,handleFetchFailure);
      }
      
      public function get name() : String
      {
         return NAME + _hash;
      }
      
      private function handleFetchSuccess(param1:Event) : void
      {
         removeFetchEventHandlers(param1);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         var _loc3_:int = int(_loc2_.elements("virmon-master-rating").valueOf());
         log("handleFetchSuccess() nmp: " + _loc2_.elements("virmon-master-rating").valueOf() + " : " + _loc3_);
         _chainLoader.handleChainLoadeeComplete(_loc3_);
      }
      
      private function removeFetchEventHandlers(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,handleFetchSuccess);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,handleFetchFailure);
      }
      
      private function handleFetchFailure(param1:IOErrorEvent) : void
      {
         removeFetchEventHandlers(param1);
         _chainLoader.handleChainLoadeeError();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

