package com.smithandtinker.nanovor.nanovormegaviewerui
{
   import com.arkadium.virmon.shared.elements.viewer.opponentattackaccordion.OpponentAccordion;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import flash.display.*;
   import flash.text.*;
   
   public class AttacksPane extends MovieClip
   {
      
      public var acc:OpponentAccordion;
      
      public var mcFaction:MovieClip;
      
      public var _sbtCloseAttacks:SimpleButton;
      
      public function AttacksPane()
      {
         super();
      }
      
      public function init(param1:IVirmon) : void
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         reset();
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         _loc2_ = param1.getAttackList();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_.length)
         {
            _loc5_ = Number(_loc2_[_loc6_].getDamage(param1));
            if(_loc5_ > 0)
            {
               _loc4_ = _loc2_[_loc6_].getAttackName() + " / " + _loc5_ + " DMG";
            }
            else
            {
               _loc4_ = _loc2_[_loc6_].getAttackName();
            }
            _loc3_.push({
               "title":_loc4_,
               "text":_loc2_[_loc6_].getPCDescription(),
               "energy":_loc2_[_loc6_].getCost() + "EN",
               "faction":param1.getFaction(),
               "icon":_loc2_[_loc6_].getAttackStatements()[0].type
            });
            _loc6_++;
         }
         acc.dataProvider = _loc3_;
         mcFaction.gotoAndStop(param1.getFaction());
      }
      
      public function reset() : void
      {
         if(Boolean(acc))
         {
            acc.clearAll();
         }
      }
   }
}

