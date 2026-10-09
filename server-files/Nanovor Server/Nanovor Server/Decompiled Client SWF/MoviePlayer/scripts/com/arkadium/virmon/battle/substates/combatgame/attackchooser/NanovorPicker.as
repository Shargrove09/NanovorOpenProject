package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.NanovorPickerInfo;
   import com.arkadium.virmon.battle.substates.combatgame.CombatUIController;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.final.components.actionslot.RolloutComponent;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class NanovorPicker extends Sprite
   {
      
      public static const DISPLAY_UPDATED:String = "NanovorPicker::displayUpdated";
      
      public static const DISPLAY_BRING_OUT_COMPLETE:String = "NanovorPicker::displayBringOutComplete";
      
      private const POWER_RING_OFFSET_X:int = -274;
      
      private const NANOVOR_INFO_OFFSET_Y:int = -260;
      
      private var _swarmContainer:Sprite;
      
      private const POWER_RING_OFFSET_Y:int = -106;
      
      private var _rollout:RolloutComponent;
      
      public var mcSwarmMask:MovieClip;
      
      private var _bInited:Boolean = false;
      
      private const ICON_RETICLE_IN_DELAY:Number = 0.5;
      
      private var _control:CombatUIController;
      
      public var mcSelectFirstNanovor:MovieClip;
      
      private var _iSwarmLoadCounter:int = 0;
      
      public var mcLine:MovieClip;
      
      private var _bNanovorNamesInView:Boolean = false;
      
      private const SWARM_X:int = 271;
      
      private const SWARM_Y:int = 0;
      
      private const POWER_RING_FADE_IN_TIME:Number = 0.25;
      
      private var _nanovorInfo:NanovorPickerInfo;
      
      private const TIMER_MOUSE_OUT_DELAY:int = 350;
      
      private var _bPowerRingInView:Boolean = false;
      
      private const POWER_RING_MOVE_TIME:Number = 0.3;
      
      private var _spotlight:Spotlight;
      
      private const ICON_RETICLE_OUT_DELAY:Number = 0.1;
      
      private const NANOVOR_INFO_OFFSET_X:int = -207;
      
      private var _tmrMouseOut:Timer;
      
      private const POWER_RING_FADE_OUT_TIME:Number = 0.5;
      
      public var tfActionTitle:TextField;
      
      private var _bStepDescriptionInView:Boolean = false;
      
      public var tfActionDesc:TextField;
      
      private const SWARM_ICON_SPACING:int = 60;
      
      private var _aNanovorIcons:Array = new Array();
      
      public function NanovorPicker(param1:CombatUIController, param2:Number = 1000)
      {
         _control = param1;
         super();
         mcLine.visible = false;
         _spotlight = new Spotlight();
         _spotlight.scaleX = _spotlight.scaleY = 0.25;
         _spotlight.open(false);
         _spotlight.visible = false;
         _spotlight.stop();
         _spotlight.alpha = 1;
         _spotlight.x = -POWER_RING_OFFSET_X;
         _spotlight.y = POWER_RING_OFFSET_Y;
         this.addChild(_spotlight);
         _tmrMouseOut = new Timer(TIMER_MOUSE_OUT_DELAY);
         _tmrMouseOut.addEventListener(TimerEvent.TIMER,onTimerMouseOutTick,false,0,true);
         _rollout = new RolloutComponent(0,param2);
         this.addChildAt(_rollout,0);
         tfActionTitle.text = "SELECT";
         tfActionDesc.text = "";
         tfActionTitle.cacheAsBitmap = true;
         tfActionDesc.cacheAsBitmap = true;
         tfActionDesc.alpha = 0;
         tfActionTitle.alpha = 0;
         _swarmContainer = new Sprite();
         _swarmContainer.x = SWARM_X;
         _swarmContainer.y = SWARM_Y;
         addChild(_swarmContainer);
         mcSwarmMask.cacheAsBitmap = true;
         _swarmContainer.cacheAsBitmap = true;
         _swarmContainer.mask = mcSwarmMask;
         _nanovorInfo = new NanovorPickerInfo();
         _nanovorInfo.y = NANOVOR_INFO_OFFSET_Y;
         _nanovorInfo.visible = false;
         _nanovorInfo.addEventListener(NanovorPickerInfo.EVENT_CLOSED,onNanovorInfoClosed,false,0,true);
         addChild(_nanovorInfo);
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
         _loc1_.initialize(_control.myPlayer.swarm[_iSwarmLoadCounter]);
      }
      
      private function onRolloutCloseTweenCompleted(param1:Event) : void
      {
         _rollout.removeEventListener(RolloutComponent.ROLLOUT_CLOSE_COMPLETED,onRolloutCloseTweenCompleted);
         this.visible = false;
      }
      
      private function bringOutNanovorInfo() : void
      {
         _nanovorInfo.close();
      }
      
      private function onNanovorIconRollOver(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Attack_CharacterStats1",true,SoundManagerConst.soundApplicationDomain,true));
         stopMouseOutTimer();
         if(!_loc2_.nanovor.isDead)
         {
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
      
      private function onMaskTweenComplete() : void
      {
         log("onMaskTweenComplete: mcSwarmMask.x=" + mcSwarmMask.x + ", _aNanovorIcons.length=" + _aNanovorIcons.length);
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
      
      private function onNanovorInfoClosed(param1:Event) : void
      {
         _nanovorInfo.visible = false;
         _nanovorInfo.clearNanovorSelection();
      }
      
      private function onNanovorIconSelected(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         log("onNanovorIconSelected: oNI.assetId=" + _loc2_.assetId);
         if(_loc2_.nanovor.isDead)
         {
            return;
         }
         Managers.soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Attack_CharacterStats3",true,SoundManagerConst.soundApplicationDomain,true));
         _loc2_.bringOutReticle();
         var _loc3_:NanovorPickerEvent = new NanovorPickerEvent(NanovorPickerEvent.NANOVOR_ICON_SELECTED,_loc2_);
         dispatchEvent(_loc3_);
      }
      
      private function bringInNanovorInfo(param1:NanovorIcon) : void
      {
         _nanovorInfo.visible = true;
         _nanovorInfo.setNanovor(param1.nanovor);
         _nanovorInfo.open();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorPicker: " + param1);
      }
      
      private function onTimerMouseOutTick(param1:TimerEvent) : void
      {
         stopMouseOutTimer();
         bringOutPowerRing();
         _nanovorInfo.close();
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
      
      public function updateSwarm(param1:Boolean = false) : void
      {
         tfActionDesc.text = param1 ? "SELECT FIRST NANOVOR" : "SELECT NEXT NANOVOR";
         updateDisplay();
         _bInited = true;
      }
      
      private function onBringOutChaserTweenStarted(param1:Event) : void
      {
         log("onBringOutChaserTweenStarted: mcSwarmMask.x=" + mcSwarmMask.x);
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
      
      private function onPowerRingTweenOutComplete() : void
      {
         _spotlight.visible = false;
         _spotlight.stop();
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
      
      private function onNanovorIconRollOut(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         if(!_loc2_.nanovor.isDead)
         {
            _loc2_.bringOutReticle(ICON_RETICLE_OUT_DELAY);
         }
         startMouseOutTimer();
      }
      
      private function onNanovorIconLoaded(param1:Event) : void
      {
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconLoaded);
         log("onNanovorIconLoaded: counter=" + _iSwarmLoadCounter + ", _control.myPlayer.swarm.length=" + _control.myPlayer.swarm.length);
         if(++_iSwarmLoadCounter >= _control.myPlayer.swarm.length)
         {
            onDisplayUpdated();
         }
         else
         {
            loadNextNanovorIcon();
         }
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
      
      private function startMouseOutTimer() : void
      {
         _tmrMouseOut.reset();
         _tmrMouseOut.start();
      }
      
      private function updateNextNanovorIcon() : void
      {
         var _loc1_:NanovorIcon = _aNanovorIcons[_iSwarmLoadCounter];
         _loc1_.addEventListener(NanovorIcon.LOADED,onNanovorIconUpdated);
         _loc1_.updateDisplay();
         _loc1_.enableHit();
      }
      
      public function playAttention() : void
      {
         mcSelectFirstNanovor.alpha = 0;
         mcSelectFirstNanovor.visible = true;
         Tweener.addTween(mcSelectFirstNanovor,{
            "alpha":1,
            "delay":1,
            "time":0.5,
            "transition":"easeInBounce"
         });
         Tweener.addTween(mcSelectFirstNanovor.mcChaser,{
            "x":-129,
            "delay":1.6,
            "time":0.5,
            "transition":"linear",
            "onComplete":function():*
            {
               mcSelectFirstNanovor.mcChaser.x = 451;
            }
         });
         Tweener.addTween(mcSelectFirstNanovor.mcChaser,{
            "x":-129,
            "delay":2.8,
            "time":0.5,
            "transition":"linear",
            "onComplete":function():*
            {
               mcSelectFirstNanovor.mcChaser.x = 451;
            }
         });
      }
      
      public function stopAttention() : void
      {
         Tweener.removeTweens(mcSelectFirstNanovor,"alpha");
         Tweener.addTween(mcSelectFirstNanovor,{
            "alpha":0,
            "time":0.4,
            "transition":"easeOutBounce",
            "onComplete":function():*
            {
               mcSelectFirstNanovor.visible = false;
            }
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
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorPicker: " + param1);
      }
      
      public function bringIn() : void
      {
         this.visible = true;
         bringInStepDescription();
         _bNanovorNamesInView = false;
         Tweener.removeTweens(mcSwarmMask,x);
         mcSwarmMask.x = RolloutComponent.CHASER_START_POSITION;
         _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onRolloutChaserTweenStarted,false,0,true);
         _rollout.open(false,0.4);
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
      
      private function stopMouseOutTimer() : void
      {
         _tmrMouseOut.stop();
      }
      
      private function onDisplayUpdated() : void
      {
         dispatchEvent(new Event(DISPLAY_UPDATED));
      }
      
      public function bringOut() : void
      {
         var _loc1_:NanovorIcon = null;
         for each(_loc1_ in _aNanovorIcons)
         {
            _loc1_.disableHit();
         }
         bringOutPowerRing();
         bringOutNanovorInfo();
         bringOutStepDescription();
         _bNanovorNamesInView = true;
         Tweener.removeTweens(mcSwarmMask,x);
         mcSwarmMask.x = RolloutComponent.CHASER_END_POSITION;
         _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onBringOutChaserTweenStarted,false,0,true);
         _rollout.addEventListener(RolloutComponent.CHASER_TWEEN_COMPLETED,onBringOutChaserTweenCompleted,false,0,true);
         _rollout.startChaser(true);
      }
      
      public function destroy() : void
      {
         var _loc2_:NanovorIcon = null;
         var _loc1_:int = 0;
         while(_loc1_ < _aNanovorIcons.length)
         {
            _loc2_ = _aNanovorIcons[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconLoaded);
               _loc2_.removeEventListener(NanovorIcon.LOADED,onNanovorIconUpdated);
               _loc2_.removeEventListener(NanovorIcon.ROLL_OVER,onNanovorIconRollOver);
               _loc2_.removeEventListener(NanovorIcon.ROLL_OUT,onNanovorIconRollOut);
               _loc2_.removeEventListener(NanovorIcon.SELECTED,onNanovorIconSelected);
            }
            _loc1_++;
         }
         _tmrMouseOut.removeEventListener(TimerEvent.TIMER,onTimerMouseOutTick);
         _nanovorInfo.removeEventListener(NanovorPickerInfo.EVENT_CLOSED,onNanovorInfoClosed);
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onRolloutChaserTweenStarted);
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onBringOutChaserTweenStarted);
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_COMPLETED,onBringOutChaserTweenCompleted);
         _rollout.removeEventListener(RolloutComponent.ROLLOUT_CLOSE_COMPLETED,onRolloutCloseTweenCompleted);
         _nanovorInfo.destroy();
      }
      
      private function onRolloutChaserTweenStarted(param1:Event) : void
      {
         log("onRolloutChaserTweenStarted: mcSwarmMask.x=" + mcSwarmMask.x);
         _rollout.removeEventListener(RolloutComponent.CHASER_TWEEN_STARTED,onRolloutChaserTweenStarted);
         Tweener.addTween(mcSwarmMask,{
            "x":RolloutComponent.CHASER_END_POSITION,
            "time":RolloutComponent.CHASER_TWEEN_SECONDS,
            "transition":"linear",
            "onUpdate":onMaskTweenUpdate,
            "onComplete":onMaskTweenComplete
         });
      }
      
      public function initAttention() : void
      {
         mcSelectFirstNanovor.mcChaserMask.cacheAsBitmap = true;
         mcSelectFirstNanovor.mcChaser.cacheAsBitmap = true;
         mcSelectFirstNanovor.mcChaser.mask = mcSelectFirstNanovor.mcChaserMask;
         mcSelectFirstNanovor.mcChaser.x = 451;
         mcSelectFirstNanovor.visible = false;
         mcSelectFirstNanovor.alpha = 0;
      }
      
      private function onBringOutChaserTweenCompleted(param1:Event) : void
      {
         _rollout.addEventListener(RolloutComponent.ROLLOUT_CLOSE_COMPLETED,onRolloutCloseTweenCompleted,false,0,true);
         _rollout.stayOpen = false;
         _rollout.close();
         dispatchEvent(new Event(DISPLAY_BRING_OUT_COMPLETE));
      }
   }
}

