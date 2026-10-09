package com.arkadium.virmon.trade.ui.collections
{
   import com.arkadium.virmon.collectionmanager.*;
   import com.arkadium.virmon.framework.*;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.shared.data.DataProvider;
   import com.arkadium.virmon.shared.elements.*;
   import com.arkadium.virmon.shared.events.ListEvent;
   import com.arkadium.virmon.shared.renders.TradeVirmonRender;
   import com.arkadium.virmon.shared.renders.event.*;
   import com.arkadium.virmon.shared.ui.*;
   import com.arkadium.virmon.shared.utils.*;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.trade.TradingCart;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol176")]
   public class VirmonCollection extends DragTileList
   {
      
      public static var VIRMON_CHECK:String = "VIRMON_CHECK";
      
      private var _cTradeVirmonCell:TradeVirmonRender;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      public function VirmonCollection()
      {
         super();
         cellRenderer = "com.arkadium.virmon.shared.renders.TradeVirmonRender";
         path = "TradeChipVirmon";
         cellHeight = 100;
         cellWidth = 100;
         rowCount = 5;
         column = 2;
      }
      
      override protected function createDragItem(param1:String) : void
      {
         _rDragItem = new CChipTradeVirmon(_characterAssetRetriever);
         _rDragItem.gotoAndStop(1);
         _rDragItem.mouseEnabled = false;
      }
      
      public function set index(param1:int) : void
      {
         _iSelectIndex = param1;
      }
      
      override protected function changeLocation(param1:*) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Boolean = false;
         if(param1 is TradingCart && param1.length < 9)
         {
            _loc3_ = _dataprovider.getItemAt(_iSelectIndex);
            param1.addItem({"virmon":_loc3_.virmon},TradingCart.VIRMON);
            _loc2_ = true;
         }
         if(_loc2_)
         {
            dispatchEvent(new Event(VIRMON_CHECK));
            _iSelectIndex = -1;
            param1 = null;
            return true;
         }
         return false;
      }
      
      override public function updateState(param1:Object) : void
      {
         super.updateState(param1);
         if(Boolean(param1) && Boolean(param1.content))
         {
            param1.content.update();
         }
      }
      
      override protected function onSelectItem(param1:ListEvent) : void
      {
         _rDragItem = new CChipTradeVirmon(_characterAssetRetriever);
         super.onSelectItem(param1);
      }
      
      override protected function onDrag(param1:MouseEvent) : void
      {
         super.onDrag(param1);
         if(_mcParent.mouseY > 600)
         {
            _oDragItem.item.y = 600 - _oDragItem.item.height / 2;
         }
      }
      
      override public function set dataProvider(param1:DataProvider) : *
      {
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.getItemAt(_loc2_);
            if(Boolean(_loc3_.virmon))
            {
               _loc3_.speed = _loc3_.virmon.getSpeed();
               _loc3_.strength = _loc3_.virmon.getStrength();
               _loc3_.armor = _loc3_.virmon.getArmor();
               _loc3_.health = _loc3_.virmon.getHealth();
               _loc3_.sv = _loc3_.virmon.getSV();
               _loc3_.name = _loc3_.virmon.getName();
               _loc3_.family = _loc3_.virmon.getFaction();
               _loc3_.mv = _loc3_.virmon.getMarketValue();
               if(!_loc3_.state || _loc3_.state == undefined)
               {
                  _loc3_.state = 1;
               }
            }
            param1.replaceItemAt(_loc3_,_loc2_);
            _loc2_++;
         }
         super.dataProvider = param1;
      }
      
      public function init(param1:ICharacterAssetRetriever, param2:ISoundManager) : void
      {
         super.setSoundManager(param2);
         _characterAssetRetriever = param1;
      }
   }
}

