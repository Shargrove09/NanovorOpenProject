package com.arkadium.virmon.shared.ui.dropdownmenu
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol37")]
   public class DropDownMenuHeaderBox extends MovieClip
   {
      
      public var tfName:TextField;
      
      private var _handler:IDropDownMenuHeaderBoxHandler;
      
      public var btnArrow:SimpleButton;
      
      public function DropDownMenuHeaderBox()
      {
         super();
      }
      
      public function init(param1:IDropDownMenuHeaderBoxHandler) : void
      {
         this._handler = param1;
         this.btnArrow.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
      }
      
      public function updateLabel(param1:String) : void
      {
         this.tfName.text = param1;
      }
      
      private function onArrowClick(param1:MouseEvent) : void
      {
         this._handler.toggleListBox();
      }
   }
}

