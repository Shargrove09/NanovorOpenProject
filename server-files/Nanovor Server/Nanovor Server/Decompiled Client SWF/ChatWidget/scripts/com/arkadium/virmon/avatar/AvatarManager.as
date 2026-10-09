package com.arkadium.virmon.avatar
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.framework.BuddyManager;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.avatar.AvatarWidget;
   import com.arkadium.virmon.shared.widgets.megawidget.IMegaWidget;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   
   public class AvatarManager extends EventDispatcher
   {
      
      private static var _instance:AvatarManager;
      
      private var _chatGameService:IChatGameService;
      
      private var _initialized:Boolean = false;
      
      private var _avatarClickHandler:Function;
      
      private var _battleGameService:IBattleGameService;
      
      private var _tradeGameService:ITradeGameService;
      
      public function AvatarManager(param1:Function)
      {
         super();
         if(param1 == null || param1 != SingletonEnforcer)
         {
            throw new Error("AvatarManager singleton exception: cannot instantiate outside of this class");
         }
         this._battleGameService = GameServiceProvider.getInstance().battleGameService;
         this._chatGameService = GameServiceProvider.getInstance().chatGameService;
         this._tradeGameService = GameServiceProvider.getInstance().tradeGameService;
      }
      
      public static function getInstance() : AvatarManager
      {
         if(_instance == null)
         {
            _instance = new AvatarManager(SingletonEnforcer);
         }
         return _instance;
      }
      
      private static function SingletonEnforcer() : void
      {
      }
      
      public function handleTradeButtonClick(param1:AvatarSpinner) : void
      {
         this.closeAvatarSpinner(param1);
         this.log("About to invite user to trade");
         IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).invitePlayerToTrade(param1.playerName,param1.avatarId);
      }
      
      public function handleRemoveFriendButtonClick(param1:AvatarSpinner) : void
      {
         BuddyManager.getInstance().requestRemoveBuddy(param1.playerName);
         this.closeAvatarSpinner(param1);
      }
      
      public function handleIgnoreFriendButtonClick(param1:AvatarSpinner) : void
      {
         this.closeAvatarSpinner(param1);
      }
      
      public function handleAddFriendButtonClick(param1:AvatarSpinner) : void
      {
         BuddyManager.getInstance().requestAddBuddy(param1.playerName);
         this.closeAvatarSpinner(param1);
      }
      
      public function handleAvatarClick(param1:DisplayObject, param2:String, param3:int, param4:int = -1) : void
      {
         if(UserProfile.getInstance().screenname.toLowerCase() == param2.toLowerCase())
         {
            return;
         }
         AvatarWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_AVATAR.name)).openSpinnerAtLocation(param1,param2,param3,param4);
      }
      
      private function closeAvatarSpinner(param1:AvatarSpinner) : void
      {
         var _loc2_:Boolean = param1.close();
         param1.menuMode = AvatarSpinner.MENU_MODE_NONE;
         if(_loc2_)
         {
            AvatarWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_AVATAR.name)).closeActiveSpinnerBlock();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AvatarManager>> " + param1);
      }
      
      public function handleCloseButtonClick(param1:AvatarSpinner) : void
      {
         this.closeAvatarSpinner(param1);
      }
      
      public function handleChatButtonClick(param1:AvatarSpinner) : void
      {
         this.closeAvatarSpinner(param1);
         IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).invitePlayerToChat(param1.playerName,param1.avatarId);
      }
      
      public function init() : void
      {
         if(this._initialized)
         {
            return;
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<AvatarManager>> " + param1);
      }
      
      public function handleBattleButtonClick(param1:AvatarSpinner) : void
      {
         this.closeAvatarSpinner(param1);
         var _loc2_:IBuddyData = BuddyManager.getInstance().getBuddyByName(param1.playerName);
         this.log("Invited player.  Now calling MegaWidget.  Invite to battle communication will be called there.");
         IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).invitePlayerToBattle(param1.playerName,param1.avatarId);
      }
      
      public function handleFriendButtonClick(param1:AvatarSpinner) : void
      {
         BuddyManager.getInstance().requestAddBuddy(param1.playerName);
         this.closeAvatarSpinner(param1);
      }
      
      public function setAvatarClickHandler(param1:Function) : void
      {
         if(param1 == null)
         {
            throw new Error("YOU SUCK");
         }
         this._avatarClickHandler = param1;
      }
   }
}

