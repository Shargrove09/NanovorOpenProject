package com.arkadium.virmon.evogame
{
   import com.arkadium.virmon.shared.final.elements.GenericEM;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol624")]
   public class HopperTray extends MovieClip
   {
      
      private static const HOPPER_X:int = 113;
      
      private static const HOPPER_Y:int = 15;
      
      private static const HOPPER_X_SPACING:int = 10;
      
      private static const HOPPER_Y_SPACING:int = 4;
      
      private static const HOPPERS_PER_ROW:int = 6;
      
      private var _hoppers:Array;
      
      private var _evoGameUI:IEvoGameStateUI;
      
      private var _draggingId:int;
      
      private var _ems:Array;
      
      private var _totalHoppers:int;
      
      public function HopperTray(param1:IEvoGameStateUI)
      {
         super();
         _evoGameUI = param1;
      }
      
      private function getHopper(param1:int) : Hopper
      {
         var _loc2_:int = 0;
         while(_loc2_ < _hoppers.length)
         {
            if(_hoppers[_loc2_].getID() == param1)
            {
               return _hoppers[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function onEMLetGo(param1:GenericEM) : void
      {
         lockHoppers(false);
         if(_draggingId > -1)
         {
            getHopper(_draggingId).onEMLetGo(param1);
            _draggingId = -1;
         }
         else if(Boolean(param1) && param1.getID() > -1)
         {
            getHopper(param1.getID()).onEMLetGo(param1);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> Evolution Game >> Hopper Tray: " + param1);
      }
      
      public function reset() : void
      {
         makeHoppers();
      }
      
      public function setEMs(param1:Array) : void
      {
         _ems = param1;
         _totalHoppers = _ems.length;
         makeHoppers();
      }
      
      private function makeHoppers() : void
      {
         var _loc4_:Hopper = null;
         clearHoppers();
         _hoppers = new Array();
         var _loc1_:int = HOPPER_X;
         var _loc2_:int = HOPPER_Y;
         var _loc3_:int = 0;
         while(_loc3_ < _totalHoppers)
         {
            _loc4_ = new Hopper(this,_ems[_loc3_]);
            addChild(_loc4_);
            _loc4_.x = _loc1_;
            _loc4_.y = _loc2_;
            _hoppers.push(_loc4_);
            _loc1_ += 112 + HOPPER_X_SPACING;
            if(_loc3_ == HOPPERS_PER_ROW - 1)
            {
               _loc1_ = HOPPER_X;
               _loc2_ += _loc4_.height + HOPPER_Y_SPACING;
            }
            _loc3_++;
         }
      }
      
      private function clearHoppers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Hopper = null;
         if(_hoppers != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _hoppers.length)
            {
               _loc2_ = _hoppers[_loc1_];
               removeChild(_loc2_);
               _loc2_ = null;
               _loc1_++;
            }
         }
      }
      
      public function lockHoppers(param1:Boolean = true) : void
      {
         var _loc3_:Hopper = null;
         var _loc2_:int = 0;
         while(_loc2_ < _totalHoppers)
         {
            _loc3_ = _hoppers[_loc2_];
            _loc3_.lock(param1);
            _loc2_++;
         }
      }
      
      public function onEMPress(param1:GenericEM) : void
      {
         lockHoppers(true);
         _draggingId = param1.getID();
         _evoGameUI.onEMPress(param1);
      }
   }
}

