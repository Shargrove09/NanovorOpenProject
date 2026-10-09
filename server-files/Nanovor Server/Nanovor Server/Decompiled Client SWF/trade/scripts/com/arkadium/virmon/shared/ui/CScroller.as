package com.arkadium.virmon.shared.ui
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   
   public class CScroller extends MovieClip
   {
      
      public static const START_SCROLL:String = "START_SCROLL";
      
      public static const STOP_SCROLL:String = "STOP_SCROLL";
      
      private var _mcScrollPane:MovieClip;
      
      private var _lScrollLoader:Loader;
      
      private var _uiScrollPaneHeight:uint;
      
      private var _id:int;
      
      public function CScroller()
      {
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,startDragScroll,false,0,true);
         _id = Math.floor(Math.random() * 1000000);
         addEventListener(Event.ADDED_TO_STAGE,onAddedToStage,false,0,true);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
      }
      
      private function startDragScroll(param1:MouseEvent) : *
      {
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragScroll);
            stage.addEventListener(MouseEvent.MOUSE_UP,stopDragScroll,false,0,true);
         }
         this.startDrag(false,new Rectangle(this.x,0,0,_uiScrollPaneHeight - this.height));
         addEventListener(Event.ENTER_FRAME,scrolling,false,0,true);
         dispatchEvent(new Event(START_SCROLL));
      }
      
      private function scrollLoadError(param1:IOErrorEvent) : void
      {
         logError("Error loading scroller skin.");
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> CScroller [" + _id + "]: ** " + param1 + " **");
      }
      
      public function set skin(param1:String) : void
      {
         _lScrollLoader = new Loader();
         _lScrollLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,scrollLoadError,false,0,true);
         _lScrollLoader.load(new URLRequest(param1));
         addChild(_lScrollLoader);
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log(">> CScroller [" + _id + "]: " + param1);
      }
      
      public function set scrollPane(param1:MovieClip) : void
      {
         _mcScrollPane = param1;
      }
      
      private function stopDragScroll(param1:MouseEvent) : *
      {
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragScroll);
         }
         removeEventListener(Event.ENTER_FRAME,scrolling);
         this.stopDrag();
         _mcScrollPane.y = -Math.round((this.y * (_mcScrollPane.height - _uiScrollPaneHeight) - this.height) / (_uiScrollPaneHeight - this.height));
         dispatchEvent(new Event(STOP_SCROLL));
      }
      
      private function scrolling(param1:Event) : void
      {
         _mcScrollPane.y = -Math.round((this.y * (_mcScrollPane.height - _uiScrollPaneHeight) - this.height) / (_uiScrollPaneHeight - this.height));
      }
      
      public function set scrollPaneHeight(param1:uint) : void
      {
         _uiScrollPaneHeight = param1;
      }
      
      public function set position(param1:Number) : void
      {
         if(param1 > _uiScrollPaneHeight - this.height)
         {
            param1 = _uiScrollPaneHeight - this.height;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         this.y = param1;
         _mcScrollPane.y = -Math.round((this.y * (_mcScrollPane.height - _uiScrollPaneHeight) - this.height) / (_uiScrollPaneHeight - this.height));
      }
      
      public function destroy() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
         if(Boolean(stage))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragScroll);
         }
         if(Boolean(_lScrollLoader) && this.contains(_lScrollLoader))
         {
            _lScrollLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,scrollLoadError);
            _lScrollLoader.unload();
            _lScrollLoader = null;
         }
         removeEventListener(MouseEvent.MOUSE_DOWN,startDragScroll);
         removeEventListener(Event.ENTER_FRAME,scrolling);
      }
   }
}

