package com.arkadium.virmon.shared.components.avatar
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IAvatarAssetRetriever;
   import com.arkadium.virmon.shared.components.ISwarmometer;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.text.EuroStileText;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Avatar extends Sprite implements IAvatar
   {
      
      private static const OVERRIDE_TWEEN_SECONDS:Number = 0.15;
      
      private static const GENERAL_TWEEN_SECONDS:Number = 1;
      
      private static const MODE_BATTLE_POINT:Point = new Point(3,-5);
      
      private static const MODE_DASHBOARD_POINT:Point = new Point(-6,-36);
      
      private static const DECAL_LABEL_RED:String = "Red";
      
      private static const DECAL_LABEL_BLUE:String = "Blue";
      
      private static const BOTTOM_RIGHT_START_X:Number = 176;
      
      private static const BOTTOM_RIGHT_END_X:Number = 131;
      
      private static const SLIDER_START_X:Number = -4;
      
      private static const SLIDER_END_X:Number = -49;
      
      private static const NMP_START_X:Number = 86;
      
      private static const NMP_END_X:Number = 100;
      
      private static const ENERGY_CONTAINER_X:int = 148;
      
      private static const ENERGY_CONTAINER_Y:int = 30;
      
      public var tfStatus:TextField;
      
      public var mcAvatarHead:MovieClip;
      
      public var mcSlider:MovieClip;
      
      private var _playerID:int;
      
      public var tfPlayerName:TextField;
      
      private var _override:Sprite;
      
      private var _avatarAssetRetriever:IAvatarAssetRetriever;
      
      public var mcGlow:MovieClip;
      
      public var mcBottomLeftBG:MovieClip;
      
      public var tfNMP2:TextField;
      
      private var _decalColor:MovieClip;
      
      public var mcNMPLogo:MovieClip;
      
      private var _ldrAvatarPic:Loader;
      
      private var _tfEnergyLabel:TextField;
      
      private var _bPictureXed:Boolean = false;
      
      private var _energyContainer:Sprite;
      
      private var _overridePopupController:OverridePopupController;
      
      private var _picture:MovieClip;
      
      public var mcBottomRightBG:MovieClip;
      
      private var _overrideSlot:MovieClip;
      
      private var _currentStatus:String;
      
      public var tfNMP:TextField;
      
      private var _pictureOverlayX:MovieClip;
      
      private var _currentMode:String;
      
      private var _tfEnergyValue:TextField;
      
      public function Avatar(param1:IAvatarAssetRetriever)
      {
         var _loc2_:* = undefined;
         super();
         _avatarAssetRetriever = param1;
         createNMPText();
         _picture = mcAvatarHead.mcPicture;
         _pictureOverlayX = mcAvatarHead.mcOverlayX;
         _pictureOverlayX.alpha = 0;
         _pictureOverlayX.visible = false;
         _decalColor = mcAvatarHead.mcHeadBG.mcDecals;
         _overrideSlot = mcAvatarHead.mcOverride;
         mcAvatarHead.swarmometer.y -= 34;
         _overrideSlot.alpha = 0;
         tfStatus.alpha = 0;
         createOverrideSlot();
         createEnergyContainer();
         this.color = Const.AVATAR_WIDGET_COLOR_BLUE;
         var _loc3_:int = 0;
         while(_loc3_ < this.numChildren)
         {
            _loc2_ = this.getChildAt(_loc3_);
            if(_loc2_ !== mcAvatarHead)
            {
               if(_loc2_ as DisplayObjectContainer != null)
               {
                  _loc2_.mouseEnabled = false;
                  _loc2_.mouseChildren = false;
               }
               else if(_loc2_ as InteractiveObject != null)
               {
                  _loc2_.mouseEnabled = false;
               }
            }
            _loc3_++;
         }
         mcAvatarHead.mouseEnabled = false;
         _picture.mouseEnabled = false;
         _overrideSlot.mouseEnabled = false;
         this.mouseEnabled = false;
         _overridePopupController = new OverridePopupController(_overrideSlot.mcOverridePopup);
         _overrideSlot.setChildIndex(_overrideSlot.mcOverridePopup,_overrideSlot.numChildren - 1);
      }
      
      private function createOverrideSlot() : void
      {
         _override = new Sprite();
         _override.x = 7;
         _override.y = 8;
         _overrideSlot.addChild(_override);
      }
      
      public function get playerName() : String
      {
         return tfPlayerName.text;
      }
      
      public function set energy(param1:int) : void
      {
         _tfEnergyValue.text = param1.toString();
      }
      
      public function set playerName(param1:String) : void
      {
         tfPlayerName.text = param1;
      }
      
      public function set glow(param1:Boolean) : void
      {
         if(param1)
         {
            showGlow();
         }
         else
         {
            hideGlow();
         }
      }
      
      public function set nmp(param1:int) : void
      {
         tfNMP.text = "NMP    " + param1.toString();
      }
      
      public function loadAvatarPicture(param1:int) : void
      {
         var szAvatarUrl:String;
         var iAvatarId:int = param1;
         if(Boolean(_ldrAvatarPic))
         {
            try
            {
               _ldrAvatarPic.unload();
               _ldrAvatarPic.close();
            }
            catch(e:Error)
            {
            }
         }
         szAvatarUrl = _avatarAssetRetriever.getAvatarURL(AvatarAssetType.MEDIUM,iAvatarId).url;
         _ldrAvatarPic = new Loader();
         _ldrAvatarPic.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadAvatarPicComplete,false,0,true);
         _ldrAvatarPic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError,false,0,true);
         _ldrAvatarPic.load(new URLRequest(szAvatarUrl));
      }
      
      private function showGlow() : void
      {
      }
      
      private function hideOverride() : void
      {
         Tweener.removeTweens(_overrideSlot,"alpha");
         Tweener.addTween(_overrideSlot,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS,
            "onComplete":function():*
            {
               _overrideSlot.visible = false;
            }
         });
      }
      
      private function showPictureX() : void
      {
         if(_bPictureXed)
         {
            return;
         }
         _bPictureXed = true;
         Tweener.removeTweens(_picture,"_saturation");
         Tweener.removeTweens(_pictureOverlayX,"_autoAlpha");
         Tweener.addTween(_picture,{
            "_saturation":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(_pictureOverlayX,{
            "_autoAlpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      private function setModeBattle() : void
      {
         Tweener.addTween(mcAvatarHead,{
            "x":MODE_BATTLE_POINT.x,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcAvatarHead,{
            "y":MODE_BATTLE_POINT.y,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      public function setStatusText(param1:String, param2:uint = 16777216) : void
      {
         var _loc3_:TextFormat = null;
         if(param2 <= 16777215)
         {
            _loc3_ = tfStatus.defaultTextFormat;
            _loc3_.color = param2;
            _loc3_.bold = true;
            tfStatus.defaultTextFormat = _loc3_;
         }
         tfStatus.text = param1;
      }
      
      private function createEnergyContainer() : void
      {
         _tfEnergyLabel = new EuroStileText("ENERGY",EuroStileText.EUROSTILE_BOLD_CONDENSED,12,3355443);
         _tfEnergyValue = new EuroStileText("000",EuroStileText.EUROSTILE_BOLD_CONDENSED,12,0);
         _tfEnergyValue.x = _tfEnergyLabel.x + _tfEnergyLabel.textWidth + 10;
         _energyContainer = new Sprite();
         _energyContainer.addChild(_tfEnergyLabel);
         _energyContainer.addChild(_tfEnergyValue);
         _energyContainer.x = ENERGY_CONTAINER_X;
         _energyContainer.y = ENERGY_CONTAINER_Y;
         _energyContainer.alpha = 0;
         this.addChild(_energyContainer);
      }
      
      private function onOverrideRollOut(param1:MouseEvent) : void
      {
         _overridePopupController.close();
      }
      
      private function setStatusOutOfBattle() : void
      {
         Tweener.addTween(mcSlider,{
            "x":SLIDER_START_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "x":BOTTOM_RIGHT_START_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP,{
            "x":NMP_START_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.removeTweens(mcBottomRightBG,"_color");
         mcBottomRightBG.transform.colorTransform = new ColorTransform();
         Tweener.addTween(_energyContainer,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP2,{
            "alpha":1,
            "x":228,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcNMPLogo,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomLeftBG,{
            "width":131.25,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfStatus,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         hidePictureX();
         swarmometer.hide();
         swarmometer.clearMeters();
      }
      
      private function showOverrideChain() : void
      {
         _overrideSlot.visible = true;
         Tweener.removeTweens(_overrideSlot,"alpha");
         Tweener.addTween(_overrideSlot,{
            "alpha":1,
            "time":OVERRIDE_TWEEN_SECONDS
         });
         Tweener.addTween(_overrideSlot,{
            "_color":16777215,
            "time":OVERRIDE_TWEEN_SECONDS,
            "onComplete":removeOverrideTint
         });
      }
      
      private function setStatusDiedInBattle() : void
      {
         Tweener.addTween(mcSlider,{
            "x":SLIDER_END_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(_energyContainer,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP2,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcNMPLogo,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomLeftBG,{
            "width":220,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfStatus,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         if(_overrideSlot.visible)
         {
            hideOverride();
         }
         swarmometer.hide();
         swarmometer.clearMeters();
         showPictureX();
         setStatusText("GAME OVER");
      }
      
      public function setOverride(param1:*) : void
      {
         DebugLog.instance.log("%rsk% Avatar: setOverride: overrideIcon=" + param1 + " _overrideSlot.visible=" + _overrideSlot.visible + " _overrideSlot.alpha=" + _overrideSlot.alpha);
         while(_override.numChildren > 0)
         {
            _override.removeChildAt(0);
         }
         _override.removeEventListener(MouseEvent.ROLL_OVER,onOverrideRollOver);
         _override.removeEventListener(MouseEvent.ROLL_OUT,onOverrideRollOut);
         if(param1 != null)
         {
            _override.addChild(param1);
            _overridePopupController.text = param1.overrideDescription;
            _override.addEventListener(MouseEvent.ROLL_OVER,onOverrideRollOver,false,0,true);
            _override.addEventListener(MouseEvent.ROLL_OUT,onOverrideRollOut,false,0,true);
         }
         else
         {
            _overridePopupController.close();
         }
      }
      
      public function set mode(param1:String) : void
      {
         if(_currentMode == param1)
         {
            return;
         }
         energy = 0;
         _currentMode = param1;
         switch(_currentMode)
         {
            case Const.AVATAR_MODE_BATTLE:
               setModeBattle();
               break;
            case Const.AVATAR_MODE_DASHBOARD:
               setModeDashboard();
         }
      }
      
      public function set playerID(param1:int) : void
      {
         _playerID = param1;
      }
      
      private function hidePictureX() : void
      {
         if(!_bPictureXed)
         {
            return;
         }
         _bPictureXed = false;
         Tweener.removeTweens(_picture,"_saturation");
         Tweener.removeTweens(_pictureOverlayX,"_autoAlpha");
         Tweener.addTween(_picture,{
            "_saturation":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(_pictureOverlayX,{
            "_autoAlpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      private function removeOverrideTint() : void
      {
         Tweener.addTween(_overrideSlot,{
            "_colorTransform":new ColorTransform(),
            "time":OVERRIDE_TWEEN_SECONDS
         });
      }
      
      public function set override(param1:Boolean) : void
      {
         if(param1)
         {
            showOverrideChain();
         }
         else
         {
            hideOverride();
         }
      }
      
      private function setStatusLeftBattle() : void
      {
         Tweener.addTween(mcSlider,{
            "x":SLIDER_END_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(_energyContainer,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP2,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcNMPLogo,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomLeftBG,{
            "width":220,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfStatus,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         if(_overrideSlot.visible)
         {
            hideOverride();
         }
         swarmometer.hide();
         swarmometer.clearMeters();
         showPictureX();
         setStatusText("LEFT BATTLE");
      }
      
      public function get playerID() : int
      {
         return _playerID;
      }
      
      private function createNMPText() : void
      {
         tfNMP = new EBCText();
         tfNMP.x = 85;
         tfNMP.y = 29;
         addChild(tfNMP);
      }
      
      public function set color(param1:uint) : void
      {
         switch(param1)
         {
            case Const.AVATAR_WIDGET_COLOR_RED:
               _decalColor.gotoAndStop(DECAL_LABEL_RED);
               break;
            default:
               _decalColor.gotoAndStop(DECAL_LABEL_BLUE);
         }
      }
      
      public function set nanocash(param1:int) : void
      {
         tfNMP2.text = param1.toString();
      }
      
      private function setStatusBattle() : void
      {
         Tweener.addTween(mcSlider,{
            "x":SLIDER_END_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "x":BOTTOM_RIGHT_END_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP,{
            "x":NMP_END_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "_color":16373044,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(_energyContainer,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP2,{
            "alpha":0,
            "x":186,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcNMPLogo,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomLeftBG,{
            "width":131.25,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfStatus,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         hidePictureX();
         setStatusText("BUILDING SWARM...",16777215);
      }
      
      private function onOverrideRollOver(param1:MouseEvent) : void
      {
         _overridePopupController.open();
      }
      
      private function setStatusBattleWaiting() : void
      {
         Tweener.addTween(mcSlider,{
            "x":SLIDER_END_X,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomRightBG,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(_energyContainer,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfNMP2,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcNMPLogo,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcBottomLeftBG,{
            "width":220,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(tfStatus,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
         hidePictureX();
      }
      
      private function onLoadAvatarPicError(param1:IOErrorEvent) : void
      {
         _ldrAvatarPic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarPicComplete);
         _ldrAvatarPic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError);
         _ldrAvatarPic.unload();
         _ldrAvatarPic = null;
      }
      
      public function set status(param1:String) : void
      {
         if(_currentStatus == param1)
         {
            return;
         }
         _currentStatus = param1;
         switch(_currentStatus)
         {
            case Const.AVATAR_STATUS_BATTLE:
               setStatusBattle();
               break;
            case Const.AVATAR_STATUS_BATTLE_WAITING:
               setStatusBattleWaiting();
               break;
            case Const.AVATAR_STATUS_OUT_OF_BATTLE:
               setStatusOutOfBattle();
               break;
            case Const.AVATAR_STATUS_LEFT_BATTLE:
               setStatusLeftBattle();
               break;
            case Const.AVATAR_STATUS_DIED_IN_BATTLE:
               setStatusDiedInBattle();
         }
      }
      
      private function onLoadAvatarPicComplete(param1:Event) : void
      {
         _ldrAvatarPic.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarPicComplete);
         _ldrAvatarPic.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError);
         var _loc2_:Bitmap = new Bitmap((_ldrAvatarPic.contentLoaderInfo.content as Bitmap).bitmapData);
         _loc2_.x = -5;
         _loc2_.y = -6;
         _loc2_.width = 60;
         _loc2_.height = 60;
         _picture.addChild(_loc2_);
         while(_picture.numChildren > 1)
         {
            _picture.removeChildAt(0);
         }
         _ldrAvatarPic.unload();
         _ldrAvatarPic = null;
      }
      
      private function hideGlow() : void
      {
      }
      
      public function get swarmometer() : ISwarmometer
      {
         return mcAvatarHead.swarmometer;
      }
      
      private function setModeDashboard() : void
      {
         if(_overrideSlot.alpha != 0)
         {
            hideOverride();
         }
         setOverride(null);
         Tweener.addTween(mcAvatarHead,{
            "x":MODE_DASHBOARD_POINT.x,
            "time":GENERAL_TWEEN_SECONDS
         });
         Tweener.addTween(mcAvatarHead,{
            "y":MODE_DASHBOARD_POINT.y,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
   }
}

