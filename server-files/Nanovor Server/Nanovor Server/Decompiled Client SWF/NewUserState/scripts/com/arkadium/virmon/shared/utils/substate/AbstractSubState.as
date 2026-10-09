package com.arkadium.virmon.shared.utils.substate
{
   public class AbstractSubState implements ISubState
   {
      
      protected var _subStateController:ISubStateController;
      
      public function AbstractSubState()
      {
         super();
      }
      
      public function setSubState() : void
      {
         throw new Error("setSubState() must be implemented by the derived classes.");
      }
      
      public function setSubStateController(param1:ISubStateController) : *
      {
         _subStateController = param1;
      }
   }
}

