package com.arkadium.virmon.senseibattle.battlelogic.nanovor
{
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class BattleLogicAttack
   {
      
      private var _inCombatDescription:String;
      
      private var _wasUsed:Boolean;
      
      private var _keywords:Array;
      
      private var _type:String;
      
      private var _attackStatements:Array;
      
      private var _cost:int;
      
      private var _ammo:int;
      
      private var _attackConditionals:Array;
      
      private var _description:String;
      
      private var _conditional:BattleLogicConditional;
      
      private var _overrideDescription:String;
      
      private var _hackDescription:String;
      
      private var _attackId:int;
      
      private var _name:String;
      
      private var _forceDamage:String;
      
      public function BattleLogicAttack(param1:int)
      {
         super();
         _attackId = param1;
         _name = "No Name";
         _type = "No Type";
         _cost = -1;
         _ammo = -1;
         _forceDamage = "none";
         _keywords = new Array();
         _inCombatDescription = "No Description";
         _description = "No Description";
         _overrideDescription = "No Description";
         _hackDescription = "No Description";
         _conditional = null;
         _attackStatements = new Array();
         _wasUsed = false;
      }
      
      private function setInCombatDescription(param1:String) : void
      {
         _inCombatDescription = param1;
      }
      
      public function get attackId() : int
      {
         return _attackId;
      }
      
      public function get conditional() : BattleLogicConditional
      {
         return _conditional;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function setName(param1:String) : void
      {
         _name = param1;
      }
      
      public function get overrideDescription() : String
      {
         return _overrideDescription;
      }
      
      public function setWasUsed(param1:Boolean) : void
      {
         _wasUsed = param1;
      }
      
      public function get hackDescription() : String
      {
         return _hackDescription;
      }
      
      public function addAttackStatement(param1:BattleLogicAttackStatement) : void
      {
         _attackStatements.push(param1);
      }
      
      public function isDodgeable() : Boolean
      {
         var _loc2_:BattleLogicAttackStatement = null;
         var _loc1_:uint = 0;
         while(_loc1_ < _attackStatements.length)
         {
            _loc2_ = _attackStatements[_loc1_];
            if(_loc2_.target == BattleLogicAttackStatement.TARGET_ENEMY_NANOVOR || _loc2_.target == BattleLogicAttackStatement.TARGET_ENEMY_TEAM)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get keywords() : Array
      {
         return _keywords;
      }
      
      public function parseXMLData(param1:XML) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:* = undefined;
         var _loc10_:BattleLogicAttackStatement = null;
         _name = String(param1.child("attack-name"));
         _type = String(param1.child("type"));
         _inCombatDescription = String(param1.child("short-in-combat-description"));
         _description = String(param1.child("pc-description"));
         _overrideDescription = String(param1.child("override-description"));
         _hackDescription = String(param1.child("hack-description"));
         _forceDamage = String(param1.child("force-damage"));
         _keywords[0] = String(param1.child("keyword-1"));
         _keywords[1] = String(param1.child("keyword-2"));
         _cost = Number(param1.child("cost"));
         _ammo = Number(param1.child("ammo"));
         var _loc2_:XMLList = param1.child("conditional");
         _attackConditionals = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length())
         {
            _loc6_ = String(_loc2_[_loc5_].child("conditional-name")[0]);
            _loc7_ = String(_loc2_[_loc5_].child("conditional-mod")[0]);
            _loc8_ = String(_loc2_[_loc5_].child("conditional-var")[0]);
            _conditional = new BattleLogicConditional(_loc6_,_loc7_,_loc8_);
            _attackConditionals.push(_conditional);
            _loc3_++;
         }
         _attackStatements = new Array();
         var _loc4_:XMLList = param1.child("attack-statement");
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc9_ = _loc4_[_loc5_].@id;
            _loc10_ = new BattleLogicAttackStatement(_loc9_,attackId);
            _loc10_.parseAttackStatement(_loc4_[_loc5_]);
            _attackStatements.push(_loc10_);
            _loc5_++;
         }
      }
      
      public function getKeyword(param1:int) : String
      {
         return _keywords[param1];
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      private function setKeywords(param1:Array) : void
      {
         _keywords = param1;
      }
      
      public function setType(param1:String) : void
      {
         _type = param1;
      }
      
      public function get forceDamage() : String
      {
         return _forceDamage;
      }
      
      public function get inCombatDescription() : String
      {
         return _inCombatDescription;
      }
      
      public function wasUsed() : Boolean
      {
         return _wasUsed;
      }
      
      public function setDescription(param1:String) : void
      {
         _description = param1;
      }
      
      private function setConditional(param1:BattleLogicConditional) : void
      {
         _conditional = param1;
      }
      
      public function get attackStatements() : Array
      {
         return _attackStatements;
      }
      
      public function get cost() : int
      {
         return _cost;
      }
      
      public function get ammo() : int
      {
         return _ammo;
      }
      
      public function setCost(param1:int) : void
      {
         _cost = param1;
      }
      
      private function setAmmo(param1:int) : void
      {
         _ammo = param1;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleLogicAttack>>\t" + param1);
      }
      
      private function setOverrideDescription(param1:String) : void
      {
         _overrideDescription = param1;
      }
      
      private function setHackDescription(param1:String) : void
      {
         _hackDescription = param1;
      }
      
      public function clone(param1:Boolean) : BattleLogicAttack
      {
         var _loc3_:uint = 0;
         var _loc4_:BattleLogicAttackStatement = null;
         var _loc5_:BattleLogicAttackStatement = null;
         var _loc2_:BattleLogicAttack = new BattleLogicAttack(_attackId);
         _loc2_.setName(_name);
         _loc2_.setType(_type);
         _loc2_.setCost(_cost);
         _loc2_.setAmmo(_ammo);
         _loc2_.setForceDamage(_forceDamage);
         _loc2_.setKeywords(_keywords);
         _loc2_.setInCombatDescription(_inCombatDescription);
         _loc2_.setDescription(_description);
         _loc2_.setOverrideDescription(_overrideDescription);
         _loc2_.setHackDescription(_hackDescription);
         if(_conditional != null)
         {
            _loc2_.setConditional(_conditional.clone());
         }
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < _attackStatements.length)
            {
               _loc4_ = _attackStatements[_loc3_];
               _loc5_ = _loc4_.clone();
               _loc2_.addAttackStatement(_loc5_);
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "[Name: " + _name + " | ";
         return _loc1_ + ("Cost: " + _cost + "]");
      }
      
      private function setForceDamage(param1:String) : void
      {
         _forceDamage = param1;
      }
      
      public function get description() : String
      {
         return _description;
      }
   }
}

