package com.arkadium.communications
{
   public interface IGameServiceInvitationManager
   {
      
      function handleInvitation(param1:Object, param2:IGameServiceInvitationManagerConsumer, param3:String, param4:int, param5:Boolean = true) : void;
      
      function cancelInvitation(param1:String, param2:String, param3:String) : void;
      
      function checkCanAcceptInvitations() : Boolean;
      
      function removeInvitationByKey(param1:String) : void;
      
      function declineAllInvitations(param1:Boolean = false) : void;
   }
}

