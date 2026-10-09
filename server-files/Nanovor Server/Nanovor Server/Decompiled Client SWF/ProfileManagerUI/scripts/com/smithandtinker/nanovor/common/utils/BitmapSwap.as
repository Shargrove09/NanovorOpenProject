package com.smithandtinker.nanovor.common.utils
{
   import caurina.transitions.Tweener;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BitmapSwap extends EventDispatcher
   {
      
      public static const TYPE_ORIGINAL:uint = 1;
      
      public static const TYPE_REVEAL:uint = 2;
      
      public static const TYPE_CROSS:uint = 3;
      
      private var _bitmapOld:Bitmap;
      
      private var _container:DisplayObjectContainer;
      
      private var _autoTop:Boolean;
      
      private var _oldIndex:int;
      
      private var _time:Number;
      
      private var _bitmapNew:Bitmap;
      
      private var _type:uint;
      
      public function BitmapSwap(param1:*, param2:Bitmap, param3:Number = 1, param4:int = 0, param5:Boolean = false, param6:uint = 1, param7:Boolean = true)
      {
         var container:* = param1;
         var newBitmap:Bitmap = param2;
         var time:Number = param3;
         var oldIndex:int = param4;
         var setSamePoint:Boolean = param5;
         var type:uint = param6;
         var autoTop:Boolean = param7;
         super();
         _container = DisplayObjectContainer(container);
         _bitmapNew = newBitmap;
         _time = time;
         _autoTop = autoTop;
         _oldIndex = _autoTop ? (_container.numChildren > 0 ? _container.numChildren - 1 : 0) : oldIndex;
         _type = type;
         try
         {
            _bitmapOld = Bitmap(_container.getChildAt(_oldIndex));
         }
         catch(e:RangeError)
         {
            _bitmapOld = null;
         }
         if(setSamePoint && Boolean(_bitmapOld))
         {
            _bitmapNew.x = _bitmapOld.x;
            _bitmapNew.y = _bitmapOld.y;
         }
      }
      
      public static function SafeClear(param1:*, param2:int = 0) : void
      {
         var bm:Bitmap = null;
         var container:* = param1;
         var index:int = param2;
         var doc:DisplayObjectContainer = DisplayObjectContainer(container);
         try
         {
            bm = Bitmap(doc.getChildAt(index));
         }
         catch(e:RangeError)
         {
            bm = null;
         }
         if(Boolean(bm))
         {
            doc.removeChild(bm);
            bm = null;
         }
      }
      
      public static function QuickRun(param1:*, param2:Bitmap, param3:Number = 1, param4:int = 0, param5:Boolean = false, param6:uint = 1, param7:Boolean = true) : BitmapSwap
      {
         var _loc8_:BitmapSwap = new BitmapSwap(param1,param2,param3,param4,param5,param6,param7);
         _loc8_.Start();
         return _loc8_;
      }
      
      public function Start() : void
      {
         if(!_bitmapOld)
         {
            oldBitmapOutComplete();
            return;
         }
         if(_type == TYPE_ORIGINAL)
         {
            Tweener.addTween(_bitmapOld,{
               "alpha":0,
               "time":_time / 2,
               "transition":"easeInOutQuad",
               "onComplete":oldBitmapOutComplete
            });
            return;
         }
         if(_type == TYPE_REVEAL)
         {
            _bitmapNew.alpha = 0;
            _container.addChildAt(_bitmapNew,_container.numChildren);
            Tweener.addTween(_bitmapNew,{
               "alpha":1,
               "time":_time,
               "transition":"easeInOutQuad",
               "onComplete":oldBitmapOutComplete
            });
         }
         if(_type == TYPE_CROSS)
         {
            _bitmapNew.alpha = 0;
            _container.addChildAt(_bitmapNew,_container.numChildren);
            Tweener.addTween(_bitmapOld,{
               "alpha":0,
               "time":_time * 0.9,
               "transition":"easeInOutQuad"
            });
            Tweener.addTween(_bitmapNew,{
               "alpha":1,
               "time":_time,
               "transition":"easeInOutQuad",
               "onComplete":oldBitmapOutComplete
            });
         }
      }
      
      private function newBitmapInComplete() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function oldBitmapOutComplete() : void
      {
         if(Boolean(_bitmapOld))
         {
            _container.removeChild(_bitmapOld);
         }
         if(_type == TYPE_ORIGINAL || (_type == TYPE_REVEAL || _type == TYPE_CROSS) && !_bitmapOld)
         {
            _bitmapNew.alpha = 0;
            _container.addChildAt(_bitmapNew,_oldIndex);
            Tweener.addTween(_bitmapNew,{
               "alpha":1,
               "time":_time / 2,
               "transition":"easeInOutQuad",
               "onComplete":newBitmapInComplete
            });
            return;
         }
         if(_type == TYPE_REVEAL || _type == TYPE_CROSS)
         {
            _container.setChildIndex(_bitmapNew,_oldIndex);
            newBitmapInComplete();
         }
      }
   }
}

