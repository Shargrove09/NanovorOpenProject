package com.arkadium.virmon.device
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class LoadProgressUpdater implements ILoadProgressUpdater
   {
      
      private var _currentItemIndex:int;
      
      private var _lastStatusTextLine:String;
      
      private var _loadProgressMonitor:ILoadProgressMonitor;
      
      private var _totalItems:int;
      
      private var _weights:Array;
      
      public function LoadProgressUpdater(param1:int, param2:ILoadProgressMonitor, param3:Array = null)
      {
         var _loc4_:uint = 0;
         super();
         _weights = param3;
         if(null != _weights)
         {
            if(_weights.length != param1)
            {
               throw new Error("Number of weights does not match number of total items.");
            }
         }
         else
         {
            _weights = new Array();
            _loc4_ = 0;
            while(_loc4_ < param1)
            {
               _weights.push(1);
               _loc4_++;
            }
         }
         _currentItemIndex = 0;
         _totalItems = param1;
         _loadProgressMonitor = param2;
      }
      
      private function refreshProgress(param1:Number) : void
      {
         var _loc2_:Number = getWeightedProgress(param1);
         _loadProgressMonitor.updateProgress(_loc2_);
         if(null != _lastStatusTextLine)
         {
            _loadProgressMonitor.replaceLastStatusTextLine(_lastStatusTextLine.replace(/...[0-9]+%/,"..." + Number(_loc2_ * 100).toFixed(2) + "%"));
         }
         if(1 == param1)
         {
            if(null != _lastStatusTextLine)
            {
               _loadProgressMonitor.replaceLastStatusTextLine(_lastStatusTextLine.replace(/...[0-9]+%/,"...COMPLETE"));
            }
            ++_currentItemIndex;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<LoadProgressUpdater>> " + param1);
      }
      
      private function getWeightTotal() : Number
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = 0;
         for each(_loc2_ in _weights)
         {
            _loc1_ += _loc2_;
         }
         return _loc1_;
      }
      
      public function addStatusTextLine(param1:String) : void
      {
         _lastStatusTextLine = param1;
         _loadProgressMonitor.addStatusTextLine(param1);
      }
      
      private function getWeightedProgress(param1:Number) : Number
      {
         if(_currentItemIndex >= _totalItems)
         {
            return 1;
         }
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         while(_loc3_ < _currentItemIndex)
         {
            _loc2_ += _weights[_loc3_];
            _loc3_++;
         }
         return (param1 * Number(_weights[_currentItemIndex]) + _loc2_) / getWeightTotal();
      }
      
      public function updateCurrentItemProgress(param1:Number) : void
      {
         refreshProgress(param1);
      }
      
      public function handleItemCompleted() : void
      {
         refreshProgress(1);
      }
   }
}

