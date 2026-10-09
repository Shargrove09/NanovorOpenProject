package com.arkadium.virmon.shared.widgets.chat
{
   import flash.display.MovieClip;
   
   public interface ICannedChatPanel
   {
      
      function get cannedMessage1() : MovieClip;
      
      function get cannedMessage2() : MovieClip;
      
      function get cannedMessage3() : MovieClip;
      
      function addSendMessageHandler(param1:ISendMessageHandler) : void;
      
      function removeSendMessageHandler(param1:ISendMessageHandler) : void;
      
      function get category1() : MovieClip;
      
      function get category2() : MovieClip;
      
      function get category3() : MovieClip;
      
      function get category4() : MovieClip;
      
      function get category5() : MovieClip;
      
      function get category6() : MovieClip;
      
      function get more() : MovieClip;
   }
}

