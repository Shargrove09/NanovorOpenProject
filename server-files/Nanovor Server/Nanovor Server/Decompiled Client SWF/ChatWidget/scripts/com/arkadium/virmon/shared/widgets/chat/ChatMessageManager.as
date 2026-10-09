package com.arkadium.virmon.shared.widgets.chat
{
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   
   public class ChatMessageManager
   {
      
      private var _chatMessages:Array;
      
      private var _chatMessageContainer:DisplayObjectContainer;
      
      private var _chatPanelView:ChatPanelView;
      
      private var _originalPosition:Point;
      
      public function ChatMessageManager(param1:DisplayObjectContainer, param2:ChatPanelView)
      {
         super();
         this._chatPanelView = param2;
         this._chatMessages = new Array();
         this._chatMessageContainer = param1;
         this._originalPosition = new Point(this._chatMessageContainer.x,this._chatMessageContainer.y);
      }
      
      public function get container() : DisplayObjectContainer
      {
         return this._chatMessageContainer;
      }
      
      public function addMessage(param1:ChatMessage) : void
      {
         param1.y = this._chatMessages.length * (param1.height + 2);
         this._chatMessageContainer.addChild(param1);
         this._chatMessages.push(param1);
      }
      
      public function clear() : void
      {
         var _loc1_:ChatMessage = null;
         for each(_loc1_ in this._chatMessages)
         {
            if(null != _loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
         this._chatMessages = new Array();
         this._chatMessageContainer.x = this._originalPosition.x;
         this._chatMessageContainer.y = this._originalPosition.y;
         this._chatPanelView.resetScrollBar();
      }
      
      public function get length() : uint
      {
         return this._chatMessages.length;
      }
   }
}

