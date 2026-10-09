package com.arkadium.virmon.framework
{
   public interface IBadgeData
   {
      
      function getName() : String;
      
      function set iId(param1:int) : void;
      
      function get sType() : String;
      
      function getCriteriaVar() : String;
      
      function getCriteriaOp() : String;
      
      function set bHidden(param1:Boolean) : void;
      
      function set sLongDescription(param1:String) : void;
      
      function getCriteriaValue() : Number;
      
      function getShortDescription() : String;
      
      function get sName() : String;
      
      function set sType(param1:String) : void;
      
      function getMasterData() : BadgeMasterData;
      
      function get iId() : int;
      
      function set sShortDescription(param1:String) : void;
      
      function getIconId() : int;
      
      function getPrereqDescription() : String;
      
      function get bHidden() : Boolean;
      
      function get sLongDescription() : String;
      
      function parseXMLData(param1:XML) : void;
      
      function getID() : int;
      
      function get sShortDescription() : String;
      
      function set sDateAwarded(param1:String) : void;
      
      function getLongDescription() : String;
      
      function get sDateAwarded() : String;
      
      function set sName(param1:String) : void;
   }
}

