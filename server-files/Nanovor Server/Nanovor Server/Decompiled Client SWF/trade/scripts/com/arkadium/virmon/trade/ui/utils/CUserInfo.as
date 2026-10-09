package com.arkadium.virmon.trade.ui.utils
{
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   public class CUserInfo extends MovieClip
   {
      
      public var mcGlow:MovieClip;
      
      public var _tfUserName:TextField;
      
      public var _mcAvatarContainer:MovieClip;
      
      public var _tfUserStatus:TextField;
      
      private var _ldr:Loader;
      
      private var _iAvatarId:int;
      
      public function CUserInfo()
      {
         super();
         _tfUserName.text = "?";
         _tfUserStatus.text = "?";
      }
      
      public function destroy() : void
      {
         try
         {
            _ldr.close();
            _ldr.unload();
            _mcAvatarContainer.removeChild(_ldr);
            _ldr = null;
         }
         catch(e:*)
         {
         }
         Utils.clearAllChildren(this);
      }
      
      public function set status(param1:String) : void
      {
         _tfUserStatus.text = String(param1).toUpperCase();
      }
      
      public function set AvatarID(param1:int) : *
      {
         _iAvatarId = param1;
         loadAvatar();
      }
      
      private function onErrorAvatarLoad(param1:IOErrorEvent) : void
      {
         _ldr.removeEventListener(Event.COMPLETE,onCompleteAvatarLoad);
         _ldr.removeEventListener(IOErrorEvent.IO_ERROR,onErrorAvatarLoad);
         DebugLog.instance.error("CUserInfo: onErrorAvatarLoad .. " + param1.text);
      }
      
      private function onCompleteAvatarLoad(param1:Event) : void
      {
         _ldr.removeEventListener(Event.COMPLETE,onCompleteAvatarLoad);
         _ldr.removeEventListener(IOErrorEvent.IO_ERROR,onErrorAvatarLoad);
         _ldr.x = -25;
         _ldr.y = -25;
         _ldr.width = 48;
         _ldr.height = 48;
      }
      
      override public function set name(param1:String) : void
      {
         _tfUserName.text = String(param1);
      }
      
      private function loadAvatar() : void
      {
         var _loc1_:String = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarURL(AvatarAssetType.SMALL,_iAvatarId).url;
         _ldr = new Loader();
         _ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteAvatarLoad,false,0,true);
         _ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErrorAvatarLoad,false,0,true);
         _ldr.load(new URLRequest(_loc1_));
         _mcAvatarContainer.addChild(_ldr);
      }
   }
}

