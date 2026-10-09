package com.arkadium.virmon.common
{
   import com.arkadium.virmon.shared.utils.IChainLoadee;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class MainConfigManager extends EventDispatcher implements IChainLoadee
   {
      
      private static var _instance:MainConfigManager;
      
      private const CONFIG_FILE:String = "Config/MainConfig.xml";
      
      private var _settings:Dictionary = new Dictionary();
      
      private var _loader:URLLoader;
      
      private var _chainLoader:IChainLoader;
      
      private const NAME:String = "MainConfigManager";
      
      public function MainConfigManager()
      {
         super();
      }
      
      public static function getInstance() : MainConfigManager
      {
         if(_instance == null)
         {
            _instance = new MainConfigManager();
         }
         return _instance;
      }
      
      public function getSetting(param1:String) : String
      {
         log("getSetting: " + param1);
         if(_settings[param1] == null)
         {
            return "";
         }
         return _settings[param1];
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         log("onLoaderComplete");
         _loader.removeEventListener(Event.COMPLETE,onLoaderComplete);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR,onLoaderError);
         parseXML(_loader.data);
         if(_chainLoader != null)
         {
            _chainLoader.handleChainLoadeeComplete();
            _chainLoader = null;
         }
      }
      
      public function load() : void
      {
         log("load()");
         loadConfigurationFile();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> MainConfigManager: " + param1);
      }
      
      private function loadConfigurationFile() : void
      {
         _loader = new URLLoader();
         _loader.addEventListener(Event.COMPLETE,onLoaderComplete,false,0,true);
         _loader.addEventListener(IOErrorEvent.IO_ERROR,onLoaderError,false,0,true);
         _loader.load(new URLRequest(CONFIG_FILE));
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         _chainLoader = param1;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** MainConfigManager: " + param1);
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      private function parseXML(param1:*) : Boolean
      {
         var i:int;
         var szKey:String = null;
         var szValue:String = null;
         var xData:XML = null;
         var data:* = param1;
         try
         {
            xData = XML(data);
         }
         catch(e:Error)
         {
            logError("parseXML: Error parsing XML: " + e.message);
            return false;
         }
         i = 0;
         while(i < xData.setting.length())
         {
            szKey = xData.setting[i].@name;
            szValue = xData.setting[i].toString();
            _settings[szKey] = szValue;
            i++;
         }
         return true;
      }
      
      private function onLoaderError(param1:IOErrorEvent) : void
      {
         logError("onLoaderError: " + param1.text);
         _loader.removeEventListener(Event.COMPLETE,onLoaderComplete);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR,onLoaderError);
         if(_chainLoader != null)
         {
            _chainLoader.handleChainLoadeeError();
            _chainLoader = null;
         }
      }
   }
}

