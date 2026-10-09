package com.arkadium.communications
{
   import com.arkadium.communications.handlers.trade.IAddedToCartHandler;
   import com.arkadium.communications.handlers.trade.IBadgeListReceivedHandler;
   import com.arkadium.communications.handlers.trade.ICollectionSetHandler;
   import com.arkadium.communications.handlers.trade.IOfferAcceptedHandler;
   import com.arkadium.communications.handlers.trade.IOfferMadeHandler;
   import com.arkadium.communications.handlers.trade.IOtherPlayerJoinTradeHandler;
   import com.arkadium.communications.handlers.trade.IPlayerJoinTradeHandler;
   import com.arkadium.communications.handlers.trade.IQuittingTradeHandler;
   import com.arkadium.communications.handlers.trade.IRemovedFromCartHandler;
   import com.arkadium.communications.handlers.trade.ITradeCreationErrorHandler;
   import com.arkadium.communications.handlers.trade.ITradeInvitationAcceptHandler;
   import com.arkadium.communications.handlers.trade.ITradeInvitationCanceledHandler;
   import com.arkadium.communications.handlers.trade.ITradeInvitationRequestHandler;
   import com.arkadium.communications.handlers.trade.ITradeInvitationResponseHandler;
   import com.arkadium.communications.handlers.trade.ITradeOtherPlayerQuitHandler;
   import com.arkadium.communications.handlers.trade.ITradeOverHandler;
   import com.arkadium.communications.handlers.trade.ITradeQuitHandler;
   import com.arkadium.communications.handlers.trade.ITradeStartedHandler;
   import com.arkadium.communications.handlers.trade.ITransactionConfirmedHandler;
   
   public interface ITradeGameService extends IGameService
   {
      
      function addRemovedFromCartHandler(param1:IRemovedFromCartHandler) : void;
      
      function addTradeCreationErrorHandler(param1:ITradeCreationErrorHandler) : void;
      
      function addCollectionSetHandler(param1:ICollectionSetHandler) : void;
      
      function addTransactionConfirmedHandler(param1:ITransactionConfirmedHandler) : void;
      
      function removeTradeOtherPlayerQuitHandler(param1:ITradeOtherPlayerQuitHandler) : void;
      
      function joinAndGetCollections(param1:String) : void;
      
      function addTradeInivitationAcceptHandler(param1:ITradeInvitationAcceptHandler) : void;
      
      function removeFromCart(param1:String, param2:String) : void;
      
      function get tradeName() : String;
      
      function removeTradeInvitationResponseHandler(param1:ITradeInvitationResponseHandler) : void;
      
      function removeTradeInivitationAcceptHandler(param1:ITradeInvitationAcceptHandler) : void;
      
      function addPlayerJoinTradeHandler(param1:IPlayerJoinTradeHandler) : void;
      
      function addTradeOverHandler(param1:ITradeOverHandler) : void;
      
      function removeTradeInvitationRequestHandler(param1:ITradeInvitationRequestHandler) : void;
      
      function addTradeInvitationCanceledHandler(param1:ITradeInvitationCanceledHandler) : void;
      
      function addTradeInvitationRequestHandler(param1:ITradeInvitationRequestHandler) : void;
      
      function removeTradeCreationErrorHandler(param1:ITradeCreationErrorHandler) : void;
      
      function removeAddedToCartHandler(param1:IAddedToCartHandler) : void;
      
      function removeTradeQuitHandler(param1:ITradeQuitHandler) : void;
      
      function removeOfferMadeHandler(param1:IOfferMadeHandler) : void;
      
      function startTrade() : void;
      
      function removeOtherPlayerJoinTradeHandler(param1:IOtherPlayerJoinTradeHandler) : void;
      
      function makeOffer() : void;
      
      function removeRemovedFromCartHandler(param1:IRemovedFromCartHandler) : void;
      
      function addTradeStartedHandler(param1:ITradeStartedHandler) : void;
      
      function getBadgeList(param1:String, param2:String) : void;
      
      function removePlayerJoinTradeHandler(param1:IPlayerJoinTradeHandler) : void;
      
      function setGameServiceInivitationManager(param1:IGameServiceInvitationManager) : void;
      
      function removeTradeInvitationCanceledHandler(param1:ITradeInvitationCanceledHandler) : void;
      
      function addOfferMadeHandler(param1:IOfferMadeHandler) : void;
      
      function removeBadgeListReceivedHandler(param1:IBadgeListReceivedHandler) : void;
      
      function addToCart(param1:String, param2:String) : void;
      
      function addTradeQuitHandler(param1:ITradeQuitHandler) : void;
      
      function cancelTradeInvitation(param1:String, param2:String, param3:String, param4:String) : void;
      
      function removeTransactionConfirmedHandler(param1:ITransactionConfirmedHandler) : void;
      
      function removeQuittingTradeHandler(param1:IQuittingTradeHandler) : void;
      
      function addBadgeListReceivedHandler(param1:IBadgeListReceivedHandler) : void;
      
      function removeOfferAcceptedHandler(param1:IOfferAcceptedHandler) : void;
      
      function addTradeOtherPlayerQuitHandler(param1:ITradeOtherPlayerQuitHandler) : void;
      
      function quitTrade() : void;
      
      function addOtherPlayerJoinTradeHandler(param1:IOtherPlayerJoinTradeHandler) : void;
      
      function addQuittingTradeHandler(param1:IQuittingTradeHandler) : void;
      
      function addOfferAcceptedHandler(param1:IOfferAcceptedHandler) : void;
      
      function removeTradeStartedHandler(param1:ITradeStartedHandler) : void;
      
      function removeCollectionSetHandler(param1:ICollectionSetHandler) : void;
      
      function addTradeInvitationResponseHandler(param1:ITradeInvitationResponseHandler) : void;
      
      function addAddedToCartHandler(param1:IAddedToCartHandler) : void;
      
      function inviteUser(param1:String) : void;
      
      function removeTradeOverHandler(param1:ITradeOverHandler) : void;
      
      function confirmTransaction() : void;
   }
}

