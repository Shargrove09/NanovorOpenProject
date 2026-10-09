package com.arkadium.virmon.shared.utils
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   
   public class LoopHelper implements IFramerateTickConsumer
   {
      
      public static const DEFAULT_FRAME_RATE:int = 30;
      
      private var _targetFramesPerTick:Number;
      
      private var _stopOnFrame:int = -1;
      
      private var _target:MovieClip;
      
      private var _framesPerTick:Number;
      
      public function LoopHelper(param1:MovieClip)
      {
         super();
         this._target = param1;
         this._target.stop();
         this._framesPerTick = 1;
         this._targetFramesPerTick = 1;
      }
      
      public function destroy() : void
      {
         FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
         Tweener.removeTweens(this);
         this._target = null;
      }
      
      public function stop(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
         }
         else
         {
            this._stopOnFrame = param1 % this._target.totalFrames;
         }
      }
      
      public function get framesPerTick() : Number
      {
         return this._framesPerTick;
      }
      
      public function get speed() : Number
      {
         return this._targetFramesPerTick;
      }
      
      public function set speed(param1:Number) : void
      {
         this._targetFramesPerTick = param1;
         Tweener.addTween(this,{
            "framesPerTick":this._targetFramesPerTick,
            "time":1,
            "rounded":true,
            "transition":"easeOutQuad"
         });
      }
      
      public function set framesPerTick(param1:Number) : void
      {
         this._framesPerTick = param1;
      }
      
      public function get currentFrame() : int
      {
         return this._target.currentFrame;
      }
      
      public function play() : void
      {
         this._stopOnFrame = -1;
         FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
      }
      
      public function tick() : void
      {
         if(this._stopOnFrame != -1 && int(this._target.currentFrame + this._framesPerTick) % this._target.totalFrames + 1 >= this._stopOnFrame)
         {
            this._stopOnFrame = -1;
            this._target.gotoAndStop(this._stopOnFrame);
            FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
            return;
         }
         this._target.gotoAndStop(int(this._target.currentFrame + this._framesPerTick) % this._target.totalFrames + 1);
      }
   }
}

