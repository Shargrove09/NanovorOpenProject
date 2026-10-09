package com.arkadium.virmon.help.attackchooser.targetselect
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class HelpAttackChooserTargetSelectBG extends MovieClip
   {
      
      private static const CUTOUT_COORDS:Array = [[new Point(68,0)],[new Point(551,0)],[new Point(433,0),new Point(791,0)],[new Point(309,0),new Point(551,0),new Point(791,0)]];
      
      private var _cutOutCount:int;
      
      private var _isSelfTarget:Boolean;
      
      private var _cutOuts:Array;
      
      public var mcBG0:MovieClip;
      
      public var mcBG1:MovieClip;
      
      public var mcBG2:MovieClip;
      
      public var mcBG3:MovieClip;
      
      public function HelpAttackChooserTargetSelectBG(param1:int = 1, param2:Boolean = false)
      {
         super();
         _cutOutCount = param1;
         _isSelfTarget = param2;
         mcBG0.visible = false;
         mcBG1.visible = false;
         mcBG2.visible = false;
         mcBG3.visible = false;
         setCutOuts();
      }
      
      private function setCutOuts() : void
      {
         var _loc3_:HelpAttackChooserTargetSelectBGCutOut = null;
         if(_isSelfTarget)
         {
            this.mcBG0.visible = true;
            _cutOutCount = 0;
         }
         else
         {
            this["mcBG" + _cutOutCount].visible = true;
         }
         _cutOuts = new Array();
         var _loc1_:Array = CUTOUT_COORDS[_cutOutCount];
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new HelpAttackChooserTargetSelectBGCutOut();
            addChild(_loc3_);
            _loc3_.x = _loc1_[_loc2_].x;
            _loc3_.y = _loc1_[_loc2_].y;
            _cutOuts.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function revealCutOut(param1:int, param2:Number = 0) : void
      {
         Tweener.addTween(_cutOuts[param1],{
            "alpha":0,
            "time":0.5,
            "delay":param2,
            "transition":"linear"
         });
      }
      
      public function hideCutOut(param1:int, param2:Number = 0) : void
      {
         Tweener.addTween(_cutOuts[param1],{
            "alpha":1,
            "time":0.5,
            "delay":param2,
            "transition":"linear"
         });
      }
   }
}

