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
         this._mdmManager = param1;
         if(this._mdmManager == null)
         {
            throw new Error("WOOPS -- gotta refactor something!");
         }
         this._processCallback = new Dictionary();
         this._timer = new Timer(POLLING_INTERVAL_MILLISECONDS);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function deleteFolder(param1:String, param2:Function = null) : void
      {
         this.executeCommand("rd /s/q \"" + param1 + "\"",param2);
      }
      
      public function loadFile(param1:String) : String
      {
         return this._mdmManager.mdmFilesystem.loadFile(param1);
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
         return this._mdmManager.mdmFilesystem.getFolderSize(param1);
      }
      
      public function deleteFile(param1:String, param2:Function = null) : void
      {
         this.executeCommand("del /aa \"" + param1 + "\"",param2);
      }
      
      public function copyFolder(param1:String, param2:String, param3:Function, param4:String = "") : void
      {
         var _loc5_:String = param4 == "" ? "" : " > \"" + param4 + "\"";
         this.executeCommand("xcopy /s/r \"" + param1 + "\" \"" + param2 + "\"" + _loc5_,param3);
      }
      
      public function makeFolder(param1:String, param2:Function = null) : void
      {
         this.executeCommand("md \"" + param1 + "\"",param2);
      }
      
      public function copyFile(param1:String, param2:String, param3:Function) : void
      {
         this.executeCommand("copy /y \"" + param1 + "\" \"" + param2 + "\"",param3);
      }
      
      public function writeByteArray(param1:ByteArray, param2:String) : void
      {
         this._mdmManager.mdmFilesystem.BinaryFile.setDataBA(param1);
         this._mdmManager.mdmFilesystem.BinaryFile.writeDataBA(param2);
      }
      
      private function executeCommand(param1:String, param2:Function) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         if(null != param2)
         {
            _loc3_ = "cmd.exe /C " + param1;
            _loc4_ = int(this._mdmManager.mdmProcess.create(param1,0,0,0,0,"",_loc3_,this._mdmManager.mdmApplication.path,3,1));
            this._processCallback[_loc4_] = param2;
            this._timer.start();
         }
         else
         {
            _loc5_ = this._mdmManager.mdmSystem.execStdOut("cmd /C " + param1 + " 2>&1");
         }
      }
      
      public function saveFile(param1:String, param2:String, param3:Boolean = true) : void
      {
         this._mdmManager.mdmFilesystem.saveFile(param1,param2,param3);
      }
      
      public function concatenateFiles(param1:String, param2:String, param3:String, param4:Boolean = false, param5:Function = null) : void
      {
         this.executeCommand("copy /y " + (param4 ? "/b " : "") + "\"" + param1 + "\"+\"" + param2 + "\" \"" + param3 + "\"",param5);
      }
      
      public function deleteAllFiles(param1:String, param2:Function) : void
      {
         this.executeCommand(String("del /q /aa \"" + param1 + "\\*.*\"").replace(/\\\\/g,"\\"),param2);
      }
      
      public function doesFileExist(param1:String) : Boolean
      {
         return this._mdmManager.mdmFilesystem.fileExists(param1);
      }
      
      public function moveFile(param1:String, param2:String, param3:Function = null) : void
      {
         this.executeCommand("move /y \"" + param1 + "\" \"" + param2 + "\"",param3);
      }
      
      public function doesFolderExist(param1:String) : Boolean
      {
         return this._mdmManager.mdmFilesystem.folderExists(param1);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in this._processCallback)
         {
            _loc2_ = true;
            if(!this._mdmManager.mdmProcess.isOpen(int(_loc3_)))
            {
               if(null != this._processCallback[_loc3_])
               {
                  this._processCallback[_loc3_]();
               }
               delete this._processCallback[_loc3_];
            }
         }
         if(!_loc2_)
         {
            this._timer.stop();
         }
      }
      
      public function destroy() : void
      {
         if(null != this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer = null;
         }
      }
      
      public function appendByteArray(param1:ByteArray, param2:String) : void
      {
         this._mdmManager.mdmFilesystem.BinaryFile.setDataBA(param1);
         this._mdmManager.mdmFilesystem.BinaryFile.appendDataBA(param2);
      }
      
      public function getFileList(param1:String, param2:String) : Array
      {
         return this._mdmManager.mdmFilesystem.getFileList(param1,param2);
      }
   }
}

