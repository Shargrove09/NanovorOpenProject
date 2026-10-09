package com.arkadium.virmon.trade
{
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.asset.retriever.ICharacterAssetRetriever;
   import com.arkadium.virmon.framework.asset.retriever.IEMAssetRetriever;
   import com.arkadium.virmon.shared.data.DataProvider;
   import com.arkadium.virmon.shared.elements.*;
   import com.arkadium.virmon.shared.renders.*;
   import com.arkadium.virmon.shared.ui.*;
   import com.arkadium.virmon.shared.utils.*;
   import com.arkadium.virmon.trade.ui.collections.EmsCollection;
   import com.arkadium.virmon.trade.ui.collections.VirmonCollection;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.utils.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol179")]
   public class TradingCart extends MovieClip
   {
      
      public static var REMOVE_VIRMON:String = "REMOVE_VIRMON";
      
      public static var REMOVE_EMS:String = "REMOVE_EMS";
      
      public static var VIRMON:String = "VIRMON";
      
      public static var EMS:String = "EMS";
      
      private var _iEmsMID:int;
      
      private var _baVirmon:ByteArray;
      
      private var _iCntVirmon:int = 0;
      
      private var _baEms:ByteArray;
      
      private var _ldrEms:Loader;
      
      private var _cem:CEm;
      
      private var _bDragActive:Boolean = true;
      
      private var _mcSelectedItem:*;
      
      private var _iCntEms:int = 0;
      
      private var _cVrm:IVirmon;
      
      private var _ldrVirmon:Loader;
      
      public var _target:*;
      
      private var _ulEms:URLLoader;
      
      private var _mcDragItem:MovieClip;
      
      private var _ldrDragItem:Loader;
      
      private var _iCount:int = 0;
      
      private var _sType:String;
      
      private var _bMove:Boolean = false;
      
      private var _arEmsLoader:Array = [];
      
      private var _arEms:Array = [];
      
      private var _iEmsID:*;
      
      private var _ulVirmon:URLLoader;
      
      private var _emAssetRetriever:IEMAssetRetriever;
      
      private var _emManager:IEMManager;
      
      private var _arVirmonLoader:Array = [];
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      private var _arVirmon:Array = [];
      
      private var _oDragItem:Object;
      
      public function TradingCart()
      {
         super();
      }
      
      public function destroy() : void
      {
         var i:int = 0;
         i = 0;
         while(i < _arVirmon.length)
         {
            _arVirmon[i].removeEventListener(MouseEvent.MOUSE_DOWN,onVirmonSelect);
            CChipTradeVirmon(_arVirmon[i]).destroy();
            removeChild(_arVirmon[i]);
            _arVirmon[i] = null;
            i++;
         }
         i = 0;
         while(i < _arEms.length)
         {
            _arEms[i].removeEventListener(MouseEvent.MOUSE_DOWN,onEmsSelect);
            CChipTradeEm(_arEms[i]).destroy();
            removeChild(_arEms[i]);
            _arEms[i] = null;
            i++;
         }
         _arVirmon = [];
         _arEms = [];
         try
         {
            i = 0;
            while(i < 9)
            {
               _arVirmonLoader[i].close();
               _arVirmonLoader[i].unload();
               _arVirmonLoader[i] = null;
               _arEmsLoader[i].close();
               _arEmsLoader[i].unload();
               _arEmsLoader[i] = null;
               i++;
            }
            _ldrVirmon.close();
            _ldrVirmon.unload();
            _ldrVirmon = null;
            _ldrEms.close();
            _ldrEms.unload();
            _ldrEms = null;
            _ldrDragItem.close();
            _ldrDragItem.unload();
            _ldrDragItem = null;
         }
         catch(e:*)
         {
         }
         try
         {
            _ulVirmon.close();
            _ulEms.close();
         }
         catch(e:*)
         {
         }
         _baEms = null;
         _baVirmon = null;
      }
      
      protected function changeLocation(param1:*) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:DataProvider = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         if(param1 is VirmonCollection && _sType == VIRMON)
         {
            _loc3_ = param1.dataProvider;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = _loc3_.getItemAt(_loc4_);
               if(_loc2_.virmon.getID() == _oDragItem.data.getID())
               {
                  _loc2_.state = 1;
                  VirmonCollection(param1).updateState(_loc2_);
                  _loc5_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         if(param1 is EmsCollection && _sType == EMS)
         {
            _loc3_ = param1.dataProvider;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = _loc3_.getItemAt(_loc4_);
               if(CEm(_loc2_.em).masterID == CEm(_oDragItem.data).masterID)
               {
                  _loc2_.state = 1;
                  _loc2_.id.push(_oDragItem.data.getID());
                  _loc2_.em.count = _loc2_.count = _loc2_.id.length;
                  _loc3_.replaceItemAt(_loc2_,_loc4_);
                  EmsCollection(param1).updateState(_loc2_);
                  _loc5_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         if(_loc5_)
         {
            dispatchEvent(new Event("REMOVE_" + _sType));
            parent.parent.removeChild(_oDragItem.item);
            param1 = null;
            _bMove = false;
            _sType = "";
            return true;
         }
         return false;
      }
      
      private function onEmsSelect(param1:MouseEvent) : void
      {
         if(isDragActive)
         {
            _mcSelectedItem = param1.currentTarget;
            _sType = EMS;
            onCreateItem(param1.currentTarget,_sType);
         }
      }
      
      private function onStopDragItem(param1:MouseEvent) : void
      {
         parent.parent.removeEventListener(MouseEvent.MOUSE_MOVE,onDragItem);
         parent.parent.removeEventListener(MouseEvent.MOUSE_MOVE,onDrag);
         parent.parent.removeEventListener(MouseEvent.MOUSE_UP,onStopDragItem);
         if(_bMove)
         {
            if(changeLocation(_target))
            {
               return;
            }
            switch(_sType)
            {
               case VIRMON:
                  addItem({"virmon":_oDragItem.data},_sType);
                  break;
               case EMS:
                  addItem({"em":_oDragItem.data},_sType);
            }
         }
         if(parent.parent.contains(_oDragItem.item))
         {
            parent.parent.removeChild(_oDragItem.item);
         }
         _oDragItem = null;
         _target = null;
         _bMove = false;
         _sType = "";
      }
      
      public function init(param1:ICharacterAssetRetriever, param2:IEMAssetRetriever, param3:IEMManager) : void
      {
         _characterAssetRetriever = param1;
         _emAssetRetriever = param2;
         _emManager = param3;
         _arVirmon = [];
         _arEms = [];
         var _loc4_:int = 0;
         while(_loc4_ < 10)
         {
            _arVirmon[_loc4_] = new CChipTradeVirmon(_characterAssetRetriever);
            _arVirmon[_loc4_]._mcCellBack.visible = false;
            _arVirmon[_loc4_].visible = false;
            _arVirmon[_loc4_].x = _loc4_ % 3 * _arVirmon[_loc4_]._mcHolder.width;
            _arVirmon[_loc4_].y = int(_loc4_ / 3) * (_arVirmon[_loc4_]._mcHolder.height + 5);
            _arVirmon[_loc4_].addEventListener(MouseEvent.CLICK,onSelect,false,0,true);
            _arEms[_loc4_] = new CChipTradeEm(_emAssetRetriever,_emManager);
            _arEms[_loc4_].hideBG();
            _arEms[_loc4_].visible = false;
            _arEms[_loc4_].x = _loc4_ % 3 * _arEms[_loc4_]._mcHolder.width;
            _arEms[_loc4_].y = int(_loc4_ / 3) * (_arEms[_loc4_]._mcHolder.height + 5);
            addChild(_arEms[_loc4_]);
            addChild(_arVirmon[_loc4_]);
            _loc4_++;
         }
      }
      
      public function get isMove() : Boolean
      {
         return _bMove;
      }
      
      public function get isDragActive() : Boolean
      {
         return _bDragActive;
      }
      
      public function get data() : *
      {
         return _oDragItem.data;
      }
      
      public function removeItem(param1:String, param2:String) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < 9)
         {
            switch(param2)
            {
               case VIRMON:
                  if(_arVirmon[_loc3_].getId() == param1)
                  {
                     _arVirmon[_loc3_].visible = false;
                     _arVirmon[_loc3_].removeEventListener(MouseEvent.MOUSE_DOWN,onVirmonSelect);
                  }
                  break;
               case EMS:
                  if(_arEms[_loc3_].getId() == param1)
                  {
                     _arEms[_loc3_].visible = false;
                     _arEms[_loc3_].removeEventListener(MouseEvent.MOUSE_DOWN,onEmsSelect);
                     _arEms[_loc3_].removeEventListener(CChipTradeEm.CHIP_LOADED,onEmChipLoadedStopAnimation);
                  }
            }
            _loc3_++;
         }
         --_iCount;
      }
      
      private function onSelect(param1:MouseEvent) : void
      {
         parent.parent.removeEventListener(MouseEvent.MOUSE_MOVE,onDragItem);
         if(!_oDragItem)
         {
            _oDragItem = new Object();
         }
         _oDragItem.data = param1.currentTarget.getVirmon();
         dispatchEvent(new Event(DragTileList.SELECT_VIRMON));
      }
      
      public function get type() : String
      {
         return _sType;
      }
      
      public function set isDragActive(param1:Boolean) : void
      {
         _bDragActive = param1;
      }
      
      public function get length() : int
      {
         return _iCount;
      }
      
      private function onEmChipLoadedStopAnimation(param1:Event) : void
      {
         var e:Event = param1;
         e.target.removeEventListener(CChipTradeEm.CHIP_LOADED,onEmChipLoadedStopAnimation);
         try
         {
            e.target.stopAnimation();
         }
         catch(err:Error)
         {
            DebugLog.instance.error("** EmsCollection: onEmChipLoadedStopAnimation -- error: " + err.message);
         }
      }
      
      private function onDrag(param1:MouseEvent) : void
      {
         _oDragItem.item.x = parent.parent.mouseX - _oDragItem.item.width / 2;
         _oDragItem.item.y = parent.parent.mouseY - _oDragItem.item.height / 2;
         param1.updateAfterEvent();
      }
      
      private function emStopAnimation(param1:int) : void
      {
         var iIndex:int = param1;
         try
         {
            _arEms[iIndex].stopAnimation();
         }
         catch(e:Error)
         {
            _arEms[iIndex].addEventListener(CChipTradeEm.CHIP_LOADED,onEmChipLoadedStopAnimation,false,0,true);
         }
      }
      
      private function onVirmonSelect(param1:MouseEvent) : void
      {
         if(isDragActive)
         {
            _mcSelectedItem = param1.currentTarget;
            _sType = VIRMON;
            onCreateItem(param1.currentTarget,_sType);
         }
      }
      
      public function addItem(param1:Object, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:CChipTradeVirmon = null;
         if(!param1 || _iCount == 9)
         {
            return;
         }
         _loc3_ = 0;
         loop0:
         for(; _loc3_ < 9; _loc3_++)
         {
            if(!(!_arVirmon[_loc3_].visible && !_arEms[_loc3_].visible))
            {
               continue;
            }
            switch(param2)
            {
               case VIRMON:
                  _loc4_ = CChipTradeVirmon(_arVirmon[_loc3_]);
                  _loc4_.clearImage();
                  _loc4_.setData(param1.virmon,"SV");
                  _loc4_.visible = true;
                  _loc4_.addEventListener(MouseEvent.MOUSE_DOWN,onVirmonSelect,false,0,true);
                  break loop0;
               case EMS:
                  param1.em.count = 1;
                  _arEms[_loc3_].clearImage();
                  _arEms[_loc3_].setData(param1.em);
                  emStopAnimation(_loc3_);
                  _arEms[_loc3_].visible = true;
                  _arEms[_loc3_].addEventListener(MouseEvent.MOUSE_DOWN,onEmsSelect,false,0,true);
                  break loop0;
               default:
                  break loop0;
            }
         }
         ++_iCount;
      }
      
      private function onDragItem(param1:MouseEvent) : void
      {
         _target = null;
         _mcSelectedItem.visible = false;
         parent.parent.addChild(_oDragItem.item);
         var _loc2_:Rectangle = new Rectangle(0,0,924,668);
         _bMove = true;
         --_iCount;
         parent.parent.removeEventListener(MouseEvent.MOUSE_MOVE,onDragItem);
         parent.parent.addEventListener(MouseEvent.MOUSE_MOVE,onDrag,false,0,true);
      }
      
      private function onCreateItem(param1:*, param2:String) : void
      {
         var _loc3_:* = undefined;
         _oDragItem = new Object();
         switch(param2)
         {
            case VIRMON:
               _oDragItem.data = CChipTradeVirmon(param1).getVirmon();
               _loc3_ = new CChipTradeVirmon(_characterAssetRetriever);
               break;
            case EMS:
               _oDragItem.data = CChipTradeEm(param1).getEM();
               _loc3_ = new CChipTradeEm(_emAssetRetriever,_emManager);
         }
         _loc3_._mcCellBack.visible = false;
         _loc3_.setData(_oDragItem.data);
         _loc3_.mouseEnabled = _loc3_.mouseChildren = false;
         _oDragItem.data.setID(param1.getId());
         _oDragItem.item = _loc3_;
         _oDragItem.item.x = parent.parent.mouseX - _mcSelectedItem.mouseX;
         _oDragItem.item.y = parent.parent.mouseY - _mcSelectedItem.mouseY;
         parent.parent.addEventListener(MouseEvent.MOUSE_MOVE,onDragItem,false,0,true);
         parent.parent.addEventListener(MouseEvent.MOUSE_UP,onStopDragItem,false,0,true);
      }
   }
}

