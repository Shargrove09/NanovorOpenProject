package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TabTitle extends TabTitleTemplate
   {
      
      private static const WIRE_PADDING:Number = 30;
      
      private static const TWEEN_X_DISTANCE:Number = 20;
      
      private var _inactiveField:TextField;
      
      private var _activeField:TextField;
      
      public function TabTitle(param1:String)
      {
         super();
         tfTitle.autoSize = TextFieldAutoSize.LEFT;
         tfTitle2.autoSize = TextFieldAutoSize.LEFT;
         tfTitle2.alpha = 0;
         this._inactiveField = tfTitle2;
         this._activeField = tfTitle;
         this.text = param1;
         this.buttonMode = false;
         this.useHandCursor = false;
         this.visible = false;
      }
      
      public function set text(param1:String) : void
      {
         this._inactiveField.text = param1;
         Tweener.addTween(this._activeField,{
            "_autoAlpha":0,
            "x":0 - TWEEN_X_DISTANCE,
            "time":1
         });
         Tweener.addTween(this._inactiveField,{
            "_autoAlpha":1,
            "x":0,
            "time":0.5
         });
         Tweener.addTween(mcWire,{
            "width":this._inactiveField.width + WIRE_PADDING,
            "time":0.5
         });
         this.swapActiveFields();
      }
      
      private function swapActiveFields() : void
      {
         if(this._activeField == tfTitle)
         {
            this._activeField = tfTitle2;
            this._inactiveField = tfTitle;
         }
         else
         {
            this._activeField = tfTitle;
            this._inactiveField = tfTitle2;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<TabTitle>>\t" + param1);
      }
      
      public function hideTabTemplateFields() : void
      {
         DisplayObject(tfTitle).visible = DisplayObject(tfTitle2).visible = DisplayObject(mcWire).visible = false;
      }
      
      public function showTabTemplateFields() : void
      {
         this.visible = true;
         DisplayObject(tfTitle).visible = DisplayObject(tfTitle2).visible = DisplayObject(mcWire).visible = true;
      }
      
      override public function toString() : String
      {
         return "[TabTitle]";
      }
      
      public function get text() : String
      {
         return this._inactiveField.text;
      }
   }
}

