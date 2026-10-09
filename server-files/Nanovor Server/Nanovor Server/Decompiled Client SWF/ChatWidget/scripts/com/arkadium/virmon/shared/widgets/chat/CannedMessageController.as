package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CannedMessageController extends MovieClip
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.3,
         "transition":Equations.easeInOutQuad
      };
      
      public var messageId:int;
      
      private var _bg:MovieClip;
      
      private var _isActive:Boolean;
      
      private var _base:MovieClip;
      
      public var messageText:String = "Who\'s house?  RUN\'s house.";
      
      private var _tfMessage:TextField;
      
      public function CannedMessageController(param1:MovieClip)
      {
         super();
         param1.controller = this;
         this._base = param1;
         this._tfMessage = this._base.tfMessage;
         this._bg = this._base.mcBG;
         this.init();
      }
      
      private function onBaseRollOver(param1:MouseEvent) : void
      {
         if(!this._isActive)
         {
            this.activate();
         }
      }
      
      public function deactivate() : void
      {
         Tweener.addTween(this._bg,{
            "base":TWEEN_BASE,
            "alpha":0
         });
      }
      
      public function get message() : String
      {
         return this._tfMessage.text;
      }
      
      public function hide() : void
      {
         this._base.visible = false;
      }
      
      private function init() : void
      {
         this._base.buttonMode = true;
         this._base.mouseChildren = false;
         this._bg.alpha = 0;
         this._isActive = false;
         this._base.addEventListener(MouseEvent.ROLL_OVER,this.onBaseRollOver);
         this._base.addEventListener(MouseEvent.ROLL_OUT,this.onBaseRollOut);
      }
      
      private function onBaseRollOut(param1:MouseEvent) : void
      {
         if(!this._isActive)
         {
            this.deactivate();
         }
      }
      
      public function activate() : void
      {
         Tweener.addTween(this._bg,{
            "base":TWEEN_BASE,
            "alpha":1
         });
      }
      
      public function set active(param1:Boolean) : void
      {
         this._isActive = param1;
         if(this._isActive)
         {
            this.activate();
         }
         else
         {
            this.deactivate();
         }
      }
      
      public function show() : void
      {
         this._base.visible = true;
      }
      
      public function set title(param1:String) : void
      {
         this._tfMessage.text = param1;
      }
   }
}

