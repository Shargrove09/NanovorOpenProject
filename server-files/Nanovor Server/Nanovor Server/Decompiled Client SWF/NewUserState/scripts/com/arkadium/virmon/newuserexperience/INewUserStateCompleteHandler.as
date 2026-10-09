package com.arkadium.virmon.newuserexperience
{
   public interface INewUserStateCompleteHandler
   {
      
      function handleNewUserStateError(param1:String) : void;
      
      function handleNewUserStateComplete() : void;
   }
}

