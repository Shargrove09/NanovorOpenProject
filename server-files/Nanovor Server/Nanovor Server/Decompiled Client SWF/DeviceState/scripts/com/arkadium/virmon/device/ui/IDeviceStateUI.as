package com.arkadium.virmon.device.ui
{
   import com.arkadium.virmon.device.ui.spinner.DeviceSpinner;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public interface IDeviceStateUI
   {
      
      function getButtonTitleEraseData() : Sprite;
      
      function getTitleHome() : MovieClip;
      
      function getSpinner() : DeviceSpinner;
      
      function getSwarmChooserInstructions() : MovieClip;
      
      function getJoltsAwards() : DeviceJoltsAwards;
      
      function destroy() : void;
      
      function getConsole() : TextField;
      
      function getActionPicker() : DeviceActionPicker;
      
      function getNanoscope() : SpinningNanoscopeLarge;
      
      function getTitleTransferingNanoscope() : MovieClip;
      
      function getButtonTitleAddNanoscope() : Sprite;
      
      function getButtonTitleCancel() : Sprite;
      
      function getBGBlock() : MovieClip;
      
      function getWireTitleUnknownNanoscope() : MovieClip;
      
      function getDeviceResetButton() : SimpleButton;
      
      function getUpdateChevrons() : MovieClip;
      
      function getTitleUpdatingNanoscope() : MovieClip;
      
      function getTitleWarning() : MovieClip;
      
      function getTransferAnimation() : MovieClip;
      
      function getWireTitleAddNanoscope() : MovieClip;
      
      function getButtonTitleIgnoreNanoscope() : Sprite;
      
      function getCenterStripe() : DeviceCenterStripe;
   }
}

