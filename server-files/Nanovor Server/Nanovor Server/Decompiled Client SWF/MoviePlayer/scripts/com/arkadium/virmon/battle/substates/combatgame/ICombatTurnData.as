package com.arkadium.virmon.battle.substates.combatgame
{
   import com.arkadium.virmon.battle.control.IAttack;
   
   public interface ICombatTurnData
   {
      
      function get MyNextNanovorId() : String;
      
      function set MyNextNanovorId(param1:String) : *;
      
      function get AttackId() : int;
      
      function set AttackData(param1:IAttack) : *;
      
      function set AttackId(param1:int) : *;
      
      function set TargetedPlayerName(param1:String) : *;
      
      function get AttackData() : IAttack;
      
      function get TargetedPlayerName() : String;
      
      function set MyActiveNanovorId(param1:String) : *;
      
      function get MyActiveNanovorId() : String;
   }
}

