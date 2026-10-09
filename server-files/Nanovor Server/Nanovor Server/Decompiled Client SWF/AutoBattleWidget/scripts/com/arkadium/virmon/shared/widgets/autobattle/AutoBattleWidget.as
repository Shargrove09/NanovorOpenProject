package com.arkadium.virmon.shared.widgets.autobattle
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.collection.ICollectionState;
   import com.arkadium.virmon.home.IHomeNewsBlocker;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.mdm.MDMBrowserKey;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.widgets.AbstractWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.autobattle.autobattleselector.AutoBattleSelector;
   import com.arkadium.virmon.shared.widgets.autobattle.autobattleselector.IAutoBattleSelector;
   import com.arkadium.virmon.shared.widgets.autobattle.autobattleselector.IAutoBattleSelectorConsumer;
   import com.arkadium.virmon.shared.widgets.megawidget.IMegaWidget;
   import com.arkadium.virmon.state.AbstractState;
   import com.arkadium.virmon.state.StateType;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AutoBattleWidget extends AbstractWidget implements IAutoBattleWidget, IAutoBattleSelectorConsumer, IHomeNewsBlocker
   {
      
      private static const FOOTER_Y:int = 703;
      
      private static const FOOTER_Y_HIDDEN:int = 768;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      public var mcBacker:Sprite;
      
      public var mcFooter:MovieClip;
      
      private var _selectorIsInView:Boolean = false;
      
      private var _autoBattleSelectorContainer:Sprite;
      
      private var _autoBattleSelector:IAutoBattleSelector;
      
      private var _battleButton:SimpleButton;
      
      public function AutoBattleWidget()
      {
         super(WidgetType.WIDGET_AUTO_BATTLE);
         _battleButton = mcFooter.btnRedButton as SimpleButton;
         this.mouseEnabled = false;
         mcBacker.alpha = 0;
         mcBacker.mouseEnabled = false;
         mcBacker.mouseChildren = false;
         mcFooter.mouseEnabled = false;
         _autoBattleSelector = new AutoBattleSelector();
         _autoBattleSelector.init(IAutoBattleSelectorConsumer(this));
         var _loc1_:DisplayObject = _autoBattleSelector as DisplayObject;
         _loc1_.x = 207;
         _loc1_.y = 177;
         this.removeChild(mcBacker);
      }
      
      private function hideSelector() : void
      {
         _selectorIsInView = false;
         _autoBattleSelector.hide();
         var _loc1_:DisplayObject = _autoBattleSelector as DisplayObject;
         if(null != _loc1_.parent)
         {
            _loc1_.parent.removeChild(_loc1_);
         }
      }
      
      private function showSelector() : void
      {
         _autoBattleSelector.show();
         var _loc1_:DisplayObject = _autoBattleSelector as DisplayObject;
         _autoBattleSelectorContainer.addChild(_loc1_);
      }
      
      public function show() : void
      {
         Tweener.addTween(mcFooter,{
            "y":FOOTER_Y,
            "base":TWEEN_BASE
         });
         mcFooter.mouseChildren = true;
      }
      
      public function hide() : void
      {
         Tweener.addTween(mcFooter,{
            "y":FOOTER_Y_HIDDEN,
            "base":TWEEN_BASE
         });
         mcFooter.mouseChildren = false;
         hideSelector();
         hideBacker();
      }
      
      private function handleBattleButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:AbstractState = null;
         if(Managers.stateManager.state == StateType.COLLECTION.name)
         {
            _loc2_ = Managers.stateManager.getStateByName(Managers.stateManager.state);
            if(ICollectionState(_loc2_).pendingChanges)
            {
               CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_ALERT,"UNSAVED CHANGES","You have made changes to your Nanovor\'s stats.  If you go in to battle now, these changes will go unsaved.  Are you sure you want to go in to battle?",0,onConfirmExit);
               return;
            }
         }
         showBattleTypeSelection();
      }
      
      public function get isActive() : Boolean
      {
         return _selectorIsInView;
      }
      
      private function showBattleTypeSelection() : void
      {
         hide();
         showBacker();
         showSelector();
         _selectorIsInView = true;
      }
      
      private function onConfirmExit(param1:Object) : void
      {
         showBattleTypeSelection();
      }
      
      public function selectedSingleplayer() : void
      {
         Managers.stateManager.setState(StateType.SENSEI_SELECT);
         Managers.mdmManager.pushFakeBrowserState(MDMBrowserKey.HOME_NEWS,{"visible":false});
         hideBacker();
         hideSelector();
      }
      
      private function showBacker() : void
      {
         _autoBattleSelectorContainer.addChild(mcBacker);
         Managers.mdmManager.hideAllMdmBrowsers();
         mcBacker.mouseEnabled = true;
         Tweener.addTween(mcBacker,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
      
      override public function init(param1:Object = null) : void
      {
         _autoBattleSelectorContainer = param1.popupContainer as Sprite;
         _battleButton.addEventListener(MouseEvent.CLICK,handleBattleButtonClick);
      }
      
      private function hideBacker() : void
      {
         if(_selectorIsInView)
         {
            Managers.mdmManager.restoreLastMdmBrowsersStates();
         }
         mcBacker.mouseEnabled = false;
         Tweener.addTween(mcBacker,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         if(null != mcBacker.parent)
         {
            mcBacker.parent.removeChild(mcBacker);
         }
      }
      
      public function canceledSelection() : void
      {
         show();
         hideBacker();
         hideSelector();
      }
      
      public function selectedMultiplayer() : void
      {
         if(null != Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name))
         {
            IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).startAutoBattle();
         }
         Managers.mdmManager.pushFakeBrowserState(MDMBrowserKey.HOME_NEWS,{"visible":false});
         hideBacker();
         hideSelector();
      }
   }
}

