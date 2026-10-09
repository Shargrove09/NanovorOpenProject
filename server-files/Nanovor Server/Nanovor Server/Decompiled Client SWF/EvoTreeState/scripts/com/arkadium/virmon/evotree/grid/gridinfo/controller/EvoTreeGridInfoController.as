package com.arkadium.virmon.evotree.grid.gridinfo.controller
{
   import com.arkadium.virmon.evotree.grid.gridinfo.model.IEvoTreeGridInfoModel;
   
   public class EvoTreeGridInfoController implements IEvoTreeGridInfoController
   {
      
      private var _model:IEvoTreeGridInfoModel;
      
      public function EvoTreeGridInfoController(param1:IEvoTreeGridInfoModel)
      {
         super();
         _model = param1;
      }
      
      public function handleCollectionButtonClick() : void
      {
         _model.gotoCollection();
      }
      
      public function handleRightArrowClick() : void
      {
         _model.selectNextNanovor();
      }
      
      public function handleLeftArrowClick() : void
      {
         _model.selectPreviousNanovor();
      }
   }
}

