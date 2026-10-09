package com.arkadium.virmon.movieplayer
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.Event;
   
   public dynamic class OverlayContainer extends AnimationContainer
   {
      
      public var _xPositionMotion:XML;
      
      public var _bFollowing:Boolean = true;
      
      public var _nBaseX:Number;
      
      public var _nBaseY:Number;
      
      public function OverlayContainer()
      {
         super();
      }
      
      override public function doAction(param1:MovieClip) : *
      {
         var mcAnimation:MovieClip = param1;
         super.doAction(mcAnimation);
         try
         {
            _mcActiveAnimation.x = -1 * Number(_xPositionMotion.frame[0].@translationX);
            _mcActiveAnimation.y = Number(_xPositionMotion.frame[0].@translationY);
         }
         catch(e:*)
         {
            trace("no hloc info");
            logError("Error during doAction - no hloc info: " + e.toString() + "\n" + e.getStackTrace());
            _mcActiveAnimation.x = 0;
            _mcActiveAnimation.y = 0;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> OverlayContainer: " + param1);
      }
      
      override protected function trackOnEnterFrame(param1:Event) : void
      {
         var nCF:* = undefined;
         var nNextFrame:* = undefined;
         var nOverlayframeToPlay:* = undefined;
         var oEvent:Event = param1;
         if(++_nFrameOffestCounter % 2 == 0)
         {
            nCF = _mcActiveAnimation.currentFrame;
            nNextFrame = nCF + 1;
            if(_nFramesPlayed < _xPositionMotion.frame.length())
            {
               if(_bFollowing == true)
               {
                  nOverlayframeToPlay = _nFramesPlayed + 2;
                  if(nOverlayframeToPlay >= _xPositionMotion.frame.length())
                  {
                     nOverlayframeToPlay = _xPositionMotion.frame.length() - 1;
                  }
                  try
                  {
                     _mcActiveAnimation.x = -1 * Number(_xPositionMotion.frame[nOverlayframeToPlay].@translationX);
                     _mcActiveAnimation.y = Number(_xPositionMotion.frame[nOverlayframeToPlay].@translationY);
                  }
                  catch(e:*)
                  {
                     trace("no postion data");
                     logError("Error during trackOnEnterFrame - no postion data: " + e.toString());
                     _mcActiveAnimation.x = 0;
                     _mcActiveAnimation.y = 0;
                  }
               }
               if(_aEventList[nCF] != null)
               {
                  _aEventList[nCF](this);
                  playNextFrame(nNextFrame);
               }
               else
               {
                  playNextFrame(nNextFrame);
               }
            }
            else
            {
               _fEndFunction(this);
            }
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> OverlayContainer: ** " + param1 + " **");
      }
      
      public function setXScale(param1:*) : *
      {
         _mcActiveAnimation.scaleX = param1;
      }
      
      override public function initNewActiveAnimation() : *
      {
         _nFramesPlayed = 0;
         _nTotalframes = _mcActiveAnimation.totalFrames;
      }
      
      public function setX(param1:*) : *
      {
         _mcActiveAnimation.x = param1;
      }
      
      public function setY(param1:*) : *
      {
         _mcActiveAnimation.y = param1;
      }
   }
}

