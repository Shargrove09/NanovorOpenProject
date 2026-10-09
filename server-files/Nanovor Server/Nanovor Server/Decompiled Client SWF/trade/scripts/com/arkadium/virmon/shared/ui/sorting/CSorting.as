package com.arkadium.virmon.shared.ui.sorting
{
   import caurina.transitions.*;
   import fl.transitions.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol187")]
   public class CSorting extends MovieClip
   {
      
      public static const CHANGE_PARAM_SORT:String = "CHANGE_PARAM_SORT";
      
      private var _dpArray:Array = [];
      
      private var _dictDownList:Dictionary = new Dictionary();
      
      private var _tmrOut:Timer;
      
      private var _arrDownList:Array = [];
      
      public var _mcBase:MovieClip;
      
      private var _render:*;
      
      private var _iDirection:int = -1;
      
      public var _mcDirection:MovieClip;
      
      private var _nDelay:Number = 0.15;
      
      public var _sbtDisplayList:SimpleButton;
      
      private var BLACK_COLOR:Number = 0;
      
      private var _iSelectIndex:int = -1;
      
      private var RED_COLOR:Number = 16711680;
      
      private var _bEvent:Boolean = true;
      
      public var _tfParam:TextField;
      
      public function CSorting()
      {
         super();
         _tfParam.text = "";
         _sbtDisplayList.addEventListener(MouseEvent.ROLL_OVER,onAnythingOver,false,0,true);
         _sbtDisplayList.addEventListener(MouseEvent.ROLL_OUT,onAnythingOut,false,0,true);
         _mcDirection.buttonMode = true;
         _mcDirection.addEventListener(MouseEvent.CLICK,onChangeDirection,false,0,true);
         _tmrOut = new Timer(500);
         _tmrOut.addEventListener(TimerEvent.TIMER,onTimerOutTick,false,0,true);
      }
      
      private function onAnythingOver(param1:MouseEvent) : void
      {
         _tmrOut.reset();
      }
      
      private function onTimerOutTick(param1:TimerEvent) : void
      {
         _tmrOut.reset();
         _bEvent = false;
         onItemSelect(null);
      }
      
      private function onAnythingOut(param1:MouseEvent) : void
      {
         _tmrOut.start();
      }
      
      public function get sortParam() : String
      {
         if(_iSelectIndex != -1)
         {
            return _dpArray[_iSelectIndex].toLowerCase();
         }
         return new String();
      }
      
      private function onSelectOut(param1:MouseEvent) : void
      {
         _bEvent = false;
         onItemSelect(null);
      }
      
      private function onCloseList(param1:MouseEvent) : void
      {
         _bEvent = false;
         onItemSelect(null);
         _sbtDisplayList.removeEventListener(MouseEvent.CLICK,onCloseList);
         _sbtDisplayList.addEventListener(MouseEvent.CLICK,onDisplayList,false,0,true);
      }
      
      public function get selectedIndex() : int
      {
         return _iSelectIndex;
      }
      
      private function onItemOver(param1:MouseEvent) : void
      {
         var _loc2_:ItemRender = _dictDownList[param1.currentTarget];
         if(_iSelectIndex != -1)
         {
            _loc2_.text = setText(String(_dpArray[_iSelectIndex]),BLACK_COLOR);
         }
         _loc2_.text = setText(String("-- " + _dpArray[_loc2_.id] + " --"),RED_COLOR);
      }
      
      private function onDisplayList(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:ItemRender = null;
         var _loc5_:Number = NaN;
         _arrDownList = [];
         _dictDownList = new Dictionary();
         _sbtDisplayList.removeEventListener(MouseEvent.CLICK,onDisplayList);
         _sbtDisplayList.addEventListener(MouseEvent.CLICK,onCloseList,false,0,true);
         var _loc2_:int = 0;
         while(_loc2_ < _dpArray.length)
         {
            _loc3_ = new Object();
            _loc4_ = new ItemRender();
            _loc5_ = _mcBase.y + (_loc2_ + 1) * (_loc4_.height - 10);
            _loc4_.x = _mcBase.x;
            _loc4_.id = _loc2_;
            _loc4_.text = setText(String(_dpArray[_loc2_]),BLACK_COLOR);
            Tweener.removeTweens(_loc4_,y);
            Tweener.addTween(_loc4_,{
               "y":_loc5_,
               "time":_nDelay + _loc2_ / 25,
               "transition":"easeOutQuad",
               "onComplete":onTweenInComplete,
               "onCompleteParams":[_loc4_]
            });
            _loc3_.mc = _loc4_;
            if(_loc2_ > 0)
            {
               addChildAt(_loc4_,getChildIndex(_arrDownList[_loc2_ - 1].mc));
            }
            else
            {
               addChildAt(_loc4_,getChildIndex(_mcBase));
            }
            _arrDownList.push(_loc3_);
            _loc2_++;
         }
         _bEvent = true;
      }
      
      public function set render(param1:*) : void
      {
         _render = param1;
      }
      
      private function onItemSelect(param1:MouseEvent) : void
      {
         var _loc3_:ItemRender = null;
         var _loc4_:Object = null;
         var _loc5_:ItemRender = null;
         var _loc6_:Number = NaN;
         _tmrOut.reset();
         if(param1 !== null)
         {
            _loc3_ = _dictDownList[param1.currentTarget];
            _iSelectIndex = _loc3_.id;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < _arrDownList.length)
         {
            _loc4_ = new Object();
            _loc5_ = _arrDownList[_loc2_].mc;
            _loc6_ = _mcBase.y;
            _loc5_.mcHit.removeEventListener(MouseEvent.MOUSE_OVER,onItemOver);
            _loc5_.mcHit.removeEventListener(MouseEvent.MOUSE_OUT,onItemOut);
            _loc5_.mcHit.removeEventListener(MouseEvent.CLICK,onItemSelect);
            _loc5_.mcHit.removeEventListener(MouseEvent.ROLL_OVER,onAnythingOver);
            _loc5_.mcHit.removeEventListener(MouseEvent.ROLL_OUT,onAnythingOut);
            if(_loc2_ == _arrDownList.length - 1)
            {
               Tweener.removeTweens(_loc5_,y);
               Tweener.addTween(_loc5_,{
                  "y":_loc6_,
                  "alpha":0,
                  "time":_nDelay - _loc2_ / 25,
                  "delay":_nDelay - _nDelay * ((_loc2_ + 1) / _arrDownList.length),
                  "transition":"easeInQuad",
                  "onComplete":onFinalTweenOutComplete,
                  "onCompleteParams":[_loc5_]
               });
            }
            else
            {
               Tweener.removeTweens(_loc5_,y);
               Tweener.addTween(_loc5_,{
                  "y":_loc6_,
                  "alpha":0,
                  "time":_nDelay - _loc2_ / 25,
                  "delay":_nDelay - _nDelay * ((_loc2_ + 1) / _arrDownList.length),
                  "transition":"easeInQuad",
                  "onComplete":onTweenOutComplete,
                  "onCompleteParams":[_loc5_]
               });
            }
            _loc2_++;
         }
         updateDisplayList();
         if(_bEvent)
         {
            dispatchEvent(new Event(CHANGE_PARAM_SORT));
         }
      }
      
      private function setText(param1:String, param2:Number) : String
      {
         return "<font color=\'#" + param2.toString(16) + "\'><b>" + param1 + "</b></font>";
      }
      
      private function onFinalTweenOutComplete(param1:ItemRender) : void
      {
         if(contains(param1))
         {
            removeChild(param1);
         }
         if(contains(param1.mcHit))
         {
            removeChild(param1.mcHit);
         }
         _sbtDisplayList.addEventListener(MouseEvent.CLICK,onDisplayList,false,0,true);
         _sbtDisplayList.removeEventListener(MouseEvent.CLICK,onCloseList);
      }
      
      private function onTweenOutComplete(param1:ItemRender) : void
      {
         if(contains(param1))
         {
            removeChild(param1);
         }
         if(contains(param1.mcHit))
         {
            removeChild(param1.mcHit);
         }
      }
      
      private function onChangeDirection(param1:MouseEvent) : void
      {
         _mcDirection.rotation += 180;
         _iDirection *= -1;
         dispatchEvent(new Event(CHANGE_PARAM_SORT));
      }
      
      private function onItemOut(param1:MouseEvent) : void
      {
         var _loc2_:ItemRender = _dictDownList[param1.currentTarget];
         _loc2_.text = setText(String(_dpArray[_loc2_.id]),BLACK_COLOR);
         _tmrOut.start();
      }
      
      public function set selectedIndex(param1:int) : void
      {
         _iSelectIndex = param1;
         updateDisplayList();
         dispatchEvent(new Event(CHANGE_PARAM_SORT));
      }
      
      private function onTweenInComplete(param1:ItemRender) : void
      {
         var _loc2_:MovieClip = addChild(param1.mcHit) as MovieClip;
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _dictDownList[_loc2_] = param1;
         _loc2_.addEventListener(MouseEvent.MOUSE_OVER,onItemOver,false,0,true);
         _loc2_.addEventListener(MouseEvent.MOUSE_OUT,onItemOut,false,0,true);
         _loc2_.addEventListener(MouseEvent.CLICK,onItemSelect,false,0,true);
         _loc2_.addEventListener(MouseEvent.ROLL_OVER,onAnythingOver,false,0,true);
         _loc2_.addEventListener(MouseEvent.ROLL_OUT,onAnythingOut,false,0,true);
      }
      
      public function set dataProvider(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:ItemRender = null;
         _sbtDisplayList.addEventListener(MouseEvent.CLICK,onDisplayList,false,0,true);
         _sbtDisplayList.removeEventListener(MouseEvent.CLICK,onCloseList);
         var _loc2_:int = 0;
         while(_loc2_ < _arrDownList.length)
         {
            _loc3_ = Object(_arrDownList[_loc2_]);
            _loc4_ = ItemRender(_arrDownList[_loc2_].mc);
            _loc4_.mcHit.removeEventListener(MouseEvent.MOUSE_OVER,onItemOver);
            _loc4_.mcHit.removeEventListener(MouseEvent.MOUSE_OUT,onItemOut);
            _loc4_.mcHit.removeEventListener(MouseEvent.CLICK,onItemSelect);
            _loc4_.mcHit.removeEventListener(MouseEvent.ROLL_OVER,onAnythingOver);
            _loc4_.mcHit.removeEventListener(MouseEvent.ROLL_OUT,onAnythingOut);
            _loc3_ = null;
            if(contains(_loc4_))
            {
               removeChild(_loc4_);
            }
            if(contains(_loc4_.mcHit))
            {
               removeChild(_loc4_.mcHit);
            }
            _loc2_++;
         }
         _arrDownList = [];
         _dictDownList = new Dictionary();
         _dpArray = param1;
         if(_dpArray.length > 0)
         {
            _iSelectIndex = 0;
            updateDisplayList();
         }
      }
      
      protected function updateDisplayList() : void
      {
         _tfParam.text = _dpArray[_iSelectIndex];
      }
      
      public function get direction() : int
      {
         return _iDirection;
      }
   }
}

