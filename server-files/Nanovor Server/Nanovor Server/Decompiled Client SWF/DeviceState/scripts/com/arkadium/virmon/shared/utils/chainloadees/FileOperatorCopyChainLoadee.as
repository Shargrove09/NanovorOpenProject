package com.arkadium.virmon.shared.utils.chainloadees
{
   import com.arkadium.virmon.device.ILoadProgressUpdater;
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class FileOperatorCopyChainLoadee implements IChainLoadee
   {
      
      private var _destination:String;
      
      private var _chainLoader:IChainLoader;
      
      private var _loadProgressUpdater:ILoadProgressUpdater;
      
      private var _source:String;
      
      private var _fileOperator:IFileOperator;
      
      public function FileOperatorCopyChainLoadee(param1:String, param2:String, param3:IFileOperator, param4:ILoadProgressUpdater = null)
      {
         super();
         _source = param1;
         _destination = param2;
         _fileOperator = param3;
         if(null != param4)
         {
            _loadProgressUpdater = param4;
         }
      }
      
      private function handleCopyFileFinished() : void
      {
         log("handleCopyFileFinished()");
         if(null != _loadProgressUpdater)
         {
            _loadProgressUpdater.handleItemCompleted();
         }
         _chainLoader.handleChainLoadeeComplete();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<FileOperatorCopyChainLoadee>> " + param1);
      }
      
      public function load() : void
      {
         log("load(): copying \'" + _source + "\' to \'" + _destination + "\'");
         _fileOperator.copyFile(_source,_destination,handleCopyFileFinished);
      }
      
      public function get name() : String
      {
         return "FileOperatorCopyChainLoadee";
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
   }
}

