package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.adobe.utils.StringUtil;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.handlers.chat.ChatRoomType;
   import com.arkadium.communications.handlers.chat.IChatInvitationErrorHandler;
   import com.arkadium.communications.handlers.chat.IChatInvitationResponseHandler;
   import com.arkadium.communications.handlers.chat.IChatMessageReceivedHandler;
   import com.arkadium.communications.handlers.chat.IUserLeftChatRoomHandler;
   import com.arkadium.virmon.avatar.AvatarSpinnerStateType;
   import com.arkadium.virmon.avatar.IAvatarSpinnerCloseHandler;
   import com.arkadium.virmon.avatar.IAvatarSpinnerConsumer;
   import com.arkadium.virmon.avatar.IAvatarSpinnerProvider;
   import com.arkadium.virmon.avatar.IAvatarSpinnerState;
   import com.arkadium.virmon.shared.data.IPermissionsManager;
   import com.arkadium.virmon.shared.utils.AvatarLoaderProvider;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ChatPanelView implements IChainLoaderConsumer, ISelectedChatRoomChangedHandler, IChatPanelClickedHandler, IAvatarSpinnerCloseHandler, IAvatarSpinnerConsumer, IUserLeftChatRoomHandler, IChatMessageReceivedHandler, IChatInvitationResponseHandler, IChatInvitationErrorHandler
   {
      
      public static const CHAT_CONTAINER_DEFAULT_HEIGHT:Number = 452;
      
      public static const CHAT_CONTAINER_BATTLE_HEIGHT:Number = 210;
      
      public static const STANDARD:String = "standard";
      
      public static const MINIMIZED:String = "minimized";
      
      public static const BATTLE:String = "battle";
      
      private var _chatPanel:IChatPanel;
      
      private var _spinningSendButton:DisplayObject;
      
      private var _chatPanelParent:DisplayObjectContainer;
      
      private var _permissionsManager:IPermissionsManager;
      
      private var _chatInputPanelView:ChatInputPanelView;
      
      private var _avatarHolder:DisplayObject;
      
      private var _toScrollLater:Function;
      
      private var _friendsPanel:DisplayObject;
      
      private var _scrollSliderPercentage:Number = 1;
      
      private var _chainLoader:ChainLoader;
      
      private var _chatMode:String = "standard";
      
      private var _privateChatMessageManager:ChatMessageManager;
      
      private var _chatInputPanelDOC:DisplayObjectContainer;
      
      private var _cannedChatCategories:Dictionary;
      
      private var _avatarSpinnerState:IAvatarSpinnerState;
      
      private var _scrollUp:MovieClip;
      
      private var _chatGameService:IChatGameService;
      
      private var _scrollDown:MovieClip;
      
      private var _isOpen:Boolean = false;
      
      private var _scrollTimer:Timer;
      
      private var _scrollSpeed:int = 1;
      
      private var _scrollTrack:MovieClip;
      
      private var _scrollBounds:Rectangle;
      
      private var _publicChatMessageManager:ChatMessageManager;
      
      private var _handlers:Dictionary;
      
      private var _headerSpinner:MovieClip;
      
      private var _scrollSlider:MovieClip;
      
      private var _scrollDirection:String = "";
      
      private var _stage:Stage;
      
      public function ChatPanelView(param1:Stage, param2:DisplayObject, param3:IChatPanel, param4:IPermissionsManager, param5:IChatGameService, param6:IUserGameService)
      {
         var _loc7_:ChainLoadeeList = null;
         super();
         this._permissionsManager = param4;
         if(false == this._permissionsManager.canChat)
         {
            _loc7_ = new ChainLoadeeList();
            _loc7_.add(new CannedChatDataChainLoadee());
            this._chainLoader = new ChainLoader(_loc7_,IChainLoaderConsumer(this));
            this._chainLoader.load();
         }
         this._stage = param1;
         this._friendsPanel = param2;
         this._chatPanel = param3;
         this._chatGameService = param5;
         this._chatGameService.addChatInvitationErrorHandler(IChatInvitationErrorHandler(this));
         this._chatGameService.addChatInvitationResponseHandler(IChatInvitationResponseHandler(this));
         this._chatGameService.addUserLeftChatRoomHandler(IUserLeftChatRoomHandler(this));
         this._chatGameService.addChatMessageReceivedHandler(IChatMessageReceivedHandler(this));
         this._chatInputPanelView = new ChatInputPanelView(this._chatPanel.chatInputPanel,param4,new ChatInputPanelController(this._chatGameService,param6));
         this._chatInputPanelDOC = this._chatPanel.chatInputPanel as DisplayObjectContainer;
         this._avatarHolder = this._chatPanel.chatInputPanel.avatarHolder;
         this._spinningSendButton = this._chatPanel.chatInputPanel.sendSpinningButton as DisplayObject;
         this._headerSpinner = (this._chatPanel.chatHeader.instructions as MovieClip).mcSpinner as MovieClip;
         if(null != this._headerSpinner.parent)
         {
            this._headerSpinner.parent.removeChild(this._headerSpinner);
         }
         this.createHandlersDictionary();
         this._publicChatMessageManager = new ChatMessageManager(this._chatPanel.publicChatMessageContainer,ChatPanelView(this));
         this._privateChatMessageManager = new ChatMessageManager(this._chatPanel.privateChatMessageContainer,ChatPanelView(this));
         this._scrollUp = this._chatPanel.scrollBarContainer.mcUp;
         this._scrollDown = this._chatPanel.scrollBarContainer.mcDown;
         this._scrollTrack = this._chatPanel.scrollBarContainer.mcScrollTrack;
         this._scrollSlider = this._chatPanel.scrollBarContainer.mcSlider;
         this.scrollBarHeight = CHAT_CONTAINER_DEFAULT_HEIGHT;
         this._chatPanel.chatHeader.publicChatMessageManager = this._publicChatMessageManager;
         this._chatPanel.chatHeader.privateChatMessageManager = this._privateChatMessageManager;
         this._chatPanel.chatHeader.addSelectedChatRoomChangedHandler(ISelectedChatRoomChangedHandler(this));
         this._chatPanel.addChatPanelClickedHandler(IChatPanelClickedHandler(this));
         this._scrollTimer = new Timer(20);
         this._scrollTimer.addEventListener(TimerEvent.TIMER,this.onTime);
         this._chatPanelParent = DisplayObject(this._chatPanel).parent;
         this.init();
      }
      
      public function removeChatPanelStateHandler(param1:IChatPanelStateHandler) : void
      {
         delete this._handlers[IChatPanelStateHandler][param1];
      }
      
      private function hideInstructions() : void
      {
         if(null != this._headerSpinner.parent)
         {
            this._headerSpinner.stop();
            this._headerSpinner.parent.removeChild(this._headerSpinner);
         }
      }
      
      public function addChatPanelStateHandler(param1:IChatPanelStateHandler) : void
      {
         this._handlers[IChatPanelStateHandler][param1] = param1;
      }
      
      public function init() : void
      {
         this.log("init()");
         this._chatPanel.chatHeader.mode = ChatHeaderGlobal.MODE_LOBBY;
         this._chatPanel.chatHeader.setPublicTitle(this._chatGameService.publicChatRoomName);
         this.setMode(STANDARD);
      }
      
      private function handlePrivateMessageAdded() : void
      {
         var _loc1_:IChatPanelStateHandler = null;
         for each(_loc1_ in this._handlers[IChatPanelStateHandler])
         {
            _loc1_.handlePrivateMessageAdded();
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ChatPanelView: " + param1);
      }
      
      public function setMode(param1:String = null) : void
      {
         this._chatMode = param1;
         switch(param1)
         {
            case STANDARD:
               this._chatPanel.chatMessageContainerMask.height = CHAT_CONTAINER_DEFAULT_HEIGHT;
               this._chatPanel.chatMessageContainerMask.y = -CHAT_CONTAINER_DEFAULT_HEIGHT;
               break;
            case BATTLE:
               this._chatPanel.chatMessageContainerMask.height = CHAT_CONTAINER_BATTLE_HEIGHT;
               this._chatPanel.chatMessageContainerMask.y = -CHAT_CONTAINER_BATTLE_HEIGHT;
               this._chatPanel.chatHeader.mode = ChatHeaderGlobal.MODE_PRIVATE;
               break;
            case MINIMIZED:
               if(this._isOpen)
               {
                  this.closeChatPanel(true);
                  break;
               }
               this._chatMode = STANDARD;
               break;
            default:
               this.setMode(STANDARD);
         }
      }
      
      public function handleUserLeftChatRoom(param1:String, param2:String) : void
      {
      }
      
      public function handleChatInvitationError(param1:String, param2:String) : void
      {
      }
      
      private function scrollTo(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         this._scrollSliderPercentage = (this._scrollSlider.y - this._scrollBounds.top) / this._scrollBounds.height;
         if(this.getActiveChatMessageContainer().height > this._chatPanel.chatMessageContainerMask.height || param1.type == "INITIALIZING")
         {
            _loc2_ = this._chatPanel.chatMessageContainerMask.y - this._scrollSliderPercentage * (this.getActiveChatMessageContainer().height - this._chatPanel.chatMessageContainerMask.height);
            if(param1.type == "INITIALIZING")
            {
               Tweener.addTween(this.getActiveChatMessageContainer(),{
                  "y":_loc2_,
                  "time":0.75,
                  "transition":"easeOutQuad"
               });
            }
            else
            {
               this.getActiveChatMessageContainer().y = _loc2_;
            }
         }
      }
      
      private function getActiveChatMessageManager() : ChatMessageManager
      {
         return ChatHeaderGlobal.MODE_LOBBY == this._chatPanel.chatHeader.mode ? this._publicChatMessageManager : this._privateChatMessageManager;
      }
      
      public function openChatPanelImmediately() : void
      {
         this._chatPanel.chatHeader.enableMouse();
         this._chatPanel.visible = true;
         this._chatPanel.alpha = 1;
         this._isOpen = true;
         DisplayObjectContainer(this._chatPanel.chatHeader.instructions).addChild(this._headerSpinner);
         this._chatInputPanelDOC.addChild(this._spinningSendButton);
         this.scrubListeners();
         this.scrollBarHeight = CHAT_CONTAINER_DEFAULT_HEIGHT;
         this._chatPanel.scrollBarContainer.y = -1 * CHAT_CONTAINER_DEFAULT_HEIGHT;
         this._chatPanel.chatHeader.y = -1 * CHAT_CONTAINER_DEFAULT_HEIGHT;
         this._chatPanel.chatHeader.instructions.visible = true;
         this._chatPanel.chatHeader.instructions.alpha = 1;
         this._chatPanel.chatMessageContainerMask.y = this._chatPanel.chatBG.y = -1 * CHAT_CONTAINER_DEFAULT_HEIGHT;
         this.initializeScrollbar();
         this._chatPanel.mouseEnabled = true;
         this._chatPanel.mouseChildren = true;
         this.handlePanelOpened();
         this.resetScrollBar();
      }
      
      public function showPublicChat() : void
      {
         this._chatPanel.chatHeader.showPublicChat();
      }
      
      public function hide() : void
      {
         Tweener.addTween(this,{
            "_autoAlpha":0,
            "time":0.5,
            "onComplete":function():*
            {
               this.visible = false;
            }
         });
         this.handlePanelClosed();
      }
      
      public function handleChatPanelClicked() : void
      {
         var _loc1_:IChatPanelClickedHandler = null;
         for each(_loc1_ in this._handlers[IChatPanelClickedHandler])
         {
            _loc1_.handleChatPanelClicked();
         }
      }
      
      private function handlePanelClosed() : void
      {
         var _loc1_:IChatPanelStateHandler = null;
         this.hideInstructions();
         if(null != this._spinningSendButton.parent)
         {
            this._spinningSendButton.parent.removeChild(this._spinningSendButton);
         }
         if(null != this._avatarHolder.parent)
         {
         }
         for each(_loc1_ in this._handlers[IChatPanelStateHandler])
         {
            _loc1_.handleChatPanelClosed();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ChatPanelView: " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         this.log("handleChainLoaderComplete()");
         this._cannedChatCategories = Dictionary(param1.getLoadedAsset(CannedChatDataChainLoadee.NAME));
         this._chainLoader.destroy();
         this._chainLoader = null;
      }
      
      public function setAvatarSpinnerProvider(param1:IAvatarSpinnerProvider) : void
      {
         this._avatarSpinnerState = param1.avatarSpinnerState;
         param1.addAvatarSpinnerCloseHandler(IAvatarSpinnerCloseHandler(this));
      }
      
      public function hidePublicChat() : void
      {
         this._chatPanel.chatHeader.hidePublicChat();
      }
      
      private function canAutoScroll() : Boolean
      {
         if(this._scrollSliderPercentage == 1)
         {
            return true;
         }
         if(Math.floor(this.getActiveChatMessageManager().length - this._scrollSliderPercentage * this.getActiveChatMessageManager().length) > 0)
         {
            return false;
         }
         if(this._avatarSpinnerState.state == AvatarSpinnerStateType.ACTIVE)
         {
            return false;
         }
         return true;
      }
      
      public function handleChatMessageReceived(param1:ChatRoomType, param2:String, param3:int, param4:int, param5:String) : void
      {
         if(false == this.isAllowedChatMessage(param5))
         {
            return;
         }
         if(this.canAutoScroll())
         {
            this._scrollSlider.y = this._scrollBounds.bottom;
         }
         if(ChatRoomType.PUBLIC == param1)
         {
            this.addPublicChatMesssage(param2,param5,param3,param4);
         }
         else
         {
            this.addPrivateChatMesssage(param2,param5,param3,param4);
         }
      }
      
      private function onTime(param1:TimerEvent) : void
      {
         var _loc2_:Number = this._scrollDirection == "down" ? this._scrollSpeed * -1 : this._scrollSpeed;
         if(this._scrollSlider.y - _loc2_ <= this._scrollBounds.bottom && this._scrollSlider.y - _loc2_ >= this._scrollBounds.top)
         {
            this._scrollSlider.y -= _loc2_;
         }
      }
      
      private function handlePanelOpened() : void
      {
         var _loc1_:IChatPanelStateHandler = null;
         for each(_loc1_ in this._handlers[IChatPanelStateHandler])
         {
            _loc1_.handleChatPanelOpened();
         }
      }
      
      public function get alpha() : Number
      {
         return this._chatPanel.alpha;
      }
      
      public function openChatPanel() : void
      {
         this._chatPanel.chatHeader.enableMouse();
         if(this._isOpen)
         {
            return;
         }
         this.visible = true;
         DisplayObjectContainer(this._chatPanel.chatHeader.instructions).addChild(this._headerSpinner);
         this._chatInputPanelDOC.addChild(this._spinningSendButton);
         this._chatPanel.chatMessageContainerMask.height = BATTLE == this._chatMode ? CHAT_CONTAINER_BATTLE_HEIGHT : CHAT_CONTAINER_DEFAULT_HEIGHT;
         this._chatPanel.chatMessageContainerMask.y = -this._chatPanel.chatMessageContainerMask.height;
         this.getActiveChatMessageContainer().y = this._chatPanel.scrollBarContainer.y = 0;
         this._chatPanel.chatInputPanel.setDefaultText();
         Tweener.addTween(this,{
            "_autoAlpha":1,
            "time":0.5,
            "onComplete":this.openMessagePanel
         });
         this._chatPanel.mouseEnabled = true;
         this._chatPanel.mouseChildren = true;
         this.resetScrollBar();
      }
      
      public function closeMessagePanel(param1:Boolean) : void
      {
         this._isOpen = false;
         Tweener.removeTweens(this._chatPanel.chatHeader.instructions);
         var _loc2_:Function = param1 ? this.doNothing : this.hide;
         Tweener.addTween(this._chatPanel.chatHeader,{
            "y":30,
            "time":0.5,
            "onComplete":_loc2_
         });
         Tweener.addTween(this._chatPanel.chatMessageContainerMask,{
            "height":0,
            "y":0,
            "time":0.5
         });
         Tweener.addTween(this._chatPanel.chatBG,{
            "y":0,
            "time":0.5
         });
         if(param1)
         {
            Tweener.addTween(this._chatPanel.chatHeader.instructions,{
               "_autoAlpha":0,
               "time":0.5,
               "onComplete":this.hideInstructions
            });
         }
         Tweener.addTween(this._publicChatMessageManager.container,{
            "y":0,
            "time":0.5,
            "onComplete":this.scrubListeners
         });
         Tweener.addTween(this._privateChatMessageManager.container,{
            "y":0,
            "time":0.5,
            "onComplete":this.scrubListeners
         });
         this.handlePanelClosed();
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         this._scrollSlider.stopDrag();
         this._scrollSlider.removeEventListener(Event.ENTER_FRAME,this.scrollTo);
         this._scrollTimer.reset();
         this._stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
      }
      
      public function closeChatPanel(param1:Boolean = false) : void
      {
         this._chatPanel.chatHeader.disableMouse();
         if(!this._isOpen && param1)
         {
            return;
         }
         this._chatPanel.mouseEnabled = param1;
         this._chatPanel.mouseChildren = param1;
         this._chatInputPanelView.clearMessage();
         this.closeMessagePanel(param1);
      }
      
      public function resetScrollBar() : void
      {
         var _loc1_:int = this._scrollUp.y + this._scrollUp.height + this._scrollSlider.height / 2;
         var _loc2_:int = this._scrollTrack.height - this._scrollSlider.height;
         var _loc3_:int = this._scrollUp.width / 2;
         this._scrollSlider.y = _loc1_ + _loc2_;
         this._scrollBounds = new Rectangle(_loc3_,_loc1_,0,_loc2_);
         this.scrollTo(new Event("Hack"));
      }
      
      public function get visible() : Boolean
      {
         return this._chatPanelParent.contains(DisplayObject(this._chatPanel));
      }
      
      private function initializeScrollbar() : void
      {
         this._scrollSlider.addEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._scrollUp.addEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._scrollDown.addEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.beginScroll);
         var _loc1_:int = this._scrollUp.y + this._scrollUp.height + this._scrollSlider.height / 2;
         var _loc2_:int = this._scrollTrack.height - this._scrollSlider.height;
         var _loc3_:int = this._scrollUp.width / 2;
         this._scrollSlider.y = _loc1_ + _loc2_;
         this._scrollBounds = new Rectangle(_loc3_,_loc1_,0,_loc2_);
         this.scrollTo(new MouseEvent("INITIALIZING"));
      }
      
      private function isAllowedChatMessage(param1:String) : Boolean
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         if(this._permissionsManager.canChat)
         {
            return true;
         }
         if(null != this._cannedChatCategories)
         {
            for each(_loc2_ in this._cannedChatCategories)
            {
               for each(_loc3_ in _loc2_)
               {
                  for each(_loc4_ in _loc3_)
                  {
                     if(StringUtil.trim(_loc4_) == StringUtil.trim(param1))
                     {
                        return true;
                     }
                  }
               }
            }
         }
         return false;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function handleAvatarSpinnerClose() : void
      {
         if(null != this._toScrollLater)
         {
            this._toScrollLater();
         }
         this._toScrollLater = null;
      }
      
      public function set scrollBarHeight(param1:Number) : void
      {
         this._scrollTrack.height = param1 - this._scrollUp.height - this._scrollDown.height;
         this._scrollDown.y = param1;
      }
      
      private function addPublicChatMesssage(param1:String, param2:String, param3:int, param4:int) : void
      {
         var _loc5_:ChatMessage = this.createChatMessage(param1,param2,param3,param4);
         this._publicChatMessageManager.addMessage(_loc5_);
         this.createTween(this._publicChatMessageManager.container,_loc5_);
      }
      
      public function set chatHeaderMode(param1:String) : void
      {
         this._chatPanel.chatHeader.mode = param1;
      }
      
      public function removeChatPanelClickedHandler(param1:IChatPanelClickedHandler) : void
      {
         delete this._handlers[IChatPanelClickedHandler][param1];
      }
      
      private function openMessagePanel() : void
      {
         if(this._isOpen)
         {
            return;
         }
         this._isOpen = true;
         this.scrubListeners();
         var _loc1_:Number = this._chatMode == STANDARD ? CHAT_CONTAINER_DEFAULT_HEIGHT : CHAT_CONTAINER_BATTLE_HEIGHT;
         this.scrollBarHeight = _loc1_;
         this._chatPanel.chatMessageContainerMask.y = -_loc1_;
         Tweener.addTween(this._chatPanel.scrollBarContainer,{
            "y":-1 * _loc1_,
            "time":0.5
         });
         Tweener.addTween(this._chatPanel.chatHeader,{
            "y":-1 * _loc1_,
            "time":0.5
         });
         DisplayObjectContainer(this._chatPanel.chatHeader.instructions).addChild(this._headerSpinner);
         this._chatPanel.chatHeader.instructions.visible = true;
         Tweener.addTween(this._chatPanel.chatHeader.instructions,{
            "_autoAlpha":1,
            "time":0.5
         });
         Tweener.addTween(this._chatPanel.chatBG,{
            "y":-1 * _loc1_,
            "time":0.5,
            "onComplete":this.initializeScrollbar
         });
         this.handlePanelOpened();
      }
      
      public function set alpha(param1:Number) : void
      {
         this._chatPanel.alpha = param1;
      }
      
      public function doNothing(... rest) : void
      {
      }
      
      public function handleChatInvitationResponse(param1:String, param2:String, param3:Boolean, param4:int, param5:int) : void
      {
         if(param3)
         {
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Chat Invitation Accepted","User " + param2.toUpperCase() + " has accepted your invitation to private chat.");
         }
         else
         {
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Chat Invitation Rejected","User " + param2.toUpperCase() + " has rejected your invitation to private chat.");
         }
      }
      
      private function createTween(param1:DisplayObjectContainer, param2:ChatMessage) : void
      {
         var newPos:int = 0;
         var chatMessageContainer:DisplayObjectContainer = param1;
         var chatMessage:ChatMessage = param2;
         newPos = -chatMessageContainer.height;
         if(this.canAutoScroll())
         {
            Tweener.addTween(chatMessageContainer,{
               "y":newPos,
               "time":0.75,
               "transition":"easeOutQuad"
            });
         }
         else
         {
            this._toScrollLater = function():void
            {
               Tweener.addTween(chatMessageContainer,{
                  "y":newPos,
                  "time":0.75,
                  "transition":"easeOutQuad"
               });
            };
         }
      }
      
      private function scrubListeners() : void
      {
         this._scrollSlider.removeEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._scrollUp.removeEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._scrollDown.removeEventListener(MouseEvent.MOUSE_DOWN,this.beginScroll);
         this._stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.beginScroll);
      }
      
      private function getActiveChatMessageContainer() : DisplayObjectContainer
      {
         return this.getActiveChatMessageManager().container;
      }
      
      private function beginScroll(param1:MouseEvent) : void
      {
         if(this.getActiveChatMessageContainer().height < this._chatPanel.chatMessageContainerMask.height)
         {
            return;
         }
         if(param1.type == MouseEvent.MOUSE_WHEEL)
         {
            if(this._scrollSlider.y - param1.delta <= this._scrollBounds.bottom && this._scrollSlider.y - param1.delta >= this._scrollBounds.top)
            {
               this._scrollSlider.y -= param1.delta;
               this.scrollTo(param1);
            }
            return;
         }
         this._stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         this._scrollSlider.addEventListener(Event.ENTER_FRAME,this.scrollTo);
         if(param1.currentTarget == this._scrollSlider)
         {
            this._scrollSlider.startDrag(true,this._scrollBounds);
         }
         else
         {
            this._scrollDirection = param1.currentTarget.name == "mcUp" ? "up" : "down";
            this._scrollTimer.start();
         }
      }
      
      private function addPrivateChatMesssage(param1:String, param2:String, param3:int, param4:int) : void
      {
         this.log("addPrivateChatMessage(): sendingPlayer: " + param1 + ", messageText: " + param2 + ", avatarId: " + param3);
         var _loc5_:ChatMessage = this.createChatMessage(param1,param2,param3,param4);
         this._privateChatMessageManager.addMessage(_loc5_);
         this.handlePrivateMessageAdded();
         this.createTween(this._privateChatMessageManager.container,_loc5_);
      }
      
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:DisplayObject = this._chatPanel as DisplayObject;
         if(param1)
         {
            this._chatPanelParent.addChildAt(_loc2_,0);
            this._chatPanelParent.addChildAt(this._friendsPanel,0);
         }
         else if(null != _loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      public function handleSelectedChatRoomChangedHandler(param1:ChatRoomType) : void
      {
         this.log("<<ChatPanelView>> handleSelectedChatRoomChangedHandler(): chatRoomType: " + param1);
         this._scrollSlider.y = this._scrollBounds.bottom;
         this.scrollTo(new MouseEvent(""));
      }
      
      public function addChatPanelClickedHandler(param1:IChatPanelClickedHandler) : void
      {
         this._handlers[IChatPanelClickedHandler][param1] = param1;
      }
      
      private function createChatMessage(param1:String, param2:String, param3:int, param4:int) : ChatMessage
      {
         var _loc5_:ChatMessage = new ChatMessage();
         _loc5_.tfPlayerName.text = param1.toUpperCase();
         _loc5_.tfMessage.text = param2;
         _loc5_.loadAvatarPicture(new AvatarLoaderProvider(),param3);
         _loc5_.nmp = param4;
         return _loc5_;
      }
      
      private function createHandlersDictionary() : void
      {
         this._handlers = new Dictionary();
         this._handlers[IChatPanelStateHandler] = new Dictionary(true);
         this._handlers[IChatPanelClickedHandler] = new Dictionary(true);
      }
   }
}

