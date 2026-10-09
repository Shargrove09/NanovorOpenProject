package com.arkadium.virmon.shared.widgets.autobattle.autobattleselector
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol31")]
   public class AutoBattleSelector extends Sprite implements IAutoBattleSelector
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeNone
      };
      
      private var _closeButton:SpinningButtonComponent;
      
      public var mcTrainingArea:Sprite;
      
      public var mcTraining:MovieClip;
      
      public var mcMultiplayerArea:Sprite;
      
      private var _consumer:IAutoBattleSelectorConsumer;
      
      public var mcMultiplayer:MovieClip;
      
      private var _currentSelection:Sprite;
      
      public var mcButtonsContainer:Sprite;
      
      public function AutoBattleSelector()
      {
         super();
         initUI();
         createButtons();
         _currentSelection = mcMultiplayer;
         mcMultiplayerArea.addEventListener(MouseEvent.CLICK,onMultiplayerButtonClick);
         mcTrainingArea.addEventListener(MouseEvent.CLICK,onTrainingButtonClick);
         mcMultiplayerArea.addEventListener(MouseEvent.ROLL_OVER,onGameRollOver);
         mcTrainingArea.addEventListener(MouseEvent.ROLL_OVER,onGameRollOver);
      }
      
      private function onGameRollOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.target === mcMultiplayerArea ? mcMultiplayer : mcTraining;
         switch(_loc2_)
         {
            case _currentSelection:
               return;
            case mcMultiplayerArea:
               §§push(mcTrainingArea);
               break;
            default:
               §§push(mcMultiplayerArea);
         }
         var _loc3_:Sprite = §§pop();
         Tweener.addTween(_currentSelection,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _currentSelection = _loc2_;
         Tweener.addTween(_currentSelection,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
      
      public function hide() : void
      {
         this.mouseChildren = false;
         if(null != _closeButton.parent)
         {
            _closeButton.parent.removeChild(_closeButton);
         }
         Tweener.addTween(this,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
      }
      
      public function init(param1:IAutoBattleSelectorConsumer) : void
      {
         _consumer = param1;
      }
      
      private function onCloseButtonClick(param1:MouseEvent) : void
      {
         _consumer.canceledSelection();
      }
      
      private function createButtons() : void
      {
         _closeButton = new SpinningButtonComponent(new SpinnerIconX());
         _closeButton.color = SpinningButtonComponent.COLOR_RED;
         _closeButton.x = 566;
         _closeButton.y = 354;
         _closeButton.open();
         _closeButton.addEventListener(MouseEvent.CLICK,onCloseButtonClick);
      }
      
      private function onTrainingButtonClick(param1:MouseEvent) : void
      {
         _consumer.selectedSingleplayer();
      }
      
      private function onMultiplayerButtonClick(param1:MouseEvent) : void
      {
         _consumer.selectedMultiplayer();
      }
      
      private function initUI() : void
      {
         this.alpha = 0;
         this.mouseEnabled = false;
         mcMultiplayerArea.mouseChildren = false;
         mcTrainingArea.mouseChildren = false;
         mcTrainingArea.buttonMode = true;
         mcMultiplayerArea.alpha = 0;
         mcMultiplayerArea.buttonMode = true;
         mcTrainingArea.alpha = 0;
         mcTraining.alpha = 0;
         mcTraining.mouseChildren = false;
         mcMultiplayer.mouseEnabled = false;
         mcMultiplayer.mouseChildren = false;
         mcTraining.mouseEnabled = false;
         mcButtonsContainer.mouseEnabled = false;
      }
      
      public function show() : void
      {
         this.mouseChildren = true;
         mcButtonsContainer.addChild(_closeButton);
         Tweener.addTween(this,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
   }
}

