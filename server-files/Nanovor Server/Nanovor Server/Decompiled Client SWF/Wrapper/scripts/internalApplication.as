package
{
   import flash.display.Sprite;
   
   public final class internalApplication
   {
      
      private var resolver:mdm_Application = null;
      
      public function internalApplication()
      {
         super();
      }
      
      public function set onAppExit(callback:Function) : void
      {
         internal_resolver().onAppExit = callback;
      }
      
      public function set onFormMinimize(callback:Function) : void
      {
         internal_resolver().onFormMinimize = callback;
      }
      
      public function delay(delayValue:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().delay(delayValue);
      }
      
      public function doEvents(syncFlag:Boolean = true) : void
      {
         internal_resolver().doEvents();
      }
      
      public function get Screensaver() : mdm_resolver
      {
         return internal_resolver().Screensaver;
      }
      
      public function set onFormChangeFocus(callback:Function) : void
      {
         internal_resolver().onFormChangeFocus = callback;
      }
      
      public function get isMinimized() : Boolean
      {
         return internal_resolver().isMinimized;
      }
      
      public function exitWithModalResult(modalResult:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().exitWithModalResult(modalResult);
      }
      
      public function restore(syncFlag:Boolean = true) : void
      {
         internal_resolver().restore();
      }
      
      public function init(dispObj:Sprite, onInitCallback:Function = null) : void
      {
         internal_resolver().init(dispObj,onInitCallback);
      }
      
      public function exitWithCode(exitCode:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().exitWithCode(exitCode);
      }
      
      public function set onBottomHit(callback:Function) : void
      {
         internal_resolver().onBottomHit = callback;
      }
      
      public function set onDragDrop(callback:Function) : void
      {
         internal_resolver().onDragDrop = callback;
      }
      
      public function bringToFront(syncFlag:Boolean = true) : void
      {
         internal_resolver().bringToFront();
      }
      
      public function shake(shakeTime:Number, syncFlag:Boolean = true) : void
      {
         internal_resolver().shake(shakeTime);
      }
      
      public function minimizeToTray(enabledFlag:Boolean, syncFlag:Boolean = true) : void
      {
         internal_resolver().minimizeToTray(enabledFlag);
      }
      
      public function set onAppMinimize(callback:Function) : void
      {
         internal_resolver().onAppMinimize = callback;
      }
      
      public function get Library() : mdm_resolver
      {
         return internal_resolver().Library;
      }
      
      public function set onTopHit(callback:Function) : void
      {
         internal_resolver().onTopHit = callback;
      }
      
      public function set onFormRestore(callback:Function) : void
      {
         internal_resolver().onFormRestore = callback;
      }
      
      public function minimize(syncFlag:Boolean = true) : void
      {
         internal_resolver().minimize();
      }
      
      public function get filename() : String
      {
         return internal_resolver().filename;
      }
      
      public function setProxyUsername(strUsername:String) : void
      {
         internal_resolver().setProxyUsername(strUsername);
      }
      
      public function exit(opt:String = "", message:String = "", syncFlag:Boolean = true) : void
      {
         internal_resolver().exit(opt,message);
      }
      
      public function getCMDParams(cmdId:Number) : String
      {
         return internal_resolver().getCMDParams(cmdId);
      }
      
      public function get Timer() : mdm_resolver
      {
         return internal_resolver().Timer;
      }
      
      public function getFormNames() : Array
      {
         return internal_resolver().getFormNames();
      }
      
      public function switchFullScreen(enable:Boolean) : void
      {
         internal_resolver().switchFullScreen(enable);
      }
      
      public function set title(titleText:String) : void
      {
         internal_resolver().title = titleText;
      }
      
      public function sendToBack(syncFlag:Boolean = true) : void
      {
         internal_resolver().sendToBack();
      }
      
      public function get path() : String
      {
         var internalPath:String = null;
         var dblBackslash:RegExp = null;
         var isNetworkPath:Boolean = false;
         internalPath = internal_resolver().path;
         dblBackslash = /\\\\/g;
         isNetworkPath = internalPath.indexOf("\\\\") == 0;
         return (isNetworkPath ? "\\" : "") + internalPath.replace(dblBackslash,"\\");
      }
      
      public function set onFormResize(callback:Function) : void
      {
         internal_resolver().onFormResize = callback;
      }
      
      public function get filenameUnix() : String
      {
         return internal_resolver().filenameUnix;
      }
      
      public function getHttpProxyPort() : String
      {
         return internal_resolver().getHttpProxyPort();
      }
      
      public function printVar(textToPrint:String, showPrintDialog:Boolean = false, syncFlag:Boolean = true) : void
      {
         internal_resolver().printVar(textToPrint,showPrintDialog);
      }
      
      public function set onRightHit(callback:Function) : void
      {
         internal_resolver().onRightHit = callback;
      }
      
      private function internal_resolver() : mdm_Application
      {
         if(resolver == null)
         {
            resolver = new mdm_Application();
         }
         return resolver;
      }
      
      public function enableExitHandler(syncFlag:Boolean = true) : void
      {
         internal_resolver().enableExitHandler();
      }
      
      public function maximize(syncFlag:Boolean = true) : void
      {
         internal_resolver().maximize();
      }
      
      public function get pathUnix() : String
      {
         return internal_resolver().pathUnix;
      }
      
      public function getGlobalVar(varName:String) : String
      {
         return internal_resolver().getGlobalVar(varName);
      }
      
      public function get Kiosk() : mdm_resolver
      {
         return internal_resolver().Kiosk;
      }
      
      public function set onAppChangeFocus(callback:Function) : void
      {
         internal_resolver().onAppChangeFocus = callback;
      }
      
      public function showTips(tips:String) : Boolean
      {
         return internal_resolver().showTips(tips);
      }
      
      public function get filenameUnicode() : String
      {
         return internal_resolver().filenameUnicode;
      }
      
      public function set onAppRestore(callback:Function) : void
      {
         internal_resolver().onAppRestore = callback;
      }
      
      public function getHttpsProxyPort() : String
      {
         return internal_resolver().getHttpsProxyPort();
      }
      
      public function getHttpsProxyServer() : String
      {
         return internal_resolver().getHttpsProxyServer();
      }
      
      public function set onFormMaximize(callback:Function) : void
      {
         internal_resolver().onFormMaximize = callback;
      }
      
      public function createForm(formName:String, formType:String, swfPath:String, x:Number, y:Number, width:Number, height:Number) : Boolean
      {
         return internal_resolver().createForm(formName,formType,swfPath,x,y,width,height);
      }
      
      public function set onLeftHit(callback:Function) : void
      {
         internal_resolver().onLeftHit = callback;
      }
      
      public function set onArrowKeyPress(callback:Function) : void
      {
         internal_resolver().onArrowKeyPress = callback;
      }
      
      public function set onSplashClosed(callback:Function) : void
      {
         internal_resolver().onSplashClosed = callback;
      }
      
      public function setProxyPassword(strPassword:String) : void
      {
         internal_resolver().setProxyPassword(strPassword);
      }
      
      public function set onMDMScriptException(callback:Function) : void
      {
         internal_resolver().onMDMScriptException = callback;
      }
      
      public function set onFormClose(callback:Function) : void
      {
         internal_resolver().onFormClose = callback;
      }
      
      public function say(text2speech:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().say(text2speech);
      }
      
      public function exitWithDialog(message:String, syncFlag:Boolean) : void
      {
         internal_resolver().exitWithDialog(message);
      }
      
      public function getEnvVar(varName:String) : String
      {
         return internal_resolver().getEnvVar(varName);
      }
      
      public function getHttpProxyServer() : String
      {
         return internal_resolver().getHttpProxyServer();
      }
      
      public function textAreaEnhance(enhanceFlag:Boolean, syncFlag:Boolean = true) : void
      {
         internal_resolver().textAreaEnhance(enhanceFlag);
      }
      
      public function get Trial() : mdm_resolver
      {
         return internal_resolver().Trial;
      }
      
      public function get pathUnicode() : String
      {
         var internalPath:String = null;
         var dblBackslash:RegExp = null;
         var isNetworkPath:Boolean = false;
         internalPath = internal_resolver().path;
         dblBackslash = /\\\\/g;
         isNetworkPath = internalPath.indexOf("\\\\") == 0;
         return (isNetworkPath ? "\\" : "") + internalPath.replace(dblBackslash,"\\");
      }
      
      public function getSecureVar(varName:String) : String
      {
         return internal_resolver().getSecureVar(varName);
      }
      
      public function setEnvVar(variableName:String, variableValue:String, syncFlag:Boolean = true) : void
      {
         internal_resolver().setEnvVar(variableName,variableValue);
      }
      
      public function set onFormReposition(callback:Function) : void
      {
         internal_resolver().onFormReposition = callback;
      }
   }
}

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.ByteArray;
import flash.utils.Proxy;
import mdm.Alert2;

