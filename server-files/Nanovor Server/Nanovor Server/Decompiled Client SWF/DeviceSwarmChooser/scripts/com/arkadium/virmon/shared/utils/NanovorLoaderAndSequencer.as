package com.arkadium.virmon.shared.utils
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class NanovorLoaderAndSequencer extends Sprite
   {
      
      private var _sequencer:NanovorAnimationSequencer;
      
      private var _sequencerParams:Object;
      
      private var _loader:Loader;
      
      public function NanovorLoaderAndSequencer(param1:String, param2:Object)
      {
         super();
         _sequencerParams = param2;
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanovorLoadComplete);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         _loader.load(new URLRequest(param1));
         _sequencer = new NanovorAnimationSequencer();
         this.addChild(_sequencer);
      }
      
      public function stopAnimations() : void
      {
         _sequencer.stop();
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         log("onNanovorLoadComplete()");
         var _loc2_:MovieClip = _loader.content as MovieClip;
         _sequencer.addInterruptAnimation(_loc2_,_sequencerParams);
         _sequencer.setDefaultAnimation(_loc2_,_sequencerParams);
         removeLoaderEventListeners();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<NanovorLoaderAndSequencer>>\t" + param1);
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         log("onNanovorLoadError()");
         removeLoaderEventListeners();
      }
      
      private function removeLoaderEventListeners() : void
      {
         if(null != _loader && null != _loader.contentLoaderInfo)
         {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         }
      }
   }
}

