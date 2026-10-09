package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   
   public class AvatarLoader implements IAvatarLoader
   {
      
      private var _avatarLoaderConsumer:IAvatarLoaderConsumer;
      
      private var _avatarPic:Loader;
      
      private var _avatarAssetType:AvatarAssetType;
      
      public function AvatarLoader()
      {
         super();
      }
      
      private function handleLoadAvatarPicComplete(param1:Event) : void
      {
         this._avatarPic.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleLoadAvatarPicComplete);
         this._avatarPic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadAvatarPicError);
         var _loc2_:Bitmap = new Bitmap((this._avatarPic.contentLoaderInfo.content as Bitmap).bitmapData);
         _loc2_.x = -5;
         _loc2_.y = -6;
         _loc2_.width = 60;
         _loc2_.height = 60;
         if(this._avatarAssetType == AvatarAssetType.SMALL)
         {
            _loc2_.width = 48;
            _loc2_.height = 48;
         }
         _loc2_.alpha = 0;
         this._avatarLoaderConsumer.handleAvatarLoadComplete(_loc2_);
         this._avatarPic.unload();
         this._avatarPic = null;
      }
      
      private function handleLoadAvatarPicError(param1:IOErrorEvent) : void
      {
         DebugLog.instance.log("<<AvatarLoader>> handleLoadAvatarPicError");
         this._avatarPic.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleLoadAvatarPicComplete);
         this._avatarPic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.handleLoadAvatarPicError);
         this._avatarLoaderConsumer.handleAvatarLoadError(param1.text);
         this._avatarPic.unload();
         this._avatarPic = null;
      }
      
      public function loadAvatarPicture(param1:int, param2:IAvatarLoaderConsumer) : void
      {
         this._avatarAssetType = AvatarAssetType.MEDIUM;
         this.loadAvatarFromGroup(param1,AvatarAssetType.MEDIUM,param2);
      }
      
      private function loadAvatarFromGroup(param1:int, param2:AvatarAssetType, param3:IAvatarLoaderConsumer) : void
      {
         var avatarUrl:String;
         var avatarId:int = param1;
         var avatarAssetType:AvatarAssetType = param2;
         var avatarLoaderConsumer:IAvatarLoaderConsumer = param3;
         DebugLog.instance.log("<<AvatarLoader>> loadAvatarPicture");
         this._avatarLoaderConsumer = avatarLoaderConsumer;
         if(Boolean(this._avatarPic))
         {
            try
            {
               this._avatarPic.unload();
               this._avatarPic.close();
            }
            catch(e:Error)
            {
            }
         }
         avatarUrl = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarURL(avatarAssetType,avatarId).url;
         this._avatarPic = new Loader();
         this._avatarPic.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleLoadAvatarPicComplete,false,0,true);
         this._avatarPic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleLoadAvatarPicError,false,0,true);
         this._avatarPic.load(new URLRequest(avatarUrl));
      }
      
      public function loadSmallAvatarPicture(param1:int, param2:IAvatarLoaderConsumer) : void
      {
         this._avatarAssetType = AvatarAssetType.SMALL;
         this.loadAvatarFromGroup(param1,AvatarAssetType.SMALL,param2);
      }
   }
}

