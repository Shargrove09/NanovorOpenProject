package com.arkadium.virmon.framework
{
   import com.arkadium.virmon.common.AttackIconType;
   import com.arkadium.virmon.shared.utils.CFormulaParser;
   import com.arkadium.virmon.shared.utils.IVirmon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class VirmonAttackData implements IVirmonAttackData
   {
      
      private const STATEMENT_CONDS:int = 10;
      
      private var _sOverrideDescription:String;
      
      private var _sHackDescription:String;
      
      private var _uintID:uint;
      
      private var _sPCDescription:String;
      
      private var _aAttackConditionals:Array;
      
      private var _sName:String;
      
      private var _aDMGFormuls:Array;
      
      private var _virmon:IVirmon;
      
      private var _sForceDamage:String;
      
      private var _sType:String;
      
      private var _aAttackStatements:Array;
      
      private var _nCost:Number;
      
      private var _sAmmo:String;
      
      private var _sHHDescription:String;
      
      private var _sIconType:String;
      
      private var _sShortDescription:String;
      
      private var _sKeyword1:String;
      
      private var _sKeyword2:String;
      
      public function VirmonAttackData()
      {
         super();
      }
      
      public function getForceDamage() : String
      {
         return _sForceDamage;
      }
      
      public function getAttackType() : String
      {
         return _sType;
      }
      
      public function getAttackConditionals() : Array
      {
         return _aAttackConditionals;
      }
      
      private function evaluateAttackConditionals() : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Conditional = null;
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < _aAttackConditionals.length)
         {
            _loc3_ = _aAttackConditionals[_loc2_].name;
            _loc4_ = _aAttackConditionals[_loc2_].mod;
            _loc5_ = _aAttackConditionals[_loc2_].val;
            _loc6_ = new Conditional(_virmon,_loc3_,_loc4_,_loc5_);
            _loc1_ &&= _loc6_.evaluate();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getDamage(param1:IVirmon) : Number
      {
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:Conditional = null;
         var _loc13_:String = null;
         _virmon = param1;
         var _loc2_:Number = Number(param1.getStrength());
         var _loc3_:Boolean = evaluateAttackConditionals();
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _aAttackStatements.length)
         {
            _loc6_ = _loc3_;
            _loc7_ = _aAttackStatements[_loc5_];
            if(String(_loc7_.type).toLowerCase() == "attack")
            {
               _loc8_ = 0;
               while(_loc8_ < _loc7_.aConditionals.length)
               {
                  if(String(_loc7_.aConditionals[_loc8_].name).indexOf("failed") >= 0)
                  {
                     _loc6_ = !_loc6_;
                  }
                  else
                  {
                     _loc9_ = _loc7_.aConditionals[_loc8_].name;
                     _loc10_ = _loc7_.aConditionals[_loc8_].mod;
                     _loc11_ = _loc7_.aConditionals[_loc8_].val;
                     _loc12_ = new Conditional(_virmon,_loc9_,_loc10_,_loc11_);
                     _loc6_ &&= _loc12_.evaluate();
                  }
                  _loc8_++;
               }
               if(_loc6_)
               {
                  _loc13_ = CFormulaParser.trim(_loc7_.baseDamageFormula.toString());
                  _loc4_ += CFormulaParser.parseFormula(_loc13_,_loc2_);
               }
            }
            _loc5_++;
         }
         return Math.round(_loc4_);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> VirmonAttackData: " + param1);
      }
      
      public function parseXMLData(param1:XML) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:* = undefined;
         var _loc10_:XMLList = null;
         var _loc11_:XMLList = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         _uintID = param1.@id;
         _sName = String(param1.child("attack-name"));
         _sType = String(param1.child("type"));
         _sShortDescription = String(param1.child("short-in-combat-description"));
         _sHHDescription = String(param1.child("hh-description"));
         _sPCDescription = String(param1.child("pc-description"));
         _sOverrideDescription = String(param1.child("override-description"));
         _sHackDescription = String(param1.child("hack-description"));
         _sForceDamage = String(param1.child("force-damage"));
         _sKeyword1 = String(param1.child("keyword-1"));
         _sKeyword2 = String(param1.child("keyword-2"));
         _nCost = Number(param1.child("cost"));
         _sAmmo = String(param1.child("ammo"));
         var _loc2_:XMLList = param1.child("conditional");
         _aAttackConditionals = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length())
         {
            _loc6_ = new Object();
            _loc7_ = new Object();
            _loc7_.name = String(_loc2_[_loc5_].child("conditional-name")[0]);
            _loc7_.mod = String(_loc2_[_loc5_].child("conditional-mod")[0]);
            _loc7_.val = String(_loc2_[_loc5_].child("conditional-var")[0]);
            _aAttackConditionals.push(_loc7_);
            _loc3_++;
         }
         _aDMGFormuls = new Array();
         _aAttackStatements = new Array();
         var _loc4_:XMLList = param1.child("attack-statement");
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length())
         {
            _loc8_ = new Object();
            _loc8_.id = int(_loc4_[_loc5_].@id);
            _loc8_.attackStatementName = _loc4_[_loc5_].child("attack-statement-name");
            _loc8_.type = _loc4_[_loc5_].child("type");
            _loc8_.target = _loc4_[_loc5_].child("target");
            _loc8_.stat = _loc4_[_loc5_].child("stat");
            _loc8_.verb = _loc4_[_loc5_].child("verb");
            _loc8_.delay = _loc4_[_loc5_].child("delay");
            _loc8_.duration = _loc4_[_loc5_].child("duration");
            _loc8_.baseDamageFormula = _loc4_[_loc5_].child("base-damage-formula");
            _loc8_.statementFormula = _loc4_[_loc5_].child("statement-formula");
            _aAttackStatements.push(_loc8_);
            if(_loc4_[_loc5_].child("base-damage-formula") != "")
            {
               _aDMGFormuls.push(CFormulaParser.trim(_loc4_[_loc5_].child("base-damage-formula").toString()));
            }
            _loc8_.aConditionals = new Array();
            _loc9_ = 1;
            while(_loc9_ <= STATEMENT_CONDS)
            {
               _loc10_ = _loc4_[_loc5_].child("conditional-" + _loc9_);
               if(Boolean(_loc10_.length()))
               {
                  _loc12_ = new Object();
                  _loc12_.isRound = false;
                  _loc12_.name = String(_loc10_[0].child("conditional-name")[0]);
                  _loc12_.mod = String(_loc10_[0].child("conditional-mod")[0]);
                  _loc12_.val = String(_loc10_[0].child("conditional-var")[0]);
                  _loc8_.aConditionals.push(_loc12_);
               }
               _loc11_ = _loc4_[_loc5_].child("round-conditional-" + _loc9_);
               if(Boolean(_loc11_.length()))
               {
                  _loc13_ = new Object();
                  _loc13_.isRound = true;
                  _loc13_.name = String(_loc11_[0].child("conditional-name")[0]);
                  _loc13_.mod = String(_loc11_[0].child("conditional-mod")[0]);
                  _loc13_.val = String(_loc11_[0].child("conditional-var")[0]);
                  _loc8_.aConditionals.push(_loc13_);
               }
               _loc9_++;
            }
            _loc5_++;
         }
         _sIconType = determineIconType();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> VirmonAttackData: " + param1);
      }
      
      public function set iconType(param1:String) : void
      {
         _sIconType = param1;
      }
      
      private function calcAttackDMG(param1:int) : Number
      {
         var _loc2_:Number = -1;
         var _loc3_:Number = 0;
         var _loc4_:uint = _aDMGFormuls.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = CFormulaParser.parseFormula(_aDMGFormuls[_loc5_],param1);
            if(!isNaN(_loc3_))
            {
               _loc2_ = Math.max(_loc3_,_loc2_);
            }
            _loc5_++;
         }
         return Math.round(_loc2_);
      }
      
      public function getCost() : Number
      {
         return _nCost;
      }
      
      private function determineIconType() : String
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         if(_sKeyword1 == AttackIconType.OVERRIDE)
         {
            for each(_loc1_ in _aAttackStatements)
            {
               switch(String(_loc1_.stat))
               {
                  case AttackIconType.RED_SPIKE:
                  case AttackIconType.BLUE_SPIKE:
                  case AttackIconType.YELLOW_SPIKE:
                     return String(_loc1_.stat);
               }
            }
         }
         else if(_sKeyword1 == AttackIconType.MELEE)
         {
            _loc2_ = true;
            _loc3_ = true;
            for each(_loc1_ in _aAttackStatements)
            {
               if(String(_loc1_.type) != "Hack")
               {
                  _loc2_ = false;
               }
               if(String(_loc1_.type) != "Mod")
               {
                  _loc3_ = false;
               }
            }
            if(_loc2_)
            {
               return AttackIconType.HACK;
            }
            if(_loc3_)
            {
               return AttackIconType.MOD;
            }
         }
         return _sKeyword1;
      }
      
      public function getAttackStatements() : Array
      {
         return _aAttackStatements;
      }
      
      public function getAmmo() : String
      {
         return _sAmmo;
      }
      
      public function get iconType() : String
      {
         return _sIconType;
      }
      
      public function getShortDescription() : String
      {
         return _sShortDescription;
      }
      
      public function isTargetOpponent() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < _aAttackStatements.length)
         {
            if(_aAttackStatements[_loc1_].target.indexOf("Enemy") == 0)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function getAttackID() : uint
      {
         return _uintID;
      }
      
      public function getKeyword1() : String
      {
         return _sKeyword1;
      }
      
      public function getOverrideDescription() : String
      {
         return _sOverrideDescription;
      }
      
      public function getKeyword2() : String
      {
         return _sKeyword2;
      }
      
      public function getHackDescription() : String
      {
         return _sHackDescription;
      }
      
      public function getAttackName() : String
      {
         return _sName;
      }
      
      public function getHandHeldDescription() : String
      {
         return _sHHDescription;
      }
      
      public function getPCDescription() : String
      {
         return _sPCDescription;
      }
   }
}

