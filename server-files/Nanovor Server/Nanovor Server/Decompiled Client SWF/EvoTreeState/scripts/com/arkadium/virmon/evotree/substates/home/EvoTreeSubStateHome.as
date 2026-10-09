package com.arkadium.virmon.evotree.substates.home
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.EvoTreeEvoChecker;
   import com.arkadium.virmon.evotree.IEvoTreeEvolverFactory;
   import com.arkadium.virmon.evotree.grid.EvoTreeGrid;
   import com.arkadium.virmon.evotree.grid.EvoTreeGridController;
   import com.arkadium.virmon.evotree.grid.IEvoTreeGridController;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.NanovorEvoTreeGridColorProvider;
   import com.arkadium.virmon.evotree.grid.positioner.EvoTreeGridPositioner;
   import com.arkadium.virmon.evotree.ui.treename.EvoTreeName;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.ITreeViewMenuData;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenuEvent;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.arkadium.virmon.state.IStateChanger;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class EvoTreeSubStateHome extends AbstractSubState implements IEvoTreeNanovorSelector
   {
      
      private static const TREEVIEW_MENU_POSITION:Point = new Point(57,122);
      
      private static const EVO_TREE_GRID_POSITION:Point = new Point(0,220);
      
      private static const EVO_TREE_NAME_POSITION:Point = new Point(80,220);
      
      private var _treeViewMenu:TreeViewMenu;
      
      private var _evoTreeGrid:EvoTreeGrid;
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _evoTreeName:EvoTreeName;
      
      private var _selectedNanovor:INanovor;
      
      private var _uiContainer:DisplayObjectContainer;
      
      private var _preSelectedNanovorId:String;
      
      private var _selectedTreeId:int;
      
      private var _evoTreeGridController:IEvoTreeGridController;
      
      public function EvoTreeSubStateHome(param1:INanovorFactory, param2:IEvoManager, param3:IBadgeManager, param4:IEMManager, param5:DisplayObjectContainer, param6:ITreeViewMenuData, param7:Array, param8:IVirmonManager, param9:IUserProfile, param10:IEvoTreeEvolverFactory, param11:IStateChanger, param12:String = null)
      {
         super();
         _nanovorFactory = param1;
         _uiContainer = param5;
         _preSelectedNanovorId = param12;
         createTreeViewMenu(param6);
         createEvoGrid(param7,param8,_nanovorFactory,param2,param3,param4,param9,param10,param11);
         createEvoTreeName(param6.treeNames);
      }
      
      private function createTreeViewMenu(param1:ITreeViewMenuData) : void
      {
         _treeViewMenu = new TreeViewMenu(_nanovorFactory,param1.nanovorsIdsInTrees,param1.nanovors,param1.treeNames);
         _treeViewMenu.mouseEnabled = false;
         _treeViewMenu.x = TREEVIEW_MENU_POSITION.x;
         _treeViewMenu.y = TREEVIEW_MENU_POSITION.y;
         _treeViewMenu.showCollectionTiles(false);
         _treeViewMenu.allowEmptyTreeSelect();
         _treeViewMenu.addEventListener(TreeViewMenuEvent.COLLECTIONTILE_CLICK,onCollectionTileClick,false,0,true);
         _treeViewMenu.addEventListener(TreeViewMenuEvent.TREETILE_CLICK,onTreeTileClick,false,0,true);
         _uiContainer.addChild(_treeViewMenu);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoTreeSubStateHome>>\t" + param1);
      }
      
      override public function setSubState() : void
      {
         if(null == _preSelectedNanovorId)
         {
            _treeViewMenu.autoSelectFirstRoot();
         }
         else
         {
            _treeViewMenu.autoSelectByAssetId(_preSelectedNanovorId);
         }
      }
      
      private function onCollectionTileClick(param1:TreeViewMenuEvent) : void
      {
         replaceSelectedTitle();
         _selectedNanovor = param1.data.nanovor as INanovor;
         log("onCollectionTileClick() - Selecting tree: " + _selectedTreeId);
         log("onCollectionTileClick() - Selecting nanovor type: " + _selectedNanovor.assetTypeId);
      }
      
      private function onTreeTileClick(param1:TreeViewMenuEvent) : void
      {
         replaceSelectedTitle();
         var _loc2_:Object = param1.data as Object;
         var _loc3_:int = int(_loc2_.treeID);
         var _loc4_:String = _loc2_.faction;
         _selectedTreeId = _loc3_;
         log("onTreeTileClick() - Selecting treeId " + _loc3_);
         _evoTreeGridController.selectTree(_loc3_);
         _evoTreeName.changeTreeId(_loc3_,_loc4_);
      }
      
      public function selectNanovorByAssetTypeId(param1:int) : void
      {
         var _loc2_:INanovor = null;
         var _loc3_:Array = _treeViewMenu.getNanovorsOfType(param1);
         if(0 < _loc3_.length)
         {
            _loc2_ = _treeViewMenu.getNanovorsOfType(param1)[0];
         }
         _evoTreeGridController.selectNanovor(_selectedTreeId,param1,_loc2_);
      }
      
      private function createEvoGrid(param1:Array, param2:IVirmonManager, param3:INanovorFactory, param4:IEvoManager, param5:IBadgeManager, param6:IEMManager, param7:IUserProfile, param8:IEvoTreeEvolverFactory, param9:IStateChanger) : void
      {
         _evoTreeGridController = new EvoTreeGridController(param3,param1,new EvoTreeEvoChecker(param2,param3,param4,param5,param6,param7),param2,param7,param8,param9,IEvoTreeNanovorSelector(this),new EvoTreeGridPositioner(),_treeViewMenu,new NanovorEvoTreeGridColorProvider());
         _evoTreeGrid = new EvoTreeGrid(_evoTreeGridController);
         _evoTreeGrid.x = EVO_TREE_GRID_POSITION.x;
         _evoTreeGrid.y = EVO_TREE_GRID_POSITION.y;
         _uiContainer.addChildAt(_evoTreeGrid,0);
      }
      
      private function replaceSelectedTitle() : void
      {
         if(null != _selectedNanovor)
         {
            _treeViewMenu.replaceTile(_selectedNanovor);
            _selectedNanovor = null;
         }
      }
      
      private function createEvoTreeName(param1:Dictionary) : void
      {
         _evoTreeName = new EvoTreeName(param1);
         _evoTreeName.x = EVO_TREE_NAME_POSITION.x;
         _evoTreeName.y = EVO_TREE_NAME_POSITION.y;
         _uiContainer.addChild(_evoTreeName);
      }
   }
}

