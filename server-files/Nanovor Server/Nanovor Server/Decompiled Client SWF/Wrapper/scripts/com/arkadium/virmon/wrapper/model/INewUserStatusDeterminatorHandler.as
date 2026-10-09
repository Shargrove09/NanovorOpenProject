package com.arkadium.virmon.wrapper.model
{
   public interface INewUserStatusDeterminatorHandler
   {
      
      function handleNewUserStatusDeterminatorError(param1:String) : void;
      
      function handleNewUserStatusDeterminatorComplete(param1:Boolean) : void;
   }
}

