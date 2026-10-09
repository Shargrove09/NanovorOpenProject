package com.arkadium.virmon.downloadovor
{
   import com.arkadium.virmon.shared.utils.IDownloaderConsumer;
   
   internal class QueueFile
   {
      
      private var _retryAttempts:int;
      
      private var _isLocalFileCopy:Boolean;
      
      private var _cacheVersion:String;
      
      private var _fileSource:String;
      
      private var _maxRetries:int;
      
      private var _consumer:IDownloaderConsumer;
      
      private var _fileDestination:String;
      
      public function QueueFile(param1:IDownloaderConsumer, param2:String, param3:String, param4:String = "", param5:int = 2, param6:Boolean = false)
      {
         super();
         _consumer = param1;
         _fileSource = param2;
         _fileDestination = param3;
         _cacheVersion = param4 == null ? "" : param4;
         _maxRetries = param5;
         _retryAttempts = 0;
         _isLocalFileCopy = param6;
      }
      
      public function get maxRetries() : int
      {
         return _maxRetries;
      }
      
      public function get retryAttempts() : int
      {
         return _retryAttempts;
      }
      
      public function get isLocalFileCopy() : Boolean
      {
         return _isLocalFileCopy;
      }
      
      public function set retryAttempts(param1:int) : void
      {
         _retryAttempts = param1;
      }
      
      public function clone() : QueueFile
      {
         return new QueueFile(_consumer,_fileSource,_fileDestination,_cacheVersion,_maxRetries,_isLocalFileCopy);
      }
      
      public function set fileSource(param1:String) : void
      {
         _fileSource = param1;
      }
      
      public function get fileDestination() : String
      {
         return _fileDestination;
      }
      
      public function get consumer() : IDownloaderConsumer
      {
         return _consumer;
      }
      
      public function get fileSource() : String
      {
         return _fileSource;
      }
      
      public function get cacheVersion() : String
      {
         return _cacheVersion;
      }
   }
}

