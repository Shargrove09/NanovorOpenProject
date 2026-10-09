package com.arkadium.virmon.nanomall
{
   import com.arkadium.virmon.framework.asset.retriever.IBoosterAssetRetriever;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class BoosterItemDrag extends MovieClip
   {
      
      private var oCurBoosterData:IBoosterItemData;
      
      private const ITEM_POSITIONS:int = 6;
      
      private var aItems:Array;
      
      public function BoosterItemDrag()
      {
         super();
         useHandCursor = true;
         buttonMode = true;
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_DOWN,onDown,false,0,true);
         addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
         aItems = new Array();
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         startDrag();
         dispatchEvent(new Event("BOOSTER_DRAGITEM_DOWN"));
      }
      
      private function clearItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < aItems.length)
         {
            BoosterSelectItem(aItems[_loc1_]).destroy();
            removeChild(aItems[_loc1_]);
            _loc1_++;
         }
         aItems = new Array();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanoMallBoosterItemDrag: " + param1);
      }
      
      public function hideItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < aItems.length)
         {
            aItems[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         stopDrag();
         dispatchEvent(new Event("BOOSTER_DRAGITEM_UP"));
      }
      
      public function init(param1:IBoosterItemData, param2:IBoosterAssetRetriever) : void
      {
         clearItems();
         oCurBoosterData = param1;
         makeItems(param2);
      }
      
      private function makeItems(param1:IBoosterAssetRetriever) : void
      {
         var _loc3_:BoosterSelectItem = null;
         var _loc2_:int = 1;
         while(_loc2_ <= ITEM_POSITIONS)
         {
            _loc3_ = new BoosterSelectItem(oCurBoosterData,_loc2_,param1.getBoosterPackIconURL(oCurBoosterData.id,_loc2_).url);
            addChild(_loc3_);
            aItems.push(_loc3_);
            _loc3_.visible = false;
            _loc2_++;
         }
      }
      
      public function showItem(param1:int) : void
      {
         hideItems();
         aItems[param1 - 1].visible = true;
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
         removeEventListener(MouseEvent.MOUSE_UP,onUp);
         clearItems();
      }
   }
}

