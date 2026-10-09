package com.arkadium.virmon.device.ui
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.device.IDeviceManager;
   import com.arkadium.virmon.device.ui.spinner.DeviceSpinner;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   
   public class DeviceUIController implements IDeviceUIController
   {
      
      private var _currentUIInstructions:IDeviceUIInstructions;
      
      private var _nextUIInstructions:IDeviceUIInstructions;
      
      private var _deviceContents:IDeviceContents;
      
      private var _deviceStateUI:IDeviceStateUI;
      
      private var _commonDialogBoxList:Array;
      
      private var _stateManager:IStateManager;
      
      private var TWEEN_BASE:Object = {
         "time":0.4,
         "transition":Equations.easeInOutQuad
      };
      
      private var _callbackQueue:Array;
      
      private var _disconnectDialog:CommonDialogBox;
      
      private var _deviceManager:IDeviceManager;
      
      public function DeviceUIController(param1:IStateManager, param2:IDeviceManager)
      {
         super();
         _stateManager = param1;
         _deviceManager = param2;
         _commonDialogBoxList = new Array();
      }
      
      public function closeSpinner(param1:Function = null) : void
      {
         _deviceStateUI.getSpinner().close(param1);
      }
      
      private function killDialogs() : void
      {
         var _loc1_:CommonDialogBox = null;
         for each(_loc1_ in _commonDialogBoxList)
         {
            if(null != _loc1_)
            {
               _loc1_.kill();
            }
         }
         _commonDialogBoxList = null;
      }
      
      public function getDeviceContents() : IDeviceContents
      {
         return _deviceContents;
      }
      
      public function getTitleTransferingNanoscope() : MovieClip
      {
         return _deviceStateUI.getTitleTransferingNanoscope();
      }
      
      public function moveSpinner(param1:Point, param2:Function = null) : void
      {
         if(null != param2)
         {
            Tweener.addTween(_deviceStateUI.getSpinner(),{
               "x":param1.x,
               "y":param1.y,
               "base":TWEEN_BASE,
               "onComplete":param2
            });
         }
         else
         {
            Tweener.addTween(_deviceStateUI.getSpinner(),{
               "x":param1.x,
               "y":param1.y,
               "base":TWEEN_BASE
            });
         }
      }
      
      public function getCenterStripe() : DeviceCenterStripe
      {
         return _deviceStateUI.getCenterStripe();
      }
      
      private function handleYesDeviceRecovery(param1:Object = null) : void
      {
         log("handleYesDeviceRecovery()");
         _deviceManager.startDeviceRecovery("");
      }
      
      public function nextUIInstructions(param1:IDeviceUIInstructions) : void
      {
         _nextUIInstructions = param1;
         _currentUIInstructions.unsetUI();
      }
      
      private function gotoCustomerService(param1:Object = null) : void
      {
         navigateToURL(new URLRequest("http://www.nanovor.com"),"_blank");
      }
      
      private function gotoCustomerServiceAndExitToHomeState(param1:Object = null) : void
      {
         gotoCustomerService();
         exitToHomeState();
      }
      
      public function init(param1:IDeviceStateUI, param2:ICharacterAssetTypeCache) : void
      {
         _deviceStateUI = param1;
         _callbackQueue = new Array();
         var _loc3_:DeviceContents = new DeviceContents(param2,_deviceStateUI.getNanoscope().getContents());
         _loc3_.init();
         _loc3_.y = 630;
         addUILayer(_loc3_);
         _deviceContents = _loc3_ as IDeviceContents;
         _currentUIInstructions = new DummyUIInstructions(this,null);
         _deviceStateUI.getDeviceResetButton().addEventListener(MouseEvent.CLICK,handleDeviceResetClick);
      }
      
      public function getTransferAnimation() : MovieClip
      {
         return _deviceStateUI.getTransferAnimation();
      }
      
      public function getTitleHome() : MovieClip
      {
         return _deviceStateUI.getTitleHome();
      }
      
      public function getTitleWarning() : MovieClip
      {
         return _deviceStateUI.getTitleWarning();
      }
      
      public function getButtonTitleCancel() : Sprite
      {
         return _deviceStateUI.getButtonTitleCancel();
      }
      
      public function getJoltsAwards() : DeviceJoltsAwards
      {
         return _deviceStateUI.getJoltsAwards();
      }
      
      public function getBGBlock() : MovieClip
      {
         return _deviceStateUI.getBGBlock();
      }
      
      public function getButtonTitleAddNanoscope() : Sprite
      {
         return _deviceStateUI.getButtonTitleAddNanoscope();
      }
      
      private function exitToHomeState(param1:Object = null) : void
      {
         _stateManager.setState(StateType.HOME);
      }
      
      public function getWireTitleAddNanoscope() : MovieClip
      {
         return _deviceStateUI.getWireTitleAddNanoscope();
      }
      
      public function openBGBlock() : void
      {
         _deviceStateUI.getBGBlock().play();
         Tweener.addTween(_deviceStateUI.getBGBlock(),{
            "_autoAlpha":0.7,
            "time":1,
            "transition":Equations.easeInBounce
         });
      }
      
      public function getButtonTitleEraseData() : Sprite
      {
         return _deviceStateUI.getButtonTitleEraseData();
      }
      
      public function showDisconnectPopup() : void
      {
         _disconnectDialog = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_WAITING,"Disconnect Nanoscope","It is now safe to disconnect your Nanoscope.\nPlease do not turn it off until you see the Ready screen — the device update may take up to five minutes.",0,killDisconnectDialogBox,killDisconnectDialogBox,null,killDisconnectDialogBox);
         _commonDialogBoxList.push(_disconnectDialog);
      }
      
      public function finishedUIUnset() : void
      {
         log("finishedUIUnset()");
         if(_nextUIInstructions != null)
         {
            _nextUIInstructions.setUI();
            _currentUIInstructions = _nextUIInstructions;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceUIController>> " + param1);
      }
      
      public function getWireTitleUnknownNanoscope() : MovieClip
      {
         return _deviceStateUI.getWireTitleUnknownNanoscope();
      }
      
      public function closeBGBlock() : void
      {
         Tweener.addTween(_deviceStateUI.getBGBlock(),{
            "_autoAlpha":0,
            "onComplete":_deviceStateUI.getBGBlock().stop,
            "base":TWEEN_BASE
         });
      }
      
      public function handleDeviceReset(param1:Function = null) : void
      {
         log("handleDeviceReset()");
         _commonDialogBoxList.push(CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_CONFIRM,"Device Recovery","Click \"Yes\" if you have a recovery validation code\nor click \"No\" to contact customer support.",0,handleYesDeviceRecovery,null == param1 ? gotoCustomerService : param1,null == param1 ? gotoCustomerService : param1,null,null));
      }
      
      private function handleDeviceResetClick(param1:MouseEvent) : void
      {
         log("handleDeviceResetClick()");
         handleDeviceReset();
      }
      
      public function getActionPicker() : DeviceActionPicker
      {
         return _deviceStateUI.getActionPicker();
      }
      
      public function addUILayer(param1:DisplayObject) : void
      {
         (_deviceStateUI as DisplayObjectContainer).addChild(param1);
      }
      
      public function getSwarmChooserInstructions() : MovieClip
      {
         return _deviceStateUI.getSwarmChooserInstructions();
      }
      
      public function getConsole() : TextField
      {
         return _deviceStateUI.getConsole();
      }
      
      public function showErrorPopup(param1:Object = null) : void
      {
         _commonDialogBoxList.push(CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_ALERT,"Nanoscope Error","There was a problem associating the Nanoscope (ID: " + int(param1.deviceID) + "),\nplease disconnect Nanoscope\nor click \"OK\" to contact customer support.",0,gotoCustomerServiceAndExitToHomeState,exitToHomeState,exitToHomeState,null,null));
      }
      
      private function killDisconnectDialogBox(param1:Object = null) : void
      {
         if(null == _disconnectDialog)
         {
            return;
         }
         _disconnectDialog.kill();
         _disconnectDialog = null;
      }
      
      public function getSpinner() : DeviceSpinner
      {
         return _deviceStateUI.getSpinner();
      }
      
      public function openSpinner(param1:Function = null) : void
      {
         _deviceStateUI.getSpinner().open(param1);
      }
      
      public function getNanoscope() : SpinningNanoscopeLarge
      {
         return _deviceStateUI.getNanoscope();
      }
      
      public function getDeviceResetButton() : SimpleButton
      {
         return _deviceStateUI.getDeviceResetButton();
      }
      
      public function getButtonTitleIgnoreNanoscope() : Sprite
      {
         return _deviceStateUI.getButtonTitleIgnoreNanoscope();
      }
      
      public function destroy() : void
      {
         log("destroy() clearing memory!!");
         _deviceStateUI.getDeviceResetButton().removeEventListener(MouseEvent.CLICK,handleDeviceResetClick);
         if(null != _deviceStateUI as DisplayObject && null != (_deviceStateUI as DisplayObject).parent)
         {
            (_deviceStateUI as DisplayObject).parent.removeChild(_deviceStateUI as DisplayObject);
         }
         killDialogs();
         _deviceStateUI.destroy();
         _deviceContents.destroy();
         _disconnectDialog = null;
      }
      
      public function getUpdateChevrons() : MovieClip
      {
         return _deviceStateUI.getUpdateChevrons();
      }
      
      public function getTitleUpdatingNanoscope() : MovieClip
      {
         return _deviceStateUI.getTitleUpdatingNanoscope();
      }
   }
}

