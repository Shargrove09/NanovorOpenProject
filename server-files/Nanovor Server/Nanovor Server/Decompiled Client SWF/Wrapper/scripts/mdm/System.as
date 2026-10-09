package mdm
{
   public final class System
   {
      
      private static var resolver:mdm_System = null;
      
      public function System()
      {
         super();
      }
      
      public static function openCDTray(driveLetter:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().openCDTray(driveLetter);
      }
      
      public static function get linVerString() : String
      {
         return internal_resolver().linVerString;
      }
      
      public static function getDisplayModes() : Array
      {
         return internal_resolver().getDisplayModes();
      }
      
      public static function get macVerString() : String
      {
         return internal_resolver().macVerString;
      }
      
      public static function get winVerStringDetail() : String
      {
         return internal_resolver().winVerStringDetail;
      }
      
      public static function logOff(promptOption:String, messageText:String, syncFlag:Boolean) : void
      {
         internal_resolver().logOff(promptOption,messageText);
      }
      
      public static function execUnicode(exePath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().execUnicode(exePath);
      }
      
      public static function setWindowFocus(windowID:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().setWindowFocus(windowID);
      }
      
      public static function restart(promptOption:String, messageText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().restart(promptOption,messageText);
      }
      
      public static function exec(exePath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().exec(exePath);
      }
      
      public static function getMasterVolume() : Number
      {
         return internal_resolver().getMasterVolume();
      }
      
      public static function get VBScript() : mdm_resolver
      {
         return internal_resolver().VBScript;
      }
      
      public static function getTotalSpace(drive:String) : Number
      {
         return internal_resolver().getTotalSpace(drive);
      }
      
      public static function execStdOut(exePath:String) : String
      {
         return internal_resolver().execStdOut(exePath);
      }
      
      public static function setMasterVolume(volumeLevel:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().setMasterVolume(volumeLevel);
      }
      
      public static function get RAMSize() : Number
      {
         return internal_resolver().RAMSize;
      }
      
      public static function showTaskBar(syncFlag:Boolean = true) : void
      {
         internal_resolver().showTaskBar();
      }
      
      public static function getWindowList() : Array
      {
         return internal_resolver().getWindowList();
      }
      
      public static function get CPUSpeed() : Number
      {
         return internal_resolver().CPUSpeed;
      }
      
      public static function get winVerString() : String
      {
         return internal_resolver().winVerString;
      }
      
      public static function get CDDrive() : String
      {
         return internal_resolver().CDDrive;
      }
      
      public static function powerOff(promptOption:String, messageText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().powerOff(promptOption,messageText);
      }
      
      public static function hideTaskBar(syncFlag:Boolean = true) : void
      {
         internal_resolver().hideTaskBar();
      }
      
      public static function setResolution(resolutionX:Number, resolutionY:Number, refreshRate:Number = -1, displayDepth:Number = -1, syncFlag:Boolean = true) : void
      {
         internal_resolver().setResolution(resolutionX,resolutionY,refreshRate,displayDepth);
      }
      
      public static function closeCDTray(driveLetter:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().closeCDTray(driveLetter);
      }
      
      public static function getResolution() : Array
      {
         return internal_resolver().getResolution();
      }
      
      public static function get screenHeight() : Number
      {
         return internal_resolver().screenHeight;
      }
      
      public static function taskBarBlink(syncFlag:Boolean = true) : void
      {
         internal_resolver().taskBarBlink();
      }
      
      public static function get screenWidth() : Number
      {
         return internal_resolver().screenWidth;
      }
      
      public static function getVolumeName(volumeNumber:Number) : String
      {
         return internal_resolver().getVolumeName(volumeNumber);
      }
      
      public static function suspend(promptOption:String, messageText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().suspend(promptOption,messageText);
      }
      
      public static function setWallpaper(filePath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().setWallpaper(filePath);
      }
      
      public static function getNumberOfVolumes() : Number
      {
         return internal_resolver().getNumberOfVolumes();
      }
      
      public static function getFreeSpace(drive:String) : Number
      {
         return internal_resolver().getFreeSpace(drive);
      }
      
      public static function get isAdmin() : Boolean
      {
         return internal_resolver().isAdmin;
      }
      
      public static function get computerName() : String
      {
         return internal_resolver().computerName;
      }
      
      public static function postMessage(windowID:Number, messageNo:Number, wParam:Number, lParam:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().postMessage(windowID,messageNo,wParam,lParam);
      }
      
      private static function internal_resolver() : mdm_System
      {
         if(resolver == null)
         {
            resolver = new mdm_System();
         }
         return resolver;
      }
      
      public static function setWallpaperAlt(filePath:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().setWallpaperAlt(filePath);
      }
      
      public static function get JScript() : mdm_resolver
      {
         return internal_resolver().JScript;
      }
      
      public static function get Paths() : mdm_resolver
      {
         return internal_resolver().Paths;
      }
      
      public static function hibernate(promptOption:String, messageText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().hibernate(promptOption,messageText);
      }
      
      public static function get language() : String
      {
         return internal_resolver().language;
      }
      
      public static function get Registry() : mdm_resolver
      {
         return internal_resolver().Registry;
      }
      
      public static function get localTime() : String
      {
         return internal_resolver().localTime;
      }
      
      public static function setWaveBalance(volumeBalance:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().setWaveBalance(volumeBalance);
      }
      
      public static function get computerCompany() : String
      {
         return internal_resolver().computerCompany;
      }
      
      public static function sendMessage(windowID:Number, messageNo:Number, wParam:Number, lParam:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().sendMessage(windowID,messageNo,wParam,lParam);
      }
      
      public static function get computerOwner() : String
      {
         return internal_resolver().computerOwner;
      }
      
      public static function getWaveVolume() : Number
      {
         return internal_resolver().getWaveVolume();
      }
      
      public static function getHDSerial(drive:String) : String
      {
         return internal_resolver().getHDSerial(drive);
      }
      
      public static function get servicePack() : String
      {
         return internal_resolver().servicePack;
      }
      
      public static function get DirectX() : mdm_resolver
      {
         return internal_resolver().DirectX;
      }
      
      public static function getWaveBalance() : Number
      {
         return internal_resolver().getWaveBalance();
      }
      
      public static function setWaveVolume(volumeLevel:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().setWaveVolume(volumeLevel);
      }
      
      public static function shutDown(promptOption:String, messageText:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().shutDown(promptOption,messageText);
      }
      
      public static function setWaveVolumeAdv(leftVolumeLevel:Number, rightVolumeLevel:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().setWaveVolumeAdv(leftVolumeLevel,rightVolumeLevel);
      }
      
      public function mdm_System() : void
      {
      }
   }
}

import flash.utils.Proxy;

dynamic class mdm_System extends mdm_resolver
{
   
   public function mdm_System()
   {
      super();
      SetClassName("mdm.System");
      AddObject("DirectX",null);
      AddObject("JScript",null);
      AddObject("Paths",null);
      AddObject("Registry",null);
      AddObject("VBScript",null);
   }
}
