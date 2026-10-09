package com.arkadium.virmon.transitions
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TransitionManager implements ITransitionManager
   {
      
      public static const GENERIC_TRANSITION:String = "GenericTransition.swf";
      
      private static const START_FRAME:String = "Start";
      
      private static const MIDPOINT_FRAME:String = "Midpoint";
      
      private static const FINISH_FRAME:String = "Finish";
      
      private static const FINISHED_FRAME:String = "Finished";
      
      private var _transitionContainer:DisplayObjectContainer;
      
      private var _stageBitmap:Bitmap;
      
      private var _consumer:ITransitionManagerConsumer;
      
      private var _defaultTransition:MovieClip;
      
      public function TransitionManager(param1:DisplayObjectContainer, param2:MovieClip)
      {
         super();
         if(null == param1)
         {
            throw new Error("Transition container is null");
         }
         if(null == param1.stage)
         {
            throw new Error("Transition container is not on stage");
         }
         if(null == param2)
         {
            throw new Error("Default transition is null");
         }
         if(null == param2.mcTransition)
         {
            throw new Error("Default transition does not contain \"mcTransition\" instance");
         }
         this._transitionContainer = param1;
         this._defaultTransition = param2;
      }
      
      private function waitForMidpoint(param1:Event) : *
      {
         if(this._defaultTransition.mcTransition.currentLabel == MIDPOINT_FRAME)
         {
            this._defaultTransition.removeEventListener(Event.ENTER_FRAME,this.waitForMidpoint);
            if(null != this._consumer)
            {
               this._consumer.handleTransitionMidpoint();
            }
         }
      }
      
      public function finishTransition() : void
      {
         this.removeStageBitmap();
         this._defaultTransition.mcTransition.gotoAndPlay(FINISH_FRAME);
         this._defaultTransition.addEventListener(Event.ENTER_FRAME,this.waitForFinished,false,0,true);
      }
      
      private function removeStageBitmap() : void
      {
         if(null != this._stageBitmap)
         {
            if(null != this._stageBitmap.parent)
            {
               this._stageBitmap.parent.removeChild(this._stageBitmap);
            }
            this._stageBitmap.bitmapData.dispose();
            this._stageBitmap = null;
         }
      }
      
      private function waitForFinished(param1:Event) : *
      {
         if(this._defaultTransition.mcTransition.currentLabel == FINISHED_FRAME)
         {
            this._defaultTransition.removeEventListener(Event.ENTER_FRAME,this.waitForFinished);
            if(null != this._defaultTransition.parent)
            {
               this._defaultTransition.parent.removeChild(this._defaultTransition);
            }
            if(null != this._consumer)
            {
               this._consumer.handleTransitionComplete();
            }
         }
      }
      
      public function init(param1:ITransitionManagerConsumer) : void
      {
         this._consumer = param1;
      }
      
      public function startTransition() : void
      {
         this.removeStageBitmap();
         var _loc1_:BitmapData = new BitmapData(1024,768,false,0);
         _loc1_.draw(this._transitionContainer.stage);
         this._stageBitmap = new Bitmap(_loc1_);
         this._transitionContainer.addChild(this._stageBitmap);
         this._transitionContainer.addChild(this._defaultTransition);
         this._defaultTransition.mcTransition.gotoAndPlay(START_FRAME);
         this._defaultTransition.addEventListener(Event.ENTER_FRAME,this.waitForMidpoint,false,0,true);
      }
   }
}

