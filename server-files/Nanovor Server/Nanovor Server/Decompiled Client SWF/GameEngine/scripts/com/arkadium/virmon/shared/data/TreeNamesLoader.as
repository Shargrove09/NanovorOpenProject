package com.arkadium.virmon.shared.data
{
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.asset.enum.MasterDataAssetType;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class TreeNamesLoader implements IChainLoadee
   {
      
      public static const NAME:String = "TreeNamesLoader";
      
      private var _chainLoader:IChainLoader;
      
      private var _loader:URLLoader;
      
      public function TreeNamesLoader()
      {
         super();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function load() : void
      {
         log("load()");
         _loader = new URLLoader();
         _loader.addEventListener(Event.COMPLETE,onTreeNamesLoaded,false,0,false);
         _loader.addEventListener(IOErrorEvent.IO_ERROR,onTreeNamesLoadError,false,0,false);
         _loader.load(new URLRequest(Managers.assetRetrieverManager.masterDataAssetRetriever.getMasterDataURL(MasterDataAssetType.EVO_TREE).url));
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      private function onTreeNamesLoaded(param1:Event) : void
      {
         log("onTreeNamesLoaded()");
         _loader.removeEventListener(Event.COMPLETE,onTreeNamesLoaded);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR,onTreeNamesLoadError);
         DataManager.getInstance().getEvoManager().initTreeNames(new XML(param1.target.data));
         _loader.close();
         _loader = null;
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function onTreeNamesLoadError(param1:IOErrorEvent) : void
      {
         log("onTreeNamesLoadError()");
         _loader.removeEventListener(Event.COMPLETE,onTreeNamesLoaded);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR,onTreeNamesLoadError);
         _loader.close();
         _loader = null;
         _chainLoader.handleChainLoadeeError();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<TreeNamesLoader>>\t" + param1);
      }
   }
}

