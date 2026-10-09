package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import com.smithandtinker.nanovor.debug.*;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   
   public class AnimationSequencer extends EventDispatcher
   {
      
      private var _iFrameCounter:int;
      
      private var _playingAnimation:SequenceAnimData;
      
      private var _queuedAnimations:Array;
      
      private var _secondaryCompleteHandler:Function;
      
      private var _isPlaying:Boolean;
      
      private var _parentClip:MovieClip;
      
      public function AnimationSequencer(param1:MovieClip)
      {
         super();
         _parentClip = param1;
         if(_parentClip == null)
         {
            logError("Constructed with null parent clip!");
            _parentClip = new MovieClip();
         }
         _queuedAnimations = new Array();
         _isPlaying = false;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AnimationSequencer: " + param1);
      }
      
      public function UnloadAll() : void
      {
         var _loc1_:DisplayObject = null;
         log("Unloading ALL movie(s)");
         while(_parentClip.numChildren > 0)
         {
            _loc1_ = _parentClip.getChildAt(0);
            _loc1_.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            _parentClip.removeChild(_loc1_);
         }
         _queuedAnimations = new Array();
      }
      
      public function LoadAndQueueClip(param1:String, param2:Function = null, param3:Function = null) : void
      {
         var _loc4_:URLRequest = new URLRequest(param1);
         var _loc5_:Loader = new Loader();
         _queuedAnimations.push(SequenceAnimData.FromLoader(_loc5_,param2,param3));
         _loc5_.contentLoaderInfo.addEventListener(Event.COMPLETE,clipLoadCompleteHandler);
         _loc5_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,clipLoadErrorHandler);
         if(param2 != null)
         {
            _secondaryCompleteHandler = param2;
         }
         _loc5_.load(_loc4_);
      }
      
      public function Play() : void
      {
         _isPlaying = true;
         attachAndPlayNextMovie();
      }
      
      protected function enterFrameHandler(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         if(_isPlaying)
         {
            if(_playingAnimation.Clip.currentFrame == _playingAnimation.Clip.totalFrames)
            {
               if(_playingAnimation.CompleteHandler != null)
               {
                  _playingAnimation.CompleteHandler();
               }
               _loc2_ = true;
               if(_queuedAnimations.length > 0)
               {
                  if(Boolean(_queuedAnimations[0].IsLoaded))
                  {
                     _playingAnimation.Clip.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
                     if(_playingAnimation !== null && _playingAnimation.Clip !== null)
                     {
                        if(_parentClip.contains(_playingAnimation.Clip))
                        {
                           _parentClip.removeChild(_playingAnimation.Clip);
                        }
                     }
                     _playingAnimation = null;
                     attachAndPlayNextMovie();
                     _loc2_ = false;
                  }
               }
               if(_loc2_ && _isPlaying)
               {
                  _iFrameCounter = 0;
                  _playingAnimation.Clip.gotoAndStop(1);
               }
            }
            else if(++_iFrameCounter % 2 == 0)
            {
               _playingAnimation.Clip.nextFrame();
            }
         }
      }
      
      protected function clipLoadErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,clipLoadCompleteHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,clipLoadErrorHandler);
         if(getLoadingCount() == 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      protected function clipLoadCompleteHandler(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,clipLoadCompleteHandler);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,clipLoadErrorHandler);
         if(_secondaryCompleteHandler != null)
         {
            _secondaryCompleteHandler(param1);
         }
         _secondaryCompleteHandler = null;
         if(getLoadingCount() == 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      public function Unload(param1:Boolean = false) : void
      {
         log("Unloading movie.");
         if(_playingAnimation != null)
         {
            _playingAnimation.Clip.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            _parentClip.removeChild(_playingAnimation.Clip);
            _playingAnimation = null;
            _queuedAnimations = new Array();
         }
         if(param1)
         {
            _queuedAnimations = new Array();
         }
      }
      
      public function Stop() : void
      {
         if(_isPlaying)
         {
            _isPlaying = false;
            if(_playingAnimation != null)
            {
               _playingAnimation.Clip.stop();
            }
         }
      }
      
      public function get isPlaying() : Boolean
      {
         return _isPlaying;
      }
      
      public function QueueClip(param1:MovieClip, param2:Function = null) : void
      {
         _queuedAnimations.push(SequenceAnimData.FromClip(param1,param2));
      }
      
      private function getLoadingCount() : int
      {
         var _loc2_:SequenceAnimData = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _queuedAnimations)
         {
            if(!_loc2_.IsLoaded)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> AnimationSequencer: ** " + param1 + " **");
      }
      
      private function attachAndPlayNextMovie() : void
      {
         log("Attaching new movie.");
         if(_queuedAnimations.length > 0 && _playingAnimation == null)
         {
            _playingAnimation = _queuedAnimations.shift();
            _parentClip.addChildAt(_playingAnimation.Clip,0);
            _iFrameCounter = 0;
            _playingAnimation.Clip.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
            _playingAnimation.Clip.gotoAndStop(1);
         }
      }
   }
}

