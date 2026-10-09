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
         _target = param1;
         _target.stop();
         _framesPerTick = 1;
         _targetFramesPerTick = 1;
      }
      
      public function destroy() : void
      {
         FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
         Tweener.removeTweens(this);
         _target = null;
      }
      
      public function stop(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
         }
         else
         {
            _stopOnFrame = param1 % _target.totalFrames;
         }
      }
      
      public function get framesPerTick() : Number
      {
         return _framesPerTick;
      }
      
      public function get speed() : Number
      {
         return _targetFramesPerTick;
      }
      
      public function set speed(param1:Number) : void
      {
         _targetFramesPerTick = param1;
         Tweener.addTween(this,{
            "framesPerTick":_targetFramesPerTick,
            "time":1,
            "rounded":true,
            "transition":"easeOutQuad"
         });
      }
      
      public function set framesPerTick(param1:Number) : void
      {
         _framesPerTick = param1;
      }
      
      public function get currentFrame() : int
      {
         return _target.currentFrame;
      }
      
      public function play() : void
      {
         _stopOnFrame = -1;
         FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
      }
      
      public function tick() : void
      {
         if(_stopOnFrame != -1 && int(_target.currentFrame + _framesPerTick) % _target.totalFrames + 1 >= _stopOnFrame)
         {
            _stopOnFrame = -1;
            _target.gotoAndStop(_stopOnFrame);
            FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
            return;
         }
         _target.gotoAndStop(int(_target.currentFrame + _framesPerTick) % _target.totalFrames + 1);
      }
   }
}

