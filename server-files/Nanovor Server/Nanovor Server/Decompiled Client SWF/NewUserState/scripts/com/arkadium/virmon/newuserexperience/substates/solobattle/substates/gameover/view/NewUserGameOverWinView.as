package com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.view
{
   import fl.motion.MotionEvent;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol41")]
   public class NewUserGameOverWinView extends AbstractNewUserGameOver
   {
      
      public var mcSelectionSpinner:Sprite;
      
      public function NewUserGameOverWinView(param1:INewUserGameOverViewConsumer)
      {
         addFrameScript(238,frame239);
         super(param1);
      }
      
      override public function init() : void
      {
         super.initSpinner(mcSelectionSpinner);
      }
      
      internal function frame239() : *
      {
         stop();
         this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
      }
   }
}

