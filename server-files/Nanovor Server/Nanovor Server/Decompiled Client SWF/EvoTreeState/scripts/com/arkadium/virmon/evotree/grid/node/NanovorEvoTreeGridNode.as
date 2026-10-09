package com.arkadium.virmon.evotree.grid.node
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.evotree.IEvoTreeCanEvolveResponse;
   import com.arkadium.virmon.evotree.grid.gridinfo.IEvoTreeGridInfo;
   import com.arkadium.virmon.evotree.grid.node.colorprovider.IEvoTreeGridColorProvider;
   import com.arkadium.virmon.evotree.node.EvoTreeNodeType;
   import com.arkadium.virmon.evotree.ui.EvoTreeGridNodePuck;
   import com.arkadium.virmon.evotree.ui.EvoTreeGridNodePuckModes;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NanovorEvoTreeGridNode extends EvoTreeGridNode implements INanovorEvoTreeGridNode
   {
      
      private var _assetTypeId:int;
      
      private var _clickEnabled:Boolean;
      
      private var _evoButtonContainer:Sprite;
      
      private var _evoTreeGridInfo:IEvoTreeGridInfo;
      
      private var _consumer:INanovorEvoTreeGridNodeConsumer;
      
      private var _icon:EvoTreeGridNodePuck;
      
      private var _evoButtons:Array;
      
      private var _colorProvider:IEvoTreeGridColorProvider;
      
      public function NanovorEvoTreeGridNode(param1:int, param2:Boolean, param3:Boolean, param4:int, param5:int, param6:IEvoTreeGridInfo, param7:int, param8:IEvoTreeGridColorProvider)
      {
         super(param4,param5);
         _assetTypeId = param1;
         _colorProvider = param8;
         _lineColor = _colorProvider.lineColorInactive;
         _evoTreeGridInfo = param6;
         _sprite.addChild(_evoTreeGridInfo.sprite);
         _icon = new EvoTreeGridNodePuck(EvoTreeNodeType.ACTIVE,param3,param2,param1,false,param7,_colorProvider);
         _icon.setMode(EvoTreeGridNodePuckModes.MODE_INACTIVE);
         _icon.addEventListener(MouseEvent.CLICK,handlePuckClick,false,0,true);
         _sprite.addChild(_icon);
         _evoButtonContainer = new Sprite();
         _evoButtonContainer.mouseEnabled = false;
         _sprite.addChild(_evoButtonContainer);
         _evoButtons = new Array();
         _clickEnabled = true;
      }
      
      public function setEvolutionButtons(param1:INanovorEvoTreeGridNode, param2:Sprite) : void
      {
         var _loc5_:Array = null;
         var _loc3_:int = param1.positionY - this.positionY;
         param2.y = _loc3_ * 140;
         param2.alpha = 0;
         var _loc4_:int = 138;
         if(-1 == this.positionX)
         {
            _loc4_ += 146 + param1.positionX * 90;
         }
         param2.x = _loc4_;
         param2.alpha = 1;
         _evoButtons.push([param1.positionY,param2]);
         _evoButtons.sortOn("0",Array.NUMERIC);
         for each(_loc5_ in _evoButtons)
         {
            _evoButtonContainer.addChild(_loc5_[1]);
         }
      }
      
      public function lineBackToSource(param1:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:IEvoTreeGridNode = this;
         while(null != _loc2_)
         {
            _loc3_ = param1 ? _colorProvider.lineColorCanEvolve : _colorProvider.lineColorCantevolve;
            _loc2_.setLineColor(_loc3_);
            _loc2_ = _loc2_.source;
            if(null != _loc2_ as INanovorEvoTreeGridNode)
            {
               return;
            }
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<NanovorEvoTreeGridNode>>\t" + param1);
      }
      
      override public function setLineColor(param1:uint) : void
      {
         _icon.setFlatTint(param1);
         super.setLineColor(param1);
      }
      
      private function handlePuckClick(param1:MouseEvent) : void
      {
         if(null != _consumer && _clickEnabled)
         {
            _consumer.handleNanovorNodeClick(INanovorEvoTreeGridNode(this),_evoData);
         }
      }
      
      public function toggleClick(param1:Boolean) : void
      {
         _clickEnabled = param1;
         _icon.buttonMode = _clickEnabled;
      }
      
      public function clearEvolveButtons() : void
      {
         while(_evoButtonContainer.numChildren > 0)
         {
            _evoButtonContainer.removeChildAt(0);
         }
         _evoButtons = new Array();
      }
      
      public function get assetTypeId() : int
      {
         return _assetTypeId;
      }
      
      public function setCantEvolveReasons(param1:IEvoTreeCanEvolveResponse) : void
      {
         _icon.setCantEvolveReasons(param1);
      }
      
      public function preselectSpecificNanovor(param1:INanovor) : void
      {
         _evoTreeGridInfo.selectNanovor(param1);
      }
      
      override public function drawLineToParent(param1:Number = 1) : void
      {
         if(null == _source)
         {
            return;
         }
         var _loc2_:Sprite = _source.sprite;
         if(null != _loc2_ && null != _sprite)
         {
            _sprite.graphics.clear();
            _sprite.graphics.lineStyle(4,_lineColor,param1);
            _sprite.graphics.lineTo(_loc2_.x - _sprite.x,_loc2_.y - _sprite.y);
         }
      }
      
      public function setIconMode(param1:EvoTreeGridNodePuckModes) : void
      {
         _icon.setMode(param1);
         var _loc2_:Boolean = Boolean(param1 == EvoTreeGridNodePuckModes.MODE_SELECTED);
         _evoTreeGridInfo.toggle(_loc2_);
         if(!_loc2_)
         {
            while(_evoButtonContainer.numChildren > 0)
            {
               _evoButtonContainer.removeChildAt(0);
            }
         }
      }
      
      public function setConsumer(param1:INanovorEvoTreeGridNodeConsumer) : void
      {
         _consumer = param1;
      }
   }
}

