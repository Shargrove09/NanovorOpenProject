package com.smithandtinker.smartfox.enums
{
   public final class GameState
   {
      
      public static const REQUEST_CREATE_QUICK_BATTLE:String = "createQuickBattle";
      
      public static const REQUEST_CREATE_GAME:String = "createGame";
      
      public static const REQUEST_INVITE_USER:String = "inviteUser";
      
      public static const REQUEST_REPLY_INVITATION:String = "replyInvitation";
      
      public static const REQUEST_SET_GAME_SWARM_VALUE:String = "setGameSwarmValue";
      
      public static const REQUEST_START_GAME:String = "startGame";
      
      public static const REQUEST_SET_SWARM:String = "setSwarm";
      
      public static const REQUEST_SET_SELECTED_NANOVOR:String = "setSelectedNanovor";
      
      public static const REQUEST_SET_ATTACK:String = "setAttack";
      
      public static const REQUEST_SET_NEXT_SWAP:String = "setNextSwap";
      
      public static const REQUEST_SET_ENEMY:String = "setEnemy";
      
      public static const REQUEST_SET_ATTACK_INFO:String = "setAttackInfo";
      
      public static const REQUEST_END_ROUND:String = "endRound";
      
      public static const REQUEST_QUIT_GAME:String = "quitGame";
      
      public static const REQUEST_DECLINED_TO_WATCH:String = "declinedToWatch";
      
      public static const REQUEST_KICK_PLAYER_OUT:String = "kickPlayerOut";
      
      public static const REQUEST_CANCEL_QUICK_BATTLE:String = "cancelQuickBattle";
      
      public static const REQUEST_GET_BADGE_LIST:String = "getBadgeList";
      
      public static const RESPONSE_GAME_CREATED:String = "gameCreated";
      
      public static const RESPONSE_GAME_CREATION_ERROR:String = "gameCreationError";
      
      public static const RESPONSE_GAME_INVITATION_ERROR:String = "gameInvitationError";
      
      public static const RESPONSE_SYSTEM_ERROR:String = "systemError";
      
      public static const RESPONSE_GAME_ERROR:String = "gameError";
      
      public static const RESPONSE_GAME_ERROR_CAPITAL:String = "GameError";
      
      public static const RESPONSE_JOIN_GAME_ERROR:String = "joinGameError";
      
      public static const RESPONSE_SELECTED_NANOVOR_ERROR:String = "selectedNanovorError";
      
      public static const RESPONSE_BADGE_LIST:String = "badgeList";
      
      public static const SERVER_ALL_PLAYERS_READY:String = "allPlayersReady";
      
      public static const SERVER_WAITING_FOR_PLAYERS:String = "waitingForPlayers";
      
      public static const SERVER_SET_GAME_SWARM_VALUE:String = "setGameSwarmValue";
      
      public static const SERVER_INVITATION_REQUEST:String = "invitationRequest";
      
      public static const SERVER_INVITATION_RESPONSE:String = "invitationResponse";
      
      public static const SERVER_PLAYER_JOIN_GAME:String = "playerJoinGame";
      
      public static const SERVER_PLAYER_JOIN_AUTO_BATTLE:String = "playerJoinAutoBattle";
      
      public static const SERVER_GAME_STARTED:String = "gameStarted";
      
      public static const SERVER_GAME_SWARM_VALUE_SET:String = "gameSwarmValueSet";
      
      public static const SERVER_SWARM_SELECTED:String = "swarmSelected";
      
      public static const SERVER_TARGET_SELECTED:String = "targetSelected";
      
      public static const SERVER_READY_FOR_TURN:String = "readyForTurn";
      
      public static const SERVER_KILL_NANOVOR:String = "killNanovor";
      
      public static const SERVER_SWAP_NANOVOR:String = "swapNanovor";
      
      public static const SERVER_BLOCK_SWAP:String = "blockSwap";
      
      public static const SERVER_SELECT_NANOVOR:String = "selectNanovor";
      
      public static const SERVER_SET_ROUND_INFO:String = "setRoundInfo";
      
      public static const SERVER_PERFORM_ATTACK:String = "performAttack";
      
      public static const SERVER_ROUND_COMPLETED:String = "roundCompleted";
      
      public static const SERVER_SHOW_GAME_RESULTS:String = "showGameResults";
      
      public static const SERVER_PLAYER_QUIT_GAME:String = "playerQuitGame";
      
      public static const SERVER_GAME_QUIT:String = "gameQuit";
      
      public static const SERVER_GAME_OVER:String = "gameOver";
      
      public static const SERVER_PLAYER_KICKED_OUT:String = "playerKickedOut";
      
      public static const SERVER_ROOM_DESTROYED:String = "roomDestroyed";
      
      public function GameState()
      {
         super();
      }
   }
}

