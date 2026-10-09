package com.arkadium.virmon.framework
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BadgeMasterData
   {
      
      private var _sCriteriaVar:String;
      
      private var _nID:int;
      
      private var _sLongDescription:String;
      
      private var _sPrereqDescription:String;
      
      private var _sName:String;
      
      private var _nCriteriaValue:Number;
      
      private var _sCriteriaOp:String;
      
      private var _sShortDescription:String;
      
      private var _iIconId:int = 0;
      
      public function BadgeMasterData()
      {
         super();
      }
      
      public function getName() : String
      {
         return _sName;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BadgeMasterData: " + param1);
      }
      
      public function getCriteriaVar() : String
      {
         return _sCriteriaVar;
      }
      
      public function getCriteriaOp() : String
      {
         return _sCriteriaOp;
      }
      
      public function getCriteriaValue() : Number
      {
         return _nCriteriaValue;
      }
      
      public function getShortDescription() : String
      {
         return _sShortDescription;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BadgeMasterData: " + param1);
      }
      
      public function getLongDescription() : String
      {
         return _sLongDescription;
      }
      
      public function getPrereqDescription() : String
      {
         return _sPrereqDescription;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         var _loc2_:Namespace = param1.namespace();
         _nID = int(param1.attribute(new QName(_loc2_.uri,"id")));
         _sName = String(param1.child(new QName(_loc2_.uri,"name")));
         _sShortDescription = String(param1.child(new QName(_loc2_.uri,"short-description")));
         _sLongDescription = String(param1.child(new QName(_loc2_.uri,"long-description")));
         _sPrereqDescription = String(param1.child(new QName(_loc2_.uri,"prereq-description")));
         _iIconId = int(param1.child(new QName(_loc2_.uri,"icon-id")));
         var _loc3_:XML = param1.child(new QName(_loc2_.uri,"criteria-clause"))[0];
         if(_loc3_ == null)
         {
            logError("xCC == null: _nID=" + _nID + ", _sName=" + _sName + "\n" + param1.child(new QName(_loc2_.uri,"criteria-clause")));
         }
         _sCriteriaVar = String(_loc3_.child(new QName(_loc2_.uri,"criteria-var")));
         _sCriteriaOp = String(_loc3_.child(new QName(_loc2_.uri,"criteria-op")));
         _nCriteriaValue = Number(_loc3_.child(new QName(_loc2_.uri,"criteria-value")));
      }
      
      public function getID() : int
      {
         return _nID;
      }
      
      public function getIconId() : int
      {
         return _iIconId;
      }
   }
}

