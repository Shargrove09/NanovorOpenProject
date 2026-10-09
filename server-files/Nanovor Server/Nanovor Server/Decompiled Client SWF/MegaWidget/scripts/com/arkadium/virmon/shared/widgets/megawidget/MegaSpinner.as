package com.arkadium.virmon.shared.widgets.megawidget
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol93")]
   public class MegaSpinner extends MovieClip
   {
      
      public static const EVENT_OPENED:String = "opened";
      
      public static const EVENT_CLOSED:String = "closed";
      
      public static const COLOR_BLUE:String = "blue";
      
      public static const COLOR_ORANGE:String = "orange";
      
      public static const CENTER_MODE_SEARCHING:String = "searching";
      
      public static const CENTER_MODE_TIMER:String = "timer";
      
      public static const CENTER_MODE_UNKNOWN:String = "unknown";
      
      private static const SCALE_MULTIPLIER:int = 5;
      
      public var mcDots:MovieClip;
      
      public var mcLeftRing:MovieClip;
      
      private var _avatarSpinners:Array;
      
      private var _autoBattlePicker:AutoBattlePicker;
      
      public var mcLeftInner:MovieClip;
      
      private var _unknownNanovor:UnknownNanovorSpinner;
      
      public var mcSpinner:MovieClip;
      
      private var _animationPieces:Array;
      
      public var mcCircler:MovieClip;
      
      public var mcDial:MovieClip;
      
      public var mcLeftOutter:MovieClip;
      
      public var mcCenterBattleStartsIn:MovieClip;
      
      public var mcTopBottomTicks:MovieClip;
      
      private var _endingAttributes:Dictionary = new Dictionary(false);
      
      public var mcSlots:MovieClip;
      
      public var mcGlow:MovieClip;
      
      public var mcClamps:MovieClip;
      
      private var _isOpening:Boolean = false;
      
      public var mcRightInner:MovieClip;
      
      private var _avatarSpinner2:MegaWidgetAvatarSpinner;
      
      private var _avatarSpinner3:MegaWidgetAvatarSpinner;
      
      public var mcLeftDot:MovieClip;
      
      public var mcRandomTechPieces:MovieClip;
      
      private var _avatarSpinner1:MegaWidgetAvatarSpinner;
      
      public var mcRightOutter:MovieClip;
      
      private var _avatarSpinner4:MegaWidgetAvatarSpinner;
      
      private var _startingAttributes:Dictionary = new Dictionary(false);
      
      public var mcAvatarSpinnersContainer:MovieClip;
      
      public var mcAutoBattlePicker:MovieClip;
      
      private var _adjustColorFilters:Dictionary = new Dictionary(false);
      
      public var mcCenterSearching:MovieClip;
      
      public var tfTimer:TextField;
      
      public function MegaSpinner()
      {
         super();
         _unknownNanovor = new UnknownNanovorSpinner();
         _unknownNanovor.x = -75;
         _unknownNanovor.y = -61;
         this.addChild(_unknownNanovor);
      }
      
      public function destroy() : void
      {
         _avatarSpinner1.destory();
         _avatarSpinner2.destory();
         _avatarSpinner3.destory();
         _avatarSpinner4.destory();
      }
      
      public function get avatarSpinners() : Array
      {
         return _avatarSpinners;
      }
      
      private function startOpenAnimationChain() : void
      {
         DebugLog.instance.log("STARTING OPEN ANIMATION CHAIN");
         Tweener.addTween(mcLeftOutter,{
            "base":_startingAttributes[mcLeftOutter],
            "delay":0
         });
         Tweener.addTween(mcRightOutter,{
            "base":_startingAttributes[mcRightOutter],
            "delay":0
         });
         Tweener.addTween(mcLeftInner,{
            "base":_startingAttributes[mcLeftInner],
            "delay":0.2
         });
         Tweener.addTween(mcRightInner,{
            "base":_startingAttributes[mcRightInner],
            "delay":0.2
         });
         Tweener.addTween(mcCircler,{
            "base":_startingAttributes[mcCircler],
            "delay":0.4,
            "onComplete":openSlotHolderAndSpinners
         });
         Tweener.addTween(mcSpinner,{
            "base":_startingAttributes[mcSpinner],
            "delay":1
         });
         Tweener.addTween(mcDial,{
            "base":_startingAttributes[mcDial],
            "delay":1
         });
         Tweener.addTween(mcClamps,{
            "base":_startingAttributes[mcClamps],
            "delay":1
         });
         Tweener.addTween(mcLeftRing,{
            "base":_startingAttributes[mcLeftRing],
            "delay":2
         });
         Tweener.addTween(mcRandomTechPieces,{
            "base":_startingAttributes[mcRandomTechPieces],
            "delay":2
         });
         Tweener.addTween(mcLeftDot,{
            "base":_startingAttributes[mcLeftDot],
            "delay":2.2
         });
         Tweener.addTween(mcDots,{
            "base":_startingAttributes[mcDots],
            "delay":2.2
         });
         Tweener.addTween(mcGlow,{
            "base":_startingAttributes[mcGlow],
            "delay":2.2
         });
         Tweener.addTween(_unknownNanovor,{
            "base":_startingAttributes[_unknownNanovor],
            "delay":2.2
         });
      }
      
      private function createAvatarSpinners() : void
      {
         _avatarSpinner1 = new MegaWidgetAvatarSpinner();
         _avatarSpinner1.x = 117;
         _avatarSpinner1.y = -186;
         _avatarSpinner1.scaleX = _avatarSpinner1.scaleY = 1.15;
         _avatarSpinner1.disabled = true;
         mcAvatarSpinnersContainer.addChild(_avatarSpinner1);
         _avatarSpinner2 = new MegaWidgetAvatarSpinner();
         _avatarSpinner2.x = 193;
         _avatarSpinner2.y = -92;
         _avatarSpinner2.timerPercent = 100;
         _avatarSpinner2.disabled = true;
         mcAvatarSpinnersContainer.addChild(_avatarSpinner2);
         _avatarSpinner3 = new MegaWidgetAvatarSpinner();
         _avatarSpinner3.x = 213;
         _avatarSpinner3.y = 21;
         _avatarSpinner3.timerPercent = 100;
         _avatarSpinner3.disabled = true;
         mcAvatarSpinnersContainer.addChild(_avatarSpinner3);
         _avatarSpinner4 = new MegaWidgetAvatarSpinner();
         _avatarSpinner4.x = 171;
         _avatarSpinner4.y = 128;
         _avatarSpinner4.timerPercent = 100;
         _avatarSpinner4.disabled = true;
         _avatarSpinner4.nameOrientation = MegaWidgetAvatarSpinner.NAME_ORIENTATION_BOTTOM_RIGHT;
         mcAvatarSpinnersContainer.addChild(_avatarSpinner4);
         _avatarSpinners = [_avatarSpinner1,_avatarSpinner2,_avatarSpinner3,_avatarSpinner4];
      }
      
      public function init() : void
      {
         initializeStartState();
         createAvatarSpinners();
         _autoBattlePicker = new AutoBattlePicker(mcAutoBattlePicker);
         this.mouseEnabled = false;
         this.visible = false;
      }
      
      private function finishClosingAnimation() : void
      {
         this.visible = false;
         dispatchEvent(new Event(EVENT_CLOSED));
      }
      
      private function openSlotHolderAndSpinners() : void
      {
         Tweener.addTween(mcSlots,{
            "base":_startingAttributes[mcSlots],
            "onComplete":finishOpeningAnimation
         });
      }
      
      public function get autoBattlePickerOpen() : Boolean
      {
         return _autoBattlePicker.isOpen();
      }
      
      private function cascadeOpenSpinners() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < _avatarSpinners.length)
         {
            Tweener.addTween(_avatarSpinners[_loc1_],{
               "onComplete":_avatarSpinners[_loc1_].open,
               "time":0,
               "delay":0.05 * _loc1_
            });
            _loc1_++;
         }
      }
      
      public function set showAutoBattlePicker(param1:Boolean) : void
      {
         if(param1)
         {
            _autoBattlePicker.open();
         }
         else
         {
            _autoBattlePicker.close();
         }
      }
      
      public function set center(param1:String) : void
      {
         switch(param1)
         {
            case CENTER_MODE_SEARCHING:
               tfTimer.visible = false;
               _unknownNanovor.visible = false;
               mcCenterSearching.visible = true;
               mcCenterBattleStartsIn.visible = false;
               break;
            case CENTER_MODE_TIMER:
               tfTimer.visible = true;
               _unknownNanovor.visible = false;
               mcCenterSearching.visible = false;
               mcCenterBattleStartsIn.visible = true;
               break;
            default:
               tfTimer.visible = false;
               _unknownNanovor.visible = true;
               mcCenterSearching.visible = false;
               mcCenterBattleStartsIn.visible = false;
         }
      }
      
      private function getStartingAttributes(param1:DisplayObjectContainer) : Object
      {
         return {
            "_scale":param1.scaleX,
            "alpha":param1.alpha,
            "time":1,
            "transition":Equations.easeInOutQuad
         };
      }
      
      public function get autoBattleButtons() : Array
      {
         return _autoBattlePicker.buttons;
      }
      
      public function open() : void
      {
         this.visible = true;
         _isOpening = true;
         startOpenAnimationChain();
      }
      
      private function closeSpinners() : void
      {
         var _loc1_:MegaWidgetAvatarSpinner = null;
         for each(_loc1_ in _avatarSpinners)
         {
            _loc1_.close();
         }
      }
      
      public function set color(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MegaWidgetAvatarSpinner = null;
         if(param1 == COLOR_ORANGE)
         {
            for each(_loc2_ in _animationPieces)
            {
               if(_adjustColorFilters[_loc2_] != null)
               {
                  _loc2_.filters = [_adjustColorFilters[_loc2_]];
               }
            }
            for each(_loc3_ in _avatarSpinners)
            {
               _loc3_.color = MegaWidgetAvatarSpinner.COLOR_ORANGE;
            }
         }
         else
         {
            for each(_loc2_ in _animationPieces)
            {
               _loc2_.filters = [];
            }
            for each(_loc3_ in _avatarSpinners)
            {
               _loc3_.color = MegaWidgetAvatarSpinner.COLOR_BLUE;
            }
         }
      }
      
      public function get isOpening() : Boolean
      {
         return _isOpening;
      }
      
      private function finishOpeningAnimation() : void
      {
         _isOpening = false;
         dispatchEvent(new Event(EVENT_OPENED));
      }
      
      private function openAvatarSpinners() : void
      {
         var _loc1_:MegaWidgetAvatarSpinner = null;
         for each(_loc1_ in _avatarSpinners)
         {
            _loc1_.open();
         }
      }
      
      public function set timerText(param1:String) : void
      {
         tfTimer.text = param1;
      }
      
      private function getEndingAttributes(param1:DisplayObjectContainer) : Object
      {
         return {
            "_scale":param1.scaleX,
            "alpha":param1.alpha,
            "time":1,
            "transition":Equations.easeInOutQuad
         };
      }
      
      private function startClosingAnimationChain() : void
      {
         closeSpinners();
         Tweener.addTween(mcSlots,{"base":_endingAttributes[mcSlots]});
         Tweener.addTween(mcLeftOutter,{
            "base":_endingAttributes[mcLeftOutter],
            "delay":1,
            "onComplete":finishClosingAnimation
         });
         Tweener.addTween(mcRightOutter,{
            "base":_endingAttributes[mcRightOutter],
            "delay":1
         });
         Tweener.addTween(mcLeftInner,{
            "base":_endingAttributes[mcLeftInner],
            "delay":0.8
         });
         Tweener.addTween(mcRightInner,{
            "base":_endingAttributes[mcRightInner],
            "delay":0.8
         });
         Tweener.addTween(mcCircler,{
            "base":_endingAttributes[mcCircler],
            "delay":0.6
         });
         Tweener.addTween(mcSpinner,{
            "base":_endingAttributes[mcSpinner],
            "delay":0.4
         });
         Tweener.addTween(mcDial,{
            "base":_endingAttributes[mcDial],
            "delay":0.4
         });
         Tweener.addTween(mcClamps,{
            "base":_endingAttributes[mcClamps],
            "delay":0.4
         });
         Tweener.addTween(mcLeftRing,{
            "base":_endingAttributes[mcLeftRing],
            "delay":0.2
         });
         Tweener.addTween(mcRandomTechPieces,{
            "base":_endingAttributes[mcRandomTechPieces],
            "delay":0.2
         });
         Tweener.addTween(mcLeftDot,{
            "base":_endingAttributes[mcLeftDot],
            "delay":0
         });
         Tweener.addTween(mcDots,{
            "base":_endingAttributes[mcDots],
            "delay":0
         });
         Tweener.addTween(mcGlow,{
            "base":_endingAttributes[mcGlow],
            "delay":0
         });
         Tweener.addTween(_unknownNanovor,{
            "base":_endingAttributes[_unknownNanovor],
            "delay":0
         });
      }
      
      public function set autoBattleNumPlayers(param1:int) : void
      {
         _autoBattlePicker.setActiveSlot(param1);
      }
      
      public function close() : void
      {
         _isOpening = false;
         startClosingAnimationChain();
      }
      
      private function initializeStartState() : void
      {
         var _loc3_:DisplayObjectContainer = null;
         this.center = CENTER_MODE_UNKNOWN;
         var _loc1_:Array = [mcLeftOutter,mcRightOutter,mcLeftInner,mcRightInner,mcSpinner,mcClamps,mcCircler,mcSlots];
         var _loc2_:Array = [mcDial,mcGlow,mcDots,mcLeftDot,mcRandomTechPieces,mcTopBottomTicks,mcLeftRing,_unknownNanovor];
         _animationPieces = _loc1_.slice().concat(_loc2_.slice());
         for each(_loc3_ in _loc1_)
         {
            _startingAttributes[_loc3_] = getStartingAttributes(_loc3_);
            _loc3_.scaleX = _loc3_.scaleY = _startingAttributes[_loc3_]._scale * SCALE_MULTIPLIER;
            _loc3_.alpha = 0;
            _loc3_.mouseEnabled = false;
            _loc3_.mouseChildren = false;
            _endingAttributes[_loc3_] = getEndingAttributes(_loc3_);
            if(_loc3_.filters.length > 0)
            {
               _adjustColorFilters[_loc3_] = _loc3_.filters[0];
            }
            _loc3_.filters = [];
         }
         for each(_loc3_ in _loc2_)
         {
            _startingAttributes[_loc3_] = getStartingAttributes(_loc3_);
            _loc3_.alpha = 0;
            _loc3_.mouseEnabled = false;
            _loc3_.mouseChildren = false;
            _endingAttributes[_loc3_] = getEndingAttributes(_loc3_);
            if(_loc3_.filters.length > 0)
            {
               _adjustColorFilters[_loc3_] = _loc3_.filters[0];
            }
            _loc3_.filters = [];
         }
      }
   }
}

