package com.arkadium.virmon.framework
{
   public class BadgeData implements IBadgeData
   {
      
      public static const TYPE_ASSET:String = "asset";
      
      public static const TYPE_ACCOUNT:String = "account";
      
      private var _sName:String;
      
      private var _iId:int;
      
      private var _sDateAwarded:String;
      
      private var _sLongDescription:String;
      
      private var _sType:String;
      
      private var _bHidden:Boolean;
      
      private var _sShortDescription:String;
      
      public function BadgeData()
      {
         super();
         sType = null;
      }
      
      public function getID() : int
      {
         return iId;
      }
      
      public function getName() : String
      {
         return sName;
      }
      
      public function getCriteriaVar() : String
      {
         if(!getMasterData())
         {
            return null;
         }
         return getMasterData().getCriteriaVar();
      }
      
      public function set sType(param1:String) : void
      {
         _sType = param1;
      }
      
      public function getCriteriaOp() : String
      {
         if(!getMasterData())
         {
            return null;
         }
         return getMasterData().getCriteriaOp();
      }
      
      public function getMasterData() : BadgeMasterData
      {
         var _loc1_:BadgeMasterData = null;
         if(sType == TYPE_ASSET || sType === null)
         {
            _loc1_ = DataManager.getInstance().getBadgeManager().getAssetBadgeData(iId);
         }
         if(sType == TYPE_ACCOUNT || _loc1_ === null)
         {
            _loc1_ = DataManager.getInstance().getBadgeManager().getAccountBadgeData(iId);
         }
         return _loc1_;
      }
      
      public function getCriteriaValue() : Number
      {
         if(!getMasterData())
         {
            return -1;
         }
         return getMasterData().getCriteriaValue();
      }
      
      public function getLongDescription() : String
      {
         return sLongDescription;
      }
      
      public function get bHidden() : Boolean
      {
         return _bHidden;
      }
      
      public function get sName() : String
      {
         return _sName;
      }
      
      public function parseXMLData(param1:XML) : void
      {
         iId = param1.attribute("id");
         sName = param1.child("name");
         sShortDescription = param1.child("short-description");
         sLongDescription = param1.child("long-description");
         sDateAwarded = String(param1.child("date-awarded")).slice(0,10);
         bHidden = String(param1.child("hidden")) == "true";
      }
      
      public function getPrereqDescription() : String
      {
         if(!getMasterData())
         {
            return null;
         }
         return getMasterData().getPrereqDescription();
      }
      
      public function get sDateAwarded() : String
      {
         return _sDateAwarded;
      }
      
      public function set sName(param1:String) : void
      {
         _sName = param1;
      }
      
      public function get sType() : String
      {
         return _sType;
      }
      
      public function set iId(param1:int) : void
      {
         _iId = param1;
      }
      
      public function getShortDescription() : String
      {
         return sShortDescription;
      }
      
      public function set bHidden(param1:Boolean) : void
      {
         _bHidden = param1;
      }
      
      public function set sLongDescription(param1:String) : void
      {
         _sLongDescription = param1;
      }
      
      public function get iId() : int
      {
         return _iId;
      }
      
      public function set sShortDescription(param1:String) : void
      {
         _sShortDescription = param1;
      }
      
      public function getIconId() : int
      {
         if(!getMasterData())
         {
            return -1;
         }
         return getMasterData().getIconId();
      }
      
      public function get sShortDescription() : String
      {
         return _sShortDescription;
      }
      
      public function set sDateAwarded(param1:String) : void
      {
         _sDateAwarded = param1;
      }
      
      public function get sLongDescription() : String
      {
         return _sLongDescription;
      }
   }
}

