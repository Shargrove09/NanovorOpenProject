package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class DeviceErrorLogCheckChainLoadee implements IChainLoadee
   {
      
      private static const ERROR_LOG_FILE:String = "elog.txt";
      
      private var _errorLogLoader:URLLoader;
      
      private var _chainLoader:IChainLoader;
      
      private var _deviceManager:IDeviceManager;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceErrorLogCheckChainLoadee(param1:IDeviceManager, param2:IFileOperator)
      {
         super();
         _deviceManager = param1;
         _fileOperator = param2;
      }
      
      private function onELogLoaded(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         _errorLogLoader.close();
         log("Device error log contents:\n" + String(param1.target.data));
         var _loc3_:Date = new Date();
         var _loc4_:String = "elog-" + add0(_loc3_.month) + "" + add0(_loc3_.date) + "" + _loc3_.fullYear + "" + add0(_loc3_.hours) + "" + add0(_loc3_.minutes) + "" + add0(_loc3_.seconds) + ".txt";
         _fileOperator.saveFile(_loc4_,String(param1.target.data));
         _fileOperator.deleteFile(_deviceManager.driveLetter + ERROR_LOG_FILE,deleteEverything);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceErrorLogCheckChainLoadee>>\t" + param1);
      }
      
      private function deleteEverything(param1:Object = null) : void
      {
         _fileOperator.deleteAllFiles(_deviceManager.driveLetter,onDeleteAllComplete);
      }
      
      public function load() : void
      {
         log("load()");
         if(!_fileOperator.doesFileExist(_deviceManager.driveLetter + ERROR_LOG_FILE))
         {
            log("load() - No error log, continuing one.");
            _chainLoader.handleChainLoadeeComplete();
         }
         else
         {
            log("load() - Error log found.");
            _deviceManager.handleErrorLogFound();
            _errorLogLoader = new URLLoader();
            _errorLogLoader.addEventListener(Event.COMPLETE,onELogLoaded);
            _errorLogLoader.load(new URLRequest(_deviceManager.driveLetter + ERROR_LOG_FILE));
         }
      }
      
      private function add0(param1:int) : String
      {
         return param1 < 10 ? "0" + param1 : "" + param1;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function onDeleteAllComplete(param1:Object = null) : void
      {
         _chainLoader.handleChainLoadeeComplete();
      }
      
      public function get name() : String
      {
         return "DeviceErrorLogCheckChainLoadee";
      }
   }
}