dynamic class mdm_Application extends mdm_resolver
{
   
   private var m_onInitCallback:Function = null;
   
   private var m_bInitDispatched:Boolean = false;
   
   public function mdm_Application()
   {
      super();
      SetClassName("mdm.Application");
      AddEvents();
      AddObject("Library",null);
      AddObject("Screensaver",null);
      AddObject("Timer",new mdm_Timer());
      AddObject("Trial",null);
      AddObject("Kiosk",null);
   }
   
   public function init(dispObj:Sprite, onInitCallback:Function = null) : void
   {
      var strURL:String = null;
      strURL = null;
      try
      {
         strURL = dispObj.root.loaderInfo.url;
      }
      catch(e:Error)
      {
      }
      finally
      {
         if(strURL == null)
         {
            try
            {
               var _loc6_:* = §§pop();
               strURL = (dispObj as Object).url;
            }
            catch(e:Error)
            {
            }
         }
      }
      AssocURL(strURL);
      mdmSetup();
      m_spr = dispObj;
      Alert2.init(dispObj.stage);
      if(onInitCallback != null)
      {
         m_onInitCallback = onInitCallback;
         dispObj.addEventListener("enterFrame",onInitialise);
      }
   }
   
   private function onInitialise(evt:Event) : void
   {
      if(!m_bInitDispatched && m_onInitCallback != null)
      {
         m_bInitDispatched = true;
         m_onInitCallback();
      }
   }
   
   private function AddEvents() : void
   {
      AddEvent("onAppChangeFocus",true);
      AddEvent("onAppExit",false);
      AddEvent("onAppMinimize",false);
      AddEvent("onAppRestore",false);
      AddEvent("onArrowKeyPress",true);
      AddEvent("onBottomHit",false);
      AddEvent("onDragDrop",true);
      AddEvent("onFormChangeFocus",true);
      AddEvent("onFormClose",false);
      AddEvent("onFormMaximize",true);
      AddEvent("onFormMinimize",true);
      AddEvent("onFormReposition",true);
      AddEvent("onFormResize",true);
      AddEvent("onFormRestore",true);
      AddEvent("onLeftHit",false);
      AddEvent("onMDMScriptException",true);
      AddEvent("onRightHit",false);
      AddEvent("onSplashClosed",false);
      AddEvent("onTopHit",false);
   }
}

