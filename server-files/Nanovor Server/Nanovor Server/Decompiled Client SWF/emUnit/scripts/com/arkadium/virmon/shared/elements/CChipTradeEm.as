package com.arkadium.virmon.shared.elements
{
   import com.arkadium.virmon.common.Logger;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.asset.enum.EMAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.utils.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.URLRequest;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol27")]
   public class CChipTradeEm extends MovieClip implements IChipDrawable
   {
      
      public static var DESTROY:String = "destroy";
      
      public static const CHIP_LOADED:String = "cChipTradeEmLoaded";
      
      private var _masterEm:EMMasterData;
      
      private var _cem:CEm;
      
      private var _mid:int;
      
      public var _smcUnitBg:MovieClip;
      
      private var _nMarketValue:Number = 0;
      
      private var _ldr:Loader;
      
      public var _mcHolder:MovieClip;
      
      public var _mcCellBack:MovieClip;
      
      private var _emAssetRetriever:IEMAssetRetriever;
      
      private var _id:int;
      
      public var _spContent:MovieClip;
      
      private var _emManager:IEMManager;
      
      public var _sbtUnit:SimpleButton;
      
      private var _numOfEms:int = 1;
      
      private var _sAssetID:String;
      
      public function CChipTradeEm(param1:IEMAssetRetriever, param2:IEMManager)
      {
         super();
         addFrameScript(0,frame1);
         if(param1 == null)
         {
            logError("CChipTradeEm(): emAssetRetriever = null \n" + new Error("JUST A STACK TRACE").getStackTrace());
         }
         _emAssetRetriever = param1;
         _emManager = param2;
         stop();
         _smcUnitBg.stop();
         onUpdateDisplayList();
      }
      
      public function get num() : int
      {
         return _numOfEms;
      }
      
      public function hideBG() : void
      {
         _mcCellBack.visible = false;
      }
      
      public function clearImage() : void
      {
         try
         {
            if(_spContent && _ldr && _spContent.contains(_ldr))
            {
               _spContent.removeChild(_ldr);
            }
            _ldr.unload();
            _ldr = null;
         }
         catch(e:*)
         {
         }
      }
      
      public function showBG() : void
      {
         _mcCellBack.visible = true;
      }
      
      public function get marketValue() : Number
      {
         return _nMarketValue;
      }
      
      public function set num(param1:int) : *
      {
         _cem.count = param1;
         onUpdateDisplayList();
      }
      
      private function initTextField() : void
      {
         _masterEm = _emManager.getEMMasterData(_mid);
         _smcUnitBg._stfNum.text = String(_cem.count);
         _smcUnitBg._stfMarketValue.text = "MV $ " + String(_cem.marketValue);
         _smcUnitBg._stfRary.text = Boolean(_masterEm) ? String(_masterEm.getRarity()).toUpperCase() : "";
         _smcUnitBg._stfWave.text = Boolean(_masterEm) ? "W" + String(_masterEm.getWave()).toUpperCase() : "";
         _smcUnitBg._stfLongName.text = Boolean(_masterEm) ? String(_masterEm.getLongName()).toUpperCase() : "";
         _smcUnitBg._stfShortName.text = Boolean(_masterEm) ? String(_masterEm.getShortName()).toUpperCase() : "";
         _smcUnitBg._stfName.text = Boolean(_masterEm) ? String(_masterEm.getCollectorId()) : "";
         if(Boolean(_masterEm))
         {
            _smcUnitBg.gotoAndStop(String(_masterEm.getFaction()));
         }
      }
      
      public function getId() : int
      {
         return _id;
      }
      
      public function stopAnimation() : void
      {
         Utils.stopAllChildren(_ldr.contentLoaderInfo.content);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CChipTradeEm: " + param1);
      }
      
      public function set marketValue(param1:Number) : *
      {
         _nMarketValue = param1;
         onUpdateDisplayList();
      }
      
      public function setData(param1:*, ... rest) : void
      {
         _cem = CEm(param1);
         _id = _cem.getID();
         if(Boolean(_ldr))
         {
            clearImage();
         }
         onUpdateDisplayList();
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onLoadErrorAvatar);
         param1.target.removeEventListener(Event.COMPLETE,onLoadComplete);
         while(_spContent.numChildren != 0)
         {
            _spContent.removeChildAt(0);
         }
         if(Boolean(_ldr))
         {
            _spContent.addChild(_ldr);
         }
         dispatchEvent(new Event(CHIP_LOADED));
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CChipTradeEm: " + param1);
      }
      
      public function update() : void
      {
         onUpdateDisplayList();
      }
      
      protected function onUpdateDisplayList() : void
      {
         var szURL:String = null;
         _smcUnitBg._stfNum.text = Boolean(_cem) ? String(_cem.count) : "?";
         _smcUnitBg._stfMarketValue.text = Boolean(_cem) ? "MV $ " + String(_cem.marketValue) : "MV $0";
         _smcUnitBg._stfRary.text = Boolean(_cem) ? String(_cem.rarity).toUpperCase() : "?";
         _smcUnitBg._stfWave.text = Boolean(_cem) ? "W" + String(_cem.wave).toUpperCase() : "W0";
         _smcUnitBg._stfLongName.text = Boolean(_cem) ? String(_cem.longName).toUpperCase() : "?";
         _smcUnitBg._stfShortName.text = Boolean(_cem) ? String(_cem.shortName).toUpperCase() : "?";
         _smcUnitBg._stfName.text = Boolean(_cem) ? String(_cem.collectorID) : "?";
         if(Boolean(_cem))
         {
            _smcUnitBg.gotoAndStop(String(_cem.faction));
         }
         else
         {
            _smcUnitBg.gotoAndStop(1);
         }
         if(Boolean(_cem) && _cem.masterID > 0)
         {
            szURL = _emAssetRetriever.getEMURL(EMAssetType.CHIP_ICON,_cem.masterID).url;
            _ldr = new Loader();
            _ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadErrorAvatar,false,0,true);
            _ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete,false,0,true);
            try
            {
               _ldr.load(new URLRequest(szURL));
            }
            catch(e:Error)
            {
               logError("onUpdateDisplayList - caught error: " + e.message);
            }
         }
      }
      
      private function onLoadErrorAvatar(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onLoadErrorAvatar);
         param1.target.removeEventListener(Event.COMPLETE,onLoadComplete);
         logError("onLoadErrorAvatar :: " + param1.text);
         trace(" :: EM AVATAR :: image not found! :: (" + param1 + ")");
         Logger.debug(" :: EM AVATAR :: image not found! :: (" + param1 + ")");
      }
      
      public function clone() : MovieClip
      {
         return MovieClip(this);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function getMasterID() : int
      {
         return _mid;
      }
      
      public function destroy() : void
      {
         _smcUnitBg.stop();
         _spContent.stop();
         try
         {
            _ldr.close();
            _ldr.unload();
            _spContent.removeChild(_ldr);
            _ldr = null;
         }
         catch(e:*)
         {
         }
         Utils.clearAllChildren(this);
         dispatchEvent(new Event(DESTROY));
      }
      
      public function getEM() : CEm
      {
         return _cem;
      }
   }
}

