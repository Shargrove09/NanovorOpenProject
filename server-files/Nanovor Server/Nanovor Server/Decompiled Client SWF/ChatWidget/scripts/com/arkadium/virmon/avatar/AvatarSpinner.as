package com.arkadium.virmon.avatar
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.framework.asset.enum.AvatarAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconB;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconC;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconF;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconMinus;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconPlus;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconR;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconT;
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
   
   public class AvatarSpinner extends MovieClip
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
      
      protected var _friendsButton:SpinningButtonComponent;
      
      public var mcCircler:MovieClip;
      
      private var _playerId:int = 0;
      
      private var _closeButtonHandler:Function;
      
      public var mcName:MovieClip;
      
      public var mcGlow:MovieClip;
      
      protected var _chatButton:SpinningButtonComponent;
      
      public var mcClamps:MovieClip;
      
      public var mcTimer:MovieClip;
      
      private var _isDisabled:Boolean = false;
      
      public var mc2Slot:MovieClip;
      
      public var mc4Slot:MovieClip;
      
      private var _closing:Boolean = false;
      
      protected var _ignoreButton:SpinningButtonComponent;
      
      private var _isBuddy:Boolean = false;
      
      private var _opened:Boolean = false;
      
      private var _mode:String;
      
      private var _closeButton:SpinningButtonSmallComponent;
      
      public var mcAvatar:MovieClip;
      
      public var buddyData:IBuddyData;
      
      private var _timerText:TextField;
      
      public var mcClampSpinner:MovieClip;
      
      private var _playerName:String = "";
      
      protected var _removeFriendButton:SpinningButtonComponent;
      
      protected var _addButton:SpinningButtonComponent;
      
      public var mcButtonsContainer:MovieClip;
      
      private var _avatarId:int = 0;
      
      private var _clampSpinnerHelper:LoopHelper;
      
      private var _timerFill:MovieClip;
      
      private var _clampSpeed:Number;
      
      protected var _battleButton:SpinningButtonComponent;
      
      private var _isNameFlipped:Boolean = false;
      
      protected var _tradeButton:SpinningButtonComponent;
      
      public function AvatarSpinner()
      {
         super();
         this._timerOutline = this.mcTimer.mcOutline;
         this._timerFill = this.mcTimer.mcFill;
         this._timerText = this.mcTimer.tfText;
         this.initializeStartState();
         this.createButtons();
         this.mcAvatar.addEventListener(MouseEvent.ROLL_OVER,this.onAvatarRollOver,false,0,true);
         this.mcAvatar.addEventListener(MouseEvent.ROLL_OUT,this.onAvatarRollOut,false,0,true);
      }
      
      private function onAddFriendButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleAddFriendButtonClick(this);
      }
      
      public function close() : Boolean
      {
         var _loc1_:Boolean = this._opened;
         this._opened = false;
         this._closing = true;
         this.mouseChildren = false;
         Tweener.addTween(this.mcCircler,{
            "_autoAlpha":0,
            "time":1,
            "onComplete":this.mcCircler.stop
         });
         Tweener.addTween(this.mcClamps,{
            "_autoAlpha":0,
            "scaleX":1.25,
            "scaleY":1.25,
            "time":1,
            "onComplete":this.closeTweensComplete
         });
         Tweener.addTween(this.mcAvatar,{
            "_autoAlpha":0,
            "time":0.15,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(this.mcDial,{
            "_autoAlpha":0,
            "rotation":45,
            "time":0.15,
            "transition":"easeInOutQuad"
         });
         if(this._isDisabled)
         {
            Tweener.addTween(this.mcCircle,{
               "_autoAlpha":0,
               "time":1
            });
         }
         this.mode = MODE_INACTIVE;
         this._closeButton.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         return _loc1_;
      }
      
      private function oTradeButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleTradeButtonClick(this);
      }
      
      public function destroy() : void
      {
         this.mcAvatar.removeEventListener(MouseEvent.ROLL_OVER,this.onAvatarRollOver);
         this.mcAvatar.removeEventListener(MouseEvent.ROLL_OUT,this.onAvatarRollOut);
         this._addButton.removeEventListener(MouseEvent.CLICK,this.onAddFriendButtonClick);
         this._ignoreButton.removeEventListener(MouseEvent.CLICK,this.onIgnoreFriendButtonClick);
         this._battleButton.removeEventListener(MouseEvent.CLICK,this.onBattleButtonClick);
         this._tradeButton.removeEventListener(MouseEvent.CLICK,this.oTradeButtonClick);
         this._chatButton.removeEventListener(MouseEvent.CLICK,this.onChatButtonClick);
         this._friendsButton.removeEventListener(MouseEvent.CLICK,this.onFriendsButtonClick);
         this._removeFriendButton.removeEventListener(MouseEvent.CLICK,this.onRemoveFriendButtonClick);
         this._closeButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         this._addButton.destroy();
         this._ignoreButton.destroy();
         this._battleButton.destroy();
         this._tradeButton.destroy();
         this._chatButton.destroy();
         this._friendsButton.destroy();
         this._removeFriendButton.destroy();
         this._closeButton.destroy();
         this._addButton = null;
         this._ignoreButton = null;
         this._battleButton = null;
         this._tradeButton = null;
         this._chatButton = null;
         this._friendsButton = null;
         this._removeFriendButton = null;
         this._closeButton = null;
      }
      
      private function initializeStartState() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this._clampSpinnerHelper = new LoopHelper(this.mcClampSpinner);
         this._clampSpinnerHelper.stop();
         this._clampSpeed = 1;
         this.mcClampSpinner.alpha = 0;
         this.mcClampSpinner.visible = false;
         this.mcAvatar.alpha = 0;
         this.mcGlow.visible = false;
         this.mcDial.alpha = 0;
         this.mcDial.visible = false;
         this.mcDial.rotation = -45;
         this.mcCircler.alpha = 0;
         this.mcCircler.visible = false;
         this.mcCircler.stop();
         this.mcClamps.alpha = 0;
         this.mcClamps.visible = false;
         this.mcClamps.scaleX = this.mcClamps.scaleY = 1.25;
         this.mc2Slot.alpha = 0;
         this.mc2Slot.visible = false;
         this.mc2Slot.scaleX = this.mc2Slot.scaleY = 2;
         this.mc2Slot.mouseEnabled = false;
         this.mc4Slot.alpha = 0;
         this.mc4Slot.visible = false;
         this.mc4Slot.scaleX = this.mc4Slot.scaleY = 2;
         this.mc4Slot.mouseEnabled = false;
         this.mcTimer.alpha = 0;
         this.mcTimer.visible = false;
         this.mcTimer.scaleX = this.mcTimer.scaleY = 0;
         this._nameWire = new NameWire(this.mcName);
         this.mcCircle.scaleX = this.mcCircle.scaleY = 0.01;
         this.mcCircle.alpha = 0;
         this.mcCircle.visible = false;
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
      
      private function onLoadAvatarPicError(param1:IOErrorEvent) : void
      {
         this._avatarPictureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadAvatarPicComplete);
         this._avatarPictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadAvatarPicError);
         this._avatarPictureLoader.unload();
         this._avatarPictureLoader = null;
      }
      
      public function set playerName(param1:String) : *
      {
         this._playerName = param1;
      }
      
      public function set showCloseButton(param1:Boolean) : void
      {
         if(param1)
         {
            this._closeButton.open();
         }
         else if(!this._closeButton.isKickButton)
         {
            this._closeButton.close();
         }
      }
      
      public function clearAvatarPicture() : void
      {
         while(this.mcAvatar.numChildren > 0)
         {
            this.mcAvatar.removeChildAt(0);
         }
      }
      
      private function openButton(param1:*) : void
      {
         if(!this._closing)
         {
            param1.open();
         }
      }
      
      private function unflashGlow() : void
      {
         Tweener.addTween(this.mcAvatar,{
            "_autoAlpha":1,
            "time":0.1,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(this.mcGlow,{
            "width":GLOW_SIZE_START,
            "height":GLOW_SIZE_START,
            "time":0.1,
            "transition":"easeInOutQuad",
            "onComplete":this.finishFlashGlow
         });
      }
      
      private function onAvatarRollOver(param1:MouseEvent) : void
      {
         this._clampSpinnerHelper.speed = 20;
      }
      
      public function set playerNameTitleColor(param1:uint) : void
      {
         this._nameWire.title.textColor = param1;
      }
      
      public function set expandSpinnerClamps(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(this.mcClampSpinner,{
               "scaleX":1.15,
               "scaleY":1.15,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(this.mcClampSpinner,{
               "scaleX":0.95,
               "scaleY":0.95,
               "time":0.5
            });
         }
      }
      
      public function loadAvatarPicture() : void
      {
         var szAvatarUrl:String;
         if(Boolean(this._avatarPictureLoader))
         {
            try
            {
               this._avatarPictureLoader.unload();
               this._avatarPictureLoader.close();
            }
            catch(e:Error)
            {
            }
         }
         szAvatarUrl = Managers.assetRetrieverManager.avatarAssetRetriever.getAvatarURL(AvatarAssetType.MEDIUM,this._avatarId).url;
         this._avatarPictureLoader = new Loader();
         this._avatarPictureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadAvatarPicComplete,false,0,true);
         this._avatarPictureLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadAvatarPicError,false,0,true);
         this._avatarPictureLoader.load(new URLRequest(szAvatarUrl));
      }
      
      public function set closeButtonHandler(param1:Function) : void
      {
         this._closeButtonHandler = param1;
      }
      
      private function hideAvatar() : void
      {
         Tweener.addTween(this.mcDial,{
            "_autoAlpha":0,
            "time":0.5,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(this.mcAvatar,{
            "_autoAlpha":0,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
      
      public function set menuMode(param1:String) : void
      {
         if(this._mode == param1)
         {
            return;
         }
         DebugLog.instance.log("menuMode: " + param1);
         switch(param1)
         {
            case MENU_MODE_GENERAL:
               Tweener.removeTweens(this.mc4Slot,"_autoAlpha");
               this.showGeneralButtons();
               Tweener.addTween(this.mc4Slot,{
                  "_autoAlpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "time":0.5
               });
               break;
            case MENU_MODE_PENDING:
               Tweener.removeTweens(this.mc2Slot,"_autoAlpha");
               Tweener.addTween(this.mc2Slot,{
                  "_autoAlpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "time":0.5,
                  "onComplete":this.showPendingButtons
               });
               break;
            case MENU_MODE_TIMER:
               Tweener.removeTweens(this.mcTimer,"_autoAlpha");
               Tweener.addTween(this.mcTimer,{
                  "_autoAlpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "time":0.5
               });
               break;
            default:
               Tweener.addTween(this.mc2Slot,{
                  "_autoAlpha":0,
                  "scaleX":2,
                  "scaleY":2,
                  "x":0,
                  "time":0.5
               });
               Tweener.addTween(this.mc4Slot,{
                  "_autoAlpha":0,
                  "scaleX":2,
                  "scaleY":2,
                  "x":0,
                  "time":0.5
               });
               Tweener.addTween(this.mcTimer,{
                  "_autoAlpha":0,
                  "scaleX":2,
                  "scaleY":2,
                  "x":0,
                  "time":0.5
               });
               this.hideAllButtons();
         }
         this._mode = param1;
      }
      
      public function set mode(param1:String) : void
      {
         if(this._menuMode == param1)
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
               this._clampSpinnerHelper.speed = this._clampSpeed = 5;
               break;
            case MODE_BATTLE_EXIT:
               this.lockClamps = false;
               this.expandSpinnerClamps = true;
               this._clampSpinnerHelper.speed = this._clampSpeed = 1;
               break;
            default:
               this.lockClamps = false;
               this.expandSpinnerClamps = false;
               this._clampSpinnerHelper.speed = this._clampSpeed = 1;
               this.showSpinnerClamps = false;
         }
         this._menuMode = param1;
      }
      
      private function showPendingButtons() : void
      {
         this.cascadeOpenButtons([this._addButton,this._ignoreButton,this._closeButton]);
      }
      
      public function open() : Boolean
      {
         var _loc1_:Boolean = this._opened;
         this._opened = true;
         this._closing = false;
         visible = true;
         mouseChildren = true;
         if(!this._isDisabled)
         {
            this.mcCircler.play();
         }
         else
         {
            this.mcCircle.alpha = 0;
            Tweener.addTween(this.mcCircle,{
               "_autoAlpha":1,
               "scaleX":1,
               "scaleY":1,
               "time":1
            });
         }
         Tweener.addTween(this.mcCircler,{
            "_autoAlpha":1,
            "time":1
         });
         Tweener.addTween(this.mcClamps,{
            "_autoAlpha":1,
            "scaleX":1,
            "scaleY":1,
            "time":1
         });
         this.mode = MODE_ACTIVE;
         return !_loc1_;
      }
      
      public function set lockClamps(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(this.mcClamps,{
               "scaleX":1.15,
               "scaleY":1.15,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(this.mcClamps,{
               "scaleX":1,
               "scaleY":1,
               "time":0.5
            });
         }
      }
      
      private function finishFlashGlow() : void
      {
         this.mcGlow.visible = false;
      }
      
      public function get avatarId() : *
      {
         return this._avatarId;
      }
      
      public function set showSpinnerClamps(param1:Boolean) : void
      {
         if(param1)
         {
            this._clampSpinnerHelper.play();
            Tweener.addTween(this.mcClampSpinner,{
               "scaleX":1.15,
               "scaleY":1.15,
               "_autoAlpha":1,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(this.mcClampSpinner,{
               "scaleX":1,
               "scaleY":1,
               "_autoAlpha":0,
               "time":0.5,
               "onComplete":this._clampSpinnerHelper.stop
            });
         }
      }
      
      public function set showName(param1:Boolean) : void
      {
         if(param1)
         {
            this._nameWire.open();
         }
         else
         {
            this._nameWire.close();
         }
      }
      
      private function onAvatarRollOut(param1:MouseEvent) : void
      {
         this._clampSpinnerHelper.speed = this._clampSpeed;
      }
      
      private function onCloseButtonClick(param1:MouseEvent) : void
      {
         if(this._closeButtonHandler == null)
         {
            AvatarManager.getInstance().handleCloseButtonClick(this);
         }
         else
         {
            this._closeButtonHandler.call(this,this);
         }
      }
      
      public function set playerNameTitle(param1:String) : void
      {
         this._nameWire.title.text = param1;
      }
      
      private function onIgnoreFriendButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleIgnoreFriendButtonClick(this);
      }
      
      public function set showAvatar(param1:Boolean) : void
      {
         if(param1)
         {
            this.showAvatarChain();
         }
         else
         {
            this.hideAvatar();
         }
      }
      
      public function set isBuddy(param1:Boolean) : void
      {
         this._isBuddy = param1;
      }
      
      private function onBattleButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleBattleButtonClick(this);
      }
      
      public function set timerPercent(param1:Number) : void
      {
         Tweener.addTween(this._timerFill,{
            "rotation":(100 - param1) * TIMER_ANGLE_PERCENTAGE_DELTA + TIMER_ANGLE_FULL,
            "time":1
         });
         this._timerText;
      }
      
      public function set nameOrientation(param1:String) : void
      {
         switch(param1)
         {
            case NAME_ORIENTATION_TOP_RIGHT:
               break;
            case NAME_ORIENTATION_BOTTOM_RIGHT:
               this._nameWire.flipV(true);
         }
      }
      
      private function hideAllButtons() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = this.mcButtonsContainer.numChildren;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.mcButtonsContainer.getChildAt(_loc2_);
            if(_loc1_ as SpinningButtonComponent != null || _loc1_ as SpinningButtonSmallComponent != null)
            {
               _loc1_.close();
            }
            _loc2_++;
         }
      }
      
      public function set playerNameSubtitle(param1:String) : void
      {
         this._nameWire.subtitle.text = param1;
      }
      
      public function set playerNameSuperTitle(param1:String) : void
      {
         if(this._nameWire.superTitle != null)
         {
            this._nameWire.superTitle.text = param1;
         }
      }
      
      public function hasAvatar() : Boolean
      {
         return this.mcAvatar.numChildren > 0;
      }
      
      private function cascadeOpenButtons(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            Tweener.addCaller(this,{
               "onUpdate":this.openButton,
               "onUpdateParams":[param1[_loc2_]],
               "time":0,
               "count":1,
               "delay":0.05 * _loc2_
            });
            _loc2_++;
         }
      }
      
      private function onChatButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleChatButtonClick(this);
      }
      
      public function killAvatarPicture() : void
      {
         if(Boolean(this._avatarPictureLoader))
         {
            try
            {
               this._avatarPictureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadAvatarPicComplete);
               this._avatarPictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadAvatarPicError);
               this._avatarPictureLoader.unload();
               this._avatarPictureLoader.close();
            }
            catch(e:Error)
            {
            }
         }
         this.clearAvatarPicture();
      }
      
      public function set avatarId(param1:int) : *
      {
         this._avatarId = param1;
      }
      
      public function showAvatarChain() : void
      {
         this.mcGlow.width = GLOW_SIZE_START;
         this.mcGlow.height = GLOW_SIZE_START;
         this.mcGlow.visible = true;
         this.mcDial.rotation = -45;
         Tweener.addTween(this.mcDial,{
            "_autoAlpha":1,
            "rotation":0,
            "time":0.5,
            "transition":"easeInOutQuad",
            "onComplete":this.unflashGlow
         });
         Tweener.addTween(this.mcGlow,{
            "width":GLOW_SIZE_END,
            "height":GLOW_SIZE_END,
            "time":0.15,
            "transition":"easeInOutQuad",
            "onComplete":this.unflashGlow
         });
      }
      
      public function set playerId(param1:int) : *
      {
         this._playerId = param1;
      }
      
      public function set color(param1:uint) : void
      {
         if(param1 == COLOR_BLUE)
         {
            Tweener.addTween(this._nameWire.wire,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this._nameWire.subtitle,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this.mcCircler,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this.mcClamps,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this.mcClampSpinner,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this.mcDial,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this.mcGlow,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this.mcCircle,{
               "_color":null,
               "time":0.5
            });
            Tweener.addTween(this.mcTimer,{
               "_color":null,
               "time":0.5
            });
            this._closeButton.color = SpinningButtonSmallComponent.COLOR_BLUE;
            return;
         }
         if(param1 == COLOR_ORANGE)
         {
            this._closeButton.color = SpinningButtonSmallComponent.COLOR_ORANGE;
         }
         Tweener.addTween(this._nameWire.wire,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this._nameWire.subtitle,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this.mcCircler,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this.mcClamps,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this.mcClampSpinner,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this.mcDial,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this.mcGlow,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this.mcCircle,{
            "_color":param1,
            "time":0.5
         });
         Tweener.addTween(this.mcTimer,{
            "_color":param1,
            "time":0.5
         });
      }
      
      private function showGeneralButtons() : void
      {
         if(!this._isBuddy)
         {
            this.cascadeOpenButtons([this._battleButton,this._tradeButton,this._chatButton,this._friendsButton,this._closeButton]);
         }
         else
         {
            this.cascadeOpenButtons([this._battleButton,this._tradeButton,this._chatButton,this._removeFriendButton,this._closeButton]);
         }
      }
      
      private function closeTweensComplete() : void
      {
         visible = false;
      }
      
      public function get playerId() : *
      {
         return this._playerId;
      }
      
      private function onLoadAvatarPicComplete(param1:Event) : void
      {
         this._avatarPictureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadAvatarPicComplete);
         this._avatarPictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadAvatarPicError);
         this.clearAvatarPicture();
         var _loc2_:Bitmap = new Bitmap((this._avatarPictureLoader.contentLoaderInfo.content as Bitmap).bitmapData);
         _loc2_.width = 60;
         _loc2_.height = 60;
         this.mcAvatar.addChild(_loc2_);
         this._avatarPictureLoader.unload();
         this._avatarPictureLoader = null;
      }
      
      private function onFriendsButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleFriendButtonClick(this);
      }
      
      public function set showKickButton(param1:Boolean) : void
      {
         this._closeButton.isKickButton = param1;
         this.showCloseButton = param1;
      }
      
      private function onRemoveFriendButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleRemoveFriendButtonClick(this);
      }
      
      private function createButtons() : void
      {
         this._addButton = new SpinningButtonComponent(new SpinnerIconPlus());
         this._addButton.x = 63;
         this._addButton.y = -19;
         this.mcButtonsContainer.addChild(this._addButton);
         this._ignoreButton = new SpinningButtonComponent(new SpinnerIconMinus());
         this._ignoreButton.color = SpinningButtonComponent.COLOR_RED;
         this._ignoreButton.x = 63;
         this._ignoreButton.y = 17;
         this.mcButtonsContainer.addChild(this._ignoreButton);
         this._battleButton = new SpinningButtonComponent(new SpinnerIconB());
         this._battleButton.x = 63;
         this._battleButton.y = -18;
         this.mcButtonsContainer.addChild(this._battleButton);
         this._tradeButton = new SpinningButtonComponent(new SpinnerIconT());
         this._tradeButton.x = 63;
         this._tradeButton.y = 18;
         this.mcButtonsContainer.addChild(this._tradeButton);
         this._chatButton = new SpinningButtonComponent(new SpinnerIconC());
         this._chatButton.x = 44;
         this._chatButton.y = 48;
         this._chatButton.scaleX = this._chatButton.scaleY = 0.7;
         this.mcButtonsContainer.addChild(this._chatButton);
         this._friendsButton = new SpinningButtonComponent(new SpinnerIconF());
         this._friendsButton.x = 13;
         this._friendsButton.y = 64;
         this._friendsButton.scaleX = this._friendsButton.scaleY = 0.7;
         this.mcButtonsContainer.addChild(this._friendsButton);
         this._removeFriendButton = new SpinningButtonComponent(new SpinnerIconR());
         this._removeFriendButton.x = 13;
         this._removeFriendButton.y = 64;
         this._removeFriendButton.scaleX = this._removeFriendButton.scaleY = 0.7;
         this.mcButtonsContainer.addChild(this._removeFriendButton);
         this._closeButton = new SpinningButtonSmallComponent(new SpinnerIconX());
         this._closeButton.x = -18;
         this._closeButton.y = 54;
         this.mcButtonsContainer.addChild(this._closeButton);
         this._addButton.addEventListener(MouseEvent.CLICK,this.onAddFriendButtonClick,false,0,true);
         this._ignoreButton.addEventListener(MouseEvent.CLICK,this.onIgnoreFriendButtonClick,false,0,true);
         this._battleButton.addEventListener(MouseEvent.CLICK,this.onBattleButtonClick,false,0,true);
         this._tradeButton.addEventListener(MouseEvent.CLICK,this.oTradeButtonClick,false,0,true);
         this._chatButton.addEventListener(MouseEvent.CLICK,this.onChatButtonClick,false,0,true);
         this._friendsButton.addEventListener(MouseEvent.CLICK,this.onFriendsButtonClick,false,0,true);
         this._removeFriendButton.addEventListener(MouseEvent.CLICK,this.onRemoveFriendButtonClick,false,0,true);
         this._closeButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClick,false,0,true);
      }
      
      public function set playerNameSubtitleColor(param1:uint) : void
      {
         this._nameWire.subtitle.textColor = param1;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         this._isDisabled = param1;
         if(param1)
         {
            this.mcCircler.stop();
            alpha = 0.25;
            if(this.mcCircle.visible)
            {
               Tweener.addTween(this.mcCircle,{
                  "_autoAlpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "time":1
               });
            }
            this.mcCircler.visible = false;
         }
         else
         {
            this.mcCircler.play();
            alpha = 1;
            if(this.mcCircle.visible)
            {
               Tweener.addTween(this.mcCircle,{
                  "_autoAlpha":0,
                  "scaleX":0.01,
                  "scaleY":0.01,
                  "time":1
               });
            }
            this.mcCircler.visible = true;
         }
      }
   }
}

