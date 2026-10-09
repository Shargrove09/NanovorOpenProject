package com.arkadium.virmon.shared.widgets.chat
{
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol88")]
   public class CannedChatPanel extends MovieClip implements ICannedChatPanel
   {
      
      public var mcCategory4:MovieClip;
      
      public var mcCategory5:MovieClip;
      
      private var _handlers:Dictionary;
      
      public var mcCategory6:MovieClip;
      
      public var mcMore:MovieClip;
      
      public var mcCannedMessage1:MovieClip;
      
      public var mcCannedMessage2:MovieClip;
      
      public var mcCannedMessage3:MovieClip;
      
      public var mcCategory1:MovieClip;
      
      public var mcCategory2:MovieClip;
      
      public var mcCategory3:MovieClip;
      
      public function CannedChatPanel()
      {
         super();
         this.createHandlersDictionary();
         addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
      }
      
      public function removeSendMessageHandler(param1:ISendMessageHandler) : void
      {
         delete this._handlers[ISendMessageHandler][param1];
      }
      
      public function get category1() : MovieClip
      {
         return this.mcCategory1;
      }
      
      public function get category4() : MovieClip
      {
         return this.mcCategory4;
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:ISendMessageHandler = null;
         if(Keyboard.ENTER != param1.keyCode)
         {
            return;
         }
         for each(_loc2_ in this._handlers[ISendMessageHandler])
         {
            _loc2_.handleSendMessage();
         }
      }
      
      public function get more() : MovieClip
      {
         return this.mcMore;
      }
      
      public function get cannedMessage2() : MovieClip
      {
         return this.mcCannedMessage2;
      }
      
      public function get cannedMessage3() : MovieClip
      {
         return this.mcCannedMessage3;
      }
      
      public function addSendMessageHandler(param1:ISendMessageHandler) : void
      {
         this._handlers[ISendMessageHandler][param1] = param1;
      }
      
      public function get cannedMessage1() : MovieClip
      {
         return this.mcCannedMessage1;
      }
      
      public function get category2() : MovieClip
      {
         return this.mcCategory2;
      }
      
      public function get category3() : MovieClip
      {
         return this.mcCategory3;
      }
      
      public function get category5() : MovieClip
      {
         return this.mcCategory5;
      }
      
      public function get category6() : MovieClip
      {
         return this.mcCategory6;
      }
      
      private function createHandlersDictionary() : void
      {
         this._handlers = new Dictionary();
         this._handlers[ISendMessageHandler] = new Dictionary(true);
      }
   }
}

