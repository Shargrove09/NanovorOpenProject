package com.arkadium.virmon.device
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceMiniGameChainLoadee implements IChainLoadee
   {
      
      private static const LOCAL_DEVICE_MINIGAMES_FOLDER:String = "Assets\\Device\\minigames\\";
      
      private var _download:IDownload;
      
      private var _driveLetter:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _gameFileName:String;
      
      private var _gameFileNameIndex:int;
      
      private var _fileOperator:IFileOperator;
      
      public function DeviceMiniGameChainLoadee(param1:String, param2:int, param3:ILoadProgressUpdater, param4:String, param5:IDownload, param6:IFileOperator)
      {
         super();
         if(null == param1)
         {
            throw new Error("Parameter \"gameFileName\" cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \"loadProgressUpdater\" cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \"driveLetter\" cannot be null.");
         }
         if(null == param5)
         {
            throw new Error("Parameter \"download\" cannot be null.");
         }
         if(null == param6)
         {
            throw new Error("Parameter \"fileOperator\" cannot be null.");
         }
         _gameFileName = param1;
         _gameFileNameIndex = param2;
         _loadProgressUpdater = param3;
         _driveLetter = param4;
         _download = param5;
         _fileOperator = param6;
      }
      
      private function writeMiniGameToDevice() : void
      {
         log("writeGameToDevice(): writing game file: " + _gameFileName);
         var _loc1_:String = _driveLetter + "g" + (_gameFileNameIndex + 1) + "\\";
         _fileOperator.makeFolder(_loc1_);
         _fileOperator.copyFile(LOCAL_DEVICE_MINIGAMES_FOLDER + _gameFileName,_loc1_ + _gameFileName,_chainLoader.handleChainLoadeeComplete);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceMiniGameChainLoadee>> " + param1);
      }
      
      public function load() : void
      {
         writeMiniGameToDevice();
      }
      
      public function get name() : String
      {
         return "DeviceMiniGameChainLoadee";
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

