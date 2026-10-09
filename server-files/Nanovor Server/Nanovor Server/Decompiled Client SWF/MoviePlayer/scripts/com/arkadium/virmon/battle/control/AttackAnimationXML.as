package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.battle.CRef;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   internal class AttackAnimationXML
   {
      
      public var actionNodeID:String;
      
      public var victory:Boolean = false;
      
      public var repKill:RegExp = /(onHitAnimation.*Type="targetVirmon".*kill=)"(\d*)"/i;
      
      public var targetHealthDamage:int = 0;
      
      public var nameNode:String = "";
      
      public var targetDeathReg:RegExp = /onHitAnimation.*Type="targetVirmon" playerId="\d*" virmonType="\d*" kill="1"/i;
      
      public var removeTempTagReg:RegExp = /<.?temp>/gi;
      
      public var findKill:RegExp = /onHitAnimation.*hpchange.*end="0"/i;
      
      private var _postAttackStatementId:int;
      
      public var groupTextNodes:Array = new Array();
      
      public var playerID:int;
      
      public var grabHealthVals:RegExp = /start="(\d*)" end="(\d*)"/i;
      
      public var isPass:Boolean = false;
      
      public var onHitNodes:String = "";
      
      private var _postAttackGroupedTextEffects:Array;
      
      public var attackID:int;
      
      public var attackNode:String = "";
      
      public var healthRegEx:RegExp = /-[0-9]+\sHLTH/g;
      
      public var selfDeathReg:RegExp = /eventAnimation.*Type="targetVirmon" playerId="\d*?" virmonType="\d*?" kill="1"/i;
      
      public var targetPlayerID:int = -1;
      
      public var playerHealthDamage:int = 0;
      
      public var endHealthReg:RegExp = / end="\d*"/i;
      
      public function AttackAnimationXML(param1:int, param2:int)
      {
         super();
         actionNodeID = param1 + ":" + param2;
         playerID = param1;
         attackID = param2;
         _postAttackGroupedTextEffects = new Array();
      }
      
      public function setPostAttackGroupedTextEffects(param1:String, param2:int) : void
      {
         _postAttackStatementId = param2;
         _postAttackGroupedTextEffects.push(param1);
      }
      
      public function getCompiledXML() : String
      {
         var _loc1_:String = nameNode;
         if(isPass)
         {
            return _loc1_;
         }
         _loc1_ += getAttackNode() + "</animation>";
         _loc1_ += getGroupTextNodes();
         _loc1_ += getPostAttackGroupedTextEffects();
         _loc1_ = verifyKill(_loc1_);
         if(_loc1_.search(targetDeathReg) > -1 && _loc1_.search(selfDeathReg) == -1)
         {
            _loc1_ = buildVictoryAnimation(_loc1_);
         }
         return _loc1_;
      }
      
      public function buildVictoryAnimation(param1:String) : String
      {
         var block:String = param1;
         var killer:int = int(CRef.battleController.getPlayerByAnimationIndex(playerID).selectedNanovor.assetTypeId);
         var victoryNode:XML = new XML("<temp><animation animationType=\"visual\" playerId=\"" + playerID + "\" virmonType=\"" + killer + "\" animationID=\"Vi\"/></temp>");
         var baseXML:XML = new XML("<temp>" + block + "</temp>");
         baseXML.insertChildAfter(baseXML.animation.(@animationType == "attack")[0],victoryNode);
         return removeTempTags(baseXML.toXMLString());
      }
      
      public function setGroupTextNode(param1:String, param2:int, param3:int) : void
      {
         if(param1 == "" || param1 == null)
         {
            return;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < groupTextNodes.length)
         {
            if(groupTextNodes[_loc4_].playerID == param2)
            {
               groupTextNodes[_loc4_].xml += param1;
               return;
            }
            _loc4_++;
         }
         groupTextNodes.push({
            "playerID":param2,
            "xml":param1,
            "statementID":param3
         });
      }
      
      public function getGroupTextNodes() : String
      {
         var _loc4_:uint = 0;
         if(groupTextNodes.length == 0)
         {
            return "";
         }
         var _loc1_:String = "";
         var _loc2_:int = groupTextNodes[_loc4_].playerID == playerID ? playerHealthDamage : targetHealthDamage;
         var _loc3_:RegExp = /(<animation.*)(<animation.*selfDeathCausedByAttack="1".*\/>)(.*<\/animation>)/i;
         _loc4_ = 0;
         while(_loc4_ < groupTextNodes.length)
         {
            _loc1_ += "<animation animationType=\"groupedTextEffects\" playerId=\"" + groupTextNodes[_loc4_].playerID + "\" statementID=\"" + groupTextNodes[_loc4_].statementID + "\">" + groupTextNodes[_loc4_].xml + "</animation>";
            _loc1_ = _loc1_.replace(healthRegEx,"-" + _loc2_ + " HLTH");
            _loc4_++;
         }
         return _loc1_.replace(_loc3_,"$1$3$2");
      }
      
      public function removeTempTags(param1:String) : String
      {
         return param1.replace(removeTempTagReg,"");
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AttackAnimationXML>>\t" + param1);
      }
      
      public function getOnHitNodes() : String
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         log("getOnHitNodes() - Before formatting:\n" + onHitNodes);
         onHitNodes = onHitNodes.replace(healthRegEx,"-" + targetHealthDamage + " HLTH");
         log("getOnHitNodes() - First regex formatting:\n" + onHitNodes);
         if(onHitNodes.search(grabHealthVals) > -1)
         {
            _loc1_ = grabHealthVals.exec(onHitNodes);
            if(_loc1_[0] != null)
            {
               _loc2_ = int(_loc1_[1]);
               _loc3_ = int(_loc1_[2]);
               _loc4_ = _loc2_ - targetHealthDamage;
               DebugLog.instance.log("RoundController.getOnHitNodes() - targetHealthDamage: " + targetHealthDamage);
               _loc4_ = _loc4_ > 0 ? _loc4_ : 0;
               onHitNodes = onHitNodes.replace(endHealthReg," end=\"" + _loc4_ + "\"");
            }
         }
         log("getOnHitNodes() - Last formatting:\n" + onHitNodes);
         return onHitNodes;
      }
      
      public function getAttackNode() : String
      {
         var _loc1_:String = attackNode;
         var _loc2_:RegExp = /targetPlayerId=".*?"/i;
         _loc1_ = _loc1_.replace(_loc2_,"targetPlayerId=\"" + targetPlayerID + "\"");
         _loc1_ += getOnHitNodes();
         _loc1_ + "</animation>";
         return _loc1_;
      }
      
      public function setDamage(param1:PlayerAttack) : void
      {
         var _loc2_:String = param1.targetPlayer != param1.player ? "targetHealthDamage" : "playerHealthDamage";
         this[_loc2_] = int(this[_loc2_] + param1.totalDamage);
         DebugLog.instance.log("RoundController.setDamage() - totalDamage: " + param1.totalDamage);
      }
      
      private function getPostAttackGroupedTextEffects() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         if(0 == _postAttackGroupedTextEffects.length)
         {
            return _loc1_;
         }
         _loc1_ += "<animation animationType=\"groupedTextEffects\" playerId=\"" + playerID + "\" statementID=\"" + _postAttackStatementId + "\">";
         for each(_loc2_ in _postAttackGroupedTextEffects)
         {
            _loc1_ += _loc2_;
         }
         return _loc1_ + "</animation>";
      }
      
      public function verifyKill(param1:String) : String
      {
         var _loc2_:Object = null;
         if(param1.search(findKill) != -1)
         {
            _loc2_ = repKill.exec(param1);
            if(_loc2_[0] != null)
            {
               param1 = param1.replace(repKill,"$1\"1\"");
            }
         }
         return param1;
      }
   }
}

