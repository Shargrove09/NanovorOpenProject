package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.avatar.AvatarManager;
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
   import flash.geom.ColorTransform;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol43")]
   public class PlayerTile extends Sprite
   {
      
      private static var _acceptBottomColor:ColorTransform;
      
      private static var _acceptTopColor:ColorTransform;
      
      public static const MODE_AVAILABLE:String = "AVAILABLE";
      
      public static const MODE_IN_BATTLE:String = "IN BATTLE";
      
      public static const MODE_IN_TRADE:String = "IN TRADE";
      
      public static const MODE_UNAVAILABLE:String = "UNAVAILABLE";
      
      public static const MODE_ACCEPT:String = "ACCEPT";
      
      public static const MODES:Array = [MODE_UNAVAILABLE,MODE_AVAILABLE,MODE_IN_BATTLE,MODE_IN_TRADE];
      
      public var tfStatus:TextField;
      
      public var tfSubStatus:TextField;
      
      public var mcAvatar:MovieClip;
      
      public var tfName:TextField;
      
      public var tfStatus2:TextField;
      
      public var sortStatus:int;
      
      private var _avatarId:int = 0;
      
      public var mcAvatarSpinnerTarget:MovieClip;
      
      private var _sortStatus:int;
      
      private var _nmp:int = -1;
      
      private var _currentModeIndex:int = 0;
      
      public var playerId:int;
      
      public var mcTopBG:MovieClip;
      
      public var mcBottomBG:MovieClip;
      
      private var _avatarPic:Loader;
      
      private var _inactiveStatus:TextField;
      
      private var _activeStatus:TextField;
      
      private var _currentMode:String;
      
      public function PlayerTile()
      {
         super();
         this._activeStatus = this.tfStatus;
         this._inactiveStatus = this.tfStatus2;
         this._inactiveStatus.alpha = 0;
         this.tfSubStatus.alpha = 0;
         if(_acceptTopColor == null || _acceptBottomColor == null)
         {
            _acceptTopColor = new ColorTransform();
            _acceptTopColor.color = 13476356;
            _acceptBottomColor = new ColorTransform();
            _acceptBottomColor.color = 7228160;
         }
         this.mode = MODES.indexOf(MODE_UNAVAILABLE);
         this._currentModeIndex = 3;
         this._currentMode = MODES[this._currentModeIndex];
         addEventListener(MouseEvent.CLICK,this.onPlayerTileClick);
         this.mcAvatar.mouseEnabled = false;
         this.mcAvatar.mouseChildren = false;
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onPlayerTileClick);
      }
      
      private function swapActiveFields() : void
      {
         if(this._activeStatus == this.tfStatus)
         {
            this._activeStatus = this.tfStatus2;
            this._inactiveStatus = this.tfStatus;
         }
         else
         {
            this._activeStatus = this.tfStatus;
            this._inactiveStatus = this.tfStatus2;
         }
      }
      
      public function set playerName(param1:String) : void
      {
         this.tfName.text = param1;
      }
      
      public function loadAvatarPicture(param1:int) : void
      {
         var avatarUrl:String;
         var avatarId:int = param1;
         this._avatarId = avatarId;
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
         avatarUrl = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarURL(AvatarAssetType.MEDIUM,avatarId).url;
         this._avatarPic = new Loader();
         this._avatarPic.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadAvatarPicComplete,false,0,true);
         this._avatarPic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadAvatarPicError,false,0,true);
         this._avatarPic.load(new URLRequest(avatarUrl));
      }
      
      public function set nmp(param1:int) : void
      {
         this._nmp = param1;
      }
      
      public function set subStatus(param1:String) : void
      {
         this.tfSubStatus.text = param1;
      }
      
      public function set mode(param1:*) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:int = param1 is String ? int(MODES.indexOf(param1)) : param1;
         var _loc3_:String = param1 is String ? param1 : MODES[_loc2_];
         this._currentMode = _loc3_;
         this._currentModeIndex = _loc2_;
         if(_loc3_ == MODE_ACCEPT)
         {
            this.setAcceptMode();
            return;
         }
         this.showSubStatus(_loc3_ == MODE_AVAILABLE);
         this.fadeAvatarAndName(_loc3_ == MODE_UNAVAILABLE);
         switch(_loc3_)
         {
            case MODE_AVAILABLE:
               _loc4_ = 9492709;
               _loc5_ = 601157;
               _loc6_ = 1393501;
               break;
            case MODE_IN_BATTLE:
               _loc4_ = 12673634;
               _loc5_ = 4916995;
               _loc6_ = 7471110;
               break;
            case MODE_IN_TRADE:
               _loc4_ = 16616506;
               _loc5_ = 4924419;
               _loc6_ = 7481344;
               break;
            default:
               _loc4_ = 3158064;
               _loc5_ = 1184274;
               _loc6_ = 657930;
         }
         Tweener.addTween(this.mcTopBG,{
            "_color":_loc5_,
            "time":1
         });
         Tweener.addTween(this.mcBottomBG,{
            "_color":_loc6_,
            "time":1
         });
         this._inactiveStatus.text = _loc3_;
         this._inactiveStatus.textColor = _loc4_;
         Tweener.addTween(this._activeStatus,{
            "alpha":0,
            "time":1
         });
         Tweener.addTween(this._inactiveStatus,{
            "alpha":1,
            "time":1
         });
         this.swapActiveFields();
      }
      
      private function onPlayerTileClick(param1:MouseEvent) : void
      {
         DebugLog.instance.log("<<PlayerTile>> onPlayerTileClick: " + this.tfName.text);
         AvatarManager.getInstance().handleAvatarClick(this.mcAvatarSpinnerTarget,this.tfName.text,this._avatarId,this._nmp);
         param1.stopImmediatePropagation();
      }
      
      private function setAcceptMode() : void
      {
         Tweener.removeTweens(this._activeStatus,alpha,y);
         Tweener.removeTweens(this.tfSubStatus,alpha);
         Tweener.removeTweens(this.mcAvatar,alpha);
         Tweener.removeTweens(this.tfName,"_color");
         Tweener.removeTweens(this.mcTopBG,"_color");
         Tweener.removeTweens(this.mcBottomBG,"_color");
         Tweener.removeTweens(this._activeStatus,alpha);
         this.mcAvatar.alpha = 1;
         this._activeStatus.text = "ACCEPT";
         this._activeStatus.alpha = 1;
         this._activeStatus.y = 83;
         this._activeStatus.textColor = 16763726;
         this.mcTopBG.transform.colorTransform = _acceptTopColor;
         this.mcBottomBG.transform.colorTransform = _acceptBottomColor;
         this.tfName.textColor = 0;
         removeEventListener(MouseEvent.CLICK,this.onPlayerTileClick);
      }
      
      private function fadeAvatarAndName(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(this.mcAvatar,{
               "alpha":0.25,
               "time":0
            });
            Tweener.addTween(this.tfName,{
               "_color":7566195,
               "time":1
            });
         }
         else
         {
            Tweener.addTween(this.mcAvatar,{
               "alpha":1,
               "time":0
            });
            Tweener.addTween(this.tfName,{
               "_color":16777215,
               "time":1
            });
         }
      }
      
      private function showSubStatus(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(this.tfStatus,{
               "y":83,
               "time":0.5
            });
            Tweener.addTween(this.tfStatus2,{
               "y":83,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(this.tfStatus,{
               "y":88,
               "time":0.5
            });
            Tweener.addTween(this.tfStatus2,{
               "y":88,
               "time":0.5
            });
         }
      }
      
      private function onLoadAvatarPicComplete(param1:Event) : void
      {
         this._avatarPic.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadAvatarPicComplete);
         this._avatarPic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadAvatarPicError);
         var _loc2_:Bitmap = new Bitmap((this._avatarPic.contentLoaderInfo.content as Bitmap).bitmapData);
         _loc2_.x = -5;
         _loc2_.y = -6;
         _loc2_.width = 60;
         _loc2_.height = 60;
         _loc2_.alpha = 0;
         this.mcAvatar.addChild(_loc2_);
         Tweener.addTween(_loc2_,{
            "alpha":1,
            "time":1
         });
         while(this.mcAvatar.numChildren > 1)
         {
            this.mcAvatar.removeChildAt(0);
         }
         this._avatarPic.unload();
         this._avatarPic = null;
      }
      
      public function set avatarID(param1:int) : void
      {
         this.loadAvatarPicture(param1);
      }
      
      override public function toString() : String
      {
         return "[PlayerTile] playerId: " + this.playerId + ", currentMode: " + this._currentMode + ", playerName: " + this.tfName.text;
      }
      
      private function onLoadAvatarPicError(param1:IOErrorEvent) : void
      {
         this._avatarPic.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadAvatarPicComplete);
         this._avatarPic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadAvatarPicError);
         this._avatarPic.unload();
         this._avatarPic = null;
      }
   }
}

