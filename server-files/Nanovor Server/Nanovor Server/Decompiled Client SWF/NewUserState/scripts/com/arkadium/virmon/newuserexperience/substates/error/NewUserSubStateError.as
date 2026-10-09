package com.arkadium.virmon.newuserexperience.substates.error
{
   import com.arkadium.virmon.newuserexperience.INewUserStateCompleteHandler;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   
   public class NewUserSubStateError extends AbstractSubState
   {
      
      private var _newUserStateCompleteHandler:INewUserStateCompleteHandler;
      
      private var _errorMessage:String;
      
      public function NewUserSubStateError(param1:INewUserStateCompleteHandler)
      {
         super();
         _newUserStateCompleteHandler = param1;
         _errorMessage = "";
      }
      
      public function setErrorMessage(param1:String) : void
      {
         _errorMessage = param1;
      }
      
      override public function setSubState() : void
      {
         _newUserStateCompleteHandler.handleNewUserStateError(_errorMessage);
      }
   }
}

