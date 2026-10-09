package com.arkadium.virmon.device.associatepanel
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.device.DevicePanelBase;
   import com.arkadium.virmon.device.DevicePanelType;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DeviceAssociatePanel extends DevicePanelBase implements IDeviceUIInstructionsConsumer
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = true;
      
      private static const STATE_INITIALIZE:String = "stateInitialize";
      
      private static const STATE_UNKNOWN:String = "stateUnknown";
      
      private static const STATE_CONFIRM:String = "stateConfirm";
      
      private var _button1:Sprite;
      
      private var _button2:Sprite;
      
      private var _disconnectDialog:CommonDialogBox;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _currentState:String;
      
      private var _uiInstructions:DeviceAssociatePanelUIInstructions;
      
      public function DeviceAssociatePanel(param1:IAnalyticsManager)
      {
         super();
         _analyticsManager = param1;
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<DeviceAssociatePanel>>\t" + param1);
         }
      }
      
      public function setUIFinished() : void
      {
         removeAllListeners();
         _uiInstructions.setUnknownUI();
         _button1.addEventListener(MouseEvent.CLICK,onAddNanoscopeClick,false,0,true);
         _button2.addEventListener(MouseEvent.CLICK,onIgnoreNanoscopeClick,false,0,true);
      }
      
      override public function setPanel() : void
      {
         _uiInstructions = new DeviceAssociatePanelUIInstructions(_deviceUIController,IDeviceUIInstructionsConsumer(this));
         _button1 = _uiInstructions.getSpinningButton1();
         _button2 = _uiInstructions.getSpinningButton2();
         log("setPanel() - GETS THIS FAR");
         _currentState = STATE_INITIALIZE;
         _deviceUIController.nextUIInstructions(_uiInstructions);
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         removeAllListeners();
         _uiInstructions.setUnknownUI();
         _button1.addEventListener(MouseEvent.CLICK,onAddNanoscopeClick,false,0,true);
         _button2.addEventListener(MouseEvent.CLICK,onIgnoreNanoscopeClick,false,0,true);
         _analyticsManager.trackView(View.DEVICE_UNKNOWN_DETECTED);
      }
      
      private function removeAllListeners() : void
      {
         if(null != _button1)
         {
            _button1.removeEventListener(MouseEvent.CLICK,onAddNanoscopeClick);
            _button1.removeEventListener(MouseEvent.CLICK,onCancelClick);
         }
         if(null != _button2)
         {
            _button2.removeEventListener(MouseEvent.CLICK,onIgnoreNanoscopeClick);
            _button2.removeEventListener(MouseEvent.CLICK,onEraseDataClick);
         }
      }
      
      override public function unsetPanel() : void
      {
         finishUnsetPanel();
      }
      
      private function onAddNanoscopeClick(param1:MouseEvent) : void
      {
         removeAllListeners();
         _uiInstructions.setConfirmUI();
         _button1.addEventListener(MouseEvent.CLICK,onCancelClick,false,0,true);
         _button2.addEventListener(MouseEvent.CLICK,onEraseDataClick,false,0,true);
         _analyticsManager.trackView(View.DEVICE_CONFIRM_ASSOCIATION);
      }
      
      private function onIgnoreNanoscopeClick(param1:MouseEvent) : void
      {
         _deviceUIController.showDisconnectPopup();
      }
      
      override public function destroy() : void
      {
         removeAllListeners();
      }
      
      private function onEraseDataClick(param1:MouseEvent) : void
      {
         log("onEraseDataClick()");
         _devicePanelController.nextPanel(DevicePanelType.DEVICE_PANEL_UPDATE);
      }
   }
}

