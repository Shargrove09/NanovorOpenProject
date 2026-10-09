package com.arkadium.virmon.movieplayer
{
   import com.arkadium.virmon.framework.asset.enum.AssetURLType;
   import com.arkadium.virmon.framework.asset.retriever.IAssetURL;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class AnimationSoundData
   {
      
      private var _masterId:int;
      
      private var _soundPaths:Array;
      
      private var _soundStartFrames:Array;
      
      public function AnimationSoundData(param1:int = 0)
      {
         super();
         _masterId = param1;
         _soundPaths = new Array();
         _soundStartFrames = new Array();
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error(">> AnimationSoundData: ** " + param1 + " **");
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> AnimationSoundData: " + param1);
      }
      
      public static function FromXml(param1:ICharacterAssetTypeCache, param2:XML, param3:int = 0) : AnimationSoundData
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:XML = null;
         var _loc4_:AnimationSoundData = new AnimationSoundData(param3);
         var _loc5_:XMLList = param2.audio.instance;
         for each(_loc8_ in _loc5_)
         {
            if(_loc8_.@asset != "" && _loc8_.@startframe != "")
            {
               if(!isNaN(parseInt(_loc8_.@startframe)))
               {
                  _loc6_ = parseInt(_loc8_.@startframe) + 1;
                  _loc7_ = _loc8_.@asset;
                  if(_loc7_.substr(_loc7_.length - 4) == ".mp3")
                  {
                     _loc7_ = _loc7_.substr(0,_loc7_.length - 4);
                  }
                  if(!_loc4_.AddSound(param1,_loc7_,_loc6_))
                  {
                     return null;
                  }
               }
               else
               {
                  logError("Sound instance in animation file had a startframe of NaN!");
                  logError("Sound instance data: " + _loc8_);
               }
            }
            else
            {
               logError("Sound instance in animation file had empty value!");
               logError("Sound instance data: " + _loc8_);
            }
         }
         return _loc4_;
      }
      
      public function TriggerSoundsOnFrame(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         while(_loc4_ < _soundStartFrames.length)
         {
            _loc2_ = int(_soundStartFrames[_loc4_]);
            _loc3_ = String(_soundPaths[_loc4_]);
            if(_loc2_ == param1)
            {
               Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,_loc3_,false));
            }
            _loc4_++;
         }
      }
      
      public function AddSound(param1:ICharacterAssetTypeCache, param2:String, param3:int) : Boolean
      {
         var _loc4_:IAssetURL = param1.getCharacterAudioURL(_masterId,param2);
         if(_loc4_ == AssetURLType.NOT_FOUND)
         {
            logError("AddSound(): url not found for _masterId=" + _masterId + ", inSoundAssetName=" + param2);
            return false;
         }
         _soundPaths.push(_loc4_.url);
         _soundStartFrames.push(param3);
         return true;
      }
   }
}

