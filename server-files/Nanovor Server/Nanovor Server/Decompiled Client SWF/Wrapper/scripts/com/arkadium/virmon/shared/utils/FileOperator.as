package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class FileOperator implements IFileOperator
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = true;
      
      private static const POLLING_INTERVAL_MILLISECONDS:int = 300;
      
      private var _timer:Timer;
      
      private var _processCallback:Dictionary;
      
      private var _mdmManager:IMDMManager;
      
      public function FileOperator(param1:IMDMManager = null)
      {
         super();
         _mdmManager = param1;
         if(_mdmManager == null)
         {
            throw new Error("WOOPS -- gotta refactor something!");
         }
         _processCallback = new Dictionary();
         _timer = new Timer(POLLING_INTERVAL_MILLISECONDS);
         _timer.addEventListener(TimerEvent.TIMER,onTimer);
      }
      
      public function deleteFolder(param1:String, param2:Function = null) : void
      {
         executeCommand("rd /s/q \"" + param1 + "\"",param2);
      }
      
      public function loadFile(param1:String) : String
      {
         return _mdmManager.mdmFilesystem.loadFile(param1);
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<FileOperator>>\t" + param1);
         }
      }
      
      public function getFolderSize(param1:String) : Number
      {
         return _mdmManager.mdmFilesystem.getFolderSize(param1);
      }
      
      public function deleteFile(param1:String, param2:Function = null) : void
      {
         executeCommand("del /aa \"" + param1 + "\"",param2);
      }
      
      public function copyFolder(param1:String, param2:String, param3:Function, param4:String = "") : void
      {
         var _loc5_:String = param4 == "" ? "" : " > \"" + param4 + "\"";
         executeCommand("xcopy /s/r \"" + param1 + "\" \"" + param2 + "\"" + _loc5_,param3);
      }
      
      public function makeFolder(param1:String, param2:Function = null) : void
      {
         executeCommand("md \"" + param1 + "\"",param2);
      }
      
      public function copyFile(param1:String, param2:String, param3:Function) : void
      {
         executeCommand("copy /y \"" + param1 + "\" \"" + param2 + "\"",param3);
      }
      
      public function writeByteArray(param1:ByteArray, param2:String) : void
      {
         _mdmManager.mdmFilesystem.BinaryFile.setDataBA(param1);
         _mdmManager.mdmFilesystem.BinaryFile.writeDataBA(param2);
      }
      
      private function executeCommand(param1:String, param2:Function) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(null != param2)
         {
            _loc3_ = "cmd.exe /C " + param1;
            _loc4_ = int(_mdmManager.mdmProcess.create(param1,0,0,0,0,"",_loc3_,_mdmManager.mdmApplication.path,3,1));
            _processCallback[_loc4_] = param2;
            _timer.start();
         }
         else
         {
            _loc5_ = _mdmManager.mdmSystem.execStdOut("cmd /C " + param1 + " 2>&1");
         }
      }
      
      public function saveFile(param1:String, param2:String, param3:Boolean = true) : void
      {
         _mdmManager.mdmFilesystem.saveFile(param1,param2,param3);
      }
      
      public function concatenateFiles(param1:String, param2:String, param3:String, param4:Boolean = false, param5:Function = null) : void
      {
         executeCommand("copy /y " + (param4 ? "/b " : "") + "\"" + param1 + "\"+\"" + param2 + "\" \"" + param3 + "\"",param5);
      }
      
      public function deleteAllFiles(param1:String, param2:Function) : void
      {
         executeCommand(String("del /q /aa \"" + param1 + "\\*.*\"").replace(/\\\\/g,"\\"),param2);
      }
      
      public function doesFileExist(param1:String) : Boolean
      {
         return _mdmManager.mdmFilesystem.fileExists(param1);
      }
      
      public function moveFile(param1:String, param2:String, param3:Function = null) : void
      {
         executeCommand("move /y \"" + param1 + "\" \"" + param2 + "\"",param3);
      }
      
      public function doesFolderExist(param1:String) : Boolean
      {
         return _mdmManager.mdmFilesystem.folderExists(param1);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in _processCallback)
         {
            _loc2_ = true;
            if(!_mdmManager.mdmProcess.isOpen(int(_loc3_)))
            {
               if(null != _processCallback[_loc3_])
               {
                  _processCallback[_loc3_]();
               }
               delete _processCallback[_loc3_];
            }
         }
         if(!_loc2_)
         {
            _timer.stop();
         }
      }
      
      public function destroy() : void
      {
         if(null != _timer)
         {
            _timer.stop();
            _timer.removeEventListener(TimerEvent.TIMER,onTimer);
            _timer = null;
         }
      }
      
      public function appendByteArray(param1:ByteArray, param2:String) : void
      {
         _mdmManager.mdmFilesystem.BinaryFile.setDataBA(param1);
         _mdmManager.mdmFilesystem.BinaryFile.appendDataBA(param2);
      }
      
      public function getFileList(param1:String, param2:String) : Array
      {
         return _mdmManager.mdmFilesystem.getFileList(param1,param2);
      }
   }
}

