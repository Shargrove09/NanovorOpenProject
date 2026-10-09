package com.arkadium.virmon.shared.data
{
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class EvoDataLoader implements IChainLoadee
   {
      
      private var _evoDataURL:String;
      
      private var _chainLoader:IChainLoader;
      
      public function EvoDataLoader(param1:String)
      {
         super();
         log("EvoDataLoader() - " + _evoDataURL);
         _evoDataURL = param1;
      }
      
      public function destroy() : void
      {
         _chainLoader = null;
      }
      
      private function handleEvoDataLoadError(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,handleEvoDataLoadComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,handleEvoDataLoadError);
         _chainLoader.handleChainLoadeeError();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoDataLoader>>\t" + param1);
      }
      
      public function get name() : String
      {
         return "EvoDataLoader";
      }
      
      public function load() : void
      {
         log("load()");
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,handleEvoDataLoadComplete);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,handleEvoDataLoadError);
         _loc1_.load(new URLRequest(_evoDataURL));
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function handleEvoDataLoadComplete(param1:Event) : void
      {
         log("handleEvoDataLoadComplete() " + param1.target.data);
         param1.target.removeEventListener(Event.COMPLETE,handleEvoDataLoadComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,handleEvoDataLoadError);
         DataManager.getInstance().getEvoManager().init(new XML(param1.target.data));
         _chainLoader.handleChainLoadeeComplete();
      }
   }
}

