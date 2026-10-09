package com.arkadium.virmon.battle.substates.swarmchooser
{
   import caurina.transitions.Tweener;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.components.TargetReticle;
   import com.arkadium.virmon.battle.control.Attack;
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.shared.components.infowindow.InfoWindowPedigree;
   import com.arkadium.virmon.shared.data.AttackPreviewGenerator;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.overrides.OverrideStat;
   import com.arkadium.virmon.shared.final.components.actionslot.ActionSlotComponent;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindowStats;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindowTitle;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class ActionPickerSwarm extends Sprite
   {
      
      public static const WIDTH:int = 180;
      
      public static const COLOR_SCHEME_BLUE:String = "blue";
      
      public static const COLOR_SCHEME_GREEN:String = "green";
      
      private static const FADE_TIME_SECONDS:Number = 0.5;
      
      private static const CLICK_REMOVE_TWEEN_SECONDS:Number = 2;
      
      private static const GENERAL_TWEEN_SECONDS:Number = 0.5;
      
      private static const CASCADE_STAGGER_SECONDS:Number = 0.04;
      
      private static const INFO_WINDOW_TITLE_FILTER:DropShadowFilter = new DropShadowFilter(4,135,0,0.6,4,6);
      
      private var _infoWindowStats:InfoWindowStats;
      
      private var _clickToRemove:TargetReticle;
      
      private var _infoWindowPedigree:InfoWindowPedigree;
      
      private var _actionSlots:Array;
      
      private var _nanovor:INanovor;
      
      private var _hoverArea:Sprite;
      
      private var _attacksContainer:Sprite;
      
      protected var _infoWindowTitle:InfoWindowTitle;
      
      private var _currentMode:String;
      
      public function ActionPickerSwarm(param1:INanovor, param2:INanovorFactory, param3:IPlayerFactory, param4:IEvoManager, param5:IBadgeManager, param6:IEMManager, param7:IUserProfile)
      {
         var _loc8_:ActionSlotComponent = null;
         var _loc9_:Attack = null;
         var _loc10_:Array = null;
         var _loc11_:AttackStatement = null;
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:IPlayer = null;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         _attacksContainer = new Sprite();
         super();
         _nanovor = param1;
         _actionSlots = new Array();
         _attacksContainer.mouseChildren = false;
         _attacksContainer.alpha = 0;
         this.addChild(_attacksContainer);
         this.mode = SwarmContainer.MODE_ATTACKS;
         this.alpha = 0;
         this.mouseChildren = false;
         createInfoWindow(param1,param2,param4,param5,param6,param7);
         _loc16_ = 0;
         while(_loc16_ < param1.attacks.length)
         {
            _loc9_ = param1.attacks[_loc16_];
            _loc8_ = new ActionSlotComponent(_loc9_);
            _loc8_.title = _loc9_.name;
            _loc8_.energyCost = _loc9_.cost;
            if(_loc9_.actionIconType == Icon.ACTION_OVERRIDE)
            {
               _loc20_ = OverrideStat.statIndexesFromAttackStatements(_loc9_.attackStatements);
               _loc8_.actionIcon = [_loc9_.actionIconType,_loc20_];
            }
            else
            {
               _loc8_.actionIcon = _loc9_.actionIconType;
            }
            _loc8_.y = ActionSlotComponent.HEIGHT * _loc16_;
            _loc18_ = param3.createPlayer(param7.screenname,param7.id);
            param1.owner = _loc18_;
            _loc18_.swarmSize = 1;
            _loc18_.selectedNanovor = param1;
            AttackPreviewGenerator.GenerateSelectedNanovorPreview(true,_loc18_,[]);
            _loc12_ = _loc18_.baseAttackPreviews[String(param1.assetId)][String(_loc9_.attackID)].players["0"];
            for(_loc19_ in _loc12_)
            {
               _loc8_.addIcon(_loc19_,_loc12_[_loc19_].delta,_loc12_[_loc19_].type);
            }
            _attacksContainer.addChild(_loc8_);
            _actionSlots.push(_loc8_);
            _loc16_++;
         }
         resetActionSlots();
         createHoverArea();
      }
      
      public function removeMouseEvents() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,onHoverRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,onHoverRollOut);
      }
      
      public function set mode(param1:String) : void
      {
         _currentMode = param1;
         reloadInfo();
      }
      
      private function closeStats() : void
      {
         Tweener.removeTweens(_infoWindowStats,"alpha");
         Tweener.addTween(_infoWindowStats,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      public function open() : void
      {
         this.mouseEnabled = true;
         Tweener.removeTweens(this,"alpha");
         Tweener.addTween(this,{
            "alpha":1,
            "time":FADE_TIME_SECONDS
         });
      }
      
      private function createHoverArea() : void
      {
         _hoverArea = new Sprite();
         _hoverArea.graphics.beginFill(16711680,0);
         _hoverArea.graphics.drawRect(0,200,ActionSlotComponent.WIDTH,200);
         _hoverArea.graphics.endFill();
         this.addChild(_hoverArea);
         this.hitArea = _hoverArea;
      }
      
      private function closeAttacks() : void
      {
         Tweener.removeTweens(_attacksContainer,"alpha");
         Tweener.addTween(_attacksContainer,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      public function set colorScheme(param1:String) : void
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case COLOR_SCHEME_BLUE:
               _infoWindowTitle.colorScheme = InfoWindowTitle.COLOR_SCHEME_BLUE;
               _loc2_ = ActionSlotComponent.BACKGROUND_COLOR_BLUE;
               break;
            case COLOR_SCHEME_GREEN:
               _infoWindowTitle.colorScheme = InfoWindowTitle.COLOR_SCHEME_GREEN;
               _loc2_ = ActionSlotComponent.BACKGROUND_COLOR_GREEN;
         }
         var _loc3_:* = 0;
         while(_loc3_ < _actionSlots.length)
         {
            _actionSlots[_loc3_].color = _loc2_;
            _loc3_++;
         }
      }
      
      private function createInfoWindow(param1:INanovor, param2:INanovorFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile) : void
      {
         _infoWindowTitle = new InfoWindowTitle();
         _infoWindowTitle.x = 26;
         _infoWindowTitle.nanovorName = param1.name;
         _infoWindowTitle.nanovorNickName = param1.safeNickName;
         switch(param1.faction)
         {
            case NanovorFaction.MAGNAMOD:
               _infoWindowTitle.faction = Icon.FACTION_MAGNAMOD;
               break;
            case NanovorFaction.VELOCITRON:
               _infoWindowTitle.faction = Icon.FACTION_VELOCITRON;
               break;
            case NanovorFaction.HEXITE:
               _infoWindowTitle.faction = Icon.FACTION_HEXITE;
         }
         _infoWindowTitle.sv = param1.swarmValue;
         _infoWindowTitle.y = ActionSlotComponent.HEIGHT * 4 + 10;
         _infoWindowTitle.filters = [INFO_WINDOW_TITLE_FILTER];
         this.addChild(_infoWindowTitle);
         _infoWindowStats = new InfoWindowStats();
         _infoWindowStats.x = 54;
         _infoWindowStats.y = 50;
         _infoWindowStats.alpha = 0;
         this.addChild(_infoWindowStats);
         _infoWindowStats.baseStrength = param1.strength;
         _infoWindowStats.baseArmor = param1.armor;
         _infoWindowStats.baseSpeed = param1.speed;
         _infoWindowStats.strength = param1.strength;
         _infoWindowStats.armor = param1.armor;
         _infoWindowStats.speed = param1.speed;
         _infoWindowStats.setHealth(param1.health,param1.health);
         _infoWindowStats.buffedArmor = param1.baseArmor > param1.virmonMasterData.getBaseArmor();
         _infoWindowStats.buffedSpeed = param1.baseSpeed > param1.virmonMasterData.getBaseSpeed();
         _infoWindowStats.buffedStrength = param1.baseStrength > param1.virmonMasterData.getBaseStrength();
         _infoWindowStats.mcHealthBar.buffedHealth = param1.baseHealth > param1.virmonMasterData.getBaseHealth();
         _infoWindowPedigree = new InfoWindowPedigree();
         _infoWindowPedigree.x = 0;
         _infoWindowPedigree.y = 0;
         _infoWindowPedigree.alpha = 0;
         this.addChild(_infoWindowPedigree);
         _infoWindowPedigree.init(param1,param2,param3,param4,param5,param6);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> ActionPickerSwarm: " + param1);
      }
      
      private function closePedigree() : void
      {
         Tweener.removeTweens(_infoWindowPedigree,"alpha");
         Tweener.addTween(_infoWindowPedigree,{
            "alpha":0,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      private function resetActionSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = _attacksContainer.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Tweener.removeTweens(_attacksContainer.getChildAt(_loc1_),"alpha");
            _attacksContainer.getChildAt(_loc1_).alpha = 0;
            _loc1_++;
         }
      }
      
      private function openStats() : void
      {
         Tweener.removeTweens(_infoWindowStats,"alpha");
         Tweener.addTween(_infoWindowStats,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** ActionPickerSwarm: " + param1);
      }
      
      public function get nanovor() : INanovor
      {
         return _nanovor;
      }
      
      private function reloadInfo() : void
      {
         switch(_currentMode)
         {
            case SwarmContainer.MODE_ATTACKS:
               openAttack();
               closeStats();
               closePedigree();
               break;
            case SwarmContainer.MODE_STATS:
               openStats();
               closeAttacks();
               closePedigree();
               break;
            case SwarmContainer.MODE_PEDIGREE:
               openPedigree();
               closeStats();
               closeAttacks();
               break;
            case SwarmContainer.MODE_NONE:
               closeStats();
               closeAttacks();
               closePedigree();
         }
      }
      
      public function addClickToRemove() : void
      {
         _clickToRemove = new TargetReticle();
         _clickToRemove.x = ActionSlotComponent.WIDTH / 2;
         _clickToRemove.y = 330;
         this.addChild(_clickToRemove);
         _clickToRemove.ctaMessage = TargetReticle.CTA_REMOVE;
         _clickToRemove.color = TargetReticle.TARGET_RETICLE_COLOR_RED;
         _clickToRemove.visible = false;
         addEventListener(MouseEvent.ROLL_OVER,onHoverRollOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,onHoverRollOut,false,0,true);
      }
      
      private function onHoverRollOver(param1:MouseEvent) : void
      {
         _clickToRemove.visible = true;
      }
      
      private function openPedigree() : void
      {
         Tweener.removeTweens(_infoWindowPedigree,"alpha");
         Tweener.addTween(_infoWindowPedigree,{
            "alpha":1,
            "time":GENERAL_TWEEN_SECONDS
         });
      }
      
      private function openAttack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(_attacksContainer.alpha == 1)
         {
            _loc2_ = _attacksContainer.numChildren;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _attacksContainer.getChildAt(_loc1_).alpha = 1;
               _loc1_++;
            }
            return;
         }
         resetActionSlots();
         Tweener.removeTweens(_attacksContainer,"alpha");
         _attacksContainer.alpha = 1;
         cascadeOpenAttacks();
      }
      
      private function onHoverRollOut(param1:MouseEvent) : void
      {
         _clickToRemove.visible = false;
      }
      
      public function close() : void
      {
         this.mouseEnabled = false;
         Tweener.removeTweens(this,"alpha");
         Tweener.addTween(this,{
            "alpha":0,
            "time":FADE_TIME_SECONDS
         });
      }
      
      public function destroy() : void
      {
         if(Boolean(_infoWindowStats))
         {
            _infoWindowStats.destroy();
         }
         _infoWindowStats = null;
      }
      
      private function cascadeOpenAttacks() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = _attacksContainer.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            Tweener.addTween(_attacksContainer.getChildAt(_loc1_),{
               "alpha":1,
               "time":GENERAL_TWEEN_SECONDS,
               "delay":_loc1_ * CASCADE_STAGGER_SECONDS
            });
            _loc1_++;
         }
      }
   }
}

