package com.arkadium.communications
{
   import com.arkadium.virmon.shared.utils.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.Dictionary;
   
   public class WebClientManager extends EventDispatcher implements IChainLoadee
   {
      
      private static var _instance:WebClientManager;
      
      private static const NAME:String = "WebClientManager";
      
      private static const WEB_CLIENT_SETTINGS_URL:String = "Config/WebClient.xml";
      
      private var _dictionaryWebHooks:Dictionary;
      
      private var _chainLoader:IChainLoader;
      
      public function WebClientManager(param1:Function = null)
      {
         super();
         if(param1 != WebClientManager.getInstance)
         {
            throw new Error("WebClientManager singleton exception: cannot instantiate outside of this class");
         }
         if(null != WebClientManager._instance)
         {
            throw new Error("Only one WebClientManager instance should be instantiated");
         }
      }
      
      public static function getInstance() : WebClientManager
      {
         if(null == _instance)
         {
            _instance = new WebClientManager(arguments.callee);
         }
         return WebClientManager._instance;
      }
      
      public function setChainLoader(param1:IChainLoader) : void
      {
         this._chainLoader = param1;
      }
      
      public function getWebClientHookUrl(param1:String) : String
      {
         var url:String = null;
         var hookName:String = param1;
         try
         {
            url = this._dictionaryWebHooks[hookName].url;
            return url;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function load() : void
      {
         this._dictionaryWebHooks = new Dictionary();
         this.loadWebClientSettings();
      }
      
      public function get name() : String
      {
         return NAME;
      }
      
      public function getWebClientHookToken(param1:String) : Boolean
      {
         var token:Boolean = false;
         var hookName:String = param1;
         try
         {
            token = Boolean(this._dictionaryWebHooks[hookName].token);
            return token;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      private function handleWebClientSettingsLoadError(param1:IOErrorEvent) : void
      {
         if(this._chainLoader != null)
         {
            this._chainLoader.handleChainLoadeeError();
            this._chainLoader = null;
         }
      }
      
      private function handleWebClientSettingsLoadComplete(param1:Event) : void
      {
         var _loc5_:Object = null;
         var _loc7_:Boolean = false;
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         IEventDispatcher(param1.currentTarget).removeEventListener(IOErrorEvent.IO_ERROR,this.handleWebClientSettingsLoadError);
         var _loc3_:XML = new XML(param1.target.data);
         var _loc4_:XMLList = _loc3_.hooks.hook;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length())
         {
            _loc5_ = new Object();
            _loc5_.url = _loc4_[_loc6_].@url.toString();
            _loc5_.type = _loc4_[_loc6_].@type.toString();
            _loc7_ = false;
            if(_loc4_[_loc6_].@token.toString() == "true")
            {
               _loc7_ = true;
            }
            _loc5_.token = _loc7_;
            this._dictionaryWebHooks[_loc4_[_loc6_].@name.toString()] = _loc5_;
            _loc6_++;
         }
         if(this._chainLoader != null)
         {
            this._chainLoader.handleChainLoadeeComplete();
            this._chainLoader = null;
         }
      }
      
      private function loadWebClientSettings() : void
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.handleWebClientSettingsLoadComplete);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.handleWebClientSettingsLoadError);
         _loc1_.load(new URLRequest(WEB_CLIENT_SETTINGS_URL));
      }
      
      public function getWebClientHookType(param1:String) : String
      {
         var type:String = null;
         var hookName:String = param1;
         try
         {
            type = this._dictionaryWebHooks[hookName].type;
            return type;
         }
         catch(e:Error)
         {
         }
         return null;
      }
   }
}

