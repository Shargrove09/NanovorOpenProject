package com.arkadium.virmon.shared.widgets.header
{
   import com.arkadium.virmon.state.StateType;
   
   public interface IHeaderButtonRenderer
   {
      
      function disableDeviceButton() : void;
      
      function setStateButton(param1:StateType) : void;
      
      function addHeaderButtonClickHandler(param1:IHeaderButtonClickHandler) : void;
      
      function showButtons(param1:Number = 1) : void;
      
      function showLastButtonClickedAsCurrent(param1:MainButton) : void;
      
      function disableButton(param1:StateType, param2:Boolean) : void;
      
      function enableDeviceButton() : void;
      
      function createMainButtons() : void;
      
      function hideButtons(param1:Number = 1) : void;
   }
}

