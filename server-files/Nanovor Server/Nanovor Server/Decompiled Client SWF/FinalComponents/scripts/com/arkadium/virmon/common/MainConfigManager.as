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
         this.log("getSetting: " + param1);
         if(this._settings[param1] == null)
         {
            return "";
         }
         return this._settings[param1];
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         this.log("onLoaderComplete");
         this._loader.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         this.parseXML(this._loader.data);
         if(this._chainLoader != null)
         {
            this._chainLoader.handleChainLoadeeComplete();
            this._chainLoader = null;
         }
      }
      
      public function load() : void
      {
         this.log("load()");
         this.loadConfigurationFile();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> MainConfigManager: " + param1);
      }
      
      private function loadConfigurationFile() : void
      {
         this._loader = new URLLoader();
         this._loader.addEventListener(Event.COMPLETE,this.onLoaderComplete,false,0,true);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError,false,0,true);
         this._loader.load(new URLRequest(this.CONFIG_FILE));
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         this._chainLoader = param1;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** MainConfigManager: " + param1);
      }
      
      public function get name() : String
      {
         return this.NAME;
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
            this._settings[szKey] = szValue;
            i++;
         }
         return true;
      }
      
      private function onLoaderError(param1:IOErrorEvent) : void
      {
         this.logError("onLoaderError: " + param1.text);
         this._loader.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
         this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         if(this._chainLoader != null)
         {
            this._chainLoader.handleChainLoadeeError();
            this._chainLoader = null;
         }
      }
   }
}

