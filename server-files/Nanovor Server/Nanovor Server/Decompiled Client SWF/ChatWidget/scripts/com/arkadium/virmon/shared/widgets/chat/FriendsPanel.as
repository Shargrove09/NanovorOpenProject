package com.arkadium.virmon.shared.widgets.chat
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.handlers.user.IBuddyAvatarDataHandler;
   import com.arkadium.virmon.avatar.AvatarSpinnerStateType;
   import com.arkadium.virmon.avatar.IAvatarSpinnerConsumer;
   import com.arkadium.virmon.avatar.IAvatarSpinnerProvider;
   import com.arkadium.virmon.avatar.IAvatarSpinnerState;
   import com.arkadium.virmon.framework.BuddyManager;
   import com.arkadium.virmon.framework.BuddyRPManager;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.framework.IBuddyManager;
   import com.arkadium.virmon.framework.IBuddyRPManager;
   import com.arkadium.virmon.framework.events.BuddyEvent;
   import com.arkadium.virmon.framework.events.BuddyListEvent;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.widgets.AbstractWidget;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol119")]
   public class FriendsPanel extends Sprite implements IAvatarSpinnerConsumer, IBuddyAvatarDataHandler
   {
      
      private static const DEFAULT_ENTER_FRIEND_TEXT:String = "Enter Friend\'s Name";
      
      private static const TAB_FRIENDS:String = "FRIENDS";
      
      private static const TAB_LAST_BATTLED:String = "LAST BATTLED";
      
      private static const TAB_FRIENDS_PENDING:String = "FRIENDS PENDING";
      
      private static const TABS:Array = [TAB_FRIENDS,TAB_LAST_BATTLED];
      
      private static const REFRESH_PLAYER_TILES_DELAY:Number = 3000;
      
      private static const TABS_NUM_FRIENDS:Array = [40,10,6];
      
      private static const NUM_COLUMNS:int = 4;
      
      private static const PLAYER_TILE_PADDING:Number = 4;
      
      public var mcFriendsMenuContainer:MovieClip;
      
      private var _scrollBar:PanelScrollBar;
      
      private var _avatarSpinnerState:IAvatarSpinnerState;
      
      private var _currentPlayerTiles:Array = new Array();
      
      private var _initialized:Boolean = false;
      
      private var _currentMenuTab:FriendsMenuTab;
      
      private var _tabTitle:TabTitle;
      
      private var _buddyRPManager:IBuddyRPManager;
      
      public var mcAddFriend:MovieClip;
      
      private var _hasPlayerTilesChanged:Boolean;
      
      public var mcContentArea:MovieClip;
      
      private var _playersList:Dictionary = new Dictionary(false);
      
      public var mcContentAreaMask:MovieClip;
      
      private var _refreshPlayerTilesTimer:Timer;
      
      public var mcInstructions:MovieClip;
      
      private var _menuTabs:Array;
      
      private var _buddyManager:IBuddyManager;
      
      private var _friendInputField:TextField;
      
      private var _addFriendButton:SimpleButton;
      
      private var _parentWidget:AbstractWidget;
      
      private var _numTiles:int;
      
      public function FriendsPanel()
      {
         super();
         GameServiceProvider.getInstance().userGameService.addBuddyAvatarDataHandler(IBuddyAvatarDataHandler(this));
         this._buddyManager = BuddyManager.getInstance();
         this._buddyRPManager = BuddyRPManager.getInstance();
         this._buddyManager.addEventListener(BuddyListEvent.BUDDY_LIST_RECEIVED,this.handleBuddyListReceived);
         this._buddyRPManager.addEventListener(BuddyListEvent.RP_LIST_RECEIVED,this.handleRecentlyPlayedBuddyListReceived);
         this._buddyManager.addEventListener(BuddyEvent.AVATAR_CHANGE,this.handleAvatarChange);
         this._buddyManager.addEventListener(BuddyEvent.CHAT_STATUS_CHANGE,this.handleChatStatusChange);
         this._buddyManager.addEventListener(BuddyEvent.ADD,this.onFriendAdded);
         this._buddyManager.addEventListener(BuddyEvent.REMOVE_RECEIVED,this.onFriendRemoved);
         this._buddyManager.addEventListener(BuddyEvent.REMOVE_SENT_RECEIVED,this.onFriendRemoved);
         this._friendInputField = this.mcAddFriend.tfInput;
         this._addFriendButton = this.mcAddFriend.btnAddFriend;
         this._friendInputField.maxChars = 17;
         this._friendInputField.text = DEFAULT_ENTER_FRIEND_TEXT;
         this._friendInputField.addEventListener(FocusEvent.FOCUS_IN,this.onFriendInputFieldFocusIn);
         this._friendInputField.addEventListener(FocusEvent.FOCUS_OUT,this.onFriendInputFieldFocusOut);
         this._addFriendButton.addEventListener(MouseEvent.CLICK,this.addFriend);
         this.mcAddFriend.alpha = 0;
         this.mcAddFriend.visible = false;
         this.mcAddFriend.mouseEnabled = false;
         this.mcAddFriend.mouseChildren = false;
         this.mcContentArea.mouseEnabled = false;
         this.mcInstructions.alpha = 0;
         this._menuTabs = new Array();
         this.createMenuTabs();
         this._scrollBar = new PanelScrollBar(this.mcContentArea,this.mcContentAreaMask);
         this._scrollBar.height = 420;
         this._scrollBar.x = 352;
         this._scrollBar.y = 171;
         this.addChild(this._scrollBar);
         this._tabTitle = new TabTitle(TAB_FRIENDS);
         this._tabTitle.y = 100;
         this.addChild(this._tabTitle);
         this._currentMenuTab = this.mcFriendsMenuContainer.getChildAt(0) as FriendsMenuTab;
         this.refreshSelectedTab(this._currentMenuTab);
         this._refreshPlayerTilesTimer = new Timer(REFRESH_PLAYER_TILES_DELAY);
         this._refreshPlayerTilesTimer.addEventListener(TimerEvent.TIMER,this.handleRefreshPlayerTilesTimer);
         this.hideFields();
         this.mcInstructions.mcSpinner.stop();
         this.mcInstructions.mcSpinner.visible = false;
      }
      
      private function handleChatStatusChange(param1:BuddyEvent) : void
      {
         this.log("handleChatStatusChange -> " + param1.buddyData.UserId + ", Status: " + param1.buddyData.Status);
         var _loc2_:Array = this.getTilesByPlayerId(param1.buddyData.UserId);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            PlayerTile(_loc2_[_loc3_]).mode = PlayerTile.MODES[param1.buddyData.Status + 1];
            PlayerTile(_loc2_[_loc3_]).sortStatus = param1.buddyData.SortStatus;
            _loc3_++;
         }
         this.sortPlayerTiles();
         this._hasPlayerTilesChanged = true;
      }
      
      public function getTilesByPlayerId(param1:int) : Array
      {
         var _loc4_:uint = 0;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < TABS.length)
         {
            if(Boolean(this._playersList[TABS[_loc3_]]))
            {
               _loc4_ = 0;
               while(_loc4_ < this._playersList[TABS[_loc3_]].length)
               {
                  if(PlayerTile(this._playersList[TABS[_loc3_]][_loc4_]).playerId == param1)
                  {
                     _loc2_.push(this._playersList[TABS[_loc3_]][_loc4_]);
                  }
                  _loc4_++;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function enable() : void
      {
         this._refreshPlayerTilesTimer.start();
         visible = true;
         this.mcInstructions.mcSpinner.play();
         this.mcInstructions.mcSpinner.visible = false;
      }
      
      private function sortBuddyList(param1:Array) : void
      {
         param1.sortOn("SortStatus",Array.NUMERIC);
      }
      
      private function onFriendInputFieldFocusOut(param1:FocusEvent) : void
      {
         this._friendInputField.removeEventListener(KeyboardEvent.KEY_DOWN,this.onFriendInputFieldKeyDown);
         if(this._friendInputField.text == "")
         {
            this._friendInputField.text = DEFAULT_ENTER_FRIEND_TEXT;
         }
      }
      
      public function showFields() : void
      {
         if(null == this._tabTitle)
         {
            return;
         }
         this._tabTitle.showTabTemplateFields();
         this._currentMenuTab.active = true;
         this.showAddFriends(TAB_FRIENDS.toUpperCase() == this._currentMenuTab.name.toUpperCase());
         this.mcContentArea.mouseChildren = true;
         Tweener.addTween(this.mcContentArea,{
            "_autoAlpha":1,
            "time":0.5
         });
      }
      
      public function init() : void
      {
         if(this._initialized)
         {
            return;
         }
         this._buddyManager.sendBuddyListRequest();
         this._buddyRPManager.sendRPListRequest();
         this._initialized = true;
         this._refreshPlayerTilesTimer.start();
      }
      
      private function showAddFriends(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(this.mcAddFriend,{
               "_autoAlpha":1,
               "time":1
            });
            Tweener.addTween(this.mcInstructions,{
               "_autoAlpha":1,
               "time":1
            });
            this.mcAddFriend.mouseEnabled = true;
            this.mcAddFriend.mouseChildren = true;
         }
         else
         {
            Tweener.addTween(this.mcAddFriend,{
               "_autoAlpha":0,
               "time":1
            });
            this.mcAddFriend.mouseEnabled = false;
            this.mcAddFriend.mouseChildren = false;
         }
      }
      
      private function createMenuTabs() : void
      {
         var _loc2_:FriendsMenuTab = null;
         var _loc3_:String = null;
         var _loc1_:Number = 0;
         for each(_loc3_ in TABS)
         {
            if(_loc1_ == 0)
            {
               _loc2_ = new FriendsMenuTab(_loc3_,14);
            }
            else
            {
               _loc2_ = new FriendsMenuTab(_loc3_);
            }
            _loc2_.x = _loc1_;
            _loc1_ += _loc2_.width - FriendsMenuTab.PADDING - 1;
            this.mcFriendsMenuContainer.addChild(_loc2_);
            _loc2_.name = _loc3_;
            _loc2_.addEventListener(MouseEvent.CLICK,this.onTabClick);
            this._menuTabs.push(_loc2_);
         }
      }
      
      public function hideFields() : void
      {
         if(null == this._tabTitle)
         {
            return;
         }
         this._tabTitle.hideTabTemplateFields();
         this._currentMenuTab.active = false;
         this.showAddFriends(false);
         this.mcContentArea.mouseChildren = false;
         Tweener.addTween(this.mcContentArea,{
            "_autoAlpha":0,
            "time":0.5
         });
      }
      
      public function get friendMenu() : MovieClip
      {
         return this.mcFriendsMenuContainer;
      }
      
      private function addFriend(param1:MouseEvent = null) : void
      {
         var _loc2_:String = this._friendInputField.text;
         this._friendInputField.text = "";
         if(null == _loc2_ || _loc2_.length == 0 || _loc2_ == DEFAULT_ENTER_FRIEND_TEXT)
         {
            this.log("addFriend(): friendName was null or empty: " + _loc2_);
         }
         else
         {
            BuddyManager.getInstance().requestAddBuddy(_loc2_);
         }
      }
      
      public function set parentWidget(param1:AbstractWidget) : void
      {
         this._parentWidget = param1;
      }
      
      public function logError(param1:String) : void
      {
         DebugLog.instance.error("<<FriendsPanel>>ERROR: -->\t" + param1);
      }
      
      private function sortPlayerTiles() : void
      {
         var tabName:String = null;
         var nextPlayerList:Array = null;
         for each(tabName in TABS)
         {
            nextPlayerList = this._playersList[tabName];
            if(null != nextPlayerList)
            {
               nextPlayerList.sort(function(param1:PlayerTile, param2:PlayerTile):int
               {
                  if(param1.sortStatus < param2.sortStatus)
                  {
                     return -1;
                  }
                  if(param1.sortStatus > param2.sortStatus)
                  {
                     return 1;
                  }
                  return 0;
               });
            }
         }
      }
      
      private function refreshSelectedTab(param1:FriendsMenuTab) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this._currentMenuTab != null)
         {
            this._currentMenuTab.active = false;
         }
         this._currentMenuTab = param1 as FriendsMenuTab;
         this._currentMenuTab.active = true;
         this._tabTitle.text = param1.name;
         this.showAddFriends(TAB_FRIENDS.toUpperCase() == param1.name.toUpperCase());
         this.renderPlayerTiles(param1.name);
      }
      
      private function onFriendAdded(param1:BuddyEvent) : void
      {
         var _loc2_:Array = BuddyManager.getInstance().getList();
         this.populateTab(_loc2_,TAB_FRIENDS);
      }
      
      private function handleRefreshPlayerTilesTimer(param1:TimerEvent) : void
      {
         if(false == this._hasPlayerTilesChanged)
         {
            return;
         }
         if(null == this._avatarSpinnerState)
         {
            return;
         }
         if(AvatarSpinnerStateType.ACTIVE == this._avatarSpinnerState.state)
         {
            return;
         }
         this._hasPlayerTilesChanged = false;
         this.renderPlayerTiles(this._currentMenuTab.name);
      }
      
      private function renderPlayerTiles(param1:String) : void
      {
         var _loc3_:PlayerTile = null;
         this.clearContent();
         var _loc2_:Array = this._playersList[param1];
         this._currentPlayerTiles = _loc2_;
         if(_loc2_ == null || _loc2_.length == 0)
         {
            return;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            _loc3_.alpha = 0;
            _loc3_.visible = true;
            Tweener.addTween(_loc3_,{
               "_autoAlpha":1,
               "time":0.5
            });
            _loc3_.x = PLAYER_TILE_PADDING + int(this._numTiles % NUM_COLUMNS) * 86;
            _loc3_.y = PLAYER_TILE_PADDING + int(this._numTiles / NUM_COLUMNS) * 116;
            this.mcContentArea.addChildAt(_loc3_,0);
            ++this._numTiles;
            _loc4_++;
         }
         this._scrollBar.refresh();
      }
      
      private function handleAvatarChange(param1:BuddyEvent) : void
      {
         var _loc3_:PlayerTile = null;
         this.log("handleAvatarChange -> " + param1.buddyData);
         var _loc2_:Array = this.getTilesByPlayerId(param1.buddyData.UserId);
         for each(_loc3_ in _loc2_)
         {
            _loc3_.avatarID = param1.buddyData.Avatar;
         }
      }
      
      public function handleBuddyAvatarData(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:PlayerTile = null;
         this.log("handleBuddyAvatarData");
         param1.userRefId;
         param1.avatarId;
         for each(_loc2_ in TABS)
         {
            for each(_loc3_ in this._playersList[_loc2_])
            {
               if(_loc3_.playerId == param1.userRefId)
               {
                  _loc3_.loadAvatarPicture(param1.avatarId);
                  return;
               }
            }
         }
      }
      
      private function onFriendRemoved(param1:BuddyEvent) : void
      {
         var _loc2_:Array = BuddyManager.getInstance().getList();
         this.populateTab(_loc2_,TAB_FRIENDS);
      }
      
      private function disableTile(param1:PlayerTile) : void
      {
         param1.visible = false;
      }
      
      private function populateTab(param1:Array, param2:String = "FRIENDS") : void
      {
         var _loc3_:PlayerTile = null;
         var _loc4_:Array = null;
         var _loc5_:IBuddyData = null;
         var _loc6_:PlayerTile = null;
         this.sortBuddyList(param1);
         _loc4_ = new Array();
         for each(_loc5_ in param1)
         {
            _loc3_ = new PlayerTile();
            _loc3_.playerName = _loc5_.Name;
            _loc3_.avatarID = _loc5_.Avatar;
            _loc3_.playerId = _loc5_.UserId;
            _loc3_.nmp = _loc5_.NMP;
            _loc3_.sortStatus = _loc5_.SortStatus;
            if(param2 != TAB_FRIENDS_PENDING)
            {
               _loc3_.mode = PlayerTile.MODES[_loc5_.Status + 1];
            }
            else
            {
               _loc3_.mode = PlayerTile.MODE_ACCEPT;
            }
            _loc4_.push(_loc3_);
         }
         if(null != this._playersList[param2])
         {
            for each(_loc6_ in this._playersList[param2])
            {
               _loc6_.destroy();
            }
         }
         this._playersList[param2] = _loc4_;
         this.renderPlayerTiles(this._currentMenuTab.name);
      }
      
      public function setAvatarSpinnerProvider(param1:IAvatarSpinnerProvider) : void
      {
         this._avatarSpinnerState = param1.avatarSpinnerState;
      }
      
      private function removePlayerTile(param1:Sprite) : void
      {
         if(this.mcContentArea.contains(param1))
         {
            this.mcContentArea.removeChild(param1);
         }
      }
      
      private function onFriendInputFieldKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.addFriend();
         }
      }
      
      private function handleBuddyListReceived(param1:BuddyListEvent) : void
      {
         this.log("handleBuddyListReceived");
         this.populateTab(param1.Buddylist,TAB_FRIENDS);
      }
      
      private function onFriendInputFieldFocusIn(param1:FocusEvent) : void
      {
         this._friendInputField.addEventListener(KeyboardEvent.KEY_DOWN,this.onFriendInputFieldKeyDown);
         if(this._friendInputField.text == DEFAULT_ENTER_FRIEND_TEXT)
         {
            this._friendInputField.text = "";
         }
      }
      
      public function disable() : void
      {
         this._refreshPlayerTilesTimer.reset();
         visible = false;
         this.mcInstructions.mcSpinner.stop();
         this.mcInstructions.mcSpinner.visible = false;
      }
      
      private function handleRecentlyPlayedBuddyListReceived(param1:BuddyListEvent) : void
      {
         this.log("handleRecentlyPlayedBuddyListReceived");
         this.populateTab(param1.Buddylist,TAB_LAST_BATTLED);
      }
      
      private function clearContent() : void
      {
         var _loc4_:PlayerTile = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc1_:Array = this.getSeparateTilesByVisibility(this._currentPlayerTiles);
         var _loc2_:Array = _loc1_[0];
         var _loc3_:Array = _loc1_[1];
         for each(_loc4_ in _loc3_)
         {
            this.mcContentArea.removeChild(_loc4_);
         }
         _loc3_ = null;
         _loc5_ = (1 - 0.5) / _loc2_.length;
         _loc6_ = 0;
         while(_loc2_.length > 0)
         {
            _loc4_ = _loc2_.splice(int(Math.random() * (_loc2_.length - 1)),1)[0];
            Tweener.addTween(_loc4_,{
               "_autoAlpha":0,
               "time":0.5,
               "delay":_loc6_ * _loc5_,
               "transition":"easeInQuad",
               "onComplete":this.removePlayerTile,
               "onCompleteParams":[_loc4_]
            });
            _loc6_++;
         }
         this._numTiles = 0;
      }
      
      public function log(param1:String) : void
      {
         DebugLog.instance.log("<<FriendsPanel>>\t" + param1);
      }
      
      public function addTabClickHandler(param1:Function) : void
      {
         var _loc2_:FriendsMenuTab = null;
         for each(_loc2_ in this._menuTabs)
         {
            _loc2_.addEventListener(MouseEvent.CLICK,param1);
         }
      }
      
      private function getSeparateTilesByVisibility(param1:Array) : Array
      {
         var _loc2_:PlayerTile = null;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         for each(_loc2_ in param1)
         {
            if(this.mcContentArea.y + _loc2_.y + _loc2_.height < this.mcContentAreaMask.y || this.mcContentArea.y + _loc2_.y > this.mcContentAreaMask.y + this.mcContentAreaMask.height)
            {
               _loc4_.push(_loc2_);
            }
            else
            {
               _loc3_.push(_loc2_);
            }
         }
         return [_loc3_,_loc4_];
      }
      
      private function onTabClick(param1:MouseEvent) : void
      {
         var _loc2_:FriendsMenuTab = param1.currentTarget as FriendsMenuTab;
         this.log("selectedTab: " + _loc2_);
         this.refreshSelectedTab(_loc2_);
         if(_loc2_.name.toUpperCase() == TAB_FRIENDS.toUpperCase())
         {
            Managers.analyticsManager.trackView(View.HOME_FRIENDS);
         }
         else if(_loc2_.name.toUpperCase() == TAB_LAST_BATTLED.toUpperCase())
         {
            Managers.analyticsManager.trackView(View.HOME_LAST_BATTLED);
         }
      }
   }
}

