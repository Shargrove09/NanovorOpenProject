package com.arkadium.virmon.shared.mdm
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class MDMBrowserController implements IMDMBrowserController
   {
      
      private var _browserKey:MDMBrowserKey;
      
      private var _mdmManager:IMDMManager;
      
      private var _browser:*;
      
      public function MDMBrowserController(param1:IMDMManager, param2:MDMBrowserKey, param3:Number, param4:Number, param5:Number, param6:Number, param7:String, param8:Boolean, param9:Boolean = false)
      {
         var mdmManager:IMDMManager = param1;
         var key:MDMBrowserKey = param2;
         var x:Number = param3;
         var y:Number = param4;
         var width:Number = param5;
         var height:Number = param6;
         var url:String = param7;
         var showBorder:Boolean = param8;
         var skipAgentSetting:Boolean = param9;
         super();
         if(key == null)
         {
            throw new Error("Cannot instantiate MDMBrowserController with a null key.");
         }
         _mdmManager = mdmManager;
         _browserKey = key;
         try
         {
            if(skipAgentSetting)
            {
               _browser = new _mdmManager.mdmBrowser(x,y,width,height,url,showBorder);
            }
            else
            {
               _browser = new _mdmManager.mdmBrowser(x,y,width,height,"about:blank",showBorder);
               userAgent = "NanoBrowser";
               goto(url);
            }
         }
         catch(e:Error)
         {
            logError("Error trying to instantiate new mdm.Browser(): " + e.message);
         }
      }
      
      public function set y(param1:Number) : void
      {
         setProp("y",param1);
      }
      
      public function stop(param1:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.stop(param1);
         }
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.close(param1);
         }
      }
      
      public function set width(param1:Number) : void
      {
         setProp("width",param1);
      }
      
      private function setProp(param1:String, param2:*) : void
      {
         if(_browser == null)
         {
            return;
         }
         _browser[param1] = param2;
      }
      
      public function get visible() : Boolean
      {
         return getProp("visible") as Boolean;
      }
      
      public function get browserKey() : MDMBrowserKey
      {
         return _browserKey;
      }
      
      public function get source() : String
      {
         return getProp("source") as String;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** MDMBrowserController: " + param1);
      }
      
      public function get height() : Number
      {
         return getProp("height") as Number;
      }
      
      public function set source(param1:String) : void
      {
         setProp("source",param1);
      }
      
      public function hide(param1:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.hide(param1);
         }
      }
      
      public function get isBusy() : Boolean
      {
         return getProp("isBusy") as Boolean;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> MDMBrowserController: " + param1);
      }
      
      public function get width() : Number
      {
         return getProp("width") as Number;
      }
      
      public function forward(param1:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.forward(param1);
         }
      }
      
      public function set height(param1:Number) : void
      {
         setProp("height",param1);
      }
      
      public function get title() : String
      {
         return getProp("title") as String;
      }
      
      private function getProp(param1:String) : *
      {
         if(_browser == null || _browser[param1] === undefined)
         {
            return null;
         }
         return _browser[param1];
      }
      
      public function refresh(param1:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.refresh(param1);
         }
      }
      
      public function get favorites() : Array
      {
         return getProp("favorites") as Array;
      }
      
      public function set url(param1:String) : void
      {
         setProp("url",param1);
      }
      
      public function set onDocumentComplete(param1:Function) : void
      {
         setProp("onDocumentComplete",param1);
      }
      
      public function back(param1:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.back(param1);
         }
      }
      
      public function goto(param1:String, param2:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.goto(param1,param2);
         }
      }
      
      public function set visible(param1:Boolean) : void
      {
         setProp("visible",param1);
      }
      
      public function get url() : String
      {
         return getProp("url") as String;
      }
      
      public function set x(param1:Number) : void
      {
         setProp("x",param1);
      }
      
      public function set userAgent(param1:String) : void
      {
         setProp("userAgent",param1);
      }
      
      public function get x() : Number
      {
         return getProp("x") as Number;
      }
      
      public function get y() : Number
      {
         return getProp("y") as Number;
      }
      
      public function destroy() : void
      {
         stop();
         close();
         _browser = null;
      }
      
      public function show(param1:Boolean = false) : void
      {
         if(_browser != null)
         {
            _browser.show(param1);
         }
      }
   }
}

