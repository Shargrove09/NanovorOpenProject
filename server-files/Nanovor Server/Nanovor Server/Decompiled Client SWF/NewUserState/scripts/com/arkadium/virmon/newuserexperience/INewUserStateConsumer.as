package com.arkadium.virmon.newuserexperience
{
   import com.arkadium.virmon.state.IStateManager;
   
   public interface INewUserStateConsumer
   {
      
      function handleNewUserStateComplete(param1:IStateManager) : void;
   }
}

