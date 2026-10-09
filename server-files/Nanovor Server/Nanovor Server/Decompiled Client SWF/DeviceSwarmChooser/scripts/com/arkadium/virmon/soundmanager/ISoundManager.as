package com.arkadium.virmon.soundmanager
{
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   
   public interface ISoundManager
   {
      
      function pauseSound(param1:String) : Boolean;
      
      function attachSoundInLibrary(param1:String, param2:Number, param3:Number = 1, param4:ApplicationDomain = null) : SoundClip;
      
      function removeSound(param1:String) : void;
      
      function get soundLibrary() : Dictionary;
      
      function stopSound(param1:String) : void;
      
      function getMusicGlobalVolume() : Number;
      
      function setGlobalVolumeByType(param1:Number, param2:Number) : void;
      
      function setClipVolume(param1:String, param2:Number) : Boolean;
      
      function animationFxHandler(param1:SoundManagerEvent) : void;
      
      function getSoundGlobalVolume() : Number;
      
      function changeSoundVolume(param1:Number, param2:String) : void;
      
      function getGlobalVolume(param1:Number) : Number;
      
      function playSound(param1:String, param2:Number = 0) : Boolean;
      
      function setMaxVolume(param1:String, param2:Number) : void;
      
      function attachExternalSound(param1:String, param2:String, param3:Number, param4:Number = 100) : SoundClip;
   }
}

