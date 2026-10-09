package com.arkadium.virmon.state
{
   public interface IState
   {
      
      function init(param1:Object = null) : void;
      
      function onTransitionInComplete() : void;
      
      function onTransitionOutComplete() : void;
      
      function set quicktipsURL(param1:String) : void;
      
      function onUnsetState() : void;
      
      function getQuicktipsURL() : String;
      
      function transitionOut() : void;
      
      function destroy() : void;
      
      function onSetState() : void;
   }
}

