package com.arkadium.virmon.framework
{
   public class EvoData
   {
      
      private var _lastEvolutionSeconds:int;
      
      private var _nanovorBadgeIds:Array;
      
      private var _accountBadgeIds:Array;
      
      private var _sourcePositionX:int;
      
      private var _slotCount:int;
      
      private var _id:int;
      
      private var _palette:Array;
      
      private var _destinationPositionX:int;
      
      private var _destinationPositionY:int;
      
      private var _sourcePositionY:int;
      
      private var _isRoot:Boolean;
      
      private var _solutionVisibleAt:int;
      
      private var _destinationAssetTypeId:int;
      
      private var _hintText:String;
      
      private var _slotsDone:int;
      
      private var _birthAgeSeconds:int;
      
      private var _sourceAssetTypeId:int;
      
      private var _reqEMIds:Array;
      
      private var _isDiscovered:Boolean;
      
      private var _treeId:int;
      
      public function EvoData()
      {
         super();
      }
      
      public function getBirthAgeSeconds() : int
      {
         return this._birthAgeSeconds;
      }
      
      public function toString() : String
      {
         return "sourceAssetTypeId: " + this._sourceAssetTypeId + "\n" + "destinationAssetTypeId: " + this._destinationAssetTypeId + "\n" + "badgeIds: " + this._nanovorBadgeIds;
      }
      
      public function getIsDiscovered() : Boolean
      {
         return this._isDiscovered;
      }
      
      public function getID() : int
      {
         return this._id;
      }
      
      public function getSlotCount() : int
      {
         return this._slotCount;
      }
      
      public function getReqEMIds() : Array
      {
         return this._reqEMIds;
      }
      
      public function getDestinationYPos() : int
      {
         return this._destinationPositionY;
      }
      
      public function set solutionVisibleAt(param1:int) : void
      {
         this._solutionVisibleAt = param1;
      }
      
      public function getSolutionVisibleAt() : int
      {
         return this._solutionVisibleAt;
      }
      
      public function getAssetBadgeIDs() : Array
      {
         return this._nanovorBadgeIds;
      }
      
      public function getIsRoot() : Boolean
      {
         return this._isRoot;
      }
      
      public function set isDiscovered(param1:Boolean) : void
      {
         this._isDiscovered = param1;
      }
      
      public function getSlotDone() : int
      {
         return this._slotsDone;
      }
      
      public function set hintText(param1:String) : void
      {
         this._hintText = param1;
      }
      
      public function set reqEMIds(param1:Array) : void
      {
         this._reqEMIds = param1;
      }
      
      public function set destinationAssetTypeId(param1:int) : void
      {
         this._destinationAssetTypeId = param1;
      }
      
      public function getTreeID() : int
      {
         return this._treeId;
      }
      
      public function set treeId(param1:int) : void
      {
         this._treeId = param1;
      }
      
      public function set nanovorBadgeIds(param1:Array) : void
      {
         this._nanovorBadgeIds = param1;
      }
      
      public function getLastEvolutionSeconds() : int
      {
         return this._lastEvolutionSeconds;
      }
      
      public function getDestinationXPos() : int
      {
         return this._destinationPositionX;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function set birthAgeSeconds(param1:int) : void
      {
         this._birthAgeSeconds = param1;
      }
      
      public function set destinationPositionX(param1:int) : void
      {
         this._destinationPositionX = param1;
      }
      
      public function set destinationPositionY(param1:int) : void
      {
         this._destinationPositionY = param1;
      }
      
      public function getSourceYPos() : int
      {
         return this._sourcePositionY;
      }
      
      public function set slotsDone(param1:int) : void
      {
         this._slotsDone = param1;
      }
      
      public function getHintText() : String
      {
         return this._hintText;
      }
      
      public function set accountBadgeIds(param1:Array) : void
      {
         this._accountBadgeIds = param1;
      }
      
      public function set sourceAssetTypeId(param1:int) : void
      {
         this._sourceAssetTypeId = param1;
      }
      
      public function getAccountBadgeIDs() : Array
      {
         return this._accountBadgeIds;
      }
      
      public function getDestinationTypeID() : int
      {
         return this._destinationAssetTypeId;
      }
      
      public function getPalette() : Array
      {
         return this._palette;
      }
      
      public function getSourceTypeID() : int
      {
         return this._sourceAssetTypeId;
      }
      
      public function set isRoot(param1:Boolean) : void
      {
         this._isRoot = param1;
      }
      
      public function set sourcePositionX(param1:int) : void
      {
         this._sourcePositionX = param1;
      }
      
      public function set sourcePositionY(param1:int) : void
      {
         this._sourcePositionY = param1;
      }
      
      public function getSourceXPos() : int
      {
         return this._sourcePositionX;
      }
      
      public function set palette(param1:Array) : void
      {
         this._palette = param1;
      }
      
      public function set slotCount(param1:int) : void
      {
         this._slotCount = param1;
      }
      
      public function set lastEvolutionSeconds(param1:int) : void
      {
         this._lastEvolutionSeconds = param1;
      }
   }
}

