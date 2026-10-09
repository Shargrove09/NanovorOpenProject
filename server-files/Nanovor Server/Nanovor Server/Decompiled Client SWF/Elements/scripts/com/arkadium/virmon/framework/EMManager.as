package com.arkadium.virmon.framework
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class EMManager extends EventDispatcher implements IEMManager
   {
      
      private var _aEMDataList:Array;
      
      private var _aEMMasterDataList:Array;
      
      private var _xInstanceData:XML;
      
      public function EMManager()
      {
         super();
         _aEMMasterDataList = new Array();
         _aEMDataList = null;
      }
      
      public function getEMQuantity(param1:Number) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:Array = new Array();
         while(_loc3_ < _aEMDataList.length)
         {
            if(param1 == _aEMDataList[_loc3_].getEMMasterData().getAssetTypeID())
            {
               _loc2_.push(_aEMDataList[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log(">> EM Mgr: " + param1);
      }
      
      public function getEMDataList() : Array
      {
         try
         {
            return _aEMDataList.slice();
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function getEMMasterData(param1:int) : EMMasterData
      {
         var _loc2_:int = 0;
         while(_loc2_ < _aEMMasterDataList.length)
         {
            if(param1 == _aEMMasterDataList[_loc2_].getAssetTypeID())
            {
               return _aEMMasterDataList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function instanceDataLoaded(param1:Event) : void
      {
         _xInstanceData = XML(param1.target.data);
      }
      
      public function setLists(param1:XML, param2:XML) : void
      {
         emMasterReceived(param1);
         assetListReceived(param2);
      }
      
      public function onInitialize() : void
      {
         DataManager.getInstance().addEventListener(FrameWorkEvent.CM_ASSET_LIST_RECEIVED,assetListUpdated);
      }
      
      public function getEMMasterDataList() : Array
      {
         return _aEMMasterDataList.slice();
      }
      
      public function getEMData(param1:String) : EMData
      {
         var _loc2_:int = 0;
         while(_loc2_ < _aEMDataList.length)
         {
            if(param1 == EMData(_aEMDataList[_loc2_]).getAssetID())
            {
               return EMData(_aEMDataList[_loc2_]);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getEMDataListByMasterID(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _aEMDataList.length)
         {
            if(_aEMDataList[_loc3_].getEMMasterData().getAssetTypeID() == param1)
            {
               _loc2_.push(_aEMDataList[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_.slice();
      }
      
      public function getEMCountByMasterId(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:* = 0;
         while(_loc3_ < _aEMDataList.length)
         {
            if(param1 == _aEMDataList[_loc3_].getEMMasterData().getAssetTypeID())
            {
               _loc2_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function emMasterReceived(param1:XML) : *
      {
         var _loc6_:EMMasterData = null;
         var _loc2_:String = String(param1);
         _loc2_ = "<em-master>" + _loc2_.substr(_loc2_.indexOf("<em>"));
         var _loc3_:XML = XML(_loc2_);
         var _loc4_:XMLList = _loc3_.em;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc6_ = new EMMasterData();
            _loc6_.parseXMLData(_loc4_[_loc5_]);
            _aEMMasterDataList.push(_loc6_);
            _loc5_++;
         }
         trace(">EM MASTER DONE!!!");
      }
      
      private function assetListUpdated(param1:FrameWorkEvent) : void
      {
         assetListReceived(XML(param1.data));
      }
      
      private function assetListReceived(param1:XML) : *
      {
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc6_:EMData = null;
         var _loc7_:int = 0;
         var _loc8_:EMMasterData = null;
         log("assetListReceived");
         var _loc2_:Namespace = param1.namespace();
         var _loc3_:XMLList = param1.child(new QName(_loc2_.uri,"asset"));
         if(_aEMDataList != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _aEMDataList.length)
            {
               _aEMDataList[_loc4_] = null;
               _loc4_++;
            }
         }
         _aEMDataList = new Array();
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.child(new QName(_loc2_.uri,"asset-type-category")) == "em")
            {
               _loc6_ = new EMData();
               _loc6_.parseXMLData(_loc5_);
               _loc7_ = int(_loc5_.child(new QName(_loc2_.uri,"asset-type-id")));
               _loc8_ = getEMMasterData(_loc7_);
               _loc6_.setEMMasterData(_loc8_);
               _aEMDataList.push(_loc6_);
            }
            _loc4_++;
         }
         dispatchEvent(new FrameWorkEvent(FrameWorkEvent.DM_DATA_UPDATED));
         trace(">EM ASSETS DONE!!!");
      }
      
      public function loadInstanceDataXML(param1:String) : *
      {
         var _loc2_:String = "data/em_" + param1 + ".xml";
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,instanceDataLoaded);
         _loc3_.load(new URLRequest(_loc2_));
      }
   }
}

