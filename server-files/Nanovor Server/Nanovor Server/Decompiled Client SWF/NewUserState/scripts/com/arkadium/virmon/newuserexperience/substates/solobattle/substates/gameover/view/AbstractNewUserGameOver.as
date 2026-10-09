package com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.view
{
   import caurina.transitions.Tweener;
   import fl.motion.MotionEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AbstractNewUserGameOver extends MovieClip implements INewUserGameOver
   {
      
      private var _consumer:INewUserGameOverViewConsumer;
      
      private var _spinner:Sprite;
      
      public function AbstractNewUserGameOver(param1:INewUserGameOverViewConsumer)
      {
         super();
         _consumer = param1;
         this.stop();
      }
      
      public function init() : void
      {
      }
      
      protected function initSpinner(param1:Sprite) : void
      {
         _spinner = param1;
         if(null != _spinner.parent)
         {
            _spinner.parent.removeChild(_spinner);
         }
         this.gotoAndPlay(1);
         this.addEventListener(MotionEvent.MOTION_END,handleMotionEnd,false,0,true);
      }
      
      public function get sprite() : Sprite
      {
         return this as Sprite;
      }
      
      private function handleSpinnerClick(param1:MouseEvent) : void
      {
         _consumer.handleGameOverComplete();
      }
      
      private function handleMotionEnd(param1:MotionEvent) : void
      {
         _spinner.addEventListener(MouseEvent.CLICK,handleSpinnerClick,false,0,true);
         _spinner.buttonMode = true;
         _spinner.useHandCursor = true;
         _spinner.alpha = 0;
         this.addChild(_spinner);
         Tweener.addTween(_spinner,{
            "alpha":1,
            "time":1
         });
      }
   }
}

