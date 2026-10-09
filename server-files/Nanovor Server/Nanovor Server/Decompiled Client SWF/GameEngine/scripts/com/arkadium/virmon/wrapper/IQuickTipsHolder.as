package com.arkadium.virmon.wrapper
{
   import flash.display.MovieClip;
   
   public interface IQuickTipsHolder
   {
      
      function get visible() : Boolean;
      
      function get QuickTipsStub() : MovieClip;
      
      function set visible(param1:Boolean) : void;
      
      function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void;
   }
}

