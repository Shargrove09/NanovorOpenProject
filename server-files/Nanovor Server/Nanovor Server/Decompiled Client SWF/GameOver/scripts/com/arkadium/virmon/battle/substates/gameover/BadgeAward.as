package com.arkadium.virmon.battle.substates.gameover
{
   import com.arkadium.virmon.framework.BadgeMasterData;
   import com.arkadium.virmon.framework.IBadgeData;
   import com.arkadium.virmon.shared.data.Managers;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   public class BadgeAward extends MovieClip
   {
      
      public var BadgeDescHolder:MovieClip;
      
      public var BadgeDescText:TextField;
      
      public var BadgeImposter:MovieClip;
      
      public var BadgeImageHolder:MovieClip;
      
      private var _masterData:BadgeMasterData;
      
      private var _badgeData:IBadgeData;
      
      private var _loader:Loader;
      
      public var BadgeNameHolder:MovieClip;
      
      public var BadgeNameText:TextField;
      
      public function BadgeAward(param1:IBadgeData)
      {
         super();
         stop();
         _badgeData = param1;
         BadgeNameText = BadgeNameHolder.BadgeNameText;
         BadgeDescText = BadgeDescHolder.BadgeDescText;
         BadgeImposter = BadgeImageHolder.BadgeImposter;
         BadgeImposter.visible = false;
         BadgeNameText.text = param1.getName();
         BadgeDescText.text = param1.getShortDescription();
         _loader = new Loader();
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler,false,0,true);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler,false,0,true);
         var _loc2_:String = Managers.assetRetrieverManager.badgeAssetRetriever.getBadgeURL(param1.getIconId()).url;
         _loader.load(new URLRequest(_loc2_));
      }
      
      private function loadCompleteHandler(param1:Event) : void
      {
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
         var _loc2_:Bitmap = Bitmap(param1.target.content);
         BadgeImageHolder.addChild(_loc2_);
         _loc2_.smoothing = true;
         _loc2_.x = _loc2_.y = -38;
         _loader.unload();
         _loader = null;
      }
      
      private function loadErrorHandler(param1:IOErrorEvent) : void
      {
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
         DebugLog.instance.error("BadgeAward: " + param1.toString());
         gotoAndStop(totalFrames - 1);
      }
   }
}

