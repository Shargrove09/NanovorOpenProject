package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.virmon.battle.components.TargetReticle;
   import com.arkadium.virmon.battle.control.*;
   import com.arkadium.virmon.battle.substates.combatgame.*;
   import com.arkadium.virmon.help.attackchooser.IHelpAttackChooser;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.events.SpotlightEvent;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindow;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class AttackChooser extends Sprite
   {
      
      public static const BRING_OUT_COMPLETE:String = "bringOutComplete";
      
      private var _helpHandler:IHelpAttackChooser;
      
      private var _bIsFirstRound:Boolean = false;
      
      private var _bMySpotlightOpen:Boolean = false;
      
      private var _bNanovorPickerReady:Boolean = false;
      
      private var _control:CombatUIController = null;
      
      private var _bInView:Boolean = false;
      
      private var _turnData:CombatTurnData = null;
      
      private var _infoWindows:Dictionary;
      
      private var _firstTargetSelect:Boolean = true;
      
      private const NEXT_NANOVOR_POINT_X:int = 247;
      
      private const NEXT_NANOVOR_POINT_Y:int = 488;
      
      private const TIMER_SECONDS:int = 60;
      
      private var _bSwapIconTweening:Boolean = false;
      
      private const ANIMATION_CHECK_READY_TIMER:int = 250;
      
      private const STATE_SWAP_SELECTED:int = 8;
      
      private const STATE_MY_NANOVOR_SELECTED:int = 1;
      
      private const DEBUG_LOG_LEVEL:int = 100;
      
      private const NANOVOR_PICKER_POINT_Y:int = 400;
      
      private var _nanovorPicker:NanovorPicker = null;
      
      private var _swapPicker:SwapPicker = null;
      
      private var _targetPlayerIndex:int = -1;
      
      private const FOOTER_Y_OUT:int = 768;
      
      private var _aStateSequence:Array;
      
      private var _firstAttackSelect:Boolean = true;
      
      private const STATE_ACTION_SELECTED:int = 2;
      
      private var _myPicker:ActionPicker = null;
      
      private var _footer:AttackChooserFooter = null;
      
      private const STATE_TARGET_SELECTED:int = 4;
      
      private var _readyForBattleSpinner:ReadyForBattleSpinner = null;
      
      private var _firstTargetConfirm:Boolean = true;
      
      private const ACTION_PICKER_POINT_Y:int = 120;
      
      private var _iState:int = 0;
      
      private var _firstNanovorSelect:Boolean = true;
      
      private var _myNanovor:INanovor = null;
      
      private var _enemyPickers:Array;
      
      private const STATE_EMPTY:int = 0;
      
      private const FOOTER_X:int = 78;
      
      private var _firstSwap:Boolean = true;
      
      private var _aLastNanovorsSelectedUpdatedIDs:Array;
      
      private var _swapNanovorIcon:NanovorIcon = null;
      
      private var _tmrCheckAnimationReady:Timer = null;
      
      private const FOOTER_Y_IN:int = 729;
      
      private const STATE_CONFIRMED:int = 16;
      
      private const DEFAULT_LOG_LEVEL:int = 2;
      
      private var _timeoutSeconds:int;
      
      public function AttackChooser(param1:ISoundManager, param2:CombatUIController, param3:Array, param4:int)
      {
         var _loc5_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:ActionPickerEnemy = null;
         var _loc10_:InfoWindow = null;
         _enemyPickers = new Array();
         _infoWindows = new Dictionary(true);
         super();
         _control = param2;
         _timeoutSeconds = param4;
         _iState = STATE_EMPTY;
         var _loc6_:AbstractState = Managers.stateManager.getStateByName(StateType.BATTLE.name);
         if(_loc6_ == null)
         {
            _loc6_ = Managers.stateManager.getStateByName(StateType.SENSEI_BATTLE.name);
         }
         if(_loc6_ == null)
         {
            logError("AttackChooser(): Cannot set quicktips url on null state! (somehow current state is not BATTLE or SENSEI_BATTLE)");
         }
         else
         {
            _loc6_.quicktipsURL = Const.QUICKTIP_ATTACK_SWAP;
         }
         Managers.stateManager.handleHelp(Const.HELP_ATTACKCHOOSER,this);
         _aStateSequence = [STATE_EMPTY,STATE_MY_NANOVOR_SELECTED,STATE_ACTION_SELECTED,STATE_TARGET_SELECTED,STATE_SWAP_SELECTED,STATE_CONFIRMED];
         _nanovorPicker = new NanovorPicker(_control);
         _nanovorPicker.initAttention();
         _swapPicker = new SwapPicker(_control);
         _aLastNanovorsSelectedUpdatedIDs = [0];
         var _loc7_:Array = new Array();
         _loc5_ = 1;
         while(_loc5_ < param3.length)
         {
            if(param3.length > 2 && _loc5_ == param3.length - 1)
            {
               _loc9_ = new ActionPickerEnemy(param1,_control.players[_loc5_],param3[_loc5_],ActionPickerEnemy.DIRECTION_LEFT);
            }
            else
            {
               _loc9_ = new ActionPickerEnemy(param1,_control.players[_loc5_],param3[_loc5_],ActionPickerEnemy.DIRECTION_RIGHT);
            }
            _loc8_ = {
               "playerId":_control.players[_loc5_].userRefId,
               "xPosition":param3[_loc5_].x - param3[0].x,
               "player":_control.players[_loc5_]
            };
            _loc7_.push(_loc8_);
            _loc9_.x = _loc9_.spotlight.x;
            _loc9_.y = ACTION_PICKER_POINT_Y;
            addChild(_loc9_);
            _aLastNanovorsSelectedUpdatedIDs.push(0);
            _control.battleGame.spMoviePlayerContainer.addChild(_loc9_.characterContainer);
            _loc9_.characterContainer.x += _loc9_.x;
            _loc9_.characterContainer.y += _loc9_.y;
            _loc9_.addEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OVER,onActionPickerNanovorRollOver,false,0,true);
            _loc9_.addEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OUT,onActionPickerNanovorRollOut,false,0,true);
            _enemyPickers.push(_loc9_);
            _loc5_++;
         }
         _myPicker = new ActionPicker(param1,_control.myPlayer,param3[0],_loc7_);
         _myPicker.x = _myPicker.spotlight.x;
         _myPicker.y = ACTION_PICKER_POINT_Y;
         addChild(_myPicker);
         _control.battleGame.spMoviePlayerContainer.addChild(_myPicker.characterContainer);
         _myPicker.characterContainer.x += _myPicker.x;
         _myPicker.characterContainer.y += _myPicker.y;
         _myPicker.addEventListener(ActionSelectionEvent.ACTION_PICKER_ATTACK_SELECTED,onActionPickerAttackSelected,false,0,true);
         _myPicker.addEventListener(ActionSelectionEvent.ACTION_PICKER_ATTACK_DESELECTED,onActionPickerAttackDeselected,false,0,true);
         _myPicker.addEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OVER,onActionPickerNanovorRollOver,false,0,true);
         _myPicker.addEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OUT,onActionPickerNanovorRollOut,false,0,true);
         _loc5_ = 0;
         while(_loc5_ < param3.length)
         {
            _loc10_ = new InfoWindow();
            _loc10_.x = param3[_loc5_].x + ActionSlotComponent.WIDTH - 32;
            _loc10_.y = 540;
            _loc10_.title.hideSV();
            _loc10_.visible = false;
            addChild(_loc10_);
            _infoWindows[_control.players[_loc5_]] = _loc10_;
            _loc5_++;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:ActionPickerEnemy = null;
         var _loc2_:InfoWindow = null;
         log("destroy()",2);
         if(Boolean(_tmrCheckAnimationReady))
         {
            _tmrCheckAnimationReady.removeEventListener(TimerEvent.TIMER,onCheckAnimationReadyTimerTick);
            _tmrCheckAnimationReady.stop();
            _tmrCheckAnimationReady = null;
         }
         if(Boolean(_footer))
         {
            Tweener.removeTweens(_footer);
            _footer.stopTimer();
            _footer.removeEventListener(AttackChooserFooter.TIMER_HIT_ZERO,onTimerHitZero);
            if(contains(_footer))
            {
               removeChild(_footer);
            }
            _footer = null;
         }
         for each(_loc1_ in _enemyPickers)
         {
            _loc1_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OVER,onActionPickerNanovorRollOver);
            _loc1_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OUT,onActionPickerNanovorRollOut);
            _loc1_.destroy();
            removeChildrenTweens(_loc1_);
            _loc1_ = null;
         }
         if(null != _myPicker)
         {
            _myPicker.removeEventListener(ActionSelectionEvent.ACTION_PICKER_ATTACK_SELECTED,onActionPickerAttackSelected);
            _myPicker.removeEventListener(ActionSelectionEvent.ACTION_PICKER_ATTACK_DESELECTED,onActionPickerAttackDeselected);
            _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OVER,onActionPickerNanovorRollOver);
            _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OUT,onActionPickerNanovorRollOut);
            _myPicker.destroy();
            removeChildrenTweens(_myPicker);
            _myPicker = null;
         }
         for each(_loc2_ in _infoWindows)
         {
            _loc2_.destroy();
         }
         _nanovorPicker.removeEventListener(NanovorPicker.DISPLAY_UPDATED,onNanovorPickerDisplayUpdated);
         _nanovorPicker.removeEventListener(NanovorPickerEvent.NANOVOR_ICON_SELECTED,onNanovorSelected);
         _nanovorPicker.destroy();
         _swapPicker.removeEventListener(SwapPicker.DISPLAY_BRING_OUT_COMPLETE,onSwapPickerBringOutComplete);
         _swapPicker.removeEventListener(SwapPickerEvent.BUTTON_CLICK,onSwapPickerButtonClick);
         _swapPicker.removeEventListener(SwapPickerEvent.NANOVOR_ICON_SELECTED,onSwapSelected);
         _swapPicker.removeEventListener(SwapPickerEvent.NO_SWAP_SELECTED,onSwapSelected);
         _swapPicker.destroy();
      }
      
      private function goToNextStep() : void
      {
         var _loc1_:ActionPickerEnemy = null;
         var _loc2_:int = 0;
         var _loc5_:ActionPickerEnemy = null;
         var _loc6_:Boolean = false;
         log("goToNextStep: _iState = " + _iState,2);
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if((_iState & STATE_CONFIRMED) == STATE_CONFIRMED)
         {
            log("... STATE_CONFIRMED",3);
            if(Boolean(_helpHandler))
            {
               _helpHandler.destroy();
            }
            sendAttack();
         }
         else if((_iState & STATE_SWAP_SELECTED) == STATE_SWAP_SELECTED)
         {
            log("... STATE_SWAP_SELECTED",3);
            if(_turnData.AttackData == null || Boolean(_turnData.AttackData.isSelfTarget))
            {
               _loc3_ = true;
               _myPicker.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_TARGET;
               _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserEnd,false,0,true);
               _myPicker.spotlight.chaserDown();
               _myPicker.confirmReticle.ctaMessage = TargetReticle.CTA_CONFIRM;
               _myPicker.confirmReticle.color = TargetReticle.TARGET_RETICLE_COLOR_BLUE;
            }
            else
            {
               for each(_loc1_ in _enemyPickers)
               {
                  if(_loc1_.player.username.toLowerCase() == _turnData.TargetedPlayerName.toLowerCase())
                  {
                     _loc1_.showActions = false;
                     _loc1_.open(true);
                     _loc1_.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_TARGET;
                     _loc1_.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_LIGHT_OPENED,onEnemySpotlightOpened,false,0,true);
                     _loc1_.spotlight.openLight();
                     _loc1_.confirmReticle.ctaMessage = TargetReticle.CTA_CONFIRM;
                     _loc1_.confirmReticle.color = TargetReticle.TARGET_RETICLE_COLOR_RED;
                     _loc1_.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onEnemySpotlightChaserEnd,false,0,true);
                     _myPicker.openSelectedAttackForConfirm(_loc1_.player.userRefId);
                     break;
                  }
                  _loc4_++;
               }
            }
            if(_firstTargetConfirm)
            {
               _firstTargetConfirm = false;
               if(Boolean(_helpHandler))
               {
                  _helpHandler.showTargetConfirmHelp(_enemyPickers,_loc4_,_loc3_,3000);
               }
            }
         }
         else if((_iState & STATE_TARGET_SELECTED) == STATE_TARGET_SELECTED)
         {
            log("... STATE_TARGET_SELECTED",3);
            _swapPicker.activeNanovor = _myNanovor;
            _swapPicker.updateSwarm();
            _swapPicker.addEventListener(SwapPickerEvent.NANOVOR_ICON_SELECTED,onSwapSelected,false,0,true);
            _swapPicker.addEventListener(SwapPickerEvent.NO_SWAP_SELECTED,onSwapSelected,false,0,true);
            if(_turnData.AttackData == null || Boolean(_turnData.AttackData.isSelfTarget))
            {
               _myPicker.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_SWAP;
               _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_HALF_DONE,onMySpotlightChaserHalfDone,false,0,true);
               _myPicker.spotlight.chaserUp();
            }
            else
            {
               _myPicker.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_SWAP_FROM_TOP;
               _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_HALF_DONE,onMySpotlightChaserHalfDone,false,0,true);
               _myPicker.spotlight.chaserDown(0.5);
            }
            if(_firstSwap)
            {
               _firstSwap = false;
               if(Boolean(_helpHandler))
               {
                  _helpHandler.showSwapHelp(3000);
               }
            }
         }
         else if((_iState & STATE_ACTION_SELECTED) == STATE_ACTION_SELECTED)
         {
            log("... STATE_ACTION_SELECTED",3);
            for each(_loc1_ in _enemyPickers)
            {
               _loc1_.showActions = false;
            }
            if(_turnData.AttackData == null || Boolean(_turnData.AttackData.isSelfTarget))
            {
               _loc3_ = true;
               _myPicker.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_TARGET;
               _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserEnd,false,0,true);
               _myPicker.spotlight.chaserDown();
               _myPicker.confirmReticle.ctaMessage = TargetReticle.CTA_SELECT;
               _myPicker.confirmReticle.color = TargetReticle.TARGET_RETICLE_COLOR_BLUE;
            }
            else
            {
               _loc2_ = 0;
               _loc5_ = null;
               for each(_loc1_ in _enemyPickers)
               {
                  if(!_loc1_.player.isDead && !_loc1_.player.leftGame)
                  {
                     _loc1_.showActions = false;
                     _loc1_.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_TARGET;
                     _loc1_.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onEnemySpotlightOpened,false,0,true);
                     _loc1_.spotlight.open(false,_loc2_ * 0.06);
                     _loc1_.confirmReticle.ctaMessage = TargetReticle.CTA_ATTACK;
                     _loc1_.confirmReticle.color = TargetReticle.TARGET_RETICLE_COLOR_RED;
                     _loc2_++;
                     _loc5_ = _loc1_;
                  }
               }
               if(Boolean(_loc5_))
               {
                  _loc5_.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onEnemySpotlightChaserEnd,false,0,true);
               }
            }
            if(_firstTargetSelect)
            {
               _firstTargetSelect = false;
               if(Boolean(_helpHandler))
               {
                  _helpHandler.showTargetSelectHelp(_enemyPickers,_loc3_,3000);
               }
            }
         }
         else if((_iState & STATE_MY_NANOVOR_SELECTED) == STATE_MY_NANOVOR_SELECTED)
         {
            log("... STATE_MY_NANOVOR_SELECTED",3);
            for each(_loc1_ in _enemyPickers)
            {
               _loc1_.showActions = true;
            }
            _loc6_ = _myPicker.setNanovor(_myNanovor);
            log("... bFreshNanovorSet=" + _loc6_);
            if(_loc6_)
            {
               _myPicker.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_ATTACK;
               if(_bMySpotlightOpen)
               {
                  _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserEnd,false,0,true);
                  _myPicker.spotlight.chaserUp();
                  _myPicker.spotlight.showMessage(Spotlight.MESSAGE_SELECT_ATTACK,0,0.4,1.5,0.4,"easeOutBounce");
               }
               else
               {
                  _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onMySpotlightOpened,false,0,true);
                  _myPicker.spotlight.open();
                  _bMySpotlightOpen = true;
                  _myPicker.spotlight.showMessage(Spotlight.MESSAGE_SELECT_ATTACK,0.4,0.4,1.9,0.4,"easeOutBounce");
               }
            }
            if(_firstAttackSelect)
            {
               _firstAttackSelect = false;
               if(Boolean(_helpHandler))
               {
                  _helpHandler.showAttackSelectHelp(IActionPickerAutomation(_myPicker),3000);
               }
            }
         }
         else if((_iState & STATE_EMPTY) == STATE_EMPTY)
         {
            log("... STATE_EMPTY",3);
            _myPicker.updateSwarm();
            _myPicker.spotlight.chaserMaskType = Spotlight.CHASER_MASK_SELECT_NANOVOR;
            _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onMySpotlightOpened,false,0,true);
            _myPicker.spotlight.open();
            _bMySpotlightOpen = true;
            if(_firstNanovorSelect)
            {
               _firstNanovorSelect = false;
               if(Boolean(_helpHandler))
               {
                  _helpHandler.showNanovorSelectHelp(3000);
               }
            }
         }
         else
         {
            logError("goToNextStep -- in unknown state! *** CRITICAL ***");
         }
      }
      
      public function setHelpHandler(param1:IHelpAttackChooser) : void
      {
         _helpHandler = param1;
      }
      
      private function onEnemySpotlightOpened(param1:SpotlightEvent) : void
      {
         log("onEnemySpotlightOpened");
         var _loc2_:Spotlight = param1.target as Spotlight;
         _loc2_.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onEnemySpotlightOpened);
         _loc2_.removeEventListener(SpotlightEvent.SPOTLIGHT_LIGHT_OPENED,onEnemySpotlightOpened);
         _loc2_.chaserDown();
      }
      
      private function revertState(param1:*) : void
      {
         var _loc2_:IAttack = null;
         var _loc3_:ActionPickerEnemy = null;
         log("revertState: " + param1,3);
         switch(param1)
         {
            case STATE_ACTION_SELECTED:
               _iState &= ~STATE_ACTION_SELECTED;
               _loc2_ = _turnData.AttackData;
               _turnData.AttackId = 0;
               _turnData.AttackData = null;
               if(_loc2_ == null || Boolean(_loc2_.isSelfTarget))
               {
                  _myPicker.showConfirm = false;
                  _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
               }
               else
               {
                  for each(_loc3_ in _enemyPickers)
                  {
                     _loc3_.showConfirm = false;
                     _loc3_.spotlight.closeLight();
                     _loc3_.spotlight.close();
                     _loc3_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
                  }
               }
               _swapPicker.bringOut();
               break;
            case STATE_TARGET_SELECTED:
               _iState &= ~STATE_TARGET_SELECTED;
               if(_targetPlayerIndex == 0)
               {
                  _myPicker.spotlight.setRingState(Spotlight.RING_UP);
               }
               else if(_targetPlayerIndex > 0)
               {
                  _enemyPickers[_targetPlayerIndex].spotlight.setRingStone(Spotlight.RING_UP);
               }
               _targetPlayerIndex = -1;
               _turnData.TargetedPlayerName = "";
               _swapPicker.bringOut();
               break;
            case STATE_SWAP_SELECTED:
               _iState &= ~STATE_SWAP_SELECTED;
               _turnData.MyNextNanovorId = "0";
               killSelectedSwapIcon();
               if(_turnData.AttackData == null || Boolean(_turnData.AttackData.isSelfTarget))
               {
                  _myPicker.showConfirm = false;
                  _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
               }
               else
               {
                  for each(_loc3_ in _enemyPickers)
                  {
                     if(_loc3_.player.username.toLowerCase() == _turnData.TargetedPlayerName.toLowerCase())
                     {
                        _loc3_.showConfirm = false;
                        _loc3_.spotlight.closeLight();
                        _loc3_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
                     }
                  }
               }
               _myPicker.confirmedSelectedAction();
               break;
            case STATE_MY_NANOVOR_SELECTED:
            case STATE_EMPTY:
         }
      }
      
      private function selectNanovor(param1:INanovor) : void
      {
         _myNanovor = param1;
         _turnData.MyActiveNanovorId = _myNanovor.assetId;
         _control.battleController.myPlayer.selectedNanovor = _myNanovor;
         _control.battleController.generateAttackPreviews();
         _iState |= STATE_MY_NANOVOR_SELECTED;
      }
      
      private function killSelectedSwapIcon() : void
      {
         _bSwapIconTweening = false;
         if(Boolean(_swapNanovorIcon) && contains(_swapNanovorIcon))
         {
            Tweener.removeTweens(_swapNanovorIcon,"x","y");
            Tweener.addTween(_swapNanovorIcon,{
               "alpha":0,
               "time":0.3,
               "transition":"easeOutQuad",
               "onComplete":onKillSelectedSwapIconComplete
            });
         }
      }
      
      private function onSwapPickerBringOutComplete(param1:Event) : void
      {
         _swapPicker.removeEventListener(SwapPicker.DISPLAY_BRING_OUT_COMPLETE,onSwapPickerBringOutComplete);
         goToNextStep();
      }
      
      private function onClearReadyForBattleSpinnerTweenComplete() : void
      {
         _readyForBattleSpinner.visible = false;
         removeChild(_readyForBattleSpinner);
         _readyForBattleSpinner = null;
      }
      
      private function onCheckAnimationReadyTimerTick(param1:TimerEvent) : void
      {
         log("@@@ onCheckAnimationReadyTimerTick",2);
         _tmrCheckAnimationReady.removeEventListener(TimerEvent.TIMER,onCheckAnimationReadyTimerTick);
         _tmrCheckAnimationReady.stop();
         _tmrCheckAnimationReady = null;
         sendAttack();
      }
      
      private function onSwapPickerButtonClick(param1:SwapPickerEvent) : void
      {
         log("onSwapPickerButtonClick");
         _swapPicker.removeEventListener(SwapPickerEvent.BUTTON_CLICK,onSwapPickerButtonClick);
         rollStateBackTo(STATE_SWAP_SELECTED);
         goToNextStep();
      }
      
      private function selectConfirm() : void
      {
         _iState |= STATE_CONFIRMED;
      }
      
      private function onBringOutTweenComplete(param1:Event) : void
      {
         log("onBringOutTweenComplete",2);
         _myPicker.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CLOSED,onBringOutTweenComplete);
         visible = false;
         dispatchEvent(new Event(BRING_OUT_COMPLETE));
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** AttackChooser: " + param1);
      }
      
      private function forceSendAttack() : void
      {
         var _loc1_:INanovor = null;
         var _loc2_:INanovor = null;
         var _loc3_:int = 0;
         if((_iState & STATE_MY_NANOVOR_SELECTED) != STATE_MY_NANOVOR_SELECTED)
         {
            _loc2_ = null;
            _loc3_ = 0;
            while(_loc3_ < _control.myPlayer.swarm.length)
            {
               _loc1_ = _control.myPlayer.swarm[_loc3_];
               if(!_loc1_.isDead)
               {
                  if(_loc2_ == null || _loc1_.swarmValue < _loc2_.swarmValue)
                  {
                     _loc2_ = _loc1_;
                  }
               }
               _loc3_++;
            }
            if(_loc2_ != null)
            {
               _nanovorPicker.bringOut();
               if(_bIsFirstRound)
               {
                  _nanovorPicker.stopAttention();
                  clearReadyForBattleSpinner();
               }
               selectNanovor(_loc2_);
               _myPicker.clearCharacter();
               log("@@@ forceSendAttack -- calling roundCountroller.chooseNanovor()",1);
               _control.battleController.roundController.chooseNanovor();
            }
            if((_iState & STATE_MY_NANOVOR_SELECTED) != STATE_MY_NANOVOR_SELECTED)
            {
               logError("sendAttack: Could not auto-select the next nanovor  ** CRITICAL **");
               return;
            }
         }
         sendAttack();
      }
      
      private function log(param1:String, param2:int = 2) : void
      {
         if(DEBUG_LOG_LEVEL >= param2)
         {
            DebugLog.instance.log(">> AttackChooser: " + param1);
         }
      }
      
      private function onMySpotlightChaserEnd(param1:SpotlightEvent) : void
      {
         log("onMySpotlightChaserEnd");
         _myPicker.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserEnd);
         if((_iState & STATE_ACTION_SELECTED) == STATE_ACTION_SELECTED)
         {
            _myPicker.showConfirm = true;
            _myPicker.addEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick,false,0,true);
         }
         else if((_iState & STATE_MY_NANOVOR_SELECTED) == STATE_MY_NANOVOR_SELECTED)
         {
            if(_bIsFirstRound)
            {
               _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserDoubleEnd,false,0,true);
               _myPicker.spotlight.chaserUp();
            }
            else
            {
               _myPicker.open();
            }
         }
      }
      
      private function selectAction(param1:IAttack) : void
      {
         if(param1 == null)
         {
            _turnData.AttackData = null;
            _turnData.AttackId = 0;
         }
         else
         {
            _turnData.AttackData = param1;
            _turnData.AttackId = param1.attackID;
         }
         _iState |= STATE_ACTION_SELECTED;
      }
      
      private function onActionPickerNanovorRollOver(param1:ActionPickerEvent) : void
      {
         var _loc2_:InfoWindow = null;
         var _loc3_:ActionPickerEnemy = null;
         log("onActionPickerNanovorRollOver");
         if(param1.target as ActionPicker != _myPicker)
         {
            _loc2_ = _infoWindows[(param1.target as ActionPicker).player];
            _loc2_.hideAllButHealth(false);
         }
         if(Boolean(param1.target as ActionPickerEnemy))
         {
            _loc3_ = param1.target as ActionPickerEnemy;
            if(_loc3_.player.selectedNanovor == null && furthestState != STATE_ACTION_SELECTED)
            {
               return;
            }
            if(furthestState == STATE_EMPTY)
            {
               return;
            }
            if(furthestState != STATE_TARGET_SELECTED && furthestState != STATE_SWAP_SELECTED)
            {
               _loc3_.open();
               if(furthestState == STATE_ACTION_SELECTED)
               {
                  _loc3_.spotlight.openLight();
               }
               else
               {
                  _loc3_.spotlight.openLight(true);
               }
            }
         }
      }
      
      private function onTimerHitZero(param1:Event) : void
      {
         log("onTimerHitZero (AttackChooser timer timed out), going to forceSendAttack if all is well in BattleController",2);
         _footer.removeEventListener(AttackChooserFooter.TIMER_HIT_ZERO,onTimerHitZero);
         if(_control == null || _control.battleController == null || _control.myPlayer == null || _control.players == null)
         {
            logError("onTimerHitZero -- this should not happen if: (_control == null || _control.battleController == null || _control.myPlayer == null || _control.players == null)");
            return;
         }
         Managers.analyticsManager.trackAction(Action.BATTLE_ATTACKCHOOSER_CLOCK_ZERO);
         forceSendAttack();
      }
      
      public function bringIn() : Boolean
      {
         log("bringIn()",2);
         if(_bInView)
         {
            logError("bringIn called but _bInView==true!");
            return false;
         }
         _bInView = true;
         clearStates();
         visible = true;
         _bIsFirstRound = _control.battleController.currentRound == 0;
         if(_control.myPlayer.selectedNanovor != null && !_control.myPlayer.selectedNanovor.isDead)
         {
            log("bringIn: myPlayer.selectedNanovor=" + _control.myPlayer.selectedNanovor);
            selectNanovor(_control.myPlayer.selectedNanovor);
            goToNextStep();
         }
         else
         {
            log("bringIn: myPlayer.selectedNanovor is null OR is dead");
            _nanovorPicker.addEventListener(NanovorPicker.DISPLAY_UPDATED,onNanovorPickerDisplayUpdated,false,0,true);
            _nanovorPicker.addEventListener(NanovorPickerEvent.NANOVOR_ICON_SELECTED,onNanovorSelected,false,0,true);
            _nanovorPicker.updateSwarm(_bIsFirstRound);
         }
         _footer = new AttackChooserFooter();
         _footer.addEventListener(AttackChooserFooter.TIMER_HIT_ZERO,onTimerHitZero,false,0,true);
         _footer.x = FOOTER_X;
         _footer.y = FOOTER_Y_OUT;
         addChild(_footer);
         Tweener.addTween(_footer,{
            "y":FOOTER_Y_IN,
            "time":0.5,
            "transition":"easeOutQuad"
         });
         _footer.initTimer(_timeoutSeconds);
         _footer.startTimer();
         return true;
      }
      
      public function bringOut() : void
      {
         var _loc1_:ActionPickerEnemy = null;
         log("bringOut()",2);
         if(!_bInView)
         {
            logError("bringOut called but _bInView==false");
            return;
         }
         _bInView = false;
         _swapPicker.removeEventListener(SwapPicker.DISPLAY_BRING_OUT_COMPLETE,onSwapPickerBringOutComplete);
         _swapPicker.bringOut();
         for each(_loc1_ in _enemyPickers)
         {
            _loc1_.close();
            _loc1_.spotlight.close();
         }
         _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CLOSED,onBringOutTweenComplete,false,0,true);
         _myPicker.spotlight.close();
         _bMySpotlightOpen = false;
         _myPicker.close();
         _myPicker.clearDisplay();
         _myPicker.showConfirm = false;
         _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
         killSelectedSwapIcon();
         for each(_loc1_ in _enemyPickers)
         {
            _loc1_.showConfirm = false;
            _loc1_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
            _loc1_.spotlight.close();
            _loc1_.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onEnemySpotlightOpened);
         }
         if(Boolean(_footer))
         {
            removeChild(_footer);
            _footer.removeEventListener(AttackChooserFooter.TIMER_HIT_ZERO,onTimerHitZero);
            _footer.stopTimer();
            Tweener.addTween(_footer,{
               "y":"70",
               "time":0.5,
               "transition":"easeOutQuad"
            });
         }
      }
      
      private function startSelectedSwapIconMove() : void
      {
         if(_bSwapIconTweening)
         {
            killSelectedSwapIcon();
         }
         _bSwapIconTweening = true;
         Tweener.addTween(_swapNanovorIcon,{
            "x":NEXT_NANOVOR_POINT_X,
            "time":0.5,
            "transition":"easeInOutQuad",
            "onComplete":onSelectedSwapIconTween1Complete,
            "rounded":true
         });
      }
      
      private function updateInfoWindows() : void
      {
         var _loc1_:INanovor = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = int(_control.players.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = _control.players[_loc3_].selectedNanovor;
            _loc2_ = _aLastNanovorsSelectedUpdatedIDs[_loc3_];
            if(Boolean(_control.players[_loc3_].isDead) || Boolean(_control.players[_loc3_].leftGame))
            {
               updateInfoWindow(_infoWindows[_control.players[_loc3_]],null,_loc2_);
            }
            else
            {
               updateInfoWindow(_infoWindows[_control.players[_loc3_]],_loc1_,_loc2_);
            }
            _aLastNanovorsSelectedUpdatedIDs[_loc3_] = _loc1_ == null ? "0" : _loc1_.assetId;
            _loc3_++;
         }
      }
      
      private function onActionPickerNanovorClick(param1:ActionPickerEvent) : void
      {
         var _loc3_:ActionPickerEnemy = null;
         var _loc4_:ActionPickerEnemy = null;
         log("onActionPickerNanovorClick");
         var _loc2_:IWidget = Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name);
         if(null != _loc2_)
         {
            _loc2_.setMode(WidgetType.MODE_CLOSED);
         }
         if((_iState & STATE_SWAP_SELECTED) == STATE_SWAP_SELECTED)
         {
            if(_turnData.AttackData == null || Boolean(_turnData.AttackData.isSelfTarget))
            {
               _myPicker.showConfirm = false;
               _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
            }
            else
            {
               _loc3_ = param1.target as ActionPickerEnemy;
               _loc3_.showConfirm = false;
               _loc3_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
               _loc3_.spotlight.closeLight();
            }
            selectConfirm();
         }
         else if(_turnData.AttackData == null || Boolean(_turnData.AttackData.isSelfTarget))
         {
            _myPicker.confirmedSelectedAction(true);
            _myPicker.showConfirm = false;
            _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
            selectTarget(_myPicker.player.username);
         }
         else
         {
            _loc3_ = param1.target as ActionPickerEnemy;
            if(Boolean(_loc3_.player.isDead) || Boolean(_loc3_.player.leftGame))
            {
               return;
            }
            _myPicker.confirmedSelectedAction();
            _loc3_.close();
            for each(_loc4_ in _enemyPickers)
            {
               _loc4_.spotlight.closeLight();
               if(_loc4_ != _loc3_)
               {
                  _loc4_.spotlight.close();
               }
               _loc4_.showConfirm = false;
               _loc4_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
            }
            selectTarget(_loc3_.player.username);
         }
         goToNextStep();
      }
      
      private function clearReadyForBattleSpinner() : void
      {
         if(_readyForBattleSpinner == null)
         {
            return;
         }
         onClearReadyForBattleSpinnerTweenComplete();
      }
      
      private function onNanovorSelected(param1:NanovorPickerEvent) : void
      {
         log("onNanovorSelected: e.nanovorIcon.nanovor.assetId=" + param1.nanovorIcon.nanovor.assetId);
         var _loc2_:IWidget = Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name);
         if(null != _loc2_)
         {
            _loc2_.setMode(WidgetType.MODE_CLOSED);
         }
         _nanovorPicker.addEventListener(NanovorPicker.DISPLAY_BRING_OUT_COMPLETE,onNanovorPickerBringOutComplete,false,0,true);
         _nanovorPicker.bringOut();
         if(_bIsFirstRound)
         {
            _nanovorPicker.stopAttention();
            clearReadyForBattleSpinner();
         }
         selectNanovor(param1.nanovorIcon.nanovor);
         _myPicker.clearCharacter();
         updateInfoWindows();
         _control.battleController.roundController.chooseNanovor();
      }
      
      private function onSelectedSwapIconTween1Complete() : void
      {
         Tweener.addTween(_swapNanovorIcon,{
            "y":NEXT_NANOVOR_POINT_Y,
            "time":0.5,
            "transition":"easeInOutQuad",
            "onComplete":onSelectedSwapIconTween2Complete,
            "rounded":true
         });
      }
      
      private function onActionPickerAttackDeselected(param1:ActionSelectionEvent) : void
      {
         log("onActionPickerAttackDeselected");
         rollStateBackTo(STATE_MY_NANOVOR_SELECTED);
         goToNextStep();
      }
      
      private function onMySpotlightChaserDoubleEnd(param1:SpotlightEvent) : void
      {
         _myPicker.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserDoubleEnd);
         _myPicker.open();
      }
      
      private function onSelectedSwapIconTween2Complete() : void
      {
         _bSwapIconTweening = false;
      }
      
      public function get state() : int
      {
         return _iState;
      }
      
      private function addReadyForBattleSpinner() : void
      {
         if(_bIsFirstRound && _readyForBattleSpinner == null)
         {
            _readyForBattleSpinner = new ReadyForBattleSpinner();
            _readyForBattleSpinner.scaleX = _readyForBattleSpinner.scaleY = 0.63;
            _readyForBattleSpinner.x = 147;
            _readyForBattleSpinner.y = 227;
            addChild(_readyForBattleSpinner);
         }
      }
      
      public function updatePickers() : void
      {
         var _loc1_:ActionPickerEnemy = null;
         if(_bInView)
         {
            logError("updatePickers -- returning since _bInView=true!  NOTE: This check is here because FightEngine still sends an end-animation packet to the server even after bringing in a new nanovor");
            return;
         }
         _control.battleController.generateSwarmAttackPreviews();
         var _loc2_:int = 0;
         while(_loc2_ < _enemyPickers.length)
         {
            _loc1_ = _enemyPickers[_loc2_] as ActionPickerEnemy;
            if(_loc1_.player.selectedNanovor != null && !_loc1_.player.selectedNanovor.isDead)
            {
               _control.battleController.generateAttackPreviews(true,_loc1_.player);
            }
            if(Boolean(_loc1_.player.isDead) || Boolean(_loc1_.player.leftGame))
            {
               _loc1_.visible = false;
               _loc1_.mouseEnabled = false;
               _loc1_.mouseChildren = false;
            }
            _loc1_.updateSwarm();
            _loc2_++;
         }
         updateInfoWindows();
      }
      
      private function onMySpotlightOpened(param1:SpotlightEvent) : void
      {
         log("onMySpotlightOpened");
         _myPicker.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onMySpotlightOpened);
         if((_iState & STATE_MY_NANOVOR_SELECTED) != STATE_MY_NANOVOR_SELECTED)
         {
            _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_HALF_DONE,onMySpotlightChaserHalfDone,false,0,true);
         }
         else
         {
            _myPicker.spotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserEnd,false,0,true);
         }
         _myPicker.spotlight.chaserUp();
      }
      
      private function selectTarget(param1:String) : void
      {
         _turnData.TargetedPlayerName = param1;
         _iState |= STATE_TARGET_SELECTED;
      }
      
      private function selectSwap(param1:INanovor) : void
      {
         if(param1 != null)
         {
            _turnData.MyNextNanovorId = param1.assetId;
         }
         else
         {
            _turnData.MyNextNanovorId = "0";
         }
         _iState |= STATE_SWAP_SELECTED;
      }
      
      private function onKillSelectedSwapIconComplete() : void
      {
         if(Boolean(_swapNanovorIcon) && contains(_swapNanovorIcon))
         {
            try
            {
               removeChild(_swapNanovorIcon);
            }
            catch(e:Error)
            {
               logError("onKillSelectedSwapIconComplete: error trying to removeChild(_swapNanovorIcon): " + e.getStackTrace());
            }
         }
      }
      
      private function onActionPickerAttackSelected(param1:ActionSelectionEvent) : void
      {
         var _loc3_:ActionPickerEnemy = null;
         log("onActionPickerAttackSelected");
         var _loc2_:IWidget = Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name);
         if(null != _loc2_)
         {
            _loc2_.setMode(WidgetType.MODE_CLOSED);
         }
         _myPicker.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onMySpotlightChaserEnd);
         for each(_loc3_ in _enemyPickers)
         {
            _loc3_.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onEnemySpotlightOpened);
            _loc3_.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onEnemySpotlightChaserEnd);
         }
         rollStateBackTo(STATE_MY_NANOVOR_SELECTED);
         selectAction(_myNanovor.getAttackByAttackId(param1.ActionID));
         goToNextStep();
      }
      
      private function onNanovorPickerBringOutComplete(param1:Event) : void
      {
         _nanovorPicker.removeEventListener(NanovorPicker.DISPLAY_BRING_OUT_COMPLETE,onNanovorPickerBringOutComplete);
         goToNextStep();
      }
      
      private function onSwapSelected(param1:SwapPickerEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         log("onSwapSelected: e.type=" + param1.type);
         var _loc2_:IWidget = Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_CHAT.name);
         if(null != _loc2_)
         {
            _loc2_.setMode(WidgetType.MODE_CLOSED);
         }
         _swapPicker.addEventListener(SwapPicker.DISPLAY_BRING_OUT_COMPLETE,onSwapPickerBringOutComplete,false,0,true);
         _swapPicker.addEventListener(SwapPickerEvent.BUTTON_CLICK,onSwapPickerButtonClick,false,0,true);
         _swapPicker.bringInButtonState();
         if(param1.type == SwapPickerEvent.NANOVOR_ICON_SELECTED)
         {
            selectSwap(param1.nanovorIcon.nanovor);
            _swapNanovorIcon = param1.nanovorIcon;
            _loc3_ = _swapPicker.x + _swapPicker.SWARM_X + _swapNanovorIcon.x;
            _loc4_ = _swapPicker.y + _swapPicker.SWARM_Y + _swapNanovorIcon.y;
            this.addChild(_swapNanovorIcon);
            _swapNanovorIcon.x = _loc3_;
            _swapNanovorIcon.y = _loc4_;
            startSelectedSwapIconMove();
         }
         else
         {
            selectSwap(null);
         }
      }
      
      private function onNanovorPickerDisplayUpdated(param1:Event) : void
      {
         log("onNanovorPickerDisplayUpdated");
         _nanovorPicker.removeEventListener(NanovorPicker.DISPLAY_UPDATED,onNanovorPickerDisplayUpdated);
         _bNanovorPickerReady = true;
         goToNextStep();
      }
      
      private function clearStates() : void
      {
         _iState = STATE_EMPTY;
         _myNanovor = null;
         _turnData = new CombatTurnData();
      }
      
      private function onEnemySpotlightChaserEnd(param1:SpotlightEvent) : void
      {
         var _loc4_:ActionPickerEnemy = null;
         log("onEnemySpotlightChaserEnd");
         var _loc2_:Spotlight = param1.target as Spotlight;
         _loc2_.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onEnemySpotlightChaserEnd);
         var _loc3_:Boolean = Boolean((_iState & STATE_SWAP_SELECTED) == STATE_SWAP_SELECTED);
         if((_iState & STATE_ACTION_SELECTED) == STATE_ACTION_SELECTED)
         {
            log("going to go through each enemy\'s picker and set showconfirm = true");
            for each(_loc4_ in _enemyPickers)
            {
               log(" ... picker.player=" + _loc4_.player);
               if(!_loc4_.player.isDead && !_loc4_.player.leftGame)
               {
                  if(!(_loc3_ && _loc4_.player.username.toLowerCase() != _turnData.TargetedPlayerName.toLowerCase()))
                  {
                     _loc4_.showConfirm = true;
                     _loc4_.addEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick,false,0,true);
                  }
               }
            }
         }
      }
      
      public function get furthestState() : int
      {
         var _loc1_:int = _aStateSequence.length - 1;
         while(_loc1_ > -1)
         {
            if((_iState & _aStateSequence[_loc1_]) == _aStateSequence[_loc1_])
            {
               return _aStateSequence[_loc1_];
            }
            _loc1_--;
         }
         return 0;
      }
      
      private function updateInfoWindow(param1:InfoWindow, param2:INanovor, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:AttackStatement = null;
         log("updateInfoWindow: nanovor=" + param2);
         if(param2 != null)
         {
            log("  ...........: previousNanovorId=" + param3 + ", nanovor.assetId=" + param2.assetId);
            if(param2.assetId != param3)
            {
               param1.baseStrength = param2.baseStrength;
               param1.baseArmor = param2.baseArmor;
               param1.baseSpeed = param2.baseSpeed;
               param1.mcStats.buffedArmor = param2.baseHealth > param2.virmonMasterData.getBaseHealth();
               param1.mcStats.buffedSpeed = param2.baseSpeed > param2.virmonMasterData.getBaseSpeed();
               param1.mcStats.buffedStrength = param2.baseStrength > param2.virmonMasterData.getBaseStrength();
               param1.mcStats.mcHealthBar.buffedHealth = param2.baseHealth > param2.virmonMasterData.getBaseHealth();
            }
            param1.stats.updateHacks(param2.hacks);
            _loc4_ = "    %%%% HACK LOG %%%%% \n";
            _loc4_ += "   nanovor = " + param2 + "\n";
            if(param2.hacks.length > 0)
            {
               for each(_loc6_ in param2.hacks)
               {
                  _loc4_ += "      ++ hack = " + _loc6_ + "\n";
               }
            }
            else
            {
               _loc4_ += "      --- NO HACKS ---- ";
            }
            log(_loc4_,4);
            param1.visible = true;
            _loc5_ = "";
            switch(param2.faction)
            {
               case "Magnamod":
                  _loc5_ = InfoWindow.FAMILY_MAGNAMOD;
                  break;
               case "Velocitron":
                  _loc5_ = InfoWindow.FAMILY_VELOCITRON;
                  break;
               case "Hexite":
                  _loc5_ = InfoWindow.FAMILY_HEXITE;
            }
            param1.visible = true;
            param1.nanovorName = param2.name;
            param1.nanovorNickName = param2.safeNickName;
            param1.faction = _loc5_;
            param1.strength = param2.moddedStrength;
            param1.armor = param2.moddedArmor;
            param1.speed = param2.moddedSpeed;
            param1.setHealth(param2.health,param2.baseHealth);
            param1.mcStats.overrideArmor = param2.checkStatOverride(Stat.ARMOR);
            param1.mcStats.overrideSpeed = param2.checkStatOverride(Stat.SPEED);
            param1.mcStats.overrideStrength = param2.checkStatOverride(Stat.STRENGTH);
         }
         else
         {
            param1.visible = false;
         }
      }
      
      private function removeChildrenTweens(param1:DisplayObjectContainer) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_ = param1.getChildAt(_loc3_);
            if(Boolean(_loc2_ as DisplayObjectContainer))
            {
               removeChildrenTweens(_loc2_);
            }
            if(Boolean(_loc2_ as DisplayObject))
            {
               Tweener.removeTweens(_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function sendAttack() : void
      {
         var _loc2_:ActionPickerEnemy = null;
         var _loc3_:ActionPickerEnemy = null;
         log("@@@ sendAttack: ....roundController.superEndOfTurn=" + _control.battleController.roundController.superEndOfTurn,2);
         if(!_control.battleController.roundController.superEndOfTurn)
         {
            _tmrCheckAnimationReady = new Timer(ANIMATION_CHECK_READY_TIMER,1);
            _tmrCheckAnimationReady.addEventListener(TimerEvent.TIMER,onCheckAnimationReadyTimerTick,false,0,true);
            _tmrCheckAnimationReady.start();
            return;
         }
         var _loc1_:CombatTurnData = new CombatTurnData();
         if((_iState & STATE_MY_NANOVOR_SELECTED) != STATE_MY_NANOVOR_SELECTED)
         {
            logError("sendAttack: Could not auto-select the next nanovor  ** CRITICAL **");
            return;
         }
         _loc1_.MyActiveNanovorId = _turnData.MyActiveNanovorId;
         if((_iState & STATE_ACTION_SELECTED) == STATE_ACTION_SELECTED)
         {
            _loc1_.AttackId = _turnData.AttackId;
            _loc1_.AttackData = _turnData.AttackData;
         }
         else
         {
            _loc1_.AttackId = 0;
            _loc1_.AttackData = null;
         }
         if((_iState & STATE_TARGET_SELECTED) == STATE_TARGET_SELECTED)
         {
            _loc1_.TargetedPlayerName = _turnData.TargetedPlayerName;
         }
         else
         {
            if(_loc1_.AttackData == null || Boolean(_loc1_.AttackData.isSelfTarget))
            {
               _myPicker.showConfirm = false;
               _myPicker.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
            }
            else
            {
               for each(_loc2_ in _enemyPickers)
               {
                  _loc2_.spotlight.closeLight();
                  _loc2_.spotlight.close();
                  _loc2_.showConfirm = false;
                  _loc2_.removeEventListener(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,onActionPickerNanovorClick);
               }
            }
            _loc1_.AttackId = 0;
            _loc1_.AttackData = null;
            _loc1_.TargetedPlayerName = _control.myPlayer.username;
         }
         if((_iState & STATE_SWAP_SELECTED) == STATE_SWAP_SELECTED)
         {
            _loc1_.MyNextNanovorId = _turnData.MyNextNanovorId;
         }
         else
         {
            _loc1_.MyNextNanovorId = "0";
            _swapPicker.bringOut();
         }
         _turnData = _loc1_;
         _control.sendTurn(_turnData);
         for each(_loc3_ in _enemyPickers)
         {
            _loc3_.clearDisplay();
         }
      }
      
      private function rollStateBackTo(param1:int, param2:int = -1) : void
      {
         if(param2 < 0)
         {
            param2 = int(_aStateSequence.length);
         }
         param2--;
         if((_iState & _aStateSequence[param2]) == _aStateSequence[param2])
         {
            revertState(_aStateSequence[param2]);
         }
         if(_aStateSequence[param2] != param1)
         {
            rollStateBackTo(param1,param2);
         }
      }
      
      private function onMySpotlightChaserHalfDone(param1:SpotlightEvent) : void
      {
         log("onMySpotlightChaserHalfDone");
         _myPicker.spotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_HALF_DONE,onMySpotlightChaserHalfDone);
         if((_iState & STATE_MY_NANOVOR_SELECTED) != STATE_MY_NANOVOR_SELECTED)
         {
            addReadyForBattleSpinner();
            addChildAt(_nanovorPicker,numChildren);
            _nanovorPicker.y = NANOVOR_PICKER_POINT_Y;
            _nanovorPicker.x = _myPicker.spotlight.x;
            _nanovorPicker.bringIn();
            if(_bIsFirstRound)
            {
               _nanovorPicker.playAttention();
            }
         }
         else
         {
            addChildAt(_swapPicker,numChildren);
            _swapPicker.y = NANOVOR_PICKER_POINT_Y;
            _swapPicker.x = _myPicker.spotlight.x;
            _swapPicker.bringIn();
         }
      }
      
      private function onActionPickerNanovorRollOut(param1:ActionPickerEvent) : void
      {
         var _loc2_:InfoWindow = null;
         var _loc3_:ActionPickerEnemy = null;
         log("onActionPickerNanovorRollOut");
         if(param1.target as ActionPicker != _myPicker)
         {
            _loc2_ = _infoWindows[(param1.target as ActionPicker).player];
            _loc2_.hideAllButHealth(true);
         }
         if(Boolean(param1.target as ActionPickerEnemy))
         {
            if(furthestState == STATE_EMPTY)
            {
               return;
            }
            _loc3_ = param1.target as ActionPickerEnemy;
            if(furthestState != STATE_TARGET_SELECTED && furthestState != STATE_SWAP_SELECTED)
            {
               if(furthestState == STATE_ACTION_SELECTED)
               {
                  _loc3_.showActions = false;
               }
               else
               {
                  _loc3_.close();
               }
               _loc3_.spotlight.closeLight();
            }
         }
      }
   }
}

