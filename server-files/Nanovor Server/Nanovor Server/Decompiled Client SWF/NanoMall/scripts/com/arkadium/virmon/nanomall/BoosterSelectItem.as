package com.arkadium.virmon.nanomall
{
   import com.arkadium.virmon.common.CustomEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol164")]
   public class BoosterSelectItem extends MovieClip
   {
      
      public var mcChip:MovieClip;
      
      private var bDisabled:Boolean = false;
      
      private var oCurBoosterData:IBoosterItemData;
      
      public var txPrice:TextField;
      
      public var iPos:int;
      
      private var chipLoader:Loader;
      
      public function BoosterSelectItem(param1:IBoosterItemData, param2:int, param3:String)
      {
         super();
         oCurBoosterData = param1;
         iPos = param2;
         setPrice();
         loadChip(param3);
         useHandCursor = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
      }
      
      public function enable() : void
      {
         useHandCursor = true;
         bDisabled = false;
      }
      
      private function setPrice() : void
      {
         txPrice.text = oCurBoosterData.price;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanoMallBoosterSelectItem: " + param1);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
      }
      
      private function loadChip(param1:String) : void
      {
         var request:URLRequest;
         var packIconURL:String = param1;
         chipLoader = new Loader();
         chipLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onChipLoadSuccess,false,0,true);
         chipLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onChipLoadError,false,0,true);
         request = new URLRequest(packIconURL);
         try
         {
            chipLoader.load(request);
         }
         catch(error:Error)
         {
            logError("loadChip(): " + error.message);
         }
         mcChip.addChild(chipLoader);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!bDisabled)
         {
            _loc2_ = new Object();
            _loc2_.pos = iPos;
            dispatchEvent(new CustomEvent("BOOSTERSELECTITEM_UP",_loc2_,true));
         }
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(!bDisabled)
         {
            _loc2_ = new Object();
            _loc2_.pos = iPos;
            _loc2_.mouseX = this.mouseX;
            _loc2_.mouseY = this.mouseY;
            dispatchEvent(new CustomEvent("BOOSTERSELECTITEM_DOWN",_loc2_,true));
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanoMallBoosterSelectItem: " + param1);
      }
      
      public function disable() : void
      {
         useHandCursor = false;
         bDisabled = true;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
      }
      
      private function onChipLoadSuccess(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,onChipLoadSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,onChipLoadError);
         dispatchEvent(new Event("CHIP_LOAD_SUCCESS"));
      }
      
      private function onChipLoadError(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,onChipLoadSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,onChipLoadError);
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,onOver);
         removeEventListener(MouseEvent.MOUSE_OUT,onOut);
         removeEventListener(MouseEvent.MOUSE_UP,onUp);
         removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
      }
   }
}

