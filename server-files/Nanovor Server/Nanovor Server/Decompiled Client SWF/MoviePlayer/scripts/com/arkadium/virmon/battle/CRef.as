package com.arkadium.virmon.battle
{
   import com.arkadium.virmon.battle.control.BattleController;
   import com.arkadium.virmon.battle.control.RoundController;
   import com.arkadium.virmon.battle.substates.combatgame.CombatGamePanel;
   import com.arkadium.virmon.battle.substates.combatgame.CombatUIController;
   
   public class CRef
   {
      
      private static var _rBR:CombatGamePanel;
      
      private static var _combatUIController:CombatUIController;
      
      private static var _roundController:RoundController;
      
      private static var _battleController:BattleController;
      
      public function CRef()
      {
         super();
      }
      
      public static function get combatUIController() : CombatUIController
      {
         return _combatUIController;
      }
      
      public static function getBattleRef() : CombatGamePanel
      {
         return _rBR;
      }
      
      public static function set combatUIController(param1:CombatUIController) : void
      {
         _combatUIController = param1;
      }
      
      public static function set battleController(param1:BattleController) : void
      {
         _battleController = param1;
      }
      
      public static function get roundController() : RoundController
      {
         return _roundController;
      }
      
      public static function get battleController() : BattleController
      {
         return _battleController;
      }
      
      public static function setBattleRef(param1:CombatGamePanel) : void
      {
         _rBR = param1;
      }
      
      public static function set roundController(param1:RoundController) : void
      {
         _roundController = param1;
      }
   }
}

