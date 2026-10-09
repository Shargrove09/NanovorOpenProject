package com.arkadium.virmon.movieplayer
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.BattleEngineEvent;
   import com.arkadium.virmon.battle.substates.combatgame.CombatGamePanel;
   import com.arkadium.virmon.framework.*;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.enum.OverlayAssetType;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.Managers;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.filters.BlurFilter;
   import flash.media.SoundTransform;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.System;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol161")]
   public dynamic class FightEngine extends MovieClip
   {
      
      public static var MOVETO_CURRENTDIRECTION:* = 700;
      
      public static var MOVETO_CENTER:* = 500;
      
      public static var MOVETO_LEFT:* = 1000;
      
      public static var MOVETO_RIGHT:* = -1;
      
      public static var MOVETO_PANORAMA:* = 1500;
      
      public var _nTotalTextEffectContainers:Number;
      
      private var holdingForTween:Boolean = false;
      
      private var movingToPanorama:Boolean = true;
      
      public var battleInitiated:Boolean = false;
      
      private var _overlayAssetRetriever:IOverlayAssetRetriever;
      
      public var _nActiveOverlays:Number;
      
      public var _nCurrentTextEffectContainer:Number;
      
      public var _nActiveAnimations:Number;
      
      public var _nTargetBattleGroundXLoc:Number;
      
      public var _nTotalMoves:Number;
      
      private const _ANIMATION_TYPE_OVERLAY:String = "animationTypeOverlay";
      
      public var _xlCombatXMLToLoad:XMLList;
      
      public var _mcAnimationHolder:MovieClip;
      
      private var _nVirmon:int;
      
      private var _buffer:int = 80;
      
      public var _nAnimationsLoaded:uint;
      
      public var superEndOfTurn:Boolean = true;
      
      private var preCombat:Boolean = true;
      
      public var _nCombatXMLLoaded:Number;
      
      private var animationXMLURL:String;
      
      public var _cMovingVirmon:*;
      
      public var _aVirmonContainers:Array;
      
      public var _nNumVirmon:uint;
      
      public var _smcVersionControl:VersionDisplay;
      
      public var fightLoggingLevel:int = 100;
      
      private var currentTurn:int = -1;
      
      public var _fPostMove:Function;
      
      public var _nActivelyPlayingTextEffectContainers:Number;
      
      public var endOfTurn:Boolean = true;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      public var _mcOverlayContainerHolder:MovieClip;
      
      private var baselineY:int;
      
      public var _nTargetBattleGroundScale:Number;
      
      private var currentTweenCount:int = 0;
      
      public var _aCombatXML:Dictionary;
      
      public var _nPlayers:Number;
      
      public var _nXmlLoaded:uint;
      
      private var bReachedX:Boolean = true;
      
      public var _oEventDispatcher:EventDispatcher;
      
      public var _nTotalOverlays:Number;
      
      private var _animationXML:Dictionary;
      
      private var spacingArray:Array;
      
      public var _aVirmonAnimations:Array;
      
      public var _xTurnData:XML;
      
      public var _aTextEffectContainers:Array;
      
      public var _aNickNames:Array;
      
      public var _nTotalAnimations:Number;
      
      private const _ANIMATION_TYPE_CHARACTER:String = "animationTypeCharacter";
      
      public var _smcBattleground:MovieClip;
      
      public var _bSoundOn:Boolean;
      
      public var _nTurnSequence:Number;
      
      public var choosingNanovor:Boolean = false;
      
      public function FightEngine()
      {
         super();
         _oEventDispatcher = new EventDispatcher();
      }
      
      private function dodgeEvent(param1:AnimationContainer) : void
      {
         var xOnHitAnimations:* = undefined;
         var nPlayerId:* = undefined;
         var sAnimationID:* = undefined;
         var sVirmonType:* = undefined;
         var sAnimationName:String = null;
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            xOnHitAnimations = _xTurnData.animation[_nTurnSequence].onHitAnimation;
            nPlayerId = xOnHitAnimations[0].@playerId;
            sAnimationID = xOnHitAnimations[0].@animationID;
            sVirmonType = xOnHitAnimations[0].@virmonType;
            sAnimationName = nPlayerId + "_" + sVirmonType + "_Do";
            setTriggerPointsForTarget(_aVirmonContainers[nPlayerId],_mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData,sAnimationName);
            ++_nActiveAnimations;
            _aVirmonContainers[nPlayerId].doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
         }
         catch(e:Error)
         {
            logError("Error during dodgeEvent: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function getCombatXML(param1:String) : *
      {
         var _loc2_:Object = null;
         for each(_loc2_ in _aCombatXML)
         {
            if(_loc2_.type == param1)
            {
               return _loc2_.xml;
            }
         }
         return null;
      }
      
      private function virmonAnimationLoadError(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,virmonAnimationLoaded);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,virmonAnimationLoadError);
         logError("Failed to load animation: " + param1.text);
         ++_nAnimationsLoaded;
         loadNextVirmonAnimationsInOrder();
      }
      
      private function finishVirmonAttackAnimation(param1:AnimationContainer) : void
      {
         var xCurrentAnimation:* = undefined;
         var nPlayerId:* = undefined;
         var sVirmonType:* = undefined;
         var sAnimationName:* = undefined;
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::finishVirmonAttackAnimation in try statement line 1553  --fma",2);
            mcAnimationContainer.clearEventsList();
            if(mcAnimationContainer.x != DataManager.getInstance()._nFirstContainerX + mcAnimationContainer._nPlayerOrder * DataManager.getInstance()._nContainerSeperationX)
            {
               mcAnimationContainer.x = DataManager.getInstance()._nFirstContainerX + mcAnimationContainer._nPlayerOrder * DataManager.getInstance()._nContainerSeperationX;
            }
            if(mcAnimationContainer._mcActiveAnimation._xAnimationData.meleetransfer != undefined)
            {
               ++_nActiveAnimations;
               xCurrentAnimation = _xTurnData.animation[_nTurnSequence];
               nPlayerId = xCurrentAnimation.@playerId;
               sVirmonType = xCurrentAnimation.@virmonType;
               sAnimationName = nPlayerId + "_" + sVirmonType + "_Re";
               mcAnimationContainer.doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
            }
            else
            {
               mcAnimationContainer.playIdleAnimation(mcAnimationContainer);
            }
            --_nActiveAnimations;
            if(_nActiveAnimations <= 0)
            {
               finishAnimationSet();
            }
         }
         catch(e:Error)
         {
            mcAnimationContainer.playIdleAnimation(mcAnimationContainer);
            logError("Error during finishVirmonAttackAnimation: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function startTurnAction() : void
      {
         try
         {
            fightLog("@@@ startTurnAction: setting endOfTurn = false",1);
            endOfTurn = false;
            superEndOfTurn = false;
            ++currentTurn;
            _nTotalMoves = _xTurnData.animation.length();
            _nTurnSequence = 0;
            _nCurrentTextEffectContainer = 0;
            _nActivelyPlayingTextEffectContainers = 0;
            doNextAnimationSet();
         }
         catch(e:Error)
         {
            logError("Error during startTurnAction: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function fightLog(param1:*, param2:int = 0) : void
      {
         var _loc4_:String = null;
         var _loc3_:String = param1 is Array ? "[Array]\n" : "";
         if(param1 is String)
         {
            param1 = [param1];
         }
         if(param1.length == 1)
         {
            _loc3_ = param1[0];
         }
         else
         {
            for(_loc4_ in param1)
            {
               _loc3_ += "\n\t[" + _loc4_ + "] " + param1[_loc4_];
            }
         }
         if(fightLoggingLevel >= param2)
         {
            DebugLog.instance.log("<<FightEngine>> -- " + _loc3_);
         }
      }
      
      private function finishTextEffect(param1:AnimationContainer) : void
      {
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::finishTextEffect in try statement line 1619  --fma",2);
            mcAnimationContainer.clearEventsList();
            mcAnimationContainer.stopAnimation();
            if(_smcBattleground.contains(mcAnimationContainer))
            {
               _smcBattleground.removeChild(mcAnimationContainer);
            }
            --_nActiveAnimations;
            --_nActivelyPlayingTextEffectContainers;
            if(_nActiveAnimations <= 0)
            {
               finishAnimationSet();
            }
         }
         catch(e:Error)
         {
            logError("Error during finishTextEffect: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      public function prepareTurn(param1:XML) : void
      {
         log("REK xTurn: " + param1);
         fightLog("FightEngine::prepareTurn",2);
         _mcAnimationHolder = new MovieClip();
         _mcOverlayContainerHolder = new MovieClip();
         _xTurnData = param1;
         loadRequiredCombatXML();
      }
      
      private function removeVirmon(param1:uint) : void
      {
         if(_smcBattleground.contains(_aVirmonContainers[param1]))
         {
            _smcBattleground.removeChild(_aVirmonContainers[param1]);
            _aVirmonContainers[param1].removeMe();
            _aVirmonContainers[param1] = null;
         }
         if(_smcBattleground.contains(_aNickNames[param1]))
         {
            _smcBattleground.removeChild(_aNickNames[param1]);
            _aNickNames[param1] = null;
         }
      }
      
      private function finishKillerAnimation(param1:AnimationContainer) : void
      {
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::finishKillerAnimation in try statement line 1582  --fma",2);
            mcAnimationContainer.clearEventsList();
            mcAnimationContainer.stopAnimation(mcAnimationContainer._mcActiveAnimation.totalFrames);
            --_nActiveAnimations;
            if(_nActiveAnimations <= 0)
            {
               finishAnimationSet();
            }
         }
         catch(e:Error)
         {
            logError("Error during finishVirmonAttackAnimation: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function reachedLocation() : void
      {
         var xCurrentAnimation:* = undefined;
         var nPlayerId:* = undefined;
         var sAnimationID:* = undefined;
         var sVirmonType:* = undefined;
         var sAnimationName:String = null;
         var xEventAnimation:* = undefined;
         var count:uint = 0;
         var targetPlayerId:Number = NaN;
         var objDepth:Number = NaN;
         var myPlayerLayer:Number = NaN;
         var playerDepth:Number = NaN;
         var nAttackNum:Number = NaN;
         var xCombatXml:* = undefined;
         var deathAnimation:* = undefined;
         try
         {
            fightLog("FightEngine::reachedLocation in try statement line 893 (this is a rather large function)  --fma",2);
            xCurrentAnimation = _xTurnData.animation[_nTurnSequence];
            if(xCurrentAnimation.@animationType == "newVirmon")
            {
               nPlayerId = xCurrentAnimation.@playerId;
               sAnimationID = xCurrentAnimation.@animationID;
               sVirmonType = xCurrentAnimation.@virmonType;
               sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
               if(choosingNanovor)
               {
                  if(_aVirmonContainers.length == 0)
                  {
                     _aVirmonContainers[0] = createVirmon(0);
                  }
                  _aVirmonContainers[0].setNewIdleAnimation(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
               }
               else if(_aVirmonContainers[nPlayerId]._mcIdleAnimation == null)
               {
                  log("Setting new idle animation for player " + nPlayerId);
                  _aVirmonContainers[nPlayerId].setNewIdleAnimation(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
               }
               _aNickNames[nPlayerId]._sdtNickname.text = xCurrentAnimation.@name == undefined ? "" : (_aNickNames[nPlayerId]._sdtNickname.text = xCurrentAnimation.@name);
               if(Number(xCurrentAnimation.@isNew) == 1)
               {
                  finishNewVirmonAnimation(_aVirmonContainers[nPlayerId]);
               }
               else
               {
                  finishAnimation(_aVirmonContainers[nPlayerId]);
               }
            }
            else if(xCurrentAnimation.@animationType == "textEffect" || xCurrentAnimation.@animationType == "hpchange")
            {
               nPlayerId = xCurrentAnimation.@playerId;
               setTriggerPointsForTextEffect(_aTextEffectContainers[_nCurrentTextEffectContainer]);
               if(_aTextEffectContainers[_nCurrentTextEffectContainer] == null)
               {
                  fightLog("HA! I CAUGHT YOU!: null found for _aTextEffectContainers[_nCurrentTextEffectContainer]:\n" + "_aTextEffectContainers.length = " + _aTextEffectContainers.length + "\n_nCurrentTextEffectContainer = " + _nCurrentTextEffectContainer,0);
                  fightLog(_aTextEffectContainers,1);
               }
               ++_nActiveAnimations;
               _aTextEffectContainers[_nCurrentTextEffectContainer].x = _aVirmonContainers[xCurrentAnimation.@playerId].x;
               _aTextEffectContainers[_nCurrentTextEffectContainer].y = _aVirmonContainers[xCurrentAnimation.@playerId].y;
               _smcBattleground.addChild(_aTextEffectContainers[_nCurrentTextEffectContainer]);
               _aTextEffectContainers[_nCurrentTextEffectContainer].doAction(_aTextEffectContainers[_nCurrentTextEffectContainer]._smcTextEffectHolder);
               ++_nCurrentTextEffectContainer;
               fightLog("incrementing _nCurrentTextEffectContainer to : " + _nCurrentTextEffectContainer + " \n\txCurrentAnimation: " + xCurrentAnimation.toXMLString(),1);
               ++_nActivelyPlayingTextEffectContainers;
            }
            else if(xCurrentAnimation.@animationType == "groupedTextEffects")
            {
               _oEventDispatcher.dispatchEvent(new BattleEngineEvent("EVENT_TRIGGER",xCurrentAnimation));
               updateFromId(xCurrentAnimation.@statementID,xCurrentAnimation);
               nPlayerId = xCurrentAnimation.@playerId;
               xEventAnimation = xCurrentAnimation.eventAnimation;
               count = 0;
               while(count < xEventAnimation.length())
               {
                  if(xEventAnimation[count].@animationType == "textEffect" || xEventAnimation[count].@animationType == "hpchange")
                  {
                     if(xEventAnimation[count].@statementID != null && xEventAnimation[count].@statementID != "")
                     {
                        updateFromId(xEventAnimation[count].@statementID,xEventAnimation[count]);
                     }
                     setTriggerPointsForTextEffect(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                     ++_nActiveAnimations;
                     _aTextEffectContainers[_nCurrentTextEffectContainer].x = _aVirmonContainers[xEventAnimation[count].@playerId].x;
                     _aTextEffectContainers[_nCurrentTextEffectContainer].y = _aVirmonContainers[xEventAnimation[count].@playerId].y + 30 * _nActivelyPlayingTextEffectContainers;
                     _smcBattleground.addChild(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                     _aTextEffectContainers[_nCurrentTextEffectContainer].doAction(_aTextEffectContainers[_nCurrentTextEffectContainer]._smcTextEffectHolder);
                     ++_nCurrentTextEffectContainer;
                     ++_nActivelyPlayingTextEffectContainers;
                  }
                  else if(xEventAnimation[count].@animationType == "targetVirmon")
                  {
                     log("reachedLocation() - Shamwow, targetVirmon");
                     nPlayerId = xEventAnimation[count].@playerId;
                     sAnimationID = xEventAnimation[count].@animationID;
                     sVirmonType = xEventAnimation[count].@virmonType;
                     sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
                     setTriggerPointsForVisual(_aVirmonContainers[nPlayerId],_mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData);
                     ++_nActiveAnimations;
                     _aVirmonContainers[nPlayerId].doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
                  }
                  count++;
               }
            }
            else if(xCurrentAnimation.@animationType == "visual")
            {
               nPlayerId = xCurrentAnimation.@playerId;
               sAnimationID = xCurrentAnimation.@animationID;
               sVirmonType = xCurrentAnimation.@virmonType;
               sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
               if(xCurrentAnimation.@animationID == "En")
               {
                  fightLog("setting new idle animation from Enter animation",1);
                  _aVirmonContainers[nPlayerId].setNewIdleAnimation(_mcAnimationHolder["smcAnimation_" + nPlayerId + "_" + sVirmonType + "_" + "Id"]);
               }
               fightLog("_aVirmonContainers[nPlayerId]: " + _aVirmonContainers[nPlayerId],0);
               fightLog("sAnimationName: " + sAnimationName,0);
               fightLog("_mcAnimationHolder[\'smcAnimation_" + sAnimationName + "\']: " + _mcAnimationHolder["smcAnimation_" + sAnimationName],0);
               fightLog("_mcAnimationHolder[\'smcAnimation_" + sAnimationName + "\']._xAnimationData: " + _mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData,0);
               setTriggerPointsForVisual(_aVirmonContainers[nPlayerId],_mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData);
               ++_nActiveAnimations;
               _aVirmonContainers[nPlayerId].doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
            }
            else if(xCurrentAnimation.@animationType == "attack")
            {
               nPlayerId = xCurrentAnimation.@playerId;
               sAnimationID = xCurrentAnimation.@animationID;
               sVirmonType = xCurrentAnimation.@virmonType;
               sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
               targetPlayerId = Number(xCurrentAnimation.@targetPlayerId);
               objDepth = _smcBattleground.getChildIndex(_aVirmonContainers[targetPlayerId]);
               myPlayerLayer = Number(xCurrentAnimation.@targetPlayerId);
               playerDepth = _smcBattleground.getChildIndex(_aVirmonContainers[nPlayerId]);
               if(objDepth > playerDepth)
               {
                  _smcBattleground.swapChildren(_aVirmonContainers[nPlayerId],_aVirmonContainers[targetPlayerId]);
               }
               setTriggerPointsForAttack(_aVirmonContainers[nPlayerId],_mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData);
               ++_nActiveAnimations;
               _aVirmonContainers[nPlayerId].doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
            }
            else if(xCurrentAnimation.@animationType == "causeDeath")
            {
               _oEventDispatcher.dispatchEvent(new BattleEngineEvent("EVENT_TRIGGER",xCurrentAnimation));
               updateFromId(xCurrentAnimation.@statementID,xCurrentAnimation);
               nAttackNum = Number(xCurrentAnimation.@selfDeathCausedByAttack);
               nPlayerId = xCurrentAnimation.@playerId;
               sAnimationID = xCurrentAnimation.@animationID;
               sVirmonType = xCurrentAnimation.@virmonType;
               if(nAttackNum > 0)
               {
                  xCombatXml = getCombatXML(sVirmonType);
                  deathAnimation = xCombatXml.animation[nAttackNum - 1].@selfdeath;
                  sAnimationName = nPlayerId + "_" + sVirmonType + "_" + deathAnimation;
               }
               else
               {
                  sAnimationName = nPlayerId + "_" + sVirmonType + "_De4";
               }
               setTriggerPointsForCauseDeath(_aVirmonContainers[nPlayerId],_mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData);
               ++_nActiveAnimations;
               _aVirmonContainers[nPlayerId].doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
            }
            else if(xCurrentAnimation.@animationType == "delay")
            {
               delayTime(Number(xCurrentAnimation.@delayTime));
            }
            else
            {
               fightLog("FightEngine::reachedLocation (928):  current _nTurnSequence: " + _nTurnSequence + " vs _nTotalMoves: " + _nTotalMoves,2);
               ++_nTurnSequence;
               if(_nTurnSequence < _nTotalMoves && !choosingNanovor)
               {
                  doNextAnimationSet();
               }
               else
               {
                  endTurnAction();
               }
            }
         }
         catch(e:Error)
         {
            logError("Error during reachedLocation: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function onFinishTween() : void
      {
         --currentTweenCount;
         fightLog("// >>-FMA-> FightEngine::onFinishTween currentTweenCount: " + currentTweenCount,1);
         if(currentTweenCount == 0)
         {
            holdingForTween = false;
            _fPostMove();
         }
      }
      
      private function createTextEffect(param1:uint, param2:String, param3:String) : TextEffectContainer
      {
         var _loc4_:* = new TextEffectContainer();
         _loc4_.mouseChildren = false;
         _loc4_.mouseEnabled = false;
         _loc4_.onInitialize(this);
         var _loc5_:TextEffect = new TextEffect();
         _loc5_.setMessage(param2,param3);
         _loc4_.setActiveAnimation(_loc5_);
         return _loc4_;
      }
      
      private function loadCombatXMLInOrder(param1:String) : void
      {
         fightLog("FightEngine::loadCombatXMLInOrder",2);
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,takeErrorActionIO,false,0,true);
         _loc2_.addEventListener(Event.COMPLETE,combatXMLLoaded,false,0,true);
         _loc2_.load(new URLRequest(param1));
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("[FightEngine::ERROR]: ** " + param1 + " **");
      }
      
      private function finishOverlay(param1:AnimationContainer) : void
      {
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::finishOverlay in try statement line 1598--fma",2);
            mcAnimationContainer.clearEventsList();
            mcAnimationContainer.stopAnimation();
            if(mcAnimationContainer.contains(mcAnimationContainer._mcActiveAnimation))
            {
               mcAnimationContainer.removeChild(mcAnimationContainer._mcActiveAnimation);
            }
            mcAnimationContainer._mcActiveAnimation = null;
            --_nActiveAnimations;
            if(_nActiveAnimations <= 0)
            {
               finishAnimationSet();
            }
         }
         catch(e:Error)
         {
            logError("Error during finishOverlay: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function loadNextCombatXMLInOrder() : void
      {
         var xmlObject:Object = null;
         var sURL:String = null;
         try
         {
            fightLog("FightEngine::loadNextCombatXMLInOrder in try statement line 295  --fma",2);
            if(_nCombatXMLLoaded < _xlCombatXMLToLoad.length())
            {
               xmlObject = getCombatXML(_xlCombatXMLToLoad[_nCombatXMLLoaded]);
               if(xmlObject != null)
               {
                  ++_nCombatXMLLoaded;
                  loadNextCombatXMLInOrder();
                  return;
               }
               sURL = _characterAssetTypeCache.getCharacterAnimationURL(CharacterAnimationAssetType.COMBAT_ANIMATION_XML,int(_xlCombatXMLToLoad[_nCombatXMLLoaded]),"1").url;
               loadCombatXMLInOrder(sURL);
            }
            else
            {
               loadRequiredAnimations();
            }
         }
         catch(e:Error)
         {
            logError("Error during loadNextCombatXMLInOrder: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function finishAnimation(param1:AnimationContainer) : void
      {
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::finishAnimation in try statement line 1538  --fma",1);
            mcAnimationContainer.clearEventsList();
            mcAnimationContainer.playIdleAnimation(mcAnimationContainer);
            --_nActiveAnimations;
            if(_nActiveAnimations <= 0)
            {
               finishAnimationSet();
            }
         }
         catch(e:Error)
         {
            logError("Error during finishAnimation: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function setTriggerPointsForTarget(param1:VirmonContainer, param2:XML, param3:String) : void
      {
         var cContainer:VirmonContainer = param1;
         var xData:XML = param2;
         var sDamageAnimationName:String = param3;
         try
         {
            fightLog("FightEngine::setTriggerPointsForTarget in try statement line 1422  --fma",2);
            cContainer.clearEventsList();
            if(_xTurnData.animation[_nTurnSequence].onHitAnimation.(@animationType == "targetVirmon").@kill == 1)
            {
               cContainer.setEndFunction(finishKillerAnimation);
            }
            else if(_xTurnData.animation[_nTurnSequence].@dodge == 1)
            {
               cContainer.setEndFunction(finishAnimation);
            }
            else
            {
               startContactOverlayAnimation(cContainer,sDamageAnimationName);
               cContainer.setEndFunction(finishAnimation);
            }
         }
         catch(e:Error)
         {
            logError("Error during setTriggerPointsForTarget: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function setTriggerPointsForCauseDeath(param1:VirmonContainer, param2:XML) : void
      {
         if(param1 == null)
         {
            logError("setTriggerPointsForCauseDeath: cContainer == null");
            return;
         }
         param1.clearEventsList();
         param1.setEndFunction(finishKillerAnimation);
      }
      
      public function clearVirmon(param1:Number) : void
      {
         _aVirmonContainers[param1].removeMe();
         _aNickNames[param1]._sdtNickname.text = "";
      }
      
      private function tweenBattleground() : void
      {
         var _loc1_:Number = NaN;
         fightLog("tweenBattleground()",0);
         ++currentTweenCount;
         if(_cMovingVirmon != null)
         {
            ++currentTweenCount;
            _loc1_ = _cMovingVirmon.x - (_nTargetBattleGroundXLoc - _smcBattleground.x);
            Tweener.addTween(_cMovingVirmon,{
               "x":_loc1_,
               "time":1.5,
               "onComplete":onFinishTween
            });
         }
         Tweener.addTween(_smcBattleground,{
            "x":_nTargetBattleGroundXLoc,
            "time":1.5,
            "onComplete":onFinishTween
         });
      }
      
      public function log(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = param1 is Array ? "[Array]\n" : "";
         if(param1 is String)
         {
            param1 = [param1];
         }
         if(param1.length == 1)
         {
            _loc2_ = param1[0];
         }
         else
         {
            for(_loc3_ in param1)
            {
               _loc2_ += "\n\t[" + _loc3_ + "] " + param1[_loc3_];
            }
         }
         DebugLog.instance.log("[FightEngine]: " + _loc2_);
      }
      
      private function finishRangedTransfer() : void
      {
      }
      
      private function blankFunction() : void
      {
      }
      
      private function endTurnAction() : void
      {
         var nMaxStuff:* = undefined;
         var count:uint = 0;
         var nTextEffectsNum:uint = 0;
         if(endOfTurn)
         {
            return;
         }
         try
         {
            nMaxStuff = _aVirmonAnimations.length;
            count = 0;
            while(count < nMaxStuff)
            {
               _aVirmonAnimations[count] = null;
               count++;
            }
            _aVirmonAnimations = null;
            _aVirmonAnimations = new Array();
            nTextEffectsNum = _aTextEffectContainers.length;
            count = 0;
            while(count < nTextEffectsNum)
            {
               removeTextEffect(count);
               _aTextEffectContainers[count] = null;
               count++;
            }
            _aTextEffectContainers = null;
            _aTextEffectContainers = new Array();
            _mcAnimationHolder = null;
            _mcOverlayContainerHolder = null;
            _mcAnimationHolder = new MovieClip();
            _mcOverlayContainerHolder = new MovieClip();
            _xTurnData = null;
            _oEventDispatcher.dispatchEvent(new Event("END_TURN_ACTION"));
            System["gc"]();
            preCombat = false;
            endOfTurn = true;
            superEndOfTurn = true;
         }
         catch(e:Error)
         {
            logError("Error during endTurnAction: " + e.toString());
            _oEventDispatcher.dispatchEvent(new Event("END_TURN_ACTION"));
         }
      }
      
      private function takeErrorAction(param1:Error) : void
      {
         logError("all is well I caught this error:" + param1);
         logError("it used this xml " + _xTurnData);
         logError("takeErrorAction... calling endTurnAction() after this logging: " + param1.getStackTrace());
         endTurnAction();
      }
      
      private function moveTo(param1:Number, param2:*, param3:Function) : void
      {
         var yesTween:Boolean = false;
         var count:uint = 0;
         var nLocation:Number = param1;
         var nTargetDirection:* = param2;
         var fPostMove:Function = param3;
         log("moveTo() " + nLocation + " : " + nTargetDirection + " : " + fPostMove);
         try
         {
            if(!choosingNanovor && _xTurnData == null)
            {
               return;
            }
            _fPostMove = fPostMove;
            _nTargetBattleGroundXLoc;
            yesTween = false;
            if(choosingNanovor)
            {
               fPostMove();
               return;
            }
            if(nTargetDirection == FightEngine.MOVETO_PANORAMA)
            {
               if(_nTargetBattleGroundScale != 0.6)
               {
                  yesTween = true;
               }
               _nTargetBattleGroundScale = 0.6;
               movingToPanorama = true;
               if(yesTween && !holdingForTween)
               {
                  tweenNanovor();
               }
               nLocation = 0;
               nTargetDirection = 1;
            }
            else
            {
               count = 0;
               while(count < _aVirmonContainers.length)
               {
                  if(count < nLocation)
                  {
                     _aVirmonContainers[count].scaleX = Math.abs(_aVirmonContainers[count].scaleX) * -1;
                  }
                  else if(count > nLocation)
                  {
                     _aVirmonContainers[count].scaleX = Math.abs(_aVirmonContainers[count].scaleX) * 1;
                  }
                  else if(nTargetDirection < 5)
                  {
                     if(nLocation < nTargetDirection)
                     {
                        _aVirmonContainers[count].scaleX = Math.abs(_aVirmonContainers[count].scaleX) * -1;
                     }
                     else if(nLocation > nTargetDirection)
                     {
                        _aVirmonContainers[count].scaleX = Math.abs(_aVirmonContainers[count].scaleX) * 1;
                     }
                  }
                  count++;
               }
               if(_nTargetBattleGroundScale != 1)
               {
                  yesTween = true;
               }
               movingToPanorama = false;
               if(yesTween && !holdingForTween)
               {
                  tweenNanovor();
               }
               _nTargetBattleGroundScale = 1;
            }
            fightLog("// >>-FMA->_nTargetBattleGroundScale: " + _nTargetBattleGroundScale,2);
            if(nTargetDirection == FightEngine.MOVETO_CENTER)
            {
               _nTargetBattleGroundXLoc = -DataManager.getInstance()._nContainerSeperationX * (nLocation - 0.5);
            }
            else if(nTargetDirection == FightEngine.MOVETO_CURRENTDIRECTION)
            {
               if(_aVirmonContainers[nLocation].scaleX < 0)
               {
                  _nTargetBattleGroundXLoc = -DataManager.getInstance()._nContainerSeperationX * nLocation;
               }
               else
               {
                  _nTargetBattleGroundXLoc = -DataManager.getInstance()._nContainerSeperationX * (nLocation - 1);
               }
            }
            else if(nTargetDirection < nLocation)
            {
               _nTargetBattleGroundXLoc = -DataManager.getInstance()._nContainerSeperationX * (nLocation - 1);
            }
            else if(nTargetDirection > nLocation)
            {
               _nTargetBattleGroundXLoc = -DataManager.getInstance()._nContainerSeperationX * nLocation;
            }
            else if(nTargetDirection == nLocation)
            {
               if(_aVirmonContainers[nLocation].scaleX < 0)
               {
                  _nTargetBattleGroundXLoc = -DataManager.getInstance()._nContainerSeperationX * nLocation;
               }
               else
               {
                  _nTargetBattleGroundXLoc = -DataManager.getInstance()._nContainerSeperationX * (nLocation - 1);
               }
            }
            if(_nTargetBattleGroundXLoc != _smcBattleground.x)
            {
               tweenBattleground();
            }
            if(_nTargetBattleGroundScale == _smcBattleground.scaleX && _nTargetBattleGroundXLoc == _smcBattleground.x)
            {
               reachedMoveToLocation();
            }
         }
         catch(e:Error)
         {
            logError("Error during moveTo: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      public function clearBattle() : void
      {
         var count:uint = 0;
         var nVirmonNum:uint = 0;
         var nTextEffectsNum:uint = 0;
         var nNickNamesNum:uint = 0;
         fightLog("FightEnine::clearBattle",2);
         try
         {
            endTurnAction();
            count = 0;
            nVirmonNum = _aVirmonContainers.length;
            count = 0;
            while(count < nVirmonNum)
            {
               removeVirmon(count);
               _aVirmonContainers[count] = null;
               count++;
            }
            _aVirmonContainers = null;
            nTextEffectsNum = _aTextEffectContainers.length;
            count = 0;
            while(count < nTextEffectsNum)
            {
               removeTextEffect(count);
               _aTextEffectContainers[count] = null;
               count++;
            }
            _aTextEffectContainers = null;
            nNickNamesNum = _aNickNames.length;
            count = 0;
            while(count < nNickNamesNum)
            {
               if(Boolean(_aNickNames[count]) && _smcBattleground.contains(_aNickNames[count]))
               {
                  try
                  {
                     _smcBattleground.removeChild(_aNickNames[count]);
                  }
                  catch(e:Error)
                  {
                  }
               }
               _aNickNames[count] = null;
               count++;
            }
            destroyXMLCache();
            System["gc"]();
         }
         catch(e:Error)
         {
            logError("Error during clearBattle: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function meleetransfer(param1:AnimationContainer) : void
      {
         var nTargetPlayerId:* = undefined;
         var nAttackerPlayerId:* = undefined;
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::meleetransfer in try statement line 1254  --fma",2);
            nTargetPlayerId = _xTurnData.animation[_nTurnSequence].@targetPlayerId;
            nAttackerPlayerId = mcAnimationContainer._nPlayerOrder;
            _cMovingVirmon = mcAnimationContainer;
            _cMovingVirmon.stopAnimation();
            _cMovingVirmon.filters = [new BlurFilter(5,0,1)];
            log("calling moveto from 1163");
            moveTo(nTargetPlayerId,nAttackerPlayerId,finishMeleeTransfer);
         }
         catch(e:Error)
         {
            logError("Error during meleetransfer: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function xmlAnimationDataLoaded(param1:Event) : void
      {
         var loadedXmlIsValid:Boolean;
         var xXML:XML = null;
         var animationObject:Object = null;
         var animationId:String = null;
         var frame:String = null;
         var resource:String = null;
         var overlayExists:Boolean = false;
         var i:* = undefined;
         var rangedTransferXML:XML = null;
         var message:String = null;
         var event:Event = param1;
         fightLog("FightEngine::xmlAnimationDataLoaded in try statement line 561  --fma",2);
         event.target.removeEventListener(IOErrorEvent.IO_ERROR,takeErrorActionIO);
         event.target.removeEventListener(Event.COMPLETE,xmlAnimationDataLoaded);
         loadedXmlIsValid = false;
         try
         {
            xXML = XML(event.target.data);
            loadedXmlIsValid = true;
         }
         catch(e1:Error)
         {
            logError("xmlAnimationDataLoaded() - Attempted and failed to cast event.target.data to XML.\n" + e1.getStackTrace() + "\n  event.target.data: \n " + event.target.data);
         }
         if(loadedXmlIsValid)
         {
            try
            {
               animationObject = new Object();
               animationObject.xml = xXML;
               animationObject.url = animationXMLURL;
               _animationXML[animationObject] = animationObject;
               animationId = _characterAssetTypeCache.getCharacterAnimationID(int((_aVirmonAnimations[_nXmlLoaded] as AnimationData)._sVirmonType),_aVirmonAnimations[_nXmlLoaded]._sAnimationID);
               _aVirmonAnimations[_nXmlLoaded]._xAnimationData = XML(xXML.animation.(@name.toLowerCase() == animationId.toLowerCase()));
               if(Boolean(_aVirmonAnimations[_nXmlLoaded]._xAnimationData.rangedtransfer.length()))
               {
                  frame = _aVirmonAnimations[_nXmlLoaded]._xAnimationData.rangedtransfer.@frame;
                  resource = _aVirmonAnimations[_nXmlLoaded]._xAnimationData.rangedtransfer.@resource;
                  overlayExists = false;
                  i = 0;
                  while(i < _aVirmonAnimations[_nXmlLoaded]._xAnimationData.overlay.length())
                  {
                     if(_aVirmonAnimations[_nXmlLoaded]._xAnimationData.overlay[i].@resource == resource)
                     {
                        overlayExists = true;
                        break;
                     }
                     i++;
                  }
                  if(!overlayExists)
                  {
                     rangedTransferXML = <overlay startframe="" resource="" layer="3"/>;
                     rangedTransferXML.@startframe = frame;
                     rangedTransferXML.@resource = resource;
                     _aVirmonAnimations[_nXmlLoaded]._xAnimationData.appendChild(rangedTransferXML);
                  }
               }
            }
            catch(e2:Error)
            {
               message = "xmlAnimationDataLoaded(): " + e2.getStackTrace();
               try
               {
                  logError(message + "\n [[ _aVirmonAnimations[_nXmlLoaded]._sAnimationID = " + _aVirmonAnimations[_nXmlLoaded]._sAnimationID + "]]" + "\n [[ deduced animationId = " + animationId + "]]" + "\n xml string = \n" + xXML.animation.(@name.toLowerCase() == animationId.toLowerCase()) + "\n animation xml = \n" + xXML.animation.toXMLString());
               }
               catch(e3:Error)
               {
                  logError(message + "\n !!! AND FURTHER MORE.... " + e3.getStackTrace());
               }
            }
         }
         ++_nXmlLoaded;
         loadNextXmlAnimationDataInOrder();
      }
      
      private function loadRequiredCombatXML() : void
      {
         fightLog("FightEngine::loadRequiredCombatXML",2);
         _xlCombatXMLToLoad = new XMLList();
         _xlCombatXMLToLoad = _xTurnData.animation.(@animationType == "attack").@virmonType;
         _nCombatXMLLoaded = 0;
         loadNextCombatXMLInOrder();
      }
      
      private function combatXMLLoaded(param1:Event) : void
      {
         fightLog("FightEngine::combatXMLLoaded",2);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,takeErrorActionIO);
         param1.target.removeEventListener(Event.COMPLETE,combatXMLLoaded);
         var _loc2_:XML = XML(param1.target.data);
         var _loc3_:Object = new Object();
         _loc3_.xml = _loc2_;
         _loc3_.type = _xlCombatXMLToLoad[_nCombatXMLLoaded];
         _aCombatXML[_loc3_] = _loc3_;
         ++_nCombatXMLLoaded;
         loadNextCombatXMLInOrder();
      }
      
      private function finishAnimationSet() : void
      {
         var nVirmonNum:uint = 0;
         var count:* = undefined;
         try
         {
            fightLog("FightEngine::finishAnimationSet in try statement line 1641  --fma",2);
            ++_nTurnSequence;
            nVirmonNum = _aVirmonContainers.length;
            count = 0;
            while(count < nVirmonNum)
            {
               if(_aVirmonContainers[count].scaleY == 1)
               {
                  _aVirmonContainers[count].x = DataManager.getInstance()._nFirstContainerX + count * DataManager.getInstance()._nContainerSeperationX;
               }
               else
               {
                  _aVirmonContainers[count].x = spacingArray[count] + _buffer;
               }
               count++;
            }
            log("calling moveto from 1504");
            if(_nTurnSequence < _nTotalMoves)
            {
               doNextAnimationSet();
            }
            else
            {
               moveTo(0,MOVETO_PANORAMA,endTurnAction);
            }
         }
         catch(e:Error)
         {
            logError("Error during finishAnimationSet: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function loadNextVirmonAnimationsInOrder() : void
      {
         var sURL:String = null;
         var animationId:String = null;
         var assetType:CharacterAnimationAssetType = null;
         var assetId:String = null;
         var sId:String = null;
         var aSplitId:Array = null;
         try
         {
            fightLog("FightEngine::loadNextVirmonAnimationsInOrder in try statement line 627  --fma",2);
            if(_nAnimationsLoaded < _nTotalAnimations)
            {
               animationId = _aVirmonAnimations[_nAnimationsLoaded]._sAnimationID;
               fightLog("loadNextVirmonAnimationsInOrder(): animationId=" + animationId + ", parsed for assetType:" + animationId.replace(/[0-9]/g,""),2);
               assetType = CharacterAnimationAssetType.parse(animationId.replace(/[0-9]/g,""));
               assetId = animationId.replace(/.+?([0-9]*)$/,"$1");
               if(assetId == "")
               {
                  assetId = "1";
               }
               fightLog("loadNextVirmonAnimationsInOrder(): RSK... _nAnimationsLoaded=" + _nAnimationsLoaded + " _nTotalAnimations=" + _nTotalAnimations + " animationId=" + animationId,3);
               sURL = _characterAssetTypeCache.getCharacterAnimationURL(assetType,int(_aVirmonAnimations[_nAnimationsLoaded]._sVirmonType),assetId).url;
               loadVirmonAnimationsInOrder(sURL,_ANIMATION_TYPE_CHARACTER);
            }
            else if(_nAnimationsLoaded < _nTotalAnimations + _nTotalOverlays)
            {
               sId = _aVirmonAnimations[_nAnimationsLoaded]._sAnimationID;
               aSplitId = _aVirmonAnimations[_nAnimationsLoaded]._sAnimationID.split("/");
               if(aSplitId[1] != null)
               {
                  sId = aSplitId[1];
               }
               sId = sId.replace(/[^0-9]/g,"");
               sURL = _overlayAssetRetriever.getOverlayURL(OverlayAssetType.OVERLAY,int(sId)).url;
               if(sURL == "" || sURL == null)
               {
                  logError("loadNextVirmonAnimationsInOrder(): overlay asset url empty for: _sAnimationID=" + _aVirmonAnimations[_nAnimationsLoaded]._sAnimationID + " sId=" + sId + " aSplitId=" + aSplitId + "\n_xAnimationData=" + _aVirmonAnimations[_nAnimationsLoaded]._xAnimationData);
               }
               loadVirmonAnimationsInOrder(sURL,_ANIMATION_TYPE_OVERLAY);
            }
            else
            {
               startTurnAction();
            }
         }
         catch(e:Error)
         {
            logError("Error during loadNextVirmonAnimationsInOrder: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function virmonAnimationLoaded(param1:Event) : void
      {
         var animationTypeId:String = null;
         var sAnimationName:String = null;
         var transform1:SoundTransform = null;
         var nThisVolume:* = undefined;
         var animSoundData:AnimationSoundData = null;
         var event:Event = param1;
         try
         {
            fightLog("virmonAnimationLoaded");
            event.target.removeEventListener(Event.COMPLETE,virmonAnimationLoaded);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR,virmonAnimationLoadError);
            animationTypeId = _aVirmonAnimations[_nAnimationsLoaded]._sAnimationID;
            sAnimationName = _aVirmonAnimations[_nAnimationsLoaded]._sLocationID + "_" + _aVirmonAnimations[_nAnimationsLoaded]._sVirmonType + "_" + _aVirmonAnimations[_nAnimationsLoaded]._sAnimationID + "" + _aVirmonAnimations[_nAnimationsLoaded]._sAnimationTag;
            _mcAnimationHolder["smcAnimation_" + sAnimationName] = event.currentTarget.content;
            _mcAnimationHolder["smcAnimation_" + sAnimationName].isPrototypeCharacter = _characterAssetTypeCache.isCharacterSuperseded(int(_aVirmonAnimations[_nAnimationsLoaded]._sVirmonType));
            _mcAnimationHolder["smcAnimation_" + sAnimationName].gotoAndStop(1);
            transform1 = new SoundTransform();
            if(_bSoundOn == false)
            {
               transform1.volume = 0;
               _mcAnimationHolder["smcAnimation_" + sAnimationName].soundTransform = transform1;
            }
            else
            {
               nThisVolume = Managers.soundManager.getSoundGlobalVolume();
               if(nThisVolume == null)
               {
                  nThisVolume = 1;
               }
               transform1.volume = nThisVolume;
               _mcAnimationHolder["smcAnimation_" + sAnimationName].soundTransform = transform1;
            }
            if(_nAnimationsLoaded < _nTotalAnimations)
            {
               _mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData = _aVirmonAnimations[_nAnimationsLoaded]._xAnimationData;
               if(animationTypeId != "Id")
               {
                  animSoundData = AnimationSoundData.FromXml(_characterAssetTypeCache,_aVirmonAnimations[_nAnimationsLoaded]._xAnimationData,_aVirmonAnimations[_nAnimationsLoaded]._sVirmonType);
                  if(animSoundData != null)
                  {
                     _mcAnimationHolder["smcAnimation_" + sAnimationName]._animationSoundData = animSoundData;
                  }
               }
               else
               {
                  fightLog("Suppressing Idle sounds (any animation named \'Id\') for launch.",3);
               }
            }
            ++_nAnimationsLoaded;
            loadNextVirmonAnimationsInOrder();
         }
         catch(e:Error)
         {
            logError("Error during virmonAnimationLoaded: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function loadNextXmlAnimationDataInOrder() : void
      {
         var _loc1_:String = null;
         fightLog("FightEngine::loadNextXmlAnimationDataInOrder",2);
         if(_nXmlLoaded < _nTotalAnimations)
         {
            _loc1_ = _characterAssetTypeCache.getCharacterAnimationURL(CharacterAnimationAssetType.ANIMATION_XML,int(_aVirmonAnimations[_nXmlLoaded]._sVirmonType),"1").url;
            loadXmlAnimationDataInOrder(_loc1_);
         }
         else
         {
            createListOfOverlayAnimations();
         }
      }
      
      private function addAnimationToList(param1:*, param2:*, param3:*, param4:* = "") : *
      {
         var _loc6_:* = undefined;
         fightLog("FightEngine::addAnimationToList",2);
         var _loc5_:String = param1 + "_" + param2 + "_" + param3 + "" + param4;
         fightLog("addAnimationToList --> sAnimationName: " + _loc5_,0);
         if(_mcAnimationHolder["smcAnimation_" + _loc5_] == null)
         {
            fightLog("_mcAnimationHolder[smcAnimation_" + _loc5_ + "] = new MovieClip();",0);
            _mcAnimationHolder["smcAnimation_" + _loc5_] = new MovieClip();
            _loc6_ = new AnimationData(param1,param2,param3,param4);
            _aVirmonAnimations.push(_loc6_);
         }
      }
      
      private function rangedImpactFrame(param1:AnimationContainer) : void
      {
         var xOnHitAnimations:* = undefined;
         var count:uint = 0;
         var xCombatXml:* = undefined;
         var nPlayerId:* = undefined;
         var sAnimationID:* = undefined;
         var sVirmonType:* = undefined;
         var sAnimationName:String = null;
         var deathAnimation:* = undefined;
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::rangedImpactFrame in try statement line 1196  --fma",2);
            xOnHitAnimations = _xTurnData.animation[_nTurnSequence].onHitAnimation;
            _oEventDispatcher.dispatchEvent(new BattleEngineEvent("EVENT_TRIGGER",xOnHitAnimations));
            count = 0;
            while(count < xOnHitAnimations.length())
            {
               xCombatXml = getCombatXML(_xTurnData.animation[_nTurnSequence].@virmonType);
               if(xOnHitAnimations[count].@animationType == "targetVirmon")
               {
                  nPlayerId = xOnHitAnimations[count].@playerId;
                  sAnimationID = xOnHitAnimations[count].@animationID;
                  sVirmonType = xOnHitAnimations[count].@virmonType;
                  if(_xTurnData.animation[_nTurnSequence].@dodge == "1")
                  {
                     sAnimationID = "Do";
                  }
                  else
                  {
                     if(xOnHitAnimations[count].@kill == "1")
                     {
                        deathAnimation = xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).@deathanimation;
                        sAnimationID = deathAnimation;
                     }
                     sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
                     setTriggerPointsForTarget(_aVirmonContainers[nPlayerId],_mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData,sAnimationName);
                     ++_nActiveAnimations;
                     _aVirmonContainers[nPlayerId]._bTrackMe = true;
                     _aVirmonContainers[nPlayerId].doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
                  }
               }
               else if(xOnHitAnimations[count].@animationType == "textEffect" || xOnHitAnimations[count].@animationType == "hpchange")
               {
                  updateFromId(xOnHitAnimations[count].@statementID,xOnHitAnimations[count]);
                  setTriggerPointsForTextEffect(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                  if(_aTextEffectContainers[_nCurrentTextEffectContainer] == null)
                  {
                     fightLog("HA!  I CAUGHT YOU!: null found for _aTextEffectContainers[_nCurrentTextEffectContainer]:\n" + "_aTextEffectContainers.length = " + _aTextEffectContainers.length + "\n_nCurrentTextEffectContainer = " + _nCurrentTextEffectContainer,0);
                     fightLog(_aTextEffectContainers,1);
                  }
                  ++_nActiveAnimations;
                  _aTextEffectContainers[_nCurrentTextEffectContainer].x = _aVirmonContainers[xOnHitAnimations[count].@playerId].x;
                  _aTextEffectContainers[_nCurrentTextEffectContainer].y = _aVirmonContainers[xOnHitAnimations[count].@playerId].y + 30 * _nActivelyPlayingTextEffectContainers;
                  _smcBattleground.addChild(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                  _aTextEffectContainers[_nCurrentTextEffectContainer].doAction(_aTextEffectContainers[_nCurrentTextEffectContainer]._smcTextEffectHolder);
                  ++_nCurrentTextEffectContainer;
                  ++_nActivelyPlayingTextEffectContainers;
               }
               count++;
            }
            finishOverlay(mcAnimationContainer);
         }
         catch(e:Error)
         {
            logError("Error during rangedImpactFrame: " + e.toString());
         }
      }
      
      private function doNextAnimationSet() : void
      {
         fightLog("FightEngine::doNextAnimationSet in try statement line 789  --fma",2);
         _nActiveAnimations = 0;
         _nActiveOverlays = 0;
         var _loc1_:* = _xTurnData.animation[_nTurnSequence];
         var _loc2_:* = _loc1_.@playerId;
         var _loc3_:* = _loc1_.@animationID;
         var _loc4_:* = _loc1_.@virmonType;
         var _loc5_:String = _loc2_ + "_" + _loc4_ + "_" + _loc3_;
         log("calling moveto from 744");
         if(_loc1_.@animationType == "newVirmon")
         {
            reachedLocation();
         }
         else if(_loc1_.@animationType == "textEffect" || _loc1_.@animationType == "hpchange")
         {
            moveTo(_loc2_,FightEngine.MOVETO_CURRENTDIRECTION,reachedLocation);
         }
         else if(_loc1_.@animationType == "groupedTextEffects")
         {
            moveTo(_loc2_,FightEngine.MOVETO_CURRENTDIRECTION,reachedLocation);
         }
         else if(_loc1_.@animationType == "visual")
         {
            moveTo(_loc2_,FightEngine.MOVETO_CURRENTDIRECTION,reachedLocation);
         }
         else if(_loc1_.@animationType == "attack")
         {
            moveTo(_loc2_,_loc1_.@targetPlayerId,reachedLocation);
         }
         else if(_loc1_.@animationType == "causeDeath")
         {
            moveTo(_loc2_,FightEngine.MOVETO_CURRENTDIRECTION,reachedLocation);
         }
         else if(_loc1_.@animationType == "delay")
         {
            reachedLocation();
         }
         else
         {
            reachedLocation();
         }
      }
      
      private function updateFromId(param1:int, param2:XML) : void
      {
         var _loc3_:BattleEngineEvent = new BattleEngineEvent(BattleEngineEvent.UPDATE_PLAYER_WIDGET,{
            "statementID":param1,
            "node":param2
         });
         _oEventDispatcher.dispatchEvent(_loc3_);
      }
      
      private function startContactOverlayAnimation(param1:VirmonContainer, param2:String) : void
      {
         var xCombatXml:* = undefined;
         var nDestination:* = undefined;
         var xOnHitAnimations:* = undefined;
         var count:* = undefined;
         var nPlayerId:String = null;
         var sAnimationID:String = null;
         var sVirmonType:String = null;
         var lowerAID:String = null;
         var sAnimationName:String = null;
         var xDaData:* = undefined;
         var sOverlayName:* = undefined;
         var cOContainer:* = undefined;
         var nOverlayLayer:* = undefined;
         var nStartFrame:* = undefined;
         var nLength:* = undefined;
         var cContainer:VirmonContainer = param1;
         var sDamageAnimationName:String = param2;
         try
         {
            fightLog("FightEngine::startContactOverlayAnimation in try statement line 1446  --fma",2);
            xCombatXml = getCombatXML(_xTurnData.animation[_nTurnSequence].@virmonType);
            nDestination = xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).overlay[0].@destination;
            xOnHitAnimations = _xTurnData.animation[_nTurnSequence].onHitAnimation;
            count = 0;
            for(; count < xOnHitAnimations.length(); count++)
            {
               if(xOnHitAnimations[count].@animationType != "targetVirmon")
               {
                  continue;
               }
               if(xOnHitAnimations[count].@kill != "0")
               {
                  continue;
               }
               nPlayerId = xOnHitAnimations[count].@playerId;
               sAnimationID = xOnHitAnimations[count].@animationID;
               sVirmonType = xOnHitAnimations[count].@virmonType;
               lowerAID = sAnimationID.toLowerCase();
               if(!(lowerAID == "da1" || lowerAID == "da2" || lowerAID == "da3" || lowerAID == "da4"))
               {
                  continue;
               }
               sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
               xDaData = _mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData;
               sOverlayName = _xTurnData.animation[_nTurnSequence].@playerId + "_Overlays_" + xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).overlay.@resource + "_Contact";
               _mcOverlayContainerHolder[sOverlayName] = createOverlay();
               cOContainer = _mcOverlayContainerHolder[sOverlayName];
               nOverlayLayer = Number(xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).overlay[0].@layer);
               if(nOverlayLayer < 2)
               {
                  _smcBattleground.addChildAt(cOContainer,0);
               }
               else
               {
                  _smcBattleground.addChild(cOContainer);
               }
               cOContainer._nBaseX = cOContainer.x = cContainer.x;
               cOContainer._nBaseY = cOContainer.y = cContainer.y;
               cOContainer.scaleX = -cContainer.scaleX;
               cOContainer._bFollowing = xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).overlay[0].@following == "true";
               cOContainer._xPositionMotion = xDaData.child("hitloc" + nDestination)[0];
               cOContainer.setEndFunction(finishOverlay);
               ++_nActiveAnimations;
               cOContainer.doAction(_mcAnimationHolder["smcAnimation_" + sOverlayName]);
               ++_nActiveOverlays;
               try
               {
                  nStartFrame = 1 + Number(xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).overlay.@startframe);
                  cOContainer.playAnimation(nStartFrame);
                  nLength = 1 + Number(xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).overlay.attribute("length"));
                  cOContainer.setTriggerEventByNum(nLength,finishOverlay);
                  break;
               }
               catch(e:Error)
               {
                  logError("Error: " + e.toString());
                  logError("Error during startContactOverlayAnimation. Missing startFrame or length?");
                  break;
               }
            }
         }
         catch(e:Error)
         {
            logError("Error during startContactOverlayAnimation: " + e.getStackTrace());
            takeErrorAction(e);
         }
      }
      
      private function setTriggerPointsForNewVirmon(param1:VirmonContainer, param2:XML) : void
      {
         var cContainer:VirmonContainer = param1;
         var xData:XML = param2;
         try
         {
            cContainer.clearEventsList();
            cContainer.setEndFunction(finishAnimation);
         }
         catch(e:Error)
         {
            logError("Error during setTriggerPointsForNewVirmon: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function createHpChangeEffect(param1:uint, param2:Number, param3:Number, param4:Number) : TextEffectContainer
      {
         var _loc5_:* = new TextEffectContainer();
         _loc5_.mouseChildren = false;
         _loc5_.mouseEnabled = false;
         _loc5_.onInitialize(this);
         var _loc6_:TextEffect = new TextEffect();
         _loc6_.setHpChange(param2,param3,param4);
         _loc5_.setActiveAnimation(_loc6_);
         return _loc5_;
      }
      
      private function finishNewVirmonAnimation(param1:AnimationContainer) : void
      {
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::finishNewVirmonAnimation _nActiveAnimations: " + _nActiveAnimations + ", currentTurn: " + currentTurn + "  --fma",2);
            mcAnimationContainer.clearEventsList();
            --_nActiveAnimations;
            if(_nActiveAnimations <= 0)
            {
               finishAnimationSet();
            }
         }
         catch(e:Error)
         {
            logError("Error during finishNewVirmonAnimation: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function createListOfOverlayAnimations() : void
      {
         var sOverlayName:* = undefined;
         var nDuplicateOverlays:* = undefined;
         var duplicateHolder:* = undefined;
         var xCombatXml:* = undefined;
         var count:uint = 0;
         var countO:uint = 0;
         try
         {
            fightLog("FightEngine::createListOfOverlayAnimations in try statement line 580  --fma",2);
            _nTotalOverlays = 0;
            sOverlayName = "";
            nDuplicateOverlays = 0;
            duplicateHolder = new MovieClip();
            count = 0;
            while(count < _nTotalAnimations)
            {
               fightLog("FightEngine::createListOfOverlayAnimations  -- _aVirmonAnimations[*count*]._sAnimationID: " + _aVirmonAnimations[count]._sAnimationID + " --fma",2);
               fightLog("FightEngine::createListOfOverlayAnimations  -- _aVirmonAnimations[*count*]._xAnimationData.overlay: " + _aVirmonAnimations[count]._xAnimationData.overlay + " --fma",2);
               if(_aVirmonAnimations[count]._xAnimationData.overlay.@resource != null && _aVirmonAnimations[count]._xAnimationData.overlay.@resource != undefined && _aVirmonAnimations[count]._xAnimationData.overlay.@resource != "")
               {
                  countO = 0;
                  while(countO < _aVirmonAnimations[count]._xAnimationData.overlay.length())
                  {
                     if(_aVirmonAnimations[count]._xAnimationData.overlay[countO].@resource != null && _aVirmonAnimations[count]._xAnimationData.overlay[countO].@resource != undefined && _aVirmonAnimations[count]._xAnimationData.overlay[countO].@resource != "")
                     {
                        nDuplicateOverlays = -1;
                        do
                        {
                           nDuplicateOverlays++;
                           sOverlayName = _aVirmonAnimations[count]._sLocationID + "_" + _aVirmonAnimations[count]._xAnimationData.overlay[countO].@resource + "_" + nDuplicateOverlays;
                        }
                        while(duplicateHolder[sOverlayName] != null);
                        
                        duplicateHolder[sOverlayName] = sOverlayName;
                        sOverlayName = _aVirmonAnimations[count]._xAnimationData.overlay[countO].@resource + "_" + nDuplicateOverlays;
                        addAnimationToList(_aVirmonAnimations[count]._sLocationID,"Overlays",_aVirmonAnimations[count]._xAnimationData.overlay[countO].@resource,"_" + nDuplicateOverlays);
                     }
                     countO++;
                  }
               }
               if(_aVirmonAnimations[count]._sAnimationID.indexOf("At") > -1)
               {
                  xCombatXml = getCombatXML(_aVirmonAnimations[count]._sVirmonType);
                  fightLog("FightEngine::createListOfOverlayAnimations  -- getCombatXML(_aVirmonAnimations[*count*]._sVirmonType): " + getCombatXML(_aVirmonAnimations[count]._sVirmonType) + " --fma",2);
                  if(xCombatXml.animation.(@name.toLowerCase() == _aVirmonAnimations[count]._sAnimationID.toLowerCase()).overlay.@resource != null && xCombatXml.animation.(@name.toLowerCase() == _aVirmonAnimations[count]._sAnimationID.toLowerCase()).overlay.@resource != undefined && xCombatXml.animation.(@name.toLowerCase() == _aVirmonAnimations[count]._sAnimationID.toLowerCase()).overlay.@resource != "")
                  {
                     addAnimationToList(_aVirmonAnimations[count]._sLocationID,"Overlays",xCombatXml.animation.(@name.toLowerCase() == _aVirmonAnimations[count]._sAnimationID.toLowerCase()).overlay.@resource,"_Contact");
                  }
               }
               count++;
            }
            _nTotalOverlays = _aVirmonAnimations.length - _nTotalAnimations;
            _nAnimationsLoaded = 0;
         }
         catch(e:Error)
         {
            logError("Error during createListOfOverlayAnimations: " + e.getStackTrace());
         }
         loadNextVirmonAnimationsInOrder();
      }
      
      private function finishMeleeTransfer() : void
      {
         var xCurrentAnimation:* = undefined;
         var nPlayerId:* = undefined;
         var nTargetPlayerId:* = undefined;
         var nAttackerPlayerId:* = undefined;
         var nPixelShift:* = undefined;
         try
         {
            fightLog("FightEngine::finishMeleTransfer in try statement line 1271  --fma",2);
            _cMovingVirmon.filters = new Array();
            _cMovingVirmon.playAnimation();
            _cMovingVirmon = null;
            xCurrentAnimation = _xTurnData.animation[_nTurnSequence];
            nPlayerId = xCurrentAnimation.@playerId;
            nTargetPlayerId = _xTurnData.animation[_nTurnSequence].@targetPlayerId;
            nAttackerPlayerId = _aVirmonContainers[nPlayerId]._nPlayerOrder;
            nPixelShift = (Math.abs(nAttackerPlayerId - nTargetPlayerId) - 1) * DataManager.getInstance()._nContainerSeperationX;
            if(nAttackerPlayerId > nTargetPlayerId)
            {
               nPixelShift *= -1;
            }
         }
         catch(e:Error)
         {
            logError("Error during finishMeleeTransfer: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function checkPrimaryAction(param1:XMLList) : void
      {
         var nMaxAnimationNodes:* = undefined;
         var szDebug:String = null;
         var count:uint = 0;
         var nAttackNum:Number = NaN;
         var xCombatXml:* = undefined;
         var deathAnimation:* = undefined;
         var xAnimationList:XMLList = param1;
         try
         {
            fightLog("FightEngine::checkPrimaryAction in try statement line 372  --fma",2);
            nMaxAnimationNodes = xAnimationList.length();
            szDebug = "checkPrimaryActionLog....";
            count = 0;
            while(count < nMaxAnimationNodes)
            {
               szDebug += "\n     ... " + count + ": " + xAnimationList[count].toXMLString();
               if(xAnimationList[count].@animationType == "textEffect")
               {
                  _aTextEffectContainers[_nTotalTextEffectContainers] = createTextEffect(_nTotalTextEffectContainers,xAnimationList[count].@animationID,xAnimationList[count].@myMessage);
                  ++_nTotalTextEffectContainers;
               }
               else if(xAnimationList[count].@animationType == "hpchange")
               {
                  _aTextEffectContainers[_nTotalTextEffectContainers] = createHpChangeEffect(_nTotalTextEffectContainers,xAnimationList[count].@start,xAnimationList[count].@end,xAnimationList[count].@max);
                  ++_nTotalTextEffectContainers;
               }
               else if(xAnimationList[count].@animationType == "groupedTextEffects")
               {
                  checkSecondaryGroupedText(xAnimationList[count].eventAnimation);
               }
               else if(xAnimationList[count].@animationType == "newVirmon" || xAnimationList[count].@animationType == "visual")
               {
                  addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,xAnimationList[count].@animationID);
               }
               else if(xAnimationList[count].@animationType == "attack")
               {
                  addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,xAnimationList[count].@animationID);
                  addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,"Re");
                  checkSecondaryAction(xAnimationList[count],xAnimationList[count].onHitAnimation);
               }
               else if(xAnimationList[count].@animationType == "causeDeath")
               {
                  nAttackNum = Number(xAnimationList[count].@selfDeathCausedByAttack);
                  if(nAttackNum > 0)
                  {
                     xCombatXml = getCombatXML(xAnimationList[count].@virmonType);
                     deathAnimation = xCombatXml.animation[nAttackNum - 1].@selfdeath;
                     addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,deathAnimation);
                  }
                  else
                  {
                     addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,"De4");
                  }
               }
               else
               {
                  szDebug += "\n               *** skipping (delay node or ??)";
               }
               count++;
            }
            fightLog("----------------------------------------------------------------\n" + szDebug + "\n----------------------------------------------------------------",2);
            fightLog(_aTextEffectContainers,2);
         }
         catch(e:Error)
         {
            logError("Error during checkPrimaryAction: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function rangedtransfer(param1:AnimationContainer) : void
      {
         var count:uint = 0;
         var nTargetPlayerId:* = undefined;
         var nAttackerPlayerId:* = undefined;
         var nCurrentFrame:int = 0;
         var sOverlayName:String = null;
         var xMotion:* = undefined;
         var nDataFrame:* = undefined;
         var nCurrentX:* = undefined;
         var nTargetX:* = undefined;
         var nCurrentY:* = undefined;
         var nTargetY:* = undefined;
         var sAnimationID:String = null;
         var xCombatXml:* = undefined;
         var nDestination:* = undefined;
         var xOnHitAnimations:* = undefined;
         var nSteps:Number = NaN;
         var nStepDistanceX:Number = NaN;
         var nStepDistanceY:Number = NaN;
         var nMotionLength:* = undefined;
         var nPlayerId:* = undefined;
         var sVirmonType:* = undefined;
         var sAnimationName:String = null;
         var xDaData:* = undefined;
         var xOffset:Number = NaN;
         var yOffset:Number = NaN;
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::rangedTransfer in try statement line 1292  --fma",2);
            nTargetPlayerId = _xTurnData.animation[_nTurnSequence].@targetPlayerId;
            nAttackerPlayerId = mcAnimationContainer._nPlayerOrder;
            log("calling moveto from 1196");
            moveTo(nTargetPlayerId,nAttackerPlayerId,finishRangedTransfer);
            nCurrentFrame = mcAnimationContainer._mcActiveAnimation.currentFrame;
            sOverlayName = mcAnimationContainer._nPlayerOrder + "_Overlays_" + mcAnimationContainer._mcActiveAnimation._xAnimationData.rangedtransfer[0].@resource + "_0";
            xMotion = _mcOverlayContainerHolder[sOverlayName]._xPositionMotion;
            nDataFrame = nCurrentFrame - Number(xMotion.@startframe) - 2;
            nCurrentX = Number(mcAnimationContainer._mcActiveAnimation._xAnimationData.rangedtransfer[0].@translationX);
            nTargetX = Math.abs(nAttackerPlayerId - nTargetPlayerId) * -DataManager.getInstance()._nContainerSeperationX;
            nCurrentY = Number(mcAnimationContainer._mcActiveAnimation._xAnimationData.rangedtransfer[0].@translationY);
            nTargetY = 0;
            xCombatXml = getCombatXML(_xTurnData.animation[_nTurnSequence].@virmonType);
            nDestination = xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).overlay[0].@destination;
            xOnHitAnimations = _xTurnData.animation[_nTurnSequence].onHitAnimation;
            count = 0;
            while(count < xOnHitAnimations.length())
            {
               if(xOnHitAnimations[count].@animationType == "targetVirmon")
               {
                  if(xOnHitAnimations[count].@kill == "0")
                  {
                     sAnimationID = xOnHitAnimations[count].@animationID;
                     if(_xTurnData.animation[_nTurnSequence].@dodge == "1")
                     {
                        break;
                     }
                     if(sAnimationID == "Da1" || sAnimationID == "Da2" || sAnimationID == "Da3" || sAnimationID == "Da4")
                     {
                        nPlayerId = xOnHitAnimations[count].@playerId;
                        sVirmonType = xOnHitAnimations[count].@virmonType;
                        sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
                        xDaData = _mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData;
                        xOffset = Number(xDaData.child("hitloc" + nDestination).frame[0].@translationX);
                        yOffset = Number(xDaData.child("hitloc" + nDestination).frame[0].@translationY);
                        nTargetX += xOffset;
                        nTargetY += yOffset;
                        break;
                     }
                  }
               }
               count++;
            }
            nSteps = 6 * (1 + Math.abs(nAttackerPlayerId - nTargetPlayerId));
            nStepDistanceX = nSteps == 0 ? 0 : (nTargetX - nCurrentX) / nSteps;
            nStepDistanceY = nSteps == 0 ? 0 : (nTargetY - nCurrentY) / nSteps;
            count = 0;
            while(count < nSteps - 1)
            {
               xMotion.appendChild(<frame translationX={nCurrentX + count * nStepDistanceX} translationY={nCurrentY + count * nStepDistanceY} scale='1,1'/>);
               count++;
            }
            nMotionLength = xMotion.length();
            _mcOverlayContainerHolder[sOverlayName].setTriggerEventByNum(xMotion.frame.length() - 2,rangedImpactFrame);
            _mcOverlayContainerHolder[sOverlayName].setEndFunction(rangedImpactFrame);
         }
         catch(e:Error)
         {
            logError("Error during rangedtransfer: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function createOverlay() : OverlayContainer
      {
         var _loc1_:* = new OverlayContainer();
         _loc1_.mouseChildren = false;
         _loc1_.mouseEnabled = false;
         _loc1_.onInitialize(this);
         return _loc1_;
      }
      
      private function checkSecondaryGroupedText(param1:XMLList) : void
      {
         var nMaxAnimationNodes:* = undefined;
         var count:uint = 0;
         var xAnimationList:XMLList = param1;
         try
         {
            fightLog("FightEngine::checkSecondaryGroupedText in try statement line 426  --fma",2);
            nMaxAnimationNodes = xAnimationList.length();
            count = 0;
            while(count < nMaxAnimationNodes)
            {
               if(xAnimationList[count].@animationType == "textEffect")
               {
                  _aTextEffectContainers[_nTotalTextEffectContainers] = createTextEffect(_nTotalTextEffectContainers,xAnimationList[count].@animationID,xAnimationList[count].@myMessage);
                  ++_nTotalTextEffectContainers;
               }
               else if(xAnimationList[count].@animationType == "hpchange")
               {
                  _aTextEffectContainers[_nTotalTextEffectContainers] = createHpChangeEffect(_nTotalTextEffectContainers,xAnimationList[count].@start,xAnimationList[count].@end,xAnimationList[count].@max);
                  ++_nTotalTextEffectContainers;
               }
               else if(xAnimationList[count].@animationType == "targetVirmon")
               {
                  addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,xAnimationList[count].@animationID);
               }
               count++;
            }
         }
         catch(e:Error)
         {
            logError("Error during checkSecondaryGroupedText: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function removeTextEffect(param1:uint) : void
      {
         _aTextEffectContainers[param1].removeMe();
         _aTextEffectContainers[param1] = null;
      }
      
      private function takeErrorActionIO(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,takeErrorAction);
         param1.target.removeEventListener(Event.COMPLETE,combatXMLLoaded);
         param1.target.removeEventListener(Event.COMPLETE,xmlAnimationDataLoaded);
         logError("IOError loading something: " + param1.text);
         endTurnAction();
      }
      
      private function destroyXMLCache() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         for each(_loc1_ in _aCombatXML)
         {
            _aCombatXML[_loc1_] = null;
            delete _aCombatXML[_loc1_];
         }
         for each(_loc2_ in _animationXML)
         {
            _animationXML[_loc2_] = null;
            delete _animationXML[_loc2_];
         }
         _aCombatXML = new Dictionary(true);
         _animationXML = new Dictionary(true);
      }
      
      public function initiateBattle(param1:int, param2:ICharacterAssetTypeCache, param3:IOverlayAssetRetriever) : void
      {
         fightLog("// >>-FMA-> FightEngine::initiate battle",1);
         _characterAssetTypeCache = param2;
         _overlayAssetRetriever = param3;
         _aCombatXML = new Dictionary(true);
         _animationXML = new Dictionary(true);
         if(!choosingNanovor && !battleInitiated)
         {
            battleInitiated = true;
         }
         _nVirmon = param1;
         _bSoundOn = true;
         _nPlayers = param1;
         baselineY = DataManager.getInstance()._nContainerBaselineY;
         if(_aVirmonContainers == null)
         {
            _aVirmonContainers = new Array();
         }
         if(_aNickNames == null)
         {
            _aNickNames = new Array();
         }
         var _loc4_:uint = 0;
         while(_loc4_ < param1)
         {
            _aVirmonContainers[_loc4_] = createVirmon(_loc4_);
            _loc4_++;
         }
         if(_aTextEffectContainers == null)
         {
            _aTextEffectContainers = new Array();
         }
         log("calling moveto from 117");
         moveTo(0,MOVETO_PANORAMA,blankFunction);
      }
      
      private function finishDelayAnimation(param1:TimerEvent) : void
      {
         param1.target.removeEventListener(TimerEvent.TIMER,finishDelayAnimation);
         finishAnimationSet();
      }
      
      private function setTriggerPointsForTextEffect(param1:TextEffectContainer) : void
      {
         if(param1 == null)
         {
            logError("setTriggerPointsForTextEffect: cContainer == null");
            return;
         }
         param1.clearEventsList();
         param1.setEndFunction(finishTextEffect);
      }
      
      public function setSound(param1:Boolean) : void
      {
         _bSoundOn = param1;
      }
      
      private function checkSecondaryAction(param1:*, param2:XMLList) : void
      {
         var nMaxAnimationNodes:* = undefined;
         var xCombatXml:* = undefined;
         var count:uint = 0;
         var deathAnimation:* = undefined;
         var sForceDamage:* = undefined;
         var nParentXML:* = param1;
         var xAnimationList:XMLList = param2;
         try
         {
            fightLog("FightEngine::checkSecondaryAction in try statement line 452  --fma",2);
            nMaxAnimationNodes = xAnimationList.length();
            xCombatXml = getCombatXML(nParentXML.@virmonType);
            count = 0;
            while(count < nMaxAnimationNodes)
            {
               if(xAnimationList[count].@animationType == "textEffect")
               {
                  _aTextEffectContainers[_nTotalTextEffectContainers] = createTextEffect(_nTotalTextEffectContainers,xAnimationList[count].@animationID,xAnimationList[count].@myMessage);
                  ++_nTotalTextEffectContainers;
               }
               else if(xAnimationList[count].@animationType == "hpchange")
               {
                  _aTextEffectContainers[_nTotalTextEffectContainers] = createHpChangeEffect(_nTotalTextEffectContainers,xAnimationList[count].@start,xAnimationList[count].@end,xAnimationList[count].@max);
                  ++_nTotalTextEffectContainers;
               }
               else if(xAnimationList[count].@kill == "1")
               {
                  deathAnimation = xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@deathanimation;
                  if(deathAnimation == "")
                  {
                     logError("ERROR, NO DEATH ANIMATION SET IN COMBAT-ANIMATION.XML FOR THIS NANOVOR!");
                  }
                  else
                  {
                     addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,deathAnimation);
                  }
               }
               else if(nParentXML.@dodge == "1")
               {
                  addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,"Do");
               }
               else if(xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@forcedamage != null && (xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@forcedamage == "Da1" || xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@forcedamage == "da1" || xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@forcedamage == "Da2" || xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@forcedamage == "Da3" || xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@forcedamage == "Da4"))
               {
                  sForceDamage = xCombatXml.animation.(@name.toLowerCase() == nParentXML.@animationID.toLowerCase()).@forcedamage;
                  addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,sForceDamage);
                  xAnimationList[count].@animationID = sForceDamage;
               }
               else
               {
                  addAnimationToList(xAnimationList[count].@playerId.toString(),xAnimationList[count].@virmonType,xAnimationList[count].@animationID);
               }
               count++;
            }
         }
         catch(e:Error)
         {
            logError("Error during checkSecondaryAction: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function startOverlayAnimation(param1:AnimationContainer) : void
      {
         var sOverlayName:String = null;
         var nDuplicateOverlays:* = undefined;
         var count:* = undefined;
         var cOContainer:* = undefined;
         var nOverlayLayer:* = undefined;
         var mcAnimationContainer:AnimationContainer = param1;
         var aOverlayNameList:* = mcAnimationContainer.getOverlayList();
         try
         {
            fightLog("FightEngine::startOverlayAnimation in try statement line 1377  --fma",2);
            nDuplicateOverlays = 0;
            count = 0;
            while(count < aOverlayNameList.length)
            {
               nDuplicateOverlays = 0;
               do
               {
                  sOverlayName = mcAnimationContainer._nPlayerOrder + "_Overlays_" + aOverlayNameList[count] + "_" + nDuplicateOverlays;
                  nDuplicateOverlays++;
               }
               while(_mcOverlayContainerHolder[sOverlayName] != null);
               
               _mcOverlayContainerHolder[sOverlayName] = createOverlay();
               cOContainer = _mcOverlayContainerHolder[sOverlayName];
               cOContainer._xPositionMotion = mcAnimationContainer._mcActiveAnimation._xAnimationData.overlay.(@resource == aOverlayNameList[count])[0];
               cOContainer._nBaseX = cOContainer.x = _aVirmonContainers[mcAnimationContainer._nPlayerOrder].x;
               cOContainer._nBaseY = cOContainer.y = _aVirmonContainers[mcAnimationContainer._nPlayerOrder].y;
               cOContainer.scaleX = -mcAnimationContainer.scaleX;
               nOverlayLayer = Number(mcAnimationContainer._mcActiveAnimation._xAnimationData.overlay.(@resource == aOverlayNameList[count]).@layer);
               if(nOverlayLayer < 2)
               {
                  _smcBattleground.addChildAt(cOContainer,0);
               }
               else
               {
                  _smcBattleground.addChild(cOContainer);
               }
               cOContainer.setEndFunction(finishOverlay);
               ++_nActiveAnimations;
               cOContainer.doAction(_mcAnimationHolder["smcAnimation_" + sOverlayName]);
               cOContainer.setXScale(-1);
               ++_nActiveOverlays;
               count++;
            }
         }
         catch(e:Error)
         {
            logError("Error during startOverlayAnimation: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function loadVirmonAnimationsInOrder(param1:String, param2:String) : void
      {
         var ldr:Loader = null;
         var urlReq:URLRequest = null;
         var sURL:String = param1;
         var animationType:String = param2;
         try
         {
            fightLog("FightEngine::loadVirmonAnimationsInOrder in try statement line 655  --fma",2);
            if(animationType == _ANIMATION_TYPE_CHARACTER)
            {
               ldr = new Loader();
               ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,virmonAnimationLoaded,false,0,true);
               ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,virmonAnimationLoadError,false,0,true);
               urlReq = new URLRequest(sURL);
               ldr.load(urlReq);
            }
            else if(animationType == _ANIMATION_TYPE_OVERLAY)
            {
               ldr = new Loader();
               ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,virmonAnimationLoaded,false,0,true);
               ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,virmonAnimationLoadError,false,0,true);
               urlReq = new URLRequest(sURL);
               ldr.load(urlReq);
            }
         }
         catch(e:Error)
         {
            logError("Error during loadVirmonAnimationsInOrder: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function selfImpactFrame(param1:AnimationContainer) : void
      {
         var xOnHitAnimations:* = undefined;
         var nTextAnimations:* = undefined;
         var count:uint = 0;
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::selfImpactFrame in try statement line 1092  --fma",2);
            xOnHitAnimations = _xTurnData.animation[_nTurnSequence].onHitAnimation;
            nTextAnimations = 0;
            count = 0;
            while(count < xOnHitAnimations.length())
            {
               if(xOnHitAnimations[count].@animationType != "targetVirmon")
               {
                  if(xOnHitAnimations[count].@animationType == "textEffect" || xOnHitAnimations[count].@animationType == "hpchange")
                  {
                     _oEventDispatcher.dispatchEvent(new BattleEngineEvent("EVENT_TRIGGER",xOnHitAnimations[count]));
                     updateFromId(xOnHitAnimations[count].@statementID,xOnHitAnimations[count]);
                     setTriggerPointsForTextEffect(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                     ++_nActiveAnimations;
                     _aTextEffectContainers[_nCurrentTextEffectContainer].x = _aVirmonContainers[xOnHitAnimations[count].@playerId].x;
                     _aTextEffectContainers[_nCurrentTextEffectContainer].y = _aVirmonContainers[xOnHitAnimations[count].@playerId].y + 30 * _nActivelyPlayingTextEffectContainers;
                     _smcBattleground.addChild(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                     _aTextEffectContainers[_nCurrentTextEffectContainer].doAction(_aTextEffectContainers[_nCurrentTextEffectContainer]._smcTextEffectHolder);
                     ++_nCurrentTextEffectContainer;
                     ++_nActivelyPlayingTextEffectContainers;
                  }
               }
               count++;
            }
         }
         catch(e:Error)
         {
            logError("Error during selfImpactFrame: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function loadXmlAnimationDataInOrder(param1:String) : void
      {
         fightLog("FightEngine::loadXmlAnimationDataInOrder in try statement line 539  --fma",2);
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,takeErrorActionIO,false,0,true);
         _loc2_.addEventListener(Event.COMPLETE,xmlAnimationDataLoaded,false,0,true);
         animationXMLURL = param1;
         _loc2_.load(new URLRequest(param1));
      }
      
      public function createVirmon(param1:uint) : VirmonContainer
      {
         var _loc4_:NickNameText = null;
         fightLog("// >>-FMA-> FightEngine::createVirmon nPlayerOrder: " + param1,2);
         spacingArray = CombatGamePanel["_SPOTLIGHT_POINTS_" + _nVirmon + "PLAYER"];
         var _loc2_:Boolean = _aVirmonContainers.length == param1 + 1;
         var _loc3_:VirmonContainer = _loc2_ ? _aVirmonContainers[param1] : new VirmonContainer();
         _loc3_.enabled = false;
         _loc3_.mouseChildren = false;
         _loc3_.mouseEnabled = false;
         if(!_loc2_)
         {
            _smcBattleground.addChildAt(_loc3_,0);
            _loc4_ = new NickNameText();
            _smcBattleground.addChild(_loc4_);
            _aNickNames[param1] = _loc4_;
            _aNickNames[param1]._sdtNickname.text = "";
            _loc3_._nPlayerOrder = param1;
            _loc3_.onInitialize(this);
         }
         _loc3_.scaleX = param1 == 0 ? -0.6 : 0.6;
         _loc3_.scaleY = 0.6;
         _loc3_.x = _loc4_.x = spacingArray[param1] + _buffer;
         _loc3_.y = _loc4_.y = baselineY;
         return _loc3_;
      }
      
      private function delayTime(param1:Number) : void
      {
         var _loc2_:Timer = new Timer(param1,1);
         _loc2_.addEventListener(TimerEvent.TIMER,finishDelayAnimation);
         _loc2_.start();
      }
      
      private function tweenNanovor() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         holdingForTween = true;
         fightLog("tweenNanovor() currentTurn: " + currentTurn,0);
         if(currentTurn < 1)
         {
            ++currentTweenCount;
            onFinishTween();
            return;
         }
         fightLog("tweenNanovor()\n\tmovingToPanorama: " + movingToPanorama,2);
         var _loc1_:int = 0;
         while(_loc1_ < _aVirmonContainers.length)
         {
            _loc2_ = movingToPanorama ? baselineY : Number(DataManager.getInstance()._nContainerY);
            _loc3_ = movingToPanorama ? spacingArray[_loc1_] + _buffer : DataManager.getInstance()._nFirstContainerX + _loc1_ * DataManager.getInstance()._nContainerSeperationX;
            _loc4_ = movingToPanorama ? 0.6 : 1;
            if(_loc1_ == 0)
            {
               _loc4_ *= -1;
            }
            else if(movingToPanorama)
            {
               if(_aVirmonContainers[_loc1_].scaleX < 0)
               {
                  _aVirmonContainers[_loc1_].scaleX *= -1;
               }
            }
            else if(_aVirmonContainers[_loc1_].scaleX < 0)
            {
               _loc4_ *= -1;
            }
            _loc5_ = movingToPanorama ? 0.6 : 1;
            Tweener.addTween(_aVirmonContainers[_loc1_],{
               "y":_loc2_,
               "x":_loc3_,
               "scaleY":_loc5_,
               "scaleX":_loc4_,
               "time":1,
               "onComplete":onFinishTween
            });
            ++currentTweenCount;
            _loc1_++;
         }
      }
      
      private function loadRequiredAnimations() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         fightLog("FightEngine::loadRequiredAnimations",2);
         _aVirmonAnimations = new Array();
         _nTotalAnimations = 0;
         _nTotalTextEffectContainers = 0;
         checkPrimaryAction(_xTurnData.animation);
         _nTotalAnimations = _aVirmonAnimations.length;
         _nXmlLoaded = 0;
         loadNextXmlAnimationDataInOrder();
      }
      
      private function impactframe(param1:AnimationContainer) : void
      {
         var xOnHitAnimations:* = undefined;
         var nTextAnimations:* = undefined;
         var count:uint = 0;
         var nPlayerId:* = undefined;
         var sAnimationID:* = undefined;
         var sVirmonType:* = undefined;
         var sAnimationName:String = null;
         var xCombatXml:* = undefined;
         var deathAnimation:* = undefined;
         var mcAnimationContainer:AnimationContainer = param1;
         try
         {
            fightLog("FightEngine::impactFrame in try statement line 1141  --fma",2);
            xOnHitAnimations = _xTurnData.animation[_nTurnSequence].onHitAnimation;
            _oEventDispatcher.dispatchEvent(new BattleEngineEvent("EVENT_TRIGGER",xOnHitAnimations));
            nTextAnimations = 0;
            count = 0;
            while(count < xOnHitAnimations.length())
            {
               if(xOnHitAnimations[count].@animationType == "targetVirmon")
               {
                  nPlayerId = xOnHitAnimations[count].@playerId;
                  sAnimationID = xOnHitAnimations[count].@animationID;
                  sVirmonType = xOnHitAnimations[count].@virmonType;
                  if(_xTurnData.animation[_nTurnSequence].@dodge == "1")
                  {
                     sAnimationID = "Do";
                  }
                  else
                  {
                     if(xOnHitAnimations[count].@kill == "1")
                     {
                        xCombatXml = getCombatXML(_xTurnData.animation[_nTurnSequence].@virmonType);
                        deathAnimation = xCombatXml.animation.(@name.toLowerCase() == _xTurnData.animation[_nTurnSequence].@animationID.toLowerCase()).@deathanimation;
                        sAnimationID = deathAnimation;
                     }
                     sAnimationName = nPlayerId + "_" + sVirmonType + "_" + sAnimationID;
                     setTriggerPointsForTarget(_aVirmonContainers[nPlayerId],_mcAnimationHolder["smcAnimation_" + sAnimationName]._xAnimationData,sAnimationName);
                     ++_nActiveAnimations;
                     _aVirmonContainers[nPlayerId].doAction(_mcAnimationHolder["smcAnimation_" + sAnimationName]);
                  }
               }
               else if(xOnHitAnimations[count].@animationType == "textEffect" || xOnHitAnimations[count].@animationType == "hpchange")
               {
                  if(_aTextEffectContainers[_nCurrentTextEffectContainer] == null)
                  {
                     fightLog("HA!  I CAUGHT YOU!: null found for _aTextEffectContainers[_nCurrentTextEffectContainer]:\n" + "_aTextEffectContainers.length = " + _aTextEffectContainers.length + "\n_nCurrentTextEffectContainer = " + _nCurrentTextEffectContainer,0);
                     fightLog(_aTextEffectContainers,2);
                  }
                  updateFromId(xOnHitAnimations[count].@statementID,xOnHitAnimations[count]);
                  setTriggerPointsForTextEffect(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                  ++_nActiveAnimations;
                  fightLog("_aTextEffectContainers[_nCurrentTextEffectContainer].x: " + (_aTextEffectContainers[_nCurrentTextEffectContainer] == null ? "null" : _aTextEffectContainers[_nCurrentTextEffectContainer].x),2);
                  fightLog("_aVirmonContainers[xOnHitAnimations[count].@playerId].x: " + (_aVirmonContainers[xOnHitAnimations[count].@playerId] == null ? "null" : _aVirmonContainers[xOnHitAnimations[count].@playerId].x),2);
                  _aTextEffectContainers[_nCurrentTextEffectContainer].x = _aVirmonContainers[xOnHitAnimations[count].@playerId].x;
                  _aTextEffectContainers[_nCurrentTextEffectContainer].y = _aVirmonContainers[xOnHitAnimations[count].@playerId].y + 30 * _nActivelyPlayingTextEffectContainers;
                  _smcBattleground.addChild(_aTextEffectContainers[_nCurrentTextEffectContainer]);
                  _aTextEffectContainers[_nCurrentTextEffectContainer].doAction(_aTextEffectContainers[_nCurrentTextEffectContainer]._smcTextEffectHolder);
                  ++_nCurrentTextEffectContainer;
                  fightLog("incrementing _nCurrentTextEffectContainer to : " + _nCurrentTextEffectContainer + " \n\txOnHitAnimations[count=" + count + "]: " + xOnHitAnimations[count].toXMLString(),2);
                  ++_nActivelyPlayingTextEffectContainers;
               }
               count++;
            }
         }
         catch(e:Error)
         {
            logError("Error during impactframe: " + e.toString());
            takeErrorAction(e);
         }
      }
      
      private function setTriggerPointsForVisual(param1:VirmonContainer, param2:XML) : void
      {
         if(param1 == null)
         {
            logError("setTriggerPointsForVisual: cContainer == null");
            return;
         }
         param1.clearEventsList();
         param1.setEndFunction(finishAnimation);
      }
      
      private function reachedMoveToLocation() : void
      {
         if(!holdingForTween)
         {
            _fPostMove();
         }
      }
      
      private function setTriggerPointsForAttack(param1:VirmonContainer, param2:XML) : void
      {
         var nOffset:* = undefined;
         var countO:uint = 0;
         var cContainer:VirmonContainer = param1;
         var xData:XML = param2;
         try
         {
            fightLog("FightEngine::setTriggerPointsForAttack in try statement line 1034  --fma",2);
            cContainer.setEndFunction(finishVirmonAttackAnimation);
            cContainer.clearEventsList();
            if(_xTurnData.animation[_nTurnSequence].@playerId == _xTurnData.animation[_nTurnSequence].@targetPlayerId)
            {
               cContainer.setTriggerEventByNum(2,selfImpactFrame);
            }
            else if(xData.impactframe == undefined && xData.meleetransfer == undefined && xData.rangedtransfer == undefined)
            {
               cContainer.setTriggerEventByNum(2,selfImpactFrame);
            }
            else
            {
               if(xData.impactframe != undefined)
               {
                  if(_xTurnData.animation[_nTurnSequence].@dodge == "1")
                  {
                     nOffset = 7;
                     cContainer.setTriggerEventByNum(Number(xData.impactframe[0].@frame) - nOffset,dodgeEvent);
                  }
                  cContainer.setTriggerEventByNum(Number(xData.impactframe[0].@frame) + 1,impactframe);
               }
               if(xData.meleetransfer != undefined)
               {
                  cContainer.setTriggerEventByNum(Number(xData.meleetransfer[0].@frame) + 1,meleetransfer);
               }
               if(xData.rangedtransfer != undefined)
               {
                  if(_xTurnData.animation[_nTurnSequence].@dodge == "1")
                  {
                     cContainer.setTriggerEventByNum(Number(xData.rangedtransfer[0].@frame) + 5,dodgeEvent);
                  }
                  cContainer.setTriggerEventByNum(Number(xData.rangedtransfer[0].@frame) + 2,rangedtransfer);
               }
            }
            if(xData.overlay != undefined)
            {
               cContainer._aOverlayNamesPerFrame = new Array();
               countO = 0;
               while(countO < xData.overlay.length())
               {
                  if(cContainer._aOverlayNamesPerFrame[Number(xData.overlay[countO].@startframe) + 1] == null)
                  {
                     cContainer._aOverlayNamesPerFrame[Number(xData.overlay[countO].@startframe) + 1] = new Array();
                  }
                  cContainer._aOverlayNamesPerFrame[Number(xData.overlay[countO].@startframe) + 1].push(xData.overlay[countO].@resource);
                  cContainer.setTriggerEventByNum(Number(xData.overlay[countO].@startframe) + 1,startOverlayAnimation);
                  countO++;
               }
            }
         }
         catch(e:Error)
         {
            logError("Error during setTriggerPointsForAttack: " + e.toString());
            takeErrorAction(e);
         }
      }
   }
}

