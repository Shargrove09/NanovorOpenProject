package com.arkadium.virmon.device.ui
{
   import com.arkadium.virmon.battle.control.INanovor;
   
   public interface IDeviceContents
   {
      
      function hide() : void;
      
      function addNanovor(param1:INanovor, param2:String = "stateNormal") : void;
      
      function updateProgress(param1:Number) : void;
      
      function destroy() : void;
      
      function clearNanovors() : void;
      
      function show() : void;
      
      function resetNanovors() : void;
   }
}

