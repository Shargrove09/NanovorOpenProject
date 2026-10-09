package com.arkadium.virmon.device.associatepanel
{
   import com.arkadium.virmon.shared.utils.FramerateTickController;
   import com.arkadium.virmon.shared.utils.IFramerateTickConsumer;
   import flash.display.MovieClip;
   
   public class AssociatePanelTitleController implements IFramerateTickConsumer
   {
      
      private var _target:MovieClip;
      
      private var _forward:Boolean;
      
      private var _finishCallback:Function;
      
      public function AssociatePanelTitleController(param1:MovieClip)
      {
         super();
         _target = param1;
      }
      
      private function stopTick() : void
      {
         FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
         if(null != _finishCallback)
         {
            _finishCallback();
            _finishCallback = null;
         }
      }
      
      public function close(param1:Boolean = false, param2:Function = null) : void
      {
         _finishCallback = param2;
         if(param1)
         {
            _target.gotoAndStop(_target.totalFrames);
         }
         _forward = false;
         FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
      }
      
      public function open(param1:Boolean = false, param2:Function = null) : void
      {
         _finishCallback = param2;
         if(param1)
         {
            _target.gotoAndStop(1);
         }
         _forward = true;
         FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
      }
      
      public function tick() : void
      {
         if(_forward)
         {
            _target.gotoAndStop(_target.currentFrame + 1);
            if(_target.currentFrame + 1 > _target.totalFrames)
            {
               stopTick();
            }
         }
         else
         {
            _target.gotoAndStop(_target.currentFrame - 1);
            if(_target.currentFrame - 1 < 1)
            {
               stopTick();
            }
         }
      }
   }
}

