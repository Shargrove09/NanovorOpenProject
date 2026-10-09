package com.arkadium.virmon.device.ui
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public interface IDeviceUIController extends IDeviceStateUI
   {
      
      function closeSpinner(param1:Function = null) : void;
      
      function finishedUIUnset() : void;
      
      function getDeviceContents() : IDeviceContents;
      
      function showErrorPopup(param1:Object = null) : void;
      
      function nextUIInstructions(param1:IDeviceUIInstructions) : void;
      
      function moveSpinner(param1:Point, param2:Function = null) : void;
      
      function closeBGBlock() : void;
      
      function handleDeviceReset(param1:Function = null) : void;
      
      function showDisconnectPopup() : void;
      
      function openSpinner(param1:Function = null) : void;
      
      function addUILayer(param1:DisplayObject) : void;
      
      function openBGBlock() : void;
   }
}

