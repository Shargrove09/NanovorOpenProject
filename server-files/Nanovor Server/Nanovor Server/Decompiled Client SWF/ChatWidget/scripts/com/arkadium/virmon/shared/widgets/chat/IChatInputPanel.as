package com.arkadium.virmon.shared.widgets.chat
{
   import com.arkadium.virmon.shared.final.components.spinningbutton.ISpinningButtonComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public interface IChatInputPanel extends IChatMessageProvider
   {
      
      function get sendSpinningButton() : ISpinningButtonComponent;
      
      function get playerNameTextField() : TextField;
      
      function get avatarHolder() : MovieClip;
      
      function get avatarMovieClip() : MovieClip;
      
      function enableCannedChat() : void;
      
      function setDefaultText() : void;
      
      function disableCannedChat() : void;
      
      function get cannedChatPanel() : ICannedChatPanel;
   }
}

