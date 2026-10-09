package com.arkadium.virmon.shared.widgets.megawidget
{
   public interface IMegaWidget
   {
      
      function startAutoBattle(param1:int = 2) : void;
      
      function isAutoBattle() : Boolean;
      
      function invitePlayerToBattle(param1:String, param2:int) : void;
      
      function canInvitePlayerToBattle(param1:String) : Boolean;
      
      function reset(param1:Boolean = true) : void;
      
      function quitBattle() : void;
      
      function isPlayerInSameChatRoom(param1:String) : Boolean;
      
      function invitePlayerToChat(param1:String, param2:int) : void;
      
      function canInvitePlayerToChat(param1:String) : Boolean;
      
      function invitePlayerToTrade(param1:String, param2:int) : void;
   }
}

