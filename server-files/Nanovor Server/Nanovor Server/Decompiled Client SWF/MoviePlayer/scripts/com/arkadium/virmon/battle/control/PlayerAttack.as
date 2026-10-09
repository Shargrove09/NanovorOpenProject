package com.arkadium.virmon.battle.control
{
   public class PlayerAttack
   {
      
      public var attackId:int = 0;
      
      public var reason:int;
      
      public var attackStatement:IAttackStatement;
      
      public var playerAttackIndex:int = 0;
      
      public var targetPlayer:IPlayer;
      
      public var totalDamage:int = 0;
      
      public var dodge:Boolean = false;
      
      public var newValueOfStat:Number;
      
      public var ignoresArmor:Boolean = false;
      
      public var player:IPlayer;
      
      public var isCrit:Boolean = false;
      
      public var clientDescription:String;
      
      public var serverTargetUpdates:Object;
      
      public var isGlitch:Boolean = false;
      
      public function PlayerAttack()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "~";
         if(player != null)
         {
            _loc2_ = player.username;
         }
         _loc1_ += "ATTACKER: " + _loc2_;
         var _loc3_:String = "~";
         if(targetPlayer != null)
         {
            _loc3_ = targetPlayer.username;
         }
         _loc1_ += " TARGET: " + _loc3_;
         _loc1_ += " AID: " + attackId;
         var _loc4_:int = 0;
         if(attackStatement != null)
         {
            _loc4_ = int(attackStatement.id);
            _loc1_ += " SID: " + _loc4_ + " TYPE: " + attackStatement.type + " STAT: " + attackStatement.stat;
         }
         if(!isNaN(newValueOfStat))
         {
            _loc1_ += " NEWVAL: " + newValueOfStat;
         }
         _loc1_ += " REASON: " + reason;
         return _loc1_ + (" DAM: " + totalDamage);
      }
   }
}

