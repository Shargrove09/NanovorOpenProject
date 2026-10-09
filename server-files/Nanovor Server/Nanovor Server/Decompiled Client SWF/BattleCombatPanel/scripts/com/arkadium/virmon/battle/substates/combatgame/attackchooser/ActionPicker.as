package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.TargetReticle;
   import com.arkadium.virmon.battle.control.Attack;
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.overrides.OverrideStat;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotWithRollout;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Bitmap;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ActionPicker extends Sprite implements IActionPickerAutomation
   {
      
      public static const HEIGHT:Number = 620;
      
      public static const NANOVOR_HEIGHT:Number = 230;
      
      private static const ACTION_SLOT_CASCADE_TWEEN_SECONDS:Number = 0.05;
      
      private static const FADE_TIME_SECONDS:Number = 0.5;
      
      private static const CONFIRM_RETICLE_Y:Number = 540;
      
      private static const CONFIRM_HIT_AREA_Y:Number = 440;
      
      private static const CONFIRM_HIT_AREA_HEIGHT:Number = 180;
      
      private static const ACTION_SLOT_FADE_SECONDS:Number = 1;
      
      protected var _player:IPlayer;
      
      private var _overlays:Sprite;
      
      private var _selectedActionSlot:ActionSlotComponent = null;
      
      private var _bReticleInView:Boolean = false;
      
      protected var _attackActionSlotContainer:Sprite;
      
      protected var _actionSlotContainer:Sprite;
      
      private var _spotlight:Spotlight;
      
      private var _iFrameCounter:int = 0;
      
      protected var _aActionSlots:Array = new Array();
      
      private var _enemyPositions:Array;
      
      protected var _passActionSlot:ActionSlotComponent;
      
      protected var _nanovor:INanovor = null;
      
      protected var _confirmReticle:TargetReticle;
      
      protected var _aAttackActionSlots:Array = new Array();
      
      private var _characterContainer:Sprite;
      
      protected var _nanovorHitArea:Sprite;
      
      private var _soundManager:ISoundManager;
      
      private var _confirmHitArea:Sprite;
      
      public function ActionPicker(param1:ISoundManager, param2:IPlayer, param3:Spotlight = null, param4:Array = null)
      {
         super();
         _soundManager = param1;
         _player = param2;
         _enemyPositions = param4;
         _characterContainer = new Sprite();
         _characterContainer.x = 15;
         _characterContainer.y = 490;
         addChild(_characterContainer);
         _spotlight = param3;
         _actionSlotContainer = new Sprite();
         _attackActionSlotContainer = new Sprite();
         _actionSlotContainer.addChild(_attackActionSlotContainer);
         this.addChild(_actionSlotContainer);
         _overlays = new Sprite();
         this.addChild(_overlays);
         _overlays.mouseEnabled = false;
         _overlays.mouseChildren = false;
         createHitAreas();
         _confirmReticle = new TargetReticle();
         _confirmReticle.stopAnimation();
         _confirmReticle.mouseChildren = false;
         _confirmReticle.mouseEnabled = false;
         _confirmReticle.y = CONFIRM_RETICLE_Y;
         _confirmReticle.x = ActionSlotComponent.WIDTH / 2;
         _confirmReticle.visible = false;
         _overlays.addChild(_confirmReticle);
      }
      
      protected function onNanovorRollOut(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionPickerEvent(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OUT,this));
      }
      
      private function onActionSlotRollOut(param1:MouseEvent) : void
      {
         var _loc2_:ActionSlotWithRollout = param1.target as ActionSlotWithRollout;
         _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
         _loc2_.closeConsequences(_enemyPositions);
         _loc2_.close();
      }
      
      private function onCharacterTweenOutComplete() : void
      {
         while(_characterContainer.numChildren > 0)
         {
            _characterContainer.removeChildAt(0);
         }
         _characterContainer.visible = false;
      }
      
      public function destroy() : void
      {
         clearDisplay();
         if(Boolean(_nanovorHitArea))
         {
            _nanovorHitArea.removeEventListener(MouseEvent.CLICK,onNanovorClick);
            _nanovorHitArea.removeEventListener(MouseEvent.ROLL_OVER,onNanovorRollOver);
            _nanovorHitArea.removeEventListener(MouseEvent.ROLL_OUT,onNanovorRollOut);
         }
      }
      
      public function autoSlotRollOut(param1:int) : void
      {
         _aAttackActionSlots[param1].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
      }
      
      public function set showConfirm(param1:Boolean) : void
      {
         log("showConfirm: bShowConfirm=" + param1);
         _bReticleInView = param1;
         _confirmReticle.reset();
         _nanovorHitArea.buttonMode = param1;
         _confirmReticle.visible = param1;
         if(param1)
         {
            _nanovorHitArea.addEventListener(MouseEvent.CLICK,onNanovorClick,false,0,true);
         }
         else
         {
            _confirmReticle.stopAnimation();
            _nanovorHitArea.removeEventListener(MouseEvent.CLICK,onNanovorClick);
         }
      }
      
      public function set showActions(param1:Boolean) : void
      {
         _actionSlotContainer.visible = param1;
         var _loc2_:int = 0;
         while(_loc2_ < _aActionSlots.length)
         {
            _aActionSlots[_loc2_].alpha = 0;
            _loc2_++;
         }
      }
      
      protected function loadHasselhoff() : void
      {
         while(_characterContainer.numChildren > 0)
         {
            _characterContainer.removeChildAt(0);
         }
         _characterContainer.visible = true;
         _iFrameCounter = 0;
         var _loc1_:UnknownNanovorSpinner = new UnknownNanovorSpinner();
         _loc1_.x = 5;
         _loc1_.y = -48;
         _characterContainer.addChild(_loc1_);
      }
      
      public function get hasTargetInView() : Boolean
      {
         return _bReticleInView;
      }
      
      private function onPassRollOver(param1:MouseEvent) : void
      {
         var _loc2_:ActionSlotComponent = param1.target as ActionSlotComponent;
         _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_SOLID;
      }
      
      protected function onLoadHasselhoffError(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,onLoadHasselhoffComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,onLoadHasselhoffError);
         logError("hasselhoff load error: " + param1.text);
         var _loc3_:TextField = new TextField();
         _loc3_.textColor = 16777215;
         _loc3_.text = "????????????????????\n\n????????????????????\n\n????????????????????\n\n";
         _loc3_.y = 150;
         _characterContainer.addChild(_loc3_);
      }
      
      private function onActionSlotRollOver(param1:MouseEvent) : void
      {
         var _loc2_:ActionSlotWithRollout = param1.target as ActionSlotWithRollout;
         _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_SOLID;
         _loc2_.openConsequences(_nanovor,_enemyPositions);
         _loc2_.open();
      }
      
      protected function onLoadHasselhoffComplete(param1:Event) : void
      {
         log("onLoadHasselhoffComplete: " + _player.username);
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,onLoadHasselhoffComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,onLoadHasselhoffError);
         var _loc3_:Bitmap = _loc2_.content as Bitmap;
         _characterContainer.addChild(_loc3_);
         _loc3_.x += 5;
         _loc3_.y -= 25;
      }
      
      protected function logError(param1:String) : void
      {
         DebugLog.instance.error("** ActionPicker: " + param1);
      }
      
      public function updateSwarm() : void
      {
         log("updateSwarm");
         if(_nanovor != null)
         {
            clearDisplay();
         }
         if(_player.selectedNanovor != null)
         {
            log(" .....  current stat index on [" + _player.username + "][" + _player.selectedNanovor.name + "/" + _player.selectedNanovor.assetId + "] = " + _player.selectedNanovor.statIndex + "/" + _player.selectedNanovor.statHistory.length);
         }
         setNanovor(_player.selectedNanovor);
         if(_player.selectedNanovor != null)
         {
            log(_player.selectedNanovor.health.toString());
         }
      }
      
      public function clearDisplay() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:ActionSlotComponent = null;
         log("clearDisplay");
         _loc1_ = 0;
         while(_loc1_ < _aAttackActionSlots.length)
         {
            _loc2_ = _aAttackActionSlots[_loc1_];
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,onActionSlotRollOver);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,onActionSlotRollOut);
            _loc2_.removeEventListener(MouseEvent.CLICK,onActionSlotClick);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _aActionSlots.length)
         {
            _loc3_ = _aActionSlots[_loc1_];
            _loc3_.removeEventListener(MouseEvent.ROLL_OVER,onPassRollOver);
            _loc3_.removeEventListener(MouseEvent.ROLL_OUT,onPassRollOut);
            _loc3_.removeEventListener(MouseEvent.CLICK,onPassClick);
            _loc1_++;
         }
         _nanovor = null;
         while(_attackActionSlotContainer.numChildren > 0)
         {
            _attackActionSlotContainer.removeChildAt(0);
         }
         while(_actionSlotContainer.numChildren > 1)
         {
            _actionSlotContainer.removeChildAt(1);
         }
         _aActionSlots = new Array();
         _aAttackActionSlots = new Array();
         clearCharacter();
      }
      
      private function onActionSlotClick(param1:MouseEvent) : void
      {
         var _loc4_:int = 0;
         log("onActionSlotClick()");
         var _loc2_:ActionSlotComponent = param1.target as ActionSlotComponent;
         var _loc3_:ActionSlotWithRollout = null;
         if(Boolean(param1.target as ActionSlotWithRollout))
         {
            _loc3_ = param1.target as ActionSlotWithRollout;
         }
         if(Boolean(_loc3_) && _loc3_.disabled)
         {
            return;
         }
         if(_selectedActionSlot != _loc2_)
         {
            if(_loc3_ == null)
            {
               _loc4_ = 0;
               _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_SOLID;
               _loc2_.color = ActionSlotComponent.BACKGROUND_COLOR_RED;
            }
            else
            {
               _loc4_ = int(_loc3_.attack.attackID);
               _loc3_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_SOLID;
               _loc3_.color = ActionSlotComponent.BACKGROUND_COLOR_RED;
               _loc3_.stayOpen = true;
               _loc3_.consequenceSlotsColor = ActionSlotComponent.BACKGROUND_COLOR_RED;
               _loc3_.open();
            }
            _selectedActionSlot = _loc2_;
            resetActionSlots(_selectedActionSlot);
            dispatchEvent(new ActionSelectionEvent(ActionSelectionEvent.ACTION_PICKER_ATTACK_SELECTED,_loc4_));
         }
         else
         {
            resetActionSlots(_selectedActionSlot,true);
            _selectedActionSlot = null;
            _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
            _loc2_.color = ActionSlotComponent.BACKGROUND_COLOR_BLUE;
            dispatchEvent(new ActionSelectionEvent(ActionSelectionEvent.ACTION_PICKER_ATTACK_DESELECTED,-1));
         }
      }
      
      public function openSelectedAttackForConfirm(param1:int) : void
      {
         var _loc2_:ActionSlotWithRollout = _selectedActionSlot as ActionSlotWithRollout;
         if(Boolean(_loc2_))
         {
            _loc2_.stayOpen = true;
            _loc2_.open();
            _loc2_.openConsequencesForTarget(_nanovor,_enemyPositions,param1);
         }
      }
      
      public function update() : void
      {
         var _loc1_:ActionSlotComponent = null;
         for each(_loc1_ in _aAttackActionSlots)
         {
            if(!(_player == null || _loc1_.attack == null))
            {
               if(_loc1_.attack.cost > _player.energyLevel)
               {
                  _loc1_.disabled = true;
               }
               else
               {
                  _loc1_.disabled = false;
               }
            }
         }
      }
      
      public function open(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         log("open (bFadeInstant=" + param1 + ") _nanovor=" + _nanovor);
         dispatchEvent(new ActionPickerEvent(ActionPickerEvent.ACTION_PICKER_OPEN,this));
         if(_nanovor == null)
         {
            opened();
            return;
         }
         if(param1)
         {
            opened();
         }
         else
         {
            _loc3_ = int(_aActionSlots.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               Tweener.removeTweens(_aActionSlots[_loc2_],"alpha");
               _aActionSlots[_loc2_].alpha = 0;
               _aActionSlots[_loc2_].visible = true;
               _loc2_++;
            }
            _actionSlotContainer.visible = true;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               Tweener.addTween(_aActionSlots[_loc2_],{
                  "alpha":1,
                  "time":FADE_TIME_SECONDS,
                  "delay":ACTION_SLOT_CASCADE_TWEEN_SECONDS * _loc2_,
                  "transition":"easeInOutQuad",
                  "onComplete":opened
               });
               _loc2_++;
            }
         }
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> ActionPicker: " + param1);
      }
      
      public function get selectedActionSlot() : ActionSlotComponent
      {
         return _selectedActionSlot;
      }
      
      private function resetActionSlots(param1:ActionSlotComponent = null, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc5_:ActionSlotWithRollout = null;
         var _loc6_:ActionSlotComponent = null;
         var _loc4_:int = int(_aActionSlots.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _aActionSlots[_loc3_];
            if(_loc6_ == param1)
            {
               if(param2 && Boolean(_loc6_ as ActionSlotWithRollout))
               {
                  _loc5_ = _loc6_ as ActionSlotWithRollout;
                  _loc5_.stayOpen = false;
                  _loc5_.color = ActionSlotComponent.BACKGROUND_COLOR_BLUE;
                  _loc5_.consequenceSlotsColor = ActionSlotComponent.BACKGROUND_COLOR_BLUE;
               }
            }
            else if(Boolean(_loc6_ as ActionSlotWithRollout))
            {
               _loc5_ = _loc6_ as ActionSlotWithRollout;
               _loc5_.stayOpen = false;
               _loc5_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
               _loc5_.color = ActionSlotComponent.BACKGROUND_COLOR_BLUE;
               _loc5_.consequenceSlotsColor = ActionSlotComponent.BACKGROUND_COLOR_BLUE;
               _loc5_.closeConsequences(_enemyPositions);
               _loc5_.close();
            }
            else
            {
               _loc6_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
               _loc6_.color = ActionSlotComponent.BACKGROUND_COLOR_BLUE;
            }
            _loc3_++;
         }
      }
      
      public function get spotlight() : Spotlight
      {
         return _spotlight;
      }
      
      protected function createHitAreas() : void
      {
         _nanovorHitArea = new Sprite();
         _nanovorHitArea.graphics.beginFill(65280,0);
         _nanovorHitArea.graphics.drawRect(0,HEIGHT - NANOVOR_HEIGHT,ActionSlotComponent.WIDTH,NANOVOR_HEIGHT);
         _nanovorHitArea.graphics.endFill();
         this.addChild(_nanovorHitArea);
         _nanovorHitArea.addEventListener(MouseEvent.ROLL_OVER,onNanovorRollOver,false,0,true);
         _nanovorHitArea.addEventListener(MouseEvent.ROLL_OUT,onNanovorRollOut,false,0,true);
      }
      
      protected function onNanovorRollOver(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionPickerEvent(ActionPickerEvent.ACTION_PICKER_NANOVOR_ROLL_OVER,this));
      }
      
      public function get characterContainer() : Sprite
      {
         return _characterContainer;
      }
      
      public function get confirmReticle() : TargetReticle
      {
         return _confirmReticle;
      }
      
      public function autoSlotRollOver(param1:int) : void
      {
         _aAttackActionSlots[param1].dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
      }
      
      private function onPassClick(param1:MouseEvent) : void
      {
         onActionSlotClick(param1);
      }
      
      protected function onNanovorClick(param1:MouseEvent) : void
      {
         dispatchEvent(new ActionPickerEvent(ActionPickerEvent.ACTION_PICKER_NANOVOR_CLICK,this));
      }
      
      public function clearCharacter(param1:Number = 0.2) : void
      {
         if(_characterContainer.numChildren > 0)
         {
            Tweener.removeTweens(_characterContainer);
            Tweener.addTween(_characterContainer,{
               "alpha":0,
               "time":0.5,
               "transition":"easeOutQuad",
               "onComplete":onCharacterTweenOutComplete
            });
         }
      }
      
      public function get player() : IPlayer
      {
         return _player;
      }
      
      protected function opened() : void
      {
         log("opened()");
         dispatchEvent(new ActionPickerEvent(ActionPickerEvent.ACTION_PICKER_OPENED,this));
      }
      
      private function disableActionSlot(param1:ActionSlotWithRollout) : void
      {
         if(param1.disabled)
         {
            param1.removeEventListener(MouseEvent.CLICK,onActionSlotClick);
            param1.disabled = true;
         }
      }
      
      private function closed() : void
      {
         dispatchEvent(new ActionPickerEvent(ActionPickerEvent.ACTION_PICKER_CLOSED,this));
      }
      
      public function confirmedSelectedAction(param1:Boolean = false) : void
      {
         var _loc2_:ActionSlotWithRollout = _selectedActionSlot as ActionSlotWithRollout;
         if(Boolean(_loc2_))
         {
            _loc2_.stayOpen = false;
            if(!param1)
            {
               _loc2_.startArrowChaser();
            }
            _loc2_.close();
            _loc2_.closeConsequences(_enemyPositions);
         }
      }
      
      public function setNanovor(param1:INanovor) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ActionSlotWithRollout = null;
         var _loc5_:Attack = null;
         var _loc6_:AttackStatement = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         if(_nanovor != null)
         {
            if(!_nanovor.isDead)
            {
               logError("setNanovor called but nanovor is already set!");
               return false;
            }
            clearDisplay();
         }
         if(param1 == null)
         {
            loadHasselhoff();
            _loc11_ = Boolean(param1 == null);
            _nanovor = param1;
            return _loc11_;
         }
         _nanovor = param1;
         _loc2_ = 0;
         while(_loc2_ < _nanovor.attacks.length)
         {
            _loc5_ = _nanovor.attacks[_loc2_];
            log("setNanovor: [" + _nanovor.name + "], attack [" + _loc2_ + "] (" + _loc5_.name + ") ==> actionIconType=" + _loc5_.actionIconType);
            _loc7_ = _nanovor.owner.baseAttackPreviews[String(_nanovor.assetId)][String(_loc5_.attackID)].players["0"];
            _loc4_ = new ActionSlotWithRollout(_soundManager,_loc5_);
            _loc4_.title = _loc5_.name;
            _loc4_.energyCost = _loc5_.cost;
            _loc4_.y = ActionSlotComponent.HEIGHT * _loc2_;
            if(_loc5_.actionIconType == Icon.ACTION_OVERRIDE)
            {
               _loc13_ = OverrideStat.statIndexesFromAttackStatements(_loc5_.attackStatements);
               _loc4_.actionIcon = [_loc5_.actionIconType,_loc13_];
            }
            else
            {
               _loc4_.actionIcon = _loc5_.actionIconType;
            }
            log(" .... attack.cost=" + _loc5_.cost + ", _nanovor.owner.energyLevel=" + _nanovor.owner.energyLevel + " _nanovor.owner=" + _nanovor.owner);
            if(_loc5_.cost > _nanovor.owner.energyLevel)
            {
               _loc4_.disabled = true;
            }
            else
            {
               _loc4_.disabled = false;
            }
            _loc4_.alpha = 0;
            _loc4_.visible = false;
            _loc4_.addEventListener(MouseEvent.ROLL_OVER,onActionSlotRollOver,false,0,true);
            _loc4_.addEventListener(MouseEvent.ROLL_OUT,onActionSlotRollOut,false,0,true);
            _loc4_.addEventListener(MouseEvent.CLICK,onActionSlotClick,false,0,true);
            for(_loc12_ in _loc7_)
            {
               _loc4_.addIcon(_loc12_,_loc7_[_loc12_].delta,_loc7_[_loc12_].type);
            }
            _attackActionSlotContainer.addChild(_loc4_);
            _aAttackActionSlots.push(_loc4_);
            _loc2_++;
         }
         _passActionSlot = new ActionSlotComponent();
         _passActionSlot.y = _aAttackActionSlots.length * ActionSlotComponent.HEIGHT;
         _passActionSlot.visible = false;
         _passActionSlot.title = "Skip Turn";
         _passActionSlot.hideEnergy();
         _passActionSlot.actionIcon = Icon.ACTION_PASS;
         _actionSlotContainer.addChild(_passActionSlot);
         _passActionSlot.addEventListener(MouseEvent.ROLL_OVER,onPassRollOver,false,0,true);
         _passActionSlot.addEventListener(MouseEvent.ROLL_OUT,onPassRollOut,false,0,true);
         _passActionSlot.addEventListener(MouseEvent.CLICK,onPassClick,false,0,true);
         _aActionSlots = _aAttackActionSlots.slice();
         _aActionSlots.push(_passActionSlot);
         update();
         return true;
      }
      
      public function close() : void
      {
         this.showActions = false;
         _confirmReticle.reset();
         _confirmReticle.visible = false;
         dispatchEvent(new ActionPickerEvent(ActionPickerEvent.ACTION_PICKER_CLOSE,this));
      }
      
      private function onPassRollOut(param1:MouseEvent) : void
      {
         var _loc2_:ActionSlotComponent = param1.target as ActionSlotComponent;
         _loc2_.backgroundState = ActionSlotComponent.BACKGROUND_STATE_OPAQUE;
      }
      
      public function getSlotCount() : int
      {
         return _aAttackActionSlots.length;
      }
      
      private function enabledActionSlot(param1:ActionSlotWithRollout) : void
      {
         if(!param1.disabled)
         {
            param1.removeEventListener(MouseEvent.CLICK,onActionSlotClick);
            param1.disabled = false;
         }
      }
   }
}

