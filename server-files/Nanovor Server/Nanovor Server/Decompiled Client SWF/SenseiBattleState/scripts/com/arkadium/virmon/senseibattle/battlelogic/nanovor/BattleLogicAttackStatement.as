package com.arkadium.virmon.senseibattle.battlelogic.nanovor
{
   import com.arkadium.virmon.senseibattle.battlelogic.player.BattleLogicPlayer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BattleLogicAttackStatement
   {
      
      public static var TYPE_DAMAGE:String = "Attack";
      
      public static var TYPE_MOD:String = "Mod";
      
      public static var TYPE_HACK:String = "Hack";
      
      public static var TYPE_OVERRIDE:String = "Override";
      
      public static var TYPE_PASS:String = "Pass";
      
      public static var TARGET_MY_NANOVOR:String = "My active Virmon";
      
      public static var TARGET_ENEMY_NANOVOR:String = "Enemy active Virmon";
      
      public static var TARGET_MY_TEAM:String = "My team";
      
      public static var TARGET_ENEMY_TEAM:String = "Enemy team";
      
      public static var TARGET_ALL_ACTIVE_NANOVOR:String = "All active Virmon";
      
      public static var TARGET_ALL_SWARMS:String = "All teams";
      
      public static var VERB_SUBTRACT:String = "-";
      
      public static var VERB_ADD:String = "+";
      
      public static var VERB_MULTIPLY:String = "*";
      
      public static var VERB_DIVIDE:String = "/";
      
      public static var VERB_SET:String = "=";
      
      public static var VERB_REMOVE:String = "Remove";
      
      public static var VERB_LOCK:String = "Lock";
      
      public static var DURATION_NONE:String = "None";
      
      public static var DURATION_END_OF_ROUND:String = "Until end of this round";
      
      public static var DURATION_PERMANENT:String = "Permanent";
      
      public static var DURATION_1_ACTIVE_ROUND:String = "1 active round";
      
      public static var DURATION_2_ACTIVE_ROUNDS:String = "2 active rounds";
      
      public static var DURATION_3_ACTIVE_ROUNDS:String = "3 active rounds";
      
      public static var DURATION_4_ACTIVE_ROUNDS:String = "4 active rounds";
      
      public static var DURATION_5_ACTIVE_ROUNDS:String = "5 active rounds";
      
      public static var DURATION_6_ACTIVE_ROUNDS:String = "6 active rounds";
      
      public static var DURATION_7_ACTIVE_ROUNDS:String = "7 active rounds";
      
      public static var DURATION_8_ACTIVE_ROUNDS:String = "8 active rounds";
      
      public static var DURATION_9_ACTIVE_ROUNDS:String = "9 active rounds";
      
      public static var DURATION_10_ACTIVE_ROUNDS:String = "10 active rounds";
      
      public static var CLIENT_DESCRIPTION_FIELD:String = "statementClientDescription";
      
      private const STATEMENT_CONDS:int = 10;
      
      private var _attackStatementId:int;
      
      private var _delay:String;
      
      private var _conditionals:Array;
      
      public var currentAttacker:BattleLogicPlayer;
      
      public var currentEnemy:BattleLogicPlayer;
      
      private var _repetition:String;
      
      private var _type:String;
      
      private var _baseDamageFormula:AttackStatementFormula;
      
      private var _target:String;
      
      private var _clientDescription:String;
      
      private var _stat:String;
      
      private var _statementFormula:AttackStatementFormula;
      
      private var _attackId:int;
      
      private var _roundConditionals:Array;
      
      private var _name:String;
      
      private var _currentDuration:int;
      
      private var _duration:int;
      
      private var _verb:String;
      
      public function BattleLogicAttackStatement(param1:int, param2:int)
      {
         super();
         _name = "No Name";
         _type = "No Type";
         _attackStatementId = param1;
         _conditionals = new Array();
         _roundConditionals = new Array();
         _target = "None";
         _stat = "None";
         _delay = "None";
         _verb = "None";
         _repetition = "None";
         _baseDamageFormula = null;
         _statementFormula = null;
         _attackId = param2;
         _clientDescription = "";
      }
      
      public function get attackStatementId() : int
      {
         return _attackStatementId;
      }
      
      public function get attackId() : int
      {
         return _attackId;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function setName(param1:String) : void
      {
         _name = param1;
      }
      
      private function setDurationFromString(param1:String) : int
      {
         if(param1 == DURATION_1_ACTIVE_ROUND)
         {
            _duration = 2;
         }
         else if(param1 == DURATION_2_ACTIVE_ROUNDS)
         {
            _duration = 3;
         }
         else if(param1 == DURATION_3_ACTIVE_ROUNDS)
         {
            _duration = 4;
         }
         else if(param1 == DURATION_4_ACTIVE_ROUNDS)
         {
            _duration = 5;
         }
         else if(param1 == DURATION_5_ACTIVE_ROUNDS)
         {
            _duration = 6;
         }
         else if(param1 == DURATION_6_ACTIVE_ROUNDS)
         {
            _duration = 7;
         }
         else if(param1 == DURATION_7_ACTIVE_ROUNDS)
         {
            _duration = 8;
         }
         else if(param1 == DURATION_8_ACTIVE_ROUNDS)
         {
            _duration = 9;
         }
         else if(param1 == DURATION_9_ACTIVE_ROUNDS)
         {
            _duration = 10;
         }
         else if(param1 == DURATION_10_ACTIVE_ROUNDS)
         {
            _duration = 11;
         }
         else if(param1 == DURATION_END_OF_ROUND)
         {
            _duration = 1;
         }
         else if(param1 == DURATION_NONE)
         {
            _duration = 0;
         }
         else if(param1 == DURATION_PERMANENT)
         {
            _duration = 10000;
         }
         return _duration;
      }
      
      public function get delay() : String
      {
         return _delay;
      }
      
      public function setTarget(param1:String) : void
      {
         _target = param1;
      }
      
      public function get duration() : int
      {
         return _duration;
      }
      
      public function getRoundConditional(param1:int) : BattleLogicConditional
      {
         return _roundConditionals[_roundConditionals.indexOf(param1)];
      }
      
      private function setDuration(param1:int) : void
      {
         _duration = param1;
      }
      
      public function calculateDamage() : Number
      {
         return _statementFormula.solve(this);
      }
      
      public function doesApplyThisRound(param1:Boolean, param2:BattleLogicPlayer, param3:BattleLogicPlayer) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:BattleLogicConditional = null;
         this.currentAttacker = param2;
         this.currentEnemy = param3;
         if(roundConditionals != null && roundConditionals.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < roundConditionals.length)
            {
               _loc5_ = roundConditionals[_loc4_];
               trace("Round Conditional: " + _loc5_.toString());
               if(!_loc5_.evaluate(param1,param2,param3))
               {
                  trace("Condition evaluated: false");
                  return false;
               }
               _loc4_++;
            }
         }
         trace("Condition evaluated: true");
         return true;
      }
      
      public function getClientDescription() : String
      {
         return _clientDescription;
      }
      
      public function get verb() : String
      {
         return _verb;
      }
      
      public function setVerb(param1:String) : void
      {
         this._verb = param1;
      }
      
      public function prepareClientDescription(param1:int) : void
      {
         log("Client description being created: " + param1);
         _clientDescription = "";
         if(_verb != null && _stat != null)
         {
            if(_verb == VERB_REMOVE)
            {
               _clientDescription = _verb + " " + _stat;
            }
            else if(_stat == Stat.ARMOR)
            {
               _clientDescription += _verb + param1 + " ARM";
            }
            else if(_stat == Stat.ENERGY || _stat == Stat.ENERGY_GENERATOR)
            {
               _clientDescription += _verb + param1 + " EN";
            }
            else if(_stat == Stat.HEALTH)
            {
               _clientDescription += _verb + param1 + " DAM";
            }
            else if(_stat == Stat.SPEED)
            {
               _clientDescription += _verb + param1 + " SPD";
            }
            else if(_stat == Stat.STRENGTH)
            {
               _clientDescription += _verb + param1 + " STR";
            }
         }
         log("CLIENT DESCRIPTION: " + _clientDescription);
      }
      
      public function updateCurrentDuration() : int
      {
         return --_currentDuration;
      }
      
      protected function addConditional(param1:BattleLogicConditional) : void
      {
         _conditionals.push(param1);
      }
      
      public function get baseDamageFormula() : AttackStatementFormula
      {
         return _baseDamageFormula;
      }
      
      public function get target() : String
      {
         return _target;
      }
      
      public function get currentDuration() : int
      {
         return _currentDuration;
      }
      
      public function calculateBaseFormula(param1:BattleLogicNanovor, param2:BattleLogicNanovor) : Number
      {
         return Math.round(_baseDamageFormula.solve(this));
      }
      
      public function get conditionals() : Array
      {
         return _conditionals;
      }
      
      public function setType(param1:String) : void
      {
         _type = param1;
      }
      
      public function setDelay(param1:String) : void
      {
         this._delay = param1;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleLogicAttackStatement>>\t" + param1);
      }
      
      public function getConditional(param1:int) : BattleLogicConditional
      {
         return _conditionals[_conditionals.indexOf(param1)];
      }
      
      protected function addRoundConditional(param1:BattleLogicConditional) : void
      {
         _roundConditionals.push(param1);
      }
      
      public function parseAttackStatement(param1:XML) : void
      {
         var _loc7_:XMLList = null;
         var _loc8_:XMLList = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         _name = param1.child("attack-statement-name");
         _type = param1.child("type");
         _target = param1.child("target");
         _stat = param1.child("stat");
         _verb = param1.child("verb");
         _delay = param1.child("delay");
         _duration = setDurationFromString(param1.child("duration"));
         _repetition = param1.child("repitition");
         _baseDamageFormula = new AttackStatementFormula(param1.child("base-damage-formula"));
         _statementFormula = new AttackStatementFormula(param1.child("statement-formula"));
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:BattleLogicConditional = null;
         var _loc6_:uint = 1;
         while(_loc6_ <= STATEMENT_CONDS)
         {
            _loc7_ = param1.child("conditional-" + _loc6_);
            if(Boolean(_loc7_.length()))
            {
               _loc9_ = new Object();
               _loc9_.isRound = false;
               _loc2_ = String(_loc7_[0].child("conditional-name")[0]);
               _loc3_ = String(_loc7_[0].child("conditional-mod")[0]);
               _loc4_ = String(_loc7_[0].child("conditional-var")[0]);
               _loc5_ = new BattleLogicConditional(_loc2_,_loc3_,_loc4_);
               _conditionals.push(_loc5_);
            }
            _loc8_ = param1.child("round-conditional-" + _loc6_);
            if(Boolean(_loc8_.length()))
            {
               _loc10_ = new Object();
               _loc10_.isRound = true;
               _loc2_ = String(_loc8_[0].child("conditional-name")[0]);
               _loc3_ = String(_loc8_[0].child("conditional-mod")[0]);
               _loc4_ = String(_loc8_[0].child("conditional-var")[0]);
               _loc5_ = new BattleLogicConditional(_loc2_,_loc3_,_loc4_);
               _roundConditionals.push(_loc5_);
            }
            _loc6_++;
         }
      }
      
      public function clone() : BattleLogicAttackStatement
      {
         var _loc2_:BattleLogicConditional = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc1_:BattleLogicAttackStatement = new BattleLogicAttackStatement(_attackStatementId,_attackId);
         _loc1_.setName(_name);
         _loc1_.setType(_type);
         _loc1_.setTarget(_target);
         _loc1_.setStat(_stat);
         _loc1_.setDelay(_delay);
         _loc1_.setDuration(_duration);
         _loc1_.setCurrentDuration();
         _loc1_.setVerb(_verb);
         _loc1_.setRepetition(_repetition);
         if(_baseDamageFormula != null)
         {
            _loc1_.setBaseDamageFormula(_baseDamageFormula.clone());
         }
         if(_statementFormula != null)
         {
            _loc1_.setStatementFormula(_statementFormula.clone());
         }
         if(_conditionals.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _conditionals.length)
            {
               _loc2_ = _conditionals[_loc3_];
               _loc1_.addConditional(_loc2_);
               _loc3_++;
            }
         }
         if(_roundConditionals.length > 0)
         {
            log("RoundConditionals length: " + _roundConditionals.length);
            _loc4_ = 0;
            while(_loc4_ < _roundConditionals.length)
            {
               _loc2_ = _roundConditionals[_loc4_];
               _loc1_.addRoundConditional(_loc2_);
               _loc4_++;
            }
         }
         return _loc1_;
      }
      
      public function resetCurrentDuration() : void
      {
         _currentDuration = 0;
      }
      
      public function setBaseDamageFormula(param1:AttackStatementFormula) : void
      {
         _baseDamageFormula = param1;
      }
      
      public function setStat(param1:String) : void
      {
         this._stat = param1;
      }
      
      public function get stat() : String
      {
         return _stat;
      }
      
      public function get repetition() : String
      {
         return _repetition;
      }
      
      public function setCurrentDuration() : void
      {
         _currentDuration = _duration;
      }
      
      public function setRepetition(param1:String) : void
      {
         this._repetition = param1;
      }
      
      public function doesApply(param1:Boolean, param2:Boolean, param3:BattleLogicPlayer, param4:BattleLogicPlayer) : Boolean
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:BattleLogicConditional = null;
         var _loc10_:BattleLogicConditional = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = param2;
         this.currentAttacker = param3;
         this.currentEnemy = param4;
         if(conditionals != null && conditionals.length > 0)
         {
            _loc7_ = 0;
            while(_loc7_ < conditionals.length)
            {
               _loc9_ = conditionals[_loc7_];
               if(_loc9_.conditionalName == BattleLogicConditional.ATTACK_FAILED)
               {
                  _loc5_ = true;
                  break;
               }
               trace("Statement Conditional: " + _loc9_);
               _loc7_++;
            }
            trace("Is FAIL conditional: " + _loc5_);
            _loc8_ = 0;
            while(_loc8_ < conditionals.length)
            {
               _loc10_ = conditionals[_loc8_];
               _loc6_ = _loc10_.evaluate(param1,param3,param4,param2);
               _loc8_++;
            }
         }
         trace("AttackStatement doesApply: " + _loc6_);
         return _loc6_;
      }
      
      public function get statementFormula() : AttackStatementFormula
      {
         return _statementFormula;
      }
      
      public function setStatementFormula(param1:AttackStatementFormula) : void
      {
         _statementFormula = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "{Name: " + _name + " | ";
         _loc1_ += "StatementID:" + _attackStatementId + " | ";
         _loc1_ += "Type: " + _type + " | ";
         _loc1_ += "Target: " + _target + " | ";
         _loc1_ += "Stat: " + _stat + " | ";
         _loc1_ += "Verb: " + _verb + " | ";
         return _loc1_ + ("Duration: " + _duration + "}  ");
      }
      
      public function get roundConditionals() : Array
      {
         return _roundConditionals;
      }
   }
}

