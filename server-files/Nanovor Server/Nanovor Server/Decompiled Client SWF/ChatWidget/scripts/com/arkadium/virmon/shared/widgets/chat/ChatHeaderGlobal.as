package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.communications.handlers.battle.IBattleCreatedHandler;
   import com.arkadium.communications.handlers.battle.IBattlePlayerKickedOutHandler;
   import com.arkadium.communications.handlers.battle.IBattleStartedHandler;
   import com.arkadium.communications.handlers.battle.IPlayerJoinBattleHandler;
   import com.arkadium.communications.handlers.battle.IQuittingGameHandler;
   import com.arkadium.communications.handlers.chat.ChatRoomType;
   import com.arkadium.communications.handlers.chat.IChatRoomCreatedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomDestroyedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomJoinedHandler;
   import com.arkadium.communications.handlers.chat.IChatRoomListResponseHandler;
   import com.arkadium.communications.handlers.chat.IExitingChatRoomHandler;
   import com.arkadium.communications.handlers.chat.IUserRemovedFromChatRoomHandler;
   import com.arkadium.communications.handlers.trade.IQuittingTradeHandler;
   import com.arkadium.communications.handlers.trade.ITradeOverHandler;
   import com.arkadium.communications.handlers.trade.ITradeStartedHandler;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.widgets.chat.chatheadertab.ChatHeaderTab;
   import com.arkadium.virmon.shared.widgets.chat.chatheadertab.ChatHeaderTabWithDropDown;
   import com.arkadium.virmon.shared.widgets.chat.chatheadertab.IChatHeaderTabDropDownEntryClickHandler;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol68")]
   public class ChatHeaderGlobal extends Sprite implements IChatHeaderGlobal, ITradeStartedHandler, IQuittingTradeHandler, ITradeOverHandler, IExitingChatRoomHandler, IUserRemovedFromChatRoomHandler, IQuittingGameHandler, IBattleStartedHandler, IBattleCreatedHandler, IPlayerJoinBattleHandler, IBattlePlayerKickedOutHandler, IChatRoomDestroyedHandler, IChatRoomCreatedHandler, IChatRoomJoinedHandler, IChatRoomListResponseHandler, IChatHeaderTabDropDownEntryClickHandler
   {
      
      public static const MODE_PRIVATE:String = "private";
      
      public static const MODE_LOBBY:String = "lobby";
      
      private static const SLIDER_LOBBY:Number = 331;
      
      private static const SLIDER_PRIVATE:Number = 156;
      
      private var _privateChatMessageManager:ChatMessageManager;
      
      public var mcPrivate:ChatHeaderTab;
      
      private var _battleGameService:IBattleGameService;
      
      public var mcPublic:ChatHeaderTabWithDropDown;
      
      private var _chatRoomNameToCountDictionary:Dictionary;
      
      private var _chatGameService:IChatGameService;
      
      private var _publicChatMessageManager:ChatMessageManager;
      
      private var _handlers:Dictionary;
      
      private var _tradeGameService:ITradeGameService;
      
      public var mcInstructions:MovieClip;
      
      private var _currentMode:String;
      
      public function ChatHeaderGlobal()
      {
         super();
         this.createHandlersDictionary();
         this._chatRoomNameToCountDictionary = new Dictionary();
         this._chatGameService = GameServiceProvider.getInstance().chatGameService;
         this._chatGameService.addChatRoomJoinedHandler(IChatRoomJoinedHandler(this));
         this._chatGameService.addChatRoomListResponseHandler(IChatRoomListResponseHandler(this));
         this._chatGameService.addChatRoomDestroyedHandler(IChatRoomDestroyedHandler(this));
         this._chatGameService.addUserRemovedFromChatRoomHandler(IUserRemovedFromChatRoomHandler(this));
         this._chatGameService.addChatRoomCreatedHandler(IChatRoomCreatedHandler(this));
         this._chatGameService.addExitingChatRoomHandler(IExitingChatRoomHandler(this));
         this._chatGameService.getChatRoomList();
         this._battleGameService = GameServiceProvider.getInstance().battleGameService;
         this._battleGameService.addBattlePlayerKickedOutHandler(IBattlePlayerKickedOutHandler(this));
         this._battleGameService.addBattleCreatedHandler(IBattleCreatedHandler(this));
         this._battleGameService.addBattleStartedHandler(IBattleStartedHandler(this));
         this._battleGameService.addPlayerJoinBattleHandler(IPlayerJoinBattleHandler(this));
         this._battleGameService.addQuittingGameHandler(IQuittingGameHandler(this));
         this._tradeGameService = GameServiceProvider.getInstance().tradeGameService;
         this._tradeGameService.addQuittingTradeHandler(IQuittingTradeHandler(this));
         this._tradeGameService.addTradeOverHandler(ITradeOverHandler(this));
         this._tradeGameService.addTradeStartedHandler(ITradeStartedHandler(this));
         this.mcPrivate.close();
         this.mcPrivate.addEventListener(MouseEvent.CLICK,this.onPrivateClick);
         this.mcPublic.addEventListener(MouseEvent.CLICK,this.onPublicClick);
         this.mode = MODE_LOBBY;
      }
      
      public function set privateChatMessageManager(param1:ChatMessageManager) : void
      {
         if(null == param1)
         {
            throw new Error("<<ChatHeaderGlobal>> set_privateChatMessageManager(): Parameter \"value\" was null.");
         }
         this._privateChatMessageManager = param1;
      }
      
      public function handleUserRemovedFromChatRoom(param1:String, param2:String) : void
      {
         if(UserProfile.getInstance().screenname.toLowerCase() != param2.toLowerCase())
         {
            return;
         }
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleUserRemovedFromChatRoom(): hiding private chat tab...");
         this.hidePrivateChat();
      }
      
      public function handlePlayerJoinBattle(param1:Object = null) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handlePlayerJoinBattle(): showing private chat tab...");
         this.mode = ChatHeaderGlobal.MODE_PRIVATE;
         this._privateChatMessageManager.clear();
      }
      
      public function handleQuttingTrade() : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleQuttingTrade(): hiding private chat tab...");
         this.hidePrivateChat();
      }
      
      public function disableMouse() : void
      {
         this.mcPrivate.mouseEnabled = false;
         this.mcPrivate.mouseChildren = false;
         this.mcPublic.locked = true;
      }
      
      public function handleQuittingGame() : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleQuittingGame(): hiding private chat tab...");
         this.hidePrivateChat();
      }
      
      public function get mode() : String
      {
         return this._currentMode;
      }
      
      public function get instructions() : MovieClip
      {
         return this.mcInstructions;
      }
      
      public function handleTradeOver(param1:Object = null) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleTradeOver(): hiding private chat tab...");
         this.hidePrivateChat();
      }
      
      public function addSelectedChatRoomChangedHandler(param1:ISelectedChatRoomChangedHandler) : void
      {
         this._handlers[ISelectedChatRoomChangedHandler][param1] = param1;
      }
      
      public function handleExitingChatRoom() : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleExitingChatRoom(): hiding private chat tab...");
         this.hidePrivateChat();
      }
      
      public function handleBattlePlayerKickedOut(param1:Object = null) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleBattlePlayerKickedOut(): hiding private chat tab...");
         this.hidePrivateChat();
      }
      
      public function setPublicTitle(param1:String) : void
      {
         this.mcPublic.text = param1;
      }
      
      public function handleChatRoomListResponse(param1:String, param2:String) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleChatRoomListResponse(): chatRoomList: " + param1 + ", chatRoomCountList: " + param2);
         var _loc3_:Array = param1.split(",");
         var _loc4_:Array = param2.split(",");
         this.mcPublic.clearAllEntries();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_.length)
         {
            this._chatRoomNameToCountDictionary[String(_loc3_[_loc5_]).toLowerCase()] = _loc4_[_loc5_];
            this.mcPublic.addDropDownEntry(_loc3_[_loc5_] + " (" + _loc4_[_loc5_] + ")",IChatHeaderTabDropDownEntryClickHandler(this));
            _loc5_++;
         }
         this.mcPublic.refreshScrollBar();
         this.mcPublic.text = this._chatGameService.publicChatRoomName + " (" + this._chatRoomNameToCountDictionary[this._chatGameService.publicChatRoomName.toLowerCase()] + ")";
      }
      
      public function hidePublicChat() : void
      {
         this.mcPublic.visible = false;
      }
      
      public function handleChatRoomJoined(param1:String) : void
      {
         var _loc2_:ISelectedChatRoomChangedHandler = null;
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleChatRoomJoined(): " + param1);
         for each(_loc2_ in this._handlers[ISelectedChatRoomChangedHandler])
         {
            _loc2_.handleSelectedChatRoomChangedHandler(ChatRoomType.PUBLIC);
         }
         this.mcPublic.text = param1 + " (" + this._chatRoomNameToCountDictionary[param1.toLowerCase()] + ")";
         if(this._currentMode != MODE_LOBBY)
         {
            this.mode = MODE_LOBBY;
         }
         this._publicChatMessageManager.clear();
         this._chatGameService.getChatRoomList();
      }
      
      public function handleTradeStarted(param1:Object = null) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleTradeStarted(): showing private chat tab...");
         this.mode = ChatHeaderGlobal.MODE_PRIVATE;
         this._privateChatMessageManager.clear();
      }
      
      private function onPublicClick(param1:MouseEvent) : void
      {
         var _loc3_:ISelectedChatRoomChangedHandler = null;
         if(this.mcPublic.isDropDownClosed())
         {
            this._chatGameService.getChatRoomList();
         }
         var _loc2_:String = this.mode;
         this.mode = MODE_LOBBY;
         if(this.mode != _loc2_)
         {
            for each(_loc3_ in this._handlers[ISelectedChatRoomChangedHandler])
            {
               _loc3_.handleSelectedChatRoomChangedHandler(ChatRoomType.PUBLIC);
            }
         }
      }
      
      public function removeSelectedChatRoomChangedHandler(param1:ISelectedChatRoomChangedHandler) : void
      {
         delete this._handlers[ISelectedChatRoomChangedHandler][param1];
      }
      
      private function onPrivateClick(param1:MouseEvent) : void
      {
         var _loc3_:ISelectedChatRoomChangedHandler = null;
         if(false == this._chatGameService.isPrivateChatRoomActive())
         {
            return;
         }
         var _loc2_:String = this.mode;
         this.mode = MODE_PRIVATE;
         if(_loc2_ != this.mode)
         {
            for each(_loc3_ in this._handlers[ISelectedChatRoomChangedHandler])
            {
               _loc3_.handleSelectedChatRoomChangedHandler(ChatRoomType.PRIVATE);
            }
         }
      }
      
      public function handleChatRoomCreated(param1:String) : void
      {
         DebugLog.instance.log("<<ChatPanel>> handleChatRoomCreated(): " + param1);
         this.mode = ChatHeaderGlobal.MODE_PRIVATE;
         this._privateChatMessageManager.clear();
      }
      
      public function set publicChatMessageManager(param1:ChatMessageManager) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> set publicChatMessageManager()");
         if(null == param1)
         {
            throw new Error("<<ChatHeaderGlobal>> set publicChatMessageManager(): Parameter \"value\" was null.");
         }
         this._publicChatMessageManager = param1;
      }
      
      public function handleChatRoomDestroyed(param1:Object) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleChatRoomDestroyed(): hiding private chat tab...");
         this.hidePrivateChat();
      }
      
      private function hidePrivateChat() : void
      {
         this.mcPrivate.close();
         this.mode = MODE_LOBBY;
         if(null != this._chatGameService.publicChatRoomName)
         {
            this.mcPublic.text = this._chatGameService.publicChatRoomName + " (" + this._chatRoomNameToCountDictionary[this._chatGameService.publicChatRoomName.toLowerCase()] + ")";
         }
         this._chatGameService.setPublicChatRoomActive();
         this._privateChatMessageManager.clear();
      }
      
      public function set mode(param1:String) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> set_mode(): " + param1);
         switch(param1)
         {
            case MODE_PRIVATE:
               this.setChildIndex(this.mcPublic,this.numChildren - 1);
               this.setChildIndex(this.mcPrivate,this.numChildren - 1);
               this.mcPrivate.open();
               this._currentMode = MODE_PRIVATE;
               this.showActiveMessageContainer(ChatRoomType.PRIVATE);
               if(null != this._chatGameService.privateChatRoomName)
               {
                  this._chatGameService.setPrivateChatRoomActive();
               }
               break;
            case MODE_LOBBY:
               this.setChildIndex(this.mcPrivate,this.numChildren - 1);
               this.setChildIndex(this.mcPublic,this.numChildren - 1);
               this._currentMode = MODE_LOBBY;
               this.showActiveMessageContainer(ChatRoomType.PUBLIC);
               this._chatGameService.setPublicChatRoomActive();
         }
      }
      
      private function showActiveMessageContainer(param1:ChatRoomType) : void
      {
         var targetPublicChatAlpha:Number;
         var targetPrivateChatAlpha:Number;
         var chatRoomTypeToActivate:ChatRoomType = param1;
         if(null == this._privateChatMessageManager)
         {
            return;
         }
         if(null == this._publicChatMessageManager)
         {
            return;
         }
         this._privateChatMessageManager.container.visible = true;
         targetPrivateChatAlpha = Boolean(ChatRoomType.PRIVATE == chatRoomTypeToActivate) ? 1 : 0;
         Tweener.addTween(this._privateChatMessageManager.container,{
            "time":0.5,
            "transition":"linear",
            "alpha":targetPrivateChatAlpha,
            "onComplete":function():void
            {
               _privateChatMessageManager.container.visible = Boolean(ChatRoomType.PRIVATE == chatRoomTypeToActivate);
            }
         });
         this._publicChatMessageManager.container.visible = true;
         targetPublicChatAlpha = Boolean(ChatRoomType.PUBLIC == chatRoomTypeToActivate) ? 1 : 0;
         Tweener.addTween(this._publicChatMessageManager.container,{
            "time":0.5,
            "transition":"linear",
            "alpha":targetPublicChatAlpha,
            "onComplete":function():void
            {
               _publicChatMessageManager.container.visible = Boolean(ChatRoomType.PUBLIC == chatRoomTypeToActivate);
            }
         });
         this._publicChatMessageManager.container.y = -this._publicChatMessageManager.container.height;
      }
      
      public function handleBattleCreated(param1:Object = null) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleBattleCreated(): showing private chat tab...");
         this.mode = ChatHeaderGlobal.MODE_PRIVATE;
         this._privateChatMessageManager.clear();
      }
      
      public function enableMouse() : void
      {
         this.mcPrivate.mouseEnabled = true;
         this.mcPrivate.mouseChildren = true;
         this.mcPublic.mouseEnabled = true;
         this.mcPublic.mouseChildren = true;
         this.mcPublic.locked = false;
      }
      
      public function handleBattleStarted(param1:Object = null) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>> handleBattleStarted(): showing private chat tab...");
         this.mode = ChatHeaderGlobal.MODE_PRIVATE;
         this._privateChatMessageManager.clear();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<ChatHeaderGlobal>>:\t" + param1);
      }
      
      public function handleChatHeaderDropDownEntryClick(param1:String) : void
      {
         this.log("Joining chat room " + param1);
         if(this._chatGameService.publicChatRoomName == param1)
         {
            return;
         }
         this._chatGameService.joinChatRoom(param1);
         Managers.analyticsManager.trackAction(Action.createDynamic(Action.HOME_SWITCH_LOBBY.name.replace("%NAME%",param1)));
      }
      
      public function showPublicChat() : void
      {
         this.mcPublic.visible = true;
      }
      
      private function createHandlersDictionary() : void
      {
         this._handlers = new Dictionary();
         this._handlers[ISelectedChatRoomChangedHandler] = new Dictionary(true);
      }
   }
}

