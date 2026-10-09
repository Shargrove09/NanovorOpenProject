package com.arkadium.virmon.soundmanager
{
   import flash.system.ApplicationDomain;
   
   public class SoundManagerConst
   {
      
      private static var _soundApplicationDomain:ApplicationDomain;
      
      public static const TYPE_FX:int = 0;
      
      public static const TYPE_MUSIC:int = 1;
      
      public static const TYPE_VOICE:int = 2;
      
      public function SoundManagerConst()
      {
         super();
      }
      
      public static function set soundApplicationDomain(param1:ApplicationDomain) : void
      {
         _soundApplicationDomain = param1;
      }
      
      public static function get soundApplicationDomain() : ApplicationDomain
      {
         return _soundApplicationDomain;
      }
   }
}

