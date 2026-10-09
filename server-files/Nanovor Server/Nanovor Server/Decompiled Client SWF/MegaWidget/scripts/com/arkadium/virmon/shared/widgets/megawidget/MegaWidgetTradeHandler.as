package com.arkadium.virmon.shared.widgets.megawidget
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.communications.handlers.trade.ICollectionSetHandler;
   import com.arkadium.communications.handlers.trade.ITradeCreationErrorHandler;
   import com.arkadium.communications.handlers.trade.ITradeInvitationAcceptHandler;
   import com.arkadium.communications.handlers.trade.ITradeInvitationResponseHandler;
   import com.arkadium.communications.handlers.trade.ITradeOtherPlayerQuitHandler;
   import com.arkadium.communications.handlers.trade.ITradeOverHandler;
   import com.arkadium.communications.handlers.trade.ITradeQuitHandler;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.PermissionsManager;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class MegaWidgetTradeHandler implements ITradeInvitationResponseHandler, ITradeOtherPlayerQuitHandler, ICollectionSetHandler, ITradeCreationErrorHandler, ITradeOverHandler, ITradeQuitHandler, ITradeInvitationAcceptHandler
   {
      
      public static const INVITE_TIMEOUT_SECONDS:int = 30;
      
      private var _tradeGameService:ITradeGameService;
      
      private var _playerEventDialogBox:CommonDialogBox;
      
      private var _invitationDialogBox:CommonDialogBox;
      
      private var _invitedPlayerName:String;
      
      private var _invitedPlayerAvatarId:int;
      
      public function MegaWidgetTradeHandler()
      {
         super();
         _tradeGameService = GameServiceProvider.getInstance().tradeGameService;
         _tradeGameService.addTradeInvitationResponseHandler(ITradeInvitationResponseHandler(this));
         _tradeGameService.addTradeOtherPlayerQuitHandler(ITradeOtherPlayerQuitHandler(this));
         _tradeGameService.addTradeCreationErrorHandler(ITradeCreationErrorHandler(this));
         _tradeGameService.addTradeOverHandler(ITradeOverHandler(this));
         _tradeGameService.addTradeQuitHandler(ITradeQuitHandler(this));
         _tradeGameService.addTradeInivitationAcceptHandler(ITradeInvitationAcceptHandler(this));
      }
      
      public function handleChatRoomJoined(param1:String) : void
      {
         log("handleChatRoomJoined");
      }
      
      public function handleTradeOtherPlayerQuit(param1:Object = null) : void
      {
         log("handleTradeOtherPlayerQuit");
         if(_invitationDialogBox != null)
         {
            _invitationDialogBox.kill();
         }
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Trade Cancelled","Other player left trade");
         resetListeners();
      }
      
      public function handleTradeInvitationAccept(param1:Object) : void
      {
         _tradeGameService.removeCollectionSetHandler(ICollectionSetHandler(this));
         Managers.stateManager.tradeCollectionSetData = null;
         Managers.stateManager.setStateData(StateType.TRADEGAME,param1);
         Managers.stateManager.setState(StateType.TRADEGAME);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<MegaWidgetTradeHandler>>\t" + param1);
      }
      
      public function handleTradeOver(param1:Object = null) : void
      {
         resetListeners();
         _tradeGameService.quitTrade();
      }
      
      public function handleTradeQuit(param1:Object = null) : void
      {
         resetListeners();
      }
      
      public function handleCollectionSet(param1:Object = null) : void
      {
         if(Managers.stateManager.tradeCollectionSetData == null)
         {
            Managers.stateManager.tradeCollectionSetData = new Array();
         }
         Managers.stateManager.tradeCollectionSetData.push(param1);
         if(Managers.stateManager.tradeCollectionSetData.length == 2)
         {
            _tradeGameService.removeCollectionSetHandler(ICollectionSetHandler(this));
         }
      }
      
      public function handleTradeCreationError(param1:Object) : void
      {
         if(_invitationDialogBox != null)
         {
            _invitationDialogBox.kill();
         }
         _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Can\'t Invite to Trade","You are currently in battle and cannot invite players to trade.",INVITE_TIMEOUT_SECONDS);
         resetListeners();
         _tradeGameService.quitTrade();
      }
      
      public function resetListeners() : void
      {
         log("resetListeners (trade)");
         _tradeGameService.addTradeInvitationResponseHandler(ITradeInvitationResponseHandler(this));
      }
      
      public function handleTradeInvitationResponse(param1:Object = null) : void
      {
         log("handleTradeInvitationResponse.  Reponse is type: " + typeof param1.acceptedInvitation);
         if(_invitationDialogBox != null)
         {
            _invitationDialogBox.kill();
         }
         if(Boolean(param1.acceptedInvitation))
         {
            log("ACCEPT");
            param1.avatarId = _invitedPlayerAvatarId;
            param1.inviteeName = _invitedPlayerName;
            Managers.stateManager.setStateData(StateType.TRADEGAME,param1);
            Managers.stateManager.setState(StateType.TRADEGAME);
         }
         else
         {
            log("DECLINE");
            if(param1.replyReason == Const.REPLY_CODE_TIMEOUT)
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Time Out","Your trade request has timed out.");
            }
            else if(param1.replyReason == Const.REPLY_CODE_NOT_ENOUGH_CASH)
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Not Enough Nanocash","Player does not have enough nanocash to trade.");
            }
            else if(param1.replyReason == Const.REPLY_CODE_NO_PERMISSION)
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"No Permission","Player does not have permission to trade.");
            }
            else
            {
               _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Player Declined Trade","Player declined trade");
            }
            _tradeGameService.quitTrade();
         }
      }
      
      public function creatorCancelTrade(param1:String) : void
      {
         log("creatorCancelTrade");
         _tradeGameService.tradeName;
         _tradeGameService.removeCollectionSetHandler(ICollectionSetHandler(this));
         _tradeGameService.cancelTradeInvitation(_tradeGameService.tradeName,UserProfile.getInstance().screenname,UserProfile.getInstance().id.toString(),param1);
      }
      
      public function invitePlayerToTrade(param1:String, param2:int) : void
      {
         if(!PermissionsManager.getInstance().canTrade)
         {
            _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"No Permission","You need permission to trade with another user.",INVITE_TIMEOUT_SECONDS);
            return;
         }
         if(UserProfile.getInstance().nanocash < 4)
         {
            _playerEventDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Not Enough Nanocash","You need at least 4 nanocash to trade.",INVITE_TIMEOUT_SECONDS);
            return;
         }
         _invitedPlayerAvatarId = param2;
         _invitedPlayerName = param1;
         Managers.stateManager.tradeCollectionSetData = new Array();
         _tradeGameService.addCollectionSetHandler(ICollectionSetHandler(this));
         _tradeGameService.inviteUser(param1);
         _invitationDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_WAITING,"WAITING FOR RESPONSE","Your invitation to trade has been sent.\nReminder: Completing a trade costs 4 Nanocash.\nPlease wait for " + param1.toUpperCase() + " to respond.",INVITE_TIMEOUT_SECONDS,creatorCancelTrade,creatorCancelTrade,creatorCancelTrade,creatorCancelTrade,param1);
      }
   }
}

