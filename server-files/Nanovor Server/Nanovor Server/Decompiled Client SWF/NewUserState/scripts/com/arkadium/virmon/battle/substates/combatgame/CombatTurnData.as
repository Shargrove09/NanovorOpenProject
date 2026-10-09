package com.arkadium.virmon.battle.substates.combatgame
{
   import com.arkadium.virmon.battle.control.IAttack;
   
   public class CombatTurnData implements ICombatTurnData
   {
      
      private var _attackId:int;
      
      private var _myNextNanovorId:String;
      
      private var _myActiveNanovorId:String;
      
      private var _attackData:IAttack;
      
      private var _targetedPlayerName:String;
      
      public function CombatTurnData()
      {
         super();
      }
      
      public function get MyNextNanovorId() : String
      {
         return _myNextNanovorId;
      }
      
      public function set MyNextNanovorId(param1:String) : *
      {
         _myNextNanovorId = param1;
      }
      
      public function get TargetedPlayerName() : String
      {
         return _targetedPlayerName;
      }
      
      public function set AttackId(param1:int) : *
      {
         _attackId = param1;
      }
      
      public function get MyActiveNanovorId() : String
      {
         return _myActiveNanovorId;
      }
      
      public function get AttackId() : int
      {
         return _attackId;
      }
      
      public function set AttackData(param1:IAttack) : *
      {
         _attackData = param1;
      }
      
      public function set MyActiveNanovorId(param1:String) : *
      {
         _myActiveNanovorId = param1;
      }
      
      public function get AttackData() : IAttack
      {
         return _attackData;
      }
      
      public function set TargetedPlayerName(param1:String) : *
      {
         _targetedPlayerName = param1;
      }
   }
}

