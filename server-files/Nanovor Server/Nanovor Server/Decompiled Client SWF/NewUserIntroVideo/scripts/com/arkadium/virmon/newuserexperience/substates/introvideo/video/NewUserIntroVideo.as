package com.arkadium.virmon.newuserexperience.substates.introvideo.video
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class NewUserIntroVideo extends MovieClip implements INewUserIntroVideo
   {
      
      private var _consumer:INewUserIntroVideoConsumer;
      
      public function NewUserIntroVideo()
      {
         super();
         addFrameScript(1222,this.frame1223);
         this.gotoAndStop(1);
         this.addEventListener(Event.COMPLETE,this.handleVideoComplete);
      }
      
      public function init(param1:INewUserIntroVideoConsumer) : void
      {
         this._consumer = param1;
         this.play();
      }
      
      public function get sprite() : Sprite
      {
         return this as Sprite;
      }
      
      private function handleVideoComplete(param1:Event) : void
      {
         this.removeEventListener(Event.COMPLETE,this.handleVideoComplete);
         if(null != this._consumer)
         {
            this._consumer.handleIntroVideoComplete();
         }
      }
      
      internal function frame1223() : *
      {
         stop();
         this.dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

