package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.arkadium.virmon.shared.utils.chainloadees.FileOperatorCopyChainLoadee;
   import com.arkadium.virmon.shared.utils.chainloadees.FileOperatorDeleteChainLoadee;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class WriteAllMiniGamesToDeviceChainLoadee implements IChainLoadee, IChainLoaderConsumer
   {
      
      private static const LOCAL_DEVICE_MINIGAMES_FOLDER:String = "Assets\\Device\\minigames\\";
      
      private var _myChainLoader:IChainLoader;
      
      private var _deviceManagerCommunicator:IDeviceManagerCommunicator;
      
      private var _driveLetter:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _fileOperator:IFileOperator;
      
      public function WriteAllMiniGamesToDeviceChainLoadee(param1:IFileOperator, param2:IDeviceManagerCommunicator, param3:String, param4:ILoadProgressUpdater)
      {
         super();
         _fileOperator = param1;
         _deviceManagerCommunicator = param2;
         _driveLetter = param3;
         _loadProgressUpdater = param4;
      }
      
      private function parseMiniGamesXML(param1:XML) : Array
      {
         var _loc4_:XML = null;
         param1 = Utils.StripXmlNamespace(param1);
         var _loc2_:XMLList = param1.elements("minigame-file");
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            log("Game names: " + _loc4_.elements("name"));
            _loc3_.push(_loc4_.elements("name").toString());
         }
         return _loc3_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<WriteAllMiniGamesToDeviceChainLoadee>> " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         log("handleChainLoaderComplete()");
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function load() : void
      {
         _loadProgressUpdater.addStatusTextLine("WRITING MINI GAMES...0%");
         _deviceManagerCommunicator.getDeviceManifestXml(handleGetDeviceManifestXmlSuccess,handleGetDeviceManifestXmlFailure);
      }
      
      public function get name() : String
      {
         return "WriteAllMiniGamesToDeviceChainLoadee";
      }
      
      private function handleGetDeviceManifestXmlSuccess(param1:Event) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         log("handleGetDeviceManifestXmlSuccess()");
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleGetDeviceManifestXmlSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleGetDeviceManifestXmlFailure);
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         var _loc3_:Array = parseMiniGamesXML(new XML(param1.target.data));
         _loadProgressUpdater = new LoadProgressUpdaterDecorator(_loc3_.length,_loadProgressUpdater);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = String(_loc3_[_loc4_]);
            _loc6_ = String(_driveLetter + "\\g" + (_loc4_ + 1)).replace(/\\\\/g,"\\");
            _fileOperator.makeFolder(_loc6_);
            _loc2_.add(new FileOperatorDeleteChainLoadee(_loc6_ + "\\game.bin",_fileOperator));
            _loc2_.add(new FileOperatorCopyChainLoadee(LOCAL_DEVICE_MINIGAMES_FOLDER + _loc5_,_loc6_ + "\\game.bin",_fileOperator,_loadProgressUpdater));
            _loc4_++;
         }
         _myChainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _myChainLoader.load();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function handleGetDeviceManifestXmlFailure(param1:IOErrorEvent) : void
      {
         log("handleGetDeviceManifestXmlFailure(): " + param1.text);
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,handleGetDeviceManifestXmlSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleGetDeviceManifestXmlFailure);
      }
   }
}

