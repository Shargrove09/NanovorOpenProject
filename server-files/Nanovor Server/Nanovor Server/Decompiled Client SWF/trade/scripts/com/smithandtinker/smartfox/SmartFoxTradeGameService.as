package com.smithandtinker.smartfox
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IGameServiceInvitationManager;
   import com.arkadium.communications.IGameServiceInvitationManagerConsumer;
   import com.arkadium.communications.ITradeGameService;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.handlers.trade.*;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.PermissionsManager;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import com.smithandtinker.smartfox.enums.TradeState;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.Dictionary;
   import it.gotoandplay.smartfoxserver.SFSEvent;
   
   public class SmartFoxTradeGameService extends AbstractSmartFoxGameService implements ITradeGameService, IGameServiceInvitationManagerConsumer
   {
      
      private static const INVITE_TIMEOUT_SECONDS:int = 30;
      
      private static const EXTENSION_NAME:String = "tradeXt";
      
      private static const MAX_PLAYERS:* = 2;
      
      private var _invitedUsers:Array;
      
      private var _invitee:String;
      
      private var _invitationManager:IGameServiceInvitationManager;
      
      private var _tradeName:String;
      
      public function SmartFoxTradeGameService(param1:IUserProfile, param2:SmartFoxConnection)
      {
         super(param1,param2,EXTENSION_NAME);
         _invitedUsers = new Array();
         registerTradeEventHandlers();
      }
      
      private function onEvent(param1:SFSEvent) : void
      {
         trace("Event: " + param1.type);
      }
      
      public function addCollectionSetHandler(param1:ICollectionSetHandler) : void
      {
         addHandler(ICollectionSetHandler,param1);
      }
      
      public function removeTradeCreationErrorHandler(param1:ITradeCreationErrorHandler) : void
      {
         removeHandler(ITradeCreationErrorHandler,param1);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         debugTrace("Security error: " + param1.text);
      }
      
      public function removeTradeInivitationAcceptHandler(param1:ITradeInvitationAcceptHandler) : void
      {
         removeHandler(ITradeInvitationAcceptHandler,param1);
      }
      
      public function joinAndGetCollections(param1:String) : void
      {
         sendRequestToServer(TradeState.REQUEST_JOIN_AND_GET_COLLECTIONS,{"tradeName":param1});
      }
      
      public function addTradeInivitationAcceptHandler(param1:ITradeInvitationAcceptHandler) : void
      {
         addHandler(ITradeInvitationAcceptHandler,param1);
      }
      
      public function get tradeName() : String
      {
         return _tradeName;
      }
      
      public function removeAddedToCartHandler(param1:IAddedToCartHandler) : void
      {
         removeHandler(IAddedToCartHandler,param1);
      }
      
      public function makeOffer() : void
      {
         sendRequestToServer(TradeState.REQUEST_MAKE_OFFER,{"userRefId":_userProfile.id});
      }
      
      private function systemError(param1:Object) : void
      {
      }
      
      public function removeTradeInvitationRequestHandler(param1:ITradeInvitationRequestHandler) : void
      {
         removeHandler(ITradeInvitationRequestHandler,param1);
      }
      
      public function removeOfferMadeHandler(param1:IOfferMadeHandler) : void
      {
         removeHandler(IOfferMadeHandler,param1);
      }
      
      public function addTradeInvitationRequestHandler(param1:ITradeInvitationRequestHandler) : void
      {
         addHandler(ITradeInvitationRequestHandler,param1);
      }
      
      private function transactionConfirmed(param1:Object) : void
      {
         var _loc3_:ITransactionConfirmedHandler = null;
         var _loc2_:String = param1.code;
         resetTrade();
         for each(_loc3_ in _handlers[ITransactionConfirmedHandler])
         {
            _loc3_.handleTransactionConfirmed({
               "tradeName":_tradeName,
               "code":_loc2_
            });
         }
      }
      
      public function startTrade() : void
      {
         sendRequestToServer(TradeState.REQUEST_START_TRADE,{"tradeName":_tradeName});
      }
      
      private function offerAccepted(param1:Object) : void
      {
         var _loc4_:IOfferAcceptedHandler = null;
         var _loc2_:String = param1.userRefId;
         var _loc3_:String = param1.code;
         for each(_loc4_ in _handlers[IOfferAcceptedHandler])
         {
            _loc4_.handleOfferAccepted({
               "tradeName":_tradeName,
               "userRefId":_loc2_,
               "code":_loc3_
            });
         }
      }
      
      public function removeRemovedFromCartHandler(param1:IRemovedFromCartHandler) : void
      {
         removeHandler(IRemovedFromCartHandler,param1);
      }
      
      private function registerTradeEventHandlers() : void
      {
         _gameServiceConnection.addEventListener(SFSEvent.onExtensionResponse,handleExtensionResponse);
         _gameServiceConnection.addEventListener(SFSEvent.onJoinRoomError,onJoinRoomError);
         _gameServiceConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         _gameServiceConnection.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
      }
      
      public function getBadgeList(param1:String, param2:String) : void
      {
         log("getBadgeList: ownerId=" + param1 + "; nanovorId=" + param2);
         sendRequestToServer(TradeState.REQUEST_GET_BADGE_LIST,{
            "ownerId":param1,
            "nanovorId":param2
         });
      }
      
      public function removeTradeInvitationCanceledHandler(param1:ITradeInvitationCanceledHandler) : void
      {
         removeHandler(ITradeInvitationCanceledHandler,param1);
      }
      
      public function addOfferMadeHandler(param1:IOfferMadeHandler) : void
      {
         addHandler(IOfferMadeHandler,param1);
      }
      
      public function removePlayerJoinTradeHandler(param1:IPlayerJoinTradeHandler) : void
      {
         removeHandler(IPlayerJoinTradeHandler,param1);
      }
      
      public function handleInvitationTimeout(param1:Object) : void
      {
         log("handleInvitationTimeout() - SHAMWOW Timeout");
         replyTradeInvitation(param1.tradeName,false,Const.REPLY_CODE_TIMEOUT);
      }
      
      public function cancelTradeInvitation(param1:String, param2:String, param3:String, param4:String) : void
      {
         resetTrade();
         sendRequestToServer(TradeState.REQUEST_CANCEL_TRADE,{
            "tradeName":param1,
            "inviterName":param2,
            "inviterId":param3,
            "inviteeId":param4
         });
      }
      
      private function onJoinRoomError(param1:SFSEvent) : void
      {
         debugTrace("Problems joining default room. Reason: " + param1.params.error);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("[SMARTFOX TRADE]          " + param1,_userProfile.screenname);
      }
      
      private function otherPlayerJoinTrade(param1:Object) : void
      {
         var _loc5_:IOtherPlayerJoinTradeHandler = null;
         var _loc2_:String = param1.username;
         var _loc3_:String = param1.userRefId;
         var _loc4_:String = param1.avatarId;
         for each(_loc5_ in _handlers[IOtherPlayerJoinTradeHandler])
         {
            _loc5_.handleOtherPlayerJoinTrade({
               "tradeName":_tradeName,
               "userRefId":_loc3_,
               "username":_loc2_,
               "avatarId":_loc4_
            });
         }
      }
      
      public function removeOfferAcceptedHandler(param1:IOfferAcceptedHandler) : void
      {
         removeHandler(IOfferAcceptedHandler,param1);
      }
      
      public function addTradeOtherPlayerQuitHandler(param1:ITradeOtherPlayerQuitHandler) : void
      {
         addHandler(ITradeOtherPlayerQuitHandler,param1);
      }
      
      public function removeQuittingTradeHandler(param1:IQuittingTradeHandler) : void
      {
         removeHandler(IQuittingTradeHandler,param1);
      }
      
      private function isPlayerInvited(param1:String) : Boolean
      {
         var _loc2_:* = 0;
         while(_loc2_ < _invitedUsers.length)
         {
            if(_invitedUsers[_loc2_].username == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("[SMARTFOX TRADE]          " + param1,_userProfile.screenname);
      }
      
      public function quitTrade() : void
      {
         var _loc1_:IQuittingTradeHandler = null;
         for each(_loc1_ in _handlers[IQuittingTradeHandler])
         {
            _loc1_.handleQuttingTrade();
         }
         sendRequestToServer(TradeState.REQUEST_QUIT_TRADE,{"userRefId":_userProfile.id});
         Managers.serviceRequestBrokerManager.startTokenRefresh();
      }
      
      public function addToCart(param1:String, param2:String) : void
      {
         sendRequestToServer(TradeState.REQUEST_ADD_TO_CART,{
            "userRefId":param1,
            "assetId":param2
         });
      }
      
      private function handleExtensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:String = param1.params.type;
         var _loc3_:Object = param1.params.dataObj;
         var _loc4_:String = _loc3_._cmd;
         var _loc5_:Boolean = true;
         switch(_loc4_)
         {
            case TradeState.RESPONSE_TRADE_CREATED:
               tradeCreated(_loc3_);
               break;
            case TradeState.RESPONSE_TRADE_CREATION_ERROR:
               tradeCreationError(_loc3_);
               break;
            case TradeState.SERVER_INVITATION_REQUEST:
               tradeInvitationRequest(_loc3_);
               break;
            case TradeState.SERVER_INVITATION_RESPONSE:
               tradeInvitationResponse(_loc3_);
               break;
            case TradeState.SERVER_INVITATION_CANCELED:
               tradeInvitationCanceled(_loc3_);
               break;
            case TradeState.SERVER_PLAYER_JOIN_TRADE:
               playerJoinTrade(_loc3_);
               break;
            case TradeState.SERVER_OTHER_PLAYER_JOIN_TRADE:
               otherPlayerJoinTrade(_loc3_);
               break;
            case TradeState.SERVER_COLLECTION_SET:
               collectionSet(_loc3_);
               break;
            case TradeState.SERVER_TRADE_STARTED:
               tradeStarted(_loc3_);
               break;
            case TradeState.SERVER_ADDED_TO_CART:
               addedToCart(_loc3_);
               break;
            case TradeState.SERVER_REMOVED_FROM_CART:
               removedFromCart(_loc3_);
               break;
            case TradeState.SERVER_OFFER_MADE:
               offerMade(_loc3_);
               break;
            case TradeState.SERVER_OFFER_ACCEPTED:
               offerAccepted(_loc3_);
               break;
            case TradeState.SERVER_TRANSACTION_CONFIRMED:
               transactionConfirmed(_loc3_);
               break;
            case TradeState.SERVER_TRADE_QUIT:
            case TradeState.SERVER_TRADE_OVER:
               tradeQuit(_loc3_);
               break;
            case TradeState.RESPONSE_TRADE_BADGE_LIST:
               badgeList(_loc3_);
               break;
            case TradeState.RESPONSE_TRADE_INVITATION_ERROR:
               break;
            case TradeState.RESPONSE_JOIN_TRADE_ERROR:
               joinTradeError(_loc3_);
               break;
            case TradeState.RESPONSE_SYSTEM_ERROR:
               systemError(_loc3_);
               break;
            default:
               _loc5_ = false;
         }
         if(_loc5_)
         {
            log(">>SMF>><< handleExtensionResponse [" + EXTENSION_NAME + "]: found case for: " + _loc4_);
         }
      }
      
      public function addOtherPlayerJoinTradeHandler(param1:IOtherPlayerJoinTradeHandler) : void
      {
         addHandler(IOtherPlayerJoinTradeHandler,param1);
      }
      
      public function handleInvitationAccept(param1:Object) : void
      {
         var _loc2_:ITradeInvitationAcceptHandler = null;
         if(_userProfile.nanocash < 4)
         {
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Not Enough Nanocash","You need at least 4 nanocash to trade.");
            replyTradeInvitation(param1.tradeName,false,Const.REPLY_CODE_NOT_ENOUGH_CASH);
            return;
         }
         _tradeName = param1.tradeName;
         GameServiceProvider.getInstance().chatGameService.exitChatRoom();
         GameServiceProvider.getInstance().battleGameService.quitGame();
         replyTradeInvitation(param1.tradeName,true,Const.REPLY_CODE_ACCEPT);
         for each(_loc2_ in _handlers[ITradeInvitationAcceptHandler])
         {
            _loc2_.handleTradeInvitationAccept(param1);
         }
      }
      
      private function addedToCart(param1:Object) : void
      {
         var _loc4_:IAddedToCartHandler = null;
         var _loc2_:String = param1.userRefId;
         var _loc3_:String = param1.assetId;
         for each(_loc4_ in _handlers[IAddedToCartHandler])
         {
            _loc4_.handleAddedToCart({
               "tradeName":_tradeName,
               "userRefId":_loc2_,
               "assetId":_loc3_
            });
         }
      }
      
      private function tradeCreationError(param1:Object) : void
      {
         var _loc2_:ITradeCreationErrorHandler = null;
         for each(_loc2_ in _handlers[ITradeCreationErrorHandler])
         {
            _loc2_.handleTradeCreationError(param1);
         }
      }
      
      public function removeCollectionSetHandler(param1:ICollectionSetHandler) : void
      {
         removeHandler(ICollectionSetHandler,param1);
      }
      
      private function resetTrade() : void
      {
         _invitedUsers = new Array();
      }
      
      public function inviteUser(param1:String) : void
      {
         log("Inviting user " + param1 + ". Current invited users:" + _invitedUsers.length);
         if(_invitedUsers.length == 0)
         {
            createTrade(param1);
         }
         else
         {
            inviteUserAfterTradeRoomIsCreated(param1);
         }
      }
      
      private function playerJoinTrade(param1:Object) : void
      {
         var _loc2_:IPlayerJoinTradeHandler = null;
         for each(_loc2_ in _handlers[IPlayerJoinTradeHandler])
         {
            _loc2_.handlePlayerJoinTrade({"tradeName":_tradeName});
         }
      }
      
      public function removeTradeOverHandler(param1:ITradeOverHandler) : void
      {
         removeHandler(ITradeOverHandler,param1);
      }
      
      private function tradeInvitationResponse(param1:Object) : void
      {
         var _loc8_:ITradeInvitationResponseHandler = null;
         var _loc9_:Object = null;
         _tradeName = param1.tradeName;
         var _loc2_:String = param1.inviterName;
         var _loc3_:String = param1.inviterId;
         var _loc4_:String = param1.inviteeName;
         var _loc5_:String = param1.inviteeId;
         var _loc6_:Boolean = Boolean(param1.acceptedInvitation);
         var _loc7_:String = param1.replyReason;
         if(!param1.acceptedInvitation)
         {
            _invitedUsers.splice(0,1);
            resetTrade();
         }
         else
         {
            _loc9_ = {
               "username":_loc4_,
               "userRefId":_loc5_
            };
            _invitedUsers[0] = _loc9_;
         }
         for each(_loc8_ in _handlers[ITradeInvitationResponseHandler])
         {
            _loc8_.handleTradeInvitationResponse({
               "tradeName":_tradeName,
               "inviterName":_loc2_,
               "inviterId":_loc3_,
               "inviteeId":_loc5_,
               "acceptedInvitation":_loc6_,
               "replyReason":_loc7_
            });
         }
      }
      
      public function addRemovedFromCartHandler(param1:IRemovedFromCartHandler) : void
      {
         addHandler(IRemovedFromCartHandler,param1);
      }
      
      private function unregisterTradeEventHandlers() : void
      {
         _gameServiceConnection.removeEventListener(SFSEvent.onExtensionResponse,handleExtensionResponse);
         _gameServiceConnection.removeEventListener(SFSEvent.onJoinRoomError,onJoinRoomError);
         _gameServiceConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         _gameServiceConnection.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
      }
      
      public function addTradeCreationErrorHandler(param1:ITradeCreationErrorHandler) : void
      {
         addHandler(ITradeCreationErrorHandler,param1);
      }
      
      public function handleInvitationBusy(param1:Object) : void
      {
         log("handleInvitationBusy() - SHAMWOW Busy");
         replyTradeInvitation(param1.tradeName,false,Const.REPLY_CODE_BUSY);
      }
      
      public function removeTradeOtherPlayerQuitHandler(param1:ITradeOtherPlayerQuitHandler) : void
      {
         removeHandler(ITradeOtherPlayerQuitHandler,param1);
      }
      
      private function tradeStarted(param1:Object) : void
      {
         var _loc3_:ITradeStartedHandler = null;
         log("tradeStarted()");
         var _loc2_:String = param1.userRefId;
         for each(_loc3_ in _handlers[ITradeStartedHandler])
         {
            _loc3_.handleTradeStarted({
               "tradeName":_tradeName,
               "userRefId":_loc2_
            });
         }
         Managers.serviceRequestBrokerManager.stopTokenRefresh();
      }
      
      public function removeFromCart(param1:String, param2:String) : void
      {
         sendRequestToServer(TradeState.REQUEST_REMOVE_FROM_CART,{
            "userRefId":param1,
            "assetId":param2
         });
      }
      
      public function addTransactionConfirmedHandler(param1:ITransactionConfirmedHandler) : void
      {
         addHandler(ITransactionConfirmedHandler,param1);
      }
      
      public function addPlayerJoinTradeHandler(param1:IPlayerJoinTradeHandler) : void
      {
         addHandler(IPlayerJoinTradeHandler,param1);
      }
      
      public function addTradeOverHandler(param1:ITradeOverHandler) : void
      {
         addHandler(ITradeOverHandler,param1);
      }
      
      public function addTradeInvitationCanceledHandler(param1:ITradeInvitationCanceledHandler) : void
      {
         addHandler(ITradeInvitationCanceledHandler,param1);
      }
      
      private function offerMade(param1:Object) : void
      {
         var _loc4_:IOfferMadeHandler = null;
         var _loc2_:String = param1.userRefId;
         var _loc3_:String = param1.code;
         for each(_loc4_ in _handlers[IOfferMadeHandler])
         {
            _loc4_.handleOfferMade({
               "tradeName":_tradeName,
               "userRefId":_loc2_,
               "code":_loc3_
            });
         }
      }
      
      public function removeOtherPlayerJoinTradeHandler(param1:IOtherPlayerJoinTradeHandler) : void
      {
         removeHandler(IOtherPlayerJoinTradeHandler,param1);
      }
      
      public function removeTradeInvitationResponseHandler(param1:ITradeInvitationResponseHandler) : void
      {
         removeHandler(ITradeInvitationResponseHandler,param1);
      }
      
      public function removeTradeQuitHandler(param1:ITradeQuitHandler) : void
      {
         removeHandler(ITradeQuitHandler,param1);
      }
      
      private function removedFromCart(param1:Object) : void
      {
         var _loc4_:IRemovedFromCartHandler = null;
         var _loc2_:String = param1.userRefId;
         var _loc3_:String = param1.assetId;
         for each(_loc4_ in _handlers[IRemovedFromCartHandler])
         {
            _loc4_.handleRemovedFromCart({
               "tradeName":_tradeName,
               "userRefId":_loc2_,
               "assetId":_loc3_
            });
         }
      }
      
      private function inviteUserAfterTradeRoomIsCreated(param1:String) : void
      {
         if(_invitedUsers.length < MAX_PLAYERS && !isPlayerInvited(param1))
         {
            log("inviteUserAfterTradeRoomIsCreated(): inviting user to trade...");
            _invitedUsers.push({
               "username":param1,
               "inGameStatus":"waiting..."
            });
            sendRequestToServer(TradeState.REQUEST_INVITE_USER,{
               "buddy":param1,
               "tradeName":_tradeName
            });
         }
      }
      
      public function addTradeStartedHandler(param1:ITradeStartedHandler) : void
      {
         addHandler(ITradeStartedHandler,param1);
      }
      
      public function getDialogText(param1:Object) : String
      {
         return "User " + String(param1.inviter.username).toUpperCase() + " wants to trade with you.\nReminder: Completing a trade costs 4 Nanocash.\nDo you accept?";
      }
      
      private function tradeInvitationRequest(param1:Object) : void
      {
         if(!PermissionsManager.getInstance().canTrade)
         {
            replyTradeInvitation(param1.tradeName,false,Const.REPLY_CODE_NO_PERMISSION);
            return;
         }
         if(!_invitationManager.checkCanAcceptInvitations())
         {
            replyTradeInvitation(param1.tradeName,false,Const.REPLY_CODE_BUSY);
            return;
         }
         _invitationManager.handleInvitation(param1,IGameServiceInvitationManagerConsumer(this),param1.tradeName,30,true);
      }
      
      public function setGameServiceInivitationManager(param1:IGameServiceInvitationManager) : void
      {
         _invitationManager = param1;
      }
      
      public function addTradeQuitHandler(param1:ITradeQuitHandler) : void
      {
         addHandler(ITradeQuitHandler,param1);
      }
      
      private function debugTrace(param1:String) : void
      {
         trace("[ LOG ] " + param1);
      }
      
      public function getDialogTitle() : String
      {
         return "INVITE TO TRADE";
      }
      
      public function removeBadgeListReceivedHandler(param1:IBadgeListReceivedHandler) : void
      {
         removeHandler(IBadgeListReceivedHandler,param1);
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         debugTrace("I/O Error: " + param1.text);
      }
      
      public function removeTransactionConfirmedHandler(param1:ITransactionConfirmedHandler) : void
      {
         removeHandler(ITransactionConfirmedHandler,param1);
      }
      
      private function createTrade(param1:String) : void
      {
         log("createTrade()");
         _invitee = param1;
         sendRequestToServer(TradeState.REQUEST_CREATE_TRADE,{});
      }
      
      public function addBadgeListReceivedHandler(param1:IBadgeListReceivedHandler) : void
      {
         addHandler(IBadgeListReceivedHandler,param1);
      }
      
      private function joinTradeError(param1:Object) : void
      {
      }
      
      private function replyTradeInvitation(param1:String, param2:Boolean, param3:String) : void
      {
         if(!param2)
         {
            resetTrade();
         }
         sendRequestToServer(TradeState.REQUEST_REPLY_INVITATION,{
            "tradeName":param1,
            "accept":param2,
            "replyReason":param3
         });
      }
      
      public function handleInvitationDecline(param1:Object) : void
      {
         log("handleInvitationDecline() - SHAMWOW Decline");
         replyTradeInvitation(param1.tradeName,false,Const.REPLY_CODE_DECLINE);
      }
      
      private function tradeInvitationCanceled(param1:Object) : void
      {
         _invitationManager.cancelInvitation(param1.tradeName,"Trade Cancelled","Other player left trade");
      }
      
      private function tradeQuit(param1:Object) : void
      {
         var _loc4_:ITradeOverHandler = null;
         var _loc5_:ITradeQuitHandler = null;
         var _loc6_:ITradeOtherPlayerQuitHandler = null;
         log("tradeQuit()");
         var _loc2_:String = param1.userRefId;
         var _loc3_:String = param1.reason;
         resetTrade();
         if(_loc2_ == String(_userProfile.id))
         {
            for each(_loc5_ in _handlers[ITradeQuitHandler])
            {
               _loc5_.handleTradeQuit({
                  "tradeName":_tradeName,
                  "reason":_loc3_
               });
            }
         }
         else
         {
            for each(_loc6_ in _handlers[ITradeOtherPlayerQuitHandler])
            {
               _loc6_.handleTradeOtherPlayerQuit({
                  "tradeName":_tradeName,
                  "userRefId":_loc2_,
                  "reason":_loc3_
               });
            }
         }
         for each(_loc4_ in _handlers[ITradeOverHandler])
         {
            _loc4_.handleTradeOver({
               "tradeName":_tradeName,
               "reason":_loc3_
            });
         }
         Managers.serviceRequestBrokerManager.startTokenRefresh();
      }
      
      private function badgeList(param1:Object) : void
      {
         var _loc2_:IBadgeListReceivedHandler = null;
         log("BADGES: " + param1.badgeList);
         for each(_loc2_ in _handlers[IBadgeListReceivedHandler])
         {
            _loc2_.handleBadgeListReceived({
               "tradeName":_tradeName,
               "ownerId":param1.ownerId,
               "nanovorId":param1.nanovorId,
               "badgeList":param1.badgeList
            });
         }
      }
      
      public function addQuittingTradeHandler(param1:IQuittingTradeHandler) : void
      {
         addHandler(IQuittingTradeHandler,param1);
      }
      
      public function addOfferAcceptedHandler(param1:IOfferAcceptedHandler) : void
      {
         addHandler(IOfferAcceptedHandler,param1);
      }
      
      public function removeTradeStartedHandler(param1:ITradeStartedHandler) : void
      {
         removeHandler(ITradeStartedHandler,param1);
      }
      
      public function addTradeInvitationResponseHandler(param1:ITradeInvitationResponseHandler) : void
      {
         addHandler(ITradeInvitationResponseHandler,param1);
      }
      
      public function addAddedToCartHandler(param1:IAddedToCartHandler) : void
      {
         addHandler(IAddedToCartHandler,param1);
      }
      
      private function tradeCreated(param1:Object) : void
      {
         log("Created Trade name is " + param1.tradeName);
         _tradeName = param1.tradeName;
         inviteUserAfterTradeRoomIsCreated(_invitee);
      }
      
      override protected function createHandlersDictionary() : void
      {
         _handlers = new Dictionary();
         _handlers[ITradeInvitationRequestHandler] = new Dictionary(true);
         _handlers[ITradeInvitationResponseHandler] = new Dictionary(true);
         _handlers[IPlayerJoinTradeHandler] = new Dictionary(true);
         _handlers[IOtherPlayerJoinTradeHandler] = new Dictionary(true);
         _handlers[ITradeInvitationCanceledHandler] = new Dictionary(true);
         _handlers[ITradeQuitHandler] = new Dictionary(true);
         _handlers[ITradeOtherPlayerQuitHandler] = new Dictionary(true);
         _handlers[ITradeOverHandler] = new Dictionary(true);
         _handlers[ICollectionSetHandler] = new Dictionary(true);
         _handlers[ITradeStartedHandler] = new Dictionary(true);
         _handlers[IAddedToCartHandler] = new Dictionary(true);
         _handlers[IRemovedFromCartHandler] = new Dictionary(true);
         _handlers[IOfferMadeHandler] = new Dictionary(true);
         _handlers[IOfferAcceptedHandler] = new Dictionary(true);
         _handlers[ITransactionConfirmedHandler] = new Dictionary(true);
         _handlers[IBadgeListReceivedHandler] = new Dictionary(true);
         _handlers[IQuittingTradeHandler] = new Dictionary(true);
         _handlers[ITradeCreationErrorHandler] = new Dictionary(true);
         _handlers[ITradeInvitationAcceptHandler] = new Dictionary(true);
      }
      
      private function collectionSet(param1:Object) : void
      {
         var _loc5_:ICollectionSetHandler = null;
         var _loc2_:String = param1.userRefId;
         var _loc3_:Array = param1.nanovorList;
         var _loc4_:Array = param1.emList;
         for each(_loc5_ in _handlers[ICollectionSetHandler])
         {
            _loc5_.handleCollectionSet({
               "tradeName":_tradeName,
               "userRefId":_loc2_,
               "nanovorList":_loc3_,
               "emList":_loc4_
            });
         }
      }
      
      public function confirmTransaction() : void
      {
         sendRequestToServer(TradeState.REQUEST_CONFIRM_TRANSACTION,{"userRefId":_userProfile.id});
      }
   }
}

