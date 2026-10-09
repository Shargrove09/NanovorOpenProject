package com.arkadium.virmon.shared.ui
{
   import com.arkadium.virmon.shared.data.DataProvider;
   import com.arkadium.virmon.shared.elements.CCollectionVirmonUnit;
   import com.arkadium.virmon.shared.events.ListEvent;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   
   public class DragTileList extends CCustomList
   {
      
      public static const SELECT_VIRMON:String = "SELECT_VIRMON";
      
      public static const SORT_STRENGTH:String = "STRENGTH";
      
      public static const SORT_HEALTH:String = "HEALTH";
      
      public static const SORT_SPEED:String = "SPEED";
      
      public static const SORT_ARMOR:String = "ARMOR";
      
      public static const SORT_SV:String = "SV";
      
      public static const SORT_NAME:String = "NAME";
      
      public static const SORT_FACTION:String = "FAMILY";
      
      protected var _data:*;
      
      protected var _iRollIndex:int = 0;
      
      protected var _bMove:Boolean;
      
      protected var _bDragActive:Boolean = true;
      
      protected var _iSelectIndex:int = -1;
      
      protected var _cSelectVirmon:IVirmon;
      
      protected var _target:*;
      
      protected var _oDragItem:Object;
      
      public var _rDragItem:MovieClip;
      
      private var _soundManager:ISoundManager;
      
      protected var _mcParent:*;
      
      public function DragTileList()
      {
         super();
         _mcParent = parent;
         addEventListener(ListEvent.ITEM_MOUSE_DOWN,onSelectItem,false,0,true);
      }
      
      protected function onDrag(param1:MouseEvent) : void
      {
         _oDragItem.item.x = _mcParent.mouseX - _oDragItem.item.width / 2;
         _oDragItem.item.y = _mcParent.mouseY - _oDragItem.item.height / 2;
         param1.updateAfterEvent();
      }
      
      protected function createDragItem(param1:String) : void
      {
         var _loc2_:* = getDefinitionByName(param1) as Class;
         _rDragItem = new _loc2_();
         _rDragItem.gotoAndStop(1);
         if(_rDragItem is CCollectionVirmonUnit)
         {
            _rDragItem.showPv();
         }
         _rDragItem.mouseEnabled = false;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DragTileList: " + param1);
      }
      
      protected function changeLocation(param1:*) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:DataProvider = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         if(_loc6_)
         {
            return true;
         }
         return false;
      }
      
      protected function onLeaveStage(param1:Event) : void
      {
         onStopDrag(null);
      }
      
      public function updateState(param1:Object) : void
      {
         if(Boolean(param1.content))
         {
            switch(param1.state)
            {
               case 1:
                  param1.content.gotoAndStop("normal");
                  break;
               case 2:
                  param1.content.gotoAndStop("selected");
                  _cSelectVirmon = param1.virmon;
                  break;
               case 3:
                  param1.content.gotoAndStop("disable");
            }
         }
      }
      
      public function set path(param1:String) : void
      {
         createDragItem(param1);
      }
      
      public function get selectedVirmon() : IVirmon
      {
         return _cSelectVirmon;
      }
      
      private function onOutStage(param1:MouseEvent) : void
      {
      }
      
      public function get isMoveSelectedItem() : Boolean
      {
         return _bMove;
      }
      
      public function get target() : *
      {
         return _target;
      }
      
      protected function onStopDrag(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         _mcParent.removeEventListener(MouseEvent.MOUSE_MOVE,onDrag);
         _mcParent.removeEventListener(MouseEvent.MOUSE_UP,onStopDrag);
         playSound("SwitchClickDown");
         if(!_bMove)
         {
            _mcParent.removeEventListener(MouseEvent.MOUSE_MOVE,onStartDrag);
            if(_iSelectIndex != -1)
            {
               _loc2_ = _dataprovider.getItemAt(_iSelectIndex);
               _loc2_.state = 1;
               updateState(_loc2_);
            }
            _iSelectIndex = _iRollIndex;
            _oDragItem.data.state = 2;
            updateState(_oDragItem.data);
            _rDragItem.clearImage();
            dispatchEvent(new Event(SELECT_VIRMON));
            return;
         }
         _oDragItem.item.stopDrag();
         var _loc3_:MovieClip = _oDragItem.item;
         _bMove = false;
         if(!changeLocation(_target))
         {
            _loc2_ = _oDragItem.data;
            _loc2_.state = 1;
            updateState(_loc2_);
         }
         if(Boolean(_mcParent.contains))
         {
            _mcParent.removeChild(_oDragItem.item);
         }
         _rDragItem.clearImage();
         _iSelectIndex = -1;
         delete _oDragItem.item;
         _oDragItem = null;
         stage.removeEventListener(Event.MOUSE_LEAVE,onLeaveStage);
      }
      
      protected function onStartDrag(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         if(_iSelectIndex != -1)
         {
            _loc2_ = _dataprovider.getItemAt(_iSelectIndex);
            _loc2_.state = 1;
            updateState(_loc2_);
         }
         _iSelectIndex = _iRollIndex;
         _bMove = true;
         _mcParent.addChild(_oDragItem.item);
         var _loc3_:Rectangle = new Rectangle(0,0,924,668);
         _oDragItem.data = _dataprovider.getItemAt(_iRollIndex);
         _oDragItem.data.state = 3;
         updateState(_oDragItem.data);
         _mcParent.removeEventListener(MouseEvent.MOUSE_MOVE,onStartDrag);
         _mcParent.addEventListener(MouseEvent.MOUSE_MOVE,onDrag,false,0,true);
         stage.addEventListener(Event.MOUSE_LEAVE,onLeaveStage);
         playSound("SwitchClickUp");
      }
      
      public function clearAll() : void
      {
         destroy();
         _mcParent = null;
         _rDragItem = null;
         _oDragItem = null;
      }
      
      public function sort(param1:String, param2:int) : void
      {
         switch(param1.toUpperCase())
         {
            case SORT_SPEED:
               _dataprovider.sortOn("speed",param2);
               break;
            case SORT_ARMOR:
               _dataprovider.sortOn("armor",param2);
               break;
            case SORT_STRENGTH:
               _dataprovider.sortOn("strength",param2);
               break;
            case SORT_HEALTH:
               _dataprovider.sortOn("health",param2);
               break;
            case SORT_SV:
               _dataprovider.sortOn("sv",param2);
               break;
            case SORT_NAME:
               _dataprovider.sortOn("name",param2);
               break;
            case SORT_FACTION:
               _dataprovider.sortOn("family",param2);
         }
      }
      
      public function set target(param1:*) : void
      {
         _target = param1;
      }
      
      public function get isDragActive() : Boolean
      {
         return _bDragActive;
      }
      
      public function setSoundManager(param1:ISoundManager) : void
      {
         _soundManager = param1;
      }
      
      public function get data() : *
      {
         return _data;
      }
      
      public function set isDragActive(param1:Boolean) : void
      {
         _bDragActive = param1;
      }
      
      protected function onSelectItem(param1:ListEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param1.item.state == 3)
         {
            return;
         }
         if(_bDragActive)
         {
            _oDragItem = new Object();
            _loc2_ = param1.item.content;
            _loc3_ = _mcParent.mouseX - _loc2_.mouseX;
            _loc4_ = _mcParent.mouseY - _loc2_.mouseY;
            _oDragItem.setPoint = new Point(_loc3_,_loc4_);
            _data = IVirmon(param1.item.virmon);
            _rDragItem.setData(_data);
            _oDragItem.item = _rDragItem;
            _oDragItem.item.mouseEnabled = false;
            _oDragItem.item.mouseChildren = false;
            if(Boolean(_oDragItem.item._mcCellBack))
            {
               _oDragItem.item._mcCellBack.visible = false;
            }
            _oDragItem.item.x = _loc3_;
            _oDragItem.item.y = _loc4_;
            _oDragItem.data = _dataprovider.getItemAt(param1.index);
            _iRollIndex = param1.index;
            _mcParent.addEventListener(MouseEvent.MOUSE_MOVE,onStartDrag,false,0,true);
            _mcParent.addEventListener(MouseEvent.MOUSE_UP,onStopDrag,false,0,true);
         }
         else
         {
            _data = IVirmon(param1.item.virmon);
            dispatchEvent(new Event(SELECT_VIRMON));
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> DragTileList: ** " + param1 + " **");
      }
      
      private function playSound(param1:String) : void
      {
         if(_soundManager == null)
         {
            return;
         }
         _soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,param1,true,SoundManagerConst.soundApplicationDomain));
      }
      
      public function set moveArea(param1:*) : void
      {
         _mcParent = param1;
      }
   }
}

