package com.arkadium.virmon.battle.control
{
   public interface IAttack
   {
      
      function get forceDamage() : String;
      
      function setWasUsed(param1:Boolean) : void;
      
      function get conditional() : IConditional;
      
      function get expectedDamage() : Number;
      
      function get pcDescription() : String;
      
      function get name() : String;
      
      function get attackStatements() : Array;
      
      function get cost() : int;
      
      function set expectedDamage(param1:Number) : void;
      
      function get overrideDescription() : String;
      
      function get ammo() : String;
      
      function get isSelfTarget() : Boolean;
      
      function get icons() : Array;
      
      function get hackDescription() : String;
      
      function get hhDescription() : String;
      
      function get wasUsed() : Boolean;
      
      function get animationID() : int;
      
      function get shortDescription() : String;
      
      function get attackID() : int;
      
      function findAttackStatements(param1:String = null, param2:String = null) : Array;
      
      function isDodgeable() : Boolean;
      
      function get keyword1() : String;
      
      function get actionIconType() : String;
      
      function toString() : String;
      
      function get keyword2() : String;
      
      function get type() : String;
      
      function set animationID(param1:int) : void;
   }
}

