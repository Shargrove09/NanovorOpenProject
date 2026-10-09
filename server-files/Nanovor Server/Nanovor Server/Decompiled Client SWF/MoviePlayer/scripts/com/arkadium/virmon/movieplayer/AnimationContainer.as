package com.arkadium.virmon.movieplayer
{
   import com.arkadium.virmon.shared.data.Managers;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.Event;
   import flash.media.SoundTransform;
   
   public dynamic class AnimationContainer extends MovieClip
   {
      
      protected var _aEventNameList:Array;
      
      public var _bPlaying:Boolean;
      
      private var _soundData:AnimationSoundData;
      
      protected var _aEventList:Array;
      
      public var _bTrackMe:Boolean = false;
      
      protected var _nFrameOffestCounter:Number;
      
      protected var _nFramesPlayed:Number;
      
      public var _mcActiveAnimation:MovieClip;
      
      protected var _fEndFunction:Function;
      
      private var _useSoundData:Boolean;
      
      protected var _nTotalframes:Number;
      
      protected var _mcParent:MovieClip;
      
      public function AnimationContainer()
      {
         super();
      }
      
      public function stopAnimation(param1:* = null) : *
      {
         initNewActiveAnimation();
         _nFrameOffestCounter = 0;
         if(param1 != null)
         {
            if(param1 != undefined)
            {
               _mcActiveAnimation.gotoAndStop(Number(param1));
            }
         }
         _bPlaying = false;
         removeEventListener(Event.ENTER_FRAME,trackOnEnterFrame);
      }
      
      public function clearTriggerEventByNum(param1:Number) : *
      {
         _aEventList[param1] = null;
      }
      
      public function onInitialize(param1:*) : *
      {
         _bPlaying = false;
         _aEventList = new Array();
         _aEventNameList = new Array();
         _mcParent = param1;
         _fEndFunction = endFunction;
      }
      
      public function setEndFunction(param1:Function) : *
      {
         _fEndFunction = param1;
      }
      
      internal function endFunction(param1:AnimationContainer) : *
      {
         stopAnimation();
      }
      
      public function initNewActiveAnimation() : *
      {
         _nFramesPlayed = 0;
         _nTotalframes = _mcActiveAnimation.totalFrames;
      }
      
      public function clearEventsList() : *
      {
         _aEventList = new Array();
      }
      
      protected function trackOnEnterFrame(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(++_nFrameOffestCounter % 2 == 0)
         {
            _loc2_ = _mcActiveAnimation.currentFrame;
            _loc3_ = _loc2_ + 1;
            _loc4_ = _mcActiveAnimation.currentFrame - 1;
            if(_aEventList[_loc2_] != null)
            {
               _aEventList[_loc2_](this);
               if(_loc3_ >= _nTotalframes)
               {
                  _fEndFunction(this);
               }
               else
               {
                  playNextFrame(_loc3_);
               }
            }
            else if(_loc3_ >= _nTotalframes)
            {
               _fEndFunction(this);
            }
            else
            {
               playNextFrame(_loc3_);
            }
         }
      }
      
      public function doAction(param1:MovieClip) : *
      {
         var _loc2_:SoundTransform = null;
         var _loc3_:* = undefined;
         _useSoundData = param1.hasOwnProperty("_animationSoundData");
         if(_useSoundData)
         {
            _soundData = AnimationSoundData(param1["_animationSoundData"]);
         }
         if(_mcActiveAnimation != null)
         {
            this.stopAnimation();
            removeChild(_mcActiveAnimation);
         }
         _mcActiveAnimation = param1;
         addChildAt(_mcActiveAnimation,0);
         initNewActiveAnimation();
         playAnimation(1);
         if(_mcParent._bSoundOn == false)
         {
            _loc2_ = new SoundTransform();
            _loc2_.volume = 0;
            _mcActiveAnimation.soundTransform = _loc2_;
         }
         else
         {
            _loc2_ = new SoundTransform();
            _loc3_ = Managers.soundManager.getSoundGlobalVolume();
            if(_loc3_ == null)
            {
               _loc3_ = 0;
            }
            _loc2_.volume = _loc3_;
            _mcActiveAnimation.soundTransform = _loc2_;
         }
      }
      
      public function setTriggerEventByNum(param1:Number, param2:Function) : *
      {
         _aEventList[param1] = param2;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> AnimationContainer: ** " + param1 + " **");
      }
      
      public function playNextFrame(param1:*) : *
      {
         if(param1 >= _nTotalframes)
         {
            param1 = 1;
         }
         ++_nFramesPlayed;
         if(_mcActiveAnimation != null)
         {
            _mcActiveAnimation.gotoAndStop(param1);
         }
         if(_useSoundData)
         {
            _soundData.TriggerSoundsOnFrame(param1);
         }
      }
      
      public function playAnimation(param1:* = null) : *
      {
         initNewActiveAnimation();
         _nFrameOffestCounter = 0;
         if(param1 != null)
         {
            if(param1 != undefined)
            {
               _mcActiveAnimation.gotoAndStop(Number(param1));
               if(_useSoundData)
               {
                  _soundData.TriggerSoundsOnFrame(param1);
               }
            }
         }
         _bPlaying = true;
         if(!this.hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,trackOnEnterFrame,false,0,true);
         }
      }
      
      public function removeMe() : *
      {
         removeEventListener(Event.ENTER_FRAME,trackOnEnterFrame);
         try
         {
            this.stopAnimation();
            removeChild(_mcActiveAnimation);
         }
         catch(e:Error)
         {
            trace("nullArray is null");
         }
         _mcActiveAnimation = null;
         delete global[this];
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> AnimationContainer: " + param1);
      }
   }
}

