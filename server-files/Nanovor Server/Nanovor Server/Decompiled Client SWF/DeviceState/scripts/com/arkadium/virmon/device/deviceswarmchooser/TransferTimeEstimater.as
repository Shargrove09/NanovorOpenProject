package com.arkadium.virmon.device.deviceswarmchooser
{
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.device.assetmanager.DeviceCharacterAssetCheckChainLoadee;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IFileOperator;
   
   public class TransferTimeEstimater implements ITransferTimeEstimater, IChainLoaderConsumer
   {
      
      private var _totalDeviceNanovorCount:uint;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _fileOperator:IFileOperator;
      
      private var TRANSFER_TIME:int = 15;
      
      private var _callback:ITransferTimeEstimaterConsumer;
      
      private var DOWNLOAD_TIME:int = 45;
      
      private var _uniqueAssetTypeIdList:Array;
      
      private var _chainLoader:IChainLoader;
      
      private var _commonDialogBox:CommonDialogBox;
      
      public function TransferTimeEstimater(param1:IFileOperator, param2:IServiceRequestBrokerManager)
      {
         super();
         _fileOperator = param1;
         _serviceRequestBrokerManager = param2;
      }
      
      public function promptTransferTimeDialog(param1:Array, param2:ITransferTimeEstimaterConsumer) : void
      {
         var _loc4_:int = 0;
         _totalDeviceNanovorCount = param1.length;
         _uniqueAssetTypeIdList = getUniqueAssetTypeIds(param1);
         _callback = param2;
         var _loc3_:ChainLoadeeList = new ChainLoadeeList();
         for each(_loc4_ in _uniqueAssetTypeIdList)
         {
            _loc3_.add(new DeviceCharacterAssetCheckChainLoadee(_loc4_,_fileOperator,_serviceRequestBrokerManager));
         }
         _chainLoader = new ChainLoader(_loc3_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var assetTypeId:int = 0;
         var seconds:int = 0;
         var minutes:int = 0;
         var estimatedTransferTime:String = null;
         var handleContinueTransferYes:Function = null;
         var handleContinueTransferNo:Function = null;
         var assetCache:IAssetCache = param1;
         handleContinueTransferYes = function(param1:Object):void
         {
            _commonDialogBox.kill();
            _callback.acceptTimeEstimate();
         };
         handleContinueTransferNo = function(param1:Object):void
         {
            _commonDialogBox.kill();
            _callback.cancelTimeEstimate();
         };
         var downloadCount:uint = 0;
         for each(assetTypeId in _uniqueAssetTypeIdList)
         {
            if(false == assetCache.getLoadedAsset(DeviceCharacterAssetCheckChainLoadee.NAME + assetTypeId))
            {
               downloadCount++;
            }
         }
         seconds = DOWNLOAD_TIME * downloadCount + TRANSFER_TIME * _totalDeviceNanovorCount;
         minutes = seconds / 60;
         estimatedTransferTime = minutes + ":" + getTwoDigitNumber(Math.round(seconds % 60));
         _commonDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,"Estimated Time","Estimated transfer time is " + estimatedTransferTime + ". Continue?",0,handleContinueTransferYes,handleContinueTransferNo,handleContinueTransferNo,null,null);
      }
      
      private function getTwoDigitNumber(param1:int) : String
      {
         return 2 == param1.toString().length ? param1.toString() : "0" + param1.toString();
      }
      
      public function killDialogs() : void
      {
         if(null != _commonDialogBox)
         {
            _commonDialogBox.kill();
         }
      }
      
      private function getUniqueAssetTypeIds(param1:Array) : Array
      {
         var _loc3_:INanovor = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(-1 == _loc2_.indexOf(_loc3_.assetTypeId))
            {
               _loc2_.push(_loc3_.assetTypeId);
            }
         }
         return _loc2_;
      }
   }
}

