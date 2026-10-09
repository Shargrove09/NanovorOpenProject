package com.arkadium.virmon.framework
{
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class EvoManager implements IEvoManager, IEvoDataRetriever
   {
      
      private var _treeNames:Dictionary;
      
      private var _nanovorAssetTypeIdsInTree:Array;
      
      private var _evolutions:Array;
      
      private var _treeIds:Array;
      
      public function EvoManager()
      {
         super();
      }
      
      public function getTreeIds() : Array
      {
         if(this._treeIds == null)
         {
            throw new Error("Tree data has not been initialized yet");
         }
         return this._treeIds;
      }
      
      private function generateNanovorIdsInEachTree() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         this.log("generateNanovorIdsInEachTree()");
         if(this._evolutions == null)
         {
            throw new Error("Evolution data has not been initialized yet");
         }
         this._nanovorAssetTypeIdsInTree = new Array();
         var _loc5_:int = int(this._evolutions.length);
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_)
         {
            _loc1_ = int(this._evolutions[_loc6_].getTreeID());
            _loc2_ = int(this._evolutions[_loc6_].getSourceTypeID());
            _loc3_ = int(this._evolutions[_loc6_].getDestinationTypeID());
            _loc4_ = Boolean(this._evolutions[_loc6_].getIsRoot());
            if(this._nanovorAssetTypeIdsInTree[_loc1_] == null)
            {
               this._nanovorAssetTypeIdsInTree[_loc1_] = new Array();
            }
            if(_loc4_)
            {
               if(this._nanovorAssetTypeIdsInTree[_loc1_][0] != _loc2_)
               {
                  this._nanovorAssetTypeIdsInTree[_loc1_].unshift(_loc2_);
               }
            }
            else if(this._nanovorAssetTypeIdsInTree[_loc1_].indexOf(_loc2_) < 0)
            {
               this._nanovorAssetTypeIdsInTree[_loc1_].push(_loc2_);
            }
            if(this._nanovorAssetTypeIdsInTree[_loc1_].indexOf(_loc3_) < 0)
            {
               this._nanovorAssetTypeIdsInTree[_loc1_].push(_loc3_);
            }
            _loc6_++;
         }
      }
      
      public function onInitialize() : void
      {
         DebugLog.instance.log(">> EvoManager: onInitialize");
      }
      
      public function init(param1:XML) : void
      {
         var _loc3_:EvoData = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:XMLList = null;
         var _loc7_:XMLList = null;
         var _loc8_:XMLList = null;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:int = 0;
         var _loc22_:String = null;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:Array = null;
         var _loc26_:Array = null;
         var _loc27_:Array = null;
         var _loc28_:XML = null;
         this.log("init()");
         this._evolutions = new Array();
         param1 = Utils.StripXmlNamespace(param1);
         var _loc2_:XMLList = param1.evolution;
         for each(_loc28_ in _loc2_)
         {
            _loc9_ = int(_loc28_.@id);
            _loc10_ = uint(_loc28_["tree"]);
            _loc11_ = _loc28_["root"] == "true" ? true : false;
            _loc13_ = uint(_loc28_["source-type-id"]);
            _loc14_ = uint(_loc28_["source-xpos"]);
            _loc15_ = uint(_loc28_["source-ypos"]);
            _loc16_ = uint(_loc28_["destination-type-id"]);
            _loc17_ = uint(_loc28_["destination-xpos"]);
            _loc18_ = uint(_loc28_["destination-ypos"]);
            _loc21_ = int(_loc28_["solution-visible-at"]);
            _loc22_ = _loc28_["hint-text"];
            _loc19_ = uint(_loc28_["recipe-slot-count"]);
            _loc8_ = _loc28_["recipe-slot"];
            if(_loc8_.length() > 0)
            {
               _loc19_ = uint(_loc8_.length());
            }
            _loc12_ = _loc11_ || _loc8_.length() > 0;
            _loc20_ = 0;
            _loc23_ = new Array();
            _loc24_ = new Array();
            _loc6_ = _loc28_["hint"];
            _loc5_ = int(_loc6_.length());
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_loc23_.indexOf(int(_loc6_[_loc4_])) == -1)
               {
                  _loc23_.push(int(_loc6_[_loc4_]));
               }
               _loc24_.push(int(_loc6_[_loc4_]));
               _loc4_++;
            }
            _loc25_ = new Array();
            _loc7_ = _loc28_["asset-badge-id"];
            _loc5_ = int(_loc7_.length());
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc25_.push(int(_loc7_[_loc4_]));
               _loc4_++;
            }
            _loc26_ = new Array();
            _loc7_ = _loc28_["account-badge-id"];
            _loc5_ = int(_loc7_.length());
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc26_.push(int(_loc7_[_loc4_]));
               _loc4_++;
            }
            _loc3_ = new EvoData();
            _loc3_.id = _loc9_;
            _loc3_.isRoot = _loc11_;
            _loc3_.isDiscovered = _loc12_;
            _loc3_.treeId = _loc10_;
            _loc3_.sourceAssetTypeId = _loc13_;
            _loc3_.sourcePositionX = _loc14_;
            _loc3_.sourcePositionY = _loc15_;
            _loc3_.destinationAssetTypeId = _loc16_;
            _loc3_.destinationPositionX = _loc17_;
            _loc3_.destinationPositionY = _loc18_;
            _loc3_.slotCount = _loc19_;
            _loc3_.slotsDone = _loc20_;
            _loc3_.solutionVisibleAt = _loc21_;
            _loc3_.hintText = _loc22_;
            _loc3_.palette = _loc23_;
            _loc3_.reqEMIds = _loc24_;
            _loc3_.nanovorBadgeIds = _loc25_;
            _loc3_.accountBadgeIds = _loc26_;
            this._evolutions.push(_loc3_);
         }
         this.generateNanovorIdsInEachTree();
      }
      
      public function getTreeNames() : Dictionary
      {
         if(this._treeNames == null)
         {
            throw new Error("Tree data has not been initialized yet");
         }
         return this._treeNames;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoManager>>\t" + param1);
      }
      
      public function initTreeNames(param1:XML) : void
      {
         this._treeIds = new Array();
         this._treeNames = new Dictionary(false);
         var _loc2_:XMLList = param1.tree;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length())
         {
            this._treeNames[_loc2_[_loc3_].@id.toString()] = _loc2_[_loc3_].@name.toString();
            this._treeIds.push(parseInt(_loc2_[_loc3_].@id));
            _loc3_++;
         }
      }
      
      public function getNanovorIdsInTrees() : Array
      {
         if(this._evolutions == null)
         {
            throw new Error("Evolution data has not been initialized yet");
         }
         return this._nanovorAssetTypeIdsInTree;
      }
      
      public function getEvoData(param1:int) : EvoData
      {
         var _loc2_:int = 0;
         if(this._evolutions == null)
         {
            throw new Error("Evolution data has not been initialized yet");
         }
         DebugLog.instance.log(">> EvoManager: getting evo data: " + param1);
         while(_loc2_ < this._evolutions.length)
         {
            if(param1 == this._evolutions[_loc2_].getID())
            {
               DebugLog.instance.log(">> EvoManager: got it...");
               return this._evolutions[_loc2_];
            }
            _loc2_++;
         }
         DebugLog.instance.log(">> EvoManager: nope...");
         return null;
      }
      
      public function getEvoList() : Array
      {
         if(this._evolutions == null)
         {
            throw new Error("Evolution data has not been initialized yet");
         }
         return this._evolutions;
      }
   }
}

