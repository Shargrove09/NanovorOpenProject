package com.arkadium.virmon.collection.substates.ems
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.components.GlowArrow;
   import com.arkadium.virmon.collection.substates.ems.components.EMFactionTileComponent;
   import com.arkadium.virmon.collection.substates.ems.components.EMTileComponent;
   import com.arkadium.virmon.collection.substates.ems.elements.FactionBGElement;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.framework.EMMasterData;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TileScrollerWaveTab;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class EMTreeMenu extends MovieClip
   {
      
      private static const FACTION_BG_ORIGIN:Point = new Point(57,123);
      
      private static const EM_BG_ORIGIN:Point = new Point(57,230);
      
      private static const EM_BG_X_OFFSET_WITH_FOIL:Number = -37;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeOutQuad
      };
      
      private static const FACTIONS_NAMES:Array = [NanovorFaction.MAGNAMOD,NanovorFaction.VELOCITRON,NanovorFaction.HEXITE];
      
      private static const DEFAULT_SELECTED_FACTION:String = NanovorFaction.MAGNAMOD;
      
      private var _currentWaveFactionEMTileContainer:Sprite;
      
      private var _leftArrow:GlowArrow;
      
      private var _waveTabLeft:TileScrollerWaveTab;
      
      private var _waveFactionEMTileContainers:Array;
      
      private var _waveTabRight:TileScrollerWaveTab;
      
      private var _currentFactionTile:EMFactionTileComponent;
      
      private var _latestWaveIndex:int;
      
      private var _factionTileContainer:Sprite;
      
      private var _waveFactionEMTiles:Array;
      
      private var _emSubTrees:Array;
      
      private var _factionBG:FactionBGElement;
      
      private var _rightArrow:GlowArrow;
      
      private var _factionTileMask:Sprite;
      
      private var _currentEMSubTreeMenu:EMSubTreeMenu;
      
      private var _currentWaveIndex:int;
      
      public function EMTreeMenu(param1:Array)
      {
         super();
         _factionBG = new FactionBGElement();
         _factionBG.mouseEnabled = false;
         _factionBG.x = FACTION_BG_ORIGIN.x;
         _factionBG.y = FACTION_BG_ORIGIN.y;
         this.addChild(_factionBG);
         _factionTileMask = new Sprite();
         _factionTileMask.x = FACTION_BG_ORIGIN.x;
         _factionTileMask.y = FACTION_BG_ORIGIN.y;
         _factionTileContainer = new Sprite();
         _factionTileContainer.mouseEnabled = false;
         _factionTileContainer.cacheAsBitmap = true;
         _factionTileContainer.x = FACTION_BG_ORIGIN.x;
         _factionTileContainer.y = FACTION_BG_ORIGIN.y;
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(_factionBG.width - 40,_factionBG.height);
         _factionTileMask.mouseEnabled = false;
         _factionTileMask.graphics.beginGradientFill(GradientType.LINEAR,[16711680,16711680,16711680,16711680],[0,1,1,0],[0,20,235,255],_loc2_);
         _factionTileMask.graphics.drawRect(20,0,_factionBG.width - 40,_factionBG.height);
         _factionTileMask.graphics.endFill();
         this.addChild(_factionTileContainer);
         this.addChild(_factionTileMask);
         _factionTileMask.cacheAsBitmap = true;
         _factionTileContainer.mask = _factionTileMask;
         _waveTabLeft = new TileScrollerWaveTab();
         addChild(_waveTabLeft);
         _waveTabLeft.x = FACTION_BG_ORIGIN.x - _waveTabLeft.width;
         _waveTabLeft.y = FACTION_BG_ORIGIN.y;
         _waveTabRight = new TileScrollerWaveTab(true);
         addChild(_waveTabRight);
         _waveTabRight.x = _factionBG.x + _factionBG.width - GlowArrow.WIDTH + 38 - _waveTabRight.width;
         _waveTabRight.y = FACTION_BG_ORIGIN.y;
         var _loc3_:int = findLatestWave(param1);
         var _loc4_:Array = generateEMData(_loc3_,param1);
         _latestWaveIndex = _loc3_ - 1;
         generateFactionEMTiles(_loc4_);
         generateCollectionEMTiles(_loc4_);
         _currentWaveIndex = 0;
      }
      
      public function destroy() : void
      {
         var _loc1_:Dictionary = null;
         var _loc2_:Sprite = null;
         var _loc3_:EMSubTreeMenu = null;
         var _loc4_:int = 0;
         var _loc5_:EMFactionTileComponent = null;
         for each(_loc1_ in _emSubTrees)
         {
            for each(_loc3_ in _loc1_)
            {
               _loc3_.destroy();
            }
         }
         for each(_loc2_ in _waveFactionEMTileContainers)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.numChildren)
            {
               _loc5_ = _loc2_.getChildAt(_loc4_) as EMFactionTileComponent;
               if(null != _loc5_)
               {
                  _loc5_.removeEventListener(EMTreeMenuEvent.FACTIONTILE_CLICK,onFactionClick);
                  _loc5_.destroy();
               }
               _loc4_++;
            }
         }
         _currentFactionTile = null;
      }
      
      private function createScrollingArrows() : void
      {
         log("createScrollingArrows()");
         _leftArrow = new GlowArrow(0.2);
         _leftArrow.x = _factionBG.x - GlowArrow.WIDTH - 10;
         _leftArrow.y = _factionBG.y + _factionBG.height - GlowArrow.HEIGHT - 60;
         _rightArrow = new GlowArrow(0.2);
         _rightArrow.scaleX = -1;
         _rightArrow.x = _factionBG.x + _factionBG.width - GlowArrow.WIDTH + 38;
         _rightArrow.y = _factionBG.y + _factionBG.height - GlowArrow.HEIGHT - 60;
         _rightArrow.open();
         this.addChild(_leftArrow);
         this.addChild(_rightArrow);
         _leftArrow.addEventListener(MouseEvent.CLICK,handleLeftArrowClick);
         _rightArrow.addEventListener(MouseEvent.CLICK,handleRightArrowClick);
      }
      
      public function openFirst() : void
      {
         toggleWave(0);
         _currentEMSubTreeMenu.openFirst();
      }
      
      public function getCurrentTile() : EMTileComponent
      {
         return _currentEMSubTreeMenu.currentTile;
      }
      
      private function onFactionClick(param1:EMTreeMenuEvent) : void
      {
         if(_currentFactionTile != null)
         {
            _currentFactionTile.deselect();
         }
         var _loc2_:String = String(param1.data.faction);
         _currentFactionTile = EMFactionTileComponent(param1.data.tile);
         toggleWaveEMs(_currentWaveIndex,_loc2_);
      }
      
      private function handleRightArrowClick(param1:MouseEvent) : void
      {
         toggleWave(_currentWaveIndex + 1);
      }
      
      private function removeFromStage(param1:Sprite) : void
      {
         if(null != param1 && null != param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EMTreeMenu>>\t" + param1);
      }
      
      private function generateEMData(param1:int, param2:Array) : Array
      {
         var _loc5_:EMMasterData = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc3_[_loc4_] = new Dictionary();
            _loc4_++;
         }
         for each(_loc5_ in param2)
         {
            _loc6_ = parseInt(_loc5_.getWave()) - 1;
            _loc7_ = getFactionName(_loc5_.getFaction());
            if(null == _loc3_[_loc6_][_loc7_])
            {
               _loc3_[_loc6_][_loc7_] = new Array();
            }
            _loc3_[_loc6_][_loc7_].push(_loc5_);
         }
         return _loc3_;
      }
      
      private function getFactionName(param1:String) : String
      {
         var _loc2_:String = null;
         for each(_loc2_ in FACTIONS_NAMES)
         {
            if(param1.toLowerCase() == _loc2_.toLowerCase())
            {
               return _loc2_;
            }
         }
         return "";
      }
      
      private function generateCollectionEMTiles(param1:Array) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:EMSubTreeMenu = null;
         _emSubTrees = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Sprite();
            _loc4_ = param1[_loc2_] as Dictionary;
            _loc5_ = 0;
            if(null == _emSubTrees[_loc2_])
            {
               _emSubTrees[_loc2_] = new Dictionary();
            }
            for each(_loc6_ in FACTIONS_NAMES)
            {
               _loc7_ = new EMSubTreeMenu();
               _loc7_.setData(param1[_loc2_][_loc6_],_loc6_);
               _loc7_.x = EM_BG_ORIGIN.x;
               _loc7_.y = EM_BG_ORIGIN.y;
               _emSubTrees[_loc2_][_loc6_] = _loc7_;
            }
            _loc2_++;
         }
      }
      
      private function toggleWaveEMs(param1:int, param2:String) : void
      {
         if(null != _currentEMSubTreeMenu)
         {
            _currentEMSubTreeMenu.deselect();
            Tweener.addTween(_currentEMSubTreeMenu,{
               "_autoAlpha":0,
               "onComplete":removeFromStage,
               "onCompleteParams":[_currentEMSubTreeMenu],
               "base":TWEEN_BASE
            });
         }
         _currentEMSubTreeMenu = _emSubTrees[param1][param2];
         _currentEMSubTreeMenu.alpha = 0;
         Tweener.addTween(_currentEMSubTreeMenu,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         var _loc3_:EMFactionTileComponent = _waveFactionEMTiles[param1][param2] as EMFactionTileComponent;
         if(null != _loc3_)
         {
            _loc3_.select();
            _currentFactionTile = _loc3_;
         }
         this.addChild(_emSubTrees[param1][param2]);
         _currentEMSubTreeMenu.openFirst();
      }
      
      private function toggleWave(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Boolean = Boolean(param1 > _currentWaveIndex);
         if(null != _currentWaveFactionEMTileContainer)
         {
            _loc5_ = _loc2_ ? -300 : 1000;
            Tweener.addTween(_currentWaveFactionEMTileContainer,{
               "x":_loc5_,
               "base":TWEEN_BASE,
               "onComplete":removeFromStage,
               "onCompleteParams":[_currentWaveFactionEMTileContainer]
            });
         }
         if(null != _currentFactionTile)
         {
            _currentFactionTile.deselect();
         }
         var _loc3_:Sprite = _waveFactionEMTileContainers[param1];
         _loc3_.x = _loc2_ ? 1000 : -300;
         var _loc4_:int = (_factionBG.width - _loc3_.width) / 2;
         _factionTileContainer.addChild(_loc3_);
         Tweener.addTween(_loc3_,{
            "x":_loc4_,
            "base":TWEEN_BASE
         });
         _currentWaveFactionEMTileContainer = _loc3_;
         _waveTabLeft.updateWave(param1 + 1);
         _waveTabRight.updateWave(param1 + 1);
         _leftArrow.open();
         _rightArrow.open();
         _currentWaveIndex = param1;
         if(_currentWaveIndex == 0)
         {
            _leftArrow.close();
         }
         if(_currentWaveIndex == _latestWaveIndex)
         {
            _rightArrow.close();
         }
         toggleWaveEMs(param1,DEFAULT_SELECTED_FACTION);
      }
      
      private function handleLeftArrowClick(param1:MouseEvent) : void
      {
         toggleWave(_currentWaveIndex - 1);
      }
      
      private function findLatestWave(param1:Array) : int
      {
         var _loc3_:EMMasterData = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(parseInt(_loc3_.getWave()) > _loc2_)
            {
               _loc2_ = parseInt(_loc3_.getWave());
            }
         }
         return _loc2_;
      }
      
      private function generateFactionEMTiles(param1:Array) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Dictionary = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:EMFactionTileComponent = null;
         log("generateFactionEMTiles() - organizedEMData.length: " + param1.length);
         _waveFactionEMTileContainers = new Array();
         _waveFactionEMTiles = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new Sprite();
            _loc4_ = param1[_loc2_] as Dictionary;
            _loc5_ = 0;
            _waveFactionEMTiles[_loc2_] = new Dictionary();
            for each(_loc6_ in FACTIONS_NAMES)
            {
               _loc7_ = new EMFactionTileComponent(_loc6_,_loc2_ + 1,true,0);
               _loc7_.x = _loc5_;
               _loc7_.addEventListener(EMTreeMenuEvent.FACTIONTILE_CLICK,onFactionClick,false,0,true);
               _loc5_ += _loc7_.width;
               _loc3_.addChild(_loc7_);
               _waveFactionEMTiles[_loc2_][_loc6_] = _loc7_;
            }
            _waveFactionEMTileContainers[_loc2_] = _loc3_;
            _loc2_++;
         }
         if(param1.length > 1)
         {
            createScrollingArrows();
         }
      }
   }
}

