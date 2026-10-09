package com.arkadium.virmon.shared.mdm
{
   public interface IMDMBrowserController
   {
      
      function get y() : Number;
      
      function hide(param1:Boolean = false) : void;
      
      function get isBusy() : Boolean;
      
      function get browserKey() : MDMBrowserKey;
      
      function forward(param1:Boolean = false) : void;
      
      function get width() : Number;
      
      function stop(param1:Boolean = false) : void;
      
      function set width(param1:Number) : void;
      
      function set height(param1:Number) : void;
      
      function get favorites() : Array;
      
      function get title() : String;
      
      function get source() : String;
      
      function set url(param1:String) : void;
      
      function refresh(param1:Boolean = false) : void;
      
      function goto(param1:String, param2:Boolean = false) : void;
      
      function set visible(param1:Boolean) : void;
      
      function set onDocumentComplete(param1:Function) : void;
      
      function get height() : Number;
      
      function back(param1:Boolean = false) : void;
      
      function get url() : String;
      
      function set x(param1:Number) : void;
      
      function set y(param1:Number) : void;
      
      function set userAgent(param1:String) : void;
      
      function set source(param1:String) : void;
      
      function close(param1:Boolean = false) : void;
      
      function get visible() : Boolean;
      
      function destroy() : void;
      
      function show(param1:Boolean = false) : void;
      
      function get x() : Number;
   }
}

