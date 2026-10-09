package com.arkadium.virmon.battle.substates.gameover
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.battle.substates.combatgame.attackchooser.NanovorIcon;
   import com.arkadium.virmon.framework.IBadgeData;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.events.VirmonDataEvent;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.elements.AlertBubble;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   import com.arkadium.virmon.soundmanager.SoundManagerConst;
   import com.arkadium.virmon.soundmanager.SoundManagerEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol42")]
   public class GameOverSlotNanovors extends Sprite
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = false;
      
      private static const DEBUG_ALL_BADGES_NEW:Boolean = true;
      
      public static const HEIGHT:int = 50;
      
      public static const LINE_WIDTH_START:Number = GameOverSlot.WIDTH;
      
      private var _preBattleBadges:Dictionary = new Dictionary(false);
      
      public var mcNanovorContainer:MovieClip;
      
      private var _myPlayer:IPlayer;
      
      private var _openWidth:Number;
      
      private var _postBattleBadges:Dictionary = new Dictionary(false);
      
      public var mcLine:MovieClip;
      
      private var _currentNanovorIcon:NanovorIcon;
      
      private var _allBadges:Dictionary = new Dictionary(false);
      
      public var mcRollout:MovieClip;
      
      public var tfText:TextField;
      
      private var _nanovorLoadBadgeQueue:Array;
      
      private var _nanovorFactory:INanovorFactory;
      
      public var mcHitArea:MovieClip;
      
      private var _roundControllerNanovorChooser:IRoundControllerNanovorChooser;
      
      private var _nanovorIcons:Array = new Array();
      
      private var _alert:AlertBubble;
      
      public var tfTextGlow:TextField;
      
      private var _badgesSlot:GameOverSlotBadgesEmpty;
      
      private var _swarm:Array;
      
      private var _soundManager:ISoundManager;
      
      public function GameOverSlotNanovors(param1:INanovorFactory, param2:ISoundManager, param3:IRoundControllerNanovorChooser, param4:IPlayer, param5:String = "", param6:Number = 800)
      {
         super();
         _nanovorFactory = param1;
         log("GameOverSlotNanovors() - NanovorFactory null? " + Boolean(null == _nanovorFactory));
         _roundControllerNanovorChooser = param3;
         _soundManager = param2;
         _myPlayer = param4;
         _openWidth = param6;
         mcLine.mouseEnabled = false;
         tfTextGlow.visible = false;
         mcLine.y = HEIGHT - 1;
         mcRollout.width = 0;
         mcRollout.mouseEnabled = false;
         mcNanovorContainer.alpha = 0;
         tfText.text = param5;
         tfTextGlow.text = param5;
         mcHitArea.buttonMode = true;
         mcHitArea.useHandCursor = true;
         mcHitArea.addEventListener(MouseEvent.CLICK,onHitAreaClick);
         createAlertBubble();
      }
      
      private function showNanovorContainer() : void
      {
         Tweener.addTween(mcNanovorContainer,{
            "alpha":1,
            "time":0.5
         });
      }
      
      public function set alertNumber(param1:int) : void
      {
         if(param1 > 0)
         {
            _alert.visible = true;
            _alert.number = param1;
         }
      }
      
      public function init(param1:Array) : void
      {
         _swarm = param1;
         log("Swarm Size: " + param1.length);
         fetchPreBattleBadges();
         _nanovorLoadBadgeQueue = param1.slice();
         log("QUEUE LENGTH " + _nanovorLoadBadgeQueue.length);
         nanovorLoadBadgeQueue(null);
      }
      
      private function fetchBadges() : void
      {
         var _loc2_:INanovor = null;
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         var _loc1_:int = 0;
         for each(_loc2_ in _swarm)
         {
            _allBadges[_loc2_] = new Array();
            _loc3_ = 0;
            while(_loc3_ < _postBattleBadges[_loc2_].length)
            {
               _loc4_ = isNewBadge(_preBattleBadges[_loc2_],_postBattleBadges[_loc2_][_loc3_]);
               if(_loc4_)
               {
                  _loc1_++;
               }
               _allBadges[_loc2_].push(new GameOverBadge(_postBattleBadges[_loc2_][_loc3_],_loc4_));
               _loc3_++;
            }
         }
         this.alertNumber = _loc1_;
      }
      
      public function set badgesSlot(param1:GameOverSlotBadgesEmpty) : void
      {
         _badgesSlot = param1;
      }
      
      private function preloadNanovorBadgeError(param1:Event) : void
      {
         logError("Failed to load nanovor badges");
      }
      
      private function fetchPostBattleBadges() : void
      {
         var _loc1_:IVirmonData = null;
         var _loc2_:INanovor = null;
         for each(_loc2_ in _swarm)
         {
            _loc1_ = _nanovorFactory.findNanovorInstanceById(_loc2_.assetId);
            _postBattleBadges[_loc2_] = _loc1_.getBadgeList();
            log("Nanovor assetId = " + _loc2_.assetId + " has " + _preBattleBadges[_loc2_].length + " post-battle badges.");
         }
      }
      
      private function isNewBadge(param1:Array, param2:IBadgeData) : Boolean
      {
         var _loc3_:Boolean = true;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            if(param2.getID() == param1[_loc4_].getID())
            {
               _loc3_ = false;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function onHitAreaClick(param1:MouseEvent) : void
      {
         dispatchEvent(new GameOverSlotColumnEvent(GameOverSlotColumnEvent.NANOVOR_BADGES_CLICK));
      }
      
      private function fetchPreBattleBadges() : void
      {
         var _loc1_:INanovor = null;
         var _loc2_:String = null;
         var _loc3_:IVirmonData = null;
         for each(_loc1_ in _swarm)
         {
            _loc2_ = _loc1_.assetId;
            _loc3_ = _nanovorFactory.findNanovorInstanceById(_loc2_);
            _preBattleBadges[_loc1_] = _loc3_.getBadgeList();
            log("Nanovor assetId = " + _loc1_.assetId + " has " + _preBattleBadges[_loc1_].length + " pre-battle badges.");
         }
      }
      
      public function set textGlow(param1:Boolean) : void
      {
         tfTextGlow.visible = param1;
      }
      
      private function showNanovorBadges(param1:INanovor) : void
      {
         var _loc2_:GameOverBadge = null;
         _myPlayer.selectedNanovor = param1;
         _roundControllerNanovorChooser.chooseNanovor();
         _badgesSlot.slider.clearBadges();
         for each(_loc2_ in _allBadges[param1])
         {
            _badgesSlot.slider.addBadge(_loc2_,_loc2_.isNewBadge);
         }
         _badgesSlot.slider.refresh();
      }
      
      private function nanovorLoadBadgeQueue(param1:Event) : void
      {
         var _loc2_:IVirmonData = null;
         if(param1 != null)
         {
            _loc2_ = param1.target as IVirmonData;
            _loc2_.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,nanovorLoadBadgeQueue);
            _loc2_.removeEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,preloadNanovorBadgeError);
            log("Finished preloading badges for nanovor assetId = " + (param1.target as IVirmonData).getAssetID());
         }
         if(_nanovorLoadBadgeQueue.length == 0)
         {
            log("Finished loading nanovor badges, populating post battle badges");
            populatePostBattleBadges();
            return;
         }
         log("QUEUE LENGTH. POPPING AND LOCKING. " + _nanovorLoadBadgeQueue.length);
         var _loc3_:INanovor = _nanovorLoadBadgeQueue.pop();
         _loc2_ = _nanovorFactory.findNanovorInstanceById(_loc3_.assetId);
         _loc2_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,nanovorLoadBadgeQueue,false,0,true);
         _loc2_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOAD_ERROR,preloadNanovorBadgeError,false,0,true);
         _loc2_.loadBadges();
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">> GameOverSlotNanovors: " + param1);
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<GameOverSlotNanovors>>\t" + param1);
         }
      }
      
      public function open() : void
      {
         _soundManager.animationFxHandler(new SoundManagerEvent(SoundManagerEvent.ANIMATION_FX,"UI_GameOver_BadgeEntry",true,SoundManagerConst.soundApplicationDomain,true));
         if(_nanovorIcons.length > 0 && _currentNanovorIcon == null)
         {
            _nanovorIcons[0].mcHit.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         Tweener.addTween(mcLine,{
            "width":_openWidth,
            "time":0.5
         });
         Tweener.addCaller(this,{
            "onComplete":_badgesSlot.open,
            "time":0,
            "count":1
         });
         Tweener.addTween(mcRollout,{
            "width":_openWidth,
            "time":0.5,
            "onComplete":showNanovorContainer
         });
      }
      
      private function populatePostBattleBadges() : void
      {
         var _loc1_:INanovor = null;
         fetchPostBattleBadges();
         fetchBadges();
         populateNanovorIcons();
      }
      
      private function onNanovorClick(param1:Event) : void
      {
         if(_currentNanovorIcon != null)
         {
            toggleNanovorIconActive(_currentNanovorIcon,false);
         }
         var _loc2_:NanovorIcon = param1.target as NanovorIcon;
         showNanovorBadges(_loc2_.nanovor);
         toggleNanovorIconActive(_loc2_,true);
         _currentNanovorIcon = _loc2_;
      }
      
      private function toggleNanovorIconActive(param1:NanovorIcon, param2:Boolean = false) : void
      {
         if(param2)
         {
            param1.setPlainAlpha(1);
            param1.disableHit();
         }
         else
         {
            param1.setPlainAlpha(0.25);
            param1.enableHit();
         }
      }
      
      private function createAlertBubble() : void
      {
         _alert = new AlertBubble();
         _alert.x = -1 * _alert.width / 2 - 8;
         _alert.y = HEIGHT / 2 - _alert.height / 2;
         _alert.visible = false;
         this.addChild(_alert);
      }
      
      public function close() : void
      {
         Tweener.addTween(mcLine,{
            "width":LINE_WIDTH_START,
            "time":0.5
         });
         Tweener.addCaller(this,{
            "onComplete":_badgesSlot.close,
            "time":0,
            "count":1,
            "delay":0.1
         });
         Tweener.addTween(mcRollout,{
            "width":0,
            "time":0.5
         });
         Tweener.addTween(mcNanovorContainer,{
            "alpha":0,
            "time":0.5
         });
      }
      
      public function destroy() : void
      {
         if(_badgesSlot != null)
         {
            _badgesSlot.destroy();
         }
         mcHitArea.removeEventListener(MouseEvent.CLICK,onHitAreaClick);
         var _loc1_:int = 0;
         while(_loc1_ < _nanovorIcons.length)
         {
            _nanovorIcons[_loc1_].removeEventListener(NanovorIcon.SELECTED,onNanovorClick);
            _nanovorIcons[_loc1_].destroy();
            _loc1_++;
         }
      }
      
      private function populateNanovorIcons() : void
      {
         var _loc1_:INanovor = null;
         var _loc2_:NanovorIcon = null;
         var _loc3_:AlertBubble = null;
         var _loc4_:int = 0;
         while(_loc4_ < _swarm.length)
         {
            _loc1_ = _swarm[_loc4_];
            _loc2_ = new NanovorIcon();
            _loc1_.isDead = false;
            _loc2_.initialize(_loc1_,false,false,true);
            _loc2_.x = _loc4_ * 54;
            mcNanovorContainer.addChild(_loc2_);
            log(_allBadges[_loc1_].length.toString());
            _nanovorIcons.push(_loc2_);
            if(_allBadges[_loc1_].length == 0)
            {
               toggleNanovorIconActive(_loc2_,false);
               _loc2_.disableHit();
            }
            else
            {
               log("Applying listener to NanovorIcon");
               toggleNanovorIconActive(_loc2_,true);
               _loc2_.enableHit();
               _loc2_.addEventListener(NanovorIcon.SELECTED,onNanovorClick,false,0,true);
            }
            _loc3_ = new AlertBubble(_allBadges[_loc1_].length);
            _loc4_++;
         }
      }
   }
}

