package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import caurina.transitions.*;
   import caurina.transitions.properties.ColorShortcuts;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class BadgeCell extends Sprite
   {
      
      public static const LOAD_COMPLETE:String = "badgeCellLoadComplete";
      
      public static const LOAD_ERROR:String = "badgeCellLoadError";
      
      public static const ROLL_OVER:String = "badgeCellRollOver";
      
      public static const ROLL_OUT:String = "badgeCellRollOut";
      
      public static const CLICK:String = "badgeCellClick";
      
      public var mcContainer:MovieClip;
      
      public var mcHit:MovieClip;
      
      private var _bEnabled:Boolean = false;
      
      private var _bSelected:Boolean = false;
      
      private var _ldrBadge:Loader;
      
      public var iIndexHack:int = 0;
      
      public var iBadgeId:int;
      
      private var _bmpBadge:Bitmap;
      
      public var mcHighlight:MovieClip;
      
      public function BadgeCell(param1:int, param2:Boolean = true)
      {
         super();
         mcHighlight.alpha = 0;
         ColorShortcuts._brightness_set(mcContainer,-0.56,[true]);
         iBadgeId = param1;
         if(param2)
         {
            loadBadge();
         }
      }
      
      private function onLoadBadgeError(param1:IOErrorEvent) : void
      {
         _ldrBadge.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadBadgeComplete);
         _ldrBadge.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadBadgeError);
         toggleEnabled(false);
         DebugLog.instance.error("BadgeCell.onLoadBadgeError: " + param1.text);
         dispatchEvent(new Event(LOAD_ERROR));
      }
      
      private function onHitRollOut(param1:MouseEvent) : void
      {
         if(!_bSelected)
         {
            Tweener.removeTweens(mcHighlight,alpha);
            Tweener.addTween(mcHighlight,{
               "alpha":0,
               "time":0.15,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(mcContainer,{
               "_tintBrightness":-0.56,
               "time":0.15,
               "transition":"easeOutQuad"
            });
         }
         dispatchEvent(new Event(ROLL_OUT));
      }
      
      private function onHitRollOver(param1:MouseEvent) : void
      {
         if(!_bSelected)
         {
            Tweener.removeTweens(mcHighlight,alpha);
            Tweener.addTween(mcHighlight,{
               "alpha":0.3,
               "time":0.15,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(mcContainer,{
               "_tintBrightness":-0.28,
               "time":0.15,
               "transition":"easeOutQuad"
            });
         }
         dispatchEvent(new Event(ROLL_OVER));
      }
      
      private function toggleEnabled(param1:Boolean) : void
      {
         if(_bEnabled == param1)
         {
            return;
         }
         _bEnabled = param1;
         if(param1)
         {
            mcHit.addEventListener(MouseEvent.ROLL_OVER,onHitRollOver,false,0,true);
            mcHit.addEventListener(MouseEvent.ROLL_OUT,onHitRollOut,false,0,true);
            mcHit.addEventListener(MouseEvent.CLICK,onHitClick,false,0,true);
            mcHit.buttonMode = true;
         }
         else
         {
            mcHit.removeEventListener(MouseEvent.ROLL_OVER,onHitRollOver);
            mcHit.removeEventListener(MouseEvent.ROLL_OUT,onHitRollOut);
            mcHit.removeEventListener(MouseEvent.CLICK,onHitClick);
            mcHit.buttonMode = false;
         }
      }
      
      private function toggleSelected(param1:Boolean) : void
      {
         if(_bSelected == param1)
         {
            return;
         }
         _bSelected = param1;
         toggleEnabled(!param1);
         if(param1)
         {
            Tweener.addTween(mcHighlight,{
               "alpha":1,
               "time":0.3,
               "transition":"easeInBounce"
            });
            Tweener.addTween(mcContainer,{
               "_tintBrightness":0,
               "time":0.3,
               "transition":"easeInBounce"
            });
         }
         else
         {
            Tweener.addTween(mcHighlight,{
               "alpha":0,
               "time":0.3,
               "transition":"easeOutQuad"
            });
            Tweener.addTween(mcContainer,{
               "_tintBrightness":-0.56,
               "time":0.3,
               "transition":"easeOutQuad"
            });
         }
      }
      
      private function onLoadBadgeComplete(param1:Event) : void
      {
         _ldrBadge.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadBadgeComplete);
         _ldrBadge.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadBadgeError);
         _bmpBadge = param1.target.content as Bitmap;
         _ldrBadge.unload();
         mcContainer.addChild(_bmpBadge);
         _ldrBadge = null;
         toggleEnabled(true);
         dispatchEvent(new Event(LOAD_COMPLETE));
      }
      
      public function get selected() : Boolean
      {
         return _bSelected;
      }
      
      public function set hitEnabled(param1:Boolean) : *
      {
         toggleEnabled(param1);
      }
      
      private function loadBadge() : void
      {
         _ldrBadge = new Loader();
         var _loc1_:int = int(DataManager.getInstance().getBadgeManager().getAssetBadgeData(iBadgeId).getIconId());
         var _loc2_:String = Managers.assetRetrieverManager.badgeAssetRetriever.getBadgeURL(_loc1_).url;
         _ldrBadge.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadBadgeComplete,false,0,true);
         _ldrBadge.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadBadgeError,false,0,true);
         _ldrBadge.load(new URLRequest(_loc2_));
      }
      
      public function load() : void
      {
         loadBadge();
      }
      
      public function getBitmap() : Bitmap
      {
         return _bmpBadge;
      }
      
      public function get hitEnabled() : Boolean
      {
         return _bEnabled;
      }
      
      public function clearListeners() : void
      {
         if(!_bEnabled)
         {
            return;
         }
         mcHit.removeEventListener(MouseEvent.ROLL_OVER,onHitRollOver);
         mcHit.removeEventListener(MouseEvent.ROLL_OUT,onHitRollOut);
         mcHit.removeEventListener(MouseEvent.CLICK,onHitClick);
      }
      
      private function onHitClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CLICK));
      }
      
      public function set selected(param1:Boolean) : *
      {
         toggleSelected(param1);
      }
      
      public function clearLoaded() : void
      {
         if(Boolean(_ldrBadge))
         {
            _ldrBadge.unload();
            try
            {
               _ldrBadge.close();
            }
            catch(e:Error)
            {
            }
            _ldrBadge = null;
         }
      }
   }
}

