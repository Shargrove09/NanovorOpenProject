package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   
   public class AnalyticsActionLoadee implements IChainLoadee
   {
      
      private var _action:Action;
      
      private var _chainLoader:IChainLoader;
      
      public function AnalyticsActionLoadee(param1:Action)
      {
         super();
         _action = param1;
      }
      
      public function load() : void
      {
         Managers.analyticsManager.trackAction(_action);
         _chainLoader.handleChainLoadeeComplete();
         _chainLoader = null;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function get name() : String
      {
         return _action.name;
      }
   }
}

