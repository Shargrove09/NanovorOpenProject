package com.arkadium.virmon.newuserexperience.substates.complete
{
   import com.arkadium.virmon.newuserexperience.INewUserStateCompleteHandler;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   
   public class NewUserSubStateComplete extends AbstractSubState
   {
      
      private var _newUserStateCompleteHandler:INewUserStateCompleteHandler;
      
      public function NewUserSubStateComplete(param1:INewUserStateCompleteHandler)
      {
         super();
         _newUserStateCompleteHandler = param1;
      }
      
      override public function setSubState() : void
      {
         _newUserStateCompleteHandler.handleNewUserStateComplete();
      }
   }
}

