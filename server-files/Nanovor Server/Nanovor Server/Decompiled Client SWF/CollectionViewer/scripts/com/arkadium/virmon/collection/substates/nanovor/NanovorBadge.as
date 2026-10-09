package com.arkadium.virmon.collection.substates.nanovor
{
   import com.arkadium.virmon.collection.substates.nanovor.components.NanovorBadgeFlashComponent;
   import com.arkadium.virmon.framework.IBadgeData;
   import com.arkadium.virmon.shared.components.NewStamp;
   import com.arkadium.virmon.shared.data.Managers;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class NanovorBadge extends Sprite
   {
      
      public static const WIDTH:Number = 74;
      
      public static const HEIGHT:Number = 74;
      
      private var _isNewBadge:Boolean;
      
      private var _badgeData:IBadgeData;
      
      private var _flash:NanovorBadgeFlashComponent;
      
      private var _badgeLoader:Loader;
      
      private var _badgeContainer:Sprite;
      
      public function NanovorBadge(param1:IBadgeData)
      {
         super();
         _badgeData = param1;
         _isNewBadge = false;
         createFlash();
         this.mouseChildren = false;
         _badgeContainer = new Sprite();
         this.addChild(_badgeContainer);
         _badgeLoader = new Loader();
         _badgeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onBadgeLoadComplete,false,0,true);
         _badgeLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onBadgeLoadFailure,false,0,true);
         var _loc2_:String = Managers.assetRetrieverManager.badgeAssetRetriever.getBadgeURL(param1.getIconId()).url;
         _badgeLoader.load(new URLRequest(_loc2_));
      }
      
      private function onBadgeLoadFailure(param1:IOErrorEvent) : void
      {
         logError("Player badges failed to load");
      }
      
      private function onBadgeLoadComplete(param1:Event) : void
      {
         var _loc3_:NewStamp = null;
         _badgeLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBadgeLoadComplete);
         _badgeLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onBadgeLoadFailure);
         var _loc2_:Bitmap = Bitmap(param1.target.content);
         _loc2_.smoothing = true;
         _badgeContainer.addChild(_loc2_);
         _badgeLoader.unload();
         _badgeLoader = null;
         if(_isNewBadge)
         {
            _loc3_ = new NewStamp();
            _badgeContainer.addChild(_loc3_);
            _loc3_.x = -10;
            _loc3_.y = 10;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorOverBadge: " + param1);
      }
      
      public function open() : void
      {
         _flash.open();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> NanovorOverBadge: " + param1);
      }
      
      public function get badgeData() : IBadgeData
      {
         return _badgeData;
      }
      
      public function get isNewBadge() : Boolean
      {
         return _isNewBadge;
      }
      
      private function createFlash() : void
      {
         _flash = new NanovorBadgeFlashComponent();
         _flash.x = WIDTH / 2;
         _flash.y = HEIGHT / 2;
         _flash.mouseEnabled = false;
         _flash.mouseChildren = false;
         _flash.stop();
         this.addChildAt(_flash,0);
      }
      
      public function close() : void
      {
         _flash.close();
      }
   }
}

