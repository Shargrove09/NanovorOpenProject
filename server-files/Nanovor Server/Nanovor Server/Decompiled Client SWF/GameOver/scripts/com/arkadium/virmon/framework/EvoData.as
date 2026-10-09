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
         return _birthAgeSeconds;
      }
      
      public function toString() : String
      {
         return "sourceAssetTypeId: " + _sourceAssetTypeId + "\n" + "destinationAssetTypeId: " + _destinationAssetTypeId + "\n" + "badgeIds: " + _nanovorBadgeIds;
      }
      
      public function getIsDiscovered() : Boolean
      {
         return _isDiscovered;
      }
      
      public function getID() : int
      {
         return _id;
      }
      
      public function getSlotCount() : int
      {
         return _slotCount;
      }
      
      public function getReqEMIds() : Array
      {
         return _reqEMIds;
      }
      
      public function getDestinationYPos() : int
      {
         return _destinationPositionY;
      }
      
      public function set solutionVisibleAt(param1:int) : void
      {
         _solutionVisibleAt = param1;
      }
      
      public function getSolutionVisibleAt() : int
      {
         return _solutionVisibleAt;
      }
      
      public function getAssetBadgeIDs() : Array
      {
         return _nanovorBadgeIds;
      }
      
      public function getIsRoot() : Boolean
      {
         return _isRoot;
      }
      
      public function set isDiscovered(param1:Boolean) : void
      {
         _isDiscovered = param1;
      }
      
      public function getSlotDone() : int
      {
         return _slotsDone;
      }
      
      public function set hintText(param1:String) : void
      {
         _hintText = param1;
      }
      
      public function set reqEMIds(param1:Array) : void
      {
         _reqEMIds = param1;
      }
      
      public function set destinationAssetTypeId(param1:int) : void
      {
         _destinationAssetTypeId = param1;
      }
      
      public function getTreeID() : int
      {
         return _treeId;
      }
      
      public function set treeId(param1:int) : void
      {
         _treeId = param1;
      }
      
      public function set nanovorBadgeIds(param1:Array) : void
      {
         _nanovorBadgeIds = param1;
      }
      
      public function getLastEvolutionSeconds() : int
      {
         return _lastEvolutionSeconds;
      }
      
      public function getDestinationXPos() : int
      {
         return _destinationPositionX;
      }
      
      public function set id(param1:int) : void
      {
         _id = param1;
      }
      
      public function set birthAgeSeconds(param1:int) : void
      {
         _birthAgeSeconds = param1;
      }
      
      public function set destinationPositionX(param1:int) : void
      {
         _destinationPositionX = param1;
      }
      
      public function set destinationPositionY(param1:int) : void
      {
         _destinationPositionY = param1;
      }
      
      public function getSourceYPos() : int
      {
         return _sourcePositionY;
      }
      
      public function set slotsDone(param1:int) : void
      {
         _slotsDone = param1;
      }
      
      public function getHintText() : String
      {
         return _hintText;
      }
      
      public function set accountBadgeIds(param1:Array) : void
      {
         _accountBadgeIds = param1;
      }
      
      public function set sourceAssetTypeId(param1:int) : void
      {
         _sourceAssetTypeId = param1;
      }
      
      public function getAccountBadgeIDs() : Array
      {
         return _accountBadgeIds;
      }
      
      public function getDestinationTypeID() : int
      {
         return _destinationAssetTypeId;
      }
      
      public function getPalette() : Array
      {
         return _palette;
      }
      
      public function getSourceTypeID() : int
      {
         return _sourceAssetTypeId;
      }
      
      public function set isRoot(param1:Boolean) : void
      {
         _isRoot = param1;
      }
      
      public function set sourcePositionX(param1:int) : void
      {
         _sourcePositionX = param1;
      }
      
      public function set sourcePositionY(param1:int) : void
      {
         _sourcePositionY = param1;
      }
      
      public function getSourceXPos() : int
      {
         return _sourcePositionX;
      }
      
      public function set palette(param1:Array) : void
      {
         _palette = param1;
      }
      
      public function set slotCount(param1:int) : void
      {
         _slotCount = param1;
      }
      
      public function set lastEvolutionSeconds(param1:int) : void
      {
         _lastEvolutionSeconds = param1;
      }
   }
}

