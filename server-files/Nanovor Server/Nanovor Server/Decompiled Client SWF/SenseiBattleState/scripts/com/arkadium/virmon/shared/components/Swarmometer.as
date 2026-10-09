package com.arkadium.virmon.shared.components
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.utils.Utils;
   import flash.display.Sprite;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol10")]
   public class Swarmometer extends Sprite implements ISwarmometer
   {
      
      private var _metersContainer:Sprite;
      
      private var _meters:Array = new Array();
      
      private const MAX_WIDTH:int = 153;
      
      private const OFFSET_X:int = 39;
      
      private const OFFSET_Y:int = 3;
      
      private var _bInView:Boolean = true;
      
      private const SPACING_X:int = -5;
      
      public function Swarmometer()
      {
         super();
         _metersContainer = new Sprite();
         addChild(_metersContainer);
         hide();
      }
      
      public function setNanovorInfo(param1:String, param2:int, param3:String = "", param4:String = "", param5:int = 1) : void
      {
         var _loc7_:int = 0;
         var _loc6_:SwarmHealthMeter = findMeterById(param1);
         if(_loc6_ == null)
         {
            _loc7_ = _meters.length - 1;
            while(_loc7_ > -1)
            {
               _loc6_ = _meters[_loc7_];
               if(_loc6_.assetId == SwarmHealthMeter.UNKNOWN_NANOVOR_ID)
               {
                  _loc6_.assetId = param1;
                  _loc6_.maxHealth = param5;
                  _loc6_.health = param2;
                  _loc6_.masterName = param3;
                  _loc6_.nickName = param4;
                  break;
               }
               _loc7_--;
            }
            if(_loc6_ == null)
            {
               throw new Error("Could not find nanovor, and there is no place for it to be set!");
            }
         }
         else
         {
            _loc6_.health = param2;
         }
      }
      
      public function hide() : void
      {
         if(!_bInView)
         {
            return;
         }
         _bInView = false;
         visible = false;
      }
      
      private function getXPoints(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:Number = MAX_WIDTH / param1 - (param1 - 1) * SPACING_X / param1;
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc2_.push(OFFSET_X + _loc4_ * (_loc3_ + SPACING_X));
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function setSwarmCount(param1:int, param2:int) : void
      {
         var _loc5_:SwarmHealthMeter = null;
         if(_meters.length > 0)
         {
            clearMeters();
         }
         var _loc3_:Number = MAX_WIDTH / param1 - (param1 - 1) * SPACING_X / param1;
         var _loc4_:Array = getXPoints(param1);
         var _loc6_:int = 0;
         while(_loc6_ < param1)
         {
            _loc5_ = new SwarmHealthMeter();
            _loc5_.popupOffset = param2;
            _loc5_.sortTieBreaker = _loc6_;
            _loc5_.width = _loc3_;
            _loc5_.x = _loc4_[_loc6_];
            _loc5_.y = OFFSET_Y;
            _metersContainer.addChild(_loc5_);
            _meters.push(_loc5_);
            _loc6_++;
         }
      }
      
      public function get METER_POPUPS_OFFSET_ALT_LEFT() : int
      {
         return SwarmHealthMeter.POPUP_OFFSET_ALT_LEFT;
      }
      
      public function sortMeters(param1:Number = 0.7, param2:Number = 0.5) : void
      {
         _meters.sortOn(["healthRatio","sortTieBreaker"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         var _loc3_:Array = getXPoints(_meters.length);
         var _loc4_:int = 0;
         while(_loc4_ < _meters.length)
         {
            Tweener.addTween(_meters[_loc4_],{
               "x":_loc3_[_loc4_],
               "delay":param1,
               "time":param2,
               "transition":"easeOutQuad"
            });
            _meters[_loc4_].sortTieBreaker = _loc4_;
            _loc4_++;
         }
      }
      
      private function findMeterById(param1:String) : SwarmHealthMeter
      {
         var _loc2_:SwarmHealthMeter = null;
         for each(_loc2_ in _meters)
         {
            if(_loc2_.assetId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function get METER_POPUPS_OFFSET_DEFAULT() : int
      {
         return SwarmHealthMeter.POPUP_OFFSET_DEFAULT;
      }
      
      public function clearMeters() : void
      {
         var _loc1_:SwarmHealthMeter = null;
         if(_meters.length == 0)
         {
            return;
         }
         Utils.RemoveChildrenTweens(_metersContainer);
         while(_meters.length > 0)
         {
            _loc1_ = _meters.pop();
            _loc1_.destroy();
            if(_metersContainer.contains(_loc1_))
            {
               _metersContainer.removeChild(_loc1_);
            }
         }
      }
      
      public function setMySwarmInfo(param1:Array) : void
      {
         var _loc2_:SwarmHealthMeter = null;
         if(param1.length != _meters.length)
         {
            throw new Error("Swarm array length is not equal to the meters count, set earlier!");
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            setNanovorInfo(param1[_loc3_].id,param1[_loc3_].health,param1[_loc3_].mastername,param1[_loc3_].nickname,param1[_loc3_].health);
            _loc3_++;
         }
         sortMeters(0,0);
      }
      
      public function show() : void
      {
         var _loc1_:SwarmHealthMeter = null;
         var _loc2_:int = 0;
         if(_bInView)
         {
            return;
         }
         _bInView = true;
         for each(_loc1_ in _meters)
         {
            _loc1_.alpha = 0;
            _loc1_.visible = true;
         }
         visible = true;
         _loc2_ = 0;
         while(_loc2_ < _meters.length)
         {
            Tweener.addTween(_meters[_loc2_],{
               "alpha":1,
               "time":0.4,
               "delay":_loc2_ * 0.05,
               "transition":"easeOutQuad"
            });
            _loc2_++;
         }
      }
   }
}

