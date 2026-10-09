package com.arkadium.virmon.device.home
{
   import com.arkadium.virmon.device.DevicePanelBase;
   import com.arkadium.virmon.device.DevicePanelType;
   import com.arkadium.virmon.device.IDevicePanelController;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.MouseEvent;
   
   public class DeviceHomePanel extends DevicePanelBase implements IDeviceUIInstructionsConsumer
   {
      
      private static const SHOW_DEBUG_LOGS:Boolean = true;
      
      private var _nanovors:Array;
      
      private var _uiInstructions:DeviceHomePanelUIInstructions;
      
      public function DeviceHomePanel()
      {
         super();
         log("init()");
      }
      
      private function onDisonnectButtonClick(param1:MouseEvent) : void
      {
         _deviceUIController.showDisconnectPopup();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         log("destroy() clearing memory!!");
         if(_uiInstructions != null)
         {
            _uiInstructions.destroy();
            _uiInstructions = null;
         }
         _nanovors = null;
      }
      
      override public function setPanel() : void
      {
         _deviceUIController.nextUIInstructions(_uiInstructions);
      }
      
      private function log(param1:String) : void
      {
         if(SHOW_DEBUG_LOGS)
         {
            DebugLog.instance.log("<<DeviceHomePanel>>\t" + param1);
         }
      }
      
      private function onNanovorTransferButtonClick() : void
      {
         log("onNanovorTransferButtonClick()");
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_SWARM_CHOOSER);
      }
      
      public function setUIFinished() : void
      {
      }
      
      override public function init(param1:IDevicePanelController, param2:IDeviceUIController) : void
      {
         super.init(param1,param2);
         _uiInstructions = new DeviceHomePanelUIInstructions(_deviceUIController,IDeviceUIInstructionsConsumer(this));
         _deviceUIController.getActionPicker().setNanovorButtonHandler(onNanovorTransferButtonClick);
         _uiInstructions.getFooterButton().addEventListener(MouseEvent.CLICK,onDisonnectButtonClick,false,0,true);
      }
   }
}

