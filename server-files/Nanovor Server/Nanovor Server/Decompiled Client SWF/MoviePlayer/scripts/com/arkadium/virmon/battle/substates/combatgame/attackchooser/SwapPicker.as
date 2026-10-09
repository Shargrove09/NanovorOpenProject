package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.NanovorPickerInfo;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.substates.combatgame.CombatUIController;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.icons.actions.ActionSwap;
   import com.arkadium.virmon.shared.final.components.actionslot.RolloutComponent;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class SwapPicker extends Sprite
   {
      
      public static const DISPLAY_UPDATED:String = "SwapPicker::displayUpdated";
      
      public static const DISPLAY_BRING_OUT_COMPLETE:String = "SwapPicker::displayBringOutComplete";
      
      public static const BACKGROUND_COLOR_BLUE:uint = 2340070;
      
      public static const BACKGROUND_COLOR_RED:uint = 16711680;
      
      public static const BACKGROUND_STATE_CLEAR:int = 50;
      
      public static const BACKGROUND_STATE_OPAQUE:int = 0;
      
      public static const BACKGROUND_STATE_SOLID:int = -50;
      
      private const POWER_RING_OFFSET_X:int = -274;
      
      private const POWER_RING_OFFSET_Y:int = -106;
      
      public var mcActionIcon:MovieClip;
      
      private var _swarmContainer:Sprite;
      
      private const SWARM_ICON_SPACING:int = 60;
      
      private const BACKGROUND_TWEEN_SECONDS:Number = 1;
      
      public var mcHit:MovieClip;
      
      private var _control:CombatUIController;
      
      private var _bInView:Boolean = false;
      
      private var _bNanovorNamesInView:Boolean = false;
      
      public const SWARM_X:int = 271;
      
      public const SWARM_Y:int = 0;
      
      private var _bPowerRingInView:Boolean = false;
      
      private const NO_SWAP_OPTION_OFFSET_X:int = -85;
      
      private var _nanovorInfo:NanovorPickerInfo;
      
      private const ICON_RETICLE_OUT_DELAY:Number = 0.1;
      
      public var mcBackground:MovieClip;
      
      private var _noSwapOption:SwapPickerNoSwap = null;
      
      private const POWER_RING_FADE_OUT_TIME:Number = 0.5;
      
      private var _aNanovorIcons:Array = new Array();
      
      private var _rollout:RolloutComponent;
      
      private var _bInited:Boolean = false;
      
      public var mcSwarmMask:MovieClip;
      
      private const ICON_RETICLE_IN_DELAY:Number = 0.5;
      
      private var _bButtonState:Boolean = false;
      
      private var _iSwarmLoadCounter:int = 0;
      
      public var mcLine:MovieClip;
      
      private const POWER_RING_FADE_IN_TIME:Number = 0.25;
      
      private const TIMER_MOUSE_OUT_DELAY:int = 500;
      
      private var _activeNanovor:INanovor = null;
      
      private const POWER_RING_MOVE_TIME:Number = 0.3;
      
      private var _spotlight:Spotlight;
      
      private const TIMER_ATTENTION_DELAY:int = 3000;
      
      private const NANOVOR_INFO_OFFSET_X:int = -207;
      
      private const NANOVOR_INFO_OFFSET_Y:int = -260;
      
      public var tfActionTitle:TextField;
      
      private var _tmrAttention:Timer;
      
      private var _bStepDescriptionInView:Boolean = false;
      
      public var tfActionDesc:TextField;
      
      private var _tmrMouseOut:Timer;
      
      public function SwapPicker(param1:CombatUIController, param2:Number = 1000)
      {
         _control = param1;
         super();
         mcHit.visible = false;
         this.color = BACKGROUND_COLOR_BLUE;
         this.backgroundState = BACKGROUND_STATE_CLEAR;
         mcLine.visible = false;
         var _loc3_:Sprite = new ActionSwap() as Sprite;
         mcActionIcon.addChild(_loc3_);
         _spotlight = new Spotlight();
         _spotlight.scaleX = _spotlight.scaleY = 0.25;
         _spotlight.open(false);
         this.addChild(_spotlight);
         _spotlight.visible = false;
         _spotlight.stop();
         _spotlight.alpha = 1;
         _spotlight.x = -POWER_RING_OFFSET_X;
         _spotlight.y = POWER_RING_OFFSET_Y;
         _tmrMouseOut = new Timer(TIMER_MOUSE_OUT_DELAY);
         _tmrMouseOut.addEventListener(TimerEvent.TIMER,onTimerMouseOutTick,false,0,true);
         _rollout = new RolloutComponent(180,param2);
         this.addChildAt(_rollout,0);
         tfActionTitle.text = "SWAP";
         tfActionDesc.text = "SELECT NEXT NANOVOR";
         tfActionTitle.cacheAsBitmap = true;
         tfActionDesc.cacheAsBitmap = true;
         tfActionDesc.alpha = 0;
         tfActionTitle.alpha = 0;
         _swarmContainer = new Sprite();
         _swarmContainer.x = SWARM_X;
         _swarmContainer.y = SWARM_Y;
         addChild(_swarmContainer);
         _noSwapOption = new SwapPickerNoSwap();
         _noSwapOption.x = NO_SWAP_OPTION_OFFSET_X;
         _noSwapOption.mcHit.addEventListener(MouseEvent.ROLL_OVER,onNoSwapRollOver,false,0,true);
         _noSwapOption.mcHit.addEventListener(MouseEvent.ROLL_OUT,onNoSwapRollOut,false,0,true);
         _noSwapOption.mcHit.addEventListener(MouseEvent.CLICK,onNoSwapClick,false,0,true);
         _noSwapOption.mcHit.buttonMode = true;
         _swarmContainer.addChild(_noSwapOption);
         mcSwarmMask.cacheAsBitmap = true;
         _swarmContainer.cacheAsBitmap = true;
         _swarmContainer.mask = mcSwarmMask;
         _nanovorInfo = new NanovorPickerInfo();
         _nanovorInfo.y = NANOVOR_INFO_OFFSET_Y;
         _nanovorInfo.visible = false;
         _nanovorInfo.addEventListener(NanovorPickerInfo.EVENT_CLOSED,onNanovorInfoClosed,false,0,true);
         addChild(_nanovorInfo);
      }
      
      private function onRolloutCloseTweenCompleted(param1:Event) : void
      {
         _rollout.removeEventListener(RolloutComponent.ROLLOUT_CLOSE_COMPLETED,onRolloutCloseTweenCompleted);
         if(!_bInView)
         {
            this.visible = false;
         }
      }
      
      private function loadNextNanovorIcon() : void
      {
         var _loc1_:NanovorIcon = new NanovorIcon();
         _loc1_.x = SWARM_ICON_SPACING * _iSwarmLoadCounter;
         _loc1_.addEventListener(NanovorIcon.ROLL_OVER,onNanovorIconRollOver,false,0,true);
         _loc1_.addEventListener(NanovorIcon.ROLL_OUT,onNanovorIconRollOut,false,0,true);
         _loc1_.addEventListener(NanovorIcon.SELECTED,onNanovorIconSelected,false,0,true);
         _aNanovorIcons.push(_loc1_);
         _swarmContainer.addChild(_loc1_);
         _loc1_.addEventListener(NanovorIcon.LOADED,onNanovorIconLoaded);
         var _loc2_:INanovor = _control.myPlayer.swarm[_iSwarmLoadCounter] == null ? null : _control.myPlayer.swarm[_iSwarmLoadCounter];
         _loc1_.initialize(_loc2_,true,false,Boolean(_loc2_ == _activeNanovor));
      }
      
      public function set backgroundState(param1:int) : void
      {
         Tweener.removeTweens(mcBackground,"y");
         switch(param1)
         {
            case BACKGROUND_STATE_CLEAR:
               Tweener.addTween(mcBackground,{
                  "y":BACKGROUND_STATE_CLEAR,
                  "time":BACKGROUND_TWEEN_SECONDS,
                  "rounded":true
               });
               break;
            case BACKGROUND_STATE_OPAQUE:
               Tweener.addTween(mcBackground,{
                  "y":BACKGROUND_STATE_OPAQUE,
                  "time":BACKGROUND_TWEEN_SECONDS,
                  "rounded":true
               });
               break;
            case BACKGROUND_STATE_SOLID:
               Tweener.addTween(mcBackground,{
                  "y":BACKGROUND_STATE_SOLID,
                  "time":BACKGROUND_TWEEN_SECONDS,
                  "rounded":true
               });
               break;
            default:
               return;
         }
      }
      
      private function onPowerRingTweenOutComplete() : void
      {
         _spotlight.visible = false;
         _spotlight.stop();
      }
      
      private function onMaskTweenComplete() : void
      {
      }
      
      private function onNanovorInfoClosed(param1:Event) : void
      {
         _nanovorInfo.visible = false;
         _nanovorInfo.clearNanovorSelection();
      }
      
      private function onNanovorIconSelected(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         log("onNanovorIconSelected: oNI.assetId=" + _loc2_.assetId);
         if(Boolean(_loc2_.nanovor.isDead) || _loc2_.nanovor == _activeNanovor)
         {
            return;
         }
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Attack_CharacterStats3",true,SoundManagerConst.soundApplicationDomain));
         _loc2_.bringOutReticle();
         var _loc3_:SwapPickerEvent = new SwapPickerEvent(SwapPickerEvent.NANOVOR_ICON_SELECTED,_loc2_);
         dispatchEvent(_loc3_);
      }
      
      private function bringInNanovorInfo(param1:NanovorIcon) : void
      {
         _nanovorInfo.visible = true;
         _nanovorInfo.setNanovor(param1.nanovor,Boolean(param1.nanovor == _activeNanovor));
         _nanovorInfo.open();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** SwapPicker: " + param1);
      }
      
      private function startMouseOutTimer() : void
      {
         _tmrMouseOut.reset();
         _tmrMouseOut.start();
      }
      
      private function stopAttentionTimers() : void
      {
         var _loc1_:NanovorIcon = null;
         if(Boolean(_tmrAttention))
         {
            _tmrAttention.removeEventListener(TimerEvent.TIMER,onAttentionTimerTick);
            _tmrAttention.stop();
            _tmrAttention = null;
         }
         for each(_loc1_ in _aNanovorIcons)
         {
            _loc1_.clearAttentionInTimer();
         }
         _noSwapOption.clearAttentionInTimer();
      }
      
      public function updateSwarm() : void
      {
         log("updateSwarm");
         updateDisplay();
         _bInited = true;
      }
      
      private function onNanovorIconRollOut(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         log("onNanovorIconRollOut: " + _loc2_.nanovor.name);
         if(!_loc2_.nanovor.isDead && _loc2_.nanovor != _activeNanovor)
         {
            _loc2_.bringOutReticle(ICON_RETICLE_OUT_DELAY);
         }
         startMouseOutTimer();
         startAttentionTimer();
      }
      
      private function bringInPowerRing() : void
      {
         if(_bPowerRingInView)
         {
            return;
         }
         _bPowerRingInView = true;
         Tweener.removeTweens(_spotlight,alpha);
         _spotlight.play();
         _spotlight.visible = true;
         Tweener.addTween(_spotlight,{
            "alpha":1,
            "time":POWER_RING_FADE_IN_TIME * (1 - _spotlight.alpha),
            "transition":"easeInOutQuad"
         });
      }
      
      private function bringInStepDescription() : void
      {
         if(_bStepDescriptionInView)
         {
            return;
         }
         _bStepDescriptionInView = true;
         Tweener.removeTweens(tfActionTitle,alpha);
         Tweener.removeTweens(tfActionDesc,alpha);
         Tweener.addTween(tfActionTitle,{
            "alpha":1,
            "time":0.3,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(tfActionDesc,{
            "alpha":1,
            "time":0.3,
            "delay":0.1,
            "transition":"easeOutQuad"
         });
      }
      
      private function onNanovorIconLoaded(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconLoaded);
         log("onNanovorIconLoaded: counter=" + _iSwarmLoadCounter + ", assetId=" + _control.myPlayer.swarm[_iSwarmLoadCounter].assetId + ", _control.myPlayer.swarm.length=" + _control.myPlayer.swarm.length);
         if(++_iSwarmLoadCounter >= _control.myPlayer.swarm.length)
         {
            onDisplayUpdated();
         }
         else
         {
            loadNextNanovorIcon();
         }
      }
      
      private function onHitRollOver(param1:MouseEvent) : void
      {
         backgroundState = BACKGROUND_STATE_SOLID;
      }
      
      private function onAttentionTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:NanovorIcon = null;
         if(_bInView && !_bButtonState)
         {
            _noSwapOption.startAttentionInTimer(0);
            _loc2_ = 1;
            for each(_loc3_ in _aNanovorIcons)
            {
               if(!_loc3_.nanovor.isDead && _loc3_.nanovor != _activeNanovor)
               {
                  _loc3_.startAttentionInTimer(_loc2_ * 275);
                  _loc2_++;
               }
            }
         }
      }
      
      private function bringOutActionIcon() : void
      {
         Tweener.removeTweens(mcActionIcon,"alpha");
         Tweener.addTween(mcActionIcon,{
            "alpha":0,
            "time":0.3,
            "delay":0.2,
            "transition":"easeOutQuad"
         });
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> SwapPicker: " + param1);
      }
      
      public function bringIn() : void
      {
         log("bringIn: _bInView=" + _bInView);
         if(_bInView && !_bButtonState)
         {
            return;
         }
         _bInView = true;
         this.visible = true;
         mcActionIcon.alpha = 1;
         if(!_bButtonState)
         {
            bringInStepDescription();
         }
         bringOutButtonState();
         _bNanovorNamesInView = false;
         Tweener.removeTweens(mcSwarmMask,"x");
         mcSwarmMask.x = RolloutComponent.CHASER_START_POSITION;
         _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onRolloutChaserTweenStarted,false,0,true);
         _rollout.open(false,0.4);
         startAttentionTimer();
      }
      
      private function onDisplayUpdated() : void
      {
         log("onDisplayUpdated (finished loading/updating swarm)");
         dispatchEvent(new Event(DISPLAY_UPDATED));
      }
      
      public function bringOut() : void
      {
         var _loc1_:NanovorIcon = null;
         log("bringOut: _bInView=" + _bInView);
         if(!_bInView)
         {
            return;
         }
         _bInView = false;
         if(!_bButtonState)
         {
            stopAttentionTimers();
            for each(_loc1_ in _aNanovorIcons)
            {
               _loc1_.disableHit();
            }
            bringOutPowerRing();
            bringOutNanovorInfo();
            _bNanovorNamesInView = true;
            Tweener.removeTweens(mcSwarmMask,"x");
            mcSwarmMask.x = RolloutComponent.CHASER_END_POSITION;
            _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onBringOutChaserTweenStarted,false,0,true);
            _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_COMPLETED,onBringOutChaserTweenCompleted,false,0,true);
            _rollout.startChaser(true);
         }
         else
         {
            _rollout.close(false,true);
         }
         bringOutButtonState();
         bringOutStepDescription();
         bringOutActionIcon();
      }
      
      private function onNoSwapRollOut(param1:MouseEvent) : void
      {
         log("onNoSwapRollOut");
         _noSwapOption.stopAttention();
         startAttentionTimer();
      }
      
      private function onNanovorIconUpdated(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconUpdated);
         log("onNanovorIconUpdated: counter=" + _iSwarmLoadCounter + ", _control.myPlayer.swarm.length=" + _control.myPlayer.swarm.length);
         if(++_iSwarmLoadCounter >= _control.myPlayer.swarm.length)
         {
            onDisplayUpdated();
         }
         else
         {
            updateNextNanovorIcon();
         }
      }
      
      private function onRolloutChaserTweenStarted(param1:Event) : void
      {
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onRolloutChaserTweenStarted);
         Tweener.addTween(mcSwarmMask,{
            "x":RolloutComponent.CHASER_END_POSITION,
            "time":RolloutComponent.CHASER_TWEEN_SECONDS,
            "transition":"linear",
            "onUpdate":onMaskTweenUpdate,
            "onComplete":onMaskTweenComplete
         });
      }
      
      private function onNanovorIconRollOver(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         log("onNanovorIconRollOver: " + _loc2_.nanovor.name);
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Attack_CharacterStats1",true,SoundManagerConst.soundApplicationDomain,true));
         stopMouseOutTimer();
         stopAttentionTimers();
         if(!_loc2_.nanovor.isDead && _loc2_.nanovor != _activeNanovor)
         {
            _loc2_.clearAttentionOutTimer();
            _loc2_.bringInReticle(ICON_RETICLE_IN_DELAY);
         }
         bringInPowerRing();
         Tweener.addTween(_spotlight,{
            "x":_loc2_.x - POWER_RING_OFFSET_X,
            "time":POWER_RING_FADE_IN_TIME,
            "transition":"easeInOutQuad"
         });
         bringInNanovorInfo(_loc2_);
         _nanovorInfo.x = _loc2_.x - NANOVOR_INFO_OFFSET_X;
      }
      
      private function stopMouseOutTimer() : void
      {
         _tmrMouseOut.stop();
      }
      
      private function onTimerMouseOutTick(param1:TimerEvent) : void
      {
         stopMouseOutTimer();
         bringOutPowerRing();
         _nanovorInfo.close();
      }
      
      public function set activeNanovor(param1:INanovor) : void
      {
         if(_activeNanovor != null)
         {
         }
         _activeNanovor = param1;
         log("set _activeNanovor = " + param1);
      }
      
      private function onBringOutChaserTweenCompleted(param1:Event) : void
      {
         _rollout.addEventListener(RolloutComponent.ROLLOUT_CLOSE_COMPLETED,onRolloutCloseTweenCompleted,false,0,true);
         _rollout.stayOpen = false;
         if(!_bInView)
         {
            _rollout.close(false,true);
         }
         else
         {
            _rollout.close();
         }
         dispatchEvent(new Event(DISPLAY_BRING_OUT_COMPLETE));
      }
      
      public function bringOutButtonState() : void
      {
         if(!_bButtonState)
         {
            return;
         }
         _bButtonState = false;
         backgroundState = BACKGROUND_STATE_CLEAR;
         mcHit.buttonMode = false;
         mcHit.visible = false;
         mcHit.removeEventListener(MouseEvent.ROLL_OVER,onHitRollOver);
         mcHit.removeEventListener(MouseEvent.ROLL_OUT,onHitRollOut);
         mcHit.removeEventListener(MouseEvent.CLICK,onHitClick);
      }
      
      private function bringOutStepDescription() : void
      {
         if(!_bStepDescriptionInView)
         {
            return;
         }
         _bStepDescriptionInView = false;
         Tweener.removeTweens(tfActionTitle,alpha);
         Tweener.removeTweens(tfActionDesc,alpha);
         Tweener.addTween(tfActionTitle,{
            "alpha":0,
            "time":0.3,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(tfActionDesc,{
            "alpha":0,
            "time":0.3,
            "delay":0.1,
            "transition":"easeOutQuad"
         });
      }
      
      private function onNoSwapClick(param1:MouseEvent) : void
      {
         log("onNoSwapClick");
         var _loc2_:SwapPickerEvent = new SwapPickerEvent(SwapPickerEvent.NO_SWAP_SELECTED,null);
         dispatchEvent(_loc2_);
      }
      
      private function onMaskTweenUpdate(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:NanovorIcon = null;
         if(!param1)
         {
            if(!_bNanovorNamesInView && mcSwarmMask.x - RolloutComponent.CHASER_START_POSITION >= (RolloutComponent.CHASER_END_POSITION - RolloutComponent.CHASER_START_POSITION) / 2)
            {
               _bNanovorNamesInView = true;
               _loc2_ = 0;
               while(_loc2_ < _aNanovorIcons.length)
               {
                  _loc3_ = _aNanovorIcons[_loc2_];
                  _loc3_.bringInName(_loc2_ * 0.05);
                  _loc2_++;
               }
            }
         }
         else if(_bNanovorNamesInView && mcSwarmMask.x - RolloutComponent.CHASER_START_POSITION <= (RolloutComponent.CHASER_END_POSITION - RolloutComponent.CHASER_START_POSITION) / 2)
         {
            _bNanovorNamesInView = false;
            _loc2_ = _aNanovorIcons.length - 1;
            while(_loc2_ > -1)
            {
               _loc3_ = _aNanovorIcons[_loc2_];
               _loc3_.bringOutName(_loc2_ * 0.05);
               _loc2_--;
            }
         }
      }
      
      public function bringInButtonState() : void
      {
         var _loc1_:NanovorIcon = null;
         log("bringToButtonState: _bInView=" + _bInView + " _bButtonState=" + _bButtonState);
         if(_bInView && _bButtonState)
         {
            return;
         }
         _bButtonState = true;
         if(_bInView)
         {
            _rollout.close();
            bringOutPowerRing();
            bringOutNanovorInfo();
            _bNanovorNamesInView = true;
            Tweener.removeTweens(mcSwarmMask,"x");
            mcSwarmMask.x = RolloutComponent.CHASER_END_POSITION;
            _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onBringOutChaserTweenStarted,false,0,true);
            _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_COMPLETED,onBringOutChaserTweenCompleted,false,0,true);
            _rollout.startChaser(true);
            for each(_loc1_ in _aNanovorIcons)
            {
               _loc1_.disableHit();
            }
         }
         else
         {
            _bInView = true;
            this.visible = true;
            mcActionIcon.alpha = 1;
            bringInStepDescription();
         }
         backgroundState = BACKGROUND_STATE_OPAQUE;
         mcHit.visible = true;
         mcHit.buttonMode = true;
         mcHit.addEventListener(MouseEvent.ROLL_OVER,onHitRollOver,false,0,true);
         mcHit.addEventListener(MouseEvent.ROLL_OUT,onHitRollOut,false,0,true);
         mcHit.addEventListener(MouseEvent.CLICK,onHitClick,false,0,true);
      }
      
      private function onHitClick(param1:MouseEvent) : void
      {
         dispatchEvent(new SwapPickerEvent(SwapPickerEvent.BUTTON_CLICK,null));
      }
      
      private function onBringOutChaserTweenStarted(param1:Event) : void
      {
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onBringOutChaserTweenStarted);
         Tweener.addTween(mcSwarmMask,{
            "x":RolloutComponent.CHASER_START_POSITION,
            "time":RolloutComponent.CHASER_TWEEN_SECONDS,
            "transition":"linear",
            "onUpdateParams":[true],
            "onUpdate":onMaskTweenUpdate,
            "onComplete":onMaskTweenComplete
         });
      }
      
      private function onHitRollOut(param1:MouseEvent) : void
      {
         backgroundState = BACKGROUND_STATE_OPAQUE;
      }
      
      public function get activeNanovor() : INanovor
      {
         return _activeNanovor;
      }
      
      private function onNoSwapRollOver(param1:MouseEvent) : void
      {
         log("onNoSwapRollOver");
         stopAttentionTimers();
         _noSwapOption.clearAttentionOutTimer();
         _noSwapOption.playAttention();
      }
      
      private function startAttentionTimer() : void
      {
         if(Boolean(_tmrAttention))
         {
            stopAttentionTimers();
         }
         _tmrAttention = new Timer(TIMER_ATTENTION_DELAY);
         _tmrAttention.addEventListener(TimerEvent.TIMER,onAttentionTimerTick,false,0,true);
         _tmrAttention.start();
      }
      
      private function updateDisplay() : void
      {
         log("updateDisplay: _bInited=" + _bInited);
         _iSwarmLoadCounter = 0;
         if(!_bInited)
         {
            loadNextNanovorIcon();
         }
         else
         {
            updateNextNanovorIcon();
         }
      }
      
      private function bringOutPowerRing() : void
      {
         if(!_bPowerRingInView)
         {
            return;
         }
         _bPowerRingInView = false;
         Tweener.removeTweens(_spotlight,alpha);
         Tweener.addTween(_spotlight,{
            "alpha":0,
            "time":POWER_RING_FADE_OUT_TIME,
            "transition":"easeOutQuad",
            "onComplete":onPowerRingTweenOutComplete
         });
      }
      
      private function updateNextNanovorIcon() : void
      {
         var _loc1_:NanovorIcon = _aNanovorIcons[_iSwarmLoadCounter];
         Tweener.removeTweens(_loc1_);
         _swarmContainer.addChild(_loc1_);
         _loc1_.alpha = 1;
         _loc1_.x = SWARM_ICON_SPACING * _iSwarmLoadCounter;
         _loc1_.y = 0;
         _loc1_.addEventListener(NanovorIcon.LOADED,onNanovorIconUpdated);
         _loc1_.updateDisplay(Boolean(_loc1_.nanovor == _activeNanovor));
         _loc1_.enableHit();
      }
      
      private function set color(param1:uint) : void
      {
         Tweener.removeTweens(mcBackground,"_color");
         Tweener.removeTweens(mcLine,"_color");
         Tweener.addTween(mcBackground,{
            "_color":param1,
            "time":0
         });
         Tweener.addTween(mcLine,{
            "_color":param1,
            "time":0
         });
      }
      
      public function destroy() : void
      {
         var _loc2_:NanovorIcon = null;
         _tmrMouseOut.removeEventListener(TimerEvent.TIMER,onTimerMouseOutTick);
         if(_tmrAttention != null)
         {
            _tmrAttention.removeEventListener(TimerEvent.TIMER,onAttentionTimerTick);
         }
         _noSwapOption.mcHit.removeEventListener(MouseEvent.ROLL_OVER,onNoSwapRollOver);
         _noSwapOption.mcHit.removeEventListener(MouseEvent.ROLL_OUT,onNoSwapRollOut);
         _noSwapOption.mcHit.removeEventListener(MouseEvent.CLICK,onNoSwapClick);
         _nanovorInfo.removeEventListener(NanovorPickerInfo.EVENT_CLOSED,onNanovorInfoClosed);
         mcHit.removeEventListener(MouseEvent.ROLL_OVER,onHitRollOver);
         mcHit.removeEventListener(MouseEvent.ROLL_OUT,onHitRollOut);
         mcHit.removeEventListener(MouseEvent.CLICK,onHitClick);
         _rollout.removeEventListener(RolloutComponent.ROLLOUT_CLOSE_COMPLETED,onRolloutCloseTweenCompleted);
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onBringOutChaserTweenStarted);
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_COMPLETED,onBringOutChaserTweenCompleted);
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onRolloutChaserTweenStarted);
         var _loc1_:int = 0;
         while(_loc1_ < _aNanovorIcons.length)
         {
            _loc2_ = _aNanovorIcons[_loc1_];
            _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconUpdated);
            _loc2_.removeEventListener(NanovorIcon.ROLL_OVER,onNanovorIconRollOver);
            _loc2_.removeEventListener(NanovorIcon.ROLL_OUT,onNanovorIconRollOut);
            _loc2_.removeEventListener(NanovorIcon.SELECTED,onNanovorIconSelected);
            _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconLoaded);
            _loc1_++;
         }
         _nanovorInfo.destroy();
      }
      
      private function bringOutNanovorInfo() : void
      {
         _nanovorInfo.close();
      }
   }
}

