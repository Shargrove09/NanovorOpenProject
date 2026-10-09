package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.common.AttackIconType;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IVirmonAttackData;
   import com.arkadium.virmon.shared.data.AttackStatementTypes;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class Attack implements IAttack
   {
      
      private var _wasUsed:Boolean;
      
      private var _pcDescription:String;
      
      private var _type:String;
      
      private var _icons:Array;
      
      private var _attackStatements:Array;
      
      private var _cost:int;
      
      private var _ammo:String;
      
      private var _shortDescription:String;
      
      private var _attackID:int;
      
      private var _keyword1:String;
      
      private var _keyword2:String;
      
      private var _conditional:IConditional;
      
      private var _actionIconType:String;
      
      private var _overrideDescription:String;
      
      private var _hackDescription:String;
      
      private var _hhDescription:String;
      
      private var _animationID:int;
      
      private var _expectedDamage:Number;
      
      private var _name:String;
      
      private var _forceDamage:String;
      
      public function Attack()
      {
         super();
         _expectedDamage = 0;
         _attackID = 0;
         _name = "No Name";
         _type = "No Type";
         _shortDescription = "No Description";
         _hhDescription = "No Description";
         _pcDescription = "No Description";
         _overrideDescription = "No Description";
         _hackDescription = "No Description";
         _forceDamage = "none";
         _keyword1 = "";
         _keyword2 = "";
         _cost = -1;
         _ammo = "";
         _conditional = null;
         _attackStatements = new Array();
         _animationID = 0;
         _wasUsed = false;
         _actionIconType = Icon.ACTION_MELEE;
         _icons = new Array();
      }
      
      public static function getOverrideDescription(param1:int) : String
      {
         return DataManager.getInstance().getVirmonManager().getOverrideDescriptionByAttackId(param1);
      }
      
      public static function createAttackById(param1:int) : IAttack
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:IAttackStatement = null;
         var _loc2_:IVirmonAttackData = DataManager.getInstance().getVirmonManager().getAttackById(param1);
         var _loc3_:Attack = new Attack();
         _loc3_._attackID = param1;
         _loc3_._name = _loc2_.getAttackName();
         _loc3_._type = _loc2_.getAttackType();
         _loc3_._shortDescription = _loc2_.getShortDescription();
         _loc3_._hhDescription = _loc2_.getHandHeldDescription();
         _loc3_._pcDescription = _loc2_.getPCDescription();
         _loc3_._overrideDescription = _loc2_.getOverrideDescription();
         _loc3_._hackDescription = _loc2_.getHackDescription();
         _loc3_._forceDamage = _loc2_.getForceDamage();
         _loc3_._keyword1 = _loc2_.getKeyword1();
         _loc3_._keyword2 = _loc2_.getKeyword2();
         _loc3_._cost = _loc2_.getCost();
         _loc3_._ammo = _loc2_.getAmmo();
         var _loc4_:Array = _loc2_.getAttackConditionals();
         if(_loc4_.length > 0)
         {
            _loc8_ = _loc4_[0].name;
            _loc9_ = _loc4_[0].mod;
            _loc10_ = _loc4_[0].val;
            _loc3_._conditional = Conditional.createConditional(_loc8_,_loc9_,_loc10_);
         }
         var _loc5_:Array = new Array();
         var _loc6_:Array = _loc2_.getAttackStatements();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc11_ = AttackStatement.createAttackStatementById(_loc6_[_loc7_].id);
            _loc3_._attackStatements.push(_loc11_);
            _loc5_.push(_loc11_.type);
            _loc3_._icons.push(Icon.getAttackStatementIcon(_loc11_.type,_loc11_.stat));
            _loc7_++;
         }
         if(_loc2_.iconType == AttackIconType.NOT_SET)
         {
            if(_loc5_.indexOf(AttackStatementTypes.TYPE_OVERRIDE) > -1)
            {
               _loc3_._actionIconType = Icon.ACTION_OVERRIDE;
            }
            if(_loc5_.indexOf(AttackStatementTypes.TYPE_MOD) > -1)
            {
               _loc3_._actionIconType = Icon.ACTION_MOD;
            }
            if(_loc5_.indexOf(AttackStatementTypes.TYPE_HACK) > -1)
            {
               _loc3_._actionIconType = Icon.ACTION_HACK;
            }
            if(_loc5_.indexOf(AttackStatementTypes.TYPE_OVERRIDE) > -1)
            {
               _loc3_._actionIconType = Icon.ACTION_MELEE;
            }
         }
         else
         {
            _loc3_._actionIconType = Icon.getIconFromFrameworkType(_loc2_.iconType);
         }
         return _loc3_;
      }
      
      public function get isSelfTarget() : Boolean
      {
         var _loc1_:IAttackStatement = null;
         if(_attackID == 0)
         {
            return true;
         }
         for each(_loc1_ in _attackStatements)
         {
            if(_loc1_.target == AttackStatementTypes.TARGET_ENEMY_NANOVOR || _loc1_.target == AttackStatementTypes.TARGET_ENEMY_TEAM)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get conditional() : IConditional
      {
         return _conditional;
      }
      
      public function get pcDescription() : String
      {
         return _pcDescription;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function setWasUsed(param1:Boolean) : void
      {
         _wasUsed = param1;
      }
      
      public function get icons() : Array
      {
         return _icons;
      }
      
      public function get overrideDescription() : String
      {
         return _overrideDescription;
      }
      
      public function findAttackStatements(param1:String = null, param2:String = null) : Array
      {
         var _loc4_:IAttackStatement = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in _attackStatements)
         {
            if(!(param1 != null && param1 != _loc4_.type))
            {
               if(!(param2 != null && param2 != _loc4_.stat))
               {
                  _loc3_.push(_loc4_);
               }
            }
         }
         DebugLog.instance.log(">> Attack: findAttackStatements (sType=" + param1 + " sStat=" + param2 + "), returning array: " + _loc3_);
         return _loc3_;
      }
      
      public function get animationID() : int
      {
         return _animationID;
      }
      
      public function isDodgeable() : Boolean
      {
         var _loc1_:* = 0;
         while(_loc1_ < _attackStatements.length)
         {
            if(_attackStatements[_loc1_].target == AttackStatementTypes.TARGET_ENEMY_NANOVOR || _attackStatements[_loc1_].target == AttackStatementTypes.TARGET_ENEMY_TEAM)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get actionIconType() : String
      {
         return _actionIconType;
      }
      
      public function get hackDescription() : String
      {
         return _hackDescription;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function set expectedDamage(param1:Number) : void
      {
         _expectedDamage = param1;
      }
      
      public function set animationID(param1:int) : void
      {
         _animationID = param1;
      }
      
      public function get wasUsed() : Boolean
      {
         return _wasUsed;
      }
      
      public function get cost() : int
      {
         return _cost;
      }
      
      public function get forceDamage() : String
      {
         return _forceDamage;
      }
      
      public function get attackStatements() : Array
      {
         return _attackStatements;
      }
      
      public function get ammo() : String
      {
         return _ammo;
      }
      
      public function get expectedDamage() : Number
      {
         return Math.round(_expectedDamage);
      }
      
      public function get shortDescription() : String
      {
         return _shortDescription;
      }
      
      public function get keyword1() : String
      {
         return _keyword1;
      }
      
      public function get attackID() : int
      {
         return _attackID;
      }
      
      public function get hhDescription() : String
      {
         return _hhDescription;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[Attack|";
         _loc1_ += "_attackID=" + _attackID + ", ";
         _loc1_ += "_name=" + _name + ", ";
         _loc1_ += "_type=" + _type + ", ";
         _loc1_ += "_shortDescription=" + _shortDescription + ", ";
         _loc1_ += "_hhDescription=" + _hhDescription + ", ";
         _loc1_ += "_pcDescription=" + _pcDescription + ", ";
         _loc1_ += "_overrideDescription=" + _overrideDescription + ", ";
         _loc1_ += "_hackDescription=" + _hackDescription + ", ";
         _loc1_ += "_forceDamage=" + _forceDamage + ", ";
         _loc1_ += "_keyword1=" + _keyword1 + ", ";
         _loc1_ += "_keyword2=" + _keyword2 + ", ";
         _loc1_ += "_cost=" + _cost + ", ";
         _loc1_ += "_ammo=" + _ammo + ", ";
         _loc1_ += "_conditional=" + _conditional + ", ";
         _loc1_ += "_attackStatements=" + _attackStatements + ", ";
         _loc1_ += "_animationID=" + _animationID + ", ";
         _loc1_ += "_wasUsed=" + _wasUsed + ", ";
         _loc1_ += "_actionIconType=" + _actionIconType + ", ";
         _loc1_ += "_icons=" + _icons;
         return _loc1_ + "]";
      }
      
      public function get keyword2() : String
      {
         return _keyword2;
      }
   }
}

