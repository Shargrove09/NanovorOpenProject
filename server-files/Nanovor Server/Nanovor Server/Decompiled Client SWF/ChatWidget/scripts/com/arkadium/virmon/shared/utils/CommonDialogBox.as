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
         this.oParams = null;
         this._tmrTimeOut = null;
         this._nTimeOut = param4;
         if(Boolean(rest[0] as Array))
         {
            rest = rest[0];
         }
         switch(param1)
         {
            case TYPE_INFO:
               this.fnOnOK = rest[0];
               this.fnOnExit = rest[1];
               this.oParams = rest[2];
               this.fnOnTimeOut = rest[3];
               break;
            case TYPE_CONFIRM:
               this.fnOnYes = rest[0];
               this.fnOnNo = rest[1];
               this.fnOnExit = rest[2];
               this.oParams = rest[3];
               this.fnOnTimeOut = rest[4];
               break;
            case TYPE_ALERT:
               this.fnOnOK = rest[0];
               this.fnOnCancel = rest[1];
               this.fnOnExit = rest[2];
               this.oParams = rest[3];
               this.fnOnTimeOut = rest[4];
               break;
            case TYPE_WAITING:
               this.fnOnCancel = rest[0];
               this.fnOnExit = rest[1];
               this.oParams = rest[2];
               this.fnOnTimeOut = rest[3];
         }
         this.oData = new Object();
         this.oData.sType = this._sType = param1;
         this.oData.sMainText = param2;
         this.oData.sSupportText = param3;
         this.oData.oCDB = this;
         if(this._nTimeOut < 0)
         {
            this._tmrTimeOut = new Timer(this._nTimeOut * -1000,1);
            this._tmrTimeOut.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerTimeOut,false,0,true);
            this._tmrTimeOut.start();
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
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_OK",this.onOKClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_YES",this.onYesClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_NO",this.onNoClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_CANCEL",this.onCancelClick);
         EventManager.getInstance().removeEventListener("DIALOG_CLICK_EXIT",this.onExitClick);
      }
      
      public function activate() : void
      {
         this.addListeners();
         if(this._nTimeOut > 0)
         {
            this._tmrTimeOut = new Timer(this._nTimeOut * 1000,1);
            this._tmrTimeOut.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerTimeOut,false,0,true);
            this._tmrTimeOut.start();
         }
      }
      
      public function clear() : void
      {
         this.removeAllListeners();
         if(Boolean(this._tmrTimeOut))
         {
            this._tmrTimeOut.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerTimeOut);
            this._tmrTimeOut.reset();
            this._tmrTimeOut = null;
         }
      }
      
      protected function onCancelClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         this.clear();
         try
         {
            if(Boolean(this.fnOnCancel))
            {
               this.fnOnCancel(this.oParams);
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
         this.clear();
         try
         {
            if(Boolean(this.fnOnOK))
            {
               this.fnOnOK(this.oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onOKClick...\n" + e.message);
         }
      }
      
      public function addListeners() : void
      {
         switch(this._sType)
         {
            case TYPE_INFO:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_OK",this.onOKClick,false,0,true);
               break;
            case TYPE_CONFIRM:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_YES",this.onYesClick,false,0,true);
               EventManager.getInstance().addEventListener("DIALOG_CLICK_NO",this.onNoClick,false,0,true);
               break;
            case TYPE_ALERT:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_OK",this.onOKClick,false,0,true);
               EventManager.getInstance().addEventListener("DIALOG_CLICK_CANCEL",this.onCancelClick,false,0,true);
               break;
            case TYPE_WAITING:
               EventManager.getInstance().addEventListener("DIALOG_CLICK_CANCEL",this.onCancelClick,false,0,true);
         }
         EventManager.getInstance().addEventListener("DIALOG_CLICK_EXIT",this.onExitClick,false,0,true);
      }
      
      public function kill() : void
      {
         this.clear();
         EventManager.getInstance().dispatchEvent(new ProjectEvent("KILL_DIALOG",this.oData));
      }
      
      protected function onYesClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         this.clear();
         try
         {
            if(Boolean(this.fnOnYes))
            {
               this.fnOnYes(this.oParams);
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
         this.clear();
         try
         {
            if(Boolean(this.fnOnExit))
            {
               this.fnOnExit(this.oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onExitClick...\n" + e.message);
         }
      }
      
      public function toString() : String
      {
         return "[CommonDialogBox: _sType=" + this._sType + ", _nTimeOut=" + this._nTimeOut + ", oData.sMainText=\"" + this.oData.sMainText + "\"]";
      }
      
      protected function onNoClick(param1:ProjectEvent) : void
      {
         var e:ProjectEvent = param1;
         this.clear();
         try
         {
            if(Boolean(this.fnOnNo))
            {
               this.fnOnNo(this.oParams);
            }
         }
         catch(e:Error)
         {
            logError("Error caught :: onNoClick...\n" + e.message);
         }
      }
      
      public function dispatch(param1:String = "QUEUE_DIALOG") : void
      {
         EventManager.getInstance().dispatchEvent(new ProjectEvent(param1,this.oData));
      }
      
      protected function onTimerTimeOut(param1:TimerEvent) : void
      {
         var e:TimerEvent = param1;
         log("onTimerIimeOut");
         try
         {
            this._tmrTimeOut.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerTimeOut);
            this._tmrTimeOut = null;
            if(Boolean(this.fnOnTimeOut))
            {
               if(this.oParams === null)
               {
                  this.oParams = new Object();
               }
               this.oParams.callingCDB = this;
               this.fnOnTimeOut(this.oParams);
            }
         }
         catch(e:Error)
         {
            logError(this.toString() + "\n... Error caught :: onTimerTimeOut...\n" + e.message);
         }
      }
   }
}

