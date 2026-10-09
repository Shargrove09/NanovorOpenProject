package com.arkadium.virmon.framework
{
   public interface IVirmonMasterData
   {
      
      function getBaseSpeed() : Number;
      
      function getRarity() : String;
      
      function getSpeedBuffFormula() : Array;
      
      function getBaseHealth() : Number;
      
      function getAssetTypeVersion() : Number;
      
      function getFaction() : String;
      
      function getHealthBuffFormula() : Array;
      
      function getArmorBuffFormula() : Array;
      
      function getAttackList() : Array;
      
      function getMaxHealth() : Number;
      
      function parseXMLData(param1:XML) : *;
      
      function getWave() : Number;
      
      function getName() : String;
      
      function getMaxArmor() : Number;
      
      function getCollectorID() : String;
      
      function getLevel() : Number;
      
      function getAssetTypeID() : Number;
      
      function getBaseStrength() : Number;
      
      function getBaseArmor() : Number;
      
      function getMaxSpeed() : Number;
      
      function getStrengthBuffFormula() : Array;
      
      function getPointValue() : Number;
      
      function getMaxStrength() : Number;
   }
}

