package com.arkadium.virmon.movieplayer
{
   public class AnimationData
   {
      
      internal var _sVirmonType:String;
      
      internal var _sLocationID:String;
      
      internal var _xAnimationData:XML;
      
      internal var _sAnimationTag:String;
      
      internal var _sAnimationID:String;
      
      public function AnimationData(param1:*, param2:*, param3:*, param4:*)
      {
         super();
         _sLocationID = param1;
         _sVirmonType = param2;
         _sAnimationID = param3;
         _sAnimationTag = param4;
      }
   }
}

