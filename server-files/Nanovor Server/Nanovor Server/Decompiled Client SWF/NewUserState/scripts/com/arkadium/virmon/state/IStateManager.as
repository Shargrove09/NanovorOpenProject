package com.arkadium.virmon.state
{
   import com.arkadium.virmon.shared.widgets.IWidget;
   
   public interface IStateManager
   {
      
      function transitionToState(param1:StateType) : void;
      
      function getStateByName(param1:String) : AbstractState;
      
      function handleHelp(param1:String, param2:*) : void;
      
      function setState(param1:StateType, param2:Object = null, param3:Boolean = false) : void;
      
      function get isActive() : Boolean;
      
      function get state() : String;
      
      function handleLogout(... rest) : void;
      
      function set tradeCollectionSetData(param1:Array) : void;
      
      function setQuickTipsButton() : void;
      
      function get playersInBattle() : Array;
      
      function handleQuit(... rest) : void;
      
      function setStateData(param1:StateType, param2:Object) : void;
      
      function sendWidgetToLimbo(param1:IWidget) : void;
      
      function set playersInBattle(param1:Array) : void;
      
      function hideQuickTips(... rest) : void;
      
      function getStateData(param1:StateType) : Object;
      
      function get tradeCollectionSetData() : Array;
      
      function handleSettings(... rest) : void;
      
      function saveAndCloseGameOptions() : void;
      
      function handleQuitBattle(... rest) : void;
      
      function toggleHelp(param1:Boolean) : void;
      
      function handleBattleNow(... rest) : void;
      
      function getWidgetFromLimbo(param1:IWidget) : void;
      
      function handleQuickTips(... rest) : void;
      
      function loadQuickTips(param1:String) : void;
   }
}

