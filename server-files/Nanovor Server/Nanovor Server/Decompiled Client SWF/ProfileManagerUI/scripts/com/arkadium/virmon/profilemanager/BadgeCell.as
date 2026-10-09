package com.arkadium.virmon.profilemanager
{
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol21")]
   public class BadgeCell extends Sprite
   {
      
      public static const LOAD_COMPLETE:String = "badgeCellLoadComplete";
      
      public static const LOAD_ERROR:String = "badgeCellLoadError";
      
      public static const ROLL_OVER:String = "badgeCellRollOver";
      
      public static const ROLL_OUT:String = "badgeCellRollOut";
      
      public static const CLICK:String = "badgeCellClick";
      
      public var mcContainer:MovieClip;
      
      public var mcCheck:MovieClip;
      
      private var _bEnabled:Boolean = false;
      
      private var _ldrBadge:Loader;
      
      public var mcHit:MovieClip;
      
      public var iBadgeId:int;
      
      private var _bmpBadge:Bitmap;
      
      public var bSelected:Boolean = false;
      
      public function BadgeCell(param1:int, param2:Boolean = true)
      {
         super();
         iBadgeId = param1;
         mcCheck.visible = false;
         if(param2)
         {
            loadBadge();
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ROLL_OUT));
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
            mcHit.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true);
            mcHit.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true);
            mcHit.addEventListener(MouseEvent.CLICK,onClick,false,0,true);
            mcHit.buttonMode = true;
         }
         else
         {
            mcHit.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
            mcHit.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
            mcHit.removeEventListener(MouseEvent.CLICK,onClick);
            mcHit.buttonMode = false;
         }
      }
      
      private function onLoadBadgeComplete(param1:Event) : void
      {
         _ldrBadge.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadBadgeComplete);
         _ldrBadge.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadBadgeError);
         _bmpBadge = param1.target.content as Bitmap;
         _ldrBadge.unload();
         _ldrBadge = null;
         mcContainer.addChild(_bmpBadge);
         _ldrBadge = null;
         toggleEnabled(true);
         dispatchEvent(new Event(LOAD_COMPLETE));
      }
      
      private function loadBadge() : void
      {
         _ldrBadge = new Loader();
         var _loc1_:int = int(DataManager.getInstance().getBadgeManager().getAccountBadgeData(iBadgeId).getIconId());
         var _loc2_:String = Managers.assetRetrieverManager.badgeAssetRetriever.getBadgeURL(_loc1_).url;
         _ldrBadge.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadBadgeComplete,false,0,true);
         _ldrBadge.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadBadgeError,false,0,true);
         _ldrBadge.load(new URLRequest(_loc2_));
      }
      
      public function setChecked() : void
      {
         clearListeners();
         mcCheck.visible = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CLICK));
      }
      
      public function getBitmap() : Bitmap
      {
         return _bmpBadge;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ROLL_OVER));
      }
      
      private function onLoadBadgeError(param1:IOErrorEvent) : void
      {
         _ldrBadge.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadBadgeComplete);
         _ldrBadge.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadBadgeError);
         _ldrBadge.unload();
         _ldrBadge = null;
         toggleEnabled(false);
         DebugLog.instance.error("BadgeCell.onLoadBadgeError: " + param1.text);
         dispatchEvent(new Event(LOAD_ERROR));
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
      
      public function clearListeners() : void
      {
         if(!_bEnabled)
         {
            return;
         }
         mcHit.removeEventListener(MouseEvent.ROLL_OVER,onRollOver);
         mcHit.removeEventListener(MouseEvent.ROLL_OUT,onRollOut);
         mcHit.removeEventListener(MouseEvent.CLICK,onClick);
      }
   }
}

