package com.arkadium.virmon.device
{
   import com.arkadium.virmon.device.ui.DeviceJoltsAwards;
   import com.arkadium.virmon.device.ui.DeviceUIInstructionsBase;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class DeviceStateUIInstructions extends DeviceUIInstructionsBase
   {
      
      public function DeviceStateUIInstructions(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super(param1,param2);
      }
      
      private function pullOffNanoscope() : void
      {
         var _loc1_:MovieClip = _deviceUIController.getNanoscope();
         if(null != _loc1_.parent)
         {
            _loc1_.parent.removeChild(_loc1_);
         }
         _loc1_.x = 0;
         _loc1_.y = 0;
      }
      
      private function initializeButtonWiresAndTitles() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:MovieClip = _deviceUIController.getWireTitleUnknownNanoscope();
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.gotoAndStop(1);
         _loc2_ = _deviceUIController.getWireTitleAddNanoscope();
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         _loc2_.gotoAndStop(1);
         var _loc3_:MovieClip = _deviceUIController.getTitleTransferingNanoscope();
         _loc3_.mouseEnabled = false;
         _loc3_.mouseChildren = false;
         _loc3_.alpha = 0;
         var _loc4_:MovieClip = _deviceUIController.getTitleUpdatingNanoscope();
         _loc4_.mouseEnabled = false;
         _loc4_.mouseChildren = false;
         _loc4_.alpha = 0;
         var _loc5_:MovieClip = _deviceUIController.getTitleHome();
         _loc5_.mouseEnabled = false;
         _loc5_.mouseChildren = false;
         _loc5_.alpha = 0;
         var _loc6_:MovieClip = _deviceUIController.getTitleWarning();
         _loc6_.mouseEnabled = false;
         _loc6_.mouseChildren = false;
         _loc6_.alpha = 0;
         var _loc7_:Sprite = _deviceUIController.getButtonTitleAddNanoscope();
         _loc7_.alpha = 0;
         _loc7_.mouseEnabled = false;
         var _loc8_:Sprite = _deviceUIController.getButtonTitleIgnoreNanoscope();
         _loc8_.alpha = 0;
         _loc8_.mouseEnabled = false;
         var _loc9_:Sprite = _deviceUIController.getButtonTitleCancel();
         _loc9_.alpha = 0;
         _loc9_.mouseEnabled = false;
         var _loc10_:Sprite = _deviceUIController.getButtonTitleEraseData();
         _loc10_.alpha = 0;
         _loc10_.mouseEnabled = false;
         var _loc11_:TextField = _deviceUIController.getConsole();
         _loc11_.visible = false;
         _loc11_.mouseEnabled = false;
         var _loc12_:DeviceJoltsAwards = _deviceUIController.getJoltsAwards();
         _loc12_.mouseEnabled = false;
         _loc12_.mouseChildren = false;
         _loc12_.alpha = 0;
         _deviceUIController.getDeviceContents().hide();
         _deviceUIController.getSpinner().visible = false;
         _deviceUIController.getSpinner().close();
         _deviceUIController.getCenterStripe().alpha = 0;
         _deviceUIController.getTransferAnimation().stop();
         _deviceUIController.getTransferAnimation().alpha = 0;
         _deviceUIController.getUpdateChevrons().stop();
         _deviceUIController.getUpdateChevrons().alpha = 0;
         _deviceUIController.getSwarmChooserInstructions().alpha = 0;
      }
      
      private function initializeSpinnerAndBGBlock() : void
      {
         _deviceUIController.getSpinner().init();
         _deviceUIController.getBGBlock().alpha = 0;
         _deviceUIController.getBGBlock().stop();
      }
      
      override public function unsetUI() : void
      {
         _deviceUIController.getSpinner().visible = true;
         unsetUIFinished();
      }
      
      override public function setUI() : void
      {
         _deviceUIController.getSpinner().init();
         pullOffNanoscope();
         initializeSpinnerAndBGBlock();
         initializeButtonWiresAndTitles();
         _deviceUIController.getActionPicker().init();
         setUIFinished();
      }
   }
}

