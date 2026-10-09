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
         _soundManager = param1;
         _snSound = null;
      }
      
      public function playSoundForced(param1:Number = -1, param2:Number = 0) : void
      {
         if(_bIsPlaying)
         {
            stopSound();
         }
         playSound(param1,param2);
      }
      
      public function attachExternalSound(param1:String, param2:String, param3:int, param4:Number) : void
      {
         if(param2 == null || param2 == "")
         {
            logError("attachExternalSound(): probably going to fail here with url=\'" + param2 + "\'... sLinkageID=" + param1 + "\n" + new Error("STACK TRACE").getStackTrace());
         }
         _sSoundName = param1;
         _nSoundType = param3;
         _nPauseTime = 0;
         _bIsPlaying = false;
         _nLoopNumber = 0;
         _bMute = false;
         _channel = null;
         setVolume(param4);
         _snSound = new Sound();
         _snSound.load(new URLRequest(param2));
         _snSound.addEventListener(Event.COMPLETE,onSoundLoaded);
         _snSound.addEventListener(IOErrorEvent.IO_ERROR,onSoundLoadError);
      }
      
      public function playSound(param1:Number = -1, param2:Number = 0) : void
      {
         if(!_bIsPlaying)
         {
            _nLoopNumber = param2;
            _channel = _snSound.play(_nPauseTime,0);
            if(_channel == null)
            {
               return;
            }
            _channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete,false,0,true);
            setVolume(param1 == -1 ? _nVolume : param1);
            _bIsPlaying = true;
         }
      }
      
      public function getSoundName() : String
      {
         return _sSoundName;
      }
      
      public function getVolume() : Number
      {
         return _nVolume;
      }
      
      private function onSoundLoadError(param1:IOErrorEvent) : void
      {
         _snSound.removeEventListener(Event.COMPLETE,onSoundLoaded);
         _snSound.removeEventListener(IOErrorEvent.IO_ERROR,onSoundLoadError);
         logError("Failed to load external sound from " + param1.target.url);
      }
      
      public function get getSoundType() : int
      {
         return _nSoundType;
      }
      
      public function mute() : void
      {
         _bMute = true;
         _prevVolume = _nVolume;
         setVolume(0);
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         _bIsPlaying = false;
         _nPauseTime = 0;
         --_nLoopNumber;
         if(_nSoundType == 1 || _nLoopNumber > 0)
         {
            _channel.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
            playSound(-1,_nLoopNumber);
         }
         else
         {
            dispatchEvent(new Event(Event.SOUND_COMPLETE));
         }
      }
      
      public function get isMusic() : Boolean
      {
         if(_nSoundType == SoundManagerConst.TYPE_MUSIC)
         {
            return true;
         }
         return false;
      }
      
      public function get isPlaying() : Boolean
      {
         return _bIsPlaying;
      }
      
      public function get channel() : SoundChannel
      {
         return _channel;
      }
      
      public function removeSound() : void
      {
         _soundManager.soundLibrary[_sSoundName + "Start"] = null;
         _soundManager.soundLibrary[_sSoundName + "Stop"] = null;
         if(_channel != null)
         {
            _channel.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
         }
         if(_snSound != null)
         {
            _snSound.removeEventListener(Event.COMPLETE,onSoundLoaded);
            _snSound.removeEventListener(IOErrorEvent.IO_ERROR,onSoundLoadError);
            log("sound removed: " + _snSound);
            _snSound = null;
         }
      }
      
      public function attachSoundInLibrary(param1:String, param2:int, param3:Number = 1, param4:ApplicationDomain = null) : void
      {
         if(param4 == null)
         {
            param4 = ApplicationDomain.currentDomain;
         }
         _sSoundName = param1;
         _nSoundType = param2;
         _nPauseTime = 0;
         _bIsPlaying = false;
         _nLoopNumber = 0;
         _bMute = false;
         _channel = null;
         setVolume(param3);
         log("creating sound instance from linkageID: " + param1);
         _snSound = createSoundInstance(param1,param4);
         _soundManager.soundLibrary[_sSoundName + "Start"] = playSound;
         _soundManager.soundLibrary[_sSoundName + "Stop"] = stopSound;
      }
      
      public function stopSound() : void
      {
         if(_channel != null)
         {
            _channel.stop();
            _bIsPlaying = false;
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
         if(_channel != null)
         {
            return _channel.position / _snSound.length;
         }
         return 0;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> SoundClip: " + param1);
      }
      
      public function unmute() : void
      {
         _bMute = false;
         setVolume(_prevVolume);
      }
      
      private function onSoundLoaded(param1:Event) : void
      {
         _snSound.removeEventListener(Event.COMPLETE,onSoundLoaded);
         _snSound.removeEventListener(IOErrorEvent.IO_ERROR,onSoundLoadError);
         _soundManager.soundLibrary[_sSoundName + "Start"] = playSound;
         _soundManager.soundLibrary[_sSoundName + "Stop"] = stopSound;
      }
      
      public function pauseSound() : void
      {
         _nPauseTime = _channel.position;
         stopSound();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> SoundClip: ** " + param1 + " **");
      }
      
      public function setVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         _nVolume = param1 > 1 ? param1 / 100 : param1;
         if(_channel != null)
         {
            if(_bMute)
            {
               _prevVolume = param1;
               _nVolume = 0;
            }
            _loc2_ = new SoundTransform();
            _loc2_.volume = _nVolume;
            _channel.soundTransform = _loc2_;
         }
      }
   }
}

