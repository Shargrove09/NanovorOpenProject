package com.arkadium.virmon.device.ui.spinner
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.elements.icons.factions.*;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.AdjustColor;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol97")]
   public class DeviceSpinner extends MovieClip
   {
      
      private static const SHOW_DEBUGGING:Boolean = true;
      
      public static const NANOVOR_ATTACH_POINTS:Array = [[205,-172],[251,-62],[254,40],[219,138],[147,211],[51,252],[-51,253],[-146,212],[-217,138],[-254,42],[-252,-62]];
      
      public static const NUM_SLOTS:int = 10;
      
      private static const TIMER_ANGLE_FULL:int = 46;
      
      private static const TIMER_ANGLE_EMPTY:int = 134;
      
      private static const TIMER_ANGLE_PERCENTAGE_DELTA:Number = (TIMER_ANGLE_EMPTY - TIMER_ANGLE_FULL) / 100;
      
      public static const COLOR_GREEN:String = "green";
      
      public static const COLOR_RED:String = "red";
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      public static const FACTION_ICON_WIDTH:int = 68;
      
      public static const FACTION_ICON_HEIGHT:int = 68;
      
      public var mcCenter:Sprite;
      
      private var _colorMatrixRed:ColorMatrixFilter;
      
      public var mcTimer:MovieClip;
      
      public var mcContents:Sprite;
      
      private var _timelineController:SpinnerTimelineHelper;
      
      private var _nanovorSlotContainer:Sprite;
      
      private var _factionSlots:Array;
      
      public var mcTransferButtonWire:MovieClip;
      
      private var _timerFill:Sprite;
      
      public var mcButtonHolder:MovieClip;
      
      private var _colorMatrixGreen:ColorMatrixFilter;
      
      public function DeviceSpinner()
      {
         super();
         _timerFill = mcTimer.mcFill;
      }
      
      public function destroy() : void
      {
         mcTimer.stop();
         mcTransferButtonWire.stop();
         mcButtonHolder.stop();
      }
      
      public function setTimer(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = param1 / param2 * 100;
         var _loc4_:Number = TIMER_ANGLE_FULL + TIMER_ANGLE_PERCENTAGE_DELTA * _loc3_;
         Tweener.addTween(_timerFill,{
            "rotation":_loc4_,
            "base":TWEEN_BASE
         });
      }
      
      private function log(param1:String) : void
      {
         if(SHOW_DEBUGGING)
         {
            DebugLog.instance.log("<<DeviceSpinner>>\t" + param1);
         }
      }
      
      public function addContent(param1:DisplayObject) : void
      {
         log("addContent()");
         mcContents.addChild(param1);
      }
      
      private function disableObject(param1:Sprite) : void
      {
         param1.mouseEnabled = false;
         param1.alpha = 0;
      }
      
      public function removeFactionIcon(param1:int) : void
      {
         mcContents.removeChild(_factionSlots[param1]);
         if(_factionSlots.length < NUM_SLOTS)
         {
         }
         _factionSlots.splice(param1,1);
         var _loc2_:* = param1;
         while(_loc2_ < _factionSlots.length)
         {
            positionFactionIcon(_factionSlots[_loc2_],_loc2_);
            _loc2_++;
         }
         revealNextOpenFactionSlot();
      }
      
      public function toggleTimer(param1:Boolean) : void
      {
         var _loc2_:Number = param1 ? 1 : 0;
         Tweener.addTween(mcTimer,{
            "_autoAlpha":_loc2_,
            "base":TWEEN_BASE
         });
      }
      
      private function positionFactionIcon(param1:*, param2:int) : void
      {
         param1.x = NANOVOR_ATTACH_POINTS[param2 + 1][0] - param1.width / 2;
         param1.y = NANOVOR_ATTACH_POINTS[param2 + 1][1] - param1.height / 2;
      }
      
      public function addFactionIcon(param1:int, param2:String) : void
      {
         var _loc3_:* = undefined;
         switch(param2.toLowerCase())
         {
            case "magnamod":
               _loc3_ = new FactionMagnamod();
               break;
            case "velocitron":
               _loc3_ = new FactionVelocitron();
               break;
            case "hexite":
               _loc3_ = new FactionHexite();
         }
         _loc3_.width = FACTION_ICON_WIDTH;
         _loc3_.height = FACTION_ICON_HEIGHT;
         positionFactionIcon(_loc3_,param1);
         _loc3_.alpha = 0;
         mcContents.addChild(_loc3_);
         _factionSlots.push(_loc3_);
         Tweener.addTween(_loc3_,{
            "alpha":1,
            "time":0.5,
            "transition":Equations.easeInOutQuad
         });
         if(param1 < NUM_SLOTS - 1)
         {
            revealNextOpenFactionSlot();
         }
      }
      
      private function revealNextOpenFactionSlot() : void
      {
      }
      
      public function initForDeviceSwarmChooser() : void
      {
         _factionSlots = new Array();
      }
      
      public function clearFactionIcons() : void
      {
         if(_factionSlots.length < NUM_SLOTS)
         {
         }
         var _loc1_:* = 0;
         while(_loc1_ < _factionSlots.length)
         {
            mcContents.removeChild(_factionSlots[_loc1_]);
            _loc1_++;
         }
      }
      
      public function showButtonHolder(param1:Function = null) : void
      {
         Tweener.addTween(mcButtonHolder,{
            "_autoAlpha":1,
            "_scale":1,
            "base":TWEEN_BASE,
            "onComplete":param1
         });
      }
      
      public function setColor(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         switch(param1)
         {
            case COLOR_RED:
               _loc2_ = [_colorMatrixRed];
               break;
            case COLOR_GREEN:
            default:
               _loc2_ = [_colorMatrixGreen];
         }
         var _loc5_:int = this.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this.getChildAt(_loc4_) as DisplayObject;
            switch(_loc3_)
            {
               default:
                  _loc3_.filters = _loc2_;
                  break;
               case mcCenter:
               case mcButtonHolder:
               case mcContents:
               case mcTimer:
               case mcTransferButtonWire:
            }
            _loc4_++;
         }
      }
      
      public function open(param1:Function = null) : void
      {
         _timelineController.open(param1);
      }
      
      public function toggleMainButtonWire(param1:Boolean) : void
      {
         Tweener.addTween(mcTransferButtonWire,{
            "_autoAlpha":(param1 ? 1 : 0),
            "base":TWEEN_BASE
         });
      }
      
      private function createFilters() : void
      {
         var _loc1_:AdjustColor = new AdjustColor();
         _loc1_.brightness = -100;
         _loc1_.contrast = 0;
         _loc1_.saturation = 100;
         _loc1_.hue = 180;
         _colorMatrixRed = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
         var _loc2_:AdjustColor = new AdjustColor();
         _loc2_.brightness = -6;
         _loc2_.contrast = 27;
         _loc2_.saturation = 18;
         _loc2_.hue = -89;
         _colorMatrixGreen = new ColorMatrixFilter(_loc2_.CalculateFinalFlatArray());
      }
      
      private function removeCenterObject(param1:DisplayObject) : void
      {
         mcCenter.removeChild(param1);
      }
      
      public function hideButtonHolder() : void
      {
         Tweener.addTween(mcButtonHolder,{
            "_autoAlpha":0,
            "_scale":3,
            "base":TWEEN_BASE
         });
      }
      
      private function createSlots() : void
      {
      }
      
      public function init() : void
      {
         _timelineController = new SpinnerTimelineHelper(this);
         mcTimer.stop();
         mcTimer.visible = false;
         disableObject(mcTransferButtonWire);
         disableObject(mcButtonHolder);
         mcButtonHolder.mouseChildren = false;
         mcButtonHolder.scaleX = 3;
         mcButtonHolder.scaleY = 3;
         createFilters();
      }
      
      public function setCenterObject(param1:DisplayObject) : void
      {
         if(mcCenter.numChildren > 0 && mcCenter.getChildAt(0) === param1)
         {
            return;
         }
         clearCenterObject();
         param1.alpha = 0;
         mcCenter.addChild(param1);
         Tweener.addTween(param1,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         log(mcCenter.numChildren.toString());
      }
      
      public function clearCenterObject() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < mcCenter.numChildren)
         {
            _loc1_ = mcCenter.getChildAt(_loc2_) as DisplayObject;
            Tweener.addTween(_loc1_,{
               "_autoAlpha":0,
               "base":TWEEN_BASE,
               "onComplete":removeCenterObject,
               "onCompleteParams":[_loc1_]
            });
            _loc2_++;
         }
      }
      
      public function close(param1:Function = null) : void
      {
         _timelineController.close(param1);
      }
   }
}

