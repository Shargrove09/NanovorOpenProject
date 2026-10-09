package com.arkadium.virmon.framework
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.net.*;
   
   public class VirmonManager extends EventDispatcher implements IVirmonManager, IVirmonDataRetriever
   {
      
      private var _aVirmonDataList:Array;
      
      private var _aVirmanMasterDataList:Array;
      
      private var _iTempRandom:int;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _bInitialDownloadComplete:Boolean;
      
      private var _xInstanceData:XML;
      
      private var _nStatsRecieved:int;
      
      public function VirmonManager(param1:IServiceRequestBrokerManager)
      {
         super();
         this._serviceRequestBrokerManager = param1;
         this._aVirmanMasterDataList = new Array();
         this._aVirmonDataList = null;
         this._iTempRandom = int(Math.random() * 1000000);
      }
      
      public function loadInstanceDataXML(param1:String) : void
      {
         var _loc2_:String = "data/" + param1 + ".xml";
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,this.instanceDataLoaded);
         _loc3_.load(new URLRequest(_loc2_));
      }
      
      public function getVirmonDataList() : Array
      {
         return this._aVirmonDataList.slice();
      }
      
      private function virmonMasterListReceived(param1:XML) : *
      {
         var _loc5_:IVirmonMasterData = null;
         var _loc2_:XML = Utils.StripXmlNamespace(param1);
         var _loc3_:XMLList = _loc2_.child("virmon");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = new VirmonMasterData();
            _loc5_.parseXMLData(_loc3_[_loc4_]);
            this._aVirmanMasterDataList.push(_loc5_);
            _loc4_++;
         }
         this.log("virmonMasterReceived: parsed " + this._aVirmanMasterDataList.length + " virmon");
      }
      
      public function getVirmonMasterData(param1:Number) : IVirmonMasterData
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._aVirmanMasterDataList.length)
         {
            if(param1 == VirmonMasterData(this._aVirmanMasterDataList[_loc2_]).getAssetTypeID())
            {
               return this._aVirmanMasterDataList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function assetListUpdated(param1:FrameWorkEvent) : void
      {
         this.assetListReceived(XML(param1.data));
      }
      
      private function assetListReceived(param1:XML) : *
      {
         var _loc5_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:IVirmonData = null;
         var _loc8_:int = 0;
         var _loc9_:IVirmonMasterData = null;
         this.log("assetListReceived");
         var _loc2_:XML = param1;
         var _loc3_:Namespace = _loc2_.namespace();
         var _loc4_:XMLList = _loc2_.child(new QName(_loc3_.uri,"asset"));
         if(this._aVirmonDataList == null)
         {
            this.log("OLD LIST COUNT: 0 (NULL)");
            this._aVirmonDataList = new Array();
         }
         else
         {
            this.log("OLD LIST COUNT: " + this._aVirmonDataList.length);
            this._aVirmonDataList.splice(0,this._aVirmonDataList.length);
         }
         this.log("NEW LIST COUNT: " + _loc4_.length());
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_.child(new QName(_loc3_.uri,"asset-type-category")) == "virmon")
            {
               _loc7_ = new VirmonData(this._serviceRequestBrokerManager);
               _loc7_.parseXMLData(_loc4_[_loc5_]);
               _loc8_ = int(_loc6_.child(new QName(_loc3_.uri,"asset-type-id")));
               _loc9_ = this.getVirmonMasterData(_loc8_);
               _loc7_.setVirmonMasterData(_loc9_);
               this._aVirmonDataList.push(_loc7_);
            }
            _loc5_++;
         }
         dispatchEvent(new FrameWorkEvent(FrameWorkEvent.DM_DATA_UPDATED));
      }
      
      public function getAttackById(param1:int) : IVirmonAttackData
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc2_:uint = this._aVirmanMasterDataList.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._aVirmanMasterDataList[_loc3_].getAttackList();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].getAttackID() == param1)
               {
                  return _loc4_[_loc5_];
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getOverrideDescriptionByAttackStatementId(param1:int) : String
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc2_:uint = this._aVirmanMasterDataList.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._aVirmanMasterDataList[_loc3_].getAttackList();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_].getAttackStatements();
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  if(_loc6_[_loc7_].id == param1)
                  {
                     return _loc4_[_loc5_].getOverrideDescription();
                  }
                  _loc7_++;
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return "NOT FOUND";
      }
      
      public function getCollectionSize() : int
      {
         return this._aVirmonDataList == null ? 0 : int(this._aVirmonDataList.length);
      }
      
      public function getVirmonQuantity(param1:Number) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this._aVirmonDataList.length)
         {
            if(param1 == VirmonData(this._aVirmonDataList[_loc3_]).getVirmonMasterData().getAssetTypeID())
            {
               _loc2_.push(this._aVirmonDataList[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getOverrideColor(param1:int) : String
      {
         var _loc3_:String = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc2_:uint = this._aVirmanMasterDataList.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._aVirmanMasterDataList[_loc4_].getAttackList();
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_].getAttackID() == param1)
               {
                  _loc3_ = _loc5_[_loc6_].getAttackName().toLowerCase();
                  if(_loc3_ == "blue spike")
                  {
                     return "blue";
                  }
                  if(_loc3_ == "red spike")
                  {
                     return "red";
                  }
                  if(_loc3_ == "yellow spike")
                  {
                     return "yellow";
                  }
               }
               _loc6_++;
            }
            _loc4_++;
         }
         return "normal";
      }
      
      public function getAttackStatementById(param1:int) : Object
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc2_:uint = this._aVirmanMasterDataList.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._aVirmanMasterDataList[_loc3_].getAttackList();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_].getAttackStatements();
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  if(_loc6_[_loc7_].id == param1)
                  {
                     return _loc6_[_loc7_];
                  }
                  _loc7_++;
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function instanceDataLoaded(param1:Event) : void
      {
         trace(">>>>LOCAL VIRMON INSTANCE DATA LOADED<<<<");
         this._xInstanceData = XML(param1.target.data);
      }
      
      public function onInitialize() : *
      {
         DataManager.getInstance().addEventListener(FrameWorkEvent.CM_ASSET_LIST_RECEIVED,this.assetListUpdated);
      }
      
      public function getVirmonData(param1:String) : IVirmonData
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._aVirmonDataList.length)
         {
            if(param1 == VirmonData(this._aVirmonDataList[_loc2_]).getAssetID())
            {
               return this._aVirmonDataList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getInstanceData() : XML
      {
         return this._xInstanceData;
      }
      
      public function getHackDescriptionByAttackId(param1:int) : String
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc2_:uint = this._aVirmanMasterDataList.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._aVirmanMasterDataList[_loc3_].getAttackList();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].getAttackID() == param1)
               {
                  return _loc4_[_loc5_].getHackDescription();
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return "";
      }
      
      public function setLists(param1:XML, param2:XML) : void
      {
         this.virmonMasterListReceived(param1);
         this.assetListReceived(param2);
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log(">> Virmon Mgr [" + this._iTempRandom + "]: " + param1);
      }
      
      public function getVirmonDataByAssetTypeId(param1:Number) : IVirmonData
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._aVirmonDataList.length)
         {
            if(param1 == VirmonData(this._aVirmonDataList[_loc2_]).getAssetTypeID())
            {
               return this._aVirmonDataList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getVirmonMasterDataList() : Array
      {
         return this._aVirmanMasterDataList.slice();
      }
      
      public function getOverrideDescriptionByAttackId(param1:int) : String
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc2_:uint = this._aVirmanMasterDataList.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._aVirmanMasterDataList[_loc3_].getAttackList();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].getAttackID() == param1)
               {
                  return _loc4_[_loc5_].getOverrideDescription();
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return "";
      }
   }
}

