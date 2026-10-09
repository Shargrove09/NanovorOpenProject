package com.arkadium.virmon.soundmanager
{
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   
   public dynamic class SoundManagerEvent extends Event
   {
      
      public static const ANIMATION_FX:String = "onAnimationFXEvent";
      
      public var applicationDomain:ApplicationDomain;
      
      public var inLibrary:Boolean;
      
      public var soundName:String;
      
      public var forcePlay:Boolean;
      
      public function SoundManagerEvent(param1:String, param2:String, param3:Boolean, param4:ApplicationDomain = null, param5:Boolean = false)
      {
         super(param1,true,true);
         this.soundName = param2;
         this.inLibrary = param3;
         this.applicationDomain = param4;
         this.forcePlay = param5;
         if(this.applicationDomain == null)
         {
            this.applicationDomain = ApplicationDomain.currentDomain;
         }
      }
      
      override public function toString() : String
      {
         return "[Event SoundManagerEvent]";
      }
      
      override public function clone() : Event
      {
         return new SoundManagerEvent(this.type,this.soundName,this.inLibrary,this.applicationDomain,this.forcePlay);
      }
   }
}

