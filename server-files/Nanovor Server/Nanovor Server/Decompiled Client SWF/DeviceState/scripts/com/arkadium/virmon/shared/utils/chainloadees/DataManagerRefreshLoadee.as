package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.framework.FrameWorkEvent;
   import com.arkadium.virmon.framework.IDataManager;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DataManagerRefreshLoadee implements IChainLoadee
   {
      
      private var _dataManager:IDataManager;
      
      private var _chainLoader:IChainLoader;
      
      public function DataManagerRefreshLoadee(param1:IDataManager)
      {
         super();
         _dataManager = param1;
      }
      
      private function handleDataManagerUpdated(param1:FrameWorkEvent) : void
      {
         log("handleDataManagerUpdated()");
         _dataManager.getVirmonManager().removeEventListener(FrameWorkEvent.DM_DATA_UPDATED,handleDataManagerUpdated);
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function load() : void
      {
         log("load()");
         _dataManager.getVirmonManager().addEventListener(FrameWorkEvent.DM_DATA_UPDATED,handleDataManagerUpdated);
         _dataManager.refreshData();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function get name() : String
      {
         return "DataManagerRefreshLoadee";
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DataManagerRefreshLoadee>>\t" + param1);
      }
   }
}

