package com.arkadium.virmon.shared.utils
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.*;
   import flash.utils.Timer;
   
   public class CommonDialogBox
   {
      
      public static const TYPE_INFO:String = "info";
      
      public static const TYPE_CONFIRM:String = "confirm";
      
      public static const TYPE_ALERT:String = "alert";
      
      public static const TYPE_WAITING:String = "waiting";
      
      public static const DIALOG_BOX_OPENED_EVENT:String = "dialogBoxOpened";
      
      protected var fnOnTimeOut:Function;
      
      protected var fnOnExit:Function;
      
      protected var _tmrTimeOut:Timer;
      
      protected var _sType:String;
      
      protected var _nTimeOut:Number;
      
      protected var oParams:Object;
      
      protected var fnOnYes:Function;
      
      protected var fnOnCancel:Function;
      
      protected var fnOnOK:Function;
      
      protected var fnOnNo:Function;
      
      protected var oData:Object;
      
      public function CommonDialogBox(param1:String, param2:String, param3:String, param4:Number = 0, ... rest)
      {
         super();
         oParams = null;
         _tmrTimeOut = null;
         _nTimeOut = param4;
         if(Boolean(rest[0] as Array))
         {
            rest = rest[0];
         }
         switch(param1)
         {
            case TYPE_INFO:
               fnOnOK = rest[0];
               fnOnExit = rest[1];
               oParams = rest[2];
               fnOnTimeOut = rest[3];
               break;
            case TYPE_CONFIRM:
               fnOnYes = rest[0];
               fnOnNo = rest[1];
               fnOnExit = rest[2];
               oParams = rest[3];
               fnOnTimeOut = rest[4];
               break;
            case TYPE_ALERT:
               fnOnOK = rest[0];
               fnOnCancel = rest[1];
               fnOnExit = rest[2];
               oParams = rest[3];
               fnOnTimeOut = rest[4];
               break;
            case TYPE_WAITING:
               fnOnCancel = rest[0];
               fnOnExit = rest[1];
               oParams = rest[2];
               fnOnTimeOut = rest[3];
         }
         oData = new Object();
         oData.sType = _sType = param1;
         oData.sMainText = param2;
         oData.sSupportText = param3;
         oData.oCDB = this;
         if(_nTimeOut < 0)
         {
            _tmrTimeOut = new Timer(_nTimeOut * -1000,1);
            _tmrTimeOut.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerTimeOut,false,0,true);
            _tmrTimeOut.start();
         }
      }
      
      public static function GenericTimeoutKill(param1:Object) : void
      {
         var _loc2_:String = Utils.ObjectToString(param1);
         log("GenericTimeoutKill: oParams = " + _loc2_);
         if(Boolean(param1.callingCDB) && Boolean(param1.callingCDB as CommonDialogBox))
         {
            log("GenericTimeoutKill: attempting to kill CommonDialogBox object");
            (param1.callingCDB as CommonDialogBox).kill();
         }
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> CommonDialogBox: " + param1);
      }
      
      public static function MakeAndForce(param1:String, param2:String, param3:String, param4:Number = -1, ... rest) : CommonDialogBox
      {
         var _loc6_:CommonDialogBox = new CommonDialogBox(param1,param2,param3,param4,rest);
         _loc6_.dispatch("FORCE_DIALOG");
         return _loc6_;
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error("** CommonDialogBox: " + param1);
      }
      
      public static function MakeAndQueue(param1:String, param2:String, param3:String, param4:Number = 0, ... rest) : CommonDialogBox
      {
         var _loc6_:CommonDialogBox = new CommonDialogBox(param1,param2,param3,param4,rest);
         _loc6_.dispatch();
         return _loc6_;
      }
      
      protected function removeAllListeners() : void
      {
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_OK",onOKClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_YES",onYesClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_NO",onNoClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_CANCEL",onCancelClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_EXIT",onExitClick);
      }
      
      public function activate() : void
      {
         addListeners();
         if(_nTimeOut > 0)
         {
            _tmrTimeOut = new Timer(_nTimeOut * 1000,1);
            _tmrTimeOut.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerTimeOut,false,0,true);
            _tmrTimeOut.start();
         }
      }
      
      public function clear() : void
      {
         removeAllListeners();
         if(Boolean(_tmrTimeOut))
         {
            _tmrTimeOut.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerTimeOut);
            _tmrTimeOut.reset();
            _tmrTimeOut = null;
         }
      }
      
      protected function onCancelClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         clear();
         try
         {
            if(Boolean(fnOnCancel))
            {
               fnOnCancel(oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onCancelClick...\n" + e.message);
         }
      }
      
      protected function onOKClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         clear();
         try
         {
            if(Boolean(fnOnOK))
            {
               fnOnOK(oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onOKClick...\n" + e.message);
         }
      }
      
      public function addListeners() : void
      {
         switch(_sType)
         {
            case TYPE_INFO:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_OK",onOKClick,false,0,true);
               break;
            case TYPE_CONFIRM:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_YES",onYesClick,false,0,true);
               EventManager.getInstance().addEventListener("DIALOG_CLICK_NO",onNoClick,false,0,true);
               break;
            case TYPE_ALERT:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_OK",onOKClick,false,0,true);
               EventManager.getInstance().addEventListener("DIALOG_CLICK_CANCEL",onCancelClick,false,0,true);
               break;
            case TYPE_WAITING:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_CANCEL",onCancelClick,false,0,true);
         }
         EventManager.getInstance().addEventListener("DIALOG_CLICK_EXIT",onExitClick,false,0,true);
      }
      
      public function kill() : void
      {
         clear();
         EventManager.getInstance().dispatchEvent(new ProjectEvent("KILL_DIALOG",oData));
      }
      
      protected function onYesClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         clear();
         try
         {
            if(Boolean(fnOnYes))
            {
               fnOnYes(oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onYesClick...\n" + e.message);
         }
      }
      
      protected function onExitClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         clear();
         try
         {
            if(Boolean(fnOnExit))
            {
               fnOnExit(oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onExitClick...\n" + e.message);
         }
      }
      
      public function toString() : String
      {
         return "[CommonDialogBox: _sType=" + _sType + ", _nTimeOut=" + _nTimeOut + ", oData.sMainText=\"" + oData.sMainText + "\"]";
      }
      
      protected function onNoClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         clear();
         try
         {
            if(Boolean(fnOnNo))
            {
               fnOnNo(oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onNoClick...\n" + e.message);
         }
      }
      
      public function dispatch(param1:String = "QUEUE_DIALOG") : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent(param1,oData));
      }
      
      protected function onTimerTimeOut(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         log("onTimerIimeOut");
         try
         {
            _tmrTimeOut.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerTimeOut);
            _tmrTimeOut = null;
            if(Boolean(fnOnTimeOut))
            {
               if(oParams === null)
               {
                  oParams = new Object();
               }
               oParams.callingCDB = this;
               fnOnTimeOut(oParams);
            }
         }
         catch(e:Error)
         {
            logError(this.toString() + "\n... Error caught :: onTimerTimeOut...\n" + e.message);
         }
      }
   }
}

