package com.arkadium.virmon.shared.components.avatar
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class OverridePopupController
   {
      
      private var _base:MovieClip;
      
      private var _bg:MovieClip;
      
      private var _popupDescription:TextField;
      
      public function OverridePopupController(param1:MovieClip)
      {
         super();
         _base = param1;
         _popupDescription = _base.tfText;
         _bg = _base.mcBG;
         _base.mouseEnabled = false;
         _base.mouseChildren = false;
         _base.alpha = 0;
         _popupDescription.autoSize = TextFieldAutoSize.LEFT;
         _popupDescription.wordWrap = false;
      }
      
      public function open() : void
      {
         if(_popupDescription.text == "")
         {
            return;
         }
         Tweener.addTween(_base,{
            "alpha":1,
            "time":0.25
         });
      }
      
      public function close() : void
      {
         if(_popupDescription.text == "")
         {
            return;
         }
         Tweener.addTween(_base,{
            "alpha":0,
            "time":0.25
         });
      }
      
      public function set text(param1:String) : void
      {
         _popupDescription.text = param1;
         _bg.width = _popupDescription.width + 6;
         _bg.height = _popupDescription.height + 32;
      }
   }
}

