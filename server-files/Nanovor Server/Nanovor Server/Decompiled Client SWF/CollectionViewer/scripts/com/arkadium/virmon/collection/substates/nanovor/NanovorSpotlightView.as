package com.arkadium.virmon.collection.substates.nanovor
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.final.components.spotlight.Spotlight;
   import com.arkadium.virmon.shared.final.elements.IdentifyingNanovorElement;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.INanovorAnimationSequencerConsumer;
   import com.arkadium.virmon.shared.utils.NanovorAnimationSequencer;
   import com.arkadium.virmon.shared.utils.chainloadees.NanovorAnimationLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class NanovorSpotlightView extends Sprite implements INanovorAnimationSequencerConsumer, IChainLoaderConsumer
   {
      
      private var _assetTypeId:int;
      
      private var _animationReanimate:MovieClip;
      
      private var _animationVictory:MovieClip;
      
      private var _identifyingGraphic:IdentifyingNanovorElement;
      
      private var _spotlight:Spotlight;
      
      private var _sequencer:NanovorAnimationSequencer;
      
      private var _characterAssetTypeCache:ICharacterAssetTypeCache;
      
      private var _identifyingGraphicEnabled:Boolean = false;
      
      private var _chainLoader:ChainLoader;
      
      private var _animationIdle:MovieClip;
      
      public function NanovorSpotlightView(param1:ICharacterAssetTypeCache)
      {
         super();
         _characterAssetTypeCache = param1;
      }
      
      private function disableIdentifyingGraphic() : void
      {
         if(!_identifyingGraphicEnabled)
         {
            return;
         }
         _identifyingGraphicEnabled = false;
         if(_identifyingGraphic == null)
         {
            return;
         }
         Tweener.removeTweens(_identifyingGraphic);
         Tweener.addTween(_identifyingGraphic,{
            "_autoAlpha":0,
            "time":0.4,
            "transition":"easeOutQuad",
            "onComplete":onIdentifyingGraphicAlphaZero
         });
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         if(_animationIdle != null)
         {
            _animationVictory = param1.getLoadedAsset(NanovorAnimationLoader.NAME + _assetTypeId + CharacterAnimationAssetType.VICTORY.name) as MovieClip;
            _sequencer.addInterruptAnimation(_animationVictory);
         }
         else
         {
            _animationIdle = param1.getLoadedAsset(NanovorAnimationLoader.NAME + _assetTypeId + CharacterAnimationAssetType.IDLE.name) as MovieClip;
            _animationReanimate = param1.getLoadedAsset(NanovorAnimationLoader.NAME + _assetTypeId + CharacterAnimationAssetType.REANIMATE.name) as MovieClip;
            _sequencer.addInterruptAnimation(_animationReanimate);
            _sequencer.setDefaultAnimation(_animationIdle);
         }
         killChainLoader();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorSpotlightView: " + param1);
      }
      
      private function destroyIdentifyingGraphic() : void
      {
         if(_identifyingGraphic == null)
         {
            return;
         }
         Tweener.removeTweens(_identifyingGraphic);
         _identifyingGraphic.stop();
         if(contains(_identifyingGraphic))
         {
            removeChild(_identifyingGraphic);
         }
         _identifyingGraphic = null;
      }
      
      private function enableIdentifyingGraphic() : void
      {
         if(_identifyingGraphicEnabled)
         {
            return;
         }
         _identifyingGraphicEnabled = true;
         if(_identifyingGraphic == null)
         {
            _identifyingGraphic = new IdentifyingNanovorElement(true);
            _identifyingGraphic.y = -20;
            _identifyingGraphic.x = -92;
            _identifyingGraphic.alpha = 0;
         }
         _identifyingGraphic.play();
         addChild(_identifyingGraphic);
         Tweener.removeTweens(_identifyingGraphic);
         Tweener.addTween(_identifyingGraphic,{
            "_autoAlpha":1,
            "time":0.8,
            "transition":"easeInOutQuad"
         });
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorSpotlightView: " + param1);
      }
      
      public function enterNanovor(param1:int, param2:Boolean) : void
      {
         destroy();
         createSpotlight();
         createSequencer();
         _sequencer.scaleX = param2 ? -1 : 1;
         _spotlight.open();
         _assetTypeId = param1;
         loadSequencerAssets(_assetTypeId);
      }
      
      private function onIdentifyingGraphicAlphaZero() : void
      {
         if(_identifyingGraphic == null)
         {
            return;
         }
         _identifyingGraphic.stop();
         removeChild(_identifyingGraphic);
      }
      
      private function killChainLoader() : void
      {
         if(_chainLoader == null)
         {
            return;
         }
         _chainLoader.destroy();
         _chainLoader = null;
      }
      
      public function buffSuccess() : void
      {
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         _loc1_.add(new NanovorAnimationLoader(_assetTypeId,CharacterAnimationAssetType.VICTORY,_characterAssetTypeCache));
         killChainLoader();
         _chainLoader = new ChainLoader(_loc1_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      private function createSpotlight() : void
      {
         _spotlight = new Spotlight();
         _spotlight.x = -100;
         _spotlight.y = -418;
         _spotlight.mouseEnabled = false;
         _spotlight.mouseChildren = false;
         this.addChild(_spotlight);
      }
      
      public function destroy() : void
      {
         if(_animationVictory != null)
         {
            _animationVictory.stop();
            _animationVictory = null;
         }
         if(_animationIdle != null)
         {
            _animationIdle.stop();
            _animationIdle = null;
         }
         if(_animationReanimate != null)
         {
            _animationReanimate.stop();
            _animationReanimate = null;
         }
         if(_sequencer != null)
         {
            if(_sequencer.parent == this)
            {
               this.removeChild(_sequencer);
            }
            _sequencer.destroy();
            _sequencer = null;
         }
         if(_spotlight != null)
         {
            if(_spotlight.parent == this)
            {
               this.removeChild(_spotlight);
            }
            _spotlight = null;
         }
         killChainLoader();
         destroyIdentifyingGraphic();
      }
      
      private function createSequencer() : void
      {
         _sequencer = new NanovorAnimationSequencer();
         _sequencer.addConsumer(this);
         _sequencer.setSpeed(0.5);
         this.addChild(_sequencer);
      }
      
      public function handleAnimationClipStarted(param1:MovieClip) : void
      {
         if(param1 == _animationIdle && Boolean(_characterAssetTypeCache.isCharacterSuperseded(_assetTypeId)))
         {
            enableIdentifyingGraphic();
            return;
         }
         disableIdentifyingGraphic();
      }
      
      private function loadSequencerAssets(param1:int) : void
      {
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new NanovorAnimationLoader(param1,CharacterAnimationAssetType.IDLE,_characterAssetTypeCache));
         _loc2_.add(new NanovorAnimationLoader(param1,CharacterAnimationAssetType.REANIMATE,_characterAssetTypeCache));
         killChainLoader();
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
   }
}

