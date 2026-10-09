package com.arkadium.communications.handlers.chat
{
   public class ChatRoomType
   {
      
      public static const PUBLIC:ChatRoomType = new ChatRoomType("public");
      
      public static const PRIVATE:ChatRoomType = new ChatRoomType("private");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function ChatRoomType(param1:String)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instantiate enum type \'ChatRoomType\'.");
         }
         this._name = param1;
      }
      
      public function toString() : String
      {
         return "[ChatRoomType: " + this._name + "]";
      }
   }
}

