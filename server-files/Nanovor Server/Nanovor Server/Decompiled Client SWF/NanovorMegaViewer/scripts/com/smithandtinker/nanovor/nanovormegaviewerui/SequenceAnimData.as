package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class SequenceAnimData
   {
      
      private var _isLoaded:Boolean;
      
      private var _clip:MovieClip;
      
      private var _loader:Loader;
      
      private var _secondaryCompleteHandler:Function;
      
      private var _completeHandler:Function;
      
      public function SequenceAnimData(param1:Function = null)
      {
         super();
         _isLoaded = false;
         _completeHandler = param1;
      }
      
      public static function FromClip(param1:MovieClip, param2:Function = null) : SequenceAnimData
      {
         var _loc3_:SequenceAnimData = new SequenceAnimData(param2);
         _loc3_.SetClip(param1);
         return _loc3_;
      }
      
      public static function FromLoader(param1:Loader, param2:Function = null, param3:Function = null) : SequenceAnimData
      {
         var _loc4_:SequenceAnimData = new SequenceAnimData(param3);
         _loc4_.SetLoader(param1,param2);
         return _loc4_;
      }
      
      public function SetClip(param1:MovieClip) : void
      {
         _clip = param1;
         _isLoaded = true;
      }
      
      public function get ClipLoader() : Loader
      {
         return _loader;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> SequenceAnimData: " + param1);
      }
      
      private function loadErrorHandler(param1:IOErrorEvent) : void
      {
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
         logError("Failed to load queued clip: " + _loader.contentLoaderInfo.url);
         _clip = new MovieClip();
         _isLoaded = true;
      }
      
      public function get Clip() : MovieClip
      {
         return _clip;
      }
      
      public function get CompleteHandler() : Function
      {
         return _completeHandler;
      }
      
      public function SetLoader(param1:Loader, param2:Function = null) : void
      {
         _loader = param1;
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler,false,0,true);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler,false,0,true);
         if(param2 != null)
         {
            _secondaryCompleteHandler = param2;
         }
      }
      
      public function get IsLoaded() : Boolean
      {
         return _isLoaded;
      }
      
      private function loadCompleteHandler(param1:Event) : void
      {
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
         if(_secondaryCompleteHandler != null)
         {
            _secondaryCompleteHandler(param1);
         }
         _secondaryCompleteHandler = null;
         _clip = MovieClip(_loader.content);
         _isLoaded = true;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> SequenceAnimData: ** " + param1 + " **");
      }
   }
}

