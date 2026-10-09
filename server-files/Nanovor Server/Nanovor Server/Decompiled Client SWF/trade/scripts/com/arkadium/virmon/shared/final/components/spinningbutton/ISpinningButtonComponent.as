package com.arkadium.virmon.shared.final.components.spinningbutton
{
   import flash.display.DisplayObject;
   
   public interface ISpinningButtonComponent
   {
      
      function set icon(param1:DisplayObject) : void;
      
      function get isOpened() : Boolean;
      
      function set color(param1:String) : void;
      
      function disable(param1:Boolean) : void;
      
      function open() : void;
      
      function close() : void;
   }
}

