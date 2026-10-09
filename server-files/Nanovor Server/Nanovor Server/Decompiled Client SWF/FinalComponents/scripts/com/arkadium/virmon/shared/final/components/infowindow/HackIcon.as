package com.arkadium.virmon.shared.final.components.infowindow
{
   import com.arkadium.virmon.battle.control.IAttackStatement;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.hacks.HackDodge;
   import com.arkadium.virmon.shared.elements.icons.hacks.HackSmallDodge;
   import com.arkadium.virmon.shared.elements.icons.hacks.HackSmallStun;
   import com.arkadium.virmon.shared.elements.icons.hacks.HackSmallSwapBlock;
   import com.arkadium.virmon.shared.elements.icons.hacks.HackStun;
   import com.arkadium.virmon.shared.elements.icons.hacks.HackSwapBlock;
   import com.arkadium.virmon.shared.final.elements.CondensedTextLeft;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   internal class HackIcon extends Sprite
   {
      
      private var _attackStatement:IAttackStatement;
      
      private var _description:String;
      
      public function HackIcon(param1:IAttackStatement, param2:int, param3:Boolean = false)
      {
         var _loc5_:DisplayObject = null;
         super();
         this._attackStatement = param1;
         this.mouseChildren = false;
         var _loc4_:String = Icon.getAttackStatementIcon(param1.type,param1.stat);
         if(_loc4_ == null)
         {
            return;
         }
         switch(_loc4_)
         {
            case Icon.HACK_DODGE:
               _loc5_ = param3 ? new HackSmallDodge() : new HackDodge();
               this._description = "DODGE";
               break;
            case Icon.HACK_STUN:
               _loc5_ = param3 ? new HackSmallStun() : new HackStun();
               this._description = "STUN";
               break;
            case Icon.HACK_SWAP_BLOCK:
               _loc5_ = param3 ? new HackSmallSwapBlock() : new HackSwapBlock();
               this._description = "SWAP BLOCK";
               break;
            default:
               _loc5_ = new Sprite();
               this._description = "";
         }
         if(param3)
         {
            _loc5_.y = 10;
         }
         this.addChild(_loc5_);
         var _loc6_:CondensedTextLeft = new CondensedTextLeft(param2.toString());
         _loc6_.x = _loc5_.width - _loc6_.width - 2;
         _loc6_.y = _loc5_.y + _loc5_.height - _loc6_.height + 2;
         this.addChild(_loc6_);
      }
      
      public function get description() : String
      {
         return this._description;
      }
   }
}

