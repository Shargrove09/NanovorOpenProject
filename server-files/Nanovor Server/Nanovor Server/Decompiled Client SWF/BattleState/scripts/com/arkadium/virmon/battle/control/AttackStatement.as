package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.smithandtinker.nanovor.common.Stat;
   
   public class AttackStatement implements IAttackStatement
   {
      
      private static var _attackStatementFactory:IAttackStatementFactory;
      
      private var _delay:String;
      
      private var _conditionals:Array;
      
      public var currentAttacker:IPlayer;
      
      public var currentEnemy:IPlayer;
      
      private var _repetition:String;
      
      private var _type:String;
      
      private var _baseDamageFormula:IAttackStatementFormula;
      
      private var _target:String;
      
      private var _clientDescription:String;
      
      private var _id:int;
      
      private var _stat:String;
      
      private var _statementFormula:IAttackStatementFormula;
      
      private var _name:String;
      
      private var _roundConditionals:Array;
      
      private var _currentDuration:int;
      
      private var _duration:int;
      
      private var _verb:String;
      
      public function AttackStatement()
      {
         super();
         _name = "No Name";
         _type = "No Type";
         _id = 0;
         _conditionals = new Array();
         _roundConditionals = new Array();
         _target = "None";
         _stat = "None";
         _delay = "None";
         _verb = "None";
         _repetition = "None";
         _baseDamageFormula = null;
         _statementFormula = null;
         _clientDescription = "";
      }
      
      public static function initialize(param1:IAttackStatementFactory) : void
      {
         _attackStatementFactory = param1;
      }
      
      public static function createAttackStatementById(param1:int) : IAttackStatement
      {
         return _attackStatementFactory.createAttackStatementById(param1);
      }
      
      public static function copy(param1:IAttackStatement) : IAttackStatement
      {
         return _attackStatementFactory.clone(param1);
      }
      
      public function get delay() : String
      {
         return _delay;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get target() : String
      {
         return _target;
      }
      
      public function get duration() : int
      {
         return _duration;
      }
      
      public function calculateBaseFormula(param1:INanovor, param2:INanovor) : Number
      {
         return Math.round(_baseDamageFormula.solve(this,param1,param2));
      }
      
      public function calculateDamage(param1:INanovor = null, param2:INanovor = null) : Number
      {
         return Math.round(_statementFormula.solve(this,param1,param2));
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get verb() : String
      {
         return _verb;
      }
      
      public function doesApplyThisRound(param1:Boolean, param2:IPlayer, param3:IPlayer) : Boolean
      {
         var _loc5_:Conditional = null;
         this.currentAttacker = param2;
         this.currentEnemy = param3;
         var _loc4_:* = 0;
         while(_loc4_ < _conditionals.length)
         {
            _loc5_ = _conditionals[_loc4_];
            if(!_loc5_.evaluate(param1,param2,param3))
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public function get currentDuration() : int
      {
         return _currentDuration;
      }
      
      public function get clientDescription() : String
      {
         return _clientDescription;
      }
      
      public function get baseDamageFormula() : IAttackStatementFormula
      {
         return _baseDamageFormula;
      }
      
      public function get conditionals() : Array
      {
         return _conditionals;
      }
      
      public function initializeWithStatementObject(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:IConditional = null;
         _id = param1.id;
         _name = param1.attackStatementName;
         _type = param1.type;
         _target = param1.target;
         _stat = param1.stat;
         _verb = param1.verb;
         _delay = param1.delay;
         _duration = _type == AttackStatementTypes.TYPE_HACK ? int(String(param1.duration).substr(0,1)) : 0;
         _currentDuration = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.aConditionals.length)
         {
            _loc3_ = param1.aConditionals[_loc2_].name;
            _loc4_ = param1.aConditionals[_loc2_].mod;
            _loc5_ = param1.aConditionals[_loc2_].val;
            _loc6_ = Boolean(param1.aConditionals[_loc2_].isRound);
            _loc7_ = Conditional.createConditional(_loc3_,_loc4_,_loc5_);
            if(_loc6_)
            {
               _roundConditionals.push(_loc7_);
            }
            else
            {
               _conditionals.push(_loc7_);
            }
            _loc2_++;
         }
         _baseDamageFormula = AttackStatementFormula.createAttackStatementFormula(param1.baseDamageFormula);
         _statementFormula = AttackStatementFormula.createAttackStatementFormula(param1.statementFormula);
         _clientDescription = "";
      }
      
      public function canEvaluateConditionalsForPreview(param1:IPlayer, param2:IPlayer, param3:Boolean = true) : Boolean
      {
         var _loc5_:Conditional = null;
         var _loc4_:Boolean = true;
         for each(_loc5_ in _conditionals)
         {
            if(!_loc5_.canEvaluatePreview(param1,param2,param3))
            {
               _loc4_ = false;
            }
         }
         return _loc4_;
      }
      
      public function getPreviewDelta(param1:IPlayer, param2:IPlayer, param3:IPlayer = null) : String
      {
         var _loc7_:* = undefined;
         var _loc4_:INanovor = param1 == null ? null : param1.selectedNanovor;
         var _loc5_:INanovor = param3 == null ? null : param3.selectedNanovor;
         var _loc6_:INanovor = param2 == null ? _loc5_ : param2.selectedNanovor;
         if(_loc6_ == null)
         {
            _loc7_ = calculateBaseFormula(_loc4_,_loc5_);
         }
         else if(_loc6_.isDead)
         {
            _loc7_ = calculateDamage(_loc4_,_loc5_);
         }
         else
         {
            _loc7_ = calculateDamage(_loc4_,_loc6_);
            if(!(_loc6_.getModdedStat(_stat) < _loc7_ && _verb != "+" && _verb != "="))
            {
               if(_loc7_ < 0)
               {
                  _loc7_ = 0;
               }
            }
         }
         var _loc8_:String = _verb + _loc7_;
         _loc8_ = _loc8_.replace("=","");
         _loc8_ = _loc8_.replace("Remove0","Remove");
         switch(_type)
         {
            case AttackStatementTypes.TYPE_HACK:
               _loc8_ = _duration.toString();
               break;
            case AttackStatementTypes.TYPE_OVERRIDE:
               if(_stat == Stat.DODGE_FAIL_PERCENTAGE)
               {
                  _loc8_ = "";
               }
               break;
            case AttackStatementTypes.TYPE_MOD:
               if(_stat == Stat.OVERRIDE)
               {
                  _loc8_ = "";
               }
         }
         return _loc8_;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function get stat() : String
      {
         return _stat;
      }
      
      public function set currentDuration(param1:int) : void
      {
         _currentDuration = param1;
      }
      
      public function resetCurrentDuration() : void
      {
         _currentDuration = 0;
      }
      
      public function get roundConditionals() : Array
      {
         return _roundConditionals;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[AttackStatement|";
         _loc1_ += "_name=" + _name + ", ";
         _loc1_ += "_type=" + _type + ", ";
         _loc1_ += "_id=" + _id + ", ";
         _loc1_ += "_conditionals=" + _conditionals + ", ";
         _loc1_ += "_roundConditionals=" + _roundConditionals + ", ";
         _loc1_ += "_target=" + _target + ", ";
         _loc1_ += "_stat=" + _stat + ", ";
         _loc1_ += "_delay=" + _delay + ", ";
         _loc1_ += "_verb=" + _verb + ", ";
         _loc1_ += "_repetition=" + _repetition + ", ";
         _loc1_ += "_baseDamageFormula=" + _baseDamageFormula + ", ";
         _loc1_ += "_statementFormula=" + _statementFormula + ", ";
         _loc1_ += "_clientDescription=" + _clientDescription;
         return _loc1_ + "]";
      }
      
      public function prepareClientDescription(param1:int) : void
      {
         _clientDescription = "";
         if(_verb != null && _stat != null)
         {
            if(_verb == AttackStatementTypes.VERB_REMOVE)
            {
               _clientDescription = _verb + " " + _stat;
            }
            else
            {
               switch(_stat)
               {
                  case Stat.ARMOR:
                     _clientDescription += _verb + param1 + " ARM";
                     break;
                  case Stat.ENERGY:
                     _clientDescription += _verb + param1 + " EN";
                     break;
                  case Stat.ENERGY_GENERATOR:
                     _clientDescription += _verb + param1 + " EN";
                     break;
                  case Stat.HEALTH:
                     _clientDescription += _verb + param1 + " DAM";
                     break;
                  case Stat.SPEED:
                     _clientDescription += _verb + param1 + " SPD";
                     break;
                  case Stat.STRENGTH:
                     _clientDescription += _verb + param1 + " STR";
               }
            }
         }
      }
      
      public function setCurrentDuration() : void
      {
         _currentDuration = _duration;
      }
      
      public function doesApply(param1:Boolean, param2:Boolean, param3:IPlayer, param4:IPlayer) : Boolean
      {
         var _loc9_:Conditional = null;
         var _loc10_:Conditional = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = param2;
         this.currentAttacker = param3;
         this.currentEnemy = param4;
         var _loc7_:* = 0;
         while(_loc7_ < _conditionals.length)
         {
            _loc9_ = _conditionals[_loc7_];
            if(_loc9_.conditionalName == Conditional.ATTACK_FAILED)
            {
               _loc5_ = true;
               break;
            }
            _loc7_++;
         }
         var _loc8_:* = 0;
         while(_loc8_ < _conditionals.length)
         {
            _loc10_ = _conditionals[_loc8_];
            _loc6_ = _loc10_.evaluate(param1,param3,param4,param2);
            _loc8_++;
         }
         return _loc6_;
      }
      
      public function get statementFormula() : IAttackStatementFormula
      {
         return _statementFormula;
      }
   }
}

