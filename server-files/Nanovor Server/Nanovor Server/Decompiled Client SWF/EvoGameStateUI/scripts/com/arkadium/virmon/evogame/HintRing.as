package com.arkadium.virmon.evogame
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol483")]
   public class HintRing extends MovieClip
   {
      
      private var _lamps:Array;
      
      public var mcHintAnim:MovieClip;
      
      public function HintRing()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function showHint(param1:int, param2:int) : void
      {
         var _loc4_:HintRingLamp = null;
         var _loc3_:int = 0;
         while(_loc3_ < _lamps.length)
         {
            _loc4_ = _lamps[_loc3_];
            if(param1 > 0)
            {
               _loc4_.gotoAndStop("greenEnd");
               param1--;
            }
            else if(param2 > 0)
            {
               _loc4_.gotoAndStop("yellowEnd");
               param2--;
            }
            else
            {
               _loc4_.gotoAndStop("redEnd");
            }
            addChild(_loc4_);
            _loc3_++;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      public function makeLamps(param1:int) : *
      {
         var _loc2_:* = undefined;
         var _loc6_:HintRingLamp = null;
         _lamps = new Array();
         var _loc3_:* = 360 / param1;
         var _loc4_:int = 24;
         switch(param1)
         {
            case 3:
               _loc2_ = -150;
               break;
            case 4:
               _loc2_ = 135;
               break;
            case 5:
               _loc2_ = 155;
               break;
            case 6:
               _loc2_ = 150;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < param1)
         {
            _loc6_ = new HintRingLamp();
            _loc6_.x = _loc4_ * Math.cos((_loc2_ + _loc5_ * _loc3_) * Math.PI / 180);
            _loc6_.y = _loc4_ * Math.sin((_loc2_ + _loc5_ * _loc3_) * Math.PI / 180);
            _loc6_.rotation = _loc3_ * _loc5_ - (360 - _loc2_);
            addChild(_loc6_);
            _lamps.push(_loc6_);
            _loc5_++;
         }
         gotoAndStop(param1);
      }
      
      public function showWin() : void
      {
         mcHintAnim.gotoAndPlay("success");
      }
   }
}

