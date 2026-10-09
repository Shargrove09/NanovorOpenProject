package com.arkadium.virmon.senseibattle
{
   import flash.utils.Dictionary;
   
   public class AbstractHandler
   {
      
      protected var _handlers:Dictionary;
      
      public function AbstractHandler(param1:Array)
      {
         var _loc2_:Class = null;
         super();
         _handlers = new Dictionary();
         for each(_loc2_ in param1)
         {
            _handlers[_loc2_] = new Dictionary(true);
         }
      }
      
      protected function addHandler(param1:Class, param2:Object) : void
      {
         if(null == _handlers)
         {
            throw new Error("AbstractHandler.removeAllHandlers(): _handlers cannot be null: did you forget to instantiate _handlers in createHandlersDictionary()?");
         }
         if(null == _handlers[param1])
         {
            throw new Error("AbstractHandler.addHandler(): _handlers[Type] is null.");
         }
         _handlers[param1][param2] = param2;
      }
      
      protected function removeAllHandlers(param1:Class) : void
      {
         var _loc2_:Object = null;
         if(null == _handlers)
         {
            throw new Error("AbstractHandler.removeAllHandlers(): _handlers cannot be null: did you forget to instantiate _handlers in createHandlersDictionary()?");
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
      
      protected function removeHandler(param1:Class, param2:Object) : void
      {
         if(null == _handlers)
         {
            throw new Error("AbstractHandler.removeAllHandlers(): _handlers cannot be null: did you forget to instantiate _handlers in createHandlersDictionary()?");
         }
         if(null == _handlers[param1])
         {
            return;
         }
         delete _handlers[param1][param2];
      }
   }
}

