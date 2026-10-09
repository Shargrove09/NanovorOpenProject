package com.arkadium.virmon.musicmanager
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.soundmanager.SoundClip;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class MusicManager implements IMusicManager
   {
      
      private var _currentTrack:SoundClip;
      
      public function MusicManager()
      {
         super();
      }
      
      private function fadeInTrackComplete(param1:SoundClip) : void
      {
         Managers.soundManager.setClipVolume(param1.getSoundName(),Managers.soundManager.getMusicGlobalVolume());
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> MusicManager: " + param1);
      }
      
      private function fadeInTrack(param1:SoundClip, param2:int, param3:int) : void
      {
         _currentTrack = param1;
         if(Managers.soundManager.getMusicGlobalVolume() <= 0)
         {
            param1.playSound(0,999);
            return;
         }
         _currentTrack.playSound(2,999);
         Tweener.addTween(_currentTrack.channel,{
            "_sound_volume":Managers.soundManager.getMusicGlobalVolume() / 100,
            "delay":param3 / 1000,
            "time":param2 / 1000,
            "transition":"easeInOutSine",
            "onComplete":fadeInTrackComplete,
            "onCompleteParams":[param1]
         });
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** MusicManager: " + param1);
      }
      
      public function FadeOutFadeInToTrack(param1:IAssetURL, param2:int = 1600, param3:int = 1000) : void
      {
         var _loc4_:String = _currentTrack == null ? "NULL" : _currentTrack.getSoundName();
         if(param1.assetURLType == AssetURLType.NOT_FOUND)
         {
            logError("FadeOutFadeInToTrack(): trackAssetURL.assetUrlType == NOT_FOUND; will not load music track.");
            return;
         }
         if(_loc4_ == param1.url)
         {
            log("FadeOutFadeInToTrack(): Same track as current; will not fade in same track.");
            return;
         }
         log("FadeOutFadeInToTrack(): Fading out " + _loc4_ + ", fading in: " + param1.url);
         if(param3 > param2)
         {
            param3 = param2;
         }
         var _loc5_:SoundClip = Managers.soundManager.attachExternalSound(param1.url,param1.url,SoundManagerConst.TYPE_MUSIC,0);
         if(_currentTrack != null)
         {
            fadeOutTrack(_currentTrack,param2);
         }
         fadeInTrack(_loc5_,param2,param3);
      }
      
      private function fadeOutTrackComplete(param1:SoundClip) : void
      {
         Managers.soundManager.stopSound(param1.getSoundName());
      }
      
      private function fadeOutTrack(param1:SoundClip, param2:int) : void
      {
         if(Managers.soundManager.getMusicGlobalVolume() <= 0)
         {
            param1.stopSound();
            return;
         }
         Tweener.removeTweens(param1.channel);
         Tweener.addTween(param1.channel,{
            "_sound_volume":0,
            "time":param2 / 1000,
            "transition":"easeInOutSine",
            "onComplete":fadeOutTrackComplete,
            "onCompleteParams":[param1]
         });
      }
      
      public function PlayTrack(param1:IAssetURL) : void
      {
         log("PlayTrack(): trackAssetURL=" + param1);
         _currentTrack = Managers.soundManager.attachExternalSound(param1.url,param1.url,SoundManagerConst.TYPE_MUSIC,0);
         _currentTrack.playSound(Managers.soundManager.getMusicGlobalVolume(),999);
      }
   }
}

