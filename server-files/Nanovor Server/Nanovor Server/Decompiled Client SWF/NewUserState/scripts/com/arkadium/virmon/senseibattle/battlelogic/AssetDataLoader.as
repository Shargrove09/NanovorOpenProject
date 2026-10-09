package com.arkadium.virmon.senseibattle.battlelogic
{
   import com.arkadium.virmon.senseibattle.battlelogic.em.EMMaster;
   import com.arkadium.virmon.senseibattle.battlelogic.nanovor.BattleLogicNanovor;
   import com.smithandtinker.nanovor.common.utils.FastCipher;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class AssetDataLoader
   {
      
      private static var MASTER_EM_LIST:Array;
      
      private var masterNanovorDataURL:String;
      
      private var bankAssetsDataURI:String;
      
      private var bankAssetsDataURL:String;
      
      private var bankAccountDataURI:String;
      
      private var bankAccountDataURL:String;
      
      private var masterEmsDataURL:String;
      
      private var virmonMasterValueURL:String;
      
      private var bankBadgesDataURI:String;
      
      private var bankBadgesDataURL:String;
      
      public function AssetDataLoader()
      {
         super();
      }
      
      public function setBankAssetsDataURI(param1:String) : void
      {
         this.bankAssetsDataURI = param1;
      }
      
      private function ioError(param1:IOErrorEvent) : void
      {
         logError("there was an IO error: " + param1.text);
      }
      
      public function loadMasterData() : void
      {
         log("loadMasterData");
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,masterDataLoaded);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,ioError);
         var _loc2_:URLRequest = new URLRequest(masterNanovorDataURL);
         _loc1_.load(_loc2_);
      }
      
      public function setBankAssetsDataURL(param1:String) : void
      {
         this.bankAssetsDataURL = param1;
      }
      
      private function emMasterLoaded(param1:Event) : void
      {
         var _loc5_:EMMaster = null;
         log("emMasterLoaded");
         MASTER_EM_LIST = new Array();
         var _loc2_:XML = new XML(URLLoader(param1.currentTarget).data);
         var _loc3_:XMLList = _loc2_.child("em");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length())
         {
            _loc5_ = new EMMaster();
            _loc5_.parseEM(_loc3_[_loc4_]);
            MASTER_EM_LIST.push(_loc5_);
            _loc4_++;
         }
      }
      
      public function setMasterNanovorDataURL(param1:String) : void
      {
         this.masterNanovorDataURL = param1;
      }
      
      public function setBankAccountDataURL(param1:String) : void
      {
         this.bankAccountDataURL = param1;
      }
      
      private function masterDataLoaded(param1:Event) : void
      {
         var _loc7_:BattleLogicNanovor = null;
         log("Master data is loaded");
         var _loc2_:Array = new Array();
         var _loc3_:String = URLLoader(param1.currentTarget).data as String;
         if(_loc3_.indexOf("<virmon-master") == -1)
         {
            _loc3_ = FastCipher.decode(_loc3_);
         }
         var _loc4_:XML = Utils.StripXmlNamespace(new XML(_loc3_));
         var _loc5_:XMLList = _loc4_.child("virmon");
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length())
         {
            _loc7_ = new BattleLogicNanovor();
            _loc7_.parseNanovor(_loc5_[_loc6_]);
            _loc2_.push(_loc7_);
            log("Nano to push: " + _loc7_.toString());
            _loc6_++;
         }
         BattleLogic.MASTER_NANOVOR_LIST = _loc2_;
      }
      
      public function setBankAccountDataURI(param1:String) : void
      {
         this.bankAccountDataURI = param1;
      }
      
      public function setMasterEmsDataURL(param1:String) : void
      {
         this.masterEmsDataURL = param1;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** <<AssetDataLoader>>\t" + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AssetDataLoader>>\t" + param1);
      }
      
      public function setVirmonMasterValueURL(param1:String) : void
      {
         this.virmonMasterValueURL = param1;
      }
      
      public function setBankBadgesDataURI(param1:String) : void
      {
         bankBadgesDataURI = param1;
      }
      
      public function setBankBadgesDataURL(param1:String) : void
      {
         bankBadgesDataURL = param1;
      }
   }
}

