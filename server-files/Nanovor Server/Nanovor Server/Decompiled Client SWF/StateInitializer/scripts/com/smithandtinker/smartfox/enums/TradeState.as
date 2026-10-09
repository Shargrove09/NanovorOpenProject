package com.smithandtinker.smartfox.enums
{
   public final class TradeState
   {
      
      public static const REQUEST_CREATE_TRADE:String = "createTrade";
      
      public static const REQUEST_INVITE_USER:String = "inviteUserToTrade";
      
      public static const REQUEST_REPLY_INVITATION:String = "replyInvitationToTrade";
      
      public static const REQUEST_CANCEL_TRADE:String = "cancelTradeInvitation";
      
      public static const REQUEST_JOIN_AND_GET_COLLECTIONS:String = "joinAndGetCollections";
      
      public static const REQUEST_START_TRADE:String = "startTrade";
      
      public static const REQUEST_ADD_TO_CART:String = "addToCart";
      
      public static const REQUEST_REMOVE_FROM_CART:String = "removeFromCart";
      
      public static const REQUEST_MAKE_OFFER:String = "makeOffer";
      
      public static const REQUEST_CONFIRM_TRANSACTION:String = "confirmTransaction";
      
      public static const REQUEST_QUIT_TRADE:String = "quitTrade";
      
      public static const REQUEST_GET_BADGE_LIST:String = "getBadgeList";
      
      public static const RESPONSE_TRADE_CREATED:String = "tradeCreated";
      
      public static const RESPONSE_TRADE_CREATION_ERROR:String = "tradeCreationError";
      
      public static const RESPONSE_TRADE_INVITATION_ERROR:String = "tradeInvitationError";
      
      public static const RESPONSE_SYSTEM_ERROR:String = "systemError";
      
      public static const RESPONSE_TRADE_ERROR:String = "tradeError";
      
      public static const RESPONSE_JOIN_TRADE_ERROR:String = "joinTradeError";
      
      public static const RESPONSE_TRADE_BADGE_LIST:String = "tradeBadgeList";
      
      public static const SERVER_ALL_PLAYERS_READY:String = "allTradePlayersReady";
      
      public static const SERVER_WAITING_FOR_PLAYERS:String = "waitingForTradePlayers";
      
      public static const SERVER_INVITATION_REQUEST:String = "tradeInvitationRequest";
      
      public static const SERVER_INVITATION_RESPONSE:String = "tradeInvitationResponse";
      
      public static const SERVER_INVITATION_CANCELED:String = "tradeInvitationCanceled";
      
      public static const SERVER_PLAYER_JOIN_TRADE:String = "playerJoinTrade";
      
      public static const SERVER_OTHER_PLAYER_JOIN_TRADE:String = "otherPlayerJoinTrade";
      
      public static const SERVER_COLLECTION_SET:String = "collectionSet";
      
      public static const SERVER_TRADE_STARTED:String = "tradeStarted";
      
      public static const SERVER_ADDED_TO_CART:String = "addedToCart";
      
      public static const SERVER_REMOVED_FROM_CART:String = "removedFromCart";
      
      public static const SERVER_OFFER_MADE:String = "offerMade";
      
      public static const SERVER_OFFER_ACCEPTED:String = "offerAccepted";
      
      public static const SERVER_TRANSACTION_CONFIRMED:String = "transactionConfirmed";
      
      public static const SERVER_TRADE_QUIT:String = "tradeQuit";
      
      public static const SERVER_TRADE_OVER:String = "tradeOver";
      
      public function TradeState()
      {
         super();
      }
   }
}

