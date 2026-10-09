package com.arkadium.virmon.device.deviceswarmchooser.deviceswarmcontainer
{
   import caurina.transitions.Tweener;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.arkadium.virmon.battle.control.Attack;
   import com.arkadium.virmon.battle.control.Conditional;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.substates.swarmchooser.ActionPickerSwarm;
   import com.arkadium.virmon.battle.substates.swarmchooser.SwarmContainerEvent;
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
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class DeviceSwarmContainer extends Sprite
   {
      
      public static const WIDTH:int = 960;
      
      public static const HEIGHT:int = 400;
      
      public static const MODE_NONE:String = "none";
      
      public static const MODE_ATTACKS:String = "attacks";
      
      public static const MODE_STATS:String = "stats";
      
      public static const MODE_PEDIGREE:String = "pedigree";
      
      public static const SPOTLIGHT_OPEN:String = "spotlightopen";
      
      private static const VIEW_BUTTON_INACTIVE_ALPHA:Number = 0.4;
      
      private static const MASK_HEIGHT:int = 500;
      
      private static const MAIN_CONTAINER_OFFSET:Number = 62;
      
      private static const SPOTLIGHT_RESET_SECONDS:Number = 0.25;
      
      private static const NANOVOR_HOLDER_OFFSET:int = 82;
      
      private static const NANOVOR_PADDING_H:Number = 17.8;
      
      private static const SCALE_MULTIPLIER:Number = 0.95;
      
      private static const SPOTLIGHT_Y:int = -232;
      
      private static const NANOVOR_Y:int = 260;
      
      private static const PADDING:int = 20;
      
      private static const NANOVOR_TWEEN_SECONDS:Number = 0.5;
      
      private static const NANOVOR_TWEEN_TRANSITION:String = "easeOutQuad";
      
      private static const SPIKEBOARD_X:int = 390;
      
      private static const SPIKEBOARD_Y:int = -250;
      
      private var _nanovorLoaders:Array = new Array();
      
      private var _candidateNanovorStack:NanovorStack;
      
      private var _yellowSpikedAttackTotal:int = 0;
      
      private var _actionPickers:Array = new Array();
      
      private var _evoManager:IEvoManager;
      
      private var _calculatedMainContainerWidth:Number;
      
      private var isSwarmFull:Boolean = false;
      
      private var _spikeBoard:SpikeBoard;
      
      private var _blueSpikedAttackTotal:int = 0;
      
      private var _userProfile:IUserProfile;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _redSpikedAttackTotal:int = 0;
      
      private var _spotlightText:SpotlightText;
      
      private var _tempNanovorStack:NanovorStack;
      
      private var _leftArrow:GlowArrow;
      
      private var _nanovorFactory:INanovorFactory;
      
      public var _mainContainer:Sprite;
      
      private var _redSpikeTotal:int = 0;
      
      private var _yellowSpikeTotal:int = 0;
      
      private var _arrowsContainer:Sprite;
      
      private var _primarySpotlight:Spotlight;
      
      private var _swarmStackDict:Dictionary = new Dictionary();
      
      private var _emManager:IEMManager;
      
      private var _badgeManager:IBadgeManager;
      
      private var _playerFactory:IPlayerFactory;
      
      private var _nanovorStacks:Array = new Array();
      
      private var _rightArrow:GlowArrow;
      
      private var views:ViewButtons;
      
      private var _blueSpikeTotal:int = 0;
      
      private var _currentMode:String;
      
      public function DeviceSwarmContainer(param1:ICharacterAssetTypeCache, param2:INanovorFactory, param3:IPlayerFactory, param4:IEvoManager, param5:IBadgeManager, param6:IEMManager, param7:IUserProfile)
      {
         super();
         createMainContainerAndMask();
         createPrimarySpotlightAndText();
         createViewButtonsAndButtons();
         createSpikeBoard();
         _characterAssetTypeCache = param1;
         _nanovorFactory = param2;
         _playerFactory = param3;
         _evoManager = param4;
         _badgeManager = param5;
         _emManager = param6;
         _userProfile = param7;
      }
      
      private function killAllSpotlightAnimations() : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightOpened);
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightFirstChaserEnd);
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightSecondChaserEnd);
         _primarySpotlight.killChasers();
      }
      
      public function open() : void
      {
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onSpotlightOpened);
         _primarySpotlight.open();
      }
      
      public function addCandidate() : void
      {
         var _loc1_:Object = null;
         if(_candidateNanovorStack != null)
         {
            _candidateNanovorStack.actionPicker.addClickToRemove();
            Tweener.removeTweens(_candidateNanovorStack.nanovorLoader,"alpha");
            Tweener.addTween(_candidateNanovorStack.nanovorLoader,{
               "alpha":1,
               "time":0.5
            });
            updateNanovorStackPositions();
            updateSpikeCounts(_candidateNanovorStack.actionPicker.nanovor,true);
            _loc1_ = new Object();
            _loc1_.redSpikes = _redSpikeTotal;
            _loc1_.redSpikedAttacks = _redSpikedAttackTotal;
            _loc1_.yellowSpikes = _yellowSpikeTotal;
            _loc1_.yellowSpikedAttacks = _yellowSpikedAttackTotal;
            _loc1_.blueSpikes = _blueSpikeTotal;
            _loc1_.blueSpikedAttacks = _blueSpikedAttackTotal;
            _spikeBoard.updateBoard(_loc1_);
            _candidateNanovorStack = null;
            _primarySpotlight.closeLight();
            _primarySpotlight.resetChaser();
            Tweener.addTween(_primarySpotlight,{
               "x":NANOVOR_PADDING_H + (ActionSlotComponent.WIDTH * SCALE_MULTIPLIER + NANOVOR_PADDING_H),
               "time":0.5,
               "transition":NANOVOR_TWEEN_TRANSITION,
               "onComplete":resetPrimarySpotlight,
               "rounded":true
            });
         }
      }
      
      private function onSpotlightOpened(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onSpotlightOpened);
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightFirstChaserEnd);
         _primarySpotlight.chaserUp();
         _spotlightText.text = "SELECT AN\nEVO TREE";
         _spotlightText.x = Math.round((ActionSlotComponent.WIDTH * SCALE_MULTIPLIER - _spotlightText.width) / 2 + NANOVOR_PADDING_H);
         Tweener.addTween(_spotlightText,{
            "alpha":1,
            "time":1,
            "onComplete":hideSpotlightText,
            "transition":"easeInOutQuad"
         });
      }
      
      public function destroy() : void
      {
         var ii:int;
         var len:int = 0;
         var i:int = 0;
         var ap:DeviceActionPickerSwarm = null;
         var nl:Loader = null;
         var masker:DisplayObject = null;
         clearSwarm();
         _leftArrow.removeEventListener(MouseEvent.CLICK,onLeftArrowClick);
         _rightArrow.removeEventListener(MouseEvent.CLICK,onRightArrowClick);
         if(_primarySpotlight != null)
         {
            _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightSecondChaserEnd);
            _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightFirstChaserEnd);
            _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_OPENED,onSpotlightOpened);
            _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASERS_KILLED,finishShowSelectNanovor);
         }
         try
         {
            len = int(_actionPickers.length);
            i = 0;
            while(i < len)
            {
               ap = _actionPickers[i];
               ap.removeEventListener(MouseEvent.CLICK,onActionPickerClick);
               ap.destroy();
               _actionPickers[i] = null;
               i++;
            }
         }
         catch(e:Error)
         {
         }
         _actionPickers = [];
         len = int(_nanovorLoaders.length);
         ii = 0;
         while(ii < len)
         {
            nl = _nanovorLoaders[ii];
            nl.contentLoaderInfo.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
            nl.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
            _nanovorLoaders[ii] = null;
            ii++;
         }
         _nanovorLoaders = [];
         if(_mainContainer != null)
         {
            masker = _mainContainer.mask;
            _mainContainer.mask = null;
            removeChild(masker);
            while(_mainContainer.numChildren > 0)
            {
               _mainContainer.removeChildAt(0);
            }
         }
         if(views != null)
         {
            views.destroy();
         }
         if(_arrowsContainer != null)
         {
            while(_arrowsContainer.numChildren > 0)
            {
               _arrowsContainer.removeChildAt(0);
            }
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceSwarmContainer>>\t" + param1);
      }
      
      public function showSelectNanovor() : void
      {
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASERS_KILLED,finishShowSelectNanovor);
         killAllSpotlightAnimations();
         Tweener.removeTweens(_spotlightText,"alpha");
         Tweener.addTween(_spotlightText,{
            "alpha":0,
            "time":0.5,
            "onComplete":hideSpotlightText,
            "transition":"easeInOutQuad"
         });
      }
      
      public function showCandidate(param1:INanovor) : void
      {
         if(null == param1)
         {
            throw new Error("Parameter candidateNanovor cannot be null.");
         }
         hideSpotlightText(true);
         killAllSpotlightAnimations();
         updateMainContainerPosition();
         _primarySpotlight.openLight();
         resetPrimarySpotlight();
         hideCandidate();
         var _loc2_:DeviceActionPickerSwarm = new DeviceActionPickerSwarm(param1,_nanovorFactory,_playerFactory,_evoManager,_badgeManager,_emManager,_userProfile);
         _loc2_.x = Math.round(NANOVOR_PADDING_H);
         _loc2_.addEventListener(MouseEvent.CLICK,onActionPickerClick);
         _actionPickers.push(_loc2_);
         var _loc3_:Loader = new Loader();
         _loc3_.x = Math.round(NANOVOR_PADDING_H + NANOVOR_HOLDER_OFFSET);
         _loc3_.y = NANOVOR_Y;
         _loc3_.alpha = 0;
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,onNanovorLoadComplete,false,0,true);
         _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError,false,0,true);
         _loc3_.load(new URLRequest(getCharacterIdleURL(param1.assetTypeId)));
         _nanovorLoaders.push(_loc3_);
         _loc3_.scaleX = 0.6 * SCALE_MULTIPLIER;
         _loc3_.scaleY = 0.6 * SCALE_MULTIPLIER;
         if(param1.isFacingRight)
         {
            _loc3_.scaleX = -_loc3_.scaleX;
         }
         _mainContainer.addChild(_loc3_);
         _mainContainer.addChild(_loc2_);
         _candidateNanovorStack = new NanovorStack(_loc2_,_loc3_);
         _nanovorStacks.push(_candidateNanovorStack);
         _swarmStackDict[_loc2_] = _candidateNanovorStack;
         Tweener.addTween(_loc3_,{
            "alpha":0.5,
            "time":0.5,
            "transition":NANOVOR_TWEEN_TRANSITION
         });
         _loc2_.mode = _currentMode;
         _loc2_.colorScheme = ActionPickerSwarm.COLOR_SCHEME_GREEN;
         _loc2_.open();
         _loc2_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
      }
      
      private function getCharacterIdleURL(param1:int) : String
      {
         return _characterAssetTypeCache.getCharacterAnimationURL(CharacterAnimationAssetType.IDLE,param1).url;
      }
      
      private function updateSpikedAttackCounts(param1:Attack, param2:Boolean) : void
      {
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:* = undefined;
         var _loc11_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(Boolean(param1.conditional))
         {
            _loc8_ = param1.conditional.conditionalName;
            if(_loc8_ == Conditional.MY_RED_SPIKE_IS_SET)
            {
               _loc3_ = true;
               if(param2)
               {
                  ++_redSpikedAttackTotal;
               }
               else
               {
                  --_redSpikedAttackTotal;
               }
            }
            if(_loc8_ == Conditional.MY_YELLOW_SPIKE_IS_SET)
            {
               _loc4_ = true;
               if(param2)
               {
                  ++_yellowSpikedAttackTotal;
               }
               else
               {
                  --_yellowSpikedAttackTotal;
               }
            }
            if(_loc8_ == Conditional.MY_BLUE_SPIKE_IS_SET)
            {
               _loc5_ = true;
               if(param2)
               {
                  ++_blueSpikedAttackTotal;
               }
               else
               {
                  --_blueSpikedAttackTotal;
               }
            }
         }
         var _loc6_:Array = param1.attackStatements;
         var _loc7_:* = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc7_].conditionals;
            _loc10_ = 0;
            while(_loc10_ < _loc9_.length)
            {
               _loc11_ = _loc9_[_loc10_].conditionalName;
               if(_loc11_ == Conditional.MY_RED_SPIKE_IS_SET && !_loc3_)
               {
                  _loc3_ = true;
                  if(param2)
                  {
                     ++_redSpikedAttackTotal;
                  }
                  else
                  {
                     --_redSpikedAttackTotal;
                  }
               }
               if(_loc11_ == Conditional.MY_YELLOW_SPIKE_IS_SET && !_loc4_)
               {
                  _loc4_ = true;
                  if(param2)
                  {
                     ++_yellowSpikedAttackTotal;
                  }
                  else
                  {
                     --_yellowSpikedAttackTotal;
                  }
               }
               if(_loc11_ == Conditional.MY_BLUE_SPIKE_IS_SET && !_loc5_)
               {
                  _loc5_ = true;
                  if(param2)
                  {
                     ++_blueSpikedAttackTotal;
                  }
                  else
                  {
                     --_blueSpikedAttackTotal;
                  }
               }
               _loc10_++;
            }
            _loc7_++;
         }
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
      
      private function removeCandidate() : void
      {
         if(_candidateNanovorStack != null)
         {
            _nanovorStacks.pop();
            _mainContainer.removeChild(_candidateNanovorStack.nanovorLoader);
            _candidateNanovorStack.nanovorLoader.unload();
            _mainContainer.removeChild(_candidateNanovorStack.actionPicker);
            _candidateNanovorStack = null;
         }
      }
      
      public function removeNanovor(param1:DeviceActionPickerSwarm) : void
      {
         var _loc2_:NanovorStack = _swarmStackDict[param1] as NanovorStack;
         _nanovorStacks.splice(_nanovorStacks.indexOf(_loc2_),1);
         _loc2_.actionPicker.close();
         Tweener.addTween(_loc2_.nanovorLoader,{
            "alpha":0,
            "time":0.2,
            "onComplete":finishRemoving,
            "onCompleteParams":[_loc2_],
            "transition":"easeInQuad"
         });
         updateSpikeCounts(param1.nanovor,false);
         var _loc3_:Object = new Object();
         _loc3_.redSpikes = _redSpikeTotal;
         _loc3_.redSpikedAttacks = _redSpikedAttackTotal;
         _loc3_.yellowSpikes = _yellowSpikeTotal;
         _loc3_.yellowSpikedAttacks = _yellowSpikedAttackTotal;
         _loc3_.blueSpikes = _blueSpikeTotal;
         _loc3_.blueSpikedAttacks = _blueSpikedAttackTotal;
         _spikeBoard.updateBoard(_loc3_);
         this.dispatchEvent(new SwarmContainerEvent(SwarmContainerEvent.NANOVOR_REMOVED,_loc2_.actionPicker.nanovor));
      }
      
      private function onActionPickerClick(param1:MouseEvent) : void
      {
         var _loc2_:DeviceActionPickerSwarm = param1.target as DeviceActionPickerSwarm;
         removeNanovor(_loc2_);
      }
      
      public function prepareForWaitScreen() : void
      {
         var nanovorStackIndex:String = null;
         this.mode = _currentMode = MODE_NONE;
         try
         {
            views.visible = false;
            _primarySpotlight.visible = false;
            _spotlightText.visible = false;
         }
         catch(e:Error)
         {
         }
         for(nanovorStackIndex in _nanovorStacks)
         {
            if(_nanovorStacks[nanovorStackIndex].actionPicker != null)
            {
               _nanovorStacks[nanovorStackIndex].actionPicker.removeMouseEvents();
            }
            if(_nanovorStacks[nanovorStackIndex].nanovorLoader != null && _nanovorStacks[nanovorStackIndex].nanovorLoader.content != null)
            {
               _nanovorStacks[nanovorStackIndex].nanovorLoader.content.stop();
            }
         }
      }
      
      public function clearSwarm() : void
      {
         var _loc2_:NanovorStack = null;
         var _loc1_:* = 0;
         while(_loc1_ < _nanovorStacks.length)
         {
            _loc2_ = _nanovorStacks[_loc1_];
            _mainContainer.removeChild(_loc2_.actionPicker);
            _mainContainer.removeChild(_loc2_.nanovorLoader);
            updateNanovorStackPositions();
            _loc1_++;
         }
         _nanovorStacks = new Array();
         _leftArrow.close();
         _rightArrow.close();
         _spikeBoard.resetBoard();
         _redSpikeTotal = 0;
         _redSpikedAttackTotal = 0;
         _yellowSpikeTotal = 0;
         _yellowSpikedAttackTotal = 0;
         _blueSpikeTotal = 0;
         _blueSpikedAttackTotal = 0;
      }
      
      private function createViewButtonsAndButtons() : void
      {
         views = new ViewButtons();
         views.mcViewBG.alpha = 0.5;
         views.y = 20;
         views.x = 16;
         views.mcStats.addChild(new HoloButton(HoloButton.ICON_S,"STATS"));
         views.addEventListenerToMC(views.mcStats,onViewStatsClick);
         views.mcAttacks.addChild(new HoloButton(HoloButton.ICON_A,"ATTACKS"));
         views.addEventListenerToMC(views.mcAttacks,onViewAttacksClick);
         views.mcPedigrees.addChild(new HoloButton(HoloButton.ICON_PEDIGREE,"EVOLUTIONS"));
         views.addEventListenerToMC(views.mcPedigrees,onViewPedigreesClick);
         this.addChild(views);
         _leftArrow = new GlowArrow();
         _leftArrow.x = Math.round((MAIN_CONTAINER_OFFSET - GlowArrow.WIDTH) / 2);
         _leftArrow.y = 320;
         _rightArrow = new GlowArrow();
         _rightArrow.scaleX = -1;
         _rightArrow.x = 1020;
         _rightArrow.y = 320;
         _leftArrow.addEventListener(MouseEvent.CLICK,onLeftArrowClick);
         _rightArrow.addEventListener(MouseEvent.CLICK,onRightArrowClick);
         _arrowsContainer = new Sprite();
         _arrowsContainer.addChild(_leftArrow);
         _arrowsContainer.addChild(_rightArrow);
         this.addChild(_arrowsContainer);
      }
      
      private function createSpikeBoard() : void
      {
         _spikeBoard = new SpikeBoard();
         addChild(_spikeBoard);
         _spikeBoard.x = SPIKEBOARD_X;
         _spikeBoard.y = SPIKEBOARD_Y;
      }
      
      private function onNanovorLoadComplete(param1:Event) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
      }
      
      private function finishShowSelectNanovor(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASERS_KILLED,finishShowSelectNanovor);
         _spotlightText.text = "SELECT\nNANOVOR\nFOR\nNANOSCOPE";
         _spotlightText.x = Math.round((ActionSlotComponent.WIDTH * SCALE_MULTIPLIER - _spotlightText.width) / 2 + NANOVOR_PADDING_H);
         Tweener.removeTweens(_spotlightText,"alpha");
         Tweener.addTween(_spotlightText,{
            "alpha":1,
            "time":1,
            "onComplete":hideSpotlightText,
            "transition":"easeInOutQuad"
         });
         _primarySpotlight.chaserDown();
      }
      
      private function onSpotlightFirstChaserEnd(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightFirstChaserEnd);
         _primarySpotlight.addEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightSecondChaserEnd);
         _primarySpotlight.chaserUp();
      }
      
      private function onSpotlightSecondChaserEnd(param1:SpotlightEvent) : void
      {
         _primarySpotlight.removeEventListener(SpotlightEvent.SPOTLIGHT_CHASER_END,onSpotlightSecondChaserEnd);
         _primarySpotlight.chaserUp();
      }
      
      public function set mode(param1:String) : void
      {
         var _loc2_:String = null;
         _currentMode = param1;
         for(_loc2_ in _nanovorStacks)
         {
            _nanovorStacks[_loc2_].actionPicker.mode = param1;
         }
         views.mcStats.alpha = VIEW_BUTTON_INACTIVE_ALPHA;
         views.mcAttacks.alpha = VIEW_BUTTON_INACTIVE_ALPHA;
         views.mcPedigrees.alpha = VIEW_BUTTON_INACTIVE_ALPHA;
         switch(_currentMode)
         {
            case MODE_ATTACKS:
               views.mcAttacks.alpha = 1;
               break;
            case MODE_STATS:
               views.mcStats.alpha = 1;
               break;
            case MODE_PEDIGREE:
               views.mcPedigrees.alpha = 1;
         }
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
            "time":NANOVOR_TWEEN_SECONDS,
            "transition":NANOVOR_TWEEN_TRANSITION,
            "rounded":true
         });
         if(_loc2_ >= MAIN_CONTAINER_OFFSET)
         {
            _leftArrow.close();
         }
      }
      
      private function updateMainContainerPosition() : void
      {
         var _loc1_:int = _nanovorStacks.length + 1;
         _calculatedMainContainerWidth = _loc1_ * ActionSlotComponent.WIDTH * SCALE_MULTIPLIER + (_loc1_ - 1) * NANOVOR_PADDING_H + NANOVOR_PADDING_H;
         Tweener.removeTweens(_mainContainer,"x");
         Tweener.addTween(_mainContainer,{
            "x":MAIN_CONTAINER_OFFSET,
            "time":NANOVOR_TWEEN_SECONDS,
            "transition":NANOVOR_TWEEN_TRANSITION,
            "rounded":true
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
      
      private function createPrimarySpotlightAndText() : void
      {
         _primarySpotlight = new Spotlight();
         _primarySpotlight.color = Spotlight.RING_COLOR_YELLOW;
         _primarySpotlight.x = Math.round(NANOVOR_PADDING_H);
         _primarySpotlight.y = SPOTLIGHT_Y;
         _mainContainer.addChild(_primarySpotlight);
         _primarySpotlight.chaserMaskType = Spotlight.CHASER_MASK_INIT;
         _primarySpotlight.color = Spotlight.RING_COLOR_GREEN;
         _spotlightText = new SpotlightText();
         _spotlightText.alpha = 0;
         _spotlightText.y = 15;
         _mainContainer.addChild(_spotlightText);
      }
      
      private function onNanovorLoadError(param1:IOErrorEvent) : void
      {
         param1.target.removeEventListener(Event.COMPLETE,onNanovorLoadComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,onNanovorLoadError);
         throw new Error("Nanovor SWF failed to load");
      }
      
      private function onPrimarySpotlightReset() : void
      {
         if(isSwarmFull)
         {
            _spotlightText.text = "NANOSCOPE\nIS FULL";
            _spotlightText.x = Math.round((ActionSlotComponent.WIDTH * SCALE_MULTIPLIER - _spotlightText.width) / 2 + NANOVOR_PADDING_H);
            Tweener.addTween(_spotlightText,{
               "alpha":1,
               "time":1,
               "transition":"easeInOutQuad"
            });
         }
         else
         {
            _primarySpotlight.openLight();
         }
         dispatchEvent(new Event(SPOTLIGHT_OPEN,false));
      }
      
      public function hideCandidate() : void
      {
         removeCandidate();
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
            "time":NANOVOR_TWEEN_SECONDS,
            "transition":NANOVOR_TWEEN_TRANSITION,
            "rounded":true
         });
         if(_calculatedMainContainerWidth - WIDTH + NANOVOR_PADDING_H + _loc2_ - MAIN_CONTAINER_OFFSET <= 3)
         {
            _rightArrow.close();
         }
      }
      
      private function resetPrimarySpotlight() : void
      {
         Tweener.removeTweens(_primarySpotlight,"x");
         Tweener.addTween(_primarySpotlight,{
            "x":NANOVOR_PADDING_H,
            "time":SPOTLIGHT_RESET_SECONDS,
            "transition":NANOVOR_TWEEN_TRANSITION,
            "onComplete":onPrimarySpotlightReset,
            "rounded":true
         });
      }
      
      private function onViewStatsClick(param1:MouseEvent) : void
      {
         _currentMode = MODE_STATS;
         this.mode = _currentMode;
      }
      
      public function swarmIsNotFull() : void
      {
         isSwarmFull = false;
         hideSpotlightText(true);
         _primarySpotlight.openLight();
      }
      
      private function updateSpikeCounts(param1:INanovor, param2:Boolean) : void
      {
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc3_:Array = param1.attacks;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            updateSpikedAttackCounts(_loc3_[_loc4_],param2);
            _loc5_ = _loc3_[_loc4_].attackStatements;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc7_ = _loc5_[_loc6_].stat.toLowerCase();
               if(_loc7_ == "redspike")
               {
                  if(param2)
                  {
                     ++_redSpikeTotal;
                     break;
                  }
                  --_redSpikeTotal;
                  break;
               }
               if(_loc7_ == "yellowspike")
               {
                  if(param2)
                  {
                     ++_yellowSpikeTotal;
                     break;
                  }
                  --_yellowSpikeTotal;
                  break;
               }
               if(_loc7_ == "bluespike")
               {
                  if(param2)
                  {
                     ++_blueSpikeTotal;
                     break;
                  }
                  --_blueSpikeTotal;
                  break;
               }
               _loc6_++;
            }
            _loc4_++;
         }
      }
      
      private function onViewPedigreesClick(param1:MouseEvent) : void
      {
         _currentMode = MODE_PEDIGREE;
         this.mode = _currentMode;
      }
      
      public function swarmIsFull() : void
      {
         isSwarmFull = true;
      }
      
      private function onViewAttacksClick(param1:MouseEvent) : void
      {
         _currentMode = MODE_ATTACKS;
         this.mode = _currentMode;
      }
      
      private function finishRemoving(param1:NanovorStack) : void
      {
         _mainContainer.removeChild(param1.actionPicker);
         _mainContainer.removeChild(param1.nanovorLoader);
         updateNanovorStackPositions();
      }
      
      private function updateNanovorStackPositions() : void
      {
         var _loc1_:NanovorStack = null;
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
               Tweener.removeTweens(_loc1_.nanovorLoader,"x");
               Tweener.addTween(_loc1_.actionPicker,{
                  "x":_loc4_,
                  "time":NANOVOR_TWEEN_SECONDS,
                  "transition":NANOVOR_TWEEN_TRANSITION
               });
               Tweener.addTween(_loc1_.nanovorLoader,{
                  "x":_loc4_ + NANOVOR_HOLDER_OFFSET,
                  "time":NANOVOR_TWEEN_SECONDS,
                  "transition":NANOVOR_TWEEN_TRANSITION,
                  "rounded":true
               });
            }
            _loc2_++;
         }
         updateMainContainerPosition();
      }
      
      private function hideSpotlightText(param1:Boolean = false) : void
      {
         if(param1)
         {
            Tweener.addTween(_spotlightText,{
               "alpha":0,
               "time":0.25,
               "transition":"easeInOutQuad"
            });
         }
         else
         {
            Tweener.addTween(_spotlightText,{
               "alpha":0,
               "time":1,
               "transition":"easeInOutQuad"
            });
         }
      }
   }
}

import flash.display.Loader;

class NanovorStack
{
   
   public var actionPicker:DeviceActionPickerSwarm;
   
   public var nanovorLoader:Loader;
   
   public function NanovorStack(param1:DeviceActionPickerSwarm, param2:Loader)
   {
      super();
      actionPicker = param1;
      nanovorLoader = param2;
   }
}
