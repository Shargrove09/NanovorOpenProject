package com.arkadium.virmon.collection.substates.ems
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.collection.substates.ems.elements.ClickToViewTextElement;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.framework.DataManager;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   import com.arkadium.virmon.framework.asset.enum.CharacterAnimationAssetType;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.effects.GlowDistort;
   import com.arkadium.virmon.shared.final.components.infowindow.InfoWindowTitle;
   import com.arkadium.virmon.shared.final.elements.AlertBubble;
   import com.arkadium.virmon.shared.final.elements.UnknownNanovorSpinner;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoader;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.MultipleNanovorAnimationSequencer;
   import com.arkadium.virmon.shared.utils.chainloadees.NanovorAnimationLoader;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class EMNanovorView extends Sprite implements IChainLoaderConsumer
   {
      
      public static const CLICK:String = "EMNanovorClick";
      
      private static const MAX_NANOVOR_WIDTH:int = 140;
      
      private static const MAX_NANOVOR_HEIGHT:int = 140;
      
      private static const NANOVOR_ORIGIN:Point = new Point(65,60);
      
      private static const ALERT_ORIGIN:Point = new Point(120,20);
      
      private static const CLICK_TEXT_POSITION:Point = new Point(0,170);
      
      private var _container:Sprite;
      
      private var _assetTypeId:int;
      
      private var _animationReanimate:MovieClip;
      
      private var _infoTitle:InfoWindowTitle;
      
      private var _nanovorDiscovered:Boolean;
      
      private var _sequencer:MultipleNanovorAnimationSequencer;
      
      private var _clickText:ClickToViewTextElement;
      
      private var _faction:String;
      
      private var _nanovorOwned:Boolean;
      
      private var _chainLoader:ChainLoader;
      
      private var _animationIdle:MovieClip;
      
      private var _alert:AlertBubble;
      
      public function EMNanovorView(param1:int, param2:int, param3:ICharacterAssetTypeCache)
      {
         super();
         _nanovorDiscovered = param2 < 2;
         _nanovorOwned = param2 == 0;
         createSequencer();
         _assetTypeId = param1;
         useHandCursor = _nanovorOwned;
         buttonMode = _nanovorOwned;
         loadSequencerAssets(param3);
         _infoTitle = new InfoWindowTitle();
         addChild(_infoTitle);
         var _loc4_:IVirmonMasterData = DataManager.getInstance().getVirmonManager().getVirmonMasterData(_assetTypeId);
         _infoTitle.nanovorName = _nanovorDiscovered ? _loc4_.getName() : "UNKNOWN";
         _infoTitle.nanovorNickName = "";
         _infoTitle.sv = _loc4_.getPointValue();
         _infoTitle.faction = _loc4_.getFaction();
         _faction = _loc4_.getFaction();
         _alert = new AlertBubble();
         _alert.x = ALERT_ORIGIN.x;
         _alert.y = ALERT_ORIGIN.y;
         _alert.number = DataManager.getInstance().getVirmonManager().getVirmonQuantity(_assetTypeId).length;
         _alert.visible = _alert.number > 0;
         addChild(_alert);
         _clickText = new ClickToViewTextElement();
         _clickText.x = CLICK_TEXT_POSITION.x;
         _clickText.y = CLICK_TEXT_POSITION.y;
         addChild(_clickText);
         _clickText.alpha = 0;
      }
      
      public function destroy() : void
      {
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
            if(_sequencer.getSequencer(0).parent != null)
            {
               _sequencer.getSequencer(0).parent.removeChild(_sequencer.getSequencer(0));
            }
            _sequencer.destroy();
            _sequencer = null;
         }
         if(_chainLoader != null)
         {
            _chainLoader.destroy();
            _chainLoader = null;
         }
      }
      
      public function get assetTypeId() : int
      {
         return _assetTypeId;
      }
      
      private function rollOut(param1:MouseEvent) : void
      {
         Tweener.addTween(_clickText,{
            "_autoAlpha":0,
            "time":0.5
         });
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> EMNanovorView: " + param1);
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         var _loc6_:int = 0;
         var _loc7_:GlowDistort = null;
         if(!_nanovorDiscovered)
         {
            _container.addChild(new UnknownNanovorSpinner());
            _container.x = -10;
            _container.y = 50;
            return;
         }
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:int = _nanovorOwned ? 1 : 2;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_.push(param1.getLoadedAsset(NanovorAnimationLoader.NAME + _assetTypeId + CharacterAnimationAssetType.REANIMATE.name + _loc5_.toString()) as MovieClip);
            _loc3_.push(param1.getLoadedAsset(NanovorAnimationLoader.NAME + _assetTypeId + CharacterAnimationAssetType.IDLE.name + _loc5_.toString()) as MovieClip);
            _loc5_++;
         }
         _chainLoader.destroy();
         _chainLoader = null;
         _sequencer.addInterruptAnimation(_loc2_,{
            "scaleX":0.6,
            "scaleY":0.6
         });
         _sequencer.setDefaultAnimation(_loc3_,{
            "scaleX":0.6,
            "scaleY":0.6
         });
         _sequencer.getSequencer(0).x = NANOVOR_ORIGIN.x;
         _sequencer.getSequencer(0).y = NANOVOR_ORIGIN.y;
         if(_nanovorOwned)
         {
         }
         if(_sequencer.getCount() > 1)
         {
            _sequencer.getSequencer(1).x = NANOVOR_ORIGIN.x;
            _sequencer.getSequencer(1).y = NANOVOR_ORIGIN.y;
            switch(_faction.toLowerCase())
            {
               case NanovorFaction.MAGNAMOD.toLowerCase():
                  _loc6_ = int(ColorMap.FACTION_MAGNAMOD);
                  break;
               case NanovorFaction.VELOCITRON.toLowerCase():
                  _loc6_ = int(ColorMap.FACTION_VELOCITRON);
                  break;
               case NanovorFaction.HEXITE.toLowerCase():
                  _loc6_ = int(ColorMap.FACTION_HEXITE);
            }
            _loc7_ = new GlowDistort(_sequencer.getSequencer(0),_sequencer.getSequencer(1),_loc6_);
            _loc7_.enable();
            _container.addChild(_loc7_);
         }
         else
         {
            _container.addEventListener(MouseEvent.CLICK,nanoClick,false,0,true);
            _container.addEventListener(MouseEvent.ROLL_OVER,rollOver,false,0,true);
            _container.addEventListener(MouseEvent.ROLL_OUT,rollOut,false,0,true);
         }
      }
      
      private function resizeNanovor() : void
      {
         if(_sequencer.getSequencer(0).width >= _sequencer.getSequencer(0).height)
         {
            _sequencer.getSequencer(0).width = MAX_NANOVOR_WIDTH;
            _sequencer.getSequencer(0).scaleY = _sequencer.getSequencer(0).scaleX;
         }
         else
         {
            _sequencer.getSequencer(0).height = MAX_NANOVOR_HEIGHT;
            _sequencer.getSequencer(0).scaleX = _sequencer.getSequencer(0).scaleY;
         }
         if(_sequencer.getCount() > 1)
         {
            _sequencer.getSequencer(1).scaleX = _sequencer.getSequencer(1).scaleY = _sequencer.getSequencer(0).scaleX;
         }
         _sequencer.getSequencer(0).x = NANOVOR_ORIGIN.x + (MAX_NANOVOR_WIDTH - _sequencer.getSequencer(0).width) / 2;
         _sequencer.getSequencer(0).y = NANOVOR_ORIGIN.y + (MAX_NANOVOR_HEIGHT - _sequencer.getSequencer(0).height) / 2;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** EMNanovorView: " + param1);
      }
      
      private function loadSequencerAssets(param1:ICharacterAssetTypeCache) : void
      {
         var _loc2_:ChainLoadeeList = new ChainLoadeeList();
         _loc2_.add(new NanovorAnimationLoader(_assetTypeId,CharacterAnimationAssetType.IDLE,param1,"0"));
         _loc2_.add(new NanovorAnimationLoader(_assetTypeId,CharacterAnimationAssetType.REANIMATE,param1,"0"));
         if(_sequencer.getCount() > 1)
         {
            _loc2_.add(new NanovorAnimationLoader(_assetTypeId,CharacterAnimationAssetType.IDLE,param1,"1"));
            _loc2_.add(new NanovorAnimationLoader(_assetTypeId,CharacterAnimationAssetType.REANIMATE,param1,"1"));
         }
         _chainLoader = new ChainLoader(_loc2_,IChainLoaderConsumer(this));
         _chainLoader.load();
      }
      
      private function rollOver(param1:MouseEvent) : void
      {
         Tweener.addTween(_clickText,{
            "_autoAlpha":1,
            "time":0.5
         });
      }
      
      private function nanoClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(EMNanovorView.CLICK));
      }
      
      private function createSequencer() : void
      {
         _container = new Sprite();
         addChild(_container);
         _sequencer = new MultipleNanovorAnimationSequencer(_nanovorOwned ? 1 : 2);
         _sequencer.setSpeed(0.5);
         if(_nanovorOwned)
         {
            _container.addChild(_sequencer.getSequencer(0));
         }
      }
   }
}

