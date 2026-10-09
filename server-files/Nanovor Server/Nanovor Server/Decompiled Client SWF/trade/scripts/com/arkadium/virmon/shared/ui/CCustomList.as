package com.arkadium.virmon.shared.ui
{
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.shared.data.DataProvider;
   import com.arkadium.virmon.shared.events.DataChangeEvent;
   import com.arkadium.virmon.shared.events.DataChangeType;
   import com.arkadium.virmon.shared.events.ListEvent;
   import com.arkadium.virmon.shared.renders.CCellRenderer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   
   public class CCustomList extends MovieClip
   {
      
      protected var _cellrenderer:String;
      
      protected var _sScrollSkin:String;
      
      protected var _countColumn:uint;
      
      protected var _aCells:Array;
      
      protected var _uiCellWidth:uint;
      
      protected var _cellRef:Class;
      
      protected var _countRow:uint;
      
      private var _bAddedToStage:Boolean;
      
      protected var _spTrack:Sprite;
      
      private var _uiHeight:uint;
      
      protected var _uiCellHeight:uint;
      
      protected var _itemcontainer:MovieClip;
      
      protected var _uiWidth:uint;
      
      protected var _iXScrollPosition:int;
      
      public var _listmask:MovieClip;
      
      protected var _scroll:MovieClip;
      
      protected var _mcParentScroll:MovieClip;
      
      protected var _dataprovider:DataProvider;
      
      public function CCustomList()
      {
         super();
         _dataprovider = new DataProvider();
         _bAddedToStage = false;
         _iXScrollPosition = this.width;
         _countColumn = 1;
         _spTrack = null;
         _sScrollSkin = "elements/scrolls/defaultScroll.swf";
         _itemcontainer = new MovieClip();
         addEventListener(Event.ADDED_TO_STAGE,addedToStage,false,0,true);
         _mcParentScroll = this;
      }
      
      public function destroy() : *
      {
         var cnt:uint = 0;
         var i:uint = 0;
         try
         {
            if(Boolean(_scroll))
            {
               _scroll.destroy();
            }
            cnt = _aCells.length;
            i = 0;
            while(i < cnt)
            {
               _aCells[i].destroy();
               i++;
            }
            _dataprovider.removeEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange);
            distroyList();
            _dataprovider.removeAll();
            delete global[this];
         }
         catch(e:Error)
         {
            logError(" Caught ERROR in destroy(): " + e.message);
         }
      }
      
      private function drawList() : void
      {
         var _loc2_:MovieClip = null;
         var _loc5_:* = undefined;
         distroyList();
         var _loc1_:uint = Boolean(_dataprovider) ? _dataprovider.length : 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         while(_loc7_ < _loc1_)
         {
            _loc2_ = new _cellRef();
            if(_uiCellWidth == 0)
            {
               _uiCellWidth = _loc2_.width;
            }
            if(_uiCellHeight == 0)
            {
               _uiCellHeight = _loc2_.height;
            }
            _loc5_ = _loc3_ * _uiCellWidth;
            if(_loc3_ % _countColumn == 0)
            {
               _loc3_ = 0;
               _loc5_ = 0;
               _loc6_ = int(_loc4_ * _uiCellHeight);
               _loc4_++;
            }
            _loc3_++;
            _loc2_.x = _loc5_;
            _loc2_.y = _loc6_;
            _loc2_.data = _dataprovider.getItemAt(_loc7_);
            _loc2_.row = _loc4_;
            _loc2_.column = _loc3_;
            _loc2_.itemIndex = _loc7_;
            addCellListeners(_loc2_);
            _aCells.push(_loc2_);
            _itemcontainer.addChild(_loc2_);
            createMask(_loc2_);
            _loc7_++;
         }
      }
      
      public function set scrollTrack(param1:Sprite) : void
      {
         _spTrack = param1;
      }
      
      public function set cellRenderer(param1:String) : *
      {
         _cellrenderer = param1;
         _cellRef = getDefinitionByName(_cellrenderer) as Class;
      }
      
      private function replaceItemInCellArray() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Array = new Array();
         var _loc3_:uint = _dataprovider.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = getCellByDataProviderItem(_dataprovider.getItemAt(_loc4_));
            _loc1_[_loc4_] = _loc2_;
            _loc4_++;
         }
         _aCells = _loc1_;
      }
      
      public function get scrollBar() : MovieClip
      {
         return _scroll;
      }
      
      private function handleCellRendererClick(param1:MouseEvent) : void
      {
         var _loc2_:CCellRenderer = param1.currentTarget as CCellRenderer;
         dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK,false,true,_loc2_.column,_loc2_.row,_loc2_.itemIndex,_loc2_.data));
      }
      
      public function set scrollskin(param1:String) : void
      {
         _sScrollSkin = param1;
      }
      
      private function drawReplaceItemAt(param1:Array, param2:uint) : void
      {
         if(Boolean(_aCells[param2]))
         {
            _aCells[param2].data = _dataprovider.getItemAt(param2);
         }
      }
      
      public function set cellWidth(param1:uint) : void
      {
         _uiCellWidth = param1;
      }
      
      private function createlist() : void
      {
         _aCells = new Array();
         _itemcontainer.visible = false;
         addChild(_itemcontainer);
         _itemcontainer.mask = _listmask;
         _itemcontainer.visible = true;
         drawList();
      }
      
      protected function handleCellRendererChange(param1:Event) : void
      {
         var _loc2_:CCellRenderer = param1.currentTarget as CCellRenderer;
         var _loc3_:uint = _loc2_.itemIndex;
         _dataprovider.invalidateItemAt(_loc3_);
      }
      
      protected function createMask(param1:MovieClip) : void
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _itemcontainer.addChild(_loc2_);
         var _loc3_:Graphics = _loc2_.graphics;
         _loc3_.beginFill(0,100);
         _loc3_.drawRect(0,0,_uiCellWidth,_uiCellHeight);
         _loc3_.endFill();
         param1.mask = _loc2_;
      }
      
      private function addedToStage(param1:Event) : void
      {
         _bAddedToStage = true;
         removeEventListener(Event.ADDED_TO_STAGE,addedToStage);
         _uiWidth = this.width;
         _uiHeight = this.height;
         this.scaleX = this.scaleY = 1;
         _listmask.height = _uiHeight;
         _listmask.width = _uiWidth;
         createlist();
         checkScroll();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> CCustomList: " + param1);
      }
      
      public function set scrollPosition(param1:Number) : *
      {
         if(Boolean(_scroll))
         {
            _scroll.position = param1;
         }
      }
      
      public function get xScrollPosition() : uint
      {
         return _iXScrollPosition;
      }
      
      public function set rowCount(param1:uint) : *
      {
         _countRow = param1;
      }
      
      private function distroyList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(Boolean(_aCells))
         {
            _loc1_ = _aCells.length;
            if(_loc1_ > 0)
            {
               _loc3_ = _loc1_ - 1;
               while(_loc3_ >= 0)
               {
                  _loc2_ = _aCells[_loc3_];
                  _aCells.splice(_loc3_,1);
                  removeCellListeners(_loc2_);
                  if(Boolean(_loc2_) && _itemcontainer.contains(_loc2_))
                  {
                     _itemcontainer.removeChild(_loc2_);
                     _itemcontainer.removeChild(_loc2_.mask);
                  }
                  _loc2_.mask = null;
                  _loc2_ = null;
                  _loc3_--;
               }
            }
         }
      }
      
      public function set scrollParent(param1:MovieClip) : void
      {
         _mcParentScroll = param1;
         if(Boolean(_scroll) && Boolean(param1))
         {
            param1.addChild(_scroll);
         }
      }
      
      public function get dataProvider() : DataProvider
      {
         return _dataprovider;
      }
      
      private function removeItemFromList(param1:Array, param2:uint) : void
      {
         var _loc3_:MovieClip = _aCells[param2];
         _aCells.splice(param2,1);
         removeCellListeners(_loc3_);
         if(Boolean(_loc3_) && _itemcontainer.contains(_loc3_))
         {
            _itemcontainer.removeChild(_loc3_);
            _itemcontainer.removeChild(_loc3_.mask);
         }
         reDrawList(param2,_loc3_.column,_loc3_.row);
         _loc3_.mask = null;
         _loc3_ = null;
      }
      
      protected function handleDataChange(param1:DataChangeEvent) : void
      {
         if(!_bAddedToStage)
         {
            return;
         }
         switch(param1.changeType)
         {
            case DataChangeType.ADD:
               drawListItem(param1.items,param1.startIndex);
               break;
            case DataChangeType.REPLACE:
               drawReplaceItemAt(param1.items,param1.startIndex);
               break;
            case DataChangeType.INVALIDATE_ALL:
               drawList();
               break;
            case DataChangeType.SORT:
               sortList();
               break;
            case DataChangeType.REMOVE:
               removeItemFromList(param1.items,param1.startIndex);
               break;
            case DataChangeType.REMOVE_ALL:
               distroyList();
         }
         checkScroll();
      }
      
      public function set column(param1:uint) : void
      {
         _countColumn = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CCustomList: " + param1);
      }
      
      protected function drawListItem(param1:Array, param2:uint) : void
      {
         var _loc3_:MovieClip = null;
         _loc3_ = new _cellRef();
         if(_uiCellWidth == 0)
         {
            _uiCellWidth = _loc3_.width;
         }
         if(_uiCellHeight == 0)
         {
            _uiCellHeight = _loc3_.height;
         }
         _loc3_.column = param2 % _countColumn;
         _loc3_.row = Math.floor(param2 / _countColumn);
         _loc3_.x = _loc3_.column * _uiCellWidth;
         _loc3_.y = _loc3_.row * _uiCellHeight;
         _loc3_.data = _dataprovider.getItemAt(param2);
         _loc3_.itemIndex = param2;
         addCellListeners(_loc3_);
         _aCells.push(_loc3_);
         _itemcontainer.addChild(_loc3_);
         createMask(_loc3_);
      }
      
      public function get rowCount() : uint
      {
         return _countRow;
      }
      
      protected function startScroll(param1:Event) : *
      {
         dispatchEvent(new ProjectEvent("START_SCROLL",{"position":_itemcontainer.y}));
      }
      
      public function set cellHeight(param1:uint) : void
      {
         _uiCellHeight = param1;
      }
      
      private function handleCellRendererMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:CCellRenderer = param1.currentTarget as CCellRenderer;
         dispatchEvent(new ListEvent(ListEvent.ITEM_MOUSE_DOWN,false,true,_loc2_.column,_loc2_.row,_loc2_.itemIndex,_loc2_.data));
      }
      
      public function set xScrollPosition(param1:uint) : void
      {
         _iXScrollPosition = param1;
      }
      
      private function getCellByDataProviderItem(param1:Object) : MovieClip
      {
         var _loc2_:uint = _aCells.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(Boolean(_aCells[_loc3_]) && _aCells[_loc3_].data == param1)
            {
               return _aCells[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      private function removeCellListeners(param1:MovieClip) : void
      {
         if(param1 != null)
         {
            param1.removeEventListener(MouseEvent.CLICK,handleCellRendererClick);
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,handleCellRendererMouseDown);
            param1.removeEventListener(MouseEvent.MOUSE_UP,handleCellRendererMouseUp);
            param1.removeEventListener(MouseEvent.ROLL_OVER,handleCellRendererMouseEvent);
            param1.removeEventListener(MouseEvent.ROLL_OUT,handleCellRendererMouseEvent);
            param1.removeEventListener(Event.CHANGE,handleCellRendererChange);
         }
      }
      
      private function handleCellRendererMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:CCellRenderer = param1.currentTarget as CCellRenderer;
         dispatchEvent(new ListEvent(ListEvent.ITEM_MOUSE_UP,false,true,_loc2_.column,_loc2_.row,_loc2_.itemIndex,_loc2_.data));
      }
      
      private function sortList() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(Boolean(_aCells))
         {
            _loc4_ = 0;
            while(_loc4_ < _dataprovider.length)
            {
               _loc1_ = getCellByDataProviderItem(_dataprovider.getItemAt(_loc4_));
               _loc2_ = Math.floor(_loc4_ / _countColumn);
               _loc3_ = _loc4_ % _countColumn;
               if(Boolean(_loc1_))
               {
                  _loc1_.x = _loc3_ * _uiCellWidth;
                  _loc1_.y = _loc2_ * _uiCellHeight;
                  _loc1_.row = _loc2_;
                  _loc1_.column = _loc3_;
                  _loc1_.itemIndex = _loc4_;
                  _loc1_.mask.x = _loc1_.x;
                  _loc1_.mask.y = _loc1_.y;
               }
               _loc4_++;
            }
            replaceItemInCellArray();
         }
      }
      
      protected function addCellListeners(param1:MovieClip) : void
      {
         if(param1 != null)
         {
            param1.addEventListener(MouseEvent.CLICK,handleCellRendererClick,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_DOWN,handleCellRendererMouseDown,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_UP,handleCellRendererMouseUp,false,0,true);
            param1.addEventListener(MouseEvent.ROLL_OVER,handleCellRendererMouseEvent,false,0,true);
            param1.addEventListener(MouseEvent.ROLL_OUT,handleCellRendererMouseEvent,false,0,true);
            param1.addEventListener(Event.CHANGE,handleCellRendererChange,false,0,true);
         }
      }
      
      private function reDrawList(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:uint = _dataprovider.length;
         var _loc5_:MovieClip = _aCells[param1];
         var _loc6_:uint = param2;
         var _loc7_:uint = uint(param3 + 1);
         var _loc8_:int = int(_loc6_ * _uiCellWidth);
         var _loc9_:int = int(param3 * _uiCellHeight);
         var _loc10_:uint = param1;
         while(_loc10_ < _loc4_)
         {
            _loc5_ = _aCells[_loc10_];
            _loc8_ = int(_loc6_ * _uiCellWidth);
            if(_loc6_ % _countColumn == 0)
            {
               _loc6_ = 0;
               _loc8_ = 0;
               _loc9_ = int(_loc7_ * _uiCellHeight);
               _loc7_++;
            }
            _loc6_++;
            _loc5_.x = _loc8_;
            _loc5_.y = _loc9_;
            _loc5_.data = _dataprovider.getItemAt(_loc10_);
            _loc5_.row = _loc7_;
            _loc5_.column = _loc6_;
            _loc5_.itemIndex = _loc10_;
            _loc5_.mask.x = _loc5_.x;
            _loc5_.mask.y = _loc5_.y;
            _loc10_++;
         }
      }
      
      protected function stopScroll(param1:Event) : *
      {
         dispatchEvent(new ProjectEvent("STOP_SCROLL",{"position":_itemcontainer.y}));
      }
      
      protected function handleCellRendererMouseEvent(param1:MouseEvent) : void
      {
         var _loc2_:CCellRenderer = param1.target as CCellRenderer;
         var _loc3_:String = param1.type == MouseEvent.ROLL_OVER ? ListEvent.ITEM_ROLL_OVER : ListEvent.ITEM_ROLL_OUT;
         dispatchEvent(new ListEvent(_loc3_,false,false,_loc2_.column,_loc2_.row,_loc2_.itemIndex,_loc2_.data));
      }
      
      protected function checkScroll() : void
      {
         if(_uiCellHeight * _dataprovider.length / _countColumn > _listmask.height && !_scroll)
         {
            _scroll = new CScroller();
            _scroll.skin = _sScrollSkin;
            _scroll.scrollPaneHeight = _listmask.height;
            _scroll.scrollPane = _itemcontainer;
            _mcParentScroll.addChild(_scroll);
            _scroll.addEventListener("START_SCROLL",startScroll,false,0,true);
            _scroll.addEventListener("STOP_SCROLL",stopScroll,false,0,true);
            _scroll.x = _iXScrollPosition;
            if(Boolean(_spTrack))
            {
               _spTrack.visible = true;
            }
         }
         if(_uiCellHeight * _dataprovider.length / _countColumn <= _listmask.height)
         {
            if(Boolean(_spTrack))
            {
               _spTrack.visible = false;
            }
            if(Boolean(_scroll))
            {
               _scroll.removeEventListener("START_SCROLL",startScroll);
               _scroll.removeEventListener("STOP_SCROLL",stopScroll);
               _scroll.destroy();
               if(_mcParentScroll.contains(_scroll))
               {
                  _mcParentScroll.removeChild(_scroll);
               }
               _scroll = null;
            }
         }
      }
      
      public function set dataProvider(param1:DataProvider) : *
      {
         if(_dataprovider != null)
         {
            _dataprovider.removeEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange);
         }
         _dataprovider = param1;
         _dataprovider.addEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange,false,0,true);
      }
      
      public function get scrollTrack() : Sprite
      {
         return _spTrack;
      }
   }
}

