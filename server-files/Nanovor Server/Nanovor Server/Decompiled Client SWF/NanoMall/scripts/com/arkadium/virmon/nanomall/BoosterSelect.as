package com.arkadium.virmon.nanomall
{
   import caurina.transitions.*;
   import com.arkadium.virmon.framework.asset.retriever.IBoosterAssetRetriever;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol295")]
   public class BoosterSelect extends MovieClip
   {
      
      private const ICON_X_MIN:int = 49;
      
      private var oCurBoosterData:IBoosterItemData;
      
      public var mcItems:MovieClip;
      
      private const SHIELD_UP_Y:int = -298;
      
      private const SHIELD_DOWN_Y:int = 46;
      
      private const ICON_Y:int = 60;
      
      private const ICON_X_SPAN:int = 320;
      
      public var mcBG:MovieClip;
      
      private const ITEM_POSITIONS:int = 6;
      
      public var mcShield:MovieClip;
      
      private var iconLoader:Loader;
      
      public var mcIcon:MovieClip;
      
      public var txTitle:TextField;
      
      private var aItems:Array;
      
      public var mcBackBtn:BackBtn;
      
      public function BoosterSelect()
      {
         super();
         mcBackBtn.visible = false;
         aItems = new Array();
      }
      
      public function disbleBackBtn() : void
      {
         mcBackBtn.disable();
      }
      
      public function replenishItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < ITEM_POSITIONS)
         {
            showItem(_loc1_ + 1);
            _loc1_++;
         }
      }
      
      private function clearItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < aItems.length)
         {
            aItems[_loc1_].destroy();
            Utils.clearAllChildren(aItems[_loc1_]);
            mcItems.removeChild(aItems[_loc1_]);
            _loc1_++;
         }
         aItems = new Array();
      }
      
      public function initBoosterSelect(param1:IBoosterItemData, param2:IBoosterAssetRetriever) : void
      {
         oCurBoosterData = param1;
         txTitle.text = oCurBoosterData.name;
         loadBoosterFamilyIcon();
         makeItems(param2);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanoMallBoosterSelect: " + param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanoMallBoosterSelect: " + param1);
      }
      
      public function disableItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < ITEM_POSITIONS)
         {
            aItems[_loc1_].disable();
            _loc1_++;
         }
         Tweener.addTween(mcShield,{
            "y":SHIELD_DOWN_Y,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
      
      private function alignItem(param1:Event) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.target);
         var _loc3_:MovieClip = mcItems["mcDock" + param1.target.iPos];
         _loc2_.x = _loc3_.x + (_loc3_.width - _loc2_.width) / 2;
         _loc2_.y = _loc3_.y + (_loc3_.height - _loc2_.height) / 2;
      }
      
      public function hideBackBtn() : void
      {
         Tweener.addTween(mcBackBtn,{
            "alpha":0,
            "time":0.25,
            "transition":"easeOutQuad",
            "onComplete":function():*
            {
               mcBackBtn.visible = false;
            }
         });
      }
      
      public function areItemsExhausted() : Boolean
      {
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < ITEM_POSITIONS)
         {
            if(Boolean(aItems[_loc2_].visible))
            {
               _loc1_ = false;
               break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function loadBoosterFamilyIcon() : void
      {
         if(iconLoader != null)
         {
            iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onIconLoadSuccess);
            iconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIconLoadError);
            mcIcon.removeChild(iconLoader);
            iconLoader.unload();
         }
         iconLoader = new Loader();
         iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onIconLoadSuccess,false,0,true);
         iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIconLoadError,false,0,true);
         try
         {
            iconLoader.load(new URLRequest(oCurBoosterData.familyIconURL));
         }
         catch(error:Error)
         {
            logError("loadBoosterFamilyIcon(): " + error.message);
         }
         mcIcon.addChild(iconLoader);
      }
      
      private function onIconLoadError(param1:IOErrorEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,onIconLoadSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,onIconLoadError);
         logError("onIconLoadError(): " + param1.text);
      }
      
      private function onIconLoadSuccess(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(Event.COMPLETE,onIconLoadSuccess);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,onIconLoadError);
         iconLoader.x = ICON_X_MIN + (ICON_X_SPAN - iconLoader.width) / 2;
         iconLoader.y = ICON_Y;
      }
      
      public function showItem(param1:int) : void
      {
         aItems[param1 - 1].visible = true;
      }
      
      public function enableBackBtn() : void
      {
         mcBackBtn.enable();
      }
      
      public function hideItem(param1:int) : void
      {
         aItems[param1 - 1].visible = false;
      }
      
      public function showBackBtn() : void
      {
         mcBackBtn.alpha = 0;
         mcBackBtn.visible = true;
         Tweener.addTween(mcBackBtn,{
            "alpha":1,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
      
      private function makeItems(param1:*) : void
      {
         var _loc3_:BoosterSelectItem = null;
         clearItems();
         var _loc2_:int = 1;
         while(_loc2_ <= ITEM_POSITIONS)
         {
            _loc3_ = new BoosterSelectItem(oCurBoosterData,_loc2_,param1.getBoosterPackIconURL(oCurBoosterData.id,_loc2_).url);
            mcItems.addChild(_loc3_);
            _loc3_.addEventListener("CHIP_LOAD_SUCCESS",alignItem,false,0,true);
            aItems.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function destroy() : void
      {
         mcBackBtn.destroy();
         if(iconLoader != null)
         {
            if(iconLoader.contentLoaderInfo != null)
            {
               iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onIconLoadSuccess);
            }
            iconLoader.unload();
         }
         var _loc1_:int = 0;
         while(_loc1_ < aItems.length)
         {
            IEventDispatcher(aItems[_loc1_]).removeEventListener("CHIP_LOAD_SUCCESS",alignItem);
            _loc1_++;
         }
         clearItems();
      }
      
      public function enableItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < ITEM_POSITIONS)
         {
            aItems[_loc1_].enable();
            _loc1_++;
         }
         Tweener.addTween(mcShield,{
            "y":SHIELD_UP_Y,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
   }
}

