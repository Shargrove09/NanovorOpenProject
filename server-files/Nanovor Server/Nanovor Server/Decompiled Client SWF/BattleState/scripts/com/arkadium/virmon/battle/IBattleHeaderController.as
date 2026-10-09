package com.arkadium.virmon.battle
{
   import com.arkadium.virmon.shared.components.ISwarmometer;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   
   public interface IBattleHeaderController
   {
      
      function playerLeftBattle(param1:int) : void;
      
      function getAvatarByPlayerId(param1:int) : IAvatar;
      
      function playerSwarmSelected(param1:int, param2:int, param3:Boolean) : void;
      
      function getSwarmometerById(param1:int) : ISwarmometer;
      
      function updateAllAvatarsAndNMPs() : void;
      
      function setCombatMode() : void;
      
      function setAllStatusWaiting() : void;
      
      function setBattleMode(param1:IBattleData, param2:String) : void;
      
      function removePlayerAvatar(param1:int, param2:uint) : void;
      
      function getSwarmCountByUserRefId(param1:int) : int;
   }
}

