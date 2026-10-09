package com.arkadium.virmon.shared.utils
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class ArkMc extends MovieClip
   {
      
      private var _aEventNameList:Array;
      
      public var _bPlaying:Boolean;
      
      private var _sCurrentFrameLabel:String;
      
      private var _aEventList:Array;
      
      private var _fExecuteNowFunction:Function;
      
      private var _fEndFunction:Function;
      
      private var _sEndFrameLabel:String;
      
      private var _nTotalframes:Number;
      
      public function ArkMc()
      {
         super();
         log(this.name);
         onInitialize();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ArkMc: " + param1);
      }
      
      public function clearTriggerEventByNum(param1:Number) : *
      {
         _aEventList[param1] = undefined;
      }
      
      public function gotoAndStopAnimation(param1:*) : *
      {
         if(param1 != undefined)
         {
            this.gotoAndStop(param1);
         }
         else
         {
            this.stop();
         }
         _bPlaying = false;
         this.removeEventListener(Event.ENTER_FRAME,trackOnEnterFrame);
         this.removeEventListener(Event.RENDER,trackProgress);
      }
      
      public function onInitialize() : *
      {
         this.stop();
         _bPlaying = false;
         _aEventList = new Array();
         _aEventNameList = new Array();
         _nTotalframes = this.totalFrames;
         _sCurrentFrameLabel = null;
         _fEndFunction = endFunction;
      }
      
      public function setEndFunction(param1:Function) : *
      {
         _fEndFunction = param1;
      }
      
      public function setTriggerEventByNum(param1:Number, param2:Function) : *
      {
         _aEventList[param1] = param2;
      }
      
      internal function endFunction() : *
      {
         stopAnimation();
      }
      
      private function executeStoppedRender(param1:Event) : void
      {
         if(_sCurrentFrameLabel != this.currentLabel)
         {
            _sCurrentFrameLabel = this.currentLabel;
            if(_aEventNameList["frameEvent" + _sCurrentFrameLabel] != null)
            {
               _aEventNameList["frameEvent" + _sCurrentFrameLabel]();
            }
         }
         else if(_aEventList[this.currentFrame] != null)
         {
            _aEventList[this.currentFrame]();
         }
         else if(this.currentFrame >= _nTotalframes)
         {
            _fEndFunction();
         }
         if(_fExecuteNowFunction != null)
         {
            _fExecuteNowFunction();
         }
         this.removeEventListener(Event.ENTER_FRAME,trackOnEnterFrame);
         this.removeEventListener(Event.RENDER,executeStoppedRender);
      }
      
      public function gotoAndPlayAnimation(param1:*) : *
      {
         stopAnimation();
         _nTotalframes = this.totalFrames;
         if(param1 != null)
         {
            this.gotoAndPlay(param1);
         }
         else
         {
            this.play();
         }
         _bPlaying = true;
         this.addEventListener(Event.ENTER_FRAME,trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,trackProgress,false,0,true);
      }
      
      public function stopAnimation() : *
      {
         this.stop();
         _bPlaying = false;
         this.removeEventListener(Event.ENTER_FRAME,trackOnEnterFrame);
         this.removeEventListener(Event.RENDER,trackProgress);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ArkMc: " + param1);
      }
      
      private function trackOnEnterFrame(param1:Event) : void
      {
         var oEvent:Event = param1;
         try
         {
            stage.invalidate();
            if(_sEndFrameLabel == this.currentLabel)
            {
               stopAnimation();
               _sEndFrameLabel = null;
            }
         }
         catch(e:Error)
         {
            logError("trackOnEnterFrame error [" + name + "]: " + e.message + "\n" + "         ... going to remove event listener and stop animation.");
            removeEventListener(Event.ENTER_FRAME,trackOnEnterFrame);
            stopAnimation();
         }
      }
      
      private function trackProgress(param1:Event) : void
      {
         if(_sCurrentFrameLabel != this.currentLabel)
         {
            _sCurrentFrameLabel = this.currentLabel;
            if(_aEventNameList["frameEvent" + _sCurrentFrameLabel] != null)
            {
               _aEventNameList["frameEvent" + _sCurrentFrameLabel]();
            }
         }
         else if(_aEventList[this.currentFrame] != null)
         {
            _aEventList[this.currentFrame]();
         }
         else if(this.currentFrame >= _nTotalframes)
         {
            _fEndFunction();
         }
      }
      
      public function clearTriggerEventByName(param1:String) : *
      {
         _aEventNameList["frameEvent" + param1] = null;
      }
      
      public function setTriggerEventByName(param1:String, param2:Function) : *
      {
         _aEventNameList["frameEvent" + param1] = param2;
      }
      
      public function stopAnimationAndExecute(param1:*, param2:*) : *
      {
         _fExecuteNowFunction = param2;
         this.gotoAndStop(param1);
         _bPlaying = false;
         this.addEventListener(Event.ENTER_FRAME,trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,executeStoppedRender,false,0,true);
      }
      
      public function playAnimation() : *
      {
         _nTotalframes = this.totalFrames;
         _bPlaying = true;
         this.addEventListener(Event.ENTER_FRAME,trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,trackProgress,false,0,true);
         this.play();
      }
      
      public function gotoAndPlayAnimationBeforeFrame(param1:String, param2:String) : void
      {
         stopAnimation();
         _nTotalframes = this.totalFrames;
         if(param1 != null)
         {
            this.gotoAndPlay(param1);
         }
         else
         {
            this.play();
         }
         _bPlaying = true;
         _sEndFrameLabel = param2;
         this.addEventListener(Event.ENTER_FRAME,trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,trackProgress,false,0,true);
      }
      
      public function removeMe() : *
      {
         try
         {
            log("removeMe: " + this.name);
            this.removeEventListener(Event.ENTER_FRAME,trackOnEnterFrame);
            this.removeEventListener(Event.RENDER,trackProgress);
         }
         catch(e:Error)
         {
            logError("removeMe error");
         }
         delete global[this];
      }
   }
}

