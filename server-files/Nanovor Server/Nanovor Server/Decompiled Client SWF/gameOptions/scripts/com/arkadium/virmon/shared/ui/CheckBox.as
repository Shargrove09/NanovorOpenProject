package com.arkadium.virmon.shared.ui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3")]
   public class CheckBox extends MovieClip
   {
      
      private var _isOn:Boolean = false;
      
      private var _id:int;
      
      private var _handler:ICheckBoxHandler;
      
      public function CheckBox()
      {
         super();
         this.buttonMode = true;
         this.useHandCursor = true;
         this.mouseEnabled = true;
         this.mouseChildren = false;
         gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         toggle();
         _handler.onCheckBoxClick(_id,_isOn);
      }
      
      public function init(param1:ICheckBoxHandler, param2:int, param3:Boolean = false) : void
      {
         _handler = param1;
         _id = param2;
         _isOn = !param3;
         toggle();
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      public function get isOn() : Boolean
      {
         return _isOn;
      }
      
      private function toggle() : void
      {
         _isOn = !_isOn;
         if(_isOn)
         {
            gotoAndStop("on");
         }
         else
         {
            gotoAndStop("off");
         }
      }
   }
}

