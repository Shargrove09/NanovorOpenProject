package com.arkadium.virmon.shared.utils.substate.substatecontrollerwithname
{
   import com.arkadium.virmon.shared.utils.substate.ISubStateFactory;
   import com.arkadium.virmon.shared.utils.substate.SubStateController;
   
   public class SubStateControllerWithName extends SubStateController implements ISubStateControllerWithName
   {
      
      private var _currentSubStateType:String;
      
      public function SubStateControllerWithName(param1:ISubStateFactory)
      {
         super(param1);
         _currentSubStateType = "";
      }
      
      public function get currentSubStateType() : String
      {
         return _currentSubStateType;
      }
      
      override public function changeSubState(param1:String, param2:Object = null) : void
      {
         _currentSubStateType = param1;
         super.changeSubState(param1,param2);
      }
   }
}

