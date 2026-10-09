package com.arkadium.virmon.state
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class StateLoader extends Loader
   {
      
      private var _target:DisplayObjectContainer;
      
      private var _sendToBack:Boolean = false;
      
      private var _currURL:String;
      
      public function StateLoader()
      {
         super();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** StateLoader: " + param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> StateLoader: " + param1);
      }
      
      private function handleLoadComplete(param1:Event) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,handleLoadComplete);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,handleLoadError);
         if(_sendToBack)
         {
            _target.addChildAt(contentLoaderInfo.content,0);
         }
         else
         {
            _target.addChild(contentLoaderInfo.content);
         }
         _sendToBack = false;
         _target.tabChildren = false;
         log("handleLoadComplete:: added child: " + contentLoaderInfo.content + " to _target: " + _target);
      }
      
      private function handleLoadError(param1:IOErrorEvent) : void
      {
         logError("handleLoadError(): " + param1.text);
         throw new IOError("Failed to load \'" + LoaderInfo(param1.currentTarget).url + "\' :" + param1.text);
      }
      
      public function loadState(param1:String, param2:DisplayObjectContainer, param3:Boolean = false, param4:Boolean = false) : void
      {
         _currURL = param1;
         _sendToBack = param3;
         contentLoaderInfo.addEventListener(Event.COMPLETE,handleLoadComplete,false,1);
         contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleLoadError);
         log("  --> loadState: url=" + param1);
         if(null == param1 || 0 == param1.length)
         {
            logError("loadState(): Parameter \'url\' cannot be null or empty.");
            throw new Error("Parameter \'url\' cannot be null or empty.");
         }
         if(null == param2)
         {
            logError("loadState(): Parameter \'target\' cannot be null.");
            throw new Error("Parameter \'target\' cannot be null.");
         }
         _target = param2;
         if(param4)
         {
            load(new URLRequest(param1),new LoaderContext(false,ApplicationDomain.currentDomain));
         }
         else
         {
            load(new URLRequest(param1));
         }
      }
   }
}

