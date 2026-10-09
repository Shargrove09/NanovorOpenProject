package com.arkadium.virmon.shared.final.components.actionslot
{
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.hacks.*;
   import com.arkadium.virmon.shared.elements.icons.mods.*;
   import com.arkadium.virmon.shared.elements.icons.spikedattack.*;
   import com.arkadium.virmon.shared.elements.icons.stats.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol30")]
   public class ActionSlotStatIconComponent extends MovieClip
   {
      
      public static const WIDTH:Number = 20;
      
      private var _szType:String;
      
      public var mcSelfAttack:MovieClip;
      
      public var mcIcon:MovieClip;
      
      private var _bSelfAttack:Boolean;
      
      public var tfText:TextField;
      
      public function ActionSlotStatIconComponent(param1:String, param2:String = "", param3:String = "")
      {
         var _loc5_:Sprite = null;
         var _loc12_:SpikedAttack = null;
         var _loc13_:Array = null;
         super();
         var _loc4_:String = param1;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         if(_loc4_.substr(0,4) == "self")
         {
            _loc4_ = _loc4_.substr(4);
            _loc6_ = true;
         }
         if(_loc4_.substr(0,8) == "%Spiked%")
         {
            _loc7_ = true;
            _loc4_ = _loc4_.substr(8);
            if(_loc4_.substr(0,6) == "%Blue%")
            {
               _loc8_ = SpikedAttack.SPIKE_BLUE;
               _loc4_ = _loc4_.substr(6);
            }
            else if(_loc4_.substr(0,5) == "%Red%")
            {
               _loc8_ = SpikedAttack.SPIKE_RED;
               _loc4_ = _loc4_.substr(5);
            }
            else if(_loc4_.substr(0,8) == "%Yellow%")
            {
               _loc8_ = SpikedAttack.SPIKE_YELLOW;
               _loc4_ = _loc4_.substr(8);
            }
            if(_loc4_.substr(0,8) == "%Active%")
            {
               _loc9_ = true;
               _loc4_ = _loc4_.substr(8);
            }
            if(_loc4_.substr(0,11) == "%Evaluated%")
            {
               _loc10_ = true;
               _loc4_ = _loc4_.substr(11);
            }
         }
         else if(_loc4_.substr(0,18) == "%OtherConditional%")
         {
            _loc7_ = true;
            _loc4_ = _loc4_.substr(18);
            _loc8_ = SpikedAttack.OTHER_CONDITIONAL;
            if(_loc4_.substr(0,8) == "%Active%")
            {
               _loc9_ = true;
               _loc4_ = _loc4_.substr(8);
            }
            if(_loc4_.substr(0,11) == "%Evaluated%")
            {
               _loc10_ = true;
               _loc4_ = _loc4_.substr(11);
            }
         }
         var _loc11_:String = Icon.getAttackStatementIcon(param3,_loc4_);
         switch(_loc11_)
         {
            case Icon.STAT_ARMOR:
               _loc5_ = new StatArmor();
               break;
            case Icon.STAT_ENERGY:
               _loc5_ = new StatEnergy();
               break;
            case Icon.STAT_SPEED:
               _loc5_ = new StatSpeed();
               break;
            case Icon.STAT_STRENGTH:
               _loc5_ = new StatStrength();
               break;
            case Icon.STAT_HEALTH:
               _loc5_ = new StatHealth();
               break;
            case Icon.OVERRIDE_ARMOR:
               _loc5_ = new StatArmor();
               break;
            case Icon.OVERRIDE_HEALTH:
               _loc5_ = new StatHealth();
               break;
            case Icon.OVERRIDE_SPEED:
               _loc5_ = new StatSpeed();
               break;
            case Icon.OVERRIDE_STRENGTH:
               _loc5_ = new StatStrength();
               break;
            case Icon.OVERRIDE_ENERGY:
               _loc5_ = new StatEnergy();
               break;
            case Icon.OVERRIDE_DODGE:
               DebugLog.instance.log("ActionSlotStatIconComponent: case Icon.OVERRIDE_DODGE! ");
               _loc5_ = null;
               break;
            case Icon.HACK_DODGE:
               _loc5_ = new HackSmallDodge();
               break;
            case Icon.HACK_STUN:
               _loc5_ = new HackSmallStun();
               break;
            case Icon.HACK_SWAP_BLOCK:
               _loc5_ = new HackSmallSwapBlock();
               break;
            case Icon.MOD_REMOVE_OVERRIDE:
               _loc5_ = new ModSmallRemoveOverride();
               break;
            default:
               _loc5_ = null;
         }
         if(_loc5_ != null)
         {
            if(_loc7_)
            {
               _loc12_ = new SpikedAttack(_loc8_,_loc5_,_loc9_);
               this.mcIcon.addChild(_loc12_);
               if(param2.indexOf("%SPLIT%") != -1)
               {
                  _loc13_ = param2.split("%SPLIT%");
                  _loc12_.spikedText = _loc13_[0];
                  _loc12_.defaultText = _loc13_[1];
                  _loc12_.spinTextEnabled = true;
                  this.tfText.text = "";
                  this.tfText.visible = false;
               }
               else
               {
                  this.tfText.text = param2;
               }
               if(_loc10_ || _loc9_)
               {
                  _loc12_.gotoAndStop(1);
               }
            }
            else
            {
               this.mcIcon.addChild(_loc5_);
               this.tfText.text = param2;
            }
            this.setSelfAttack(_loc6_);
            this.showSelfAttackChaser = false;
         }
         else
         {
            DebugLog.instance.log("ActionSlotStatIconComponent ----- icon == null");
            this.tfText.text = "";
            this.setSelfAttack(false);
         }
         this._szType = param1;
      }
      
      public function getTextField() : TextField
      {
         return this.tfText;
      }
      
      public function getSelfAttackMC() : MovieClip
      {
         return this.mcSelfAttack;
      }
      
      public function set showSelfAttackChaser(param1:Boolean) : void
      {
         this.mcSelfAttack.mcChaser.visible = param1;
      }
      
      private function setSelfAttack(param1:Boolean) : void
      {
         this._bSelfAttack = param1;
         this.mcSelfAttack.visible = param1;
      }
      
      public function get type() : String
      {
         return this._szType;
      }
      
      public function get selfAttack() : Boolean
      {
         return this._bSelfAttack;
      }
   }
}

