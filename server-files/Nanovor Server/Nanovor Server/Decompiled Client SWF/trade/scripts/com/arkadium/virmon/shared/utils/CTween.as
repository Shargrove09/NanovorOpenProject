package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.common.EventManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CTween extends EventDispatcher
   {
      
      public static const MOTION_FINISH:String = "motionfinish";
      
      private var _bIsPlaying:Boolean;
      
      private var _nFirstPosition:Number;
      
      private var _nSecondPosition:Number;
      
      private var _uiFramesNum:uint;
      
      private var _nStep:Number;
      
      private var _mcTweenObj:MovieClip;
      
      private var _sProperty:String;
      
      private var _uiFrameCounter:uint;
      
      public function CTween(param1:MovieClip, param2:String, param3:Number, param4:Number, param5:uint)
      {
         super();
         _mcTweenObj = param1;
         _sProperty = param2;
         _nFirstPosition = param3;
         _nSecondPosition = param4;
         _uiFramesNum = param5;
         init();
      }
      
      private function init() : void
      {
         EventManager.getInstance().addEventListener("UNLOAD",onUnload,false,0,true);
         _mcTweenObj[_sProperty] = _nFirstPosition;
         _uiFrameCounter = 0;
         _nStep = (_nSecondPosition - _nFirstPosition) / _uiFramesNum;
         start();
      }
      
      public function stop() : void
      {
         _bIsPlaying = false;
         if(Boolean(_mcTweenObj))
         {
            _mcTweenObj.removeEventListener(Event.ENTER_FRAME,trackEnterFrame);
         }
      }
      
      private function trackEnterFrame(param1:Event) : void
      {
         ++_uiFrameCounter;
         if(_uiFrameCounter < _uiFramesNum)
         {
            if(_nStep > 0 && _mcTweenObj[_sProperty] < _nSecondPosition || _nStep < 0 && _mcTweenObj[_sProperty] > _nSecondPosition)
            {
               _mcTweenObj[_sProperty] += _nStep;
            }
         }
         else
         {
            _mcTweenObj[_sProperty] = _nSecondPosition;
            stop();
            dispatchEvent(new Event(MOTION_FINISH));
            destroy();
         }
      }
      
      public function start() : void
      {
         _bIsPlaying = true;
         _mcTweenObj.addEventListener(Event.ENTER_FRAME,trackEnterFrame,false,0,true);
      }
      
      public function get isPlaying() : Boolean
      {
         return _bIsPlaying;
      }
      
      public function get position() : Number
      {
         if(Boolean(_mcTweenObj))
         {
            return _mcTweenObj[_sProperty];
         }
         return 0;
      }
      
      public function destroy() : void
      {
         EventManager.getInstance().removeEventListener("UNLOAD",onUnload);
         if(Boolean(_mcTweenObj))
         {
            _mcTweenObj.removeEventListener(Event.ENTER_FRAME,trackEnterFrame);
         }
         _mcTweenObj = null;
         delete global[this];
      }
      
      private function onUnload(param1:Event) : void
      {
         destroy();
      }
   }
}

