package com.arkadium.virmon.shared.elements.icons.overrides
{
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.arkadium.virmon.shared.elements.icons.overrides.parts.OverridePartArmor;
   import com.arkadium.virmon.shared.elements.icons.overrides.parts.OverridePartBG;
   import com.arkadium.virmon.shared.elements.icons.overrides.parts.OverridePartDodge;
   import com.arkadium.virmon.shared.elements.icons.overrides.parts.OverridePartEnergy;
   import com.arkadium.virmon.shared.elements.icons.overrides.parts.OverridePartGloss;
   import com.arkadium.virmon.shared.elements.icons.overrides.parts.OverridePartSpeed;
   import com.arkadium.virmon.shared.elements.icons.overrides.parts.OverridePartStrength;
   import com.smithandtinker.nanovor.common.Stat;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class OverrideStat extends MovieClip
   {
      
      public static const OVERRIDE_ARMOR:int = 1;
      
      public static const OVERRIDE_ENERGY:int = 2;
      
      public static const OVERRIDE_SPEED:int = 4;
      
      public static const OVERRIDE_STRENGTH:int = 8;
      
      public static const OVERRIDE_DODGE:int = 16;
      
      private var _overrides:Sprite;
      
      private var _currentOverrides:int = 0;
      
      public function OverrideStat(param1:int = 0, param2:Boolean = false)
      {
         super();
         var _loc3_:OverridePartGloss = new OverridePartGloss();
         _overrides = new Sprite();
         var _loc4_:OverridePartBG = new OverridePartBG();
         if(param1 != 0)
         {
            addOverrides(param1,param2);
         }
         this.addChild(_loc4_);
         this.addChild(_overrides);
         this.addChild(_loc3_);
      }
      
      public static function statIndexesFromAttackStatements(param1:Array) : int
      {
         var _loc3_:* = undefined;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(_loc3_.type != AttackStatementTypes.TYPE_OVERRIDE)
            {
               continue;
            }
            switch(_loc3_.stat)
            {
               case Stat.DODGE_FAIL_PERCENTAGE:
                  return OVERRIDE_DODGE;
               case Stat.ARMOR:
               case Stat.ENERGY:
               case Stat.SPEED:
               case Stat.STRENGTH:
                  _loc2_ |= OverrideStat["OVERRIDE_" + _loc3_.stat.toUpperCase()];
                  break;
               case Stat.ENERGY_GENERATOR:
                  _loc2_ |= OVERRIDE_ENERGY;
            }
         }
         return _loc2_;
      }
      
      public function removeAllOverrides() : void
      {
         while(_overrides.numChildren > 0)
         {
            _overrides.removeChildAt(0);
         }
      }
      
      public function removeOverrides(param1:uint) : void
      {
         var _loc2_:int = 0;
         if((_currentOverrides & param1) != 0)
         {
            removeAllOverrides();
            _loc2_ = _currentOverrides & ~param1;
            _currentOverrides = 0;
            addOverrides(_loc2_);
         }
      }
      
      public function addOverrides(param1:int, param2:Boolean = false) : void
      {
         if((param1 & OVERRIDE_DODGE) == OVERRIDE_DODGE)
         {
            removeAllOverrides();
            _overrides.addChild(new OverridePartDodge());
            _currentOverrides = OVERRIDE_DODGE;
            if(param2)
            {
               stopSpinners();
            }
            return;
         }
         var _loc3_:int = _currentOverrides & param1;
         var _loc4_:int = _loc3_ ^ param1;
         if((_loc4_ & OVERRIDE_ARMOR) == OVERRIDE_ARMOR)
         {
            _overrides.addChild(new OverridePartArmor());
         }
         if((_loc4_ & OVERRIDE_ENERGY) == OVERRIDE_ENERGY)
         {
            _overrides.addChild(new OverridePartEnergy());
         }
         if((_loc4_ & OVERRIDE_SPEED) == OVERRIDE_SPEED)
         {
            _overrides.addChild(new OverridePartSpeed());
         }
         if((_loc4_ & OVERRIDE_STRENGTH) == OVERRIDE_STRENGTH)
         {
            _overrides.addChild(new OverridePartStrength());
         }
         if(param2)
         {
            stopSpinners();
         }
         _currentOverrides |= param1;
      }
      
      private function stopSpinners() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < _overrides.numChildren)
         {
            if(Boolean(_overrides.getChildAt(_loc1_) as Sprite))
            {
               _loc2_ = _overrides.getChildAt(_loc1_) as Sprite;
               if(Boolean(_loc2_.getChildAt(0) as MovieClip))
               {
                  _loc3_ = _loc2_.getChildAt(0) as MovieClip;
                  _loc3_.gotoAndStop(1);
               }
            }
            _loc1_++;
         }
      }
   }
}

