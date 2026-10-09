package com.arkadium.virmon.shared.widgets.megawidget
{
   import caurina.transitions.Tweener;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.handlers.battle.IBattleInvitationAcceptHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationAcceptHandler;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconLightning;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.widgets.AbstractWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.StateType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class MegaWidget extends AbstractWidget implements IMegaWidget, IBattleInvitationAcceptHandler, IChatInvitationAcceptHandler
   {
      
      public static const COLOR_BLUE:String = MegaSpinner.COLOR_BLUE;
      
      public static const COLOR_ORANGE:String = MegaSpinner.COLOR_ORANGE;
      
      public static const CENTER_MODE_SEARCHING:String = MegaSpinner.CENTER_MODE_SEARCHING;
      
      public static const CENTER_MODE_TIMER:String = MegaSpinner.CENTER_MODE_TIMER;
      
      public static const CENTER_MODE_UNKNOWN:String = MegaSpinner.CENTER_MODE_UNKNOWN;
      
      public static const ROOM_TYPE_CHAT:String = "Chat";
      
      public static const ROOM_TYPE_BATTLE:String = "Battle";
      
      public static const ROOM_TYPE_AUTO_BATTLE:String = "AutoBattle";
      
      public static const ROOM_TYPE_NONE:String = "None";
      
      private var _convertButtonController:MegaWidgetButtonController;
      
      public var mcButtonHolderLaunch:MovieClip;
      
      private var _battleGameService:IBattleGameService;
      
      private var _currentRoomType:String;
      
      private var _avatarSpinners:Array;
      
      private var _chatHandler:MegaWidgetChatHandler;
      
      public var mcTitlePrepareForBattle:MovieClip;
      
      private var _tradeHandler:MegaWidgetTradeHandler;
      
      private var _quitChatButtonController:MegaWidgetButtonController;
      
      public var mcTitlePrivateChatNonCreator:MovieClip;
      
      private var _autoBattleButtonHandlers:Dictionary;
      
      private var _launchButtonController:MegaWidgetButtonController;
      
      private var _battleHandler:MegaWidgetBattleHandler;
      
      private var _roomTitles:Array;
      
      private var _autoBattleHandler:MegaWidgetAutoBattleHandler;
      
      private var _megaSpinner:MegaSpinner;
      
      public var mcButtonHolderQuitChat:MovieClip;
      
      public var mcButtonHolderQuit:MovieClip;
      
      private var _chatGameService:IChatGameService;
      
      public var mcTitlePrivateChat:MovieClip;
      
      private var _autoBattleButtons:Array;
      
      private var _quitButtonController:MegaWidgetButtonController;
      
      public var mcTitleBattleNow:MovieClip;
      
      public var mcTitlePrepareForBattleNonCreator:MovieClip;
      
      public var mcButtonHolderConvert:MovieClip;
      
      private var _currentMode:String;
      
      public function MegaWidget()
      {
         var _loc1_:MovieClip = null;
         super(WidgetType.WIDGET_MEGA_WIDGET);
         createSpinningButtons();
         setMode(WidgetType.MODE_HIDDEN);
         _battleGameService = GameServiceProvider.getInstance().battleGameService;
         _chatGameService = GameServiceProvider.getInstance().chatGameService;
         _tradeHandler = new MegaWidgetTradeHandler();
         _roomTitles = [mcTitlePrepareForBattle,mcTitlePrivateChat,mcTitleBattleNow,mcTitlePrepareForBattleNonCreator,mcTitlePrivateChatNonCreator];
         for each(_loc1_ in _roomTitles)
         {
            _loc1_.alpha = 0;
         }
         setRoomType(ROOM_TYPE_NONE);
         _quitButtonController = new MegaWidgetButtonController(mcButtonHolderQuit);
         _quitButtonController.button.icon = new SpinnerIconX();
         _quitButtonController.button.color = SpinningButtonComponent.COLOR_RED;
         _quitChatButtonController = new MegaWidgetButtonController(mcButtonHolderQuitChat);
         _quitChatButtonController.button.icon = new SpinnerIconX();
         _quitChatButtonController.button.color = SpinningButtonComponent.COLOR_RED;
         _convertButtonController = new MegaWidgetButtonController(mcButtonHolderConvert);
         _convertButtonController.button.icon = new SpinnerIconLightning();
         _convertButtonController.button.color = SpinningButtonComponent.COLOR_RED;
         _launchButtonController = new MegaWidgetButtonController(mcButtonHolderLaunch);
         _launchButtonController.button.icon = new SpinnerIconLightning();
         _launchButtonController.button.color = SpinningButtonComponent.COLOR_RED;
      }
      
      override public function destroy() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in _autoBattleButtons)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,onAutoBattleButtonClick);
         }
         _quitButtonController.destroy();
         _convertButtonController.destroy();
         _launchButtonController.destroy();
         _quitChatButtonController.destroy();
         super.destroy();
      }
      
      public function isAutoBattle() : Boolean
      {
         return _megaSpinner.autoBattlePickerOpen;
      }
      
      public function setNumAutoBattlePlayers(param1:int) : void
      {
         _megaSpinner.autoBattleNumPlayers = param1;
      }
      
      private function onAutoBattleButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_autoBattleButtonHandlers[_loc2_] != null)
         {
            _autoBattleButtonHandlers[_loc2_].call(this);
         }
      }
      
      override public function init(param1:Object = null) : void
      {
         var _loc2_:MovieClip = null;
         createMegaSpinner();
         createButtons();
         _avatarSpinners = _megaSpinner.avatarSpinners;
         for each(_loc2_ in _roomTitles)
         {
            this.setChildIndex(_loc2_,0);
         }
         reset();
      }
      
      public function handleBattleInvitationAccept(param1:String, param2:String, param3:int, param4:Boolean) : *
      {
         if(_battleHandler == null)
         {
            this.setMode(WidgetType.MODE_BATTLE);
            log("handleBattleInvitationRequest: creating the battle handler");
            _battleHandler = new MegaWidgetBattleHandler(this);
            _battleHandler.handleBattleInvitationAccept(param1,param2,param3,param4);
            if(Managers.stateManager.getStateByName(StateType.HOME.name) != null)
            {
               Managers.stateManager.getStateByName(StateType.HOME.name).setMode(StateType.MODE_BATTLE);
            }
         }
      }
      
      private function createSpinningButtons() : void
      {
         mcButtonHolderLaunch.mcButton = new SpinningButtonComponent();
         mcButtonHolderLaunch.mcButton.x = 50;
         mcButtonHolderLaunch.mcButton.y = 54;
         mcButtonHolderLaunch.mcButton.scaleX = 3.185;
         mcButtonHolderLaunch.mcButton.scaleY = 3.185;
         mcButtonHolderLaunch.addChildAt(mcButtonHolderLaunch.mcButton,0);
         mcButtonHolderConvert.mcButton = new SpinningButtonComponent();
         mcButtonHolderConvert.mcButton.x = -33;
         mcButtonHolderConvert.mcButton.y = 20;
         mcButtonHolderConvert.mcButton.scaleX = 1.73;
         mcButtonHolderConvert.mcButton.scaleY = 1.73;
         mcButtonHolderConvert.addChild(mcButtonHolderConvert.mcButton);
         mcButtonHolderQuitChat.mcButton = new SpinningButtonComponent();
         mcButtonHolderQuitChat.mcButton.x = 18.5;
         mcButtonHolderQuitChat.mcButton.y = 19.75;
         mcButtonHolderQuitChat.mcButton.scaleX = 1.155;
         mcButtonHolderQuitChat.mcButton.scaleY = 1.155;
         mcButtonHolderQuitChat.addChild(mcButtonHolderQuitChat.mcButton);
         mcButtonHolderQuit.mcButton = new SpinningButtonComponent();
         mcButtonHolderQuit.mcButton.x = 18.5;
         mcButtonHolderQuit.mcButton.y = 19.75;
         mcButtonHolderQuit.mcButton.scaleX = 1.155;
         mcButtonHolderQuit.mcButton.scaleY = 1.155;
         mcButtonHolderQuit.addChild(mcButtonHolderQuit.mcButton);
      }
      
      public function isPlayerInSameChatRoom(param1:String) : Boolean
      {
         if(_chatHandler == null)
         {
            return false;
         }
         return _chatHandler.isPlayerInSameChatRoom(param1);
      }
      
      override public function setMode(param1:String) : void
      {
         log("Setting to mode " + param1 + " currentRoomType: " + _currentRoomType);
         if(_currentRoomType != ROOM_TYPE_NONE)
         {
            param1 = WidgetType.MODE_BATTLE;
         }
         else if(param1 == _currentMode)
         {
            closeGameOptionsIfNecessary(param1);
            return;
         }
         switch(param1)
         {
            case WidgetType.MODE_HOME:
               if(Managers.homeBreadcrumbUIManager != null)
               {
                  Managers.homeBreadcrumbUIManager.showBreadcrumb();
               }
               if(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name) != null)
               {
                  Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_HEADER.name)["disableMenu"](false);
               }
               break;
            case WidgetType.MODE_HIDDEN:
            case WidgetType.MODE_MINIMIZED:
            case WidgetType.MODE_BATTLE:
            default:
               if(Managers.homeBreadcrumbUIManager != null)
               {
                  Managers.homeBreadcrumbUIManager.hideBreadcrumb();
               }
         }
         _currentMode = param1;
         closeGameOptionsIfNecessary(param1);
         Managers.stateManager.hideQuickTips();
      }
      
      public function hideAutoBattlePicker() : void
      {
         _megaSpinner.showAutoBattlePicker = false;
      }
      
      public function setRoomType(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(param1 == null)
         {
            param1 = ROOM_TYPE_NONE;
         }
         for each(_loc3_ in _roomTitles)
         {
            Tweener.addTween(_loc3_,{
               "alpha":0,
               "time":3
            });
         }
         switch(param1)
         {
            case ROOM_TYPE_AUTO_BATTLE:
               _loc4_ = mcTitleBattleNow;
               break;
            case ROOM_TYPE_BATTLE:
               _loc4_ = param2 ? mcTitlePrepareForBattle : mcTitlePrepareForBattleNonCreator;
               break;
            case ROOM_TYPE_CHAT:
               _loc4_ = param2 ? mcTitlePrivateChat : mcTitlePrivateChatNonCreator;
               break;
            default:
               param1 = ROOM_TYPE_NONE;
               _currentRoomType = param1;
               return;
         }
         Tweener.addTween(_loc4_,{
            "alpha":1,
            "time":3
         });
         _currentRoomType = param1;
      }
      
      public function get autoBattleButtons() : Array
      {
         return _megaSpinner.autoBattleButtons;
      }
      
      public function killAutoBattle() : void
      {
         if(_autoBattleHandler != null)
         {
            _autoBattleHandler.destroy();
            _autoBattleHandler = null;
         }
      }
      
      public function get convertButtonController() : MegaWidgetButtonController
      {
         return _convertButtonController;
      }
      
      public function startAutoBattle(param1:int = 2) : void
      {
         this.setMode(WidgetType.MODE_BATTLE);
         if(_battleHandler != null)
         {
            killBattle();
         }
         if(_autoBattleHandler != null)
         {
            return;
         }
         _autoBattleHandler = new MegaWidgetAutoBattleHandler(this);
         _autoBattleHandler.startAutoBattle(param1);
         log("startAutoBattle() " + Managers.stateManager.state);
         if(Managers.stateManager.state == StateType.HOME.name)
         {
            Managers.stateManager.getStateByName(StateType.HOME.name).setMode(StateType.MODE_BATTLE);
         }
         else
         {
            Managers.stateManager.setStateData(StateType.HOME,{"mode":StateType.MODE_BATTLE});
            Managers.stateManager.setState(StateType.HOME);
         }
      }
      
      public function canInvitePlayerToChat(param1:String) : Boolean
      {
         if(_chatHandler == null)
         {
            return true;
         }
         return _chatHandler.canInvitePlayerToChat(param1);
      }
      
      public function reset(param1:Boolean = true) : void
      {
         var _loc2_:MegaWidgetAvatarSpinner = null;
         _battleGameService.addBattleInvitationAcceptHandler(IBattleInvitationAcceptHandler(this));
         _chatGameService.addChatInvitationAcceptHandler(IChatInvitationAcceptHandler(this));
         resetAllSpinners();
         resetAllButtons();
         _megaSpinner.addEventListener(MegaSpinner.EVENT_CLOSED,onMegaSpinnerClosed,false,0,true);
         _megaSpinner.close();
         hideAutoBattlePicker();
         setCenterMode(MegaWidget.CENTER_MODE_UNKNOWN);
         setRoomType(ROOM_TYPE_NONE);
         for each(_loc2_ in _avatarSpinners)
         {
            _loc2_.closeButtonHandler = null;
         }
         if(Managers.stateManager.getStateByName(StateType.HOME.name) != null)
         {
            Managers.stateManager.getStateByName(StateType.HOME.name).setMode(StateType.MODE_HOME);
            this.setMode(WidgetType.MODE_BATTLE);
         }
         killBattle();
         killAutoBattle();
         killChat();
         if(param1)
         {
            this.setMode(WidgetType.MODE_HOME);
         }
      }
      
      public function handleStateChange() : void
      {
         log("handleStateChange()");
         if(null == _autoBattleHandler)
         {
            return;
         }
         log("handleStateChange(): autobattle handler not null");
         if("" != _battleGameService.battleName)
         {
            return;
         }
         log("handleStateChange(): Autobattle active, not started");
         _battleGameService.cancelMatchMaking();
         reset();
      }
      
      public function invitePlayerToChat(param1:String, param2:int) : void
      {
         if(_battleHandler != null)
         {
            log("invitePlayerToChat: battle handler still active.  Killing it.");
            resetAllSpinners();
            _battleGameService.quitGame();
            killBattle();
         }
         if(_autoBattleHandler != null)
         {
            resetAllSpinners();
            _battleGameService.quitGame();
            killAutoBattle();
         }
         else if(_chatHandler != null && _chatHandler.isPlayerInSameChatRoom(param1))
         {
            return;
         }
         this.setMode(WidgetType.MODE_BATTLE);
         _chatHandler = new MegaWidgetChatHandler(this);
         _chatHandler.invitePlayerToChat(param1.toLowerCase(),param2);
         Managers.stateManager.getStateByName(StateType.HOME.name).setMode(StateType.MODE_BATTLE);
      }
      
      private function resetAllButtons() : void
      {
         _quitButtonController.close();
         _quitChatButtonController.close();
         _launchButtonController.close();
         _convertButtonController.close();
         _quitButtonController.clickHandler = null;
         _quitChatButtonController.clickHandler = null;
         _launchButtonController.clickHandler = null;
         _convertButtonController.clickHandler = null;
         _autoBattleButtonHandlers = new Dictionary(true);
      }
      
      public function get launchButtonController() : MegaWidgetButtonController
      {
         return _launchButtonController;
      }
      
      public function resetAllSpinners() : void
      {
         var _loc1_:MegaWidgetAvatarSpinner = null;
         log("resetAllSpinners");
         for each(_loc1_ in _avatarSpinners)
         {
            resetAvatarSpinner(_loc1_);
         }
      }
      
      public function canInvitePlayerToBattle(param1:String) : Boolean
      {
         if(_battleHandler == null)
         {
            return true;
         }
         return _battleHandler.canInvitePlayerToBattle(param1);
      }
      
      public function openSpinner(param1:String) : void
      {
         _megaSpinner.color = param1;
         this.addChildAt(_megaSpinner,_roomTitles.length);
         _megaSpinner.open();
         openAllSpinners();
         _quitButtonController.open();
         _quitChatButtonController.open();
         _convertButtonController.open();
         _launchButtonController.open();
      }
      
      public function resetAvatarSpinner(param1:MegaWidgetAvatarSpinner, param2:Boolean = false) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.killAvatarPicture();
         param1.playerName = "";
         param1.showName = false;
         param1.disabled = true;
         param1.showAvatar = false;
         param1.menuMode = MegaWidgetAvatarSpinner.MENU_MODE_NONE;
         param1.playerNameSubtitle = "";
         param1.playerNameTitle = "";
         param1.playerNameSuperTitle = "";
         param1.showCloseButton = false;
         param1.showKickButton = false;
         param1.open();
      }
      
      private function onMegaSpinnerClosed(param1:Event) : void
      {
         _megaSpinner.removeEventListener(MegaSpinner.EVENT_CLOSED,onMegaSpinnerClosed);
         if(this.contains(_megaSpinner))
         {
            this.removeChild(_megaSpinner);
         }
      }
      
      public function invitePlayerToBattle(param1:String, param2:int) : void
      {
         if(_chatHandler != null)
         {
            resetAllSpinners();
            _chatGameService.exitChatRoom();
            killChat();
         }
         if(_autoBattleHandler != null)
         {
            resetAllSpinners();
            _battleGameService.quitGame();
            _battleGameService.cancelMatchMaking();
            killAutoBattle();
         }
         this.setMode(WidgetType.MODE_BATTLE);
         if(_battleHandler == null)
         {
            _battleHandler = new MegaWidgetBattleHandler(this);
         }
         _battleHandler.invitePlayerToBattle(param1.toLowerCase(),param2);
         Managers.stateManager.getStateByName(StateType.HOME.name).setMode(StateType.MODE_BATTLE);
      }
      
      public function set avatarSpinnerCloseButtonHandler(param1:IMegaWidgetAvatarSpinnerCloseHandler) : void
      {
         var _loc2_:MegaWidgetAvatarSpinner = null;
         for each(_loc2_ in _avatarSpinners)
         {
            _loc2_.closeButtonHandler = param1.handleAvatarSpinnerClose;
         }
      }
      
      public function openAllSpinners() : void
      {
         var _loc1_:MegaWidgetAvatarSpinner = null;
         for each(_loc1_ in _avatarSpinners)
         {
            _loc1_.open();
         }
      }
      
      public function setCenterMode(param1:String) : void
      {
         _megaSpinner.center = param1;
      }
      
      private function createMegaSpinner() : void
      {
         _megaSpinner = new MegaSpinner();
         _megaSpinner.init();
         _megaSpinner.x = 700;
         _megaSpinner.y = 384;
      }
      
      public function killBattle(param1:Boolean = false) : void
      {
         if(_battleHandler != null)
         {
            _battleHandler.destroy(param1);
            _battleHandler = null;
         }
      }
      
      public function handleChatInvitationAccept(param1:String, param2:String, param3:int, param4:int) : void
      {
         log("handleChatInvitationAccept");
         if(_autoBattleHandler != null)
         {
            resetAllSpinners();
            _battleGameService.quitGame();
            _battleGameService.cancelMatchMaking();
            IChatInvitationAcceptHandler(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name)).handleChatInvitationAccept(null,null,-1,-1);
         }
         if(_chatHandler == null)
         {
            this.setMode(WidgetType.MODE_BATTLE);
            _chatHandler = new MegaWidgetChatHandler(this);
            _chatHandler.handleChatInvitationAccept(param1,param2,param3,param4);
         }
         else
         {
            killChat();
            resetAllSpinners();
            _chatHandler = new MegaWidgetChatHandler(this);
            _chatHandler.handleChatInvitationAccept(param1,param2,param3,param4);
         }
         if(Managers.stateManager.getStateByName(StateType.HOME.name) != null)
         {
            Managers.stateManager.getStateByName(StateType.HOME.name).setMode(StateType.MODE_BATTLE);
         }
      }
      
      public function setTimerText(param1:String) : void
      {
         _megaSpinner.timerText = param1;
      }
      
      public function showAutoBattlePicker() : void
      {
         _megaSpinner.showAutoBattlePicker = true;
      }
      
      public function get quitChatButtonController() : MegaWidgetButtonController
      {
         return _quitChatButtonController;
      }
      
      public function killChat(param1:Boolean = false) : void
      {
         if(_chatHandler != null)
         {
            _chatHandler.destroy(param1);
            _chatHandler = null;
         }
      }
      
      public function get quitButtonController() : MegaWidgetButtonController
      {
         return _quitButtonController;
      }
      
      private function closeGameOptionsIfNecessary(param1:String) : void
      {
         if(param1 == WidgetType.MODE_BATTLE)
         {
            Managers.stateManager.saveAndCloseGameOptions();
         }
      }
      
      private function createButtons() : void
      {
         var _loc1_:MovieClip = null;
         _autoBattleButtonHandlers = new Dictionary();
         _autoBattleButtons = _megaSpinner.autoBattleButtons;
         for each(_loc1_ in _autoBattleButtons)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,onAutoBattleButtonClick);
         }
      }
      
      public function quitBattle() : void
      {
         if(null == _battleHandler)
         {
            return;
         }
         _battleGameService.quitGame();
         reset();
      }
      
      public function getAvatarSpinners() : Array
      {
         return _avatarSpinners;
      }
      
      public function convertToBattle() : void
      {
         killChat();
         if(_battleHandler == null)
         {
            _battleHandler = new MegaWidgetBattleHandler(this);
         }
         _battleHandler.convertToBattle();
      }
      
      public function setAutoBattleButtonHandler(param1:MovieClip, param2:Function) : void
      {
         _autoBattleButtonHandlers[param1] = param2;
      }
      
      public function invitePlayerToTrade(param1:String, param2:int) : void
      {
         _tradeHandler.invitePlayerToTrade(param1.toLowerCase(),param2);
      }
   }
}

