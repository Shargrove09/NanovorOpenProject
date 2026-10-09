package com.arkadium.virmon.framework
{
   import com.smithandtinker.nanovor.common.utils.MakeDate;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class EMData
   {
      
      private static const IS_NEW_TIME_THRESHOLD:int = 1000 * 60 * 60 * 48;
      
      private var _oEMMasterData:EMMasterData;
      
      private var _dBirthDate:Date;
      
      private var _dEvolveDate:Date;
      
      private var _isNew:Boolean;
      
      private var _sTypeName:String;
      
      private var _nAssetID:String;
      
      public function EMData()
      {
         super();
         _oEMMasterData = null;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** EMData: " + param1);
      }
      
      public function getEMMasterData() : EMMasterData
      {
         return _oEMMasterData;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> EMData: " + param1);
      }
      
      public function getAssetID() : String
      {
         return _nAssetID;
      }
      
      public function parseXMLData(param1:XML) : *
      {
         var _loc2_:Namespace = param1.namespace();
         _nAssetID = String(param1.attribute(new QName(_loc2_.uri,"id")));
         _sTypeName = param1.child(new QName(_loc2_.uri,"asset-type-name"));
         var _loc3_:String = String(param1.child(new QName(_loc2_.uri,"birth-date")));
         _dBirthDate = MakeDate.dateFromBankTime(_loc3_);
         var _loc4_:String = String(param1.child(new QName(_loc2_.uri,"last-evolution-date")));
         _dEvolveDate = MakeDate.dateFromBankTime(_loc4_);
         var _loc5_:Date = new Date();
         _isNew = _loc5_.getTime() - _dBirthDate.getTime() < IS_NEW_TIME_THRESHOLD;
      }
      
      public function isNew() : Boolean
      {
         return _isNew;
      }
      
      public function getTypeName() : String
      {
         return _sTypeName;
      }
      
      public function setEMMasterData(param1:EMMasterData) : *
      {
         _oEMMasterData = param1;
      }
   }
}

