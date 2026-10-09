package com.arkadium.virmon.trade.ui.collections
{
   import com.arkadium.virmon.collectionmanager.*;
   import com.arkadium.virmon.framework.*;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.data.DataProvider;
   import com.arkadium.virmon.shared.elements.*;
   import com.arkadium.virmon.shared.events.ListEvent;
   import com.arkadium.virmon.shared.renders.TradeEmsRender;
   import com.arkadium.virmon.shared.renders.event.*;
   import com.arkadium.virmon.shared.ui.*;
   import com.arkadium.virmon.shared.utils.*;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.trade.TradingCart;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol173")]
   public class EmsCollection extends DragTileList
   {
      
      public static var EMS_CHECK:String = "EMS_CHECK";
      
      private var _iEms:int;
      
      private var _emAssetRetriever:IEMAssetRetriever;
      
      private var _cem:CEm;
      
      private var _cTradeEmsCell:TradeEmsRender;
      
      private var _emManager:IEMManager;
      
      public function EmsCollection()
      {
         super();
         cellRenderer = "com.arkadium.virmon.shared.renders.TradeEmsRender";
         path = "TradeChipEms";
         cellHeight = 100;
         cellWidth = 100;
         rowCount = 5;
         column = 2;
      }
      
      override protected function createDragItem(param1:String) : void
      {
      }
      
      override protected function changeLocation(param1:*) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:DataProvider = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         if(param1 is TradingCart)
         {
            if(param1.length < 9)
            {
               _loc2_ = _dataprovider.getItemAt(_iSelectIndex);
               _loc2_.em.setID(_oDragItem.data.em.getID());
               param1.addItem({
                  "id":_loc2_.em.getID(),
                  "mid":_loc2_.mid,
                  "em":_loc2_.em
               },TradingCart.EMS);
               _loc5_ = true;
            }
         }
         if(_loc5_)
         {
            dispatchEvent(new Event(EMS_CHECK));
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
      
      private function stopDragAnimation() : void
      {
         try
         {
            _rDragItem.stopAnimation();
         }
         catch(e:Error)
         {
            _rDragItem.addEventListener(CChipTradeEm.CHIP_LOADED,onEmChipLoadedStopDragAnimation,false,0,true);
         }
      }
      
      public function init(param1:IEMManager, param2:IEMAssetRetriever, param3:ISoundManager) : void
      {
         super.setSoundManager(param3);
         _emManager = param1;
         _emAssetRetriever = param2;
         _rDragItem = new CChipTradeEm(_emAssetRetriever,_emManager);
         _rDragItem.gotoAndStop(1);
         stopDragAnimation();
         _rDragItem.mouseEnabled = false;
      }
      
      override protected function onStopDrag(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         _mcParent.removeEventListener(MouseEvent.MOUSE_UP,onStopDrag);
         _mcParent.removeEventListener(MouseEvent.MOUSE_MOVE,onDrag);
         _mcParent.removeEventListener(MouseEvent.MOUSE_MOVE,onStartDrag);
         if(!_bMove)
         {
            _iSelectIndex = _iRollIndex;
            updateState(_oDragItem.data);
            return;
         }
         _loc2_ = _dataprovider.getItemAt(_iRollIndex);
         _oDragItem.item.stopDrag();
         var _loc3_:MovieClip = _oDragItem.item;
         _bMove = false;
         if(!changeLocation(_target))
         {
            _loc2_.id.push(_loc2_.em.getID());
            _loc2_.state = 1;
            _loc2_.count = _loc2_.em.count = _loc2_.id.length;
            updateState(_loc2_);
         }
         if(Boolean(_mcParent.contains))
         {
            _mcParent.removeChild(_oDragItem.item);
         }
         _rDragItem.clearImage();
         _iSelectIndex = -1;
         _oDragItem = null;
         _target = null;
      }
      
      override protected function onStartDrag(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         _iSelectIndex = _iRollIndex;
         _bMove = true;
         _loc2_ = _dataprovider.getItemAt(_iSelectIndex);
         _loc2_.id.pop();
         _loc2_.em.count = _loc2_.count = _loc2_.id.length;
         _dataprovider.replaceItemAt(_loc2_,_iSelectIndex);
         updateState(_loc2_);
         if(_loc2_.count == 0)
         {
            _loc2_.state = 3;
         }
         updateState(_loc2_);
         _oDragItem.data.em.count = 1;
         _oDragItem.item.setData(_oDragItem.data.em);
         _mcParent.addChild(_oDragItem.item);
         _mcParent.removeEventListener(MouseEvent.MOUSE_MOVE,onStartDrag);
         _mcParent.addEventListener(MouseEvent.MOUSE_MOVE,onDrag,false,0,true);
      }
      
      public function get em() : CEm
      {
         return _cem;
      }
      
      override public function get data() : *
      {
         return _oDragItem.data.em;
      }
      
      override protected function onSelectItem(param1:ListEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc7_:* = undefined;
         if(param1.item.state == 3)
         {
            return;
         }
         if(_bDragActive)
         {
            _loc2_ = _dataprovider.getItemAt(param1.index);
            _oDragItem = new Object();
            _loc3_ = param1.item.content;
            _loc4_ = _mcParent.mouseX - _loc3_.mouseX;
            _loc5_ = _mcParent.mouseY - _loc3_.mouseY;
            _oDragItem.setPoint = new Point(_loc4_,_loc5_);
            _data = CEm(param1.item.em);
            _data.setID(param1.item.id[param1.item.id.length - 1]);
            trace(" --- ",param1.item.id," --- ",_loc2_.count);
            _loc2_.em.count = _loc2_.count;
            updateState(_loc2_);
            _oDragItem.item = _rDragItem;
            _oDragItem.item.mouseEnabled = false;
            _oDragItem.item.mouseChildren = false;
            if(Boolean(_oDragItem.item._mcCellBack))
            {
               _oDragItem.item._mcCellBack.visible = false;
            }
            _oDragItem.item.x = _loc4_;
            _oDragItem.item.y = _loc5_;
            _loc6_ = {};
            for(_loc7_ in _loc2_)
            {
               _loc6_[_loc7_] = _loc2_[_loc7_];
            }
            _oDragItem.data = _loc6_;
            _oDragItem.item.clearImage();
            _oDragItem.item.setData(_data);
            _iRollIndex = param1.index;
            _mcParent.addEventListener(MouseEvent.MOUSE_MOVE,onStartDrag,false,0,true);
            _mcParent.addEventListener(MouseEvent.MOUSE_UP,onStopDrag,false,0,true);
         }
      }
      
      public function get selectedEms() : int
      {
         return _iEms;
      }
      
      override protected function onDrag(param1:MouseEvent) : void
      {
         super.onDrag(param1);
         if(_mcParent.mouseY > 600)
         {
            onStopDrag(null);
         }
      }
      
      private function onEmChipLoadedStopDragAnimation(param1:Event) : void
      {
         var e:Event = param1;
         _rDragItem.removeEventListener(CChipTradeEm.CHIP_LOADED,onEmChipLoadedStopDragAnimation);
         try
         {
            _rDragItem.stopAnimation();
         }
         catch(err:Error)
         {
            DebugLog.instance.error("** EmsCollection: onEmChipLoadedStopDragAnimation -- error: " + err.message);
         }
      }
      
      private function createEmsData(param1:int) : CEm
      {
         var _loc2_:EMMasterData = _emManager.getEMMasterData(param1);
         var _loc3_:CEm = new CEm();
         _loc3_.masterID = param1;
         if(Boolean(_loc2_))
         {
            _loc3_.shortName = _loc2_.getShortName();
            _loc3_.longName = _loc2_.getLongName();
            _loc3_.collectorID = _loc2_.getCollectorId();
            _loc3_.wave = _loc2_.getWave();
            _loc3_.rarity = _loc2_.getRarity();
            _loc3_.faction = _loc2_.getFaction();
         }
         return _loc3_;
      }
      
      override public function set dataProvider(param1:DataProvider) : *
      {
         var _loc3_:Object = null;
         var _loc4_:CEm = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.getItemAt(_loc2_);
            _loc4_ = createEmsData(_loc3_.mid);
            _loc4_.marketValue = _loc3_.val;
            _loc4_.setID(_loc3_.id[0]);
            _loc4_.count = _loc3_.count;
            _loc3_.em = _loc4_;
            _loc3_.family = _loc4_.faction;
            _loc3_.name = _loc4_.collectorID;
            _loc3_.rarity = _loc4_.rarity;
            _loc3_.rarityInt = _loc4_.rarityInt;
            _loc3_.mv = _loc4_.marketValue;
            _loc3_.owned = _loc3_.count;
            param1.replaceItemAt(_loc3_,_loc2_);
            _loc2_++;
         }
         super.dataProvider = param1;
      }
   }
}

