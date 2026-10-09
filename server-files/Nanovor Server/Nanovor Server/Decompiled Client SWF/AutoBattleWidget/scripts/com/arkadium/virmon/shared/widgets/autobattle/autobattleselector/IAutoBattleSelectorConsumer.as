package com.arkadium.virmon.shared.widgets.autobattle.autobattleselector
{
   public interface IAutoBattleSelectorConsumer
   {
      
      function canceledSelection() : void;
      
      function selectedSingleplayer() : void;
      
      function selectedMultiplayer() : void;
   }
}

