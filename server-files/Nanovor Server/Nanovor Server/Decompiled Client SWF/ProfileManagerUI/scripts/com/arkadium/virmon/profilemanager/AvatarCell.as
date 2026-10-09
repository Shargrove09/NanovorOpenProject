package com.arkadium.virmon.profilemanager
{
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol31")]
   public class AvatarCell extends Sprite
   {
      
      public static const LOAD_COMPLETE:String = "avatarCellLoadComplete";
      
      public static const LOAD_ERROR:String = "avatarCellLoadError";
      
      public static const ROLL_OVER:String = "avatarCellRollOver";
      
      public static const ROLL_OUT:String = "avatarCellRollOut";
      
      public static const CLICK:String = "avatarCellClick";
      
      public var mcHit:MovieClip;
      
      public var mcContainer:MovieClip;
      
      public var iAvatarId:int;
      
      private var _ldrAvatar:Loader;
      
      public var mcShading:MovieClip;
      
      public var bSelected:Boolean = false;
      
      private var _bEnabled:Boolean = false;
      
      public function AvatarCell(param1:int, param2:Boolean = true)
      {
         super();
         iAvatarId = param1;
         if(param2)
         {
            loadAvatar();
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CLICK));
      }
      
      private function onLoadAvatarError(param1:IOErrorEvent) : void
      {
         _ldrAvatar.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarComplete);
         _ldrAvatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarError);
         _ldrAvatar.unload();
         _ldrAvatar = null;
         toggleEnabled(false);
         DebugLog.instance.error("AvatarCell.onLoadAvatarError: " + param1.text);
         dispatchEvent(new Event(LOAD_ERROR));
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
      
      private function onRollOver(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ROLL_OVER));
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
      
      private function onLoadAvatarComplete(param1:Event) : void
      {
         _ldrAvatar.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarComplete);
         _ldrAvatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarError);
         var _loc2_:Bitmap = param1.target.content as Bitmap;
         _ldrAvatar.unload();
         mcContainer.addChild(_loc2_);
         _ldrAvatar = null;
         toggleEnabled(true);
         dispatchEvent(new Event(LOAD_COMPLETE));
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ROLL_OUT));
      }
      
      public function clearLoaded() : void
      {
         if(Boolean(_ldrAvatar))
         {
            _ldrAvatar.unload();
            try
            {
               _ldrAvatar.close();
            }
            catch(e:Error)
            {
            }
            _ldrAvatar = null;
         }
      }
      
      private function loadAvatar() : void
      {
         _ldrAvatar = new Loader();
         var _loc1_:String = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarURL(AvatarAssetType.LARGE,iAvatarId).url;
         _ldrAvatar.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadAvatarComplete,false,0,true);
         _ldrAvatar.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarError,false,0,true);
         _ldrAvatar.load(new URLRequest(_loc1_));
      }
   }
}

