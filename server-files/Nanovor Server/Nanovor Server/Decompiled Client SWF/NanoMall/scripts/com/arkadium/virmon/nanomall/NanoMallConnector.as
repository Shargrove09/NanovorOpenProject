package com.arkadium.virmon.nanomall
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   
   public class NanoMallConnector extends MovieClip
   {
      
      private var _accountID:String;
      
      private const SKU_URL:String = "/bankfe/resources/retail?auth=";
      
      private const ACCOUNT_URL:String = "/bankfe/resources/account/[ACCOUNT_ID]?auth=";
      
      private var urlLoader:URLLoader;
      
      private var _sSessionTicket:String;
      
      private const BUY_SKU_URL:String = "/bankfe/resources/retail/[SKU_ID]?auth=";
      
      private var _sBankURLRead:String;
      
      private var _sBankURL:String;
      
      public function NanoMallConnector(param1:String, param2:String, param3:String, param4:String)
      {
         super();
         _sBankURL = param1;
         _sBankURLRead = param2;
         _sSessionTicket = param3;
         _accountID = param4;
      }
      
      public function getUserData() : void
      {
         var _loc1_:Array = ACCOUNT_URL.split("[ACCOUNT_ID]");
         var _loc2_:String = _loc1_[0] + _accountID + _loc1_[1] + _sSessionTicket;
         var _loc3_:URLRequest = new URLRequest(encodeURI(Utils.appendKillCache(_sBankURLRead + _loc2_)));
         urlLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,onUserDataComplete,false,0,true);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onUserDataError,false,0,true);
         urlLoader.load(_loc3_);
      }
      
      private function onBuySKUComplete(param1:Event) : void
      {
         urlLoader.removeEventListener(Event.COMPLETE,onBuySKUComplete);
         urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onBuySKUError);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         dispatchEvent(new CustomEvent("BUY_SKU_SUCCESS",_loc2_));
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> SKUConnector: " + param1);
      }
      
      private function onUserDataError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new Event("USER_DATA_ERROR"));
      }
      
      private function onSKUComplete(param1:Event) : void
      {
         urlLoader.removeEventListener(Event.COMPLETE,onSKUComplete);
         urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onSKUError);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         dispatchEvent(new CustomEvent("SKU_SUCCESS",_loc2_));
      }
      
      public function getSKUs() : void
      {
         var _loc1_:URLRequest = new URLRequest(encodeURI(Utils.appendKillCache(_sBankURLRead + SKU_URL + _sSessionTicket)));
         urlLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,onSKUComplete,false,0,true);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onSKUError,false,0,true);
         urlLoader.load(_loc1_);
      }
      
      private function onUserDataComplete(param1:Event) : void
      {
         urlLoader.removeEventListener(Event.COMPLETE,onUserDataComplete);
         urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onUserDataError);
         var _loc2_:XML = XML(param1.target.data);
         _loc2_ = Utils.StripXmlNamespace(_loc2_);
         dispatchEvent(new CustomEvent("USER_DATA_SUCCESS",_loc2_));
      }
      
      private function onSKUError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new Event("SKU_ERROR"));
      }
      
      private function onBuySKUError(param1:Event) : void
      {
         urlLoader.removeEventListener(Event.COMPLETE,onBuySKUComplete);
         urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,onBuySKUError);
         dispatchEvent(new Event("BUY_SKU_ERROR"));
      }
      
      public function buySKU(param1:Object) : void
      {
         var _loc2_:Array = BUY_SKU_URL.split("[SKU_ID]");
         var _loc3_:String = _sBankURL + _loc2_[0] + param1.id + _loc2_[1] + _sSessionTicket;
         var _loc4_:URLVariables = new URLVariables();
         _loc4_.auth = _sSessionTicket;
         var _loc5_:URLRequest = new URLRequest(encodeURI(Utils.appendKillCache(_loc3_)));
         _loc5_.contentType = "application/xml";
         _loc5_.method = URLRequestMethod.POST;
         _loc5_.data = _loc4_;
         urlLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,onBuySKUComplete,false,0,true);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onBuySKUError,false,0,true);
         urlLoader.load(_loc5_);
      }
   }
}

