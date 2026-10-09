package com.arkadium.virmon.evogame
{
   import com.arkadium.virmon.shared.final.elements.GenericEM;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol503")]
   public class Circuit extends MovieClip
   {
      
      private var _evoGameUI:IEvoGameStateUI;
      
      public var hintRing:HintRing;
      
      private const START_X:int = 30;
      
      private const WIDTH:int = 480;
      
      public var mcSwitch:MovieClip;
      
      public var solidPath:MovieClip;
      
      public var dashedPath:MovieClip;
      
      private var _clamps:Array;
      
      public function Circuit(param1:IEvoGameStateUI, param2:int, param3:int)
      {
         super();
         _evoGameUI = param1;
         dashedPath.x -= param3 * 22;
         mcSwitch.gotoAndStop(1);
         dashedPath.stop();
         hintRing.makeLamps(param2);
         makeClamps(param2);
      }
      
      public function openClamps() : void
      {
         var _loc2_:EMClamp = null;
         var _loc1_:int = 0;
         while(_loc1_ < _clamps.length)
         {
            _loc2_ = _clamps[_loc1_];
            _loc2_.openClamp();
            _loc1_++;
         }
         lightSwitch("yellow");
      }
      
      public function updateLights() : void
      {
         if(getArray() == null)
         {
            lightSwitch("yellow");
         }
         else
         {
            lightSwitch("green");
         }
      }
      
      public function burnClamps(param1:Boolean) : void
      {
         var _loc3_:EMClamp = null;
         if(param1)
         {
            hintRing.showWin();
            dashedPath.gotoAndPlay("success");
            solidPath.gotoAndPlay("success");
         }
         else
         {
            lightSwitch("red");
            dashedPath.gotoAndPlay("burn");
         }
         var _loc2_:int = 0;
         while(_loc2_ < _clamps.length)
         {
            _loc3_ = _clamps[_loc2_];
            _loc3_.burnClamp(param1);
            _loc2_++;
         }
      }
      
      public function getTypeArray() : Array
      {
         var _loc3_:GenericEM = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < _clamps.length)
         {
            _loc3_ = _clamps[_loc2_].getEM();
            if(_loc3_ == null)
            {
               return null;
            }
            _loc1_.push(_loc3_.getID());
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function switched() : void
      {
         mcSwitch.gotoAndStop(2);
      }
      
      public function getArray() : Array
      {
         var _loc3_:GenericEM = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < _clamps.length)
         {
            _loc3_ = _clamps[_loc2_].getEM();
            if(_loc3_ == null)
            {
               return null;
            }
            _loc1_.push(_loc3_.assetId);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function showHint(param1:int, param2:int) : void
      {
         hintRing.showHint(param1,param2);
      }
      
      private function makeClamps(param1:int) : void
      {
         var _loc3_:EMClamp = null;
         _clamps = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            _loc3_ = new EMClamp(this);
            _loc3_.x = START_X + _loc2_ * (WIDTH / (param1 - 1));
            _loc3_.y = -10;
            _clamps.push(_loc3_);
            addChild(_loc3_);
            _loc2_++;
         }
      }
      
      public function rolloverClamp(param1:EMClamp = null) : void
      {
         var _loc3_:EMClamp = null;
         var _loc2_:int = 0;
         while(_loc2_ < _clamps.length)
         {
            _loc3_ = _clamps[_loc2_];
            if(_loc3_ != param1 && _loc3_.isOpen && _loc3_.rolledOver)
            {
               _loc3_.rollOut();
            }
            if(_loc3_ == param1 && !_loc3_.rolledOver)
            {
               _loc3_.rollOver();
            }
            _loc2_++;
         }
      }
      
      private function lightSwitch(param1:String) : void
      {
         mcSwitch.mcLights.gotoAndStop(param1);
      }
      
      public function onEMPress(param1:GenericEM) : void
      {
         _evoGameUI.onEMPress(param1);
      }
      
      public function getSwitch() : MovieClip
      {
         return mcSwitch;
      }
   }
}

