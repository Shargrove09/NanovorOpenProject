package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.battle.CRef;
   import com.arkadium.virmon.battle.substates.combatgame.animation.AnimationUtils;
   import com.arkadium.virmon.battle.substates.combatgame.animation.CAnimation;
   import com.arkadium.virmon.framework.*;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.effects.*;
   import com.arkadium.virmon.shared.utils.*;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   import flash.events.*;
   import flash.xml.*;
   
   public class RoundController implements IRoundControllerNanovorChooser
   {
      
      private var _animation:CAnimation;
      
      private var _statementID:int = -1;
      
      private var _initialized:Boolean = false;
      
      private var _overlayAssetRetriever:IOverlayAssetRetriever;
      
      private var animationCompleteFunction:Function;
      
      private var _bc:BattleController;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _turnData:String;
      
      private var _playerAttack:PlayerAttack;
      
      public var animationInitialized:Boolean = false;
      
      private var _dm:IDataManager;
      
      private var _sequence:Array;
      
      public function RoundController(param1:BattleController, param2:ICharacterAssetTypeCache, param3:IOverlayAssetRetriever)
      {
         super();
         _bc = param1;
         _characterAssetTypeCache = param2;
         _overlayAssetRetriever = param3;
         if(!_initialized)
         {
            init();
         }
         CRef.roundController = this;
      }
      
      public function getSwapXML() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < _bc.players.length)
         {
            if(Boolean(_bc.players[_loc2_].hasNewNanovor) || _bc.players[_loc2_].swapReason == AttackActionTypes.BLOCK_SWAP)
            {
               _loc1_ += AnimationUtils.generateSwapXML(_bc.players[_loc2_],_statementID);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function buildXMLFromAttackStatement() : void
      {
         var _loc1_:AttackAnimationXML = null;
         var _loc9_:int = 0;
         var _loc10_:INanovor = null;
         var _loc11_:uint = 0;
         var _loc12_:INanovor = null;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:int = 0;
         var _loc19_:Boolean = false;
         var _loc20_:String = null;
         var _loc2_:IPlayer = _playerAttack.player;
         var _loc3_:IPlayer = _playerAttack.targetPlayer;
         var _loc4_:IAttackStatement = _playerAttack.attackStatement;
         _statementID = _playerAttack.playerAttackIndex;
         var _loc5_:int = _playerAttack.attackId;
         log("...and the attackId for it is: " + _loc5_);
         var _loc6_:int = 1;
         if(_loc5_ != 0)
         {
            if(_loc4_ == null && _playerAttack.reason != AttackActionTypes.DODGED)
            {
               log("null attackStatement found.  Reason: " + _playerAttack.reason);
               if(_playerAttack.reason == AttackActionTypes.NONE)
               {
                  return;
               }
            }
            else
            {
               if(_loc4_ != null)
               {
                  _loc13_ = _loc4_.stat;
               }
               if(_loc4_ != null)
               {
                  _loc14_ = _playerAttack.newValueOfStat;
               }
               _loc9_ = _playerAttack.reason;
               _loc10_ = _loc2_.selectedNanovor;
               _loc11_ = 0;
               while(_loc11_ < _loc10_.attacks.length)
               {
                  if(_loc10_.attacks[_loc11_].attackID == _loc5_)
                  {
                     _loc6_ = _loc11_ + 1;
                     break;
                  }
                  _loc11_++;
               }
               _loc12_ = _loc3_.selectedNanovor;
            }
         }
         var _loc7_:String = _loc2_.animationIndex + ":" + _loc5_;
         var _loc8_:uint = 0;
         while(_loc8_ < _sequence.length)
         {
            if(_sequence[_loc8_].actionNodeID == _loc7_)
            {
               _loc1_ = _sequence[_loc8_];
            }
            _loc8_++;
         }
         if(_loc1_ == null)
         {
            _loc1_ = new AttackAnimationXML(_loc2_.animationIndex,_loc5_);
            _loc1_.actionNodeID = _loc7_;
            _sequence.push(_loc1_);
         }
         if(_loc5_ == 0 || AttackActionTypes.FIZZLE_REASONS.indexOf(_playerAttack.reason) > -1)
         {
            _loc15_ = _playerAttack.player.selectedNanovor.isDead ? 2 : _playerAttack.reason;
            log("ftemp: pass found from " + _loc2_.username + ".  Reason: " + _loc15_);
            _loc1_.targetPlayerID = 0;
            _loc1_.nameNode = AnimationUtils.getPassDescription(_loc2_.animationIndex,_loc15_);
            _loc1_.isPass = true;
         }
         else
         {
            _loc16_ = "attack";
            if(_loc1_.targetPlayerID != -1)
            {
               if(_loc1_.targetPlayerID == _loc2_.animationIndex)
               {
                  _playerAttack.targetPlayer.animationIndex;
               }
            }
            if(_loc1_.targetPlayerID == -1)
            {
               _loc1_.targetPlayerID = _playerAttack.targetPlayer.animationIndex;
            }
            _loc17_ = "<animation animationType=\"textEffect\" playerId=\"" + _loc2_.animationIndex + "\" animationID=\"attackName\" myMessage=\"" + _loc10_.selectedAttack.name + "\" />";
            if(_playerAttack.isCrit)
            {
               _loc17_ += "<animation animationType=\"textEffect\" playerId=\"" + _loc2_.animationIndex + "\" animationID=\"crit\" myMessage=\"CRIT\"/>";
            }
            if(_playerAttack.isGlitch)
            {
               _loc17_ += "<animation animationType=\"textEffect\" playerId=\"" + _loc2_.animationIndex + "\" animationID=\"glitch\" myMessage=\"GLITCH\"/>";
            }
            _loc18_ = _playerAttack.dodge ? 1 : 0;
            _loc17_ += "<animation animationType=\"" + _loc16_.toLowerCase() + "\" playerId=\"" + _loc2_.animationIndex + "\" virmonType = \"" + _loc10_.assetTypeId + "\" animationID=\"At" + _loc6_ + "\"" + " targetPlayerId=\"" + _loc3_.animationIndex + "\" dodge=\"" + _loc18_ + "\">";
            _loc1_.attackNode = _loc17_;
            if(_loc13_ == Stat.HEALTH)
            {
               _loc1_.setDamage(_playerAttack);
            }
            _loc19_ = _loc1_.onHitNodes.search("targetVirmon") > -1;
            if(_loc3_ != _loc2_)
            {
               _loc20_ = AnimationUtils.generateReactiveAnimation(_playerAttack,_loc3_.animationIndex,_loc3_,AnimationUtils.ON_HIT_ANIMATION,_loc6_,_statementID,_loc19_);
               log("buildXMLFromAttackStatement() - onHitNodeAddition: " + _loc20_);
               if(_loc1_.onHitNodes.search("hpchange") == -1 || _loc20_.search("hpchange") == -1)
               {
                  log("buildXMLFromAttackStatement() - Adding onHitNodeAddition");
                  _loc1_.onHitNodes += _loc20_;
               }
            }
            else
            {
               _loc1_.setGroupTextNode(AnimationUtils.generateReactiveAnimation(_playerAttack,_loc3_.animationIndex,_loc3_,AnimationUtils.EVENT_ANIMATION,_loc6_,_statementID),_loc3_.animationIndex,_statementID);
            }
         }
      }
      
      private function processNextStatement() : void
      {
         _playerAttack = _bc.getNextPlayerAttack();
         if(_playerAttack != null)
         {
            buildXMLFromAttackStatement();
            _bc.applyCurrentPlayerAttack();
            processNextStatement();
         }
         else
         {
            beginAnimation();
         }
      }
      
      public function out(param1:String) : void
      {
      }
      
      public function startRound() : void
      {
         _sequence = new Array();
         _turnData = "<turnData>";
         _turnData += roundBeginXML();
         processNextStatement();
      }
      
      public function initAnimation(param1:DisplayObjectContainer, param2:Function) : void
      {
         log("RoundController::initAnimation -- \n\tanimationWindow: " + param1 + "\n\tanimCompFunc: " + param2);
         if(animationInitialized)
         {
            return;
         }
         _animation.defineBattleGround(param1);
         animationCompleteFunction = param2;
         _animation.addEventListener(CAnimation.ON_LOAD,animationCompleteFunction,false,0,true);
         _animation.addEventListener(BattleEngineEvent.INITIALIZE,setListener);
         _animation.initiateNewBattle(_bc.players.length);
         animationInitialized = true;
      }
      
      public function getRCAnimationXML() : String
      {
         return _turnData;
      }
      
      private function beginAnimation() : void
      {
         if(_animation != null)
         {
            if(_animation.moviePlayer != null)
            {
               if(_animation.moviePlayer._smcFightEngine == null)
               {
                  logError("** RoundController::beginAnimation: _animation.moviePlayer._smcFightEngine = null");
               }
            }
            else
            {
               logError("** RoundController::beginAnimation: _animation.moviePlayer = null");
            }
         }
         else
         {
            logError("** RoundController::beginAnimation _animation = null");
         }
         log("<<RC>>animation: " + _animation);
         if(_animation.moviePlayer == null)
         {
            return;
         }
         _animation.moviePlayer._smcFightEngine.choosingNanovor = false;
         log("\n\nRoundController::beginAnimation --> BEGINNING ANIMATION\n\n");
         var _loc1_:uint = 0;
         while(_loc1_ < _sequence.length)
         {
            _turnData += _sequence[_loc1_].getCompiledXML();
            _loc1_++;
         }
         _turnData += getSwapXML();
         _turnData += "</turnData>";
         var _loc2_:XML = new XML(_turnData);
         _animation.startTurn(_loc2_);
      }
      
      public function chooseNanovor() : void
      {
         log("// >>-FMA-> RoundController::chooseNanovor hit");
         _animation.moviePlayer._smcFightEngine.choosingNanovor = true;
         _animation.moviePlayer._smcFightEngine.superEndOfTurn = false;
         if(!_animation.moviePlayer._smcFightEngine.battleInitiated)
         {
            _animation.moviePlayer._smcFightEngine.initiateBattle(1,_characterAssetTypeCache,_overlayAssetRetriever);
         }
         var _loc1_:String = "<turnData>";
         _loc1_ += "<animation animationType=\"newVirmon\" playerId=\"0\" name=\"" + _bc.myPlayer.selectedNanovor.nickName + "\" virmonType=\"" + _bc.myPlayer.selectedNanovor.assetTypeId + "\" animationID=\"Id\" isNew=\"1\"/>";
         _loc1_ += "<animation animationType=\"visual\" playerId=\"0\"" + " virmonType=\"" + _bc.myPlayer.selectedNanovor.assetTypeId + "\" animationID=\"Re\"/>";
         _loc1_ += "<animation animationType=\"delay\" delayTime=\"1000\"/></turnData>";
         log("// >>-FMA->  td:\n" + _loc1_);
         _animation.startTurn(new XML(_loc1_));
      }
      
      public function preloadMoviePlayer() : void
      {
         if(_animation.moviePlayer == null)
         {
            _animation.loadMoviePlayer();
         }
      }
      
      private function roundBeginXML() : String
      {
         var _loc1_:String = "";
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < _bc.players.length)
         {
            if(_bc.players[_loc3_].animationIndex == -1)
            {
               _bc.players[_loc3_].animationIndex = _loc3_;
            }
            if(!(_bc.players[_loc3_].selectedNanovor == null || Boolean(_bc.players[_loc3_].selectedNanovor.isDead)))
            {
               if(!Boolean(_bc.players[_loc3_].leftGame))
               {
                  _loc2_.push({
                     "playerRefId":_bc.players[_loc3_].animationIndex,
                     "initiative":_bc.players[_loc3_].roundPosition
                  });
                  if(_bc.players[_loc3_].selectedNanovor != null)
                  {
                     if(_bc.currentRound == 1 || _bc.players[_loc3_].lastNanovorDiedInRoundNum == _bc.currentRound - 1)
                     {
                        if(_bc.players[_loc3_] != _bc.myPlayer)
                        {
                           log("roundBeginXML::setting entrance animation for player: " + _bc.players[_loc3_] + " (myPlayer: " + _bc.myPlayer + ")");
                           _loc1_ += "<animation animationType=\"newVirmon\" playerId=\"" + _bc.players[_loc3_].animationIndex + "\" name=\"" + _bc.players[_loc3_].selectedNanovor.nickName + "\" virmonType=\"" + _bc.players[_loc3_].selectedNanovor.assetTypeId + "\" animationID=\"Id\" isNew=\"1\"/>";
                           _loc1_ += "<animation animationType=\"visual\" playerId=\"" + _bc.players[_loc3_].animationIndex + "\" virmonType=\"" + _bc.players[_loc3_].selectedNanovor.assetTypeId + "\" animationID=\"En\"/>";
                           _loc1_ += "<animation animationType=\"delay\" delayTime=\"1000\"/>";
                        }
                     }
                  }
               }
            }
            _loc3_++;
         }
         _loc2_.sortOn("initiative",Array.NUMERIC);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc1_ += "<animation animationType=\"textEffect\" playerId=\"" + _loc2_[_loc4_].playerRefId + "\" animationID=\"inititive\" myMessage=\"" + (_loc2_[_loc4_].initiative + 1) + "\"/>";
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("<<RoundController>> *ERROR* " + param1);
      }
      
      private function updateWidget(param1:BattleEngineEvent) : void
      {
         log("%rsk% RoundController: updateWidget: xml = \n" + (Boolean(param1.data.node) ? param1.data.node.toXMLString() : "[null]"));
         _bc.updatePlayerUIDuringAnimation(int(param1.data.statementID));
      }
      
      public function get endOfTurn() : Boolean
      {
         return _animation.moviePlayer._smcFightEngine.endOfTurn;
      }
      
      public function init() : void
      {
         log("RoundController initializing");
         _dm = DataManager.getInstance();
         _sequence = new Array();
         _initialized = true;
         _animation = _bc.combatUIController.battleGame.animation;
      }
      
      public function get superEndOfTurn() : Boolean
      {
         return _animation.moviePlayer._smcFightEngine.superEndOfTurn;
      }
      
      private function setListener(param1:BattleEngineEvent) : void
      {
         _animation.moviePlayer._smcFightEngine._oEventDispatcher.addEventListener(BattleEngineEvent.UPDATE_PLAYER_WIDGET,updateWidget,false,0,true);
         _animation.removeEventListener(BattleEngineEvent.INITIALIZE,setListener);
      }
      
      private function onLcStatusEvent(param1:StatusEvent) : void
      {
         log("RSK is yer daddy: " + param1.toString());
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         out("Destroying RoundController");
         if(animationInitialized)
         {
            _animation.removeEventListener(CAnimation.ON_LOAD,animationCompleteFunction);
            _animation.moviePlayer._smcFightEngine._oEventDispatcher.removeEventListener(BattleEngineEvent.UPDATE_PLAYER_WIDGET,updateWidget);
         }
         if(_animation != null)
         {
            _animation.destroy();
         }
         for(_loc1_ in this)
         {
            this[_loc1_] = null;
         }
         delete global[this];
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<RoundController>>\t" + param1);
      }
   }
}

