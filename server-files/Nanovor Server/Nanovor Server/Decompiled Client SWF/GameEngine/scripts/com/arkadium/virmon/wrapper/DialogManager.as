package com.arkadium.virmon.wrapper
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.arkadium.virmon.home.IHomeNewsBlocker;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class DialogManager extends EventDispatcher implements IDialogManager, IHomeNewsBlocker
   {
      
      private static const _SINGLE_MODE:Boolean = false;
      
      private static const _NEXT_DIALOG_DELAY:int = 1000;
      
      private var _tmrNextDialog:Timer;
      
      private var _dictDialogIndex:Dictionary = new Dictionary();
      
      private var _aDialogStack:Array = new Array();
      
      private var _dialogUIController:IDialogUIController;
      
      public function DialogManager()
      {
         super();
      }
      
      private function stackPush(param1:Object) : int
      {
         var _loc2_:int = _aDialogStack.push(param1) - 1;
         _dictDialogIndex[param1] = _loc2_;
         return _loc2_;
      }
      
      public function clearQueue(param1:Boolean = true) : void
      {
         if(Boolean(_aDialogStack.length))
         {
            if(param1)
            {
               clearTopBox();
            }
            _aDialogStack = new Array();
            _dictDialogIndex = new Dictionary();
         }
      }
      
      private function killDialog(param1:ProjectEvent) : void
      {
         var _loc2_:Object = param1.params;
         if(_dictDialogIndex[_loc2_] === undefined || _dictDialogIndex[_loc2_] === null)
         {
            logError("killDialog: could not find passed data object in stack dictionary");
            return;
         }
         var _loc3_:int = int(_dictDialogIndex[_loc2_]);
         log("killDialog: dialog stack index = " + _loc3_);
         if(_loc3_ == 0)
         {
            clearTopBox();
            stackShift();
            startNextDialogTimer();
         }
         else
         {
            _aDialogStack.splice(_loc3_,1);
            _dictDialogIndex[_loc2_] = null;
            fixStackDict();
         }
      }
      
      private function fixStackDict() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < _aDialogStack.length)
         {
            _dictDialogIndex[_aDialogStack[_loc1_]] = _loc1_;
            _loc1_++;
         }
      }
      
      private function forceDialog(param1:ProjectEvent) : void
      {
         var _loc2_:Object = param1.params;
         if(isActive)
         {
            clearTopBox();
            if(_SINGLE_MODE)
            {
               stackShift();
               stackPush(_loc2_);
            }
            else
            {
               stackUnshift(_loc2_);
            }
         }
         else
         {
            stackPush(_loc2_);
         }
         gotoNext();
      }
      
      public function get isActive() : Boolean
      {
         return _aDialogStack.length > 0;
      }
      
      private function stackShift() : Object
      {
         var _loc1_:Object = null;
         _loc1_ = _aDialogStack.shift();
         _dictDialogIndex[_loc1_] = null;
         fixStackDict();
         return _loc1_;
      }
      
      private function clearNextDialogTimer() : void
      {
         if(Boolean(_tmrNextDialog))
         {
            _tmrNextDialog.stop();
            _tmrNextDialog.removeEventListener(TimerEvent.TIMER_COMPLETE,onTmrNextDialogTick);
            _tmrNextDialog = null;
         }
      }
      
      public function init(param1:IDialogUIController) : *
      {
         _dialogUIController = param1;
         EventManager.getInstance().addEventListener("QUEUE_DIALOG",queueDialog);
         EventManager.getInstance().addEventListener("KILL_DIALOG",killDialog);
         EventManager.getInstance().addEventListener("FORCE_DIALOG",forceDialog);
         EventManager.getInstance().addEventListener("DIALOG_CLICK_YES",dialogClicked);
         EventManager.getInstance().addEventListener("DIALOG_CLICK_NO",dialogClicked);
         EventManager.getInstance().addEventListener("DIALOG_CLICK_OK",dialogClicked);
         EventManager.getInstance().addEventListener("DIALOG_CLICK_CANCEL",dialogClicked);
         EventManager.getInstance().addEventListener("DIALOG_CLICK_EXIT",dialogClicked);
      }
      
      private function stackUnshift(param1:Object) : int
      {
         var _loc2_:int = int(_aDialogStack.unshift(param1));
         fixStackDict();
         return _loc2_;
      }
      
      private function clearTopBox() : void
      {
         _dialogUIController.hideDialog();
         if(Boolean(_aDialogStack[0].oCDB) && Boolean(_aDialogStack[0].oCDB as CommonDialogBox))
         {
            CommonDialogBox(_aDialogStack[0].oCDB).clear();
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** DialogManager: " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> DialogManager: " + param1);
      }
      
      private function startNextDialogTimer() : void
      {
         clearNextDialogTimer();
         if(_NEXT_DIALOG_DELAY > 0)
         {
            _tmrNextDialog = new Timer(_NEXT_DIALOG_DELAY,1);
            _tmrNextDialog.addEventListener(TimerEvent.TIMER_COMPLETE,onTmrNextDialogTick,false,0,true);
            _tmrNextDialog.start();
         }
         else
         {
            gotoNext();
         }
      }
      
      private function onTmrNextDialogTick(param1:TimerEvent) : void
      {
         clearNextDialogTimer();
         gotoNext();
      }
      
      private function gotoNext() : void
      {
         clearNextDialogTimer();
         if(_aDialogStack.length == 0)
         {
            return;
         }
         var _loc1_:Object = _aDialogStack[0];
         if(Boolean(_loc1_.oCDB) && Boolean(_loc1_.oCDB as CommonDialogBox))
         {
            CommonDialogBox(_loc1_.oCDB).activate();
         }
         _dialogUIController.showDialog(_loc1_);
      }
      
      private function queueDialog(param1:ProjectEvent) : void
      {
         if(_SINGLE_MODE && isActive)
         {
            logError("queueDialog [_SINGLE_MODE==true]: attempt to queue a dialog box while one is already active.");
            return;
         }
         var _loc2_:Object = param1.params;
         var _loc3_:int = stackPush(_loc2_);
         if(_loc3_ == 0)
         {
            gotoNext();
         }
      }
      
      private function dialogClicked(param1:ProjectEvent) : void
      {
         clearTopBox();
         stackShift();
         startNextDialogTimer();
      }
   }
}

