package mdm
{
   public final class FTP
   {
      
      private var resolver:mdm_FTP = null;
      
      public function FTP(server:String, port:Number)
      {
         super();
         resolver = new mdm_FTP(this,server,port);
      }
      
      public function get success() : Boolean
      {
         return resolver.success;
      }
      
      public function get error() : String
      {
         return resolver.error;
      }
      
      public function set onListingDone(callback:Function) : void
      {
         resolver.onListingDone = callback;
      }
      
      public function set async(syncFlag:Boolean) : void
      {
         resolver.async = syncFlag;
      }
      
      public function getDirAttribs(dir:String) : String
      {
         return resolver.getDirAttribs(dir);
      }
      
      public function getFileSize(filename:String) : Number
      {
         return resolver.getFileSize(filename);
      }
      
      public function set onDirDeleted(callback:Function) : void
      {
         resolver.onDirDeleted = callback;
      }
      
      public function getFileAttribs(filename:String) : String
      {
         return resolver.getFileAttribs(filename);
      }
      
      public function getDirDateTime(dir:String) : String
      {
         return resolver.getDirDateTime(dir);
      }
      
      public function close(syncFlag:Boolean = true) : void
      {
         resolver.close();
      }
      
      public function set onLoggedIn(callback:Function) : void
      {
         resolver.onLoggedIn = callback;
      }
      
      public function set onQuit(callback:Function) : void
      {
         resolver.onQuit = callback;
      }
      
      public function set onFileTransferred(callback:Function) : void
      {
         resolver.onFileTransferred = callback;
      }
      
      public function set onIndexFileReceived(callback:Function) : void
      {
         resolver.onIndexFileReceived = callback;
      }
      
      public function getFolderList() : Array
      {
         return resolver.getFolderList();
      }
      
      public function sendCommand(command:String) : String
      {
         return resolver.sendCommand(command);
      }
      
      public function sendFile(localFile:String, remoteFile:String, syncFlag:Boolean = true) : void
      {
         resolver.sendFile(localFile,remoteFile);
      }
      
      public function set onFileReceived(callback:Function) : void
      {
         resolver.onFileReceived = callback;
      }
      
      public function set currentDir(dir:String) : void
      {
         resolver.currentDir = dir;
      }
      
      public function set onReady(callback:Function) : void
      {
         resolver.onReady = callback;
      }
      
      public function setProxy(proxyType:String, proxyServer:String, proxyPort:Number, proxyUsername:String, proxyPassword:String, syncFlag:Boolean = true) : void
      {
         resolver.setProxy(proxyType,proxyServer,proxyPort,proxyUsername,proxyPassword);
      }
      
      public function getFileDateTime(filename:String) : String
      {
         return resolver.getFileDateTime(filename);
      }
      
      public function abort(syncFlag:Boolean = true) : void
      {
         resolver.abort();
      }
      
      public function set onDirCreated(callback:Function) : void
      {
         resolver.onDirCreated = callback;
      }
      
      public function getFileList() : Array
      {
         return resolver.getFileList();
      }
      
      public function set serverType(type:String) : void
      {
         resolver.serverType = type;
      }
      
      public function set onFileDeleted(callback:Function) : void
      {
         resolver.onFileDeleted = callback;
      }
      
      public function makeDir(dir:String, syncFlag:Boolean = true) : void
      {
         resolver.makeDir(dir);
      }
      
      public function set timeout(valueInSeconds:Number) : void
      {
         resolver.timeout = valueInSeconds;
      }
      
      public function get isBusy() : Boolean
      {
         return resolver.isBusy;
      }
      
      public function set NOOP(value:Boolean) : void
      {
         resolver.NOOP = value;
      }
      
      public function deleteFile(filename:String, syncFlag:Boolean = true) : void
      {
         resolver.deleteFile(filename);
      }
      
      public function internal_resolver() : mdm_FTP
      {
         return resolver;
      }
      
      public function dirExists(dir:String) : Boolean
      {
         return resolver.dirExists(dir);
      }
      
      public function set onDirChanged(callback:Function) : void
      {
         resolver.onDirChanged = callback;
      }
      
      public function set passive(passiveMode:Boolean) : void
      {
         resolver.passive = passiveMode;
      }
      
      public function get supportsResume() : Boolean
      {
         return resolver.supportsResume;
      }
      
      public function set initialDir(dir:String) : void
      {
         resolver.initialDir = dir;
      }
      
      public function get currentDir() : String
      {
         return resolver.currentDir;
      }
      
      public function set onFileRenamed(callback:Function) : void
      {
         resolver.onFileRenamed = callback;
      }
      
      public function get transferTime() : Number
      {
         return resolver.transferTime;
      }
      
      public function set onError(callback:Function) : void
      {
         resolver.onError = callback;
      }
      
      public function renameFile(currentFilename:String, newFilename:String, syncFlag:Boolean = true) : void
      {
         resolver.renameFile(currentFilename,newFilename);
      }
      
      public function refresh(syncFlag:Boolean = true) : void
      {
         resolver.refresh();
      }
      
      public function set transferMode(mode:String) : void
      {
         resolver.transferMode = mode;
      }
      
      public function set onResolveLinks(callback:Function) : void
      {
         resolver.onResolveLinks = callback;
      }
      
      public function set onAborted(callback:Function) : void
      {
         resolver.onAborted = callback;
      }
      
      public function set account(accountName:String) : void
      {
         resolver.account = accountName;
      }
      
      public function deleteDir(dir:String, syncFlag:Boolean = true) : void
      {
         resolver.deleteDir(dir);
      }
      
      public function set onConnected(callback:Function) : void
      {
         resolver.onConnected = callback;
      }
      
      public function set onFileSent(callback:Function) : void
      {
         resolver.onFileSent = callback;
      }
      
      public function chDir(dir:String, syncFlag:Boolean = true) : void
      {
         resolver.chDir(dir);
      }
      
      public function login(username:String, password:String, syncFlag:Boolean = true) : void
      {
         resolver.login(username,password);
      }
      
      public function get bytesTransferred() : Number
      {
         return resolver.bytesTransferred;
      }
      
      public function moveFile(filename:String, dir:String, syncFlag:Boolean = true) : void
      {
         resolver.moveFile(filename,dir);
      }
      
      public function set onBusy(callback:Function) : void
      {
         resolver.onBusy = callback;
      }
      
      public function getFile(remoteFile:String, localFile:String, syncFlag:Boolean = true) : void
      {
         resolver.getFile(remoteFile,localFile);
      }
      
      public function get lastReply() : String
      {
         return resolver.lastReply;
      }
      
      public function resumePosition() : Number
      {
         return resolver.resumePosition();
      }
      
      public function fileExists(filename:String) : Boolean
      {
         return resolver.fileExists(filename);
      }
      
      public function get loggerData() : String
      {
         return resolver.loggerData;
      }
      
      public function get isConnected() : Boolean
      {
         return resolver.isConnected;
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_FTP extends mdm_resolver
{
   
   public function mdm_FTP(ftp:FTP, server:String, port:Number)
   {
      var arr:Array = null;
      var id:int = 0;
      super();
      SetClassName("mdm.FTP");
      AddEvents();
      arr = new Array();
      arr.push(-1,server,port);
      SetDynamic(CallSync("create",arr));
      id = int(m_dynamicID);
      m_dynFTP[id] = ftp;
   }
   
   private function AddEvents() : void
   {
      AddDynamicEvent("onAborted",false);
      AddDynamicEvent("onBusy",false);
      AddDynamicEvent("onConnected",false);
      AddDynamicEvent("onDirChanged",false);
      AddDynamicEvent("onDirCreated",false);
      AddDynamicEvent("onDirDeleted",false);
      AddDynamicEvent("onError",false);
      AddDynamicEvent("onFileDeleted",false);
      AddDynamicEvent("onFileReceived",false);
      AddDynamicEvent("onFileRenamed",false);
      AddDynamicEvent("onFileSent",false);
      AddDynamicEvent("onFileTransferred",false);
      AddDynamicEvent("onIndexFileReceived",false);
      AddDynamicEvent("onListingDone",false);
      AddDynamicEvent("onLoggedIn",false);
      AddDynamicEvent("onQuit",false);
      AddDynamicEvent("onReady",false);
      AddDynamicEvent("onResolveLinks",false);
   }
}
