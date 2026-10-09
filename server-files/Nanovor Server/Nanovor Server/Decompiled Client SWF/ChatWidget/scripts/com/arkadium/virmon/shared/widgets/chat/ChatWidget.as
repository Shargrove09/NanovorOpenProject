package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.handlers.battle.IBattleCreatedHandler;
   import com.arkadium.communications.handlers.battle.IGameOverHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationAcceptHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomCreatedHandler;
   import com.arkadium.virmon.avatar.IAvatarSpinnerConsumer;
   import com.arkadium.virmon.avatar.IAvatarSpinnerProvider;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.elements.AlertBubble;
   import com.arkadium.virmon.shared.widgets.AbstractWidget;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.IWidgetLoadedHandler;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.state.widgetmanager.IWidgetManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class ChatWidget extends AbstractWidget implements IChatPanelClickedHandler, IChatPanelStateHandler, IGameOverHandler, IBattleCreatedHandler, IWidgetLoadedHandler, IChatRoomCreatedHandler, IChatInvitationAcceptHandler
   {
      
      private static const BUTTON_OPEN:String = "Open";
      
      private static const BUTTON_CLOSE:String = "Close";
      
      private static const BUTTON_TRANSITION_OPEN:String = "TransitionToOpen";
      
      private static const BUTTON_TRANSITION_CLOSE:String = "TransitionToClose";
      
      public var mcLaserSpinner:MovieClip;
      
      private var _currentAlertForMissedChatMessages:AlertBubble;
      
      private var _battleGameService:IBattleGameService;
      
      public var mcChatPanel:ChatPanel;
      
      public var mcLaserFrame:MovieClip;
      
      public var mcTabContainer:MovieClip;
      
      public var mcFriendsPanel:FriendsPanel;
      
      private var _isClosingOrOpening:Boolean;
      
      private var _chatGameService:IChatGameService;
      
      private var _paneOpen:Boolean = false;
      
      private var _alertForMissedChatMessagesInHomeStateOnly:AlertBubble;
      
      private var _widgetManager:IWidgetManager;
      
      private var _chatPanelView:ChatPanelView;
      
      public var mcOpenClose:MovieClip;
      
      private var _alertForMissedChatMessagesInBattleOrTrade:AlertBubble;
      
      private var _currentMode:String = "modeHome";
      
      public function ChatWidget()
      {
         addFrameScript(0,this.frame1);
         super(WidgetType.WIDGET_CHAT);
         this._alertForMissedChatMessagesInHomeStateOnly = new AlertBubble();
         this._alertForMissedChatMessagesInHomeStateOnly.x = 20;
         this._alertForMissedChatMessagesInHomeStateOnly.y = 580;
         addChild(this._alertForMissedChatMessagesInHomeStateOnly);
         this._alertForMissedChatMessagesInBattleOrTrade = new AlertBubble();
         this._alertForMissedChatMessagesInBattleOrTrade.x = 21;
         this._alertForMissedChatMessagesInBattleOrTrade.y = 676;
         addChild(this._alertForMissedChatMessagesInBattleOrTrade);
         this._chatGameService = GameServiceProvider.getInstance().chatGameService;
      }
      
      private function closePane() : void
      {
         log("closePane()");
         if(this._isClosingOrOpening)
         {
            return;
         }
         this._isClosingOrOpening = true;
         this.clearOpenCloseTweens();
         this._chatPanelView.closeChatPanel();
         this.mcFriendsPanel.showFields();
         this._paneOpen = false;
         this.mcOpenClose.gotoAndPlay(BUTTON_TRANSITION_OPEN);
      }
      
      private function resetToStandard() : void
      {
         this._alertForMissedChatMessagesInBattleOrTrade.visible = false;
         this._currentAlertForMissedChatMessages = this._alertForMissedChatMessagesInHomeStateOnly;
         this._chatPanelView.showPublicChat();
         this._chatPanelView.alpha = 1;
         this._chatPanelView.visible = true;
         this.mcFriendsPanel.enable();
         this.mcFriendsPanel.hideFields();
         this.mcOpenClose.gotoAndStop(BUTTON_CLOSE);
         this._chatPanelView.setMode(ChatPanelView.STANDARD);
         this._chatPanelView.openChatPanelImmediately();
      }
      
      override public function init(param1:Object = null) : void
      {
         this._chatPanelView = new ChatPanelView(stage,this.mcFriendsPanel,this.mcChatPanel,Managers.permissionsManager,this._chatGameService,GameServiceProvider.getInstance().userGameService);
         this.openPaneImmediately();
         this._alertForMissedChatMessagesInHomeStateOnly.visible = false;
         this._alertForMissedChatMessagesInBattleOrTrade.visible = false;
         this.mcLaserFrame.visible = false;
         this.mcLaserFrame.mouseEnabled = false;
         this.mcLaserSpinner.visible = false;
         this.mcLaserSpinner.mouseEnabled = false;
         this.mcOpenClose.addEventListener(MouseEvent.CLICK,this.onOpenCloseClick);
         this.mcOpenClose.mouseEnabled = this.mcOpenClose.mouseChildren = false;
         this.mcOpenClose.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
         this.mcFriendsPanel.parentWidget = this;
         this.mcFriendsPanel.init();
         this.mcFriendsPanel.addTabClickHandler(this.handleFriendsPanelClicked);
         this._chatGameService.addChatRoomCreatedHandler(IChatRoomCreatedHandler(this));
         this._chatGameService.addChatInvitationAcceptHandler(IChatInvitationAcceptHandler(this));
         this._battleGameService = GameServiceProvider.getInstance().battleGameService;
         this._battleGameService.addBattleCreatedHandler(IBattleCreatedHandler(this));
         this._battleGameService.addGameOverHandler(IGameOverHandler(this));
         Managers.widgetManager.addWidgetLoadedHandler(WidgetType.WIDGET_AVATAR,IWidgetLoadedHandler(this));
         this._chatPanelView.addChatPanelStateHandler(IChatPanelStateHandler(this));
         this._chatPanelView.addChatPanelClickedHandler(IChatPanelClickedHandler(this));
         this._alertForMissedChatMessagesInHomeStateOnly.number = 0;
         this._alertForMissedChatMessagesInBattleOrTrade.number = 0;
         this._currentAlertForMissedChatMessages = this._alertForMissedChatMessagesInHomeStateOnly;
         this._chatGameService.populateMessageHistory();
         this._widgetManager = Managers.widgetManager;
         log("Chat widget initialized");
      }
      
      private function onOpenCloseClick(param1:MouseEvent) : void
      {
         if(!this._paneOpen)
         {
            this.openPane();
         }
         else
         {
            this.closePane();
         }
      }
      
      public function handlePrivateMessageAdded() : void
      {
         log("handlePrivateMessageAdded()");
         if(this._currentAlertForMissedChatMessages.visible)
         {
            if(this._currentAlertForMissedChatMessages.alpha == 0)
            {
               Tweener.addTween(this._currentAlertForMissedChatMessages,{
                  "alpha":1,
                  "time":0.5,
                  "transition":"easeOutQuad"
               });
               this.showLaserFrameForAlertingMissedChatMessages();
            }
            this._currentAlertForMissedChatMessages.number += 1;
            if(this._currentAlertForMissedChatMessages.number > 99)
            {
               this._currentAlertForMissedChatMessages.number = 99;
            }
         }
      }
      
      private function enableOpenCloseButton() : void
      {
         this.mcOpenClose.alpha = 1;
         this.mcOpenClose.mouseEnabled = this.mcOpenClose.mouseChildren = true;
         this.mcOpenClose.transform.colorTransform = new ColorTransform();
      }
      
      private function disableOpenCloseButton() : void
      {
         this.mcOpenClose.alpha = 0.5;
         this.mcOpenClose.mouseEnabled = this.mcOpenClose.mouseChildren = false;
         this.mcOpenClose.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
      }
      
      public function handleGameOver(param1:int, param2:Object) : void
      {
         if(WidgetType.MODE_BATTLE != this._currentMode)
         {
            return;
         }
         this._chatGameService.exitChatRoom();
         this._widgetManager.removeWidget(WidgetType.WIDGET_CHAT);
      }
      
      public function handleWidgetLoaded(param1:IWidget) : void
      {
         log("handleWidgetLoaded(): widget: " + param1.widgetName);
         switch(param1.widgetName)
         {
            case WidgetType.WIDGET_AVATAR.name:
               IAvatarSpinnerConsumer(this._chatPanelView).setAvatarSpinnerProvider(IAvatarSpinnerProvider(param1));
               IAvatarSpinnerConsumer(this.mcFriendsPanel).setAvatarSpinnerProvider(IAvatarSpinnerProvider(param1));
         }
      }
      
      override public function setMode(param1:String) : void
      {
         log("setMode(): mode: " + param1 + ", _currentMode: " + this._currentMode);
         if(param1 == this._currentMode)
         {
            return;
         }
         this._widgetManager.addWidget(WidgetType.WIDGET_CHAT);
         this.enableOpenCloseButton();
         switch(param1)
         {
            case WidgetType.MODE_HOME:
               this._chatGameService.rejoinPublicChatRoom();
               log("setting it to alpha 0.5 and removing mouse handler.");
               this.disableOpenCloseButton();
               this.resetToStandard();
               break;
            case WidgetType.MODE_BATTLE:
               this._chatGameService.rejoinPublicChatRoom();
               this._alertForMissedChatMessagesInHomeStateOnly.visible = false;
               this._alertForMissedChatMessagesInBattleOrTrade.number = 0;
               this._alertForMissedChatMessagesInBattleOrTrade.visible = false;
               this._currentAlertForMissedChatMessages = this._alertForMissedChatMessagesInBattleOrTrade;
               this.mcFriendsPanel.disable();
               this._chatPanelView.visible = true;
               this._chatPanelView.setMode(ChatPanelView.BATTLE);
               this._chatPanelView.hidePublicChat();
               this.closePane();
               break;
            case WidgetType.MODE_MINIMIZED:
               this._chatGameService.rejoinPublicChatRoom();
               this.resetToStandard();
               this.mcFriendsPanel.disable();
               this.closePane();
               break;
            case WidgetType.MODE_CLOSED:
               if(this._currentMode == WidgetType.MODE_HIDDEN)
               {
                  this._widgetManager.removeWidget(WidgetType.WIDGET_CHAT);
                  return;
               }
               if(this._paneOpen)
               {
                  this.closePane();
               }
               return;
               break;
            case WidgetType.MODE_HIDDEN:
               this._chatGameService.exitPublicChatRoom();
               this._widgetManager.removeWidget(WidgetType.WIDGET_CHAT);
               break;
            default:
               this.setMode(WidgetType.MODE_HOME);
         }
         this._currentMode = param1;
      }
      
      public function handleChatInvitationAccept(param1:String, param2:String, param3:int, param4:int) : void
      {
         this._chatPanelView.chatHeaderMode = ChatHeaderGlobal.MODE_PRIVATE;
         this._chatPanelView.openChatPanel();
         this.openPane();
         this._chatPanelView.resetScrollBar();
      }
      
      public function handleChatPanelClicked() : void
      {
         if(this._currentMode != WidgetType.MODE_BATTLE)
         {
            this._chatPanelView.setMode(ChatPanelView.STANDARD);
         }
         this._chatPanelView.openChatPanel();
         this.mcFriendsPanel.hideFields();
      }
      
      public function handleBattleCreated(param1:Object = null) : void
      {
         log("ChatWidget.handleBattleCreated()");
         this._chatPanelView.setMode(ChatPanelView.STANDARD);
         this._chatPanelView.openChatPanel();
         this.mcFriendsPanel.hideFields();
      }
      
      private function clearOpenCloseTweens() : void
      {
         Tweener.removeTweens(this.mcLaserFrame,alpha);
         Tweener.removeTweens(this.mcLaserSpinner,alpha);
      }
      
      private function openPaneImmediately() : void
      {
         log("openPaneImmediately()");
         this._paneOpen = true;
         this.mcOpenClose.gotoAndStop(BUTTON_CLOSE);
         this._chatPanelView.openChatPanelImmediately();
      }
      
      public function handleChatPanelOpened() : void
      {
         log("handleChatPanelOpened()");
         this._currentAlertForMissedChatMessages.visible = false;
         this._currentAlertForMissedChatMessages.number = 0;
         this.hideLaserFrameForAlertingMissedChatMessages();
         this._isClosingOrOpening = false;
      }
      
      private function showLaserFrameForAlertingMissedChatMessages() : void
      {
         if(WidgetType.MODE_HOME == this._currentMode)
         {
            return;
         }
         this.mcLaserFrame.visible = true;
         this.mcLaserFrame.alpha = 0;
         Tweener.addTween(this.mcLaserFrame,{
            "alpha":1,
            "time":0.5,
            "transition":"easeOutQuad"
         });
      }
      
      public function handleChatRoomCreated(param1:String) : void
      {
         this._chatPanelView.setMode(ChatPanelView.STANDARD);
         this._chatPanelView.openChatPanel();
         this.mcFriendsPanel.hideFields();
      }
      
      public function handleChatPanelClosed() : void
      {
         log("handleChatPanelClosed()");
         this._currentAlertForMissedChatMessages.visible = true;
         if(this._currentAlertForMissedChatMessages.number == 0)
         {
            this._currentAlertForMissedChatMessages.alpha = 0;
         }
         this._isClosingOrOpening = false;
      }
      
      private function openPane() : void
      {
         log("openPane(): _paneOpen: " + this._paneOpen);
         if(this._paneOpen || this._isClosingOrOpening)
         {
            return;
         }
         this._isClosingOrOpening = true;
         this.clearOpenCloseTweens();
         this._paneOpen = true;
         this.mcOpenClose.gotoAndPlay(BUTTON_TRANSITION_CLOSE);
         this.openChatPanel();
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      private function openChatPanel() : void
      {
         log("_currentMode: " + this._currentMode);
         if(false == this.mcOpenClose.mouseEnabled)
         {
            this._chatPanelView.setMode(ChatPanelView.STANDARD);
         }
         else
         {
            this._chatPanelView.openChatPanel();
         }
         this.mcFriendsPanel.hideFields();
      }
      
      private function hideLaserFrameForAlertingMissedChatMessages() : void
      {
         this.mcLaserFrame.visible = false;
      }
      
      private function handleFriendsPanelClicked(param1:MouseEvent) : void
      {
         this._chatPanelView.setMode(ChatPanelView.MINIMIZED);
         this.mcFriendsPanel.showFields();
      }
   }
}

