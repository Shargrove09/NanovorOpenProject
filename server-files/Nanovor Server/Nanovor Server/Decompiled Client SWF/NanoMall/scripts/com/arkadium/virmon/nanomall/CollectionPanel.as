package com.arkadium.virmon.nanomall
{
   import caurina.transitions.*;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol317")]
   public class CollectionPanel extends MovieClip
   {
      
      private var xCollectionData:XML;
      
      private const CHIP_HEIGHT:int = 100;
      
      private var iChipsOrigin:int;
      
      public var mcScrollBar:ScrollBar;
      
      private const ITEM_COLS:int = 3;
      
      private var iTotalItems:int;
      
      public var mcUI:CollectionPanelUI;
      
      public var mcChips:MovieClip;
      
      private var iEMCount:int;
      
      private const VIS_HEIGHT:int = 340;
      
      private var aEMs:Array;
      
      private var _emAssetRetriever:IEMAssetRetriever;
      
      private var aItems:Array;
      
      private var _virmonManager:IVirmonManager;
      
      private var aVirmons:Array;
      
      private var iVirmonCount:int;
      
      private var _emManager:IEMManager;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      private const CHIP_WIDTH:int = 100;
      
      private const ITEM_SPACING:int = 5;
      
      public function CollectionPanel()
      {
         super();
         addFrameScript(0,frame1,9,frame10,17,frame18);
         iChipsOrigin = mcChips.y;
         mcScrollBar.visible = false;
      }
      
      private function clearAllItems() : void
      {
         var _loc1_:DisplayObject = null;
         while(Boolean(mcChips.numChildren))
         {
            _loc1_ = mcChips.getChildAt(0);
            if(Boolean(_loc1_ as CollectionPanelItem))
            {
               (_loc1_ as CollectionPanelItem).destroy();
            }
            mcChips.removeChild(_loc1_);
         }
      }
      
      public function closeTabs() : void
      {
         gotoAndPlay("close");
      }
      
      public function init(param1:IVirmonManager, param2:ICharacterAssetRetriever, param3:IEMManager, param4:IEMAssetRetriever, param5:XML) : *
      {
         _virmonManager = param1;
         _characterAssetRetriever = param2;
         _emManager = param3;
         _emAssetRetriever = param4;
         xCollectionData = param5;
      }
      
      private function onEMComplete(param1:Event) : void
      {
         param1.target.removeEventListener(CollectionPanelItem.EM_LOAD_COMPLETE,onEMComplete);
         ++iEMCount;
         if(iEMCount < aEMs.length)
         {
            getEMItem();
         }
      }
      
      private function checkForScrollable() : void
      {
         mcScrollBar.visible = false;
         if(mcChips.height >= VIS_HEIGHT + 20)
         {
            mcScrollBar.visible = true;
            mcScrollBar.init(mcChips,VIS_HEIGHT);
         }
      }
      
      public function buildCollection() : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         aItems = new Array();
         aVirmons = new Array();
         aEMs = new Array();
         iVirmonCount = 0;
         iEMCount = 0;
         iTotalItems = int(xCollectionData.child("asset").length());
         var _loc1_:int = 0;
         while(_loc1_ < iTotalItems)
         {
            _loc2_ = String(xCollectionData.child("asset")[_loc1_].@id);
            _loc3_ = String(xCollectionData.child("asset")[_loc1_].child("asset-type-category")[0]);
            if(_loc3_ == "virmon")
            {
               aVirmons.push(_loc2_);
            }
            else if(_loc3_ == "em")
            {
               aEMs.push(_loc2_);
            }
            _loc1_++;
         }
         if(aVirmons.length > 0)
         {
            getVirmonItem();
         }
         else if(aEMs.length > 0)
         {
            getEMItem();
         }
      }
      
      private function onVirmonComplete(param1:Event) : void
      {
         param1.target.removeEventListener(CollectionPanelItem.VIRMON_LOAD_COMPLETE,onVirmonComplete);
         ++iVirmonCount;
         if(iVirmonCount < aVirmons.length)
         {
            getVirmonItem();
         }
         else if(aEMs.length > 0)
         {
            getEMItem();
         }
      }
      
      private function getVirmonItem() : void
      {
         var _loc1_:CollectionPanelItem = new CollectionPanelItem(_virmonManager,_characterAssetRetriever,_emManager,_emAssetRetriever,"virmon",aVirmons[iVirmonCount]);
         mcChips.addChild(_loc1_);
         aItems.push(_loc1_);
         _loc1_.visible = false;
         _loc1_.addEventListener(CollectionPanelItem.VIRMON_LOAD_COMPLETE,onVirmonComplete,false,0,true);
         _loc1_.load();
      }
      
      private function getEMItem() : void
      {
         var _loc1_:CollectionPanelItem = new CollectionPanelItem(_virmonManager,_characterAssetRetriever,_emManager,_emAssetRetriever,"em",aEMs[iEMCount]);
         mcChips.addChild(_loc1_);
         aItems.push(_loc1_);
         _loc1_.visible = false;
         _loc1_.addEventListener(CollectionPanelItem.EM_LOAD_COMPLETE,onEMComplete,false,0,true);
         _loc1_.load();
      }
      
      public function alignItems() : void
      {
         var _loc4_:ChipZap = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < aItems.length)
         {
            _loc4_ = new ChipZap();
            mcChips.addChild(_loc4_);
            aItems[_loc3_].x = _loc4_.x = _loc1_;
            aItems[_loc3_].y = _loc4_.y = _loc2_;
            aItems[_loc3_].alpha = 0;
            aItems[_loc3_].visible = true;
            Tweener.addTween(aItems[_loc3_],{
               "alpha":1,
               "time":0.5,
               "transition":"linear"
            });
            _loc1_ += CHIP_WIDTH + ITEM_SPACING;
            if(!((_loc3_ + 1) % ITEM_COLS))
            {
               _loc1_ = 0;
               _loc2_ += CHIP_HEIGHT + ITEM_SPACING;
            }
            _loc3_++;
         }
         checkForScrollable();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CollectionPanel: " + param1);
      }
      
      public function reset() : void
      {
         if(mcScrollBar.visible)
         {
            mcScrollBar.reset();
            mcScrollBar.visible = false;
         }
         mcChips.y = iChipsOrigin;
         clearAllItems();
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      public function enableUI() : void
      {
         mcUI.enable();
      }
      
      internal function frame18() : *
      {
         stop();
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function openTabs() : void
      {
         gotoAndPlay("open");
      }
      
      public function destroy() : void
      {
         var _loc1_:DisplayObject = null;
         mcUI.destroy();
         mcScrollBar.destroy();
         while(mcChips.numChildren > 0)
         {
            _loc1_ = mcChips.getChildAt(0);
            if(Boolean(_loc1_ as CollectionPanelItem))
            {
               (_loc1_ as CollectionPanelItem).destroy();
            }
            mcChips.removeChild(_loc1_);
         }
         aItems = new Array();
      }
      
      public function disableUI() : void
      {
         mcUI.disable();
      }
   }
}

