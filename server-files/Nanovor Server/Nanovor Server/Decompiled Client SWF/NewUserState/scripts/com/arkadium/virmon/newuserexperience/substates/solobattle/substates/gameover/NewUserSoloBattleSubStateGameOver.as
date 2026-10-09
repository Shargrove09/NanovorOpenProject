package com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover
{
   import com.arkadium.virmon.battle.substates.gameover.BattleSubStateGameOverData;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.INewUserSubStateSoloBattle;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.view.INewUserGameOver;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.view.INewUserGameOverViewConsumer;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.view.NewUserGameOverLoseView;
   import com.arkadium.virmon.newuserexperience.substates.solobattle.substates.gameover.view.NewUserGameOverWinView;
   import com.arkadium.virmon.shared.utils.substate.AbstractSubState;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.Sprite;
   
   public class NewUserSoloBattleSubStateGameOver extends AbstractSubState implements INewUserGameOverViewConsumer
   {
      
      private var _gameOverSubStateData:BattleSubStateGameOverData;
      
      private var _uiContainer:Sprite;
      
      private var _soloBattle:INewUserSubStateSoloBattle;
      
      private var _winLoseOverlay:INewUserGameOver;
      
      public function NewUserSoloBattleSubStateGameOver(param1:Sprite, param2:INewUserSubStateSoloBattle)
      {
         super();
         _uiContainer = param1;
         _soloBattle = param2;
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<NewUserSoloBattleSubStateGameOver>>\t" + param1);
      }
      
      public function setGameOverData(param1:BattleSubStateGameOverData) : void
      {
         log("setGameOverData()");
         _gameOverSubStateData = param1;
      }
      
      override public function setSubState() : void
      {
         log("setSubState()");
         var _loc1_:Boolean = _gameOverSubStateData.gameOverInfo.isWinner;
         _winLoseOverlay = _loc1_ ? new NewUserGameOverWinView(INewUserGameOverViewConsumer(this)) : new NewUserGameOverLoseView(INewUserGameOverViewConsumer(this));
         _winLoseOverlay.init();
         _uiContainer.addChild(_winLoseOverlay.sprite);
      }
      
      public function destroy() : void
      {
         if(null != _winLoseOverlay && null != _winLoseOverlay.sprite.parent)
         {
            _winLoseOverlay.sprite.parent.removeChild(_winLoseOverlay.sprite);
         }
      }
      
      public function handleGameOverComplete() : void
      {
         _soloBattle.handleSoloBattleComplete();
      }
   }
}

