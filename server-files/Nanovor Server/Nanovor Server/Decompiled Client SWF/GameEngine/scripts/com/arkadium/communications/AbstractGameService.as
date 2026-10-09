package com.arkadium.communications
{
   import com.arkadium.communications.handlers.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.*;
   
   public class AbstractGameService implements IGameService, ILoginResultHandler
   {
      
      protected var _gameServiceConnection:IGameServiceConnection;
      
      protected var _handlers:Dictionary;
      
      private var _gameServiceInitializedHandler:IGameServiceInitializedHandler;
      
      public function AbstractGameService(param1:IGameServiceConnection)
      {
         super();
         _gameServiceConnection = param1;
         createHandlersDictionary();
      }
      
      public function destroy() : void
      {
         _gameServiceInitializedHandler = null;
         _gameServiceConnection.destroy();
      }
      
      public function get isConnected() : Boolean
      {
         throw new Error("Method \'get isConnected\' is abstract and must be implemented in subclasses.");
      }
      
      protected function removeHandler(param1:Class, param2:Object) : void
      {
         if(null == _handlers)
         {
            throw new Error("AbstractGameService.removeAllHandlers(): _handlers cannot be null: did you forget to instantiate _handlers in createHandlersDictionary()?");
         }
         if(null == _handlers[param1])
         {
            return;
         }
         delete _handlers[param1][param2];
      }
      
      protected function removeAllHandlers(param1:Class) : void
      {
         var _loc2_:Object = null;
         if(null == _handlers)
         {
            throw new Error("AbstractGameService.removeAllHandlers(): _handlers cannot be null: did you forget to instantiate _handlers in createHandlersDictionary()?");
         }
         if(null == _handlers[param1])
         {
            return;
         }
         for each(_loc2_ in _handlers[param1])
         {
            if(_loc2_ is param1)
            {
               delete _handlers[param1][_loc2_];
            }
         }
      }
      
      public function init(param1:IGameServiceInitializedHandler) : void
      {
         DebugLog.instance.log("AbstractGameService.init()");
         if(null == param1)
         {
            throw new Error("AbstractGameService.init(): Parameter \"handler\" cannot be null.");
         }
         _gameServiceInitializedHandler = param1;
         _gameServiceConnection.loginToGameService(ILoginResultHandler(this));
      }
      
      protected function addHandler(param1:Class, param2:Object) : void
      {
         if(null == _handlers)
         {
            throw new Error("AbstractGameService.removeAllHandlers(): _handlers cannot be null: did you forget to instantiate _handlers in createHandlersDictionary()?");
         }
         if(null == _handlers[param1])
         {
            throw new Error("AbstractGameService.addHandler(): _handlers[Type] is null.");
         }
         _handlers[param1][param2] = param2;
      }
      
      protected function createHandlersDictionary() : void
      {
         throw new Error("Method \'createHandlersDictionary\' is abstract and must be implemented in subclasses.");
      }
      
      public function disconnect() : void
      {
         _gameServiceConnection.disconnect();
      }
      
      public function handleLoginResult(param1:Object = null) : void
      {
         DebugLog.instance.log("AbstractGameService.handleLoginResult()");
         if(LoginResultType.LOGIN_SUCCESS == LoginResultType(param1.loginResultType))
         {
            DebugLog.instance.log("AbstractGameService.handleLoginResult(): handling successful login...");
            if(null != _gameServiceInitializedHandler)
            {
               _gameServiceInitializedHandler.handleGameServiceInitialized();
            }
         }
         else
         {
            DebugLog.instance.log("Failed to login to game service.");
            _gameServiceInitializedHandler.handleGameServiceFailure("Failed to login to game service!");
         }
      }
   }
}

