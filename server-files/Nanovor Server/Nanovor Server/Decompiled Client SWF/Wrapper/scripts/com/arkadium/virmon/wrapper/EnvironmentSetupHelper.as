package com.arkadium.virmon.wrapper
{
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.shared.utils.Environment;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.system.Capabilities;
   
   internal class EnvironmentSetupHelper
   {
      
      public function EnvironmentSetupHelper()
      {
         super();
      }
      
      private function getFilePathDelimiter(param1:String) : String
      {
         var _loc2_:String = "/";
         switch(param1)
         {
            case Environment.OS_KEY_WINDOWS:
               _loc2_ = "\\";
         }
         return _loc2_;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> EnvironmentSetupHelper: " + param1);
      }
      
      private function getOSName(param1:String, param2:*) : String
      {
         var _loc4_:String = null;
         var _loc3_:String = "NA";
         switch(param1)
         {
            case Environment.OS_KEY_MAC:
               _loc3_ = "MacOS";
               break;
            case Environment.OS_KEY_LINUX:
               _loc3_ = "Linux";
               break;
            case Environment.OS_KEY_WINDOWS:
               _loc3_ = "Windows";
               _loc4_ = param2.winVerString;
               if(_loc4_.indexOf("Longhorn") > 0)
               {
                  _loc4_ = "Vista";
               }
               else if(_loc4_.indexOf("XP") > 0)
               {
                  _loc4_ = "XP";
               }
               _loc3_ += " " + _loc4_;
         }
         return _loc3_;
      }
      
      private function getLocale(param1:String, param2:*, param3:*) : String
      {
         var _loc5_:String = null;
         var _loc4_:String = "NA";
         switch(param1)
         {
            case Environment.OS_KEY_MAC:
               if(param3 != null)
               {
                  param3.exec("locale|grep LANG|cut –f2 –d\"|cut –f1 –d.");
                  _loc4_ = param3.output;
               }
               break;
            case Environment.OS_KEY_WINDOWS:
               _loc5_ = param2.Registry.loadMultiSz(2,"\\Control Panel\\International","LocaleName");
               _loc4_ = _loc5_.substr(0,5);
         }
         return _loc4_;
      }
      
      public function setGlobalEnvironmentVars(param1:IMDMManager) : *
      {
         log("setGlobalEnvironmentVars()");
         Environment.osKey = getOSKey();
         Environment.osName = getOSName(Environment.osKey,param1.mdmSystem);
         Environment.osVersion = getOSVersion(Environment.osKey,param1.mdmSystem);
         Environment.osLocale = getLocale(Environment.osKey,param1.mdmSystem,param1.mdmMacShell);
         Environment.osBitType = getOSBitType(Environment.osKey,param1.mdmSystem);
         Environment.localPathDelimeter = getFilePathDelimiter(Environment.osKey);
         Environment.localApplicationPath = param1.mdmApplication.path;
         log(Environment.dumpVars());
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** EnvironmentSetupHelper: " + param1);
      }
      
      private function getOSKey() : String
      {
         var _loc1_:String = Capabilities.os.substr(0,3).toLowerCase();
         switch(_loc1_)
         {
            case Environment.OS_KEY_MAC:
            case Environment.OS_KEY_LINUX:
            case Environment.OS_KEY_WINDOWS:
               break;
            default:
               _loc1_ = Environment.OS_KEY_UNRECOGNIZED;
         }
         return _loc1_;
      }
      
      private function getOSBitType(param1:String, param2:*) : String
      {
         var _loc3_:String = "NA";
         if(param1 == Environment.OS_KEY_WINDOWS)
         {
            _loc3_ = param2.Registry.loadMultiSz(3,"\\SYSTEM\\ControlSet001\\Control\\Session Manager\\Environment","PROCESSOR_ARCHITECTURE");
            if(_loc3_.indexOf("86") >= 0)
            {
               _loc3_ = "32-bit";
            }
            else if(_loc3_.indexOf("64") >= 0)
            {
               _loc3_ = "64-bit";
            }
         }
         return _loc3_;
      }
      
      private function getOSVersion(param1:String, param2:*) : String
      {
         var _loc4_:String = null;
         var _loc3_:String = "NA";
         switch(param1)
         {
            case Environment.OS_KEY_MAC:
               _loc3_ = param2.macVerString;
               break;
            case Environment.OS_KEY_WINDOWS:
               _loc4_ = param2.servicePack;
               switch(_loc4_)
               {
                  case "Service Pack 1":
                     _loc3_ = "SP1";
                     break;
                  case "Service Pack 2":
                     _loc3_ = "SP2";
                     break;
                  default:
                     _loc3_ = "SP0";
               }
         }
         return _loc3_;
      }
   }
}

