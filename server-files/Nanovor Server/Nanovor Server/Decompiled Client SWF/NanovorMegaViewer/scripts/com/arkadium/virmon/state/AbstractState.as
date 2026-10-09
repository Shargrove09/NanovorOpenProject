package com.arkadium.virmon.state
{
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   
   public class AbstractState extends MovieClip implements IState
   {
      
      protected var _stateName:String;
      
      public var isInitialized:Boolean = false;
      
      private var _inTranstion:String = "GenericTransition.swf";
      
      protected var _quicktipsURL:String;
      
      private var _outTranstion:String = "GenericTransition.swf";
      
      private var _currentMode:String;
      
      public function AbstractState()
      {
         super();
         this.tabChildren = false;
         this.tabEnabled = false;
      }
      
      public function set outTransition(param1:String) : void
      {
         _outTranstion = param1;
      }
      
      public function getQuicktipsURL() : String
      {
         return _quicktipsURL;
      }
      
      public function destroy() : void
      {
         var _loc2_:* = undefined;
         log("is melting.");
         Utils.removeAllListener(this);
         var _loc1_:int = Utils.RemoveChildrenTweens(this);
         Utils.clearAllChildren(this);
         for(_loc2_ in this)
         {
            this[_loc2_] = null;
         }
         delete global[this];
      }
      
      public function onTransitionOutComplete() : void
      {
      }
      
      public function onSetState() : void
      {
      }
      
      public function init(param1:Object = null) : void
      {
         throw new Error("IState subclass must implement init().");
      }
      
      public function log(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = param1 is Array ? "[Array]\n" : "";
         if(param1 is String)
         {
            param1 = [param1];
         }
         if(param1.length == 1)
         {
            _loc2_ = param1[0];
         }
         else
         {
            for(_loc3_ in param1)
            {
               _loc2_ += "\n\t[" + _loc3_ + "] " + param1[_loc3_];
            }
         }
         trace("<<" + _stateName + ">>\t" + _loc2_);
         DebugLog.instance.log("<<" + _stateName + ">>\t" + _loc2_);
      }
      
      public function set quicktipsURL(param1:String) : void
      {
         _quicktipsURL = param1;
      }
      
      public function onTransitionInComplete() : void
      {
      }
      
      public function attemptToLeaveState(param1:StateType, param2:Object = null) : Boolean
      {
         return true;
      }
      
      public function logError(param1:String) : void
      {
         trace("<<" + _stateName + ">>ERROR: -->\t" + param1);
         DebugLog.instance.error("<<" + _stateName + ">>ERROR: -->\t" + param1);
      }
      
      public function setMode(param1:String) : void
      {
      }
      
      public function onUnsetState() : void
      {
      }
      
      public function set inTransition(param1:String) : void
      {
         _inTranstion = param1;
      }
      
      public function set stateName(param1:String) : void
      {
         _stateName = param1;
      }
      
      public function transitionOut() : void
      {
      }
      
      public function get stateName() : String
      {
         return _stateName;
      }
   }
}

