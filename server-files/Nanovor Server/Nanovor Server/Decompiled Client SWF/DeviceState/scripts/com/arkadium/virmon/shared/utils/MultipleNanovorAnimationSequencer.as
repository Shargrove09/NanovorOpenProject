package com.arkadium.virmon.shared.utils
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class MultipleNanovorAnimationSequencer
   {
      
      private var _sequencers:Array;
      
      public function MultipleNanovorAnimationSequencer(param1:uint)
      {
         super();
         _sequencers = new Array();
         var _loc2_:uint = 0;
         while(_loc2_ < param1)
         {
            _sequencers.push(new NanovorAnimationSequencer());
            _loc2_++;
         }
      }
      
      public function addAnimation(param1:Array, param2:Object = null) : void
      {
         if(param1.length != _sequencers.length)
         {
            logError("Number of animations and number of sequencers do not match");
         }
         var _loc3_:int = Math.min(param1.length,_sequencers.length);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _sequencers[_loc4_].addAnimation(param1[_loc4_],param2);
            _loc4_++;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<MultipleNanovorAnimationSequencer>>\t" + param1);
      }
      
      public function setSpeed(param1:Number) : void
      {
         var _loc2_:NanovorAnimationSequencer = null;
         for each(_loc2_ in _sequencers)
         {
            _loc2_.setSpeed(param1);
         }
      }
      
      public function stop() : void
      {
         var _loc1_:NanovorAnimationSequencer = null;
         for each(_loc1_ in _sequencers)
         {
            _loc1_.stop();
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<MultipleNanovorAnimationSequencer>>\t" + param1);
      }
      
      public function setDefaultAnimation(param1:Array, param2:Object = null) : void
      {
         if(param1.length != _sequencers.length)
         {
            logError("Number of animations and number of sequencers do not match");
         }
         var _loc3_:int = Math.min(param1.length,_sequencers.length);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _sequencers[_loc4_].setDefaultAnimation(param1[_loc4_],param2);
            _loc4_++;
         }
      }
      
      public function addInterruptAnimation(param1:Array, param2:Object = null) : void
      {
         if(param1.length != _sequencers.length)
         {
            logError("Number of animations and number of sequencers do not match");
         }
         var _loc3_:int = Math.min(param1.length,_sequencers.length);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _sequencers[_loc4_].addInterruptAnimation(param1[_loc4_],param2);
            _loc4_++;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:NanovorAnimationSequencer = null;
         for each(_loc1_ in _sequencers)
         {
            _loc1_.destroy();
         }
      }
      
      public function play() : void
      {
         var _loc1_:NanovorAnimationSequencer = null;
         for each(_loc1_ in _sequencers)
         {
            _loc1_.play();
         }
      }
      
      public function getCount() : int
      {
         return _sequencers.length;
      }
      
      public function clearAnimationQueue() : void
      {
         var _loc1_:NanovorAnimationSequencer = null;
         for each(_loc1_ in _sequencers)
         {
            _loc1_.clearAnimationQueue();
         }
      }
      
      public function getSequencer(param1:int) : NanovorAnimationSequencer
      {
         if(param1 >= _sequencers.length)
         {
            return null;
         }
         return _sequencers[param1];
      }
   }
}