import com.arkadium.virmon.shared.utils.FramerateTickController;
import com.arkadium.virmon.shared.utils.IFramerateTickConsumer;
import flash.display.MovieClip;

class SpinnerTimelineHelper implements IFramerateTickConsumer
{
   
   private var _reverse:Boolean;
   
   private var _target:MovieClip;
   
   private var _finishCallback:Function;
   
   private var _currentFrame:int;
   
   public function SpinnerTimelineHelper(param1:MovieClip)
   {
      super();
      _target = param1;
      _target.stop();
      _currentFrame = 1;
   }
   
   public function open(param1:Function = null) : void
   {
      _finishCallback = param1;
      _reverse = false;
      FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
   }
   
   public function close(param1:Function = null) : void
   {
      _finishCallback = param1;
      _reverse = true;
      FramerateTickController.getInstance().addConsumer(IFramerateTickConsumer(this));
   }
   
   public function tick() : void
   {
      _target.gotoAndStop(int(_currentFrame));
      if(_reverse)
      {
         _currentFrame -= 2;
         if(_currentFrame < 1)
         {
            stopTick();
         }
      }
      else
      {
         _currentFrame += 2;
         if(_currentFrame > _target.totalFrames)
         {
            stopTick();
         }
      }
   }
   
   private function stopTick() : void
   {
      FramerateTickController.getInstance().removeConsumer(IFramerateTickConsumer(this));
      if(null != _finishCallback)
      {
         _finishCallback.call();
         _finishCallback = null;
      }
   }
}
