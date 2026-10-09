package com.arkadium.virmon.trade
{
   import com.arkadium.virmon.shared.data.DataProvider;
   import com.arkadium.virmon.shared.ui.sorting.CSorting;
   import com.arkadium.virmon.trade.events.TabEvent;
   import com.arkadium.virmon.trade.ui.collections.EmsCollection;
   import com.arkadium.virmon.trade.ui.collections.VirmonCollection;
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.Regular;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.text.TextField;
   
   public class TabSelector extends MovieClip
   {
      
      public var _mcSliderMask:MovieClip;
      
      private var HIDE_POSITION:Number;
      
      public var _cmEms:MovieClip;
      
      private var _arTween:Array = [];
      
      public var _mcMaskText:MovieClip;
      
      public var _mcVirmonScroll:MovieClip;
      
      private var PERCENT_SCALE:Number = 0.4;
      
      private var _arTabContent:Array = [];
      
      private var _iSelVirmonIndex:int = 0;
      
      public var _mcParamSort:CSorting;
      
      public var _mcContentMask:MovieClip;
      
      public var _mcHeader:MovieClip;
      
      private var SCALE:Number = 0.9;
      
      private var SHOW_POSITION:Number;
      
      private var _nDuration:Number = 1.25;
      
      private var _arTabTitle:Array = ["NANOVOR","EMS"];
      
      private var _nColor:Number = 255;
      
      private var _iNumTab:int = 2;
      
      private var _spColorHeader:Sprite = new Sprite();
      
      public var _tfTabTitle1:TextField;
      
      public var _tfTabTitle2:TextField;
      
      private var _iCurTab:int = 0;
      
      public var _mcEmsScroll:MovieClip;
      
      private var PERCENT_ANIMATION:Number = 1 - PERCENT_SCALE;
      
      public var _tcCart:TradingCart;
      
      private var _arTabState:Array = [105,255];
      
      public var _cmVirmon:MovieClip;
      
      private var _iSelEmsIndex:int = 0;
      
      private var INIT_POSITION:Number;
      
      public var _mcSlider:MovieClip;
      
      public function TabSelector()
      {
         super();
         INIT_POSITION = _mcContentMask.x - 2 * _mcContentMask.width;
         SHOW_POSITION = _mcContentMask.x + 100;
         HIDE_POSITION = _mcContentMask.x + 2 * _mcContentMask.width;
         _mcHeader.buttonMode = true;
         _mcHeader.addEventListener(MouseEvent.CLICK,onChangeTab,false,0,true);
         _spColorHeader.x = _mcHeader.x;
         _spColorHeader.y = _mcHeader.y;
         _spColorHeader.mouseEnabled = false;
         addChildAt(_spColorHeader,Math.min(getChildIndex(_mcSlider),getChildIndex(_tfTabTitle1),getChildIndex(_tfTabTitle2)));
         updateDisplayList();
         _mcSliderMask.x = _mcSlider.x;
         _mcSliderMask.y = _mcSlider.y;
         _spColorHeader.mask = _mcSliderMask;
         _arTabState[0] = _mcHeader.x;
         _arTabState[1] = _mcHeader.x + _mcHeader.width - _mcSlider.width;
         _mcSlider.x = _arTabState[_iCurTab];
         _arTabContent = [_cmVirmon,_cmEms];
         var _loc1_:int = 0;
         while(_loc1_ < _arTabContent.length)
         {
            _arTabContent[_loc1_].visible = false;
            _arTabContent[_loc1_].scaleX = _arTabContent[_loc1_].scaleY = SCALE;
            _loc1_++;
         }
         _arTabContent[_iCurTab].mask = _mcContentMask;
         _arTabContent[_iCurTab].visible = true;
         _mcParamSort.dataProvider = ["SV","ARMOR","SPEED","HEALTH","STRENGTH","NAME","FAMILY","MV"];
         _mcParamSort.addEventListener(CSorting.CHANGE_PARAM_SORT,onSortVirmonCollection,false,0,true);
         addEventListener(TabEvent.SCALE_CONTENT_DOWN_COMPLETE,onScaleDownComplete,false,0,true);
         addEventListener(TabEvent.CHANGE_CONTENT,onChangeContent,false,0,true);
         addEventListener(TabEvent.SHOW_CONTENT,onShowContent,false,0,true);
      }
      
      public function destroy() : void
      {
         var _loc1_:Object = null;
         while(_arTween.length != 0)
         {
            _loc1_ = Object(_arTween.pop());
            _loc1_.tw.removeEventListener(TweenEvent.MOTION_FINISH,onFinishMotion);
            delete _loc1_.tw;
            delete _loc1_.twm;
            delete _loc1_.twmt;
            _loc1_.tw = null;
            _loc1_.twm = null;
            _loc1_.twmt = null;
            _loc1_ = null;
         }
      }
      
      private function onChangeContent(param1:TabEvent) : void
      {
         if(Boolean(param1) && Boolean(param1.content))
         {
            param1.content.visible = false;
            param1.content.x = INIT_POSITION;
         }
         var _loc2_:MovieClip = _arTabContent[_iCurTab];
         _loc2_.mask = _mcContentMask;
         _loc2_.visible = true;
         _mcVirmonScroll.visible = _mcEmsScroll.visible = false;
         if(_loc2_._tlCollection is VirmonCollection)
         {
            _mcVirmonScroll.visible = true;
         }
         else
         {
            _mcEmsScroll.visible = true;
         }
         var _loc3_:Object = new Object();
         var _loc4_:Number = _nDuration / 2 * PERCENT_ANIMATION;
         _loc3_.tw = new Tween(_loc2_,"x",Regular.easeOut,_loc2_.x,SHOW_POSITION,_loc4_,true);
         _loc3_.tw.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
         _loc3_.param = TabEvent.SHOW_CONTENT;
         _loc3_.ind = _iCurTab;
         _arTween.push(_loc3_);
      }
      
      public function get virmonCollection() : VirmonCollection
      {
         return _cmVirmon._tlCollection;
      }
      
      protected function updateDisplayList() : void
      {
         var _loc1_:BitmapData = new BitmapData(_mcHeader.width,_mcHeader.height,true,0);
         _loc1_.draw(_mcHeader,new Matrix());
         var _loc2_:Number = (_nColor >> 16) / 255;
         var _loc3_:Number = (_nColor >> 8 & 0xFF) / 255;
         var _loc4_:Number = (_nColor & 0xFF) / 255;
         var _loc5_:Array = new Array();
         _loc5_ = _loc5_.concat([_loc2_,0,0,0,0]);
         _loc5_ = _loc5_.concat([0,_loc3_,0,0,0]);
         _loc5_ = _loc5_.concat([0,0,_loc4_,0,0]);
         _loc5_ = _loc5_.concat([0,0,0,1,0]);
         var _loc6_:ColorMatrixFilter = new ColorMatrixFilter(_loc5_);
         var _loc7_:Graphics = _spColorHeader.graphics;
         _loc7_.clear();
         _loc7_.beginBitmapFill(_loc1_,new Matrix(),false,true);
         _loc7_.drawRect(0,0,_mcHeader.width,_mcHeader.height);
         _loc7_.endFill();
         _spColorHeader.filters = [_loc6_];
      }
      
      public function init() : void
      {
         onChangeContent(null);
         onSortVirmonCollection(null);
      }
      
      private function onChangeTab(param1:MouseEvent) : void
      {
         onHideContent();
         var _loc2_:Number = _mcHeader.width / _arTabState.length;
         _iCurTab = param1.localX / _loc2_;
         var _loc3_:Object = new Object();
         _loc3_.tw = new Tween(_mcSlider,"x",Regular.easeOut,_mcSlider.x,_arTabState[_iCurTab],_nDuration,true);
         _loc3_.twm = new Tween(_mcSliderMask,"x",Regular.easeOut,_mcSliderMask.x,_arTabState[_iCurTab],_nDuration,true);
         _loc3_.twmt = new Tween(_mcMaskText,"x",Regular.easeOut,_mcMaskText.x,_arTabState[_iCurTab],_nDuration,true);
         _loc3_.tw.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
         _loc3_.param = "CHANGE_TAB";
         _arTween.push(_loc3_);
         _mcSlider._mcRefresh.gotoAndPlay(1);
         _mcHeader.buttonMode = false;
         _mcHeader.removeEventListener(MouseEvent.CLICK,onChangeTab);
      }
      
      private function onFinishMotion(param1:TweenEvent) : void
      {
         var _loc3_:TabEvent = null;
         var _loc2_:uint = 0;
         while(_loc2_ < _arTween.length)
         {
            if(_arTween[_loc2_].tw == param1.currentTarget)
            {
               Tween(_arTween[_loc2_].tw).stop();
               _arTween[_loc2_].tw.removeEventListener(TweenEvent.MOTION_FINISH,onFinishMotion);
               _arTween[_loc2_].tw = null;
               _loc3_ = new TabEvent(String(_arTween[_loc2_].param));
               _loc3_.index = _arTween[_loc2_].ind;
               _loc3_.content = _arTabContent[_loc3_.index];
               dispatchEvent(_loc3_);
               _arTween.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function get duration() : Number
      {
         return _nDuration;
      }
      
      public function set duration(param1:Number) : *
      {
         _nDuration = param1;
      }
      
      private function onSortVirmonCollection(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc6_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(_mcParamSort.sortParam == "name" || _mcParamSort.sortParam == "family")
         {
            _loc3_ = _mcParamSort.direction > 0 ? Array.CASEINSENSITIVE | Array.DESCENDING : int(Array.CASEINSENSITIVE);
         }
         else
         {
            _loc3_ = _mcParamSort.direction > 0 ? Array.NUMERIC | Array.DESCENDING : int(Array.NUMERIC);
         }
         _loc4_ = _mcParamSort.direction > 0 ? Array.CASEINSENSITIVE | Array.DESCENDING : int(Array.CASEINSENSITIVE);
         if(_mcParamSort.sortParam == "name")
         {
            DataProvider(_cmVirmon._tlCollection.dataProvider).sortOn(_mcParamSort.sortParam,_loc3_);
         }
         else
         {
            DataProvider(_cmVirmon._tlCollection.dataProvider).sortOn([_mcParamSort.sortParam,"name"],[_loc3_,_loc4_]);
         }
         var _loc5_:DataProvider = _cmVirmon._tlCollection.dataProvider;
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc6_ = _loc5_.getItemAt(_loc2_);
            if(_loc6_.state == 2)
            {
               _loc6_.state = 1;
            }
            _loc6_.param = _mcParamSort.sortParam;
            if(Boolean(_loc6_.content))
            {
               _loc6_.content.setData(_loc6_.virmon,_mcParamSort.sortParam);
            }
            _loc2_++;
         }
         _cmVirmon._tlCollection.dataProvider = _loc5_;
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            VirmonCollection(_cmVirmon._tlCollection).updateState(_loc5_.getItemAt(_loc2_));
            _loc2_++;
         }
         _iSelVirmonIndex = _mcParamSort.selectedIndex;
      }
      
      private function onScaleDownComplete(param1:TabEvent) : void
      {
         var _loc2_:Object = new Object();
         var _loc3_:Number = _nDuration / 2 * PERCENT_ANIMATION;
         _loc2_.tw = new Tween(param1.content,"x",Regular.easeOut,param1.content.x,HIDE_POSITION,_loc3_,true);
         _loc2_.tw.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
         _loc2_.param = TabEvent.CHANGE_CONTENT;
         _loc2_.ind = param1.index;
         _arTween.push(_loc2_);
      }
      
      public function set color(param1:Number) : *
      {
         _nColor = param1;
         updateDisplayList();
      }
      
      private function onSortEmsCollection(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = _mcParamSort.sortParam;
         if(_loc4_ == "rarity")
         {
            _loc4_ = "rarityInt";
         }
         if(_loc4_ == "name" || _loc4_ == "family")
         {
            _loc2_ = _mcParamSort.direction > 0 ? Array.CASEINSENSITIVE | Array.DESCENDING : int(Array.CASEINSENSITIVE);
         }
         else
         {
            _loc2_ = _mcParamSort.direction > 0 ? Array.NUMERIC | Array.DESCENDING : int(Array.NUMERIC);
         }
         _loc3_ = _mcParamSort.direction > 0 ? Array.CASEINSENSITIVE | Array.DESCENDING : int(Array.CASEINSENSITIVE);
         if(_loc4_ == "name")
         {
            DataProvider(_cmEms._tlCollection.dataProvider).sortOn(_loc4_,_loc2_);
         }
         else
         {
            DataProvider(_cmEms._tlCollection.dataProvider).sortOn([_loc4_,"name"],[_loc2_,_loc3_]);
         }
         _iSelEmsIndex = _mcParamSort.selectedIndex;
      }
      
      private function onShowContent(param1:TabEvent) : void
      {
         var _loc2_:Object = new Object();
         var _loc3_:Number = _nDuration / 2 * PERCENT_SCALE;
         _loc2_.tw = new Tween(param1.content,"scaleX",Regular.easeOut,param1.content.scaleX,1,_loc3_,true);
         _loc2_.twY = new Tween(param1.content,"scaleY",Regular.easeOut,param1.content.scaleY,1,_loc3_,true);
         _loc2_.tw.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
         _arTween.push(_loc2_);
         _mcHeader.buttonMode = true;
         _mcHeader.addEventListener(MouseEvent.CLICK,onChangeTab,false,0,true);
         if(_arTabContent[_iCurTab]._tlCollection is VirmonCollection)
         {
            _mcParamSort.dataProvider = ["SV","ARMOR","SPEED","HEALTH","STRENGTH","NAME","FAMILY","MV"];
            _mcParamSort.removeEventListener("CHANGE_PARAM_SORT",onSortEmsCollection);
            _mcParamSort.addEventListener("CHANGE_PARAM_SORT",onSortVirmonCollection,false,0,true);
            _mcParamSort.selectedIndex = _iSelVirmonIndex;
         }
         else
         {
            _mcParamSort.dataProvider = ["NAME","MV","FAMILY","RARITY","OWNED"];
            _mcParamSort.removeEventListener("CHANGE_PARAM_SORT",onSortVirmonCollection);
            _mcParamSort.addEventListener("CHANGE_PARAM_SORT",onSortEmsCollection,false,0,true);
            _mcParamSort.selectedIndex = _iSelEmsIndex;
         }
      }
      
      public function get color() : Number
      {
         return _nColor;
      }
      
      public function get emCollection() : EmsCollection
      {
         return _cmEms._tlCollection;
      }
      
      private function onHideContent() : void
      {
         var _loc1_:Object = new Object();
         var _loc2_:MovieClip = _arTabContent[_iCurTab];
         _loc1_.tw = new Tween(_loc2_,"scaleX",Regular.easeOut,_loc2_.scaleX,SCALE,_nDuration / 2 * PERCENT_SCALE,true);
         _loc1_.twY = new Tween(_loc2_,"scaleY",Regular.easeOut,_loc2_.scaleY,SCALE,_nDuration / 2 * PERCENT_SCALE,true);
         _loc1_.tw.addEventListener(TweenEvent.MOTION_FINISH,onFinishMotion,false,0,true);
         _loc1_.param = TabEvent.SCALE_CONTENT_DOWN_COMPLETE;
         _loc1_.ind = _iCurTab;
         _arTween.push(_loc1_);
      }
   }
}

