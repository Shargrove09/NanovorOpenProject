package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.common.NanovorFaction;
   import com.arkadium.virmon.common.StatsDisplayInfo;
   import com.arkadium.virmon.shared.colors.ColorMap;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.elements.fonts.EuroStileCondensed;
   import com.arkadium.virmon.shared.utils.ChainLoadeeList;
   import com.arkadium.virmon.shared.utils.ChainLoaderRetry;
   import com.arkadium.virmon.shared.utils.IAssetCache;
   import com.arkadium.virmon.shared.utils.IChainLoaderConsumer;
   import com.arkadium.virmon.shared.utils.IChainLoaderErrorConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   
   public class TreeViewMenu extends MovieClip implements IChainLoaderConsumer, IChainLoaderErrorConsumer, ITreeViewMenu
   {
      
      private static const DEBUG_SHOW_LOGGING:Boolean = false;
      
      public static const TREESCROLLER_X:int = 0;
      
      public static const TREESCROLLER_Y:int = 0;
      
      public static const COLLECTIONSCROLLER_X:int = 0;
      
      public static const COLLECTIONSCROLLER_Y:int = 100;
      
      private static const TREE_SCROLLER_POINT:Point = new Point(0,0);
      
      private static const IS_NEW_THRESHOLD:Number = 172800000;
      
      private static const TREE_SCROLLER_MASK_RECT:Rectangle = new Rectangle(0,0,910,TreeTile.HEIGHT + 14);
      
      private static const TREE_BG_POINT:Point = new Point(-57,-102);
      
      private static const COLLECTION_REVEAL_TWEEN_BASE:Object = {
         "alpha":1,
         "time":0.5,
         "transition":Equations.easeOutQuad
      };
      
      private static const COLLECTION_SCROLLER_MASK_RECT:Rectangle = new Rectangle(0,0,910,120);
      
      private static const COLLECTION_BG_POINT:Point = new Point(0,121);
      
      private var collectionAssetIdDict:Dictionary = new Dictionary(true);
      
      private var curSort:String;
      
      private var _treeTiles:Array;
      
      private var _showCollectionTiles:Boolean = true;
      
      private var sortTab:TileScrollerSortTab;
      
      private var _isAutoSelect:Boolean = false;
      
      private var _collectionBG:CollectionBG;
      
      private var _waveTabLeft:TileScrollerWaveTab;
      
      private var _collectionTiles:Array;
      
      private var magnamodLabel:TextField;
      
      private var _treesBG:TreesBG;
      
      private var collectionDict:Dictionary = new Dictionary(true);
      
      private var _waveTabRight:TileScrollerWaveTab;
      
      private var isFirstTreeSelect:Boolean = true;
      
      private var _collectionData:Array;
      
      private var hexiteLabel:TextField;
      
      private var _collectionTileChainLoader:ChainLoaderRetry;
      
      private var _currentSelectedTreeId:int = -1;
      
      private var _collectionScrollers:Array;
      
      private var velocitronLabel:TextField;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _treeData:Array;
      
      private var _treeNames:Dictionary;
      
      private var _nanovors:Array;
      
      private var _treeScroller:TileScroller;
      
      private var _nanovorsInTrees:Array;
      
      private var curTreeTileSelect:TreeTile = null;
      
      public function TreeViewMenu(param1:INanovorFactory, param2:Array, param3:Array, param4:Dictionary)
      {
         super();
         _nanovorFactory = param1;
         _nanovorsInTrees = param2;
         _nanovors = param3;
         _treeNames = param4;
         buildCollectionData();
         buildTreeData();
         buildTreeScroller();
         buildCollectionScrollers();
      }
      
      private function sortCollectionTiles(param1:String) : void
      {
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:CollectionTile = null;
         curSort = param1;
         var _loc2_:Boolean = true;
         var _loc3_:int = -1;
         var _loc4_:* = 0;
         while(_loc4_ < _collectionTiles.length)
         {
            _collectionTiles[_loc4_].sort(sortArrayOnCurrentStat);
            _loc5_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < _collectionTiles[_loc4_].length)
            {
               _collectionTiles[_loc4_][_loc6_].sort(sortTilesOnCurrentStat);
               _loc7_ = 0;
               while(_loc7_ < _collectionTiles[_loc4_][_loc6_].length)
               {
                  _loc8_ = _collectionTiles[_loc4_][_loc6_][_loc7_];
                  _loc8_.changeCurrentStat(param1);
                  if(_loc8_.nanovor.assetTypeId != _loc3_)
                  {
                     log("switching dir. old: " + _loc3_ + " != " + _loc8_.nanovor.assetTypeId + " : " + (_loc2_ ? "left" : "right"));
                     _loc2_ = !_loc2_;
                  }
                  _loc3_ = int(_loc8_.nanovor.assetTypeId);
                  _loc8_.faceRight(_loc2_);
                  _loc5_.push(_loc8_);
                  _loc7_++;
               }
               _loc6_++;
            }
            _collectionScrollers[_loc4_].addTiles(_loc5_);
            _loc4_++;
         }
      }
      
      public function getTileById(param1:String) : CollectionTile
      {
         var _loc2_:CollectionTile = collectionAssetIdDict[param1];
         if(null != _loc2_)
         {
            return _loc2_;
         }
         return null;
      }
      
      public function autoSelectFirstTree() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < _treeTiles.length)
         {
            if(Boolean(_treeTiles[_loc1_].getHasMembers()) || Boolean(_treeTiles[_loc1_].isAllowEmptyTreeSelect))
            {
               _isAutoSelect = true;
               _treeTiles[_loc1_].simulateClick();
               break;
            }
            _loc1_++;
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** TreeViewMenu: " + param1);
      }
      
      private function buildCollectionScrollers() : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:TileScroller = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:CollectionTile = null;
         _collectionBG = new CollectionBG();
         addChild(_collectionBG);
         _collectionBG.x = COLLECTION_BG_POINT.x;
         _collectionBG.y = COLLECTION_BG_POINT.y;
         _collectionBG.width = COLLECTION_SCROLLER_MASK_RECT.width;
         _collectionBG.alpha = 0;
         _collectionBG.mouseEnabled = false;
         _collectionBG.buttonMode = false;
         _collectionBG.mouseChildren = false;
         sortTab = new TileScrollerSortTab();
         addChild(sortTab);
         sortTab.x = COLLECTIONSCROLLER_X - sortTab.width;
         sortTab.y = COLLECTIONSCROLLER_Y;
         sortTab.alpha = 0;
         sortTab.addEventListener(TreeViewMenuEvent.SORTTAB_CLICK,onSortByClick,false,0,true);
         _collectionScrollers = new Array();
         _collectionTiles = new Array();
         var _loc1_:ChainLoadeeList = new ChainLoadeeList();
         for(_loc2_ in _collectionData)
         {
            _loc3_ = _collectionData[_loc2_];
            _loc4_ = parseInt(_loc2_);
            if(null != _loc3_)
            {
               _loc5_ = new TileScroller(null,CollectionTile.WIDTH,CollectionTile.HEIGHT,COLLECTION_SCROLLER_MASK_RECT.width,COLLECTION_SCROLLER_MASK_RECT.height,COLLECTION_SCROLLER_MASK_RECT.x);
               _loc5_.x = COLLECTIONSCROLLER_X;
               _loc5_.y = COLLECTIONSCROLLER_Y;
               _loc5_.visible = false;
               this.addChild(_loc5_);
               _loc6_ = new Array();
               for each(_loc7_ in _loc3_)
               {
                  _loc8_ = new Array();
                  for each(_loc9_ in _loc7_)
                  {
                     _loc10_ = new CollectionTile(_loc9_);
                     collectionDict[_loc10_.nanovor] = _loc10_;
                     collectionAssetIdDict[_loc10_.nanovor.assetId] = _loc10_;
                     _loc8_.push(_loc10_);
                     _loc1_.add(_loc10_);
                  }
                  if(0 < _loc8_.length)
                  {
                     _loc6_.push(_loc8_);
                  }
               }
               _collectionScrollers.push(_loc5_);
               _collectionTiles.push(_loc6_);
            }
         }
         sortCollectionTiles(StatsDisplayInfo.SWARMVALUE);
         _collectionTileChainLoader = new ChainLoaderRetry(_loc1_,this,this);
         _collectionTileChainLoader.load();
      }
      
      public function handleChainLoaderComplete(param1:IAssetCache) : void
      {
         _collectionTileChainLoader.destroy();
         _collectionTileChainLoader = null;
      }
      
      public function hide() : void
      {
         visible = false;
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGGING)
         {
            DebugLog.instance.log(">> TreeViewMenu: " + param1);
         }
      }
      
      public function getCollectionTiles(param1:int) : Array
      {
         return _collectionTiles[param1];
      }
      
      public function getTileNanovorById(param1:String) : INanovor
      {
         var _loc2_:CollectionTile = collectionAssetIdDict[param1];
         if(null != _loc2_)
         {
            return _loc2_.nanovor;
         }
         return null;
      }
      
      private function getFirstRootNanovorTypeId() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         while(_loc2_ < _collectionData.length)
         {
            if(Boolean(_collectionData[_loc2_]))
            {
               if(_collectionData[_loc2_].length > 0)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _collectionData[_loc2_].length)
                  {
                     if(Boolean(_collectionData[_loc2_][_loc3_]))
                     {
                        if(_collectionData[_loc2_][_loc3_].length > 0)
                        {
                           _loc1_ = int(_collectionData[_loc2_][_loc3_][0].nanovor.assetTypeId);
                           break;
                        }
                     }
                     _loc3_++;
                  }
                  break;
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function autoSelectFirstRoot() : void
      {
         var _loc1_:int = getFirstRootNanovorTypeId();
         if(_loc1_ > 0)
         {
            autoSelectByAssetTypeId(_loc1_);
         }
      }
      
      public function autoSelectByAssetTypeId(param1:int) : void
      {
         var _loc2_:CollectionTile = getCollectionTileByAssetTypeId(param1);
         if(Boolean(_loc2_))
         {
            autoSelectTile(_loc2_);
         }
      }
      
      private function sortArrayOnCurrentStat(param1:Array, param2:Array) : Number
      {
         return sortTilesOnCurrentStat(param1[0],param2[0]);
      }
      
      private function buildCollectionData() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:INanovor = null;
         var _loc9_:Object = null;
         _collectionData = new Array();
         for(_loc1_ in _nanovorsInTrees)
         {
            _loc2_ = parseInt(_loc1_);
            _loc3_ = _nanovorsInTrees[_loc1_];
            if(null != _loc3_)
            {
               log("buildCollectionData() - Creating treeId " + _loc2_);
               _collectionData[_loc2_] = new Array();
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = int(_loc3_[_loc4_]);
                  _loc6_ = getNanovorsOfType(_loc5_);
                  if(0 < _loc6_.length)
                  {
                     _loc7_ = new Array();
                     for each(_loc8_ in _loc6_)
                     {
                        _loc9_ = new Object();
                        _loc9_.nanovor = _loc8_;
                        _loc9_.isNew = isNanovorNew(_loc8_);
                        _loc9_.treeId = _loc2_;
                        _loc7_.push(_loc9_);
                     }
                     _collectionData[_loc2_][_loc4_] = _loc7_;
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      public function replaceTileById(param1:String) : void
      {
         var _loc2_:CollectionTile = collectionAssetIdDict[param1];
         if(null != _loc2_)
         {
            log("replaceTileById()");
            _loc2_.deselect();
         }
         else
         {
            log("replaceTileById() - Not Found");
         }
      }
      
      public function handleChainLoaderError() : void
      {
         logError("handleChainLoaderError()");
         _collectionTileChainLoader.resumeChainLoadAfterError();
      }
      
      public function replaceTile(param1:INanovor) : void
      {
         var _loc2_:CollectionTile = null;
         for each(_loc2_ in collectionDict)
         {
            if(_loc2_.nanovor.assetId == param1.assetId)
            {
               _loc2_.deselect();
            }
         }
      }
      
      private function isNanovorNew(param1:INanovor) : Boolean
      {
         var _loc2_:Date = param1.fullEvolveDate;
         var _loc3_:Date = new Date();
         var _loc4_:Number = _loc3_.time - _loc2_.time;
         return _loc4_ <= IS_NEW_THRESHOLD;
      }
      
      public function openFirst() : void
      {
         var _loc1_:TreeTile = null;
         var _loc2_:CollectionTile = null;
         for each(_loc1_ in _treeTiles)
         {
            log("openFirst() - TreeTile.getHasMembers(): " + _loc1_.getHasMembers());
            if(_loc1_.getHasMembers())
            {
               _loc1_.simulateClick();
               _loc2_ = _collectionScrollers[_currentSelectedTreeId].openFirst();
               if(null != _loc2_)
               {
                  dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_CLICK,{"nanovor":_loc2_.nanovor}));
               }
               return;
            }
         }
      }
      
      public function autoSelectByAssetId(param1:String) : void
      {
         log("autoSelectByAssetId() - assetId " + param1);
         var _loc2_:CollectionTile = getCollectionTileByAssetId(param1);
         autoSelectTile(_loc2_);
      }
      
      private function setBGColor(param1:uint) : void
      {
         var _loc2_:AdjustColor = new AdjustColor();
         switch(param1)
         {
            case ColorMap.FACTION_MAGNAMOD:
               _loc2_.brightness = 0;
               _loc2_.contrast = 0;
               _loc2_.saturation = 0;
               _loc2_.hue = 0;
               break;
            case ColorMap.FACTION_VELOCITRON:
               _loc2_.brightness = 65;
               _loc2_.contrast = 18;
               _loc2_.saturation = 47;
               _loc2_.hue = 55;
               break;
            case ColorMap.FACTION_HEXITE:
               _loc2_.brightness = 5;
               _loc2_.contrast = 6;
               _loc2_.saturation = 26;
               _loc2_.hue = -180;
         }
      }
      
      private function buildTreeScroller() : void
      {
         var _loc2_:TreeTile = null;
         _treesBG = new TreesBG();
         addChild(_treesBG);
         _treesBG.x = TREE_BG_POINT.x;
         _treesBG.y = TREE_BG_POINT.y;
         _treesBG.alpha = 0;
         _treesBG.mouseEnabled = false;
         _treesBG.buttonMode = false;
         _treesBG.mouseChildren = false;
         _treeScroller = new TileScroller(ITreeViewMenu(this),TreeTile.WIDTH,TreeTile.HEIGHT,TREE_SCROLLER_MASK_RECT.width,TREE_SCROLLER_MASK_RECT.height,TREE_SCROLLER_MASK_RECT.x,0.2);
         addChild(_treeScroller);
         _treeScroller.x = TREE_SCROLLER_POINT.x;
         _treeScroller.y = TREE_SCROLLER_POINT.y;
         _waveTabLeft = new TileScrollerWaveTab();
         addChild(_waveTabLeft);
         _waveTabLeft.x = TREE_SCROLLER_POINT.x - _waveTabLeft.width;
         _waveTabLeft.y = TREE_SCROLLER_POINT.y;
         _waveTabRight = new TileScrollerWaveTab(true);
         addChild(_waveTabRight);
         _waveTabRight.x = TREE_SCROLLER_POINT.x + TREE_SCROLLER_MASK_RECT.width;
         _waveTabRight.y = TREE_SCROLLER_POINT.y;
         _treeTiles = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < _treeData.length)
         {
            _loc2_ = new TreeTile(_treeData[_loc1_],_loc1_);
            _treeTiles.push(_loc2_);
            _loc2_.addEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick,false,0,true);
            _loc1_++;
         }
         _treeScroller.addTiles(_treeTiles);
         makeFactionLabels();
         _treeScroller.reveal();
         Tweener.addTween(_treesBG,{
            "alpha":1,
            "time":2,
            "transition":"easeOutQuad"
         });
      }
      
      private function getCollectionTileByAssetId(param1:String) : CollectionTile
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:CollectionTile = null;
         var _loc2_:* = 0;
         while(_loc2_ < _collectionTiles.length)
         {
            _loc3_ = 0;
            while(_loc3_ < _collectionTiles[_loc2_].length)
            {
               _loc4_ = 0;
               while(_loc4_ < _collectionTiles[_loc2_][_loc3_].length)
               {
                  _loc5_ = _collectionTiles[_loc2_][_loc3_][_loc4_];
                  if(_loc5_.nanovor.assetId == param1)
                  {
                     return _loc5_;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function onSortByClick(param1:TreeViewMenuEvent) : void
      {
         sortCollectionTiles(param1.data.sort);
         if(_showCollectionTiles)
         {
            _collectionScrollers[_currentSelectedTreeId].reveal();
         }
      }
      
      public function updateNanovor(param1:INanovor) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:CollectionTile = null;
         var _loc2_:* = 0;
         while(_loc2_ < _collectionTiles.length)
         {
            _loc3_ = 0;
            while(_loc3_ < _collectionTiles[_loc2_].length)
            {
               _loc4_ = 0;
               while(_loc4_ < _collectionTiles[_loc2_][_loc3_].length)
               {
                  _loc5_ = _collectionTiles[_loc2_][_loc3_][_loc4_];
                  if(_loc5_.nanovor.assetId == param1.assetId)
                  {
                     _loc5_.updateNanovor(param1);
                     return;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function logCollectionTiles() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < _collectionTiles.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _collectionTiles[_loc1_].length)
            {
               _loc3_ = 0;
               while(_loc3_ < _collectionTiles[_loc1_][_loc2_].length)
               {
                  log(".......................");
                  log("TYPE   \t: " + _collectionTiles[_loc1_][_loc2_][_loc3_].nanovor.assetTypeId);
                  log("INSTANCE\t: " + _collectionTiles[_loc1_][_loc2_][_loc3_].nanovor.assetId);
                  log("NAME\t\t: " + _collectionTiles[_loc1_][_loc2_][_loc3_].nanovor.name);
                  _loc3_++;
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function revealCollectionScrollerBG() : void
      {
         Tweener.addTween(sortTab,{"base":COLLECTION_REVEAL_TWEEN_BASE});
         Tweener.addTween(_collectionBG,{"base":COLLECTION_REVEAL_TWEEN_BASE});
      }
      
      public function selectTileById(param1:String) : void
      {
         var _loc2_:CollectionTile = collectionAssetIdDict[param1];
         if(null != _loc2_)
         {
            log("selectTileById()");
            _loc2_.select();
         }
         else
         {
            log("selectTileById() - Not Found");
         }
      }
      
      private function changeCollectionScroller(param1:int) : void
      {
         if(isFirstTreeSelect)
         {
            isFirstTreeSelect = false;
            if(_showCollectionTiles)
            {
               revealCollectionScrollerBG();
            }
            else
            {
               _collectionBG.mouseEnabled = false;
               _collectionBG.mouseChildren = false;
               sortTab.mouseEnabled = false;
               sortTab.mouseChildren = false;
            }
         }
         else
         {
            _collectionScrollers[_currentSelectedTreeId].hide();
         }
         _currentSelectedTreeId = param1;
         if(_showCollectionTiles)
         {
            _collectionScrollers[_currentSelectedTreeId].reveal(_isAutoSelect);
         }
         _isAutoSelect = false;
         dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTION_OPENED,this));
      }
      
      public function selectTile(param1:INanovor) : void
      {
         var _loc2_:CollectionTile = collectionDict[param1];
         if(Boolean(_loc2_))
         {
            _loc2_.select();
         }
      }
      
      private function logCollectionData() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < _collectionData.length)
         {
            if(Boolean(_collectionData[_loc1_]))
            {
               log("TREE " + _loc1_ + ": ---------------------------------------------");
               _loc2_ = 0;
               while(_loc2_ < _collectionData[_loc1_].length)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _collectionData[_loc1_][_loc2_].length)
                  {
                     log(".......................: " + _loc1_ + " - " + _loc2_ + " - " + _loc3_);
                     log("TYPE   \t: " + _collectionData[_loc1_][_loc2_][_loc3_].nanovor.assetTypeId);
                     log("INSTANCE\t: " + _collectionData[_loc1_][_loc2_][_loc3_].nanovor.assetId);
                     log("NAME\t\t: " + _collectionData[_loc1_][_loc2_][_loc3_].nanovor.name);
                     _loc3_++;
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      private function sortTilesOnCurrentStat(param1:CollectionTile, param2:CollectionTile) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(curSort)
         {
            case StatsDisplayInfo.SWARMVALUE:
               _loc3_ = int(param1.nanovor.swarmValue);
               _loc4_ = int(param2.nanovor.swarmValue);
               break;
            case StatsDisplayInfo.SPEED:
               _loc3_ = int(param1.nanovor.speed);
               _loc4_ = int(param2.nanovor.speed);
               break;
            case StatsDisplayInfo.ARMOR:
               _loc3_ = int(param1.nanovor.armor);
               _loc4_ = int(param2.nanovor.armor);
               break;
            case StatsDisplayInfo.STRENGTH:
               _loc3_ = int(param1.nanovor.strength);
               _loc4_ = int(param2.nanovor.strength);
               break;
            case StatsDisplayInfo.HEALTH:
               _loc3_ = int(param1.nanovor.health);
               _loc4_ = int(param2.nanovor.health);
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      public function getTreeTiles() : Array
      {
         return _treeTiles;
      }
      
      private function autoSelectTile(param1:CollectionTile) : void
      {
         var _loc2_:TreeTile = null;
         var _loc3_:INanovor = null;
         var _loc4_:TileScroller = null;
         _isAutoSelect = true;
         for each(_loc2_ in _treeTiles)
         {
            if(_loc2_.getTreeID() == param1.treeId)
            {
               log("autoSelectTile() - treeTile.x: " + _loc2_.x);
               _treeScroller.autoScrollTo(_loc2_.x);
               _loc2_.simulateClick();
               break;
            }
         }
         _loc3_ = param1.nanovor;
         _waveTabLeft.updateWave(_loc3_.wave);
         _waveTabRight.updateWave(_loc3_.wave);
         param1.simulateRollOver();
         param1.simulateClick();
         _loc4_ = _collectionScrollers[_currentSelectedTreeId] as TileScroller;
         _loc4_.autoScrollTo(param1.x);
      }
      
      private function onTreeTileClick(param1:TreeViewMenuEvent) : void
      {
         if(Boolean(curTreeTileSelect))
         {
            curTreeTileSelect.deselect();
         }
         var _loc2_:TreeTile = TreeTile(param1.data.tile);
         if(curTreeTileSelect == null || curTreeTileSelect.tileFactionColor != _loc2_.tileFactionColor)
         {
            setBGColor(_loc2_.tileFactionColor);
         }
         curTreeTileSelect = _loc2_;
         changeCollectionScroller(int(param1.data.posID));
      }
      
      public function showCollectionTiles(param1:Boolean) : void
      {
         _showCollectionTiles = param1;
      }
      
      public function allowEmptyTreeSelect() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < _treeTiles.length)
         {
            _treeTiles[_loc1_].allowEmptyTreeSelect();
            _loc1_++;
         }
      }
      
      public function checkTileEligibility(param1:int) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:CollectionTile = null;
         var _loc2_:Boolean = false;
         var _loc3_:* = 0;
         while(_loc3_ < _collectionTiles.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _collectionTiles[_loc3_].length)
            {
               _loc5_ = 0;
               while(_loc5_ < _collectionTiles[_loc3_][_loc4_].length)
               {
                  _loc6_ = _collectionTiles[_loc3_][_loc4_][_loc5_];
                  if(_loc6_.nanovor.swarmValue <= param1)
                  {
                     _loc2_ = true;
                     _loc6_.enable();
                  }
                  else
                  {
                     _loc6_.disable();
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getCurrectTreeId() : int
      {
         return _currentSelectedTreeId;
      }
      
      public function setNanovor(param1:INanovor) : void
      {
         var _loc6_:int = 0;
         var _loc7_:TreeTile = null;
         var _loc2_:int = -1;
         var _loc3_:CollectionTile = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < _collectionTiles.length)
         {
            _loc6_ = 0;
            while(_loc6_ < _collectionTiles[_loc5_].length)
            {
               _loc3_ = _collectionTiles[_loc5_][_loc6_][0];
               if(_loc3_.nanovor.assetTypeId == param1.assetTypeId)
               {
                  _loc2_ = _loc5_;
                  _loc4_ = true;
                  break;
               }
               _loc6_++;
            }
            if(_loc4_)
            {
               break;
            }
            _loc5_++;
         }
         if(_loc2_ > -1 && _loc3_ != null)
         {
            _loc7_ = TreeTile(_treeTiles[_loc2_]);
            if(curTreeTileSelect != _loc7_)
            {
               _loc7_.select();
               onTreeTileClick(new TreeViewMenuEvent("",{
                  "tile":_loc7_,
                  "posID":_loc7_.posID
               }));
               dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.TREETILE_CLICK,{
                  "tile":_loc7_,
                  "posID":_loc7_.getPosition(),
                  "treeID":_loc7_.getTreeID()
               }));
            }
            _loc3_.select();
            dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.COLLECTIONTILE_CLICK,{"nanovor":_loc3_.nanovor}));
         }
      }
      
      private function makeFactionLabels() : void
      {
         var _loc1_:EuroStileCondensed = new EuroStileCondensed();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = _loc1_.fontName;
         _loc2_.size = 12;
         var _loc3_:int = _treeTiles[3].x - _treeTiles[0].x + _treeTiles[3].width;
         _loc2_.color = ColorMap.FACTION_MAGNAMOD;
         magnamodLabel = new TextField();
         magnamodLabel.embedFonts = true;
         magnamodLabel.text = NanovorFaction.MAGNAMOD.toUpperCase();
         magnamodLabel.setTextFormat(_loc2_);
         magnamodLabel.autoSize = TextFieldAutoSize.CENTER;
         magnamodLabel.multiline = false;
         addChild(magnamodLabel);
         magnamodLabel.y = TREE_SCROLLER_POINT.y - 15;
         magnamodLabel.x = _treeTiles[0].x + _loc3_ / 2 - magnamodLabel.width / 2;
         _loc2_.color = ColorMap.FACTION_VELOCITRON;
         velocitronLabel = new TextField();
         velocitronLabel.embedFonts = true;
         velocitronLabel.text = NanovorFaction.VELOCITRON.toUpperCase();
         velocitronLabel.setTextFormat(_loc2_);
         velocitronLabel.autoSize = TextFieldAutoSize.CENTER;
         velocitronLabel.multiline = false;
         addChild(velocitronLabel);
         velocitronLabel.y = TREE_SCROLLER_POINT.y - 15;
         velocitronLabel.x = _treeTiles[4].x + _loc3_ / 2 - velocitronLabel.width / 2;
         _loc2_.color = ColorMap.FACTION_HEXITE;
         hexiteLabel = new TextField();
         hexiteLabel.embedFonts = true;
         hexiteLabel.text = NanovorFaction.HEXITE.toUpperCase();
         hexiteLabel.setTextFormat(_loc2_);
         hexiteLabel.autoSize = TextFieldAutoSize.CENTER;
         hexiteLabel.multiline = false;
         addChild(hexiteLabel);
         hexiteLabel.y = TREE_SCROLLER_POINT.y - 15;
         hexiteLabel.x = _treeTiles[8].x + _loc3_ / 2 - hexiteLabel.width / 2;
      }
      
      public function getNanovorsOfType(param1:int) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < _nanovors.length)
         {
            if(_nanovors[_loc3_].assetTypeId == param1)
            {
               _loc2_.push(_nanovors[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function getCollectionTileByAssetTypeId(param1:int) : CollectionTile
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:CollectionTile = null;
         var _loc2_:* = 0;
         while(_loc2_ < _collectionTiles.length)
         {
            _loc3_ = 0;
            while(_loc3_ < _collectionTiles[_loc2_].length)
            {
               _loc4_ = 0;
               while(_loc4_ < _collectionTiles[_loc2_][_loc3_].length)
               {
                  _loc5_ = _collectionTiles[_loc2_][_loc3_][_loc4_];
                  if(_loc5_.nanovor.assetTypeId == param1)
                  {
                     return _loc5_;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function buildTreeData() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         _treeData = new Array();
         for(_loc1_ in _nanovorsInTrees)
         {
            _loc2_ = parseInt(_loc1_);
            _loc3_ = _nanovorsInTrees[_loc1_];
            _loc4_ = _collectionData[_loc2_];
            _loc5_ = 0;
            for each(_loc6_ in _loc4_)
            {
               for each(_loc8_ in _loc6_)
               {
                  if(Boolean(_loc8_.isNew))
                  {
                     _loc5_++;
                  }
               }
            }
            _loc7_ = new Object();
            _loc7_.treeID = _loc2_;
            _loc7_.name = null != _treeNames[_loc1_] ? _treeNames[_loc1_].toUpperCase() : "";
            _loc7_.nanovor = _nanovorFactory.createNanovorTypeById(_loc3_[0]);
            _loc7_.hasMembers = Boolean(_loc4_.length > 0);
            _loc7_.totalNew = _loc5_;
            _treeData.push(_loc7_);
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:CollectionTile = null;
         var _loc2_:TreeTile = null;
         var _loc3_:TileScroller = null;
         if(_collectionBG != null)
         {
            _collectionBG.stop();
            removeChild(_collectionBG);
         }
         if(_waveTabLeft != null)
         {
            _waveTabLeft.stop();
            removeChild(_waveTabLeft);
         }
         if(_waveTabRight != null)
         {
            _waveTabRight.stop();
            removeChild(_waveTabRight);
         }
         if(_collectionTileChainLoader != null)
         {
            _collectionTileChainLoader.destroy();
            _collectionTileChainLoader = null;
         }
         if(_treeTiles != null)
         {
            for each(_loc2_ in _treeTiles)
            {
               _loc2_.removeEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick);
               _loc2_.destroy();
            }
         }
         if(sortTab != null)
         {
            sortTab.removeEventListener(TreeViewMenuEvent.SORTTAB_CLICK,onSortByClick);
            sortTab.destroy();
            sortTab.stop();
            removeChild(sortTab);
         }
         for each(_loc1_ in collectionDict)
         {
            _loc1_.destroy();
         }
         if(_collectionScrollers != null)
         {
            for each(_loc3_ in _collectionScrollers)
            {
               _loc3_.destroy();
            }
         }
         if(_treeScroller != null)
         {
            _treeScroller.destroy();
         }
      }
      
      public function handleTileScrollerPaging(param1:int) : void
      {
         _waveTabLeft.updateWave(param1);
         _waveTabRight.updateWave(param1);
      }
   }
}

