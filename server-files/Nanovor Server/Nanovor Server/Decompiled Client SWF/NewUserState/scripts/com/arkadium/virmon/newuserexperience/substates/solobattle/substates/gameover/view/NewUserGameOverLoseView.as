package com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.view
{
   import fl.motion.MotionEvent;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol61")]
   public class NewUserGameOverLoseView extends AbstractNewUserGameOver
   {
      
      public var mcSelectionSpinner:Sprite;
      
      public function NewUserGameOverLoseView(param1:INewUserGameOverViewConsumer)
      {
         addFrameScript(274,frame275);
         super(param1);
      }
      
      override public function init() : void
      {
         super.initSpinner(mcSelectionSpinner);
      }
      
      internal function frame275() : *
      {
         stop();
         this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
      }
   }
}

