package com.arkadium.virmon.shared.utils.substate
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class SubStateController implements ISubStateController
   {
      
      protected var _subStateFactory:ISubStateFactory;
      
      public function SubStateController(param1:ISubStateFactory)
      {
         super();
         _subStateFactory = param1;
      }
      
      public function changeSubState(param1:String, param2:Object = null) : void
      {
         var _loc3_:ISubState = _subStateFactory.createSubState(param1,param2);
         _loc3_.setSubStateController(ISubStateController(this));
         _loc3_.setSubState();
      }
      
      public function destroy() : void
      {
         _subStateFactory = null;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SubStateController>>\t" + param1);
      }
   }
}

