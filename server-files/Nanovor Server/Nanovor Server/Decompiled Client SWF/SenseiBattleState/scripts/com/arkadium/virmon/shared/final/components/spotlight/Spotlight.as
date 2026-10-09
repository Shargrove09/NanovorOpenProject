package com.arkadium.virmon.shared.final.components.spotlight
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.events.SpotlightEvent;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.AdjustColor;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   
   public class Spotlight extends MovieClip
   {
      
      private static var _soundManager:ISoundManager;
      
      public static const RING_COLOR_RED:uint = 13369344;
      
      public static const RING_COLOR_BLUE:uint = 0;
      
      public static const RING_COLOR_YELLOW:uint = 16750848;
      
      public static const RING_COLOR_GREEN:uint = 9288235;
      
      public static const RING_UP:String = "up";
      
      public static const RING_MOUSE_OVER:String = "mouse over";
      
      public static const RING_SELECTED:String = "selected";
      
      public static const CHASER_MASK_INIT:String = "init";
      
      public static const CHASER_MASK_SELECT_NANOVOR:String = "selectNanovor";
      
      public static const CHASER_MASK_SELECT_ATTACK:String = "selectAttack";
      
      public static const CHASER_MASK_SELECT_TARGET:String = "selectTarget";
      
      public static const CHASER_MASK_SELECT_SWAP:String = "selectSwap";
      
      public static const CHASER_MASK_SELECT_SWAP_FROM_TOP:String = "selectSwapFromTop";
      
      public static const MESSAGE_SELECT_ATTACK:String = "mcMessageSelectAttack";
      
      private static const FADE_TIME_SECONDS:Number = 0.4;
      
      private static const LIGHT_OPENING:String = "Opening";
      
      private static const LIGHT_OPENED:String = "Opened";
      
      private static const CHASER_START_Y:int = 620;
      
      private static const CHASER_END_Y:int = 0;
      
      private static const CHASER_TWEEN_Y_SECONDS:Number = 0.5;
      
      private static const SPOTLIGHT_STATE_OPENING:String = "opening";
      
      private static const SPOTLIGHT_STATE_OPENED:String = "opened";
      
      private static const SPOTLIGHT_STATE_CLOSING:String = "closing";
      
      private static const SPOTLIGHT_STATE_CLOSED:String = "closed";
      
      private static const LIGHT_STATE_OPENING:String = "opening";
      
      private static const LIGHT_STATE_OPENED:String = "opened";
      
      private static const LIGHT_STATE_CLOSING:String = "closing";
      
      private static const LIGHT_STATE_CLOSED:String = "closed";
      
      private var _lightState:String;
      
      public var mcChaserMask:MovieClip;
      
      public var mcMessageSelectAttack:MovieClip;
      
      public var mcLight:MovieClip;
      
      public var mcRing:MovieClip;
      
      private var _chaser_mask_frame_label:String = "init";
      
      public var mcChaserNest:MovieClip;
      
      private var _bDispatchedChaserHalfDone:Boolean = false;
      
      private var _spotlightState:String;
      
      public function Spotlight()
      {
         super();
         mcChaser.alpha = 0.75;
         this.alpha = 0;
         mcMessageSelectAttack.alpha = 0;
         mcMessageSelectAttack.visible = false;
      }
      
      public static function initialize(param1:ISoundManager) : void
      {
         _soundManager = param1;
      }
      
      public function resetChaser() : void
      {
         Tweener.removeTweens(mcChaser,"y");
         if(mcChaser.scaleY == 1)
         {
            mcChaser.y = CHASER_START_Y;
            mcChaser.scaleY = 1;
         }
         else
         {
            mcChaser.scaleY = -1;
            mcChaser.y = CHASER_END_Y;
         }
         mcChaser.alpha = 1;
      }
      
      private function onClosed() : void
      {
         _spotlightState = SPOTLIGHT_STATE_CLOSED;
         dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_CLOSED,this));
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> Spotlight: " + param1);
      }
      
      public function close() : void
      {
         closeLight();
         _spotlightState = SPOTLIGHT_STATE_CLOSING;
         Tweener.removeTweens(this,"alpha");
         Tweener.addTween(this,{
            "alpha":0,
            "time":FADE_TIME_SECONDS,
            "onComplete":onClosed
         });
      }
      
      public function killChasers() : void
      {
         Tweener.addTween(mcChaser,{
            "alpha":0,
            "time":FADE_TIME_SECONDS,
            "onComplete":onChasersKilled
         });
      }
      
      public function open(param1:Boolean = true, param2:Number = 0) : void
      {
         mcRing.visible = true;
         if(_spotlightState == SPOTLIGHT_STATE_OPENED)
         {
            dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_OPENED,this));
            return;
         }
         if(_spotlightState == SPOTLIGHT_STATE_OPENING)
         {
            return;
         }
         if(param1)
         {
            openLight();
         }
         else
         {
            mcLight.visible = false;
            if(_lightState == LIGHT_STATE_OPENED)
            {
               closeLight();
            }
         }
         _spotlightState = SPOTLIGHT_STATE_OPENING;
         resetChaser();
         Tweener.removeTweens(this,"alpha");
         Tweener.addTween(this,{
            "alpha":1,
            "delay":param2,
            "time":FADE_TIME_SECONDS,
            "onComplete":onOpened
         });
      }
      
      public function chaserDown(param1:Number = 0) : void
      {
         chaserDirectionUp(false,param1);
      }
      
      public function setRingState(param1:String = "ringUp") : void
      {
      }
      
      private function onLightOpened() : void
      {
         _lightState = LIGHT_STATE_OPENED;
         dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_LIGHT_OPENED,this));
      }
      
      public function showMessage(param1:String, param2:Number = 0, param3:Number = 0.2, param4:Number = 1, param5:Number = 0.2, param6:String = "easeInOutQuad") : void
      {
         var obj:DisplayObject = null;
         var msgKey:String = param1;
         var delayIn:Number = param2;
         var tweenInTime:Number = param3;
         var delayOut:Number = param4;
         var tweenOutTime:Number = param5;
         var tweenType:String = param6;
         if(Boolean(!this[msgKey] as DisplayObject))
         {
            return;
         }
         obj = this[msgKey] as DisplayObject;
         Tweener.removeTweens(obj);
         obj.alpha = 0;
         obj.visible = true;
         Tweener.addTween(obj,{
            "alpha":1,
            "time":tweenInTime,
            "delay":delayIn,
            "transition":tweenType
         });
         if(delayOut >= 0)
         {
            Tweener.addTween(obj,{
               "alpha":0,
               "time":tweenOutTime,
               "delay":delayOut,
               "transition":tweenType,
               "onComplete":function():*
               {
                  obj.visible = false;
               }
            });
         }
      }
      
      private function onLightClosed() : void
      {
         _lightState = LIGHT_STATE_CLOSED;
         dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_LIGHT_CLOSED,this));
      }
      
      public function set chaserMaskType(param1:String) : void
      {
         _chaser_mask_frame_label = param1;
         mcChaserMask.gotoAndStop(param1);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** Spotlight: " + param1);
      }
      
      private function onChaserEnd() : void
      {
         dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_CHASER_END,this));
      }
      
      private function chaserDirectionUp(param1:Boolean, param2:Number = 0) : void
      {
         _bDispatchedChaserHalfDone = false;
         if(param1)
         {
            mcChaser.y = CHASER_START_Y;
            mcChaser.scaleY = 1;
            Tweener.addTween(mcChaser,{
               "y":CHASER_END_Y - mcChaser.height,
               "time":CHASER_TWEEN_Y_SECONDS,
               "delay":param2,
               "onUpdateParams":[param1],
               "onUpdate":onChaserTweenUpdate,
               "onComplete":onChaserEnd,
               "transition":"linear",
               "rounded":false
            });
         }
         else
         {
            mcChaser.scaleY = -1;
            mcChaser.y = CHASER_END_Y;
            if(!Tweener.addTween(mcChaser,{
               "y":CHASER_START_Y + mcChaser.height,
               "time":CHASER_TWEEN_Y_SECONDS,
               "delay":param2,
               "onUpdateParams":[param1],
               "onUpdate":onChaserTweenUpdate,
               "onComplete":onChaserEnd,
               "transition":"linear",
               "rounded":false
            }))
            {
               logError("chaserDirectionUp -- tween failed to be added!!!  calling onChaserEnd \"manually\"...");
               onChaserEnd();
            }
         }
      }
      
      public function set color(param1:uint) : void
      {
         var _loc2_:ColorTransform = new ColorTransform();
         var _loc3_:AdjustColor = new AdjustColor();
         switch(param1)
         {
            case RING_COLOR_RED:
               _loc2_.color = param1;
               _loc3_.brightness = 0;
               _loc3_.contrast = 0;
               _loc3_.saturation = 14;
               _loc3_.hue = 155;
               break;
            case RING_COLOR_YELLOW:
               _loc2_.color = param1;
               _loc2_.alphaMultiplier = 0.86;
               _loc3_.brightness = 0;
               _loc3_.contrast = 0;
               _loc3_.saturation = 14;
               _loc3_.hue = -149;
               break;
            case RING_COLOR_GREEN:
               _loc2_.color = param1;
               _loc2_.alphaMultiplier = 0.86;
               _loc3_.brightness = -6;
               _loc3_.contrast = 27;
               _loc3_.saturation = 18;
               _loc3_.hue = -75;
         }
         mcLight.transform.colorTransform = _loc2_;
         mcRing.filters = [new ColorMatrixFilter(_loc3_.CalculateFinalFlatArray())];
      }
      
      private function onOpened() : void
      {
         _spotlightState = SPOTLIGHT_STATE_OPENED;
         dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_OPENED,this));
      }
      
      private function onChaserTweenUpdate(param1:Boolean) : void
      {
         if(_bDispatchedChaserHalfDone)
         {
            return;
         }
         if(param1)
         {
            if(mcChaser.y <= (CHASER_START_Y + CHASER_END_Y - mcChaser.height) / 2)
            {
               _bDispatchedChaserHalfDone = true;
               dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_CHASER_HALF_DONE,this));
            }
         }
         else if(mcChaser.y >= (CHASER_END_Y + CHASER_START_Y + mcChaser.height) / 2)
         {
            _bDispatchedChaserHalfDone = true;
            dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_CHASER_HALF_DONE,this));
         }
      }
      
      public function openLight(param1:Boolean = false) : void
      {
         mcLight.visible = true;
         if(param1 && (Boolean(SPOTLIGHT_STATE_CLOSED) || Boolean(SPOTLIGHT_STATE_CLOSING)))
         {
            mcRing.visible = false;
            this.alpha = 1;
         }
         if(_lightState == LIGHT_STATE_OPENING || _lightState == LIGHT_STATE_OPENED)
         {
            if(_lightState == LIGHT_STATE_OPENED)
            {
               onLightOpened();
            }
            return;
         }
         _soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_Attack_CharacterSpotlight_Alt",true,SoundManagerConst.soundApplicationDomain,true));
         _lightState = LIGHT_STATE_OPENING;
         Tweener.removeTweens(mcLight,alpha);
         Tweener.addTween(mcLight,{
            "alpha":1,
            "time":FADE_TIME_SECONDS,
            "onComplete":onLightOpened
         });
         mcLight.gotoAndPlay(LIGHT_OPENING);
      }
      
      private function onChasersKilled() : void
      {
         resetChaser();
         dispatchEvent(new SpotlightEvent(SpotlightEvent.SPOTLIGHT_CHASERS_KILLED,this));
      }
      
      public function get chaserMaskType() : String
      {
         return _chaser_mask_frame_label;
      }
      
      public function get mcChaser() : MovieClip
      {
         return mcChaserNest.mcChaser as MovieClip;
      }
      
      public function closeLight() : void
      {
         if(_lightState == LIGHT_STATE_CLOSING || _lightState == LIGHT_STATE_CLOSED)
         {
            return;
         }
         _lightState = LIGHT_STATE_CLOSING;
         Tweener.removeTweens(mcLight,"alpha");
         Tweener.addTween(mcLight,{
            "alpha":0,
            "time":FADE_TIME_SECONDS,
            "onComplete":onLightClosed
         });
      }
      
      public function chaserUp(param1:Number = 0) : void
      {
         chaserDirectionUp(true,param1);
      }
   }
}

