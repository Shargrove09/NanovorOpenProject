package com.arkadium.virmon.shared.widgets.megawidget
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonSmallComponent;
   import com.arkadium.virmon.shared.utils.LoopHelper;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol33")]
   public class MegaWidgetAvatarSpinner extends MovieClip
   {
      
      public static const MENU_MODE_GENERAL:String = "menuGeneral";
      
      public static const MENU_MODE_PENDING:String = "menuPending";
      
      public static const MENU_MODE_TIMER:String = "menuTimer";
      
      public static const MENU_MODE_NONE:String = "menuNone";
      
      public static const MENU_MODE_KICK:String = "menuKick";
      
      public static const COLOR_WHITE:uint = 12776188;
      
      public static const COLOR_BLUE:uint = 6597314;
      
      public static const COLOR_ORANGE:uint = 14452533;
      
      public static const COLOR_GREEN:uint = 11069549;
      
      public static const MODE_ACTIVE:String = "active";
      
      public static const MODE_INACTIVE:String = "inactive";
      
      public static const MODE_TIMER:String = "timer";
      
      public static const MODE_BATTLE_ENTER:String = "battleEnter";
      
      public static const MODE_BATTLE_EXIT:String = "battleExit";
      
      public static const NAME_ORIENTATION_TOP_RIGHT:String = "topRight";
      
      public static const NAME_ORIENTATION_BOTTOM_RIGHT:String = "bottomRight";
      
      private static const TIMER_ANGLE_FULL:int = 46;
      
      private static const TIMER_ANGLE_EMPTY:int = 134;
      
      private static const TIMER_ANGLE_PERCENTAGE_DELTA:Number = (TIMER_ANGLE_EMPTY - TIMER_ANGLE_FULL) / 100;
      
      private static const GLOW_SIZE_START:int = 40;
      
      private static const GLOW_SIZE_END:int = 120;
      
      private var _menuMode:String;
      
      public var mcCircle:MovieClip;
      
      private var _nameWire:NameWire;
      
      private var _avatarPictureLoader:Loader;
      
      private var _timerOutline:MovieClip;
      
      public var mcDial:MovieClip;
      
      public var mcCircler:MovieClip;
      
      private var _playerId:int = 0;
      
      private var _closeButtonHandler:Function;
      
      public var mcName:MovieClip;
      
      public var mcGlow:MovieClip;
      
      public var mcClamps:MovieClip;
      
      public var mcTimer:MovieClip;
      
      private var _isDisabled:Boolean = false;
      
      private var _closing:Boolean = false;
      
      private var _isBuddy:Boolean = false;
      
      private var _mode:String;
      
      private var _closeButton:SpinningButtonSmallComponent;
      
      public var mcAvatar:MovieClip;
      
      public var buddyData:IBuddyData;
      
      private var _timerText:TextField;
      
      public var mcClampSpinner:MovieClip;
      
      private var _playerName:String = "";
      
      private var _avatarId:int = 0;
      
      public var mcButtonsContainer:MovieClip;
      
      private var _clampSpinnerHelper:LoopHelper;
      
      private var _timerFill:MovieClip;
      
      private var _isNameFlipped:Boolean = false;
      
      private var _clampSpeed:Number;
      
      public function MegaWidgetAvatarSpinner()
      {
         super();
         _timerOutline = mcTimer.mcOutline;
         _timerFill = mcTimer.mcFill;
         _timerText = mcTimer.tfText;
         initializeStartState();
         createButtons();
         mcAvatar.addEventListener(MouseEvent.ROLL_OVER,onAvatarRollOver);
         mcAvatar.addEventListener(MouseEvent.ROLL_OUT,onAvatarRollOut);
      }
      
      private function initializeStartState() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         _clampSpinnerHelper = new LoopHelper(mcClampSpinner);
         _clampSpinnerHelper.stop();
         _clampSpeed = 1;
         mcClampSpinner.alpha = 0;
         mcAvatar.alpha = 0;
         mcGlow.visible = false;
         mcDial.alpha = 0;
         mcDial.rotation = -45;
         mcCircler.alpha = 0;
         mcCircler.stop();
         mcClamps.alpha = 0;
         mcClamps.visible = false;
         mcClamps.scaleX = mcClamps.scaleY = 1.25;
         mcTimer.alpha = 0;
         mcTimer.visible = false;
         mcTimer.scaleX = mcTimer.scaleY = 0;
         _nameWire = new NameWire(mcName);
         mcCircle.scaleX = mcCircle.scaleY = 0.01;
         mcCircle.alpha = 0;
         mcCircle.visible = false;
      }
      
      public function get playerName() : String
      {
         return _playerName;
      }
      
      public function destory() : void
      {
         _closeButton.destroy();
         _nameWire.destroy();
         _closeButton.removeEventListener(MouseEvent.CLICK,onCloseButtonClick);
         mcAvatar.removeEventListener(MouseEvent.ROLL_OVER,onAvatarRollOver);
         mcAvatar.removeEventListener(MouseEvent.ROLL_OUT,onAvatarRollOut);
      }
      
      public function set playerName(param1:String) : *
      {
         _playerName = param1;
      }
      
      public function set showCloseButton(param1:Boolean) : void
      {
         if(param1)
         {
            _closeButton.open();
         }
         else if(!_closeButton.isKickButton)
         {
            _closeButton.close();
         }
      }
      
      public function clearAvatarPicture() : void
      {
         while(mcAvatar.numChildren > 0)
         {
            mcAvatar.removeChildAt(0);
         }
      }
      
      private function openButton(param1:*) : void
      {
         if(!_closing)
         {
            param1.open();
         }
      }
      
      private function unflashGlow() : void
      {
         Tweener.addTween(mcAvatar,{
            "alpha":1,
            "time":0.1,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(mcGlow,{
            "width":GLOW_SIZE_START,
            "height":GLOW_SIZE_START,
            "time":0.1,
            "transition":"easeInOutQuad",
            "onComplete":finishFlashGlow
         });
      }
      
      private function onAvatarRollOver(param1:MouseEvent) : void
      {
         _clampSpinnerHelper.speed = 20;
      }
      
      public function set playerNameTitleColor(param1:uint) : void
      {
         _nameWire.title.textColor = param1;
      }
      
      public function set showSpinnerClamps(param1:Boolean) : void
      {
         if(param1)
         {
            _clampSpinnerHelper.play();
            Tweener.addTween(mcClampSpinner,{
               "scaleX":1.15,
               "scaleY":1.15,
               "alpha":1,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(mcClampSpinner,{
               "scaleX":1,
               "scaleY":1,
               "alpha":0,
               "time":0.5,
               "onComplete":_clampSpinnerHelper.stop
            });
         }
      }
      
      public function set expandSpinnerClamps(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(mcClampSpinner,{
               "scaleX":1.15,
               "scaleY":1.15,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(mcClampSpinner,{
               "scaleX":0.95,
               "scaleY":0.95,
               "time":0.5
            });
         }
      }
      
      public function loadAvatarPicture() : void
      {
         var szAvatarUrl:String;
         if(Boolean(_avatarPictureLoader))
         {
            try
            {
               _avatarPictureLoader.unload();
               _avatarPictureLoader.close();
            }
            catch(e:Error)
            {
            }
         }
         szAvatarUrl = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarURL(AvatarAssetType.MEDIUM,_avatarId).url;
         _avatarPictureLoader = new Loader();
         _avatarPictureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadAvatarPicComplete,false,0,true);
         _avatarPictureLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError,false,0,true);
         _avatarPictureLoader.load(new URLRequest(szAvatarUrl));
      }
      
      public function set closeButtonHandler(param1:Function) : void
      {
         _closeButtonHandler = param1;
      }
      
      private function hideAvatar() : void
      {
         Tweener.addTween(mcDial,{
            "alpha":0,
            "time":0.5,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(mcAvatar,{
            "alpha":0,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
      
      public function set menuMode(param1:String) : void
      {
         var value:String = param1;
         if(_mode == value)
         {
            return;
         }
         DebugLog.instance.log("menuMode: " + value);
         switch(value)
         {
            case MENU_MODE_TIMER:
               Tweener.removeTweens(mcTimer,"alpha");
               mcTimer.visible = true;
               Tweener.addTween(mcTimer,{
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "time":0.5
               });
               break;
            default:
               Tweener.addTween(mcTimer,{
                  "alpha":0,
                  "scaleX":2,
                  "scaleY":2,
                  "x":0,
                  "time":0.5,
                  "onComplete":function():*
                  {
                     mcTimer.visible = false;
                  }
               });
               hideAllButtons();
         }
         _mode = value;
      }
      
      public function set mode(param1:String) : void
      {
         if(_menuMode == param1)
         {
            return;
         }
         DebugLog.instance.log("mode: " + param1);
         switch(param1)
         {
            case MODE_ACTIVE:
            case MODE_TIMER:
               break;
            case MODE_BATTLE_ENTER:
               this.lockClamps = true;
               this.expandSpinnerClamps = false;
               _clampSpinnerHelper.speed = _clampSpeed = 5;
               break;
            case MODE_BATTLE_EXIT:
               this.lockClamps = false;
               this.expandSpinnerClamps = true;
               _clampSpinnerHelper.speed = _clampSpeed = 1;
               break;
            default:
               this.lockClamps = false;
               this.expandSpinnerClamps = false;
               _clampSpinnerHelper.speed = _clampSpeed = 1;
               this.showSpinnerClamps = false;
         }
         _menuMode = param1;
      }
      
      public function open() : void
      {
         _closing = false;
         this.visible = true;
         this.mouseChildren = true;
         if(!_isDisabled)
         {
            mcCircler.play();
         }
         else
         {
            mcCircle.alpha = 0;
            Tweener.addTween(mcCircle,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1,
               "time":1
            });
            mcCircle.visible = true;
         }
         Tweener.addTween(mcCircler,{
            "alpha":1,
            "time":1
         });
         mcClamps.visible = true;
         Tweener.addTween(mcClamps,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "time":1
         });
         this.mode = MODE_ACTIVE;
      }
      
      public function set lockClamps(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(mcClamps,{
               "scaleX":1.15,
               "scaleY":1.15,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(mcClamps,{
               "scaleX":1,
               "scaleY":1,
               "time":0.5
            });
         }
      }
      
      public function set showName(param1:Boolean) : void
      {
         if(param1)
         {
            _nameWire.open();
         }
         else
         {
            _nameWire.close();
         }
      }
      
      private function finishFlashGlow() : void
      {
         mcGlow.visible = false;
      }
      
      public function get avatarId() : *
      {
         return _avatarId;
      }
      
      private function hideDisabledCircle() : void
      {
         mcCircle.visible = false;
      }
      
      private function onAvatarRollOut(param1:MouseEvent) : void
      {
         _clampSpinnerHelper.speed = _clampSpeed;
      }
      
      private function onCloseButtonClick(param1:MouseEvent) : void
      {
         _closeButtonHandler.call(this,this);
      }
      
      public function set playerNameTitle(param1:String) : void
      {
         _nameWire.title.text = param1;
      }
      
      public function set showAvatar(param1:Boolean) : void
      {
         if(param1)
         {
            showAvatarChain();
         }
         else
         {
            hideAvatar();
         }
      }
      
      public function set isBuddy(param1:Boolean) : void
      {
         _isBuddy = param1;
      }
      
      public function set timerPercent(param1:Number) : void
      {
         Tweener.addTween(_timerFill,{
            "rotation":(100 - param1) * TIMER_ANGLE_PERCENTAGE_DELTA + TIMER_ANGLE_FULL,
            "time":1
         });
         _timerText;
      }
      
      private function cascadeOpenButtons(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            Tweener.addCaller(this,{
               "onUpdate":openButton,
               "onUpdateParams":[param1[_loc2_]],
               "time":0,
               "count":1,
               "delay":0.05 * _loc2_
            });
            _loc2_++;
         }
      }
      
      public function set playerNameSubtitle(param1:String) : void
      {
         _nameWire.subtitle.text = param1;
      }
      
      public function set nameOrientation(param1:String) : void
      {
         switch(param1)
         {
            case NAME_ORIENTATION_TOP_RIGHT:
               break;
            case NAME_ORIENTATION_BOTTOM_RIGHT:
               _nameWire.flipV(true);
         }
      }
      
      private function hideAllButtons() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = mcButtonsContainer.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = mcButtonsContainer.getChildAt(_loc2_);
            if(_loc1_ as SpinningButtonComponent != null || _loc1_ as SpinningButtonSmallComponent != null)
            {
               _loc1_.close();
            }
            _loc2_++;
         }
      }
      
      public function set playerNameSuperTitle(param1:String) : void
      {
         if(_nameWire.superTitle != null)
         {
            _nameWire.superTitle.text = param1;
         }
      }
      
      public function hasAvatar() : Boolean
      {
         return mcAvatar.numChildren > 0;
      }
      
      public function killAvatarPicture() : void
      {
         if(Boolean(_avatarPictureLoader))
         {
            try
            {
               _avatarPictureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarPicComplete);
               _avatarPictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError);
               _avatarPictureLoader.unload();
               _avatarPictureLoader.close();
            }
            catch(e:Error)
            {
            }
         }
         clearAvatarPicture();
      }
      
      public function set avatarId(param1:int) : *
      {
         _avatarId = param1;
      }
      
      public function showAvatarChain() : void
      {
         mcGlow.width = GLOW_SIZE_START;
         mcGlow.height = GLOW_SIZE_START;
         mcGlow.visible = true;
         mcDial.rotation = -45;
         Tweener.addTween(mcDial,{
            "alpha":1,
            "rotation":0,
            "time":0.5,
            "transition":"easeInOutQuad",
            "onComplete":unflashGlow
         });
         Tweener.addTween(mcGlow,{
            "width":GLOW_SIZE_END,
            "height":GLOW_SIZE_END,
            "time":0.15,
            "transition":"easeInOutQuad",
            "onComplete":unflashGlow
         });
      }
      
      public function set playerId(param1:int) : *
      {
         _playerId = param1;
      }
      
      public function set color(param1:uint) : void
      {
         if(param1 == COLOR_BLUE)
         {
            Tweener.addTween(_nameWire.wire,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(_nameWire.subtitle,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(mcCircler,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(mcClamps,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(mcClampSpinner,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(mcDial,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(mcGlow,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(mcCircle,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(mcTimer,{
               "_color":null,
               "time":0.5
            });
            _closeButton.color = SpinningButtonSmallComponent.COLOR_BLUE;
            return;
         }
         if(param1 == COLOR_ORANGE)
         {
            _closeButton.color = SpinningButtonSmallComponent.COLOR_ORANGE;
         }
         Tweener.addTween(_nameWire.wire,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(_nameWire.subtitle,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(mcCircler,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(mcClamps,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(mcClampSpinner,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(mcDial,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(mcGlow,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(mcCircle,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(mcTimer,{
            "_color":param1,
            "time":0.5
         });
      }
      
      private function onLoadAvatarPicError(param1:IOErrorEvent) : void
      {
         _avatarPictureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarPicComplete);
         _avatarPictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError);
         _avatarPictureLoader.unload();
         _avatarPictureLoader = null;
      }
      
      private function onLoadAvatarPicComplete(param1:Event) : void
      {
         _avatarPictureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarPicComplete);
         _avatarPictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError);
         clearAvatarPicture();
         var _loc2_:Bitmap = new Bitmap((_avatarPictureLoader.contentLoaderInfo.content as Bitmap).bitmapData);
         _loc2_.width = 60;
         _loc2_.height = 60;
         mcAvatar.addChild(_loc2_);
         _avatarPictureLoader.unload();
         _avatarPictureLoader = null;
      }
      
      public function set showKickButton(param1:Boolean) : void
      {
         _closeButton.isKickButton = param1;
         showCloseButton = param1;
      }
      
      public function get playerId() : *
      {
         return _playerId;
      }
      
      private function createButtons() : void
      {
         _closeButton = new SpinningButtonSmallComponent(new SpinnerIconX());
         _closeButton.x = -18;
         _closeButton.y = 54;
         mcButtonsContainer.addChild(_closeButton);
         _closeButton.addEventListener(MouseEvent.CLICK,onCloseButtonClick);
      }
      
      public function close() : void
      {
         _closing = true;
         this.mouseChildren = false;
         Tweener.addTween(mcCircler,{
            "alpha":0,
            "time":1,
            "onComplete":mcCircler.stop
         });
         Tweener.addTween(mcClamps,{
            "alpha":0,
            "scaleX":1.25,
            "scaleY":1.25,
            "time":1,
            "onComplete":function():*
            {
               mcClamps.visible = false;
               this.visible = false;
            }
         });
         Tweener.addTween(mcAvatar,{
            "alpha":0,
            "time":0.15,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(mcDial,{
            "alpha":0,
            "rotation":45,
            "time":0.15,
            "transition":"easeInOutQuad"
         });
         if(_isDisabled)
         {
            Tweener.addTween(mcCircle,{
               "alpha":0,
               "time":1,
               "onComplete":hideDisabledCircle
            });
         }
         this.mode = MODE_INACTIVE;
         _closeButton.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
      }
      
      public function set playerNameSubtitleColor(param1:uint) : void
      {
         _nameWire.subtitle.textColor = param1;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         _isDisabled = param1;
         if(param1)
         {
            mcCircler.stop();
            this.alpha = 0.25;
            if(mcCircle.visible)
            {
               Tweener.addTween(mcCircle,{
                  "alpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "time":1
               });
            }
            mcCircler.visible = false;
         }
         else
         {
            mcCircler.play();
            this.alpha = 1;
            if(mcCircle.visible)
            {
               Tweener.addTween(mcCircle,{
                  "alpha":0,
                  "scaleX":0.01,
                  "scaleY":0.01,
                  "time":1
               });
            }
            mcCircler.visible = true;
         }
      }
   }
}

import caurina.transitions.Tweener;
import com.smithandtinker.nanovor.debug.DebugLog;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;

class NameWire
{
   
   private var _titleOriginalX:Number;
   
   private var _subtitleOriginalX:Number;
   
   private var _title:TextField;
   
   private var _wire:MovieClip;
   
   private var _target:MovieClip;
   
   private var _subtitle:TextField;
   
   private var _superTitle:TextField;
   
   private var _isFlippedV:Boolean = false;
   
   public function NameWire(param1:MovieClip)
   {
      super();
      _target = param1;
      _wire = _target.mcWire;
      _title = _target.tfTop;
      _subtitle = _target.tfBottom;
      _titleOriginalX = _title.x;
      _subtitleOriginalX = _subtitle.x;
      _superTitle = _target.tfTopTop;
      if(_superTitle != null)
      {
         _superTitle.text = "";
      }
      _target.mouseEnabled = false;
      _target.mouseChildren = false;
      _target.stop();
      _title.alpha = 0;
      _subtitle.alpha = 0;
   }
   
   private function log(param1:String) : void
   {
      DebugLog.instance.log("<<NameWire>>\t" + param1);
   }
   
   public function get wire() : MovieClip
   {
      return _wire;
   }
   
   public function set mouseEnabled(param1:Boolean) : void
   {
   }
   
   public function flipV(param1:Boolean) : void
   {
      if(_isFlippedV == param1)
      {
         return;
      }
      _isFlippedV = param1;
      if(param1)
      {
         log("flipV(): Flipping");
         _target.scaleY = -1;
         _title.scaleY = -1;
         _title.y += _title.height - 4;
         _subtitle.scaleY = -1;
         _subtitle.y += _subtitle.height - 4;
      }
   }
   
   public function open() : void
   {
      Tweener.addTween(_target,{
         "alpha":1,
         "time":0.5
      });
      _target.addEventListener(Event.COMPLETE,showNameText);
      _target.gotoAndPlay(1);
   }
   
   public function set mouseChildren(param1:Boolean) : void
   {
   }
   
   private function getSubtitleX() : Number
   {
      return _subtitleOriginalX;
   }
   
   public function get title() : TextField
   {
      return _title;
   }
   
   public function get superTitle() : TextField
   {
      return _superTitle;
   }
   
   public function get subtitle() : TextField
   {
      return _subtitle;
   }
   
   private function showNameText(param1:Event) : void
   {
      this.title.x = getTitleX() + 10;
      Tweener.addTween(this.title,{
         "alpha":1,
         "time":0.5,
         "x":getTitleX()
      });
      this.subtitle.x = getSubtitleX() - 10;
      Tweener.addTween(this.subtitle,{
         "alpha":1,
         "time":0.5,
         "x":getSubtitleX()
      });
      _target.removeEventListener(Event.COMPLETE,showNameText);
   }
   
   private function getTitleX() : Number
   {
      return _titleOriginalX;
   }
   
   public function close() : void
   {
      Tweener.addTween(_target,{
         "alpha":0,
         "time":0.5
      });
      Tweener.addTween(this.title,{
         "alpha":0,
         "x":getTitleX() + 10,
         "time":0.5
      });
      Tweener.addTween(this.subtitle,{
         "alpha":0,
         "x":getSubtitleX() - 10,
         "time":0.5
      });
   }
   
   public function destroy() : void
   {
      _target.removeEventListener(Event.COMPLETE,showNameText);
   }
   
   private function swapExistingTextAndColor() : void
   {
      var _loc1_:String = _title.text;
      var _loc2_:uint = uint(_title.textColor);
      _title.text = _subtitle.text;
      _title.textColor = _subtitle.textColor;
      _subtitle.text = _loc1_;
      _subtitle.textColor = _loc2_;
   }
}
