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
         this.log(this.name);
         this.onInitialize();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ArkMc: " + param1);
      }
      
      public function clearTriggerEventByNum(param1:Number) : *
      {
         this._aEventList[param1] = undefined;
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
         this._bPlaying = false;
         this.removeEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame);
         this.removeEventListener(Event.RENDER,this.trackProgress);
      }
      
      public function onInitialize() : *
      {
         this.stop();
         this._bPlaying = false;
         this._aEventList = new Array();
         this._aEventNameList = new Array();
         this._nTotalframes = this.totalFrames;
         this._sCurrentFrameLabel = null;
         this._fEndFunction = this.endFunction;
      }
      
      public function setEndFunction(param1:Function) : *
      {
         this._fEndFunction = param1;
      }
      
      public function setTriggerEventByNum(param1:Number, param2:Function) : *
      {
         this._aEventList[param1] = param2;
      }
      
      internal function endFunction() : *
      {
         this.stopAnimation();
      }
      
      private function executeStoppedRender(param1:Event) : void
      {
         if(this._sCurrentFrameLabel != this.currentLabel)
         {
            this._sCurrentFrameLabel = this.currentLabel;
            if(this._aEventNameList["frameEvent" + this._sCurrentFrameLabel] != null)
            {
               this._aEventNameList["frameEvent" + this._sCurrentFrameLabel]();
            }
         }
         else if(this._aEventList[this.currentFrame] != null)
         {
            this._aEventList[this.currentFrame]();
         }
         else if(this.currentFrame >= this._nTotalframes)
         {
            this._fEndFunction();
         }
         if(this._fExecuteNowFunction != null)
         {
            this._fExecuteNowFunction();
         }
         this.removeEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame);
         this.removeEventListener(Event.RENDER,this.executeStoppedRender);
      }
      
      public function gotoAndPlayAnimation(param1:*) : *
      {
         this.stopAnimation();
         this._nTotalframes = this.totalFrames;
         if(param1 != null)
         {
            this.gotoAndPlay(param1);
         }
         else
         {
            this.play();
         }
         this._bPlaying = true;
         this.addEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,this.trackProgress,false,0,true);
      }
      
      public function stopAnimation() : *
      {
         this.stop();
         this._bPlaying = false;
         this.removeEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame);
         this.removeEventListener(Event.RENDER,this.trackProgress);
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
            if(this._sEndFrameLabel == this.currentLabel)
            {
               this.stopAnimation();
               this._sEndFrameLabel = null;
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
         if(this._sCurrentFrameLabel != this.currentLabel)
         {
            this._sCurrentFrameLabel = this.currentLabel;
            if(this._aEventNameList["frameEvent" + this._sCurrentFrameLabel] != null)
            {
               this._aEventNameList["frameEvent" + this._sCurrentFrameLabel]();
            }
         }
         else if(this._aEventList[this.currentFrame] != null)
         {
            this._aEventList[this.currentFrame]();
         }
         else if(this.currentFrame >= this._nTotalframes)
         {
            this._fEndFunction();
         }
      }
      
      public function clearTriggerEventByName(param1:String) : *
      {
         this._aEventNameList["frameEvent" + param1] = null;
      }
      
      public function setTriggerEventByName(param1:String, param2:Function) : *
      {
         this._aEventNameList["frameEvent" + param1] = param2;
      }
      
      public function stopAnimationAndExecute(param1:*, param2:*) : *
      {
         this._fExecuteNowFunction = param2;
         this.gotoAndStop(param1);
         this._bPlaying = false;
         this.addEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,this.executeStoppedRender,false,0,true);
      }
      
      public function playAnimation() : *
      {
         this._nTotalframes = this.totalFrames;
         this._bPlaying = true;
         this.addEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,this.trackProgress,false,0,true);
         this.play();
      }
      
      public function gotoAndPlayAnimationBeforeFrame(param1:String, param2:String) : void
      {
         this.stopAnimation();
         this._nTotalframes = this.totalFrames;
         if(param1 != null)
         {
            this.gotoAndPlay(param1);
         }
         else
         {
            this.play();
         }
         this._bPlaying = true;
         this._sEndFrameLabel = param2;
         this.addEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame,false,0,true);
         this.addEventListener(Event.RENDER,this.trackProgress,false,0,true);
      }
      
      public function removeMe() : *
      {
         try
         {
            this.log("removeMe: " + this.name);
            this.removeEventListener(Event.ENTER_FRAME,this.trackOnEnterFrame);
            this.removeEventListener(Event.RENDER,this.trackProgress);
         }
         catch(e:Error)
         {
            logError("removeMe error");
         }
         delete global[this];
      }
   }
}

