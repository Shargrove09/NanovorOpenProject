package com.arkadium.virmon.battle.control
{
   public interface IConditional
   {
      
      function get conditionalName() : String;
      
      function get modifier() : String;
      
      function evaluate(param1:Boolean, param2:IPlayer, param3:IPlayer, param4:Boolean = true) : Boolean;
      
      function get variable() : String;
      
      function canEvaluatePreview(param1:IPlayer, param2:IPlayer, param3:Boolean = true) : Boolean;
   }
}

