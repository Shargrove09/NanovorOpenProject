package com.arkadium.virmon.gameengine.dialog
{
   import com.arkadium.virmon.home.IHomeBreadcrumbUIManager;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.mdm.MDMBrowserKey;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.wrapper.Dialog;
   import com.arkadium.virmon.wrapper.DialogManager;
   import com.arkadium.virmon.wrapper.IDialogUIController;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class GameEngineDialogUIController implements IDialogUIController
   {
      
      private var _eventManager:IEventDispatcher;
      
      private var _mdmManager:IMDMManager;
      
      private var _homeBreadcrumbUIManager:IHomeBreadcrumbUIManager;
      
      private var _dialogUI:Dialog;
      
      public function GameEngineDialogUIController(param1:IEventDispatcher, param2:Dialog, param3:IMDMManager, param4:IHomeBreadcrumbUIManager)
      {
         super();
         _eventManager = param1;
         _dialogUI = param2;
         _mdmManager = param3;
         _homeBreadcrumbUIManager = param4;
         _dialogUI.hide();
         var _loc5_:DialogManager = new DialogManager();
         _loc5_.init(this as IDialogUIController);
         Managers.dialogManager = _loc5_;
      }
      
      public function showDialog(param1:Object) : void
      {
         _dialogUI.show(param1);
         _eventManager.dispatchEvent(new Event(CommonDialogBox.DIALOG_BOX_OPENED_EVENT));
         _mdmManager.hideAllMdmBrowsers();
      }
      
      public function hideDialog() : void
      {
         _dialogUI.hide();
         if(_homeBreadcrumbUIManager != null && _homeBreadcrumbUIManager.activeNewsBlockerCount > 1)
         {
            _mdmManager.pushFakeBrowserState(MDMBrowserKey.HOME_NEWS,{"visible":false});
         }
         _mdmManager.restoreLastMdmBrowsersStates();
      }
   }
}

