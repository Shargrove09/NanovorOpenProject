package com.arkadium.virmon.shared.final.components.actionslot
{
   import caurina.transitions.Tweener;
   import caurina.transitions.properties.ColorShortcuts;
   import com.arkadium.virmon.battle.control.IAttack;
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.EnergyUseShield;
   import com.arkadium.virmon.shared.elements.icons.actions.*;
   import com.arkadium.virmon.shared.elements.icons.overrides.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ActionSlotComponent extends MovieClip
   {
      
      public static const WIDTH:Number = 180;
      
      public static const HEIGHT:Number = 50;
      
      public static const BACKGROUND_COLOR_BLUE:uint = 2340070;
      
      public static const BACKGROUND_COLOR_RED:uint = 16711680;
      
      public static const BACKGROUND_COLOR_GREEN:uint = 9288235;
      
      public static const BACKGROUND_STATE_CLEAR:int = 50;
      
      public static const BACKGROUND_STATE_OPAQUE:int = 0;
      
      public static const BACKGROUND_STATE_SOLID:int = -50;
      
      private static const MAX_NUM_ICONS:int = 5;
      
      private static const ICON_TYPE_SORT_SEQUENCE:Array = [Icon.STAT_HEALTH,Icon.STAT_STRENGTH,Icon.STAT_ARMOR,Icon.STAT_SPEED,Icon.STAT_ENERGY];
      
      private static const GLOW_TWEEN_SECONDS:Number = 1;
      
      private static const TITLE_MASK_HIDE_X:int = -184;
      
      private static const TITLE_MASK_SHOW_X:int = -4;
      
      private static const ICON_WIDTH:int = 20;
      
      private static const ICON_PADDING:int = 2;
      
      private static const BACKGROUND_TWEEN_SECONDS:Number = 1;
      
      private static const ENERGY_COST_NUM_DIGITS:int = 2;
      
      private static const COLOR_TWEEN_SECONDS:Number = 1;
      
      public var mcActionIcon:MovieClip;
      
      public var tfEnergyCost:TextField;
      
      public var mcGlowingActionTitleMask:MovieClip;
      
      public var mcCostText:MovieClip;
      
      public var mcIconContainer:MovieClip;
      
      public var mcEnergyIcon:MovieClip;
      
      private var _aIcons:Array = new Array();
      
      private var _disabled:Boolean = false;
      
      public var tfGlowingActionTitle:TextField;
      
      public var mcLine:MovieClip;
      
      private var _attack:IAttack;
      
      public var tfActionTitle:TextField;
      
      public var mcActionIconGlow:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public function ActionSlotComponent(param1:IAttack = null)
      {
         super();
         _attack = param1;
         mcEnergyIcon.addChild(new EnergyUseShield());
         this.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
         this.buttonMode = true;
         this.mouseChildren = false;
      }
      
      public static function compareAttackStatements(param1:IAttackStatement, param2:IAttackStatement) : int
      {
         if(param1.target == AttackStatementTypes.TARGET_MY_NANOVOR || param1.target == AttackStatementTypes.TARGET_MY_TEAM)
         {
            if(param2.target == AttackStatementTypes.TARGET_MY_NANOVOR || param2.target == AttackStatementTypes.TARGET_MY_TEAM)
            {
               return 0;
            }
            return -1;
         }
         if(param2.target == AttackStatementTypes.TARGET_MY_NANOVOR || param2.target == AttackStatementTypes.TARGET_MY_TEAM)
         {
            return 1;
         }
         return 0;
      }
      
      public function addIcon(param1:String, param2:String = "", param3:String = "") : void
      {
         var _loc4_:ActionSlotStatIconComponent = null;
         if(_aIcons.length == MAX_NUM_ICONS)
         {
            return;
         }
         switch(param1)
         {
            case "":
            case null:
               return;
            default:
               _loc4_ = new ActionSlotStatIconComponent(param1,param2,param3);
               mcIconContainer.addChild(_loc4_);
               _aIcons.push(_loc4_);
               update();
               return;
         }
      }
      
      public function set backgroundState(param1:int) : void
      {
         Tweener.removeTweens(mcBackground,"y");
         switch(param1)
         {
            case BACKGROUND_STATE_CLEAR:
               Tweener.addTween(mcBackground,{
                  "y":BACKGROUND_STATE_CLEAR,
                  "time":BACKGROUND_TWEEN_SECONDS,
                  "rounded":true
               });
               break;
            case BACKGROUND_STATE_OPAQUE:
               Tweener.addTween(mcBackground,{
                  "y":BACKGROUND_STATE_OPAQUE,
                  "time":BACKGROUND_TWEEN_SECONDS,
                  "rounded":true
               });
               break;
            case BACKGROUND_STATE_SOLID:
               Tweener.addTween(mcBackground,{
                  "y":BACKGROUND_STATE_SOLID,
                  "time":BACKGROUND_TWEEN_SECONDS,
                  "rounded":true
               });
               break;
            default:
               return;
         }
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         _aIcons.sort(sortBy);
         var _loc2_:int = int(_aIcons.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(!mcIconContainer.contains(_aIcons[_loc1_]))
            {
               mcIconContainer.addChild(_aIcons[_loc1_]);
            }
            _aIcons[_loc1_].x = (ICON_WIDTH + ICON_PADDING) * _loc1_;
            mcIconContainer.addChild(_aIcons[_loc1_]);
            _loc1_++;
         }
      }
      
      public function set iconGlow(param1:Boolean) : void
      {
         Tweener.removeTweens(mcActionIconGlow,"alpha");
         if(param1)
         {
            if(mcActionIcon.numChildren > 0)
            {
               Tweener.addTween(mcActionIconGlow,{
                  "alpha":1,
                  "time":GLOW_TWEEN_SECONDS
               });
            }
         }
         else
         {
            Tweener.addTween(mcActionIconGlow,{
               "alpha":0,
               "time":GLOW_TWEEN_SECONDS
            });
         }
      }
      
      public function set color(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc4_:ActionSlotStatIconComponent = null;
         Tweener.removeTweens(mcBackground,"_color");
         Tweener.removeTweens(mcLine,"_color");
         Tweener.removeTweens(mcActionIconGlow,"_color");
         Tweener.removeTweens(tfGlowingActionTitle,"_color");
         Tweener.addTween(mcBackground,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(mcLine,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(mcActionIconGlow,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         Tweener.addTween(tfGlowingActionTitle,{
            "_color":param1,
            "time":COLOR_TWEEN_SECONDS
         });
         var _loc3_:int = int(_aIcons.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _aIcons[_loc2_] as ActionSlotStatIconComponent;
            if(_loc4_.selfAttack)
            {
               Tweener.removeTweens(_loc4_.getSelfAttackMC(),"_color");
               Tweener.addTween(_loc4_.getSelfAttackMC(),{
                  "_color":param1,
                  "time":COLOR_TWEEN_SECONDS
               });
            }
            _loc2_++;
         }
      }
      
      public function set titleGlow(param1:Boolean) : void
      {
         Tweener.removeTweens(mcGlowingActionTitleMask,"x");
         if(param1)
         {
            Tweener.addTween(mcGlowingActionTitleMask,{
               "x":0,
               "time":GLOW_TWEEN_SECONDS
            });
         }
         else
         {
            Tweener.addTween(mcGlowingActionTitleMask,{
               "x":TITLE_MASK_HIDE_X,
               "time":GLOW_TWEEN_SECONDS
            });
         }
      }
      
      public function get icons() : Array
      {
         return _aIcons;
      }
      
      public function get attack() : IAttack
      {
         return _attack;
      }
      
      public function set actionIcon(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc4_:Sprite = null;
         var _loc3_:int = 0;
         if(Boolean(param1 as Array))
         {
            _loc2_ = param1[0];
            _loc3_ = int(param1[1]);
         }
         else
         {
            _loc2_ = String(param1);
         }
         switch(_loc2_)
         {
            case Icon.ACTION_ACID:
               _loc4_ = new ActionAcid();
               break;
            case Icon.ACTION_ANTIMATTER:
               _loc4_ = new ActionAntimatter();
               break;
            case Icon.ACTION_CRYSTAL:
               _loc4_ = new ActionCrystal();
               break;
            case Icon.ACTION_ELECTRIC:
               _loc4_ = new ActionElectric();
               break;
            case Icon.ACTION_ENERGY:
               _loc4_ = new ActionEnergy();
               break;
            case Icon.ACTION_FIRE:
               _loc4_ = new ActionFire();
               break;
            case Icon.ACTION_HACK:
               _loc4_ = new ActionHack();
               break;
            case Icon.ACTION_ICE:
               _loc4_ = new ActionIce();
               break;
            case Icon.ACTION_MELEE:
               _loc4_ = new ActionMelee();
               break;
            case Icon.ACTION_MOD:
               _loc4_ = new ActionMod();
               break;
            case Icon.ACTION_PASS:
               _loc4_ = new ActionPass();
               break;
            case Icon.ACTION_POISON:
               _loc4_ = new ActionPoison();
               break;
            case Icon.ACTION_PSYCHIC:
               _loc4_ = new ActionPsychic();
               break;
            case Icon.ACTION_SWAP:
               _loc4_ = new ActionSwap();
               break;
            case Icon.OVERRIDE_BLUESPIKE:
               _loc4_ = new OverrideSpikeBlue(true);
               break;
            case Icon.OVERRIDE_REDSPIKE:
               _loc4_ = new OverrideSpikeRed(true);
               break;
            case Icon.OVERRIDE_YELLOWSPIKE:
               _loc4_ = new OverrideSpikeYellow(true);
               break;
            case Icon.ACTION_OVERRIDE:
               _loc4_ = new OverrideStat(_loc3_,true);
               break;
            default:
               return;
         }
         continue loop0;
      }
      
      private function sortBy(param1:ActionSlotStatIconComponent, param2:ActionSlotStatIconComponent) : int
      {
         var _loc3_:int = 0;
         if(param1.selfAttack && !param2.selfAttack)
         {
            return -1;
         }
         if(!param1.selfAttack && param2.selfAttack)
         {
            return 1;
         }
         var _loc4_:int = int(ICON_TYPE_SORT_SEQUENCE.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1.type != param2.type)
            {
               if(param1.type == ICON_TYPE_SORT_SEQUENCE[_loc3_])
               {
                  return -1;
               }
               if(param2.type == ICON_TYPE_SORT_SEQUENCE[_loc3_])
               {
                  return 1;
               }
            }
            _loc3_++;
         }
         return 0;
      }
      
      public function hideEnergy() : void
      {
         tfEnergyCost.visible = false;
         mcEnergyIcon.visible = false;
         mcCostText.visible = false;
      }
      
      public function set icons(param1:Array) : void
      {
         _aIcons = param1;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         _disabled = param1;
         if(param1)
         {
            ColorShortcuts._brightness_set(this,-0.5,[true]);
            ColorShortcuts._saturation_set(this,0.5,[false]);
         }
         else
         {
            ColorShortcuts._brightness_set(this,0,[true]);
            ColorShortcuts._saturation_set(this,1,[false]);
         }
      }
      
      public function set energyCost(param1:int) : void
      {
         tfEnergyCost.text = String(param1);
      }
      
      public function get disabled() : Boolean
      {
         return _disabled;
      }
      
      public function set title(param1:String) : void
      {
         tfActionTitle.text = param1;
         tfGlowingActionTitle.text = param1;
      }
   }
}

