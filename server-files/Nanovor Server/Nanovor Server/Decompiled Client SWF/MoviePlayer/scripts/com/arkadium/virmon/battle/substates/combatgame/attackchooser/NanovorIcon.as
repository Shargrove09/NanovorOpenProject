package com.arkadium.virmon.battle.substates.combatgame.attackchooser
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.asset.enum.CharacterChipAssetType;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionHexite;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionMagnamod;
   import com.arkadium.virmon.shared.elements.icons.factions.FactionVelocitron;
   import com.arkadium.virmon.shared.final.elements.CondensedTextCenter;
   import com.arkadium.virmon.shared.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.AdjustColor;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.net.URLRequest;
   import flash.utils.Timer;
   
   public class NanovorIcon extends Sprite
   {
      
      public static const LOADED:String = "NanovorIcon::Loaded";
      
      public static const SELECTED:String = "NanovorIcon::Selected";
      
      public static const ROLL_OVER:String = "NanovorIcon::RollOver";
      
      public static const ROLL_OUT:String = "NanovorIcon::RollOut";
      
      private static const ASSET_OFFSET_X:int = -21;
      
      private static const ASSET_OFFSET_Y:int = 0;
      
      private static const ASSET_SOURCE_WIDTH:int = 88;
      
      private static const ASSET_SOURCE_HEIGHT:int = 47;
      
      private static const HIT_WIDTH:int = 50;
      
      private static const HIT_HEIGHT:int = 50;
      
      private static const HIT_OFFSET_X:int = 0;
      
      private static const HIT_OFFSET_Y:int = 0;
      
      private static const MASK_WIDTH:int = 50;
      
      private static const MASK_HEIGHT:int = 50;
      
      private static const MASK_OFFSET_X:int = 0;
      
      private static const MASK_OFFSET_Y:int = 0;
      
      private static const FACTION_OFFSET_X:int = 0;
      
      private static const FACTION_OFFSET_Y:int = 1;
      
      private static const NICKNAME_OFFSET_X:int = 21;
      
      private static const NICKNAME_OFFSET_Y:int = 51;
      
      private static const RETICLE_OFFSET_X:int = 25;
      
      private static const RETICLE_OFFSET_Y:int = 25;
      
      private static const TINT_COLOR_MINE:Number = 3329279;
      
      private static const TINT_COLOR_ENEMY:Number = 16711680;
      
      private static const GIZMO_ASSET_URL:String = "elements/gizmo.png";
      
      public var mcChaser:MovieClip;
      
      private var _assetContainer:Sprite;
      
      private var _bNameInView:Boolean = false;
      
      private var _bReticleInView:Boolean = false;
      
      private var _mcHit:MovieClip;
      
      private var _bIsEnemy:Boolean = false;
      
      private var _factionContainer:Sprite;
      
      private var _bmpAssetPlain:Bitmap = null;
      
      private var _tmrAttentionIn:Timer;
      
      private var _mcAssetMask:MovieClip;
      
      private var _tmrAttentionOut:Timer;
      
      private var _nickname:CondensedTextCenter;
      
      private var _currentAssetURL:String;
      
      private var _bInitedNanovor:Boolean = false;
      
      private var _bIsActive:Boolean = false;
      
      private var _assetLoader:Loader;
      
      private var _nanovor:INanovor;
      
      private var _bInited:Boolean = false;
      
      private var _reticle:SwapReticle = null;
      
      public function NanovorIcon()
      {
         super();
         mcChaser.stop();
      }
      
      public function bringInName(param1:Number = 0) : void
      {
         if(_bNameInView)
         {
            return;
         }
         _bNameInView = true;
         Tweener.removeTweens(_nickname,alpha);
         _nickname.visible = true;
         Tweener.addTween(_nickname,{
            "alpha":1,
            "time":0.3,
            "delay":param1,
            "transition":"easeOutQuad"
         });
      }
      
      public function bringOutName(param1:Number = 0) : void
      {
         if(!_bNameInView)
         {
            return;
         }
         _bNameInView = false;
         Tweener.removeTweens(_nickname,alpha);
         Tweener.addTween(_nickname,{
            "alpha":0,
            "time":0.3,
            "delay":param1,
            "transition":"easeOutQuad",
            "onComplete":onNameOutTweenComplete
         });
      }
      
      public function clearAttentionOutTimer() : void
      {
         if(Boolean(_tmrAttentionOut))
         {
            _tmrAttentionOut.removeEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerOutComplete);
            _tmrAttentionOut.stop();
            _tmrAttentionOut = null;
         }
      }
      
      private function generateAssetBitmap(param1:DisplayObject, param2:Boolean = false) : Bitmap
      {
         var _loc11_:GlowFilter = null;
         var _loc3_:BitmapData = new BitmapData(ASSET_SOURCE_WIDTH,ASSET_SOURCE_HEIGHT,true,0);
         _loc3_.draw(param1);
         if(param2)
         {
            return new Bitmap(_loc3_);
         }
         var _loc4_:Boolean = _currentAssetURL == GIZMO_ASSET_URL;
         var _loc5_:Sprite = new Sprite();
         _loc5_.addChild(new Bitmap(_loc3_));
         _loc5_.blendMode = BlendMode.HARDLIGHT;
         var _loc6_:AdjustColor = new AdjustColor();
         _loc6_.brightness = _loc4_ ? 0 : 34;
         _loc6_.contrast = _loc4_ ? 0 : 45;
         _loc6_.saturation = -100;
         _loc6_.hue = 0;
         _loc5_.filters = [new ColorMatrixFilter(_loc6_.CalculateFinalFlatArray())];
         var _loc7_:Sprite = new Sprite();
         _loc7_.addChild(new Bitmap(_loc3_));
         var _loc8_:ColorTransform = _loc7_.transform.colorTransform;
         _loc8_.color = _bIsEnemy ? uint(TINT_COLOR_ENEMY) : uint(TINT_COLOR_MINE);
         _loc7_.transform.colorTransform = _loc8_;
         if(_currentAssetURL != GIZMO_ASSET_URL)
         {
            _loc11_ = new GlowFilter(_loc8_.color,1,5,0,1,BitmapFilterQuality.MEDIUM);
            _loc7_.filters = [_loc11_];
         }
         var _loc9_:Sprite = new Sprite();
         if(_bIsActive)
         {
            _loc7_.alpha = 0.7;
            _loc9_.addChild(_loc7_);
         }
         else
         {
            _loc9_.addChild(_loc7_);
            _loc9_.addChild(_loc5_);
         }
         var _loc10_:BitmapData = new BitmapData(ASSET_SOURCE_WIDTH,ASSET_SOURCE_HEIGHT,true,0);
         _loc10_.draw(_loc9_);
         return new Bitmap(_loc10_);
      }
      
      public function disableHit() : void
      {
         _mcHit.removeEventListener(MouseEvent.ROLL_OVER,onHitRollOver);
         _mcHit.removeEventListener(MouseEvent.ROLL_OUT,onHitRollOut);
         _mcHit.removeEventListener(MouseEvent.CLICK,onHitClick);
         _mcHit.buttonMode = false;
         _mcHit.useHandCursor = false;
      }
      
      private function createAssetContainer() : void
      {
         _assetContainer = new Sprite();
         _assetContainer.x = ASSET_OFFSET_X;
         _assetContainer.y = ASSET_OFFSET_Y;
         _assetContainer.alpha = 0.88;
         addChild(_assetContainer);
      }
      
      public function clearAttentionInTimer() : void
      {
         if(Boolean(_tmrAttentionIn))
         {
            _tmrAttentionIn.removeEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerInComplete);
            _tmrAttentionIn.stop();
            _tmrAttentionIn = null;
         }
      }
      
      private function createNickname() : void
      {
         _nickname = new CondensedTextCenter();
         if(_nanovor.nickName != null && _nanovor.nickName != "")
         {
            _nickname.text = _nanovor.nickName;
         }
         else
         {
            _nickname.text = _nanovor.owner.username;
         }
         log("createNickname: _nickname.text=" + _nickname.text);
         _nickname.x = NICKNAME_OFFSET_X;
         _nickname.y = NICKNAME_OFFSET_Y;
         _nickname.alpha = 0;
         _nickname.visible = false;
         addChild(_nickname);
      }
      
      private function startAttentionOutTimer(param1:int) : void
      {
         clearAttentionInTimer();
         clearAttentionOutTimer();
         _tmrAttentionOut = new Timer(param1,1);
         _tmrAttentionOut.addEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerOutComplete,false,0,true);
         _tmrAttentionOut.start();
      }
      
      public function initialize(param1:INanovor, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false) : *
      {
         if(_bInitedNanovor)
         {
            return;
         }
         if(_bInited)
         {
            if(param1 == null)
            {
               return;
            }
            reInitializeWithNanovor(param1,param2,param3);
            return;
         }
         _bInited = true;
         if(param1 != null)
         {
            _bInitedNanovor = true;
         }
         _bIsEnemy = param3;
         _nanovor = param1;
         createAssetContainer();
         createAssetMask();
         if(_nanovor != null)
         {
            createFactionIcon();
            createNickname();
            createHitArea();
            if(param2)
            {
               enableHit();
            }
         }
         updateDisplay(param4);
      }
      
      private function createFactionIcon() : void
      {
         _factionContainer = new Sprite();
         switch(_nanovor.faction)
         {
            case Icon.FACTION_HEXITE:
               _factionContainer.addChild(new FactionHexite());
               break;
            case Icon.FACTION_MAGNAMOD:
               _factionContainer.addChild(new FactionMagnamod());
               break;
            case Icon.FACTION_VELOCITRON:
               _factionContainer.addChild(new FactionVelocitron());
               break;
            default:
               logError("createFactionIcon:  could not find a case for _nanovor.faction=" + _nanovor.faction);
         }
         _factionContainer.cacheAsBitmap = true;
         addChild(_factionContainer);
      }
      
      public function get mcHit() : MovieClip
      {
         return _mcHit;
      }
      
      public function enableHit() : void
      {
         _mcHit.addEventListener(MouseEvent.ROLL_OVER,onHitRollOver,false,0,true);
         _mcHit.addEventListener(MouseEvent.ROLL_OUT,onHitRollOut,false,0,true);
         _mcHit.addEventListener(MouseEvent.CLICK,onHitClick,false,0,true);
         _mcHit.buttonMode = true;
         _mcHit.useHandCursor = true;
      }
      
      public function get nanovor() : INanovor
      {
         return _nanovor;
      }
      
      private function onAssetLoaderError(param1:IOErrorEvent) : void
      {
         _assetLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onAssetLoaderComplete);
         _assetLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onAssetLoaderError);
         logError("onAssetLoaderError: " + param1.text);
      }
      
      private function loadAsset(param1:String) : void
      {
         if(Boolean(_assetLoader))
         {
            _assetLoader.unload();
            _assetLoader = null;
         }
         _assetLoader = new Loader();
         _assetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onAssetLoaderComplete,false,0,true);
         _assetLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onAssetLoaderError,false,0,true);
         _assetLoader.load(new URLRequest(param1));
      }
      
      public function get assetId() : String
      {
         return _nanovor.assetId;
      }
      
      private function onAssetLoaderComplete(param1:Event) : void
      {
         _assetLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onAssetLoaderComplete);
         _assetLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onAssetLoaderError);
         var _loc2_:Bitmap = generateAssetBitmap(_assetLoader.contentLoaderInfo.content as DisplayObject);
         _assetContainer.addChild(_loc2_);
         while(_assetContainer.numChildren > 1)
         {
            _assetContainer.removeChildAt(0);
         }
         _bmpAssetPlain = generateAssetBitmap(_assetLoader.contentLoaderInfo.content as DisplayObject,true);
         _bmpAssetPlain.alpha = 0;
         _bmpAssetPlain.visible = false;
         _assetContainer.addChild(_bmpAssetPlain);
         _assetLoader.unload();
         _assetLoader = null;
         dispatchEvent(new Event(LOADED));
      }
      
      private function onHitClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(SELECTED));
      }
      
      public function setPlainAlpha(param1:Number) : void
      {
         if(_bmpAssetPlain == null)
         {
            return;
         }
         Tweener.removeTweens(_bmpAssetPlain,"alpha");
         _bmpAssetPlain.visible = true;
         Tweener.addTween(_bmpAssetPlain,{
            "alpha":param1,
            "time":0.2,
            "transition":"easeOutQuad"
         });
      }
      
      public function bringOutReticle(param1:Number = 0) : void
      {
         var nDelay:Number = param1;
         if(!_bReticleInView)
         {
            return;
         }
         _bReticleInView = false;
         mcChaser.gotoAndStop(1);
         if(_bmpAssetPlain == null)
         {
            return;
         }
         Tweener.removeTweens(_bmpAssetPlain,"alpha");
         Tweener.addTween(_bmpAssetPlain,{
            "alpha":0,
            "time":0.2,
            "transition":"easeOutQuad",
            "onComplete":function():*
            {
               _bmpAssetPlain.visible = false;
            }
         });
      }
      
      public function updateDisplay(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         var _loc3_:CharacterChipAssetType = null;
         if(_nanovor == null)
         {
            _loc2_ = GIZMO_ASSET_URL;
            if(_loc2_ == _currentAssetURL && param1 == _bIsActive)
            {
               dispatchEvent(new Event(LOADED));
               return;
            }
            _currentAssetURL = _loc2_;
         }
         else
         {
            _loc3_ = _nanovor.isDead ? CharacterChipAssetType.DEATHS : CharacterChipAssetType.IDLE;
            _loc2_ = Managers.assetRetrieverManager.characterAssetRetriever.getCharacterChipURL(_loc3_,_nanovor.assetTypeId).url;
            if(_loc2_ == _currentAssetURL && param1 == _bIsActive)
            {
               dispatchEvent(new Event(LOADED));
               return;
            }
            _currentAssetURL = _loc2_;
         }
         _bIsActive = param1;
         loadAsset(_loc2_);
      }
      
      private function createHitArea() : void
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(65535,0);
         _loc1_.graphics.drawRect(0,0,HIT_WIDTH,HIT_HEIGHT);
         _loc1_.graphics.endFill();
         _mcHit = new MovieClip();
         _mcHit.addChild(_loc1_);
         _mcHit.x = HIT_OFFSET_X;
         _mcHit.y = HIT_OFFSET_Y;
         addChild(_mcHit);
      }
      
      private function onAttentionTimerOutComplete(param1:TimerEvent) : void
      {
         clearAttentionOutTimer();
         bringOutReticle();
      }
      
      private function onHitRollOut(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ROLL_OUT));
      }
      
      public function startAttentionInTimer(param1:int) : void
      {
         clearAttentionInTimer();
         clearAttentionOutTimer();
         _tmrAttentionIn = new Timer(param1,1);
         _tmrAttentionIn.addEventListener(TimerEvent.TIMER_COMPLETE,onAttentionTimerInComplete,false,0,true);
         _tmrAttentionIn.start();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorIcon: " + param1);
      }
      
      private function onHitRollOver(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(ROLL_OVER));
      }
      
      private function onNameOutTweenComplete() : void
      {
         _nickname.visible = false;
      }
      
      private function reInitializeWithNanovor(param1:INanovor, param2:Boolean, param3:Boolean) : void
      {
         if(_bInitedNanovor || param1 == null)
         {
            return;
         }
         _bInitedNanovor = true;
         _nanovor = param1;
         _bIsEnemy = param3;
         createFactionIcon();
         createNickname();
         createHitArea();
         updateDisplay();
         if(param2)
         {
            enableHit();
         }
      }
      
      public function bringInReticle(param1:Number = 0) : void
      {
         if(_bReticleInView)
         {
            return;
         }
         _bReticleInView = true;
         mcChaser.gotoAndPlay(1);
         if(_bmpAssetPlain == null)
         {
            return;
         }
         Tweener.removeTweens(_bmpAssetPlain,"alpha");
         _bmpAssetPlain.visible = true;
         Tweener.addTween(_bmpAssetPlain,{
            "alpha":1,
            "time":0.2,
            "transition":"easeOutQuad"
         });
      }
      
      private function createAssetMask() : void
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(65535,1);
         _loc1_.graphics.drawRect(0,0,MASK_WIDTH,MASK_HEIGHT);
         _loc1_.graphics.endFill();
         _mcAssetMask = new MovieClip();
         _mcAssetMask.addChild(_loc1_);
         _mcAssetMask.x = MASK_OFFSET_X;
         _mcAssetMask.y = MASK_OFFSET_Y;
         addChild(_mcAssetMask);
         _assetContainer.mask = _mcAssetMask;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorIcon: " + param1);
      }
      
      public function get typeId() : int
      {
         return _nanovor.assetTypeId;
      }
      
      private function onAttentionTimerInComplete(param1:TimerEvent) : void
      {
         clearAttentionInTimer();
         bringInReticle();
         startAttentionOutTimer(950);
      }
      
      public function destroy() : void
      {
         disableHit();
         clearAttentionInTimer();
         clearAttentionOutTimer();
         if(Boolean(_assetLoader))
         {
            _assetLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onAssetLoaderComplete);
            _assetLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onAssetLoaderError);
            _assetLoader.unload();
            _assetLoader = null;
         }
         Utils.clearAllChildren(_assetContainer);
         Utils.clearAllChildren(_mcHit);
         Utils.clearAllChildren(_mcAssetMask);
         Utils.clearAllChildren(this);
         _nanovor = null;
         delete global[this];
      }
   }
}

