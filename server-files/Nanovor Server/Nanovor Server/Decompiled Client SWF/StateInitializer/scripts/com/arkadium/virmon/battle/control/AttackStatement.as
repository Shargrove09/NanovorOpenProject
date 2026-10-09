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
         this._name = "No Name";
         this._type = "No Type";
         this._id = 0;
         this._conditionals = new Array();
         this._roundConditionals = new Array();
         this._target = "None";
         this._stat = "None";
         this._delay = "None";
         this._verb = "None";
         this._repetition = "None";
         this._baseDamageFormula = null;
         this._statementFormula = null;
         this._clientDescription = "";
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
         return this._delay;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get target() : String
      {
         return this._target;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function calculateBaseFormula(param1:INanovor, param2:INanovor) : Number
      {
         return Math.round(this._baseDamageFormula.solve(this,param1,param2));
      }
      
      public function calculateDamage(param1:INanovor = null, param2:INanovor = null) : Number
      {
         return Math.round(this._statementFormula.solve(this,param1,param2));
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get verb() : String
      {
         return this._verb;
      }
      
      public function doesApplyThisRound(param1:Boolean, param2:IPlayer, param3:IPlayer) : Boolean
      {
         var _loc5_:Conditional = null;
         this.currentAttacker = param2;
         this.currentEnemy = param3;
         var _loc4_:* = 0;
         while(_loc4_ < this._conditionals.length)
         {
            _loc5_ = this._conditionals[_loc4_];
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
         return this._currentDuration;
      }
      
      public function get clientDescription() : String
      {
         return this._clientDescription;
      }
      
      public function get baseDamageFormula() : IAttackStatementFormula
      {
         return this._baseDamageFormula;
      }
      
      public function get conditionals() : Array
      {
         return this._conditionals;
      }
      
      public function initializeWithStatementObject(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:IConditional = null;
         this._id = param1.id;
         this._name = param1.attackStatementName;
         this._type = param1.type;
         this._target = param1.target;
         this._stat = param1.stat;
         this._verb = param1.verb;
         this._delay = param1.delay;
         this._duration = this._type == AttackStatementTypes.TYPE_HACK ? int(String(param1.duration).substr(0,1)) : 0;
         this._currentDuration = 0;
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
               this._roundConditionals.push(_loc7_);
            }
            else
            {
               this._conditionals.push(_loc7_);
            }
            _loc2_++;
         }
         this._baseDamageFormula = AttackStatementFormula.createAttackStatementFormula(param1.baseDamageFormula);
         this._statementFormula = AttackStatementFormula.createAttackStatementFormula(param1.statementFormula);
         this._clientDescription = "";
      }
      
      public function canEvaluateConditionalsForPreview(param1:IPlayer, param2:IPlayer, param3:Boolean = true) : Boolean
      {
         var _loc5_:Conditional = null;
         var _loc4_:Boolean = true;
         for each(_loc5_ in this._conditionals)
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
            _loc7_ = this.calculateBaseFormula(_loc4_,_loc5_);
         }
         else if(_loc6_.isDead)
         {
            _loc7_ = this.calculateDamage(_loc4_,_loc5_);
         }
         else
         {
            _loc7_ = this.calculateDamage(_loc4_,_loc6_);
            if(!(_loc6_.getModdedStat(this._stat) < _loc7_ && this._verb != "+" && this._verb != "="))
            {
               if(_loc7_ < 0)
               {
                  _loc7_ = 0;
               }
            }
         }
         var _loc8_:String = this._verb + _loc7_;
         _loc8_ = _loc8_.replace("=","");
         _loc8_ = _loc8_.replace("Remove0","Remove");
         switch(this._type)
         {
            case AttackStatementTypes.TYPE_HACK:
               _loc8_ = this._duration.toString();
               break;
            case AttackStatementTypes.TYPE_OVERRIDE:
               if(this._stat == Stat.DODGE_FAIL_PERCENTAGE)
               {
                  _loc8_ = "";
               }
               break;
            case AttackStatementTypes.TYPE_MOD:
               if(this._stat == Stat.OVERRIDE)
               {
                  _loc8_ = "";
               }
         }
         return _loc8_;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get stat() : String
      {
         return this._stat;
      }
      
      public function set currentDuration(param1:int) : void
      {
         this._currentDuration = param1;
      }
      
      public function resetCurrentDuration() : void
      {
         this._currentDuration = 0;
      }
      
      public function get roundConditionals() : Array
      {
         return this._roundConditionals;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[AttackStatement|";
         _loc1_ += "_name=" + this._name + ", ";
         _loc1_ += "_type=" + this._type + ", ";
         _loc1_ += "_id=" + this._id + ", ";
         _loc1_ += "_conditionals=" + this._conditionals + ", ";
         _loc1_ += "_roundConditionals=" + this._roundConditionals + ", ";
         _loc1_ += "_target=" + this._target + ", ";
         _loc1_ += "_stat=" + this._stat + ", ";
         _loc1_ += "_delay=" + this._delay + ", ";
         _loc1_ += "_verb=" + this._verb + ", ";
         _loc1_ += "_repetition=" + this._repetition + ", ";
         _loc1_ += "_baseDamageFormula=" + this._baseDamageFormula + ", ";
         _loc1_ += "_statementFormula=" + this._statementFormula + ", ";
         _loc1_ += "_clientDescription=" + this._clientDescription;
         return _loc1_ + "]";
      }
      
      public function prepareClientDescription(param1:int) : void
      {
         this._clientDescription = "";
         if(this._verb != null && this._stat != null)
         {
            if(this._verb == AttackStatementTypes.VERB_REMOVE)
            {
               this._clientDescription = this._verb + " " + this._stat;
            }
            else
            {
               switch(this._stat)
               {
                  case Stat.ARMOR:
                     this._clientDescription += this._verb + param1 + " ARM";
                     break;
                  case Stat.ENERGY:
                     this._clientDescription += this._verb + param1 + " EN";
                     break;
                  case Stat.ENERGY_GENERATOR:
                     this._clientDescription += this._verb + param1 + " EN";
                     break;
                  case Stat.HEALTH:
                     this._clientDescription += this._verb + param1 + " DAM";
                     break;
                  case Stat.SPEED:
                     this._clientDescription += this._verb + param1 + " SPD";
                     break;
                  case Stat.STRENGTH:
                     this._clientDescription += this._verb + param1 + " STR";
               }
            }
         }
      }
      
      public function setCurrentDuration() : void
      {
         this._currentDuration = this._duration;
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
         while(_loc7_ < this._conditionals.length)
         {
            _loc9_ = this._conditionals[_loc7_];
            if(_loc9_.conditionalName == Conditional.ATTACK_FAILED)
            {
               _loc5_ = true;
               break;
            }
            _loc7_++;
         }
         var _loc8_:* = 0;
         while(_loc8_ < this._conditionals.length)
         {
            _loc10_ = this._conditionals[_loc8_];
            _loc6_ = _loc10_.evaluate(param1,param3,param4,param2);
            _loc8_++;
         }
         return _loc6_;
      }
      
      public function get statementFormula() : IAttackStatementFormula
      {
         return this._statementFormula;
      }
   }
}

