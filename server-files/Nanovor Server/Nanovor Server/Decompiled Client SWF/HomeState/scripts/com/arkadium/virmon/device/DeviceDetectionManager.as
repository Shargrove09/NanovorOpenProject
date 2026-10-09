package com.arkadium.virmon.device
{
   import com.arkadium.communications.IChatGameService;
   import com.arkadium.virmon.collection.ICollectionState;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.wrapper.IApplicationExitHandler;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class DeviceDetectionManager implements IDeviceConnectionHandler, IApplicationExitHandler
   {
      
      private var _commonDialogBox:CommonDialogBox;
      
      private var _headerWidget:IHeaderWidget;
      
      private var _deviceConnectionDetector:IDeviceConnectionDetector;
      
      private var _deviceConnectionHandler:DeviceConnectionHandler;
      
      private var _chatGameService:IChatGameService;
      
      private var _stateManager:IStateManager;
      
      private var _applicationExiter:IApplicationExiter;
      
      public function DeviceDetectionManager(param1:IMDMManager, param2:IStateManager, param3:IHeaderWidget, param4:IChatGameService, param5:IApplicationExiter)
      {
         super();
         if(null == param1)
         {
            throw new Error("Parameter \"mdmManager\" cannot be null.");
         }
         if(null == param2)
         {
            throw new Error("Parameter \"stateManager\" cannot be null.");
         }
         if(null == param3)
         {
            throw new Error("Parameter \"headerWidget\" cannot be null.");
         }
         if(null == param4)
         {
            throw new Error("Parameter \"chatGameService\" cannot be null.");
         }
         if(null == param5)
         {
            throw new Error("Parameter \"applicationExiter\" cannot be null.");
         }
         _deviceConnectionHandler = new DeviceConnectionHandler(IDeviceConnectionHandler(this));
         _deviceConnectionDetector = new DeviceConnectionDetector(param1,_deviceConnectionHandler);
         _chatGameService = param4;
         _applicationExiter = param5;
         _stateManager = param2;
         _headerWidget = param3;
      }
      
      private function log(param1:Object) : void
      {
         DebugLog.instance.log("<<DeviceDetectionManager>> " + param1.toString());
      }
      
      public function handleApplicationExit() : void
      {
         log("handleApplicationExit()");
         if(null != _commonDialogBox)
         {
            _commonDialogBox.kill();
         }
         _commonDialogBox = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Nanoscope Still Connected","Please disconnect Nanoscope first before exiting.",0,null,null);
      }
      
      private function showSecondDialog(param1:Object) : void
      {
         CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Nanoscope Connected","Once you\'ve confirmed your Jolt spend, click the Nanoscope button along the top of your screen to connect to your Nanoscope.",0,null,null);
      }
      
      public function get isDeviceConnected() : Boolean
      {
         return _deviceConnectionHandler.isConnected;
      }
      
      public function handleDeviceConnected(param1:String) : void
      {
         var _loc2_:String = null;
         log("handleDeviceConnected()!");
         _applicationExiter.addApplicationExitHandler(IApplicationExitHandler(this));
         _stateManager.setStateData(StateType.DEVICEMANAGER,_deviceConnectionDetector);
         if(null != _chatGameService.privateChatRoomName)
         {
            log("handleDeviceConnected(): _chatGameService.privateChatRoomName: " + _chatGameService.privateChatRoomName);
            _headerWidget.enableDeviceButton();
            _loc2_ = "battle or chat";
            if(_stateManager.state == StateType.TRADEGAME.name)
            {
               _loc2_ = "Trade";
            }
            else if(_stateManager.state == StateType.BATTLE.name || _stateManager.state == StateType.SENSEI_BATTLE.name)
            {
               _loc2_ = "Battle";
            }
            else
            {
               _loc2_ = "Private Chat";
            }
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"Nanoscope has been Connected","Please exit " + _loc2_ + " and click the \"Nanoscope\" tab at the top of the home screen to manage your Nanoscope.",0,null,null);
            return;
         }
         if(_stateManager.getStateByName(StateType.COLLECTION.name) != null && Boolean(ICollectionState(_stateManager.getStateByName(StateType.COLLECTION.name)).pendingChanges))
         {
            log("handleDeviceConnected(): collectionstate has pending changes");
            _headerWidget.enableDeviceButton();
            CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_ALERT,"UNSAVED CHANGES","You have made changes to your Nanovor\'s stats.  If you leave now, these changes will go unsaved.  Are you sure you want to exit?",0,proceedIgnoringPendingChanges,showSecondDialog);
            return;
         }
         log("handleDeviceConnected(): attempting to move to device manager. isConnected? " + _chatGameService.isConnected);
         if(_chatGameService.isConnected)
         {
            _stateManager.setState(StateType.DEVICEMANAGER);
         }
         else
         {
            _applicationExiter.removeApplicationExitHandler(IApplicationExitHandler(this));
         }
      }
      
      public function startDeviceCheck() : void
      {
         _deviceConnectionDetector.startDeviceCheck();
      }
      
      private function proceedIgnoringPendingChanges(param1:Object) : void
      {
         if(_chatGameService.isConnected)
         {
            _stateManager.setState(StateType.DEVICEMANAGER);
         }
         else
         {
            _applicationExiter.removeApplicationExitHandler(IApplicationExitHandler(this));
         }
      }
      
      public function stopDeviceCheck() : void
      {
         _deviceConnectionDetector.stopDeviceCheck();
      }
      
      public function handleDeviceDisconnected() : void
      {
         log("handleDeviceDisconnected(): " + new Error("stack").getStackTrace());
         if(null != _commonDialogBox)
         {
            _commonDialogBox.kill();
         }
         _headerWidget.disableDeviceButton();
         _stateManager.setStateData(StateType.DEVICEMANAGER,null);
         if(shouldGoHome())
         {
            _stateManager.setState(StateType.HOME);
         }
         _applicationExiter.removeApplicationExitHandler(IApplicationExitHandler(this));
      }
      
      private function shouldGoHome() : Boolean
      {
         if(null != _chatGameService.privateChatRoomName)
         {
            return false;
         }
         if(null == _stateManager.getStateByName(StateType.DEVICEMANAGER.name))
         {
            return false;
         }
         return true;
      }
   }
}

