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
         this.sType = null;
      }
      
      public function getID() : int
      {
         return this.iId;
      }
      
      public function getName() : String
      {
         return this.sName;
      }
      
      public function getCriteriaVar() : String
      {
         if(!this.getMasterData())
         {
            return null;
         }
         return this.getMasterData().getCriteriaVar();
      }
      
      public function set sType(param1:String) : void
      {
         this._sType = param1;
      }
      
      public function getCriteriaOp() : String
      {
         if(!this.getMasterData())
         {
            return null;
         }
         return this.getMasterData().getCriteriaOp();
      }
      
      public function getMasterData() : BadgeMasterData
      {
         var _loc1_:BadgeMasterData = null;
         if(this.sType == TYPE_ASSET || this.sType === null)
         {
            _loc1_ = DataManager.getInstance().getBadgeManager().getAssetBadgeData(this.iId);
         }
         if(this.sType == TYPE_ACCOUNT || _loc1_ === null)
         {
            _loc1_ = DataManager.getInstance().getBadgeManager().getAccountBadgeData(this.iId);
         }
         return _loc1_;
      }
      
      public function getCriteriaValue() : Number
      {
         if(!this.getMasterData())
         {
            return -1;
         }
         return this.getMasterData().getCriteriaValue();
      }
      
      public function getLongDescription() : String
      {
         return this.sLongDescription;
      }
      
      public function get bHidden() : Boolean
      {
         return this._bHidden;
      }
      
      public function get sName() : String
      {
         return this._sName;
      }
      
      public function parseXMLData(param1:XML) : void
      {
         this.iId = param1.attribute("id");
         this.sName = param1.child("name");
         this.sShortDescription = param1.child("short-description");
         this.sLongDescription = param1.child("long-description");
         this.sDateAwarded = String(param1.child("date-awarded")).slice(0,10);
         this.bHidden = String(param1.child("hidden")) == "true";
      }
      
      public function getPrereqDescription() : String
      {
         if(!this.getMasterData())
         {
            return null;
         }
         return this.getMasterData().getPrereqDescription();
      }
      
      public function get sDateAwarded() : String
      {
         return this._sDateAwarded;
      }
      
      public function set sName(param1:String) : void
      {
         this._sName = param1;
      }
      
      public function get sType() : String
      {
         return this._sType;
      }
      
      public function set iId(param1:int) : void
      {
         this._iId = param1;
      }
      
      public function getShortDescription() : String
      {
         return this.sShortDescription;
      }
      
      public function set bHidden(param1:Boolean) : void
      {
         this._bHidden = param1;
      }
      
      public function set sLongDescription(param1:String) : void
      {
         this._sLongDescription = param1;
      }
      
      public function get iId() : int
      {
         return this._iId;
      }
      
      public function set sShortDescription(param1:String) : void
      {
         this._sShortDescription = param1;
      }
      
      public function getIconId() : int
      {
         if(!this.getMasterData())
         {
            return -1;
         }
         return this.getMasterData().getIconId();
      }
      
      public function get sShortDescription() : String
      {
         return this._sShortDescription;
      }
      
      public function set sDateAwarded(param1:String) : void
      {
         this._sDateAwarded = param1;
      }
      
      public function get sLongDescription() : String
      {
         return this._sLongDescription;
      }
   }
}

