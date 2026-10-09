package com.arkadium.virmon.shared.utils.substate.substatecontrollerwithname
{
   import com.arkadium.virmon.shared.utils.substate.ISubStateController;
   
   public interface ISubStateControllerWithName extends ISubStateController
   {
      
      function get currentSubStateType() : String;
   }
}

