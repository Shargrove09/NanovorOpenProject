package com.arkadium.virmon.evotree.grid.gridinfo
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.grid.IEvoTreeGridNodeController;
   import com.arkadium.virmon.evotree.grid.gridinfo.controller.EvoTreeGridInfoController;
   import com.arkadium.virmon.evotree.grid.gridinfo.model.EvoTreeGridInfoModel;
   import com.arkadium.virmon.evotree.grid.gridinfo.view.EvoTreeGridInfoView;
   import com.arkadium.virmon.evotree.substates.home.IEvoTreeNanovorSelector;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.ITreeViewMenu;
   import flash.display.Sprite;
   
   public class EvoTreeGridInfo extends Sprite implements IEvoTreeGridInfo
   {
      
      private var _view:EvoTreeGridInfoView;
      
      private var _nanovorSelector:IEvoTreeNanovorSelector;
      
      private var _model:EvoTreeGridInfoModel;
      
      private var _controller:EvoTreeGridInfoController;
      
      public function EvoTreeGridInfo(param1:INanovorFactory, param2:int, param3:ITreeViewMenu, param4:IEvoTreeNanovorSelector, param5:IEvoTreeGridNodeController)
      {
         super();
         _nanovorSelector = param4;
         var _loc6_:INanovor = param1.createNanovorTypeById(param2);
         _model = new EvoTreeGridInfoModel(param2,param3,param5);
         _controller = new EvoTreeGridInfoController(_model);
         _view = new EvoTreeGridInfoView(_controller,_loc6_.name,_loc6_.swarmValue);
         _model.addConsumer(_view);
         _model.init();
         this.addChild(_view);
         this.mouseEnabled = false;
         _view.visible = false;
      }
      
      public function toggle(param1:Boolean) : void
      {
         _view.visible = param1;
      }
      
      public function selectNanovor(param1:INanovor) : void
      {
         _model.selectNanovor(param1);
      }
      
      public function get sprite() : Sprite
      {
         return this;
      }
   }
}

