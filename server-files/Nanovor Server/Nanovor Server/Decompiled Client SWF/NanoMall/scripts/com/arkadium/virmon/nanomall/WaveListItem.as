package com.arkadium.virmon.nanomall
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol161")]
   public class WaveListItem extends MovieClip
   {
      
      private var _boosterItemData:IBoosterItemData;
      
      private const ICON_X:int = 26;
      
      private const ICON_Y:int = 32;
      
      public var mcBG:MovieClip;
      
      public var mcBuyBtn:BuyBtn;
      
      public var txName:TextField;
      
      private var iconLoader:Loader;
      
      public var mcNanoCash:MovieClip;
      
      public function WaveListItem(param1:IBoosterItemData)
      {
         super();
         _boosterItemData = param1;
         loadIcon();
         setName();
         setPrice();
         mcBuyBtn.addEventListener("BUYBTN_CLICK",onBuyBtnClick);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanoMallWaveListItem: " + param1);
      }
      
      private function setPrice() : void
      {
         mcNanoCash.mcGlow.txPrice.text = _boosterItemData.price;
      }
      
      private function setName() : void
      {
         txName.text = _boosterItemData.name;
      }
      
      private function onBuyBtnClick(param1:Event) : void
      {
         dispatchEvent(new BoosterItemEvent(BoosterItemEvent.WAVELIST_BUYBTN_CLICK,_boosterItemData,true));
      }
      
      private function onIconLoadSuccess(param1:Event) : void
      {
         iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onIconLoadSuccess);
         iconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIconLoadError);
      }
      
      private function onIconLoadError(param1:IOErrorEvent) : void
      {
         iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onIconLoadSuccess);
         iconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIconLoadError);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanoMallWaveListItem: " + param1);
      }
      
      public function destroy() : void
      {
         mcBuyBtn.removeEventListener("BUYBTN_CLICK",onBuyBtnClick);
         mcBuyBtn.destroy();
      }
      
      private function loadIcon() : void
      {
         var request:URLRequest;
         iconLoader = new Loader();
         iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onIconLoadSuccess);
         iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIconLoadError);
         request = new URLRequest(_boosterItemData.familyIconURL);
         try
         {
            iconLoader.load(request);
         }
         catch(error:Error)
         {
            logError("loadIcon(): " + error.message);
         }
         addChild(iconLoader);
         iconLoader.x = ICON_X;
         iconLoader.y = ICON_Y;
      }
   }
}

