package com.arkadium.virmon.battle.control
{
   public interface IAttackStatement
   {
      
      function get delay() : String;
      
      function doesApply(param1:Boolean, param2:Boolean, param3:IPlayer, param4:IPlayer) : Boolean;
      
      function getPreviewDelta(param1:IPlayer, param2:IPlayer, param3:IPlayer = null) : String;
      
      function get name() : String;
      
      function calculateBaseFormula(param1:INanovor, param2:INanovor) : Number;
      
      function get target() : String;
      
      function get duration() : int;
      
      function set currentDuration(param1:int) : void;
      
      function get roundConditionals() : Array;
      
      function resetCurrentDuration() : void;
      
      function get verb() : String;
      
      function doesApplyThisRound(param1:Boolean, param2:IPlayer, param3:IPlayer) : Boolean;
      
      function get stat() : String;
      
      function get baseDamageFormula() : IAttackStatementFormula;
      
      function prepareClientDescription(param1:int) : void;
      
      function setCurrentDuration() : void;
      
      function toString() : String;
      
      function get conditionals() : Array;
      
      function get clientDescription() : String;
      
      function get id() : int;
      
      function get currentDuration() : int;
      
      function calculateDamage(param1:INanovor = null, param2:INanovor = null) : Number;
      
      function get statementFormula() : IAttackStatementFormula;
      
      function get type() : String;
      
      function canEvaluateConditionalsForPreview(param1:IPlayer, param2:IPlayer, param3:Boolean = true) : Boolean;
   }
}

