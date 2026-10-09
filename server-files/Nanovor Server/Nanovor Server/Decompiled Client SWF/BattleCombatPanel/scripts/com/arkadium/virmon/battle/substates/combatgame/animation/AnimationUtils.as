package com.arkadium.virmon.battle.substates.combatgame.animation
{
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.PlayerAttack;
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import com.smithandtinker.smartfox.battle.AttackActionTypes;
   
   public class AnimationUtils
   {
      
      public static const ON_HIT_ANIMATION:String = "onHitAnimation";
      
      public static const EVENT_ANIMATION:String = "eventAnimation";
      
      private static var delayXML:String = "<animation animationType=\"delay\" delayTime=\"1000\"/>";
      
      public function AnimationUtils()
      {
         super();
      }
      
      public static function generateSwapXML(param1:IPlayer, param2:int) : String
      {
         var _loc3_:String = null;
         if(param1.swapReason == AttackActionTypes.SWAP)
         {
            return "<animation animationType=\"newVirmon\" playerId=\"" + param1.animationIndex + "\" virmonType=\"" + param1.nextNanovor.assetTypeId + "\" animationID=\"Id\" isNew=\"1\" name=\"" + param1.nextNanovor.nickName + "\" />" + "<animation animationType=\"visual\" playerId=\"" + param1.animationIndex + "\" virmonType=\"" + param1.nextNanovor.assetTypeId + "\" animationID = \"En\" statementID=\"" + param2 + "\"/>";
         }
         var _loc4_:String = param1.swapReason == AttackActionTypes.BLOCK_SWAP ? "SWAP BLOCKED" : "NO ENERGY";
         return "<animation animationType=\"textEffect\" playerId=\"" + param1.animationIndex + "\" myMessage=\"" + _loc4_ + "\" animationID = \"effectName\"/>";
      }
      
      public static function getPassDescription(param1:uint, param2:uint) : String
      {
         DebugLog.instance.error("<<AnimationUtils>> getPassDescription()- " + arguments);
         var _loc4_:String = "<animation animationType=\"textEffect\" playerId =\"" + param1;
         switch(param2)
         {
            case 0:
            case 1:
               _loc4_ += "\" animationID=\"pass\" myMessage=\"PASS\" />";
               break;
            case 3:
               _loc4_ += "\" animationID=\"stunned\" myMessage=\"STUN\" />";
               break;
            case 4:
            case 5:
               _loc4_ += "\" animationID=\"fizzle\" myMessage=\"FIZZLE\" />";
               break;
            case 8:
               _loc4_ += "\" animationID=\"dodge\" myMessage=\"DODGE\" />";
               break;
            default:
               _loc4_ = "";
         }
         if(_loc4_ != "")
         {
            _loc4_ += delayXML;
         }
         DebugLog.instance.error("<<AnimationUtils>> getPassDescription() - returning: " + _loc4_);
         return _loc4_;
      }
      
      public static function generateReactiveAnimation(param1:PlayerAttack, param2:int, param3:IPlayer, param4:String, param5:int, param6:int, param7:Boolean = false) : String
      {
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         var _loc18_:uint = 0;
         var _loc9_:String = "";
         if(param1.dodge)
         {
            _loc9_ += "<" + param4 + "  animationType=\"targetVirmon\" playerId=\"" + param2 + "\" virmonType=\"" + param3.selectedNanovor.assetTypeId + "\" kill=\"0\" animationID=\"Do\"/>";
            return _loc9_ + ("<" + param4 + " animationType=\"textEffect\" playerId=\"" + param2 + "\" animationID=\"attackName\" myMessage=\"DODGE\" />");
         }
         if(param1.attackStatement.stat != null && param1.attackStatement.stat != "None")
         {
            _loc12_ = param3.selectedNanovor.getModdedStat(param1.attackStatement.stat,false) - param1.newValueOfStat;
            if(param1.newValueOfStat == 0)
            {
               _loc16_ = int(param3.selectedNanovor.getModdedStat(param1.attackStatement.stat,false));
            }
            switch(param1.attackStatement.stat)
            {
               case Stat.SPEED:
                  _loc10_ = "SPD";
                  _loc11_ = "damagespeed";
                  break;
               case Stat.ARMOR:
                  _loc10_ = "ARM";
                  _loc11_ = "damagearmor";
                  break;
               case Stat.STRENGTH:
                  _loc10_ = "STR";
                  _loc11_ = "damagestrength";
                  break;
               case Stat.ENERGY:
                  _loc10_ = "EN";
                  _loc11_ = "damagehealth";
                  break;
               case AttackStatementTypes.TYPE_OVERRIDE:
               case AttackStatementTypes.TYPE_HACK:
                  _loc11_ = "effectName";
                  break;
               case AttackStatementTypes.TYPE_DAMAGE:
                  break;
               default:
                  DebugLog.instance.error("<<AnimationUtils>> generateReactiveAnimation() - switch for stat in Mod hit default case.  Unknown stat: " + param1.attackStatement.stat);
            }
            _loc13_ = param3.selectedNanovor.getModdedStat(param1.attackStatement.stat,false) >= param1.newValueOfStat ? String("-" + param1.totalDamage) : String("+" + param1.totalDamage);
         }
         switch(param1.attackStatement.type)
         {
            case AttackStatementTypes.TYPE_DAMAGE:
               _loc14_ = 0;
               _loc15_ = "Da2";
               if(param1.isCrit)
               {
                  _loc15_ = "Da3";
               }
               if(param1.isGlitch)
               {
                  _loc15_ = "Da1";
               }
               if(param1.dodge)
               {
                  _loc15_ = "Do";
               }
               _loc16_ = param3.selectedNanovor.health - param1.newValueOfStat;
               _loc17_ = "";
               if(param1.newValueOfStat == 0)
               {
                  _loc14_ = 1;
                  _loc18_ = _loc14_ == 1 && param2 == param1.player.animationIndex ? 1 : 0;
                  _loc17_ = "<animation animationType=\"causeDeath\" playerId=\"" + param1.player.animationIndex + "\" virmonType=\"" + param1.player.selectedNanovor.assetTypeId + "\" selfDeathCausedByAttack=\"" + _loc18_ + "\" statementID=\"" + param6 + "\"/>";
                  _loc15_ = "De" + param5;
                  _loc16_ = param1.totalDamage;
               }
               else if(param1.player === param3)
               {
               }
               if(!param7)
               {
                  _loc9_ += "<" + param4 + "  animationType=\"targetVirmon\" playerId=\"" + param2 + "\" virmonType=\"" + param3.selectedNanovor.assetTypeId + "\" kill=\"" + _loc14_ + "\" animationID=\"" + _loc15_ + "\"/>";
               }
               if(param3.selectedNanovor.moddedArmor > 0 && !param1.ignoresArmor && !param1.dodge)
               {
                  _loc9_ += "<onHitAnimation animationType=\"textEffect\" playerId=\"" + param2 + "\" animationID=\"showshield\" myMessage=\"" + param3.selectedNanovor.moddedArmor + "\" statementID=\"" + param6 + "\"/>";
               }
               _loc9_ += "<" + param4 + "  animationType=\"hpchange\" playerId=\"" + param2 + "\" start=\"" + param3.selectedNanovor.health + "\" end=\"" + param1.newValueOfStat + "\" max=\"" + param3.selectedNanovor.baseHealth + "\" statementID=\"" + param6 + "\"/>";
               _loc9_ += "<" + param4 + "  animationType=\"textEffect\" playerId=\"" + param2 + "\" animationID=\"damagehealth\" myMessage=\"-" + _loc16_ + " HLTH\" statementID=\"" + param6 + "\"/>";
               _loc9_ += _loc17_;
               break;
            case AttackStatementTypes.TYPE_MOD:
               if(_loc11_ == null)
               {
                  break;
               }
               if(param1.player != param3 && !param7)
               {
                  _loc9_ += "<" + param4 + "  animationType=\"targetVirmon\" playerId=\"" + param2 + "\" virmonType=\"" + param3.selectedNanovor.assetTypeId + "\" kill=\"" + _loc14_ + "\" animationID=\"Da2\"/>";
               }
               if(param1.attackStatement.stat == AttackStatementTypes.TYPE_HACK || param1.attackStatement.stat == AttackStatementTypes.TYPE_OVERRIDE)
               {
                  _loc11_ = "effectName";
                  _loc13_ = param1.attackStatement.stat == AttackStatementTypes.TYPE_HACK ? "HACK ERASED" : "OVERRIDE ERASED";
                  _loc10_ = "";
               }
               _loc9_ += "<" + param4 + " animationType=\"textEffect\" playerId=\"" + param2 + "\" animationID=\"" + _loc11_ + "\" myMessage=\"" + _loc13_ + " " + _loc10_ + "\" statementID=\"" + param6 + "\"/>";
               break;
            case AttackStatementTypes.TYPE_HACK:
               if(param1.player != param3 && !param7)
               {
                  _loc9_ += "<" + param4 + "  animationType=\"targetVirmon\" playerId=\"" + param2 + "\" virmonType=\"" + param3.selectedNanovor.assetTypeId + "\" kill=\"" + _loc14_ + "\" animationID=\"Da2\"/>";
               }
               _loc9_ += "<" + param4 + " animationType=\"textEffect\" playerId=\"" + param2 + "\" animationID=\"hackeffectname\" myMessage=\"HACK\" statementID=\"" + param6 + "\"/>";
               break;
            case AttackStatementTypes.TYPE_OVERRIDE:
               _loc9_ += "<" + param4 + " animationType=\"textEffect\" playerId=\"" + param2 + "\" animationID=\"overrideeffectname\" myMessage=\"OVERRIDE\" statementID=\"" + param6 + "\"/>";
               if(_loc11_ == null)
               {
                  break;
               }
               _loc9_ += "<" + param4 + " animationType=\"textEffect\" playerId=\"" + param2 + "\" animationID=\"" + _loc11_ + "\" myMessage=\"" + param1.attackStatement.clientDescription + "\" statementID=\"" + param6 + "\"/>";
               break;
            case AttackStatementTypes.TYPE_PASS:
               DebugLog.instance.error("<<AnimationUtils>> generateReactiveAnimation() - TYPE_PASS erroneously hit" + arguments);
               break;
            default:
               DebugLog.instance.error("<<AnimationUtils>> generateReactiveAnimation() - unknown type hit" + arguments);
         }
         return _loc9_;
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log("<<AnimationUtils>>\t" + param1);
      }
   }
}

