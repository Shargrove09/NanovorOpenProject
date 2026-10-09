package com.arkadium.virmon.shared.utils
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol84")]
   public class CMessage extends Sprite
   {
      
      public var _sbtYes:SimpleButton;
      
      private var _fCloseGame:Function;
      
      public var _sbtNo:SimpleButton;
      
      public var _sbtOk:SimpleButton;
      
      private var _fDecline:Function;
      
      private var _Data:*;
      
      public var _stfMes:TextField;
      
      private var _fAccept:Function;
      
      public function CMessage()
      {
         super();
      }
      
      public function accept(param1:MouseEvent) : *
      {
         _fAccept(_Data);
         this.parent.removeChild(this);
      }
      
      public function setData(param1:String, param2:String, ... rest) : void
      {
         _stfMes.text = param2;
         _stfMes.y = 380 - _stfMes.textHeight / 2;
         if(rest.length > 0)
         {
            _fCloseGame = rest[0];
            _fAccept = rest[0];
            _fDecline = rest[1];
            _Data = rest[2];
         }
         switch(param1)
         {
            case "offer":
               _sbtOk.visible = false;
               _sbtYes.addEventListener(MouseEvent.CLICK,accept);
               _sbtNo.addEventListener(MouseEvent.CLICK,decline);
               break;
            case "info":
               _sbtOk.addEventListener(MouseEvent.CLICK,closeMessage);
               _sbtYes.visible = false;
               _sbtNo.visible = false;
               break;
            case "gameWin":
               _sbtOk.addEventListener(MouseEvent.CLICK,closeGame);
               _sbtYes.visible = false;
               _sbtNo.visible = false;
         }
      }
      
      public function closeGame(param1:MouseEvent) : *
      {
         _fCloseGame(_Data);
         this.parent.removeChild(this);
      }
      
      public function closeMessage(param1:MouseEvent) : *
      {
         this.parent.removeChild(this);
      }
      
      public function decline(param1:MouseEvent) : *
      {
         _fDecline(_Data);
         this.parent.removeChild(this);
      }
   }
}

