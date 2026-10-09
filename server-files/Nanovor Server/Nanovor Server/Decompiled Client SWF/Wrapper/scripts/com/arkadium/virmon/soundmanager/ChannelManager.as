package com.arkadium.virmon.soundmanager
{
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import com.smithandtinker.utils.SoundList;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   internal class ChannelManager
   {
      
      private var _iSoundType:int;
      
      private var _nGlobalVolume:Number;
      
      private var _nMaxVolume:Number;
      
      private var _slSoundList:SoundList;
      
      private var _soundManager:ISoundManager;
      
      public function ChannelManager(param1:ISoundManager, param2:int, param3:int)
      {
         super();
         _soundManager = param1;
         _iSoundType = param2;
         _slSoundList = new SoundList(param3);
         _nMaxVolume = 1;
         _nGlobalVolume = 1;
         onInitialize();
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error(">> ChannelManager: ** " + param1 + " **");
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> ChannelManager: " + param1);
      }
      
      public function getSoundByName(param1:String) : SoundClip
      {
         return _slSoundList.getSoundByName(param1);
      }
      
      public function convertVolumeValue(param1:Number) : Number
      {
         var _loc2_:Number = param1 >= 1 ? param1 / 100 : param1;
         _loc2_ = _loc2_ < 0 ? _nGlobalVolume : _loc2_;
         _loc2_ = _loc2_ > 1 ? 1 : _loc2_;
         var _loc3_:Number = _loc2_ * 100 / 1;
         trace("SOUND VOLUME: " + _loc3_ + "%");
         _loc2_ = _loc2_ >= _nGlobalVolume ? _nGlobalVolume : _loc3_ * _nMaxVolume / 100;
         trace("SOUND VOLUME: " + _loc2_);
         return _loc2_;
      }
      
      public function setVolumeByName(param1:String, param2:Number) : void
      {
         var _loc3_:SoundClip = _slSoundList.getSoundByName(param1);
         var _loc4_:Number = param2 > 1 ? param2 / 100 : param2;
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         _loc4_ = _loc4_ > 1 ? 1 : _loc4_;
         var _loc5_:Number = _loc4_ * 100 / 1;
         _loc4_ = _loc4_ > _nGlobalVolume ? _nGlobalVolume : _loc5_ * _nMaxVolume / 100;
         _loc3_.setVolume(_loc4_);
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         var _loc2_:SoundClip = SoundClip(param1.currentTarget);
         _slSoundList.removeSound(_loc2_);
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
      }
      
      public function getSoundInstance(param1:String) : SoundClip
      {
         var _loc2_:SoundClip = _slSoundList.getSoundByName(param1);
         if(_loc2_ == null)
         {
            _loc2_ = attachSoundInLibrary(param1,_nGlobalVolume);
         }
         return _loc2_;
      }
      
      public function onInitialize() : void
      {
      }
      
      public function getGlobalVolume() : Number
      {
         return _nGlobalVolume * 100;
      }
      
      public function attachSoundInLibrary(param1:String, param2:Number = -1, param3:ApplicationDomain = null) : SoundClip
      {
         if(param3 == null)
         {
            param3 = ApplicationDomain.currentDomain;
         }
         var _loc4_:Number = convertVolumeValue(param2);
         var _loc5_:SoundClip = _slSoundList.getSoundByName(param1);
         if(_loc5_ != null)
         {
            _loc5_.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
            return _loc5_;
         }
         var _loc6_:SoundClip = new SoundClip(_soundManager);
         _loc6_.attachSoundInLibrary(param1,_iSoundType,_loc4_,param3);
         _slSoundList.addSoundClip(_loc6_);
         _loc6_.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
         return _loc6_;
      }
      
      public function pauseSoundByName(param1:String) : void
      {
         var _loc2_:SoundClip = _slSoundList.getSoundByName(param1);
         if(_loc2_ != null)
         {
            _loc2_.pauseSound();
         }
      }
      
      public function setMaxVolume(param1:Number) : void
      {
         _nMaxVolume = param1 > 1 ? param1 / 100 : param1;
         _nMaxVolume = _nMaxVolume < 0 ? 0 : _nMaxVolume;
         _nMaxVolume = _nMaxVolume > 1 ? 1 : _nMaxVolume;
         _nGlobalVolume = _nGlobalVolume > _nMaxVolume ? _nMaxVolume : _nGlobalVolume;
      }
      
      public function playSoundByName(param1:String, param2:Number = -1, param3:Number = 0) : void
      {
         var _loc4_:SoundClip = _slSoundList.getSoundByName(param1);
         var _loc5_:Number = convertVolumeValue(param2);
         if(_loc4_ == null)
         {
            _loc4_ = attachSoundInLibrary(param1,_loc5_);
         }
         _loc4_.playSound(_nGlobalVolume,param3);
      }
      
      public function setGlobalVolume(param1:Number) : void
      {
         var _loc2_:String = "setGlobalVolume() called with nVolume = " + param1;
         var _loc3_:Number = _nGlobalVolume;
         var _loc4_:Number = param1 / 100;
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         _loc4_ = _loc4_ > 1 ? 1 : _loc4_;
         var _loc5_:Number = _loc4_ * 100 / 1;
         _nGlobalVolume = _loc5_ * _nMaxVolume / 100;
         _loc2_ += "\n ... _nGlobalVolume = " + _nGlobalVolume;
         _loc2_ += "\n ... going to loop through _slSoundList, .totalSounds() = " + _slSoundList.totalSounds();
         var _loc6_:int = 0;
         while(_loc6_ < _slSoundList.totalSounds())
         {
            if(_slSoundList.getSound(_loc6_).getVolume() == _loc3_)
            {
               _slSoundList.getSound(_loc6_).setVolume(_nGlobalVolume);
               _loc2_ += "\n     ... [" + _loc6_ + "] set volume on (\'" + _slSoundList.getSound(_loc6_).getSoundName() + "\' to _nGlobalVolume (" + _nGlobalVolume + ")";
            }
            else
            {
               _loc4_ = _slSoundList.getSound(_loc6_).getVolume();
               _loc5_ = _loc4_ * 100 / 1;
               _loc4_ = _loc5_ * _nGlobalVolume / 100;
               _slSoundList.getSound(_loc6_).setVolume(_loc4_);
               _loc2_ += "\n     ... [" + _loc6_ + "] set volume on (\'" + _slSoundList.getSound(_loc6_).getSoundName() + "\' to volume based on percentage (" + _loc4_ + ")";
            }
            _loc6_++;
         }
         log(_loc2_);
      }
      
      public function getMaxVolume() : Number
      {
         return _nMaxVolume * 100;
      }
      
      public function removeSound(param1:String) : void
      {
         var _loc2_:SoundClip = _slSoundList.getSoundByName(param1);
         if(_loc2_ != null)
         {
            _slSoundList.removeSound(_loc2_);
         }
         Utils.gc();
      }
      
      public function stopSound(param1:String) : void
      {
         var _loc2_:SoundClip = _slSoundList.getSoundByName(param1);
         if(_loc2_ != null)
         {
            _slSoundList.removeSound(_loc2_);
            _loc2_.stopSound();
            _loc2_.removeSound();
         }
      }
      
      public function pauseSound(param1:String) : void
      {
         var _loc2_:SoundClip = _slSoundList.getCurrentSound();
         if(_loc2_ != null)
         {
            _loc2_.pauseSound();
         }
      }
      
      public function playSound(param1:Number = -1, param2:Number = 0) : void
      {
         var _loc3_:SoundClip = _slSoundList.getNextSound();
         var _loc4_:Number = convertVolumeValue(param1);
         if(_loc3_ != null)
         {
            _loc3_.playSound(_loc4_,param2);
         }
      }
      
      public function attachExternalSound(param1:String, param2:String, param3:Number = -1) : SoundClip
      {
         var _loc4_:Number = convertVolumeValue(param3);
         log("looking for sound in currently attached sounds: " + param1);
         var _loc5_:SoundClip = _slSoundList.getSoundByName(param1);
         if(_loc5_ != null)
         {
            _loc5_.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
            return _loc5_;
         }
         log("not found - attaching new sound.");
         var _loc6_:SoundClip = new SoundClip(_soundManager);
         _loc6_.attachExternalSound(param1,param2,_iSoundType,_loc4_);
         log("sound attached.");
         _slSoundList.addSoundClip(_loc6_);
         log("sound added to list.");
         _loc6_.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
         return _loc6_;
      }
   }
}

class SingletonCreator
{
   
   public function SingletonCreator()
   {
      super();
   }
}
