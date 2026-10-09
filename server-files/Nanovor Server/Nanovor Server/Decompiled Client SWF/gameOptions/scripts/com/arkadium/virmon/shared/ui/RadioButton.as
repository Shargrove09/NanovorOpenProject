package com.arkadium.virmon.shared.ui
{
   import com.arkadium.virmon.common.CustomEvent;
   import flash.display.*;
   import flash.events.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol43")]
   public class RadioButton extends MovieClip
   {
      
      public static var ON_CLICK:* = "onRBClick";
      
      private var bOn:Boolean = false;
      
      private var id:*;
      
      public var mcEye:MovieClip;
      
      public function RadioButton()
      {
         super();
         mcEye.visible = bOn;
         useHandCursor = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
      }
      
      public function deselect() : void
      {
         bOn = mcEye.visible = false;
      }
      
      public function get btnID() : *
      {
         return id;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!bOn)
         {
            _loc2_ = new Object();
            _loc2_.id = id;
            dispatchEvent(new CustomEvent(ON_CLICK,_loc2_));
         }
      }
      
      public function select() : void
      {
         bOn = mcEye.visible = true;
      }
      
      public function set btnID(param1:*) : void
      {
         id = param1;
      }
   }
}

