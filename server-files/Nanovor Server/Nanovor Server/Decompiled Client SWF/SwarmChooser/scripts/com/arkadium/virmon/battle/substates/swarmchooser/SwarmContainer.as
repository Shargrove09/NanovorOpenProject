package com.arkadium.virmon.battle.substates.swarmchooser
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.events.SpotlightEvent;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.final.components.spotlight.SpotlightText;
   import com.arkadium.virmon.shared.final.components.viewbuttons.HoloButton;
   import com.arkadium.virmon.shared.final.components.viewbuttons.ViewButtons;
   import com.arkadium.virmon.shared.utils.NanovorLoaderAndSequencer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class SwarmContainer extends Sprite implements ISwarmContainer
   {
      
      public static const WIDTH:int = 1024;
      
      public static const HEIGHT:int = 400;
      
      public static const MODE_NONE:String = "none";
      
      public static const MODE_ATTACKS:String = "attacks";
      
      public static const MODE_STATS:String = "stats";
      
      public static const MODE_PEDIGREE:String = "pedigree";
      
      private static const VIEW_BUTTON_INACTIVE_ALPHA:Number = 0.4;
      
      private static const MASK_HEIGHT:int = 500;
      
      private static const MAIN_CONTAINER_OFFSET:Number = 62;
      
      private static const SPOTLIGHT_RESET_SECONDS:Number = 0.25;
      
      private static const NANOVOR_HOLDER_OFFSET:int = 82;
      
      private static const NANOVOR_PADDING_H:Number = 17.8;
      
      private static const SCALE_MULTIPLIER:Number = 0.95;
      
      private static const NANOVOR_SCALE:Number = 0.6 * SCALE_MULTIPLIER;
      
      private static const SPOTLIGHT_Y:int = -232;
      
      private static const NANOVOR_Y:int = 260;
      
      private static const PADDING:int = 20;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeOutQuad,
         "rounded":true
      };
      
      private var _candidateNanovorStack:SwarmContainerNanovorStack;
      
      private var _evoManager:IEvoManager;
      
      private var _calculatedMainContainerWidth:Number;
      
      private var _userProfile:IUserProfile;
      
      private var _spotlightText:SpotlightText;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _leftArrow:GlowArrow;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _mainContainer:Sprite;
      
      private var _primarySpotlight:Spotlight;
      
      private var _swarmStackDict:Dictionary = new Dictionary(true);
      
      private var _emManager:IEMManager;
      
      private var _badgeManager:IBadgeManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _rightArrow:GlowArrow;
      
      private var _isSwarmFull:Boolean = false;
      
      private var _views:MovieClip;
      
      private var _nanovorStacks:Array = new Array();
      
      private var _isSwarmSelected:Boolean = false;
      
      private var _currentMode:String;
      
      public function SwarmContainer(param1:ICharacterAssetTypeCache, param2:INanovorFactory, param3:IPlayerFactory, param4:IEvoManager, param5:IBadgeManager, param6:IEMManager, param7:IUserProfile)
      {
         super();
         _characterAssetTypeCache = param1;
         _nanovorFactory = param2;
         _playerFactory = param3;
         _evoManager = param4;
         _badgeManager = param5;
         _emManager = param6;
         _userProfile = param7;
         createMainContainerAndMask();
         createPrimarySpotlightAndText();
         createViewButtonsAndButtons();
      }
      
      private function onViewAttacksClick(param1:MouseEvent) : void
      {
         _currentMode = MODE_ATTACKS;
         this.mode = _currentMode;
      }
      
      public function addCandidate() : void
      {
         if(null == _candidateNanovorStack)
         {
            return;
         }
         _candidateNanovorStack.actionPicker.addClickToRemove();
         Tweener.removeTweens(_candidateNanovorStack.nanovor,"alpha");
         Tweener.addTween(_candidateNanovorStack.nanovor,{
            "alpha":1,
            "time":0.5
         });
         updateNanovorStackPositions();
         _candidateNanovorStack = null;
         _primarySpotlight.closeLight();
         _primarySpotlight.resetChaser();
         Tweener.addTween(_primarySpotlight,{
            "x":NANOVOR_PADDING_H + (ActionSlotComponent.WIDTH * SCALE_MULTIPLIER + NANOVOR_PADDING_H),
            "base":TWEEN_BASE,
            "onComplete":resetPrimarySpotlight
         });
         Tweener.removeTweens(_spotlightText,"_autoAlpha");
         Tweener.addTween(_spotlightText,{
            "_autoAlpha":1,
            "time":0.5,
            "delay":1,
            "transition":"easeInOutQuad"
         });
      }
      
      private function onSpotlightOpened(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onSpotlightOpened);
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightFirstChaserEnd);
         _primarySpotlight.chaserUp();
         _spotlightText.text = "SELECT AN\nEVO TREE";
         _spotlightText.x = Math.round((ActionSlotComponent.WIDTH * SCALE_MULTIPLIER - _spotlightText.width) / 2 + NANOVOR_PADDING_H);
         Tweener.addTween(_spotlightText,{
            "_autoAlpha":1,
            "time":1,
            "transition":"easeInOutQuad"
         });
      }
      
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:SwarmContainerNanovorStack = null;
         for(_loc1_ in _nanovorStacks)
         {
            _loc2_ = _nanovorStacks[_loc1_];
            if(_loc2_.actionPicker != null)
            {
               _loc2_.actionPicker.destroy();
               _loc2_.actionPicker.removeMouseEvents();
               _loc2_.actionPicker.removeEventListener(MouseEvent.CLICK,onActionPickerClick);
            }
            if(_loc2_.nanovor != null)
            {
               _loc2_.nanovor.stopAnimations();
            }
         }
         _views.mcStats.removeEventListener(MouseEvent.CLICK,onViewStatsClick);
         _views.mcAttacks.removeEventListener(MouseEvent.CLICK,onViewAttacksClick);
         _views.mcPedigrees.removeEventListener(MouseEvent.CLICK,onViewPedigreesClick);
         _leftArrow.removeEventListener(MouseEvent.CLICK,onLeftArrowClick);
         _rightArrow.removeEventListener(MouseEvent.CLICK,onRightArrowClick);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<SwarmContainer>> " + param1);
      }
      
      private function onViewPedigreesClick(param1:MouseEvent) : void
      {
         _currentMode = MODE_PEDIGREE;
         this.mode = _currentMode;
      }
      
      public function showSelectNanovor() : void
      {
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASERS_KILLED,finishShowSelectNanovor);
         killAllSpotlightAnimations();
         Tweener.removeTweens(_spotlightText,"_autoAlpha");
         Tweener.addTween(_spotlightText,{
            "_autoAlpha":0,
            "time":0.5,
            "onComplete":hideSpotlightText,
            "transition":"easeInOutQuad"
         });
      }
      
      public function showCandidate(param1:INanovor) : void
      {
         hideSpotlightText(true);
         killAllSpotlightAnimations();
         updateMainContainerPosition();
         _primarySpotlight.openLight();
         resetPrimarySpotlight();
         hideCandidate();
         var _loc2_:ActionPickerSwarm = new ActionPickerSwarm(param1,_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile);
         _loc2_.x = Math.round(NANOVOR_PADDING_H);
         _loc2_.addEventListener(MouseEvent.CLICK,onActionPickerClick);
         var _loc3_:Object = {
            "speed":0.5,
            "scaleX":(param1.isFacingRight ? -1 * NANOVOR_SCALE : NANOVOR_SCALE),
            "scaleY":NANOVOR_SCALE
         };
         var _loc4_:NanovorLoaderAndSequencer = new NanovorLoaderAndSequencer(getCharacterIdleURL(param1.assetTypeId),_loc3_);
         _loc4_.x = Math.round(NANOVOR_PADDING_H + NANOVOR_HOLDER_OFFSET);
         _loc4_.y = NANOVOR_Y;
         _loc4_.alpha = 0.5;
         _mainContainer.addChild(_loc4_);
         _mainContainer.addChild(_loc2_);
         _candidateNanovorStack = new SwarmContainerNanovorStack(_loc2_,_loc4_);
         _nanovorStacks.push(_candidateNanovorStack);
         _swarmStackDict[_loc2_] = _candidateNanovorStack;
         _loc2_.mode = _currentMode;
         _loc2_.open();
         _loc2_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
      }
      
      public function removeNanovor(param1:ActionPickerSwarm) : void
      {
         var _loc2_:SwarmContainerNanovorStack = _swarmStackDict[param1] as SwarmContainerNanovorStack;
         _nanovorStacks.splice(_nanovorStacks.indexOf(_loc2_),1);
         param1.removeEventListener(MouseEvent.CLICK,onActionPickerClick);
         param1.removeMouseEvents();
         _loc2_.actionPicker.close();
         _loc2_.actionPicker.destroy();
         Tweener.addTween(_loc2_.nanovor,{
            "_autoAlpha":0,
            "time":0.2,
            "onComplete":finishRemoving,
            "onCompleteParams":[_loc2_],
            "transition":"easeInQuad"
         });
         _spotlightText.text = "SELECT\nNANOVOR\nFOR\nSWARM!!";
         Tweener.addTween(_spotlightText,{
            "_autoAlpha":1,
            "time":1,
            "transition":"easeInOutQuad"
         });
         dispatchEvent(new SwarmContainerEvent(SwarmContainerEvent.NANOVOR_REMOVED,_loc2_.actionPicker.nanovor));
      }
      
      private function getCharacterIdleURL(param1:int) : String
      {
         return _characterAssetTypeCache.getCharacterAnimationURL(CharacterAnimationAssetType.IDLE,param1).url;
      }
      
      private function killAllSpotlightAnimations() : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightOpened);
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightFirstChaserEnd);
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightSecondChaserEnd);
         _primarySpotlight.killChasers();
      }
      
      private function hideSpotlightText(param1:Boolean = false) : void
      {
         if(param1)
         {
            Tweener.addTween(_spotlightText,{
               "_autoAlpha":0,
               "time":0.25,
               "transition":"easeInOutQuad"
            });
         }
         else
         {
            Tweener.addTween(_spotlightText,{
               "_autoAlpha":0,
               "time":1,
               "transition":"easeInOutQuad"
            });
         }
      }
      
      public function prepareForWaitScreen() : void
      {
         var nanovorStackIndex:String = null;
         var nanovorStack:SwarmContainerNanovorStack = null;
         this.mode = _currentMode = MODE_NONE;
         _spotlightText.visible = false;
         Tweener.removeTweens(_spotlightText,"_autoAlpha");
         try
         {
            _views.visible = false;
            _primarySpotlight.visible = false;
         }
         catch(e:Error)
         {
         }
         for(nanovorStackIndex in _nanovorStacks)
         {
            nanovorStack = _nanovorStacks[nanovorStackIndex];
            if(null != nanovorStack.actionPicker)
            {
               nanovorStack.actionPicker.destroy();
               nanovorStack.actionPicker.removeMouseEvents();
            }
            if(nanovorStack.nanovor != null)
            {
               nanovorStack.nanovor.stopAnimations();
            }
         }
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         log("onNanovorLoadComplete");
         param1.target.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
      }
      
      private function createMainContainerAndMask() : void
      {
         _mainContainer = new Sprite();
         _mainContainer.x = MAIN_CONTAINER_OFFSET;
         this.addChild(_mainContainer);
         var _loc1_:Sprite = new Sprite();
         _loc1_.x = MAIN_CONTAINER_OFFSET + 1;
         _loc1_.mouseEnabled = false;
         _loc1_.graphics.beginFill(16711680,0.5);
         _loc1_.graphics.drawRect(0,HEIGHT - MASK_HEIGHT,WIDTH - MAIN_CONTAINER_OFFSET,MASK_HEIGHT);
         _loc1_.graphics.endFill();
         this.addChild(_loc1_);
         _mainContainer.mask = _loc1_;
      }
      
      private function onSpotlightSecondChaserEnd(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightSecondChaserEnd);
         _primarySpotlight.chaserUp();
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         throw new Error("Nanovor SWF failed to load");
      }
      
      private function onLeftArrowClick(param1:MouseEvent) : void
      {
         if(Tweener.isTweening(_mainContainer))
         {
            return;
         }
         _rightArrow.open();
         var _loc2_:Number = _mainContainer.x + (ActionPickerSwarm.WIDTH * SCALE_MULTIPLIER + NANOVOR_PADDING_H);
         Tweener.addTween(_mainContainer,{
            "x":_loc2_,
            "base":TWEEN_BASE
         });
         if(_loc2_ >= MAIN_CONTAINER_OFFSET)
         {
            _leftArrow.close();
         }
      }
      
      public function get isSwarmSelected() : Boolean
      {
         return _isSwarmSelected;
      }
      
      private function onActionPickerClick(param1:MouseEvent) : void
      {
         var _loc2_:ActionPickerSwarm = null;
         if(!_isSwarmSelected)
         {
            _loc2_ = param1.target as ActionPickerSwarm;
            removeNanovor(_loc2_);
         }
      }
      
      private function createPrimarySpotlightAndText() : void
      {
         _primarySpotlight = new Spotlight();
         _primarySpotlight.color = Spotlight.RING_COLOR_YELLOW;
         _primarySpotlight.x = Math.round(NANOVOR_PADDING_H);
         _primarySpotlight.y = SPOTLIGHT_Y;
         _mainContainer.addChild(_primarySpotlight);
         _primarySpotlight.chaserMaskType = Spotlight.CHASER_MASK_INIT;
         _spotlightText = new SpotlightText();
         _spotlightText.alpha = 0;
         _spotlightText.y = 100;
         _mainContainer.addChild(_spotlightText);
      }
      
      private function finishShowSelectNanovor(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASERS_KILLED,finishShowSelectNanovor);
         _spotlightText.text = "SELECT\nNANOVOR\nFOR\nSWARM";
         _spotlightText.x = Math.round((ActionSlotComponent.WIDTH * SCALE_MULTIPLIER - _spotlightText.width) / 2 + NANOVOR_PADDING_H);
         Tweener.removeTweens(_spotlightText,"_autoAlpha");
         Tweener.addTween(_spotlightText,{
            "_autoAlpha":1,
            "time":1,
            "transition":"easeInOutQuad"
         });
         _primarySpotlight.chaserDown();
      }
      
      public function set mode(param1:String) : void
      {
         var _loc2_:String = null;
         _currentMode = param1;
         for(_loc2_ in _nanovorStacks)
         {
            _nanovorStacks[_loc2_].actionPicker.mode = param1;
         }
         _views.mcStats.alpha = VIEW_BUTTON_INACTIVE_ALPHA;
         _views.mcAttacks.alpha = VIEW_BUTTON_INACTIVE_ALPHA;
         _views.mcPedigrees.alpha = VIEW_BUTTON_INACTIVE_ALPHA;
         switch(_currentMode)
         {
            case SwarmContainer.MODE_ATTACKS:
               _views.mcAttacks.alpha = 1;
               break;
            case SwarmContainer.MODE_STATS:
               _views.mcStats.alpha = 1;
               break;
            case SwarmContainer.MODE_PEDIGREE:
               _views.mcPedigrees.alpha = 1;
         }
      }
      
      private function updateMainContainerPosition() : void
      {
         var _loc1_:int = _nanovorStacks.length + 1;
         _calculatedMainContainerWidth = _loc1_ * ActionSlotComponent.WIDTH * SCALE_MULTIPLIER + (_loc1_ - 1) * NANOVOR_PADDING_H + NANOVOR_PADDING_H;
         Tweener.removeTweens(_mainContainer,"x");
         Tweener.addTween(_mainContainer,{
            "x":MAIN_CONTAINER_OFFSET,
            "base":TWEEN_BASE
         });
         if(_calculatedMainContainerWidth > WIDTH - MAIN_CONTAINER_OFFSET)
         {
            _leftArrow.close();
            _rightArrow.open();
         }
         else
         {
            _leftArrow.close();
            _rightArrow.close();
         }
      }
      
      public function open() : void
      {
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onSpotlightOpened);
         _primarySpotlight.open();
      }
      
      private function onRightArrowClick(param1:MouseEvent) : void
      {
         if(Tweener.isTweening(_mainContainer))
         {
            return;
         }
         _leftArrow.open();
         var _loc2_:Number = _mainContainer.x - (ActionPickerSwarm.WIDTH * SCALE_MULTIPLIER + NANOVOR_PADDING_H);
         Tweener.addTween(_mainContainer,{
            "x":_loc2_,
            "base":TWEEN_BASE
         });
         if(_calculatedMainContainerWidth - WIDTH + NANOVOR_PADDING_H + _loc2_ - MAIN_CONTAINER_OFFSET <= 3)
         {
            _rightArrow.close();
         }
      }
      
      public function swarmIsNotFull() : void
      {
         _isSwarmFull = false;
         hideSpotlightText(true);
         _primarySpotlight.openLight();
      }
      
      public function hideCandidate() : void
      {
         log("hideCandidate() ");
         removeCandidate();
      }
      
      private function removeCandidate() : void
      {
         if(null == _candidateNanovorStack)
         {
            return;
         }
         _nanovorStacks.pop();
         _mainContainer.removeChild(_candidateNanovorStack.nanovor);
         _candidateNanovorStack.actionPicker.destroy();
         _candidateNanovorStack.actionPicker.removeEventListener(MouseEvent.CLICK,onActionPickerClick);
         _mainContainer.removeChild(_candidateNanovorStack.actionPicker);
         _candidateNanovorStack = null;
         Tweener.removeTweens(_spotlightText,"_autoAlpha");
         Tweener.addTween(_spotlightText,{
            "_autoAlpha":1,
            "time":0.5,
            "transition":"easeInOutQuad"
         });
      }
      
      private function resetPrimarySpotlight() : void
      {
         Tweener.removeTweens(_primarySpotlight,"x");
         Tweener.addTween(_primarySpotlight,{
            "x":NANOVOR_PADDING_H,
            "time":SPOTLIGHT_RESET_SECONDS,
            "base":TWEEN_BASE,
            "onComplete":onPrimarySpotlightReset
         });
      }
      
      public function set isSwarmSelected(param1:Boolean) : void
      {
         _isSwarmSelected = param1;
      }
      
      private function onSpotlightFirstChaserEnd(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightFirstChaserEnd);
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightSecondChaserEnd);
         _primarySpotlight.chaserUp();
      }
      
      private function onPrimarySpotlightReset() : void
      {
         if(_isSwarmFull)
         {
            _spotlightText.text = "SWARM\nIS FULL";
            _spotlightText.x = Math.round((ActionSlotComponent.WIDTH * SCALE_MULTIPLIER - _spotlightText.width) / 2 + NANOVOR_PADDING_H);
            Tweener.addTween(_spotlightText,{
               "_autoAlpha":1,
               "time":1,
               "transition":"easeInOutQuad"
            });
         }
         else
         {
            _primarySpotlight.openLight();
         }
      }
      
      private function createViewButtonsAndButtons() : void
      {
         _views = new ViewButtons();
         _views.mcViewBG.alpha = 0.5;
         _views.y = 20;
         _views.x = 16;
         _views.mcStats.addChild(new HoloButton(HoloButton.ICON_S,"STATS"));
         _views.mcStats.addEventListener(MouseEvent.CLICK,onViewStatsClick);
         _views.mcAttacks.addChild(new HoloButton(HoloButton.ICON_A,"ATTACKS"));
         _views.mcAttacks.addEventListener(MouseEvent.CLICK,onViewAttacksClick);
         _views.mcPedigrees.addChild(new HoloButton(HoloButton.ICON_PEDIGREE,"EVOLUTIONS"));
         _views.mcPedigrees.addEventListener(MouseEvent.CLICK,onViewPedigreesClick);
         this.addChild(_views);
         _leftArrow = new GlowArrow();
         _leftArrow.x = Math.round((MAIN_CONTAINER_OFFSET - GlowArrow.WIDTH) / 2);
         _leftArrow.y = 260;
         _rightArrow = new GlowArrow();
         _rightArrow.scaleX = -1;
         _rightArrow.x = WIDTH - 10;
         _rightArrow.y = 260;
         _leftArrow.addEventListener(MouseEvent.CLICK,onLeftArrowClick);
         _rightArrow.addEventListener(MouseEvent.CLICK,onRightArrowClick);
         var _loc1_:Sprite = new Sprite();
         _loc1_.addChild(_leftArrow);
         _loc1_.addChild(_rightArrow);
         this.addChild(_loc1_);
      }
      
      public function swarmIsFull() : void
      {
         _isSwarmFull = true;
      }
      
      private function finishRemoving(param1:SwarmContainerNanovorStack) : void
      {
         _mainContainer.removeChild(param1.actionPicker);
         param1.actionPicker.destroy();
         _mainContainer.removeChild(param1.nanovor);
         updateNanovorStackPositions();
      }
      
      private function onViewStatsClick(param1:MouseEvent) : void
      {
         _currentMode = MODE_STATS;
         this.mode = _currentMode;
      }
      
      private function updateNanovorStackPositions() : void
      {
         var _loc1_:SwarmContainerNanovorStack = null;
         var _loc2_:int = 0;
         var _loc4_:Number = NaN;
         var _loc3_:int = int(_nanovorStacks.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _nanovorStacks[_loc2_];
            _loc4_ = Math.round((_loc3_ - _loc2_) * (ActionPickerSwarm.WIDTH * SCALE_MULTIPLIER + NANOVOR_PADDING_H) + NANOVOR_PADDING_H);
            if(_loc1_.actionPicker.x != _loc4_)
            {
               Tweener.removeTweens(_loc1_.actionPicker,"x");
               Tweener.removeTweens(_loc1_.nanovor,"x");
               Tweener.addTween(_loc1_.actionPicker,{
                  "x":_loc4_,
                  "base":TWEEN_BASE
               });
               Tweener.addTween(_loc1_.nanovor,{
                  "x":_loc4_ + NANOVOR_HOLDER_OFFSET,
                  "base":TWEEN_BASE
               });
            }
            _loc2_++;
         }
         updateMainContainerPosition();
      }
   }
}

