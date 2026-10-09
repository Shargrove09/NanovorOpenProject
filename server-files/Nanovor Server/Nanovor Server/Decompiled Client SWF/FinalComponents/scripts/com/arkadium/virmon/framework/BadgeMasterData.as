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
         return this._sName;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> BadgeMasterData: " + param1);
      }
      
      public function getCriteriaVar() : String
      {
         return this._sCriteriaVar;
      }
      
      public function getCriteriaOp() : String
      {
         return this._sCriteriaOp;
      }
      
      public function getCriteriaValue() : Number
      {
         return this._nCriteriaValue;
      }
      
      public function getShortDescription() : String
      {
         return this._sShortDescription;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** BadgeMasterData: " + param1);
      }
      
      public function getLongDescription() : String
      {
         return this._sLongDescription;
      }
      
      public function getPrereqDescription() : String
      {
         return this._sPrereqDescription;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         var _loc2_:Namespace = param1.namespace();
         this._nID = int(param1.attribute(new QName(_loc2_.uri,"id")));
         this._sName = String(param1.child(new QName(_loc2_.uri,"name")));
         this._sShortDescription = String(param1.child(new QName(_loc2_.uri,"short-description")));
         this._sLongDescription = String(param1.child(new QName(_loc2_.uri,"long-description")));
         this._sPrereqDescription = String(param1.child(new QName(_loc2_.uri,"prereq-description")));
         this._iIconId = int(param1.child(new QName(_loc2_.uri,"icon-id")));
         var _loc3_:XML = param1.child(new QName(_loc2_.uri,"criteria-clause"))[0];
         if(_loc3_ == null)
         {
            this.logError("xCC == null: _nID=" + this._nID + ", _sName=" + this._sName + "\n" + param1.child(new QName(_loc2_.uri,"criteria-clause")));
         }
         this._sCriteriaVar = String(_loc3_.child(new QName(_loc2_.uri,"criteria-var")));
         this._sCriteriaOp = String(_loc3_.child(new QName(_loc2_.uri,"criteria-op")));
         this._nCriteriaValue = Number(_loc3_.child(new QName(_loc2_.uri,"criteria-value")));
      }
      
      public function getID() : int
      {
         return this._nID;
      }
      
      public function getIconId() : int
      {
         return this._iIconId;
      }
   }
}

