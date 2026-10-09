package com.arkadium.virmon.framework
{
   import com.arkadium.virmon.shared.utils.IVirmon;
   
   public interface IVirmonAttackData
   {
      
      function getOverrideDescription() : String;
      
      function getHandHeldDescription() : String;
      
      function getCost() : Number;
      
      function getForceDamage() : String;
      
      function getHackDescription() : String;
      
      function set iconType(param1:String) : void;
      
      function getAttackStatements() : Array;
      
      function getAmmo() : String;
      
      function getDamage(param1:IVirmon) : Number;
      
      function parseXMLData(param1:XML) : void;
      
      function getAttackName() : String;
      
      function getAttackConditionals() : Array;
      
      function get iconType() : String;
      
      function getShortDescription() : String;
      
      function getKeyword2() : String;
      
      function isTargetOpponent() : Boolean;
      
      function getAttackID() : uint;
      
      function getPCDescription() : String;
      
      function getKeyword1() : String;
      
      function getAttackType() : String;
   }
}

