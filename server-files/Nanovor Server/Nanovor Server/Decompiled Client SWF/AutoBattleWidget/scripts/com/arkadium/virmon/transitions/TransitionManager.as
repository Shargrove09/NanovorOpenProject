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
         _transitionContainer = param1;
         _defaultTransition = param2;
      }
      
      private function waitForMidpoint(param1:Event) : *
      {
         if(_defaultTransition.mcTransition.currentLabel == MIDPOINT_FRAME)
         {
            _defaultTransition.removeEventListener(Event.ENTER_FRAME,waitForMidpoint);
            if(null != _consumer)
            {
               _consumer.handleTransitionMidpoint();
            }
         }
      }
      
      public function finishTransition() : void
      {
         removeStageBitmap();
         _defaultTransition.mcTransition.gotoAndPlay(FINISH_FRAME);
         _defaultTransition.addEventListener(Event.ENTER_FRAME,waitForFinished,false,0,true);
      }
      
      private function removeStageBitmap() : void
      {
         if(null != _stageBitmap)
         {
            if(null != _stageBitmap.parent)
            {
               _stageBitmap.parent.removeChild(_stageBitmap);
            }
            _stageBitmap.bitmapData.dispose();
            _stageBitmap = null;
         }
      }
      
      private function waitForFinished(param1:Event) : *
      {
         if(_defaultTransition.mcTransition.currentLabel == FINISHED_FRAME)
         {
            _defaultTransition.removeEventListener(Event.ENTER_FRAME,waitForFinished);
            if(null != _defaultTransition.parent)
            {
               _defaultTransition.parent.removeChild(_defaultTransition);
            }
            if(null != _consumer)
            {
               _consumer.handleTransitionComplete();
            }
         }
      }
      
      public function init(param1:ITransitionManagerConsumer) : void
      {
         _consumer = param1;
      }
      
      public function startTransition() : void
      {
         removeStageBitmap();
         var _loc1_:BitmapData = new BitmapData(1024,768,false,0);
         _loc1_.draw(_transitionContainer.stage);
         _stageBitmap = new Bitmap(_loc1_);
         _transitionContainer.addChild(_stageBitmap);
         _transitionContainer.addChild(_defaultTransition);
         _defaultTransition.mcTransition.gotoAndPlay(START_FRAME);
         _defaultTransition.addEventListener(Event.ENTER_FRAME,waitForMidpoint,false,0,true);
      }
   }
}

