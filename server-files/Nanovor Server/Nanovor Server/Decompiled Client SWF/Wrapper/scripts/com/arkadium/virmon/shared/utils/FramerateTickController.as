package com.arkadium.virmon.shared.utils
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class FramerateTickController extends Sprite
   {
      
      private static var _instance:FramerateTickController;
      
      private static const DEFAULT_FRAMERATE:int = 30;
      
      private var _consumers:Dictionary;
      
      public function FramerateTickController(param1:Enforcer)
      {
         super();
         _consumers = new Dictionary(true);
      }
      
      public static function getInstance() : FramerateTickController
      {
         if(_instance == null)
         {
            _instance = new FramerateTickController(new Enforcer());
         }
         return FramerateTickController._instance;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:IFramerateTickConsumer = null;
         for each(_loc2_ in _consumers)
         {
            _loc2_.tick();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<FramerateTickController>>\t" + param1);
      }
      
      public function addConsumer(param1:IFramerateTickConsumer) : void
      {
         _consumers[param1] = param1;
         if(!this.hasEventListener(Event.ENTER_FRAME))
         {
            this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
         }
      }
      
      public function removeConsumer(param1:IFramerateTickConsumer) : void
      {
         delete _consumers[param1];
         if(dictLength() == 0)
         {
            this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         }
      }
      
      private function dictLength() : int
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         for(_loc2_ in _consumers)
         {
            _loc1_++;
         }
         return _loc1_;
      }
   }
}

class Enforcer
{
   
   public function Enforcer()
   {
      super();
   }
}
