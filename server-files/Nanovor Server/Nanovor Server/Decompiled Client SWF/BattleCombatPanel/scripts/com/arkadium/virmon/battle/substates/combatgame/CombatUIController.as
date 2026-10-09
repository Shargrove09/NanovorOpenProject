package com.arkadium.virmon.battle.substates.combatgame
{
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.virmon.battle.IBattleData;
   import com.arkadium.virmon.battle.IBattleHeaderController;
   import com.arkadium.virmon.battle.control.AttackStatement;
   import com.arkadium.virmon.battle.control.BattleCommunications;
   import com.arkadium.virmon.battle.control.BattleController;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.IRoundControllerNanovorChooser;
   import com.arkadium.virmon.framework.asset.retriever.IOverlayAssetRetriever;
   import com.arkadium.virmon.framework.asset.utils.ICharacterAssetTypeCache;
   import com.arkadium.virmon.shared.components.ISwarmometer;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import com.arkadium.virmon.shared.data.IPlayerFactory;
   import com.arkadium.virmon.shared.elements.icons.overrides.OverrideIcon;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class CombatUIController
   {
      
      private var _battleHeaderController:IBattleHeaderController;
      
      private var _ui:CombatGamePanel;
      
      private var _bAnimationPlaying:Boolean;
      
      private var _bOneRoundCompleted:Boolean;
      
      private var _control:BattleController;
      
      private var _comm:BattleCommunications;
      
      private var _bWatchAccepted:Boolean;
      
      public function CombatUIController(param1:IPlayerFactory, param2:CombatGamePanel, param3:IBattleGameService, param4:IBattleData, param5:IBattleHeaderController, param6:ICharacterAssetTypeCache, param7:IOverlayAssetRetriever)
      {
         super();
         _bWatchAccepted = false;
         _bAnimationPlaying = false;
         _bOneRoundCompleted = false;
         _ui = param2;
         _comm = new BattleCommunications(param2,this,param3);
         _control = new BattleController(param1,this,param3,param4,param6,param7);
         _battleHeaderController = param5;
      }
      
      public function destroy() : void
      {
         if(null != _control)
         {
            _control.destroy();
            _control = null;
         }
         if(null != _comm)
         {
            _comm.destroy();
            _comm = null;
         }
         _battleHeaderController = null;
      }
      
      public function readyForTurn() : void
      {
         var _loc1_:IPlayer = null;
         log("readyForTurn()");
         _control.readyForAttackSelection();
         if(myPlayer.isDead)
         {
            return;
         }
         _ui.readyForTurnSelection();
         for each(_loc1_ in players)
         {
            if(!_loc1_.isDead && Boolean(_loc1_.leftGame))
            {
               _loc1_.waiting = true;
            }
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CombatUIController: " + param1);
      }
      
      public function set oneRoundCompleted(param1:Boolean) : void
      {
         _bOneRoundCompleted = param1;
      }
      
      public function updatePlayerSwarmometer(param1:IPlayer) : void
      {
         var _loc3_:INanovor = null;
         if(null == param1.swarm || param1.swarm.length == 0)
         {
            return;
         }
         var _loc2_:ISwarmometer = _battleHeaderController.getSwarmometerById(param1.userRefId);
         for each(_loc3_ in param1.swarm)
         {
            _loc2_.setNanovorInfo(_loc3_.assetId,_loc3_.health,_loc3_.name,_loc3_.nickName,_loc3_.baseHealth);
         }
         _loc2_.sortMeters();
      }
      
      public function get battleGame() : CombatGamePanel
      {
         return _ui;
      }
      
      public function init(param1:int, param2:Array) : void
      {
         var _loc4_:INanovor = null;
         var _loc5_:IPlayer = null;
         var _loc6_:int = 0;
         var _loc7_:ISwarmometer = null;
         log("init() - myUserRefId: " + param1.toString());
         _comm.init(param1);
         _control.init(param1);
         log("init() - myPlayer.setSwarm(): " + param2.join(","));
         myPlayer.setSwarm(param2);
         var _loc3_:Array = new Array();
         for each(_loc4_ in myPlayer.swarm)
         {
            _loc3_.push({
               "id":_loc4_.assetId,
               "health":_loc4_.baseHealth,
               "mastername":_loc4_.name,
               "nickname":_loc4_.nickName
            });
         }
         for each(_loc5_ in players)
         {
            log("init() - Initializing " + _loc5_.username);
            _loc6_ = int(_battleHeaderController.getSwarmCountByUserRefId(_loc5_.userRefId));
            log("init() - Setting player: " + _loc5_.username + " swarmCount: " + _loc6_);
            _loc5_.swarmSize = _loc6_;
            _loc7_ = _battleHeaderController.getSwarmometerById(_loc5_.userRefId);
            if(null != _loc7_)
            {
               if(_loc5_.userRefId == param1)
               {
                  _loc7_.setMySwarmInfo(_loc3_);
               }
               _loc7_.show();
            }
         }
         _ui.initializeAttackChooser();
         _comm.sendSwarmToServer(param2);
      }
      
      public function get isAnimationPlaying() : Boolean
      {
         return _bAnimationPlaying;
      }
      
      public function onAcceptWatch(param1:Object = null) : void
      {
         _bWatchAccepted = true;
         _ui.onAcceptWatch();
      }
      
      private function hasOverrideChanges(param1:IPlayer) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:AttackStatement = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1.previousCurrentOverrideArray.length != param1.currentOverrideArray.length)
         {
            return true;
         }
         if(param1.currentOverrideArray.length > 0)
         {
            _loc2_ = [];
            for each(_loc3_ in param1.currentOverrideArray)
            {
               _loc2_.push(_loc3_.id);
            }
            _loc4_ = [];
            for each(_loc3_ in param1.previousCurrentOverrideArray)
            {
               _loc4_.push(_loc3_.id);
            }
            for each(_loc5_ in _loc2_)
            {
               if(_loc4_.indexOf(_loc5_) == -1)
               {
                  return true;
               }
            }
            for each(_loc5_ in _loc4_)
            {
               if(_loc2_.indexOf(_loc5_) == -1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function get roundControllerNanovorChooser() : IRoundControllerNanovorChooser
      {
         return _control.roundController;
      }
      
      public function get oneRoundCompleted() : Boolean
      {
         return _bOneRoundCompleted;
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CombatUIController: " + param1);
      }
      
      public function sendTurn(param1:CombatTurnData) : void
      {
         _comm.sendTurn(param1);
         _ui.hideAttackChooser();
      }
      
      public function set isAnimationPlaying(param1:Boolean) : void
      {
         _bAnimationPlaying = param1;
      }
      
      public function opponentLeaveGame(param1:int) : void
      {
         if(null == _control.players)
         {
            return;
         }
         var _loc2_:IPlayer = _control.getPlayerById(param1);
         if(null != _loc2_)
         {
            _loc2_.leftGame = true;
         }
      }
      
      public function get myPlayer() : IPlayer
      {
         return _control.myPlayer;
      }
      
      public function get players() : Array
      {
         return _control.players;
      }
      
      public function get battleController() : BattleController
      {
         return _control;
      }
      
      public function get WatchAccepted() : Boolean
      {
         return _bWatchAccepted;
      }
      
      public function onDeclineWatch(param1:Object = null) : void
      {
         var oParams:Object = param1;
         try
         {
            _ui.onDeclineWatch();
            _comm.sendPlayerDeclinedToWatch();
         }
         catch(err:Error)
         {
            logError("onDeclineWatch -- caught \"Error\": " + err.message);
         }
      }
      
      public function updateUIState(param1:Boolean = false) : void
      {
         var player:IPlayer = null;
         var avatar:IAvatar = null;
         var swarmometer:ISwarmometer = null;
         var overrideIcon:OverrideIcon = null;
         var bAfterOrBeforeAnimation:Boolean = param1;
         log("updateUIState() = bAfterOrBeforeAnimation: " + bAfterOrBeforeAnimation);
         for each(player in players)
         {
            log("updateUIState() - player " + player.username + " isDead? " + player.isDead + " bAfterOrBeforeAnimation: " + bAfterOrBeforeAnimation);
            avatar = _battleHeaderController.getAvatarByPlayerId(player.userRefId);
            if(bAfterOrBeforeAnimation)
            {
               if(player.leftGame)
               {
                  avatar.status = "LEFT BATTLE";
               }
               else if(player.isDead)
               {
                  avatar.status = "GAME OVER";
               }
               else
               {
                  updatePlayerSwarmometer(player);
               }
            }
            if(player != null && !player.leftGame)
            {
               try
               {
                  if(player.statIndexUsed)
                  {
                     continue;
                  }
               }
               catch(err:Error)
               {
                  logError("CAUGHT ERROR in updateUIState (player.statIndexUsed):\n\tplayer=" + player + "\n\t" + err.getStackTrace());
                  continue;
               }
               player.statIndexUsed = true;
               avatar.energy = player.energyLevel;
               swarmometer = avatar.swarmometer;
               if(!bAfterOrBeforeAnimation)
               {
                  if(player.selectedNanovor != null && player.selectedNanovor.health != player.selectedNanovor.previousHealth)
                  {
                     swarmometer.setNanovorInfo(player.selectedNanovor.assetId,player.selectedNanovor.health,player.selectedNanovor.name,player.selectedNanovor.nickName,player.selectedNanovor.baseHealth);
                     swarmometer.sortMeters();
                  }
               }
               log("... updateUIState: [" + player.username + "] currentOverrideArray.length=" + player.currentOverrideArray.length);
               log("... updateUIState: [" + player.username + "] previousCurrentOverrideArray.length=" + player.previousCurrentOverrideArray.length);
               if(hasOverrideChanges(player))
               {
                  log("     ... updateUIState: [" + player.username + "] detected override status change ... going to call avatar setOverride... (length=" + player.currentOverrideArray.length + ")");
                  overrideIcon = OverrideIcon.createFromAttackStatements(player.currentOverrideArray,player.currentOverrideDescription);
                  avatar.setOverride(overrideIcon);
               }
            }
         }
      }
      
      public function onCurtainClosed() : void
      {
         _comm.sendAnimationComplete();
      }
   }
}

