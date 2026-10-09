package com.arkadium.virmon.battle.substates.gameover
{
   import com.arkadium.virmon.battle.IBattleExiter;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.soundmanager.ISoundManager;
   
   public interface IGameOver
   {
      
      function init(param1:INanovorFactory, param2:ISoundManager, param3:IRoundControllerNanovorChooser, param4:IBattleExiter, param5:Array, param6:GameOverInfo, param7:IPlayer, param8:int = 0, param9:Boolean = true, param10:Boolean = true) : void;
      
      function destroy() : void;
   }
}

