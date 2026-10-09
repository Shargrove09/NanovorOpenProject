package com.arkadium.communications
{
   public interface IGameServiceInvitationManagerConsumer
   {
      
      function handleInvitationTimeout(param1:Object) : void;
      
      function getDialogTitle() : String;
      
      function handleInvitationDecline(param1:Object) : void;
      
      function handleInvitationAccept(param1:Object) : void;
      
      function handleInvitationBusy(param1:Object) : void;
      
      function getDialogText(param1:Object) : String;
   }
}

