package com.arkadium.virmon.shared.utils
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class NanovorAnimationSequencer extends Sprite implements IFramerateTickConsumer
   {
      
      private var _default:AnimationInstructions;
      
      private var _speedMultiplier:Number;
      
      private var _queue:Array;
      
      private var _current:AnimationInstructions;
      
      private var _consumers:Dictionary;
      
      public function NanovorAnimationSequencer()
      {
         super();
         FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
         _queue = new Array();
         _consumers = new Dictionary(true);
         _speedMultiplier = 1;
      }
      
      public function clearAnimationQueue() : void
      {
         _queue.splice(0,_queue.length);
      }
      
      public function addAnimation(param1:MovieClip, param2:Object = null) : void
      {
         _queue.push(new AnimationInstructions(param1,param2));
      }
      
      public function setSpeed(param1:Number) : void
      {
         _speedMultiplier = param1;
      }
      
      private function dispatchClipStarted(param1:MovieClip) : void
      {
         var _loc2_:INanovorAnimationSequencerConsumer = null;
         for each(_loc2_ in _consumers)
         {
            _loc2_.handleAnimationClipStarted(param1);
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:INanovorAnimationSequencerConsumer = null;
         FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
         for each(_loc1_ in _consumers)
         {
            delete _consumers[_loc1_];
         }
      }
      
      public function setDefaultAnimation(param1:MovieClip, param2:Object = null) : void
      {
         _default = new AnimationInstructions(param1,param2);
         if(_current == null)
         {
            _current = _default;
         }
      }
      
      private function gotoNextAnimation() : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         if(_queue.length > 0)
         {
            _current = _queue.splice(0,1)[0] as AnimationInstructions;
            dispatchClipStarted(_current.clip);
            this.addChild(_current.clip);
         }
         else
         {
            if(null == _default || null == _default.clip)
            {
               return;
            }
            if(_current != _default)
            {
               dispatchClipStarted(_default.clip);
            }
            _current = _default;
            _current.reset();
            this.addChild(_current.clip);
         }
      }
      
      public function addInterruptAnimation(param1:MovieClip, param2:Object = null) : void
      {
         _queue.splice(0,0,new AnimationInstructions(param1,param2));
         gotoNextAnimation();
      }
      
      public function stop() : void
      {
         FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
      }
      
      public function addConsumer(param1:INanovorAnimationSequencerConsumer) : void
      {
         _consumers[param1] = param1;
      }
      
      public function play() : void
      {
         FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
      }
      
      public function tick() : void
      {
         if(_current == null)
         {
            if(_queue.length <= 0)
            {
               return;
            }
            _current = _queue.splice(0,1)[0] as AnimationInstructions;
         }
         if(_current.isAtEnd())
         {
            gotoNextAnimation();
         }
         else
         {
            _current.tick(_speedMultiplier);
         }
      }
   }
}

import flash.display.MovieClip;

class AnimationInstructions
{
   
   private static const BASE_PARAMETERS:Object = {
      "speed":1,
      "scaleX":1,
      "scaleY":1,
      "reverse":false,
      "stop":false
   };
   
   public var reverse:Boolean;
   
   public var speed:Number;
   
   public var stop:Boolean;
   
   public var clip:MovieClip;
   
   public var currentFrame:Number;
   
   public function AnimationInstructions(param1:MovieClip, param2:Object = null)
   {
      var _loc4_:String = null;
      super();
      if(param1 == null)
      {
         return;
      }
      clip = param1;
      currentFrame = 1;
      clip.gotoAndStop(currentFrame);
      var _loc3_:Object = new Object();
      for(_loc4_ in BASE_PARAMETERS)
      {
         _loc3_[_loc4_] = BASE_PARAMETERS[_loc4_];
      }
      if(param2 != null)
      {
         for(_loc4_ in param2)
         {
            _loc3_[_loc4_] = param2[_loc4_];
         }
      }
      speed = Math.abs(_loc3_.speed);
      clip.scaleX = _loc3_.scaleX;
      clip.scaleY = _loc3_.scaleY;
      reverse = _loc3_.reverse;
      stop = _loc3_.stop;
   }
   
   public function reset() : void
   {
      if(reverse)
      {
         currentFrame = clip.totalFrames;
      }
      else
      {
         currentFrame = 1;
      }
   }
   
   private function clampCurrentFrames() : Number
   {
      currentFrame = Math.min(currentFrame,clip.totalFrames);
      currentFrame = Math.max(currentFrame,0);
      return currentFrame;
   }
   
   public function tick(param1:Number) : void
   {
      if(stop)
      {
         return;
      }
      if(reverse)
      {
         currentFrame -= 1 * speed * param1;
      }
      else
      {
         currentFrame += 1 * speed * param1;
      }
      currentFrame = clampCurrentFrames();
      clip.gotoAndStop(int(currentFrame));
   }
   
   public function isAtEnd() : Boolean
   {
      if(stop)
      {
         return true;
      }
      if(null == clip)
      {
         return true;
      }
      if(reverse)
      {
         if(currentFrame <= 1)
         {
            return true;
         }
      }
      else if(currentFrame >= clip.totalFrames)
      {
         return true;
      }
      return false;
   }
}
