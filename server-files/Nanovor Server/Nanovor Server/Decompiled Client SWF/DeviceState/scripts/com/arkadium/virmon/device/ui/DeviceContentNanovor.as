package com.arkadium.virmon.device.ui
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.effects.GlowDistort;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindow;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindowTitle;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.MultipleNanovorAnimationSequencer;
   import com.arkadium.virmon.shared.utils.chainloadees.NanovorAnimationLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class DeviceContentNanovor extends Sprite implements IChainLoaderConsumer
   {
      
      private static var _colorMatrix:ColorMatrixFilter;
      
      private static var _glow:GlowFilter;
      
      public static const STATE_ADDING:String = "stateAdding";
      
      public static const STATE_DEVICE:String = "stateDevice";
      
      private static const SEQUENCER_PARAMS:Object = {
         "scaleX":0.35,
         "scaleY":0.35
      };
      
      private static const NUM_SEQUENCERS:int = 2;
      
      private var _idleAnimations:Array;
      
      private var _nanovorContentContainer:Sprite;
      
      private var _transferChevron:DeviceTransferChevron;
      
      private var _sequencer:MultipleNanovorAnimationSequencer;
      
      private var _spotlight:Spotlight;
      
      private var _nanoscopeAnimation:MovieClip;
      
      private var _nanovor:INanovor;
      
      private var _chainLoader:IChainLoader;
      
      private var _distortedNanovor:GlowDistort;
      
      private var _infoWindowTitle:InfoWindowTitle;
      
      public function DeviceContentNanovor(param1:INanovor, param2:Sprite = null, param3:ICharacterAssetTypeCache = null)
      {
         super();
         initializeColors();
         if(null == param1)
         {
            return;
         }
         _nanovor = param1;
         _nanovorContentContainer = param2;
         createHitArea();
         var _loc4_:ChainLoadeeList = new ChainLoadeeList();
         var _loc5_:uint = 0;
         while(_loc5_ < NUM_SEQUENCERS)
         {
            _loc4_.add(new NanovorAnimationLoader(_nanovor.assetTypeId,CharacterAnimationAssetType.IDLE,param3,_loc5_.toString()));
            _loc4_.add(new NanovorAnimationLoader(_nanovor.assetTypeId,CharacterAnimationAssetType.REANIMATE,param3,_loc5_.toString()));
            _loc5_++;
         }
         _loc4_.add(new NanovorAnimationLoader(_nanovor.assetTypeId,CharacterAnimationAssetType.IDLE,param3,"nanoscope"));
         _chainLoader = new ChainLoader(_loc4_,IChainLoaderConsumer(this));
         _chainLoader.load();
         _spotlight = new Spotlight();
         _spotlight.color = Spotlight.RING_COLOR_GREEN;
         _spotlight.scaleX = _spotlight.scaleY = 0.4;
         _spotlight.x = -36;
         _spotlight.y = -177;
         this.addChild(_spotlight);
         _sequencer = new MultipleNanovorAnimationSequencer(NUM_SEQUENCERS);
         _sequencer.setSpeed(0.8);
         _distortedNanovor = new GlowDistort(_sequencer.getSequencer(0),_sequencer.getSequencer(1),11326797,1);
         this.addChild(_distortedNanovor);
         _infoWindowTitle = new InfoWindowTitle();
         _infoWindowTitle.sv = _nanovor.swarmValue;
         _infoWindowTitle.faction = getFactionString(_nanovor.faction);
         _infoWindowTitle.nanovorName = _nanovor.name;
         _infoWindowTitle.nanovorNickName = _nanovor.nickName;
         _infoWindowTitle.colorScheme = InfoWindowTitle.COLOR_SCHEME_GREEN;
         _infoWindowTitle.alpha = 0;
         _infoWindowTitle.y = -60;
         _infoWindowTitle.x = -55;
         this.addChild(_infoWindowTitle);
      }
      
      private function toggleGlow(param1:Boolean) : void
      {
         this.filters = param1 ? [_glow] : [];
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _nanoscopeAnimation = param1.getLoadedAsset(NanovorAnimationLoader.NAME + _nanovor.assetTypeId.toString() + CharacterAnimationAssetType.IDLE.name + "nanoscope") as MovieClip;
         _nanoscopeAnimation.x = 147;
         _nanoscopeAnimation.y = 40;
         _nanoscopeAnimation.scaleX = _nanoscopeAnimation.scaleY * 0.75;
         var _loc2_:Array = new Array();
         _idleAnimations = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < NUM_SEQUENCERS)
         {
            _loc2_.push(param1.getLoadedAsset(NanovorAnimationLoader.NAME + _nanovor.assetTypeId.toString() + CharacterAnimationAssetType.REANIMATE.name + _loc3_.toString()) as MovieClip);
            _idleAnimations.push(param1.getLoadedAsset(NanovorAnimationLoader.NAME + _nanovor.assetTypeId.toString() + CharacterAnimationAssetType.IDLE.name + _loc3_.toString()) as MovieClip);
            _loc3_++;
         }
         _sequencer.setDefaultAnimation(_idleAnimations,SEQUENCER_PARAMS);
         _sequencer.addAnimation(_loc2_,SEQUENCER_PARAMS);
      }
      
      public function destroy() : void
      {
         log("destroy() clearing from memory");
         if(null != _nanovorContentContainer)
         {
            while(_nanovorContentContainer.numChildren > 0)
            {
               _nanovorContentContainer.removeChildAt(0);
            }
         }
         removeTransferChevron();
         if(_sequencer != null)
         {
            _sequencer.stop();
            _sequencer.destroy();
         }
         if(_spotlight != null)
         {
            _spotlight.stop();
         }
         if(_nanoscopeAnimation != null)
         {
            _nanoscopeAnimation.stop();
         }
         if(_chainLoader != null)
         {
            _chainLoader.destroy();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceContentNanovor>>\t" + param1);
      }
      
      public function setState(param1:String) : void
      {
         switch(param1)
         {
            case STATE_ADDING:
               setStateAdding();
               break;
            case STATE_DEVICE:
               setStateDevice();
         }
      }
      
      private function setStateAdding() : void
      {
         toggleGlow(true);
         _transferChevron = new DeviceTransferChevron();
         _transferChevron.alpha = 0;
         Tweener.addTween(_transferChevron,{
            "_autoAlpha":1,
            "time":0.5
         });
         this.addChild(_transferChevron);
         if(null != _idleAnimations)
         {
            _sequencer.setDefaultAnimation(_idleAnimations,{
               "scaleX":0.35,
               "scaleY":0.35,
               "stop":true
            });
         }
         _distortedNanovor.enable();
      }
      
      private function onNanovorRollOver(param1:MouseEvent) : void
      {
         _sequencer.setDefaultAnimation(_idleAnimations,{
            "scaleX":0.35,
            "scaleY":0.35
         });
         _sequencer.play();
         _spotlight.open();
         Tweener.addTween(_infoWindowTitle,{
            "_autoAlpha":1,
            "time":0.5
         });
         _distortedNanovor.disable();
         if(null != _nanovorContentContainer)
         {
            while(_nanovorContentContainer.numChildren > 0)
            {
               _nanovorContentContainer.removeChildAt(0);
            }
            _nanovorContentContainer.addChild(_nanoscopeAnimation);
         }
      }
      
      private function setStateDevice() : void
      {
         if(null == _sequencer)
         {
            return;
         }
         if(null != _transferChevron)
         {
            Tweener.addTween(_transferChevron,{
               "_autoAlpha":0,
               "time":0.5,
               "onComplete":removeTransferChevron
            });
         }
         toggleGlow(false);
         this.addEventListener(MouseEvent.ROLL_OVER,onNanovorRollOver,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,onNanovorRollOut,false,0,true);
         if(null != _idleAnimations)
         {
            _sequencer.setDefaultAnimation(_idleAnimations,{
               "scaleX":0.35,
               "scaleY":0.35,
               "stop":true
            });
         }
         _distortedNanovor.enable();
      }
      
      private function getFactionString(param1:String) : String
      {
         switch(param1)
         {
            case "Magnamod":
               return InfoWindow.FAMILY_MAGNAMOD;
            case "Velocitron":
               return InfoWindow.FAMILY_VELOCITRON;
            case "Hexite":
               return InfoWindow.FAMILY_HEXITE;
            default:
               return "";
         }
      }
      
      private function initializeColors() : void
      {
         var _loc1_:AdjustColor = null;
         if(null == _glow)
         {
            _glow = new GlowFilter(177666,0.8,10,10);
         }
         if(null == _colorMatrix)
         {
            _loc1_ = new AdjustColor();
            _loc1_.brightness = -6;
            _loc1_.contrast = 27;
            _loc1_.saturation = 18;
            _loc1_.hue = -111;
            _colorMatrix = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
         }
      }
      
      private function onNanovorRollOut(param1:MouseEvent) : void
      {
         _sequencer.setDefaultAnimation(_idleAnimations,{
            "scaleX":0.35,
            "scaleY":0.35,
            "stop":true
         });
         _spotlight.close();
         Tweener.addTween(_infoWindowTitle,{
            "_autoAlpha":0,
            "time":0.5
         });
         _distortedNanovor.enable();
         if(null != _nanovorContentContainer)
         {
            while(_nanovorContentContainer.numChildren > 0)
            {
               _nanovorContentContainer.removeChildAt(0);
            }
         }
      }
      
      private function removeTransferChevron() : void
      {
         if(null != _transferChevron && null != _transferChevron.parent)
         {
            _transferChevron.stop();
            _transferChevron.parent.removeChild(_transferChevron);
         }
         _transferChevron = null;
      }
      
      private function createHitArea() : void
      {
         this.mouseChildren = false;
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16711680,0);
         _loc1_.graphics.drawRect(65 / -2,0,65,65);
         _loc1_.graphics.endFill();
         this.addChild(_loc1_);
         this.hitArea = _loc1_;
      }
   }
}

