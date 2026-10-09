package com.arkadium.virmon.movieplayer
{
   import flash.display.*;
   
   public class TextEffectContainer extends AnimationContainer
   {
      
      public var _smcTextEffectHolder:MovieClip;
      
      public function TextEffectContainer()
      {
         super();
      }
      
      override public function removeMe() : *
      {
         _smcTextEffectHolder = null;
         super.removeMe();
      }
      
      override public function doAction(param1:MovieClip) : *
      {
         _smcTextEffectHolder.startAction();
         super.doAction(param1);
      }
      
      public function setActiveAnimation(param1:*) : *
      {
         _smcTextEffectHolder = param1;
      }
   }
}

