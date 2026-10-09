package com.arkadium.virmon.device
{
   import com.adobe.utils.StringUtil;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.wrapper.IApplicationExiter;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class DeviceConnectionDetector implements IDeviceConnectionDetector
   {
      
      private static const TIMER_DELAY:Number = 5000;
      
      private var _lastConnectionString:String;
      
      private var _timer:Timer;
      
      private var _handlers:Dictionary;
      
      private var _driveLetter:String;
      
      private var _mdmManager:IMDMManager;
      
      private var _applicationExiter:IApplicationExiter;
      
      public function DeviceConnectionDetector(param1:IMDMManager, param2:IDeviceConnectionHandler = null)
      {
         super();
         _mdmManager = param1;
         _handlers = new Dictionary();
         _handlers[IDeviceConnectionHandler] = new Dictionary(true);
         if(null != param2)
         {
            _handlers[IDeviceConnectionHandler][param2] = param2;
         }
         _timer = new Timer(TIMER_DELAY);
         _timer.addEventListener(TimerEvent.TIMER,handleTimer);
         log("DeviceConnectionDetector() created!!");
      }
      
      public function get driveLetter() : String
      {
         return _driveLetter;
      }
      
      private function handleTimer(param1:TimerEvent) : void
      {
         var _loc3_:IDeviceConnectionHandler = null;
         var _loc2_:String = _mdmManager.mdmSystem.execStdOut("cmd /C Utils\\ConsoleDeviceInterface.exe 2>&1");
         _loc2_ = StringUtil.trim(_loc2_);
         if(_loc2_ != _lastConnectionString)
         {
            log("handleTimer(): deviceDetectionString changed: " + _loc2_);
            _lastConnectionString = _loc2_;
         }
         if("" == _loc2_)
         {
            return;
         }
         for each(_loc3_ in _handlers[IDeviceConnectionHandler])
         {
            if(_loc2_ != "DISCONNECTED")
            {
               _driveLetter = _loc2_;
               _driveLetter = StringUtil.rtrim(_driveLetter);
               _driveLetter = _driveLetter.replace(/\\\\/g,"\\");
               _loc3_.handleDeviceConnected(_loc2_);
            }
            else
            {
               _loc3_.handleDeviceDisconnected();
            }
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceConnectionDetector>> " + param1);
      }
      
      public function stopDeviceCheck() : void
      {
         _timer.reset();
      }
      
      public function addDeviceConnectionHandler(param1:IDeviceConnectionHandler) : void
      {
         _handlers[IDeviceConnectionHandler][param1] = param1;
      }
      
      public function startDeviceCheck() : void
      {
         _timer.start();
      }
      
      public function removeDeviceConnectionHandler(param1:IDeviceConnectionHandler) : void
      {
         delete _handlers[IDeviceConnectionHandler][param1];
      }
   }
}

