package com.arkadium.virmon.soundmanager
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.StoredSetting;
   import com.arkadium.virmon.common.StoredSettingManager;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   
   public dynamic class SoundManager implements ISoundManager
   {
      
      private static var _soundAppDomain:ApplicationDomain;
      
      private static const DEFAULT_MUSIC_VOLUME:Number = 15;
      
      private static const DEFAULT_FX_VOLUME:Number = 100;
      
      private static const MAX_MUSIC_VOLUME:Number = 100;
      
      private static const MAX_FX_VOLUME:Number = 100;
      
      private static const MAX_FX_SOUNDS:int = 28;
      
      private static const MAX_MUSIC_SOUNDS:int = 4;
      
      private var _soundLibrary:Dictionary;
      
      private var _uiSoundLoader:Loader;
      
      private var _cmFXManager:ChannelManager;
      
      private var _cmMusicManager:ChannelManager;
      
      public function SoundManager()
      {
         super();
         _cmMusicManager = new ChannelManager(this,SoundManagerConst.TYPE_MUSIC,SoundManager.MAX_MUSIC_SOUNDS);
         _cmFXManager = new ChannelManager(this,SoundManagerConst.TYPE_FX,SoundManager.MAX_FX_SOUNDS);
         _soundLibrary = new Dictionary();
         onInitialize();
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> SoundManager: " + param1);
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error(">> SoundManager: ** " + param1 + " **");
      }
      
      public static function get SoundAppDomain() : ApplicationDomain
      {
         return _soundAppDomain;
      }
      
      public function animationFxHandler(param1:SoundManagerEvent) : void
      {
         var _loc2_:SoundClip = null;
         if(param1.inLibrary)
         {
            if(param1.forcePlay)
            {
               attachSoundInLibrary(param1.soundName,SoundManagerConst.TYPE_FX,100,param1.applicationDomain).playSoundForced();
            }
            else
            {
               attachSoundInLibrary(param1.soundName,SoundManagerConst.TYPE_FX,100,param1.applicationDomain).playSound();
            }
         }
         else
         {
            _loc2_ = attachExternalSound("fxAnim",param1.soundName,SoundManagerConst.TYPE_FX,100);
            _loc2_.playSound();
         }
      }
      
      public function attachExternalSound(param1:String, param2:String, param3:Number, param4:Number = 100) : SoundClip
      {
         var _loc5_:SoundClip = null;
         switch(param3)
         {
            case SoundManagerConst.TYPE_MUSIC:
               _loc5_ = _cmMusicManager.attachExternalSound(param1,param2,param4);
               break;
            case SoundManagerConst.TYPE_FX:
               _loc5_ = _cmFXManager.attachExternalSound(param1,param2,param4);
         }
         return _loc5_;
      }
      
      private function uiSoundsLoadErrorHandler(param1:IOErrorEvent) : void
      {
         _uiSoundLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,uiSoundsLoadCompleteHandler);
         _uiSoundLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,uiSoundsLoadErrorHandler);
         logError("UI Sounds movie failed to load: " + param1);
         logError("No UI sounds will play.");
      }
      
      public function changeSoundVolume(param1:Number, param2:String) : void
      {
         var _loc3_:uint = 0;
         log("changeSoundVolume() - volume: " + param1.toString() + " type: " + param2);
         switch(param2)
         {
            case "music":
               _loc3_ = uint(SoundManagerConst.TYPE_MUSIC);
               break;
            case "effects":
               _loc3_ = uint(SoundManagerConst.TYPE_FX);
               break;
            default:
               log("changeSoundVolume() - Unknown sound type: " + param2.toString());
               return;
         }
         setGlobalVolumeByType(_loc3_,param1);
      }
      
      public function setClipVolume(param1:String, param2:Number) : Boolean
      {
         var _loc3_:SoundClip = _cmMusicManager.getSoundByName(param1);
         if(_loc3_ == null)
         {
            _loc3_ = _cmFXManager.getSoundByName(param1);
         }
         if(_loc3_ == null)
         {
            return false;
         }
         _loc3_.setVolume(param2);
         return true;
      }
      
      public function get soundLibrary() : Dictionary
      {
         return _soundLibrary;
      }
      
      private function uiSoundsLoadCompleteHandler(param1:Event) : void
      {
         _uiSoundLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,uiSoundsLoadCompleteHandler);
         _uiSoundLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,uiSoundsLoadErrorHandler);
         log("UI Sound resource loaded.");
      }
      
      private function onInitialize() : void
      {
         var _loc1_:Number = StoredSettingManager.getInstance().getSettingOrSetDefault(StoredSetting.GAMEOPTIONS_MUSIC,int(DEFAULT_MUSIC_VOLUME));
         var _loc2_:Number = StoredSettingManager.getInstance().getSettingOrSetDefault(StoredSetting.GAMEOPTIONS_SOUND,int(DEFAULT_FX_VOLUME));
         _cmMusicManager.setMaxVolume(SoundManager.MAX_MUSIC_VOLUME);
         _cmMusicManager.setGlobalVolume(_loc1_);
         _cmFXManager.setMaxVolume(SoundManager.MAX_FX_VOLUME);
         _cmFXManager.setGlobalVolume(_loc2_);
         EventManager.getInstance().addEventListener(SoundManagerEvent.ANIMATION_FX,animationFxHandler);
         _soundAppDomain = new ApplicationDomain();
         SoundManagerConst.soundApplicationDomain = _soundAppDomain;
         var _loc3_:LoaderContext = new LoaderContext(false,_soundAppDomain);
         _uiSoundLoader = new Loader();
         _uiSoundLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,uiSoundsLoadCompleteHandler);
         _uiSoundLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,uiSoundsLoadErrorHandler);
         var _loc4_:String = "Audio/UISounds.swf";
         var _loc5_:URLRequest = new URLRequest(_loc4_);
         _uiSoundLoader.load(_loc5_,_loc3_);
      }
      
      public function getMusicGlobalVolume() : Number
      {
         return _cmMusicManager.getGlobalVolume();
      }
      
      public function getGlobalVolume(param1:Number) : Number
      {
         switch(param1)
         {
            case SoundManagerConst.TYPE_MUSIC:
               return _cmMusicManager.getGlobalVolume();
            case SoundManagerConst.TYPE_FX:
               return _cmFXManager.getGlobalVolume();
            default:
               return -1;
         }
      }
      
      public function setMaxVolume(param1:String, param2:Number) : void
      {
         switch(param1)
         {
            case SoundManagerConst.TYPE_MUSIC:
               _cmMusicManager.setMaxVolume(param2);
               break;
            case SoundManagerConst.TYPE_FX:
               _cmFXManager.setMaxVolume(param2);
         }
      }
      
      public function getSoundGlobalVolume() : Number
      {
         return _cmFXManager.getGlobalVolume();
      }
      
      public function stopSound(param1:String) : void
      {
         _cmMusicManager.stopSound(param1);
         _cmFXManager.stopSound(param1);
      }
      
      public function setGlobalVolumeByType(param1:Number, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:String = "setGlobalVolumeByType: ";
         switch(param1)
         {
            case SoundManagerConst.TYPE_MUSIC:
               _loc3_ += "TYPE_MUSIC (nVolume=" + param2 + ")";
               _cmMusicManager.setGlobalVolume(param2);
               _loc4_ = StoredSettingManager.getInstance().getSettingOrSetDefault(StoredSetting.GAMEOPTIONS_MUSIC,int(_cmMusicManager.getGlobalVolume()));
               break;
            case SoundManagerConst.TYPE_FX:
               _loc3_ += "TYPE_FX (nVolume=" + param2 + ")";
               _cmFXManager.setGlobalVolume(param2);
               _loc5_ = StoredSettingManager.getInstance().getSettingOrSetDefault(StoredSetting.GAMEOPTIONS_SOUND,int(_cmFXManager.getGlobalVolume()));
         }
         log(_loc3_);
      }
      
      public function removeSound(param1:String) : void
      {
         log("<<SoundManager>>::removeSound --> sLinkageID: " + param1);
         _cmMusicManager.removeSound(param1);
         _cmFXManager.removeSound(param1);
         Utils.gc();
      }
      
      public function attachSoundInLibrary(param1:String, param2:Number, param3:Number = 1, param4:ApplicationDomain = null) : SoundClip
      {
         var _loc5_:SoundClip = null;
         log("<<Soundmanager>>::attachSound in Library --> sLinkageID: " + param1);
         if(param4 == null)
         {
            param4 = ApplicationDomain.currentDomain;
         }
         switch(param2)
         {
            case SoundManagerConst.TYPE_MUSIC:
               _loc5_ = _cmMusicManager.attachSoundInLibrary(param1,param3,param4);
               break;
            case SoundManagerConst.TYPE_FX:
               _loc5_ = _cmFXManager.attachSoundInLibrary(param1,param3,param4);
         }
         return _loc5_;
      }
      
      public function pauseSound(param1:String) : Boolean
      {
         var _loc2_:SoundClip = _cmMusicManager.getSoundByName(param1);
         if(_loc2_ == null)
         {
            _loc2_ = _cmFXManager.getSoundByName(param1);
         }
         if(_loc2_ == null)
         {
            return false;
         }
         _loc2_.pauseSound();
         return true;
      }
      
      public function playSound(param1:String, param2:Number = 0) : Boolean
      {
         var _loc3_:SoundClip = _cmMusicManager.getSoundByName(param1);
         if(_loc3_ == null)
         {
            _loc3_ = _cmFXManager.getSoundByName(param1);
         }
         if(_loc3_ == null)
         {
            return false;
         }
         _loc3_.playSound(-1,param2);
         return true;
      }
   }
}

