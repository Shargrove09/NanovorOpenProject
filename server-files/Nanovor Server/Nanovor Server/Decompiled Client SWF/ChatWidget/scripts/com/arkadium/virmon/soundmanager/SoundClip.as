package com.arkadium.virmon.soundmanager
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   
   public class SoundClip extends EventDispatcher
   {
      
      private var _bIsPlaying:Boolean;
      
      private var _channel:SoundChannel;
      
      private var _nSoundType:int;
      
      private const _emptySoundName:String = "EmptySound";
      
      private var _prevVolume:Number;
      
      private var _bMute:Boolean;
      
      private var _nLoopNumber:Number;
      
      private var _sSoundName:String;
      
      private var _nVolume:Number;
      
      private var _snSound:Sound;
      
      private var _nPauseTime:Number;
      
      private var _soundManager:ISoundManager;
      
      public function SoundClip(param1:ISoundManager)
      {
         super();
         this._soundManager = param1;
         this._snSound = null;
      }
      
      public function playSoundForced(param1:Number = -1, param2:Number = 0) : void
      {
         if(this._bIsPlaying)
         {
            this.stopSound();
         }
         this.playSound(param1,param2);
      }
      
      public function attachExternalSound(param1:String, param2:String, param3:int, param4:Number) : void
      {
         if(param2 == null || param2 == "")
         {
            this.logError("attachExternalSound(): probably going to fail here with url=\'" + param2 + "\'... sLinkageID=" + param1 + "\n" + new Error("STACK TRACE").getStackTrace());
         }
         this._sSoundName = param1;
         this._nSoundType = param3;
         this._nPauseTime = 0;
         this._bIsPlaying = false;
         this._nLoopNumber = 0;
         this._bMute = false;
         this._channel = null;
         this.setVolume(param4);
         this._snSound = new Sound();
         this._snSound.load(new URLRequest(param2));
         this._snSound.addEventListener(Event.COMPLETE,this.onSoundLoaded);
         this._snSound.addEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadError);
      }
      
      public function playSound(param1:Number = -1, param2:Number = 0) : void
      {
         if(!this._bIsPlaying)
         {
            this._nLoopNumber = param2;
            this._channel = this._snSound.play(this._nPauseTime,0);
            if(this._channel == null)
            {
               return;
            }
            this._channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete,false,0,true);
            this.setVolume(param1 == -1 ? this._nVolume : param1);
            this._bIsPlaying = true;
         }
      }
      
      public function getSoundName() : String
      {
         return this._sSoundName;
      }
      
      public function getVolume() : Number
      {
         return this._nVolume;
      }
      
      private function onSoundLoadError(param1:IOErrorEvent) : void
      {
         this._snSound.removeEventListener(Event.COMPLETE,this.onSoundLoaded);
         this._snSound.removeEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadError);
         this.logError("Failed to load external sound from " + param1.target.url);
      }
      
      public function get getSoundType() : int
      {
         return this._nSoundType;
      }
      
      public function mute() : void
      {
         this._bMute = true;
         this._prevVolume = this._nVolume;
         this.setVolume(0);
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         this._bIsPlaying = false;
         this._nPauseTime = 0;
         --this._nLoopNumber;
         if(this._nSoundType == 1 || this._nLoopNumber > 0)
         {
            this._channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            this.playSound(-1,this._nLoopNumber);
         }
         else
         {
            dispatchEvent(new Event(Event.SOUND_COMPLETE));
         }
      }
      
      public function get isMusic() : Boolean
      {
         if(this._nSoundType == SoundManagerConst.TYPE_MUSIC)
         {
            return true;
         }
         return false;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._bIsPlaying;
      }
      
      public function get channel() : SoundChannel
      {
         return this._channel;
      }
      
      public function removeSound() : void
      {
         this._soundManager.soundLibrary[this._sSoundName + "Start"] = null;
         this._soundManager.soundLibrary[this._sSoundName + "Stop"] = null;
         if(this._channel != null)
         {
            this._channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         if(this._snSound != null)
         {
            this._snSound.removeEventListener(Event.COMPLETE,this.onSoundLoaded);
            this._snSound.removeEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadError);
            this.log("sound removed: " + this._snSound);
            this._snSound = null;
         }
      }
      
      public function attachSoundInLibrary(param1:String, param2:int, param3:Number = 1, param4:ApplicationDomain = null) : void
      {
         if(param4 == null)
         {
            param4 = ApplicationDomain.currentDomain;
         }
         this._sSoundName = param1;
         this._nSoundType = param2;
         this._nPauseTime = 0;
         this._bIsPlaying = false;
         this._nLoopNumber = 0;
         this._bMute = false;
         this._channel = null;
         this.setVolume(param3);
         this.log("creating sound instance from linkageID: " + param1);
         this._snSound = this.createSoundInstance(param1,param4);
         this._soundManager.soundLibrary[this._sSoundName + "Start"] = this.playSound;
         this._soundManager.soundLibrary[this._sSoundName + "Stop"] = this.stopSound;
      }
      
      public function stopSound() : void
      {
         if(this._channel != null)
         {
            this._channel.stop();
            this._bIsPlaying = false;
         }
      }
      
      private function createSoundInstance(param1:String, param2:ApplicationDomain = null) : Sound
      {
         var snd:Sound = null;
         var classReference:Class = null;
         var sLinkageID:String = param1;
         var oAppDomain:ApplicationDomain = param2;
         if(oAppDomain == null)
         {
            oAppDomain = ApplicationDomain.currentDomain;
         }
         try
         {
            classReference = oAppDomain.getDefinition(sLinkageID) as Class;
         }
         catch(error:Error)
         {
            logError("Failed to get reference to library sound: " + sLinkageID);
            classReference = ApplicationDomain.currentDomain.getDefinition(_emptySoundName) as Class;
         }
         snd = new classReference();
         return snd;
      }
      
      public function get position() : Number
      {
         if(this._channel != null)
         {
            return this._channel.position / this._snSound.length;
         }
         return 0;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> SoundClip: " + param1);
      }
      
      public function unmute() : void
      {
         this._bMute = false;
         this.setVolume(this._prevVolume);
      }
      
      private function onSoundLoaded(param1:Event) : void
      {
         this._snSound.removeEventListener(Event.COMPLETE,this.onSoundLoaded);
         this._snSound.removeEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadError);
         this._soundManager.soundLibrary[this._sSoundName + "Start"] = this.playSound;
         this._soundManager.soundLibrary[this._sSoundName + "Stop"] = this.stopSound;
      }
      
      public function pauseSound() : void
      {
         this._nPauseTime = this._channel.position;
         this.stopSound();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> SoundClip: ** " + param1 + " **");
      }
      
      public function setVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         this._nVolume = param1 > 1 ? param1 / 100 : param1;
         if(this._channel != null)
         {
            if(this._bMute)
            {
               this._prevVolume = param1;
               this._nVolume = 0;
            }
            _loc2_ = new SoundTransform();
            _loc2_.volume = this._nVolume;
            this._channel.soundTransform = _loc2_;
         }
      }
   }
}