dynamic class mdm_Timer extends mdm_resolver
{
   
   public function mdm_Timer()
   {
      super();
      SetClassName("mdm.Application.Timer");
      AddEvents();
   }
   
   private function AddEvents() : void
   {
      AddEvent("onTimer0",false);
      AddEvent("onTimer1",false);
      AddEvent("onTimer2",false);
      AddEvent("onTimer3",false);
      AddEvent("onTimer4",false);
      AddEvent("onTimer5",false);
      AddEvent("onTimer6",false);
      AddEvent("onTimer7",false);
      AddEvent("onTimer8",false);
      AddEvent("onTimer9",false);
      AddEvent("onTimer10",false);
   }
}

class Base64
{
   
   private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
   
   public function Base64()
   {
      super();
      throw new Error("Base64 class is static container only");
   }
   
   public static function encode(data:String) : String
   {
      var bytes:ByteArray = null;
      bytes = new ByteArray();
      bytes.writeUTFBytes(data);
      return encodeByteArray(bytes);
   }
   
   public static function decodeToByteArray(data:String) : ByteArray
   {
      var output:ByteArray = null;
      var dataBuffer:Array = null;
      var outputBuffer:Array = null;
      var i:uint = 0;
      var j:uint = 0;
      var k:uint = 0;
      output = new ByteArray();
      dataBuffer = new Array(4);
      outputBuffer = new Array(3);
      for(i = 0; i < data.length; i += 4)
      {
         j = 0;
         while(j < 4 && i + j < data.length)
         {
            dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
            j++;
         }
         outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
         outputBuffer[1] = ((dataBuffer[1] & 0x0F) << 4) + ((dataBuffer[2] & 0x3C) >> 2);
         outputBuffer[2] = ((dataBuffer[2] & 3) << 6) + dataBuffer[3];
         for(k = 0; k < outputBuffer.length; k++)
         {
            if(dataBuffer[k + 1] == 64)
            {
               break;
            }
            output.writeByte(outputBuffer[k]);
         }
      }
      output.position = 0;
      return output;
   }
   
   public static function encodeByteArray(data:ByteArray) : String
   {
      var output:String = null;
      var dataBuffer:Array = null;
      var outputBuffer:Array = null;
      var i:uint = 0;
      var j:uint = 0;
      var k:uint = 0;
      output = "";
      outputBuffer = new Array(4);
      data.position = 0;
      while(data.bytesAvailable > 0)
      {
         dataBuffer = new Array();
         i = 0;
         while(i < 3 && data.bytesAvailable > 0)
         {
            dataBuffer[i] = data.readUnsignedByte();
            i++;
         }
         outputBuffer[0] = (dataBuffer[0] & 0xFC) >> 2;
         outputBuffer[1] = (dataBuffer[0] & 3) << 4 | dataBuffer[1] >> 4;
         outputBuffer[2] = (dataBuffer[1] & 0x0F) << 2 | dataBuffer[2] >> 6;
         outputBuffer[3] = dataBuffer[2] & 0x3F;
         for(j = dataBuffer.length; j < 3; j++)
         {
            outputBuffer[j + 1] = 64;
         }
         for(k = 0; k < outputBuffer.length; k++)
         {
            output += BASE64_CHARS.charAt(outputBuffer[k]);
         }
      }
      return output;
   }
   
   public static function decode(data:String) : String
   {
      var bytes:ByteArray = null;
      bytes = decodeToByteArray(data);
      return bytes.readUTFBytes(bytes.length);
   }
}
