package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoaderHandleError;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IChainLoaderErrorConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class DeviceSenseiGameFolderUpdateChainLoadee implements IChainLoadee, IChainLoaderConsumer, IFileToByteArrayConsumer, IChainLoaderErrorConsumer
   {
      
      public static const NAME:String = "DeviceSenseiGameSingleUpdateChainLoadee";
      
      private static const LOCAL_DIRECTORY:String = "Assets\\device\\s1";
      
      private static var DEVICE_DIRECTORY:String = "";
      
      private var _fileName:String;
      
      private var _fileOperator:IFileOperator;
      
      private var _time:int;
      
      private var _localFileArray:ByteArray;
      
      private var _loader:URLLoader;
      
      private var _totalFiles:int;
      
      private var _s1ManifestLoader:URLLoader;
      
      private var _deviceFileArray:ByteArray;
      
      private var _completed:int;
      
      private var _filePaths:Array;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _chainLoader:IChainLoader;
      
      private var _myChainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      public function DeviceSenseiGameFolderUpdateChainLoadee(param1:IFileOperator, param2:String, param3:IDeviceManager, param4:ILoadProgressUpdater)
      {
         super();
         _deviceManager = param3;
         _loadProgressUpdater = param4;
         _fileName = "\\" + param2;
         DEVICE_DIRECTORY = _deviceManager.driveLetter + "s1";
         _fileOperator = param1;
      }
      
      private function makeFolder() : void
      {
         _fileOperator.makeFolder(DEVICE_DIRECTORY,copyFolder);
      }
      
      private function folderCopyCompleted() : void
      {
         log("folder copy complete! " + (getTimer() - _time));
         _loadProgressUpdater.handleItemCompleted();
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      public function handleChainLoaderError() : void
      {
         if(_localFileArray == null)
         {
            folderCopyCompleted();
         }
         else
         {
            deleteFolder();
         }
      }
      
      private function copyNextFile() : void
      {
         if(_filePaths.length == 0)
         {
            folderCopyCompleted();
            return;
         }
         var _loc1_:Object = _filePaths.pop();
         _loadProgressUpdater.updateCurrentItemProgress(0.33 + 0.67 * ((_totalFiles - _filePaths.length) / _totalFiles));
         var _loc2_:String = _loc1_.filename;
         var _loc3_:String = _loc1_.crc;
         log("copyNextFile(): " + _loc2_);
         var _loc4_:String = DEVICE_DIRECTORY + Environment.localPathDelimeter + _loc2_;
         _fileOperator.makeFolder(_loc4_.substr(0,_loc4_.lastIndexOf(Environment.localPathDelimeter)));
         _fileOperator.copyFile(LOCAL_DIRECTORY + Environment.localPathDelimeter + _loc2_,_loc4_,onCopyFileComplete);
      }
      
      private function compareByteArrays(param1:ByteArray, param2:ByteArray) : Boolean
      {
         if(param1.length != param2.length)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != param2[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DeviceSenseiGameFolderUpdateChainLoadee: " + param1);
      }
      
      private function onS1ManifestLoaderComplete(param1:Event) : void
      {
         var assetXML:XML = null;
         var xml:XML = null;
         var e:Event = param1;
         _s1ManifestLoader.removeEventListener(Event.COMPLETE,onS1ManifestLoaderComplete);
         _s1ManifestLoader.removeEventListener(IOErrorEvent.IO_ERROR,onS1ManifestLoaderError);
         try
         {
            xml = new XML(String(_s1ManifestLoader.data));
         }
         catch(error:Error)
         {
            logError("onS1ManifestLoaderComplete(): error parsing xml:" + error.message);
            return;
         }
         _filePaths = [];
         for each(assetXML in xml..Asset)
         {
            _filePaths[_filePaths.length] = {
               "filename":String(assetXML.@Filename),
               "crc":String(assetXML.@CRC)
            };
         }
         _totalFiles = _filePaths.length;
         copyNextFile();
      }
      
      private function copyFolder() : void
      {
         _s1ManifestLoader = new URLLoader();
         _s1ManifestLoader.addEventListener(Event.COMPLETE,onS1ManifestLoaderComplete,false,0,true);
         _s1ManifestLoader.addEventListener(IOErrorEvent.IO_ERROR,onS1ManifestLoaderError,false,0,true);
         _s1ManifestLoader.load(new URLRequest(LOCAL_DIRECTORY + "\\manifest.xml"));
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DeviceSenseiGameFolderUpdateChainLoadee: " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _loadProgressUpdater.updateCurrentItemProgress(0.33);
         if(!compareByteArrays(_localFileArray,_deviceFileArray))
         {
            log("files are different!!!!!!!!!!!! " + (getTimer() - _time));
            _time = getTimer();
            deleteFolder();
         }
         else
         {
            log("files are exactly the same!!!!!!!!!!!! " + (getTimer() - _time));
            _time = getTimer();
            folderCopyCompleted();
         }
      }
      
      public function load() : void
      {
         _loadProgressUpdater.addStatusTextLine("CHECKING SENSEI GAME FILES...0%");
         _time = getTimer();
         log("checking game.bin from \'" + LOCAL_DIRECTORY + _fileName + "\' against \'" + DEVICE_DIRECTORY + _fileName + "\'");
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         _loc1_.add(new LoadedFileToByteArrayLoadee(LOCAL_DIRECTORY + _fileName,this));
         _loc1_.add(new LoadedFileToByteArrayLoadee(DEVICE_DIRECTORY + _fileName,this));
         _myChainLoader = new ChainLoaderHandleError(_loc1_,this,this);
         _myChainLoader.load();
      }
      
      private function onS1ManifestLoaderError(param1:IOErrorEvent) : void
      {
         _s1ManifestLoader.removeEventListener(Event.COMPLETE,onS1ManifestLoaderComplete);
         _s1ManifestLoader.removeEventListener(IOErrorEvent.IO_ERROR,onS1ManifestLoaderError);
         logError("onS1ManifestLoaderError(): " + param1.text);
      }
      
      private function onCopyFileComplete() : void
      {
         log("onCopyFileComplete()");
         copyNextFile();
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      public function setByteArray(param1:String, param2:ByteArray) : void
      {
         if(param1 == LOCAL_DIRECTORY + _fileName)
         {
            _localFileArray = param2;
         }
         else
         {
            _deviceFileArray = param2;
         }
      }
      
      private function deleteFolder() : void
      {
         _fileOperator.deleteFolder(DEVICE_DIRECTORY,makeFolder);
      }
   }
}

