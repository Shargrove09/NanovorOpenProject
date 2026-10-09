package com.arkadium.virmon.device.ui
{
   import com.arkadium.virmon.device.ui.spinner.DeviceSpinner;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class DeviceStateUI extends MovieClip implements IDeviceStateUI
   {
      
      public var mcButtonTitleEraseData:Sprite;
      
      public var tfConsole:TextField;
      
      public var mcWireTitleAddNanoscope:MovieClip;
      
      public var mcActionPicker:DeviceActionPicker;
      
      public var btnDeviceReset:SimpleButton;
      
      public var mcSwarmChooserInstructions:MovieClip;
      
      public var mcSpinner:DeviceSpinner;
      
      public var mcNanoscope:SpinningNanoscopeLarge;
      
      public var mcUpdateChevrons:MovieClip;
      
      public var mcTitleUpdatingNanoscope:MovieClip;
      
      public var mcCenterStripe:DeviceCenterStripe;
      
      public var mcTitleTransferingNanoscope:MovieClip;
      
      public var mcTitleHome:MovieClip;
      
      public var mcTransferAnimation:MovieClip;
      
      public var mcTitleWarning:MovieClip;
      
      public var mcJoltsAwards:DeviceJoltsAwards;
      
      public var mcButtonTitleAddNanoscope:Sprite;
      
      public var mcButtonTitleCancel:Sprite;
      
      public var mcWireTitleUnknownNanoscope:MovieClip;
      
      public var mcBGBlock:MovieClip;
      
      public var mcButtonTitleIgnoreNanoscope:Sprite;
      
      public function DeviceStateUI()
      {
         super();
      }
      
      public function getUpdateChevrons() : MovieClip
      {
         return mcUpdateChevrons;
      }
      
      public function getNanoscope() : SpinningNanoscopeLarge
      {
         return mcNanoscope;
      }
      
      public function getTitleTransferingNanoscope() : MovieClip
      {
         return mcTitleTransferingNanoscope;
      }
      
      public function getTitleHome() : MovieClip
      {
         return mcTitleHome;
      }
      
      public function getCenterStripe() : DeviceCenterStripe
      {
         return mcCenterStripe;
      }
      
      public function getJoltsAwards() : DeviceJoltsAwards
      {
         return mcJoltsAwards;
      }
      
      public function getTitleWarning() : MovieClip
      {
         return mcTitleWarning;
      }
      
      public function getButtonTitleAddNanoscope() : Sprite
      {
         return mcButtonTitleAddNanoscope;
      }
      
      public function getConsole() : TextField
      {
         return tfConsole;
      }
      
      public function getButtonTitleCancel() : Sprite
      {
         return mcButtonTitleCancel;
      }
      
      public function getBGBlock() : MovieClip
      {
         return mcBGBlock;
      }
      
      public function getButtonTitleIgnoreNanoscope() : Sprite
      {
         return mcButtonTitleIgnoreNanoscope;
      }
      
      public function getButtonTitleEraseData() : Sprite
      {
         return mcButtonTitleEraseData;
      }
      
      public function getWireTitleAddNanoscope() : MovieClip
      {
         return mcWireTitleAddNanoscope;
      }
      
      public function getTransferAnimation() : MovieClip
      {
         return mcTransferAnimation;
      }
      
      public function getWireTitleUnknownNanoscope() : MovieClip
      {
         return mcWireTitleUnknownNanoscope;
      }
      
      public function getActionPicker() : DeviceActionPicker
      {
         return mcActionPicker;
      }
      
      public function getSwarmChooserInstructions() : MovieClip
      {
         return mcSwarmChooserInstructions;
      }
      
      public function getSpinner() : DeviceSpinner
      {
         return mcSpinner;
      }
      
      public function getDeviceResetButton() : SimpleButton
      {
         return btnDeviceReset;
      }
      
      public function destroy() : void
      {
         mcActionPicker.destroy();
         mcSpinner.destroy();
         mcNanoscope.stop();
         mcUpdateChevrons.stop();
         mcSwarmChooserInstructions.stop();
         mcTransferAnimation.stop();
         mcBGBlock.stop();
         mcWireTitleAddNanoscope.stop();
         mcWireTitleUnknownNanoscope.stop();
         mcTitleHome.stop();
         mcTitleTransferingNanoscope.stop();
         mcTitleUpdatingNanoscope.stop();
         mcTitleWarning.stop();
      }
      
      public function getTitleUpdatingNanoscope() : MovieClip
      {
         return mcTitleUpdatingNanoscope;
      }
   }
}

