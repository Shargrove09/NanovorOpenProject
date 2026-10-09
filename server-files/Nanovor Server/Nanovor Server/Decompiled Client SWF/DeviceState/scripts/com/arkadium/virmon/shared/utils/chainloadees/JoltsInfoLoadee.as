package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.shared.data.JoltsInfo;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class JoltsInfoLoadee implements IChainLoadee
   {
      
      public static const NAME:String = "joltsInfoLoadee";
      
      private var _hash:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      public function JoltsInfoLoadee(param1:IServiceRequestBrokerManager, param2:String = "")
      {
         super();
         _serviceRequestBrokerManager = param1;
         _hash = param2;
      }
      
      private function removeFetchJoltEventHandlers(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,handleJoltsFetchSuccess);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,handleJoltsFetchFailure);
      }
      
      public function load() : void
      {
         _serviceRequestBrokerManager.requestAccountInfo(handleJoltsFetchSuccess,handleJoltsFetchFailure);
      }
      
      private function handleJoltsFetchSuccess(param1:Event) : void
      {
         removeFetchJoltEventHandlers(param1);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         var _loc3_:int = int(_loc2_.elements("jolt_health_balance"));
         var _loc4_:int = int(_loc2_.elements("jolt_armor_balance"));
         var _loc5_:int = int(_loc2_.elements("jolt_strength_balance"));
         var _loc6_:int = int(_loc2_.elements("jolt_speed_balance"));
         _chainLoader.handleChainLoadeeComplete(new JoltsInfo(_loc3_,_loc4_,_loc5_,_loc6_));
      }
      
      public function get name() : String
      {
         return NAME + _hash;
      }
      
      private function handleJoltsFetchFailure(param1:IOErrorEvent) : void
      {
         removeFetchJoltEventHandlers(param1);
         _chainLoader.handleChainLoadeeError();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

