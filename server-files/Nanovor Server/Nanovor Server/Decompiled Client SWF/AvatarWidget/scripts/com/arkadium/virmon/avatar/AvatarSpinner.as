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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol37")]
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
         _timerOutline = mcTimer.mcOutline;
         _timerFill = mcTimer.mcFill;
         _timerText = mcTimer.tfText;
         initializeStartState();
         createButtons();
         mcAvatar.addEventListener(MouseEvent.ROLL_OVER,onAvatarRollOver,false,0,true);
         mcAvatar.addEventListener(MouseEvent.ROLL_OUT,onAvatarRollOut,false,0,true);
      }
      
      private function onAddFriendButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleAddFriendButtonClick(this);
      }
      
      public function close() : Boolean
      {
         var _loc1_:Boolean = _opened;
         _opened = false;
         _closing = true;
         this.mouseChildren = false;
         Tweener.addTween(mcCircler,{
            "_autoAlpha":0,
            "time":1,
            "onComplete":mcCircler.stop
         });
         Tweener.addTween(mcClamps,{
            "_autoAlpha":0,
            "scaleX":1.25,
            "scaleY":1.25,
            "time":1,
            "onComplete":closeTweensComplete
         });
         Tweener.addTween(mcAvatar,{
            "_autoAlpha":0,
            "time":0.15,
            "transition":"easeInOutQuad"
         });
         Tweener.addTween(mcDial,{
            "_autoAlpha":0,
            "rotation":45,
            "time":0.15,
            "transition":"easeInOutQuad"
         });
         if(_isDisabled)
         {
            Tweener.addTween(mcCircle,{
               "_autoAlpha":0,
               "time":1
            });
         }
         this.mode = MODE_INACTIVE;
         _closeButton.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
         return _loc1_;
      }
      
      private function oTradeButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleTradeButtonClick(this);
      }
      
      public function destroy() : void
      {
         mcAvatar.removeEventListener(MouseEvent.ROLL_OVER,onAvatarRollOver);
         mcAvatar.removeEventListener(MouseEvent.ROLL_OUT,onAvatarRollOut);
         _addButton.removeEventListener(MouseEvent.CLICK,onAddFriendButtonClick);
         _ignoreButton.removeEventListener(MouseEvent.CLICK,onIgnoreFriendButtonClick);
         _battleButton.removeEventListener(MouseEvent.CLICK,onBattleButtonClick);
         _tradeButton.removeEventListener(MouseEvent.CLICK,oTradeButtonClick);
         _chatButton.removeEventListener(MouseEvent.CLICK,onChatButtonClick);
         _friendsButton.removeEventListener(MouseEvent.CLICK,onFriendsButtonClick);
         _removeFriendButton.removeEventListener(MouseEvent.CLICK,onRemoveFriendButtonClick);
         _closeButton.removeEventListener(MouseEvent.CLICK,onCloseButtonClick);
         _addButton.destroy();
         _ignoreButton.destroy();
         _battleButton.destroy();
         _tradeButton.destroy();
         _chatButton.destroy();
         _friendsButton.destroy();
         _removeFriendButton.destroy();
         _closeButton.destroy();
         _addButton = null;
         _ignoreButton = null;
         _battleButton = null;
         _tradeButton = null;
         _chatButton = null;
         _friendsButton = null;
         _removeFriendButton = null;
         _closeButton = null;
      }
      
      private function initializeStartState() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         _clampSpinnerHelper = new LoopHelper(mcClampSpinner);
         _clampSpinnerHelper.stop();
         _clampSpeed = 1;
         mcClampSpinner.alpha = 0;
         mcClampSpinner.visible = false;
         mcAvatar.alpha = 0;
         mcGlow.visible = false;
         mcDial.alpha = 0;
         mcDial.visible = false;
         mcDial.rotation = -45;
         mcCircler.alpha = 0;
         mcCircler.visible = false;
         mcCircler.stop();
         mcClamps.alpha = 0;
         mcClamps.visible = false;
         mcClamps.scaleX = mcClamps.scaleY = 1.25;
         mc2Slot.alpha = 0;
         mc2Slot.visible = false;
         mc2Slot.scaleX = mc2Slot.scaleY = 2;
         mc2Slot.mouseEnabled = false;
         mc4Slot.alpha = 0;
         mc4Slot.visible = false;
         mc4Slot.scaleX = mc4Slot.scaleY = 2;
         mc4Slot.mouseEnabled = false;
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
      
      private function onLoadAvatarPicError(param1:IOErrorEvent) : void
      {
         _avatarPictureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadAvatarPicComplete);
         _avatarPictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadAvatarPicError);
         _avatarPictureLoader.unload();
         _avatarPictureLoader = null;
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
            "_autoAlpha":1,
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
            "_autoAlpha":0,
            "time":0.5,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(mcAvatar,{
            "_autoAlpha":0,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
      
      public function set menuMode(param1:String) : void
      {
         if(_mode == param1)
         {
            return;
         }
         DebugLog.instance.log("menuMode: " + param1);
         switch(param1)
         {
            case MENU_MODE_GENERAL:
               Tweener.removeTweens(mc4Slot,"_autoAlpha");
               showGeneralButtons();
               Tweener.addTween(mc4Slot,{
                  "_autoAlpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "time":0.5
               });
               break;
            case MENU_MODE_PENDING:
               Tweener.removeTweens(mc2Slot,"_autoAlpha");
               Tweener.addTween(mc2Slot,{
                  "_autoAlpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "time":0.5,
                  "onComplete":showPendingButtons
               });
               break;
            case MENU_MODE_TIMER:
               Tweener.removeTweens(mcTimer,"_autoAlpha");
               Tweener.addTween(mcTimer,{
                  "_autoAlpha":1,
                  "scaleX":1,
                  "scaleY":1,
                  "x":0,
                  "time":0.5
               });
               break;
            default:
               Tweener.addTween(mc2Slot,{
                  "_autoAlpha":0,
                  "scaleX":2,
                  "scaleY":2,
                  "x":0,
                  "time":0.5
               });
               Tweener.addTween(mc4Slot,{
                  "_autoAlpha":0,
                  "scaleX":2,
                  "scaleY":2,
                  "x":0,
                  "time":0.5
               });
               Tweener.addTween(mcTimer,{
                  "_autoAlpha":0,
                  "scaleX":2,
                  "scaleY":2,
                  "x":0,
                  "time":0.5
               });
               hideAllButtons();
         }
         _mode = param1;
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
      
      private function showPendingButtons() : void
      {
         cascadeOpenButtons([_addButton,_ignoreButton,_closeButton]);
      }
      
      public function open() : Boolean
      {
         var _loc1_:Boolean = _opened;
         _opened = true;
         _closing = false;
         visible = true;
         mouseChildren = true;
         if(!_isDisabled)
         {
            mcCircler.play();
         }
         else
         {
            mcCircle.alpha = 0;
            Tweener.addTween(mcCircle,{
               "_autoAlpha":1,
               "scaleX":1,
               "scaleY":1,
               "time":1
            });
         }
         Tweener.addTween(mcCircler,{
            "_autoAlpha":1,
            "time":1
         });
         Tweener.addTween(mcClamps,{
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
      
      private function finishFlashGlow() : void
      {
         mcGlow.visible = false;
      }
      
      public function get avatarId() : *
      {
         return _avatarId;
      }
      
      public function set showSpinnerClamps(param1:Boolean) : void
      {
         if(param1)
         {
            _clampSpinnerHelper.play();
            Tweener.addTween(mcClampSpinner,{
               "scaleX":1.15,
               "scaleY":1.15,
               "_autoAlpha":1,
               "time":0.5
            });
         }
         else
         {
            Tweener.addTween(mcClampSpinner,{
               "scaleX":1,
               "scaleY":1,
               "_autoAlpha":0,
               "time":0.5,
               "onComplete":_clampSpinnerHelper.stop
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
      
      private function onAvatarRollOut(param1:MouseEvent) : void
      {
         _clampSpinnerHelper.speed = _clampSpeed;
      }
      
      private function onCloseButtonClick(param1:MouseEvent) : void
      {
         if(_closeButtonHandler == null)
         {
            AvatarManager.getInstance().handleCloseButtonClick(this);
         }
         else
         {
            _closeButtonHandler.call(this,this);
         }
      }
      
      public function set playerNameTitle(param1:String) : void
      {
         _nameWire.title.text = param1;
      }
      
      private function onIgnoreFriendButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleIgnoreFriendButtonClick(this);
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
      
      private function onBattleButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleBattleButtonClick(this);
      }
      
      public function set timerPercent(param1:Number) : void
      {
         Tweener.addTween(_timerFill,{
            "rotation":(100 - param1) * TIMER_ANGLE_PERCENTAGE_DELTA + TIMER_ANGLE_FULL,
            "time":1
         });
         _timerText;
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
      
      public function set playerNameSubtitle(param1:String) : void
      {
         _nameWire.subtitle.text = param1;
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
      
      private function onChatButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleChatButtonClick(this);
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
            "_autoAlpha":1,
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
      
      private function showGeneralButtons() : void
      {
         if(!_isBuddy)
         {
            cascadeOpenButtons([_battleButton,_tradeButton,_chatButton,_friendsButton,_closeButton]);
         }
         else
         {
            cascadeOpenButtons([_battleButton,_tradeButton,_chatButton,_removeFriendButton,_closeButton]);
         }
      }
      
      private function closeTweensComplete() : void
      {
         visible = false;
      }
      
      public function get playerId() : *
      {
         return _playerId;
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
      
      private function onFriendsButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleFriendButtonClick(this);
      }
      
      public function set showKickButton(param1:Boolean) : void
      {
         _closeButton.isKickButton = param1;
         showCloseButton = param1;
      }
      
      private function onRemoveFriendButtonClick(param1:MouseEvent) : void
      {
         AvatarManager.getInstance().handleRemoveFriendButtonClick(this);
      }
      
      private function createButtons() : void
      {
         _addButton = new SpinningButtonComponent(new SpinnerIconPlus());
         _addButton.x = 63;
         _addButton.y = -19;
         mcButtonsContainer.addChild(_addButton);
         _ignoreButton = new SpinningButtonComponent(new SpinnerIconMinus());
         _ignoreButton.color = SpinningButtonComponent.COLOR_RED;
         _ignoreButton.x = 63;
         _ignoreButton.y = 17;
         mcButtonsContainer.addChild(_ignoreButton);
         _battleButton = new SpinningButtonComponent(new SpinnerIconB());
         _battleButton.x = 63;
         _battleButton.y = -18;
         mcButtonsContainer.addChild(_battleButton);
         _tradeButton = new SpinningButtonComponent(new SpinnerIconT());
         _tradeButton.x = 63;
         _tradeButton.y = 18;
         mcButtonsContainer.addChild(_tradeButton);
         _chatButton = new SpinningButtonComponent(new SpinnerIconC());
         _chatButton.x = 44;
         _chatButton.y = 48;
         _chatButton.scaleX = _chatButton.scaleY = 0.7;
         mcButtonsContainer.addChild(_chatButton);
         _friendsButton = new SpinningButtonComponent(new SpinnerIconF());
         _friendsButton.x = 13;
         _friendsButton.y = 64;
         _friendsButton.scaleX = _friendsButton.scaleY = 0.7;
         mcButtonsContainer.addChild(_friendsButton);
         _removeFriendButton = new SpinningButtonComponent(new SpinnerIconR());
         _removeFriendButton.x = 13;
         _removeFriendButton.y = 64;
         _removeFriendButton.scaleX = _removeFriendButton.scaleY = 0.7;
         mcButtonsContainer.addChild(_removeFriendButton);
         _closeButton = new SpinningButtonSmallComponent(new SpinnerIconX());
         _closeButton.x = -18;
         _closeButton.y = 54;
         mcButtonsContainer.addChild(_closeButton);
         _addButton.addEventListener(MouseEvent.CLICK,onAddFriendButtonClick,false,0,true);
         _ignoreButton.addEventListener(MouseEvent.CLICK,onIgnoreFriendButtonClick,false,0,true);
         _battleButton.addEventListener(MouseEvent.CLICK,onBattleButtonClick,false,0,true);
         _tradeButton.addEventListener(MouseEvent.CLICK,oTradeButtonClick,false,0,true);
         _chatButton.addEventListener(MouseEvent.CLICK,onChatButtonClick,false,0,true);
         _friendsButton.addEventListener(MouseEvent.CLICK,onFriendsButtonClick,false,0,true);
         _removeFriendButton.addEventListener(MouseEvent.CLICK,onRemoveFriendButtonClick,false,0,true);
         _closeButton.addEventListener(MouseEvent.CLICK,onCloseButtonClick,false,0,true);
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
            alpha = 0.25;
            if(mcCircle.visible)
            {
               Tweener.addTween(mcCircle,{
                  "_autoAlpha":1,
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
            alpha = 1;
            if(mcCircle.visible)
            {
               Tweener.addTween(mcCircle,{
                  "_autoAlpha":0,
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

