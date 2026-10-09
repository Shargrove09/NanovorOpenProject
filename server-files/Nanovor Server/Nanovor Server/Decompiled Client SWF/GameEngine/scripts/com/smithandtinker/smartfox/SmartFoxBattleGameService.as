package com.smithandtinker.smartfox
{
   import com.arkadium.communications.GameServiceProvider;
   import com.arkadium.communications.IBattleGameService;
   import com.arkadium.communications.IGameServiceInvitationManager;
   import com.arkadium.communications.IGameServiceInvitationManagerConsumer;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.communications.handlers.battle.*;
   import com.arkadium.virmon.battle.control.round.roundinfo.RoundInfo;
   import com.arkadium.virmon.battle.substates.combatgame.ICombatTurnData;
   import com.arkadium.virmon.collection.ICollectionState;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.megawidget.IMegaWidget;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import com.smithandtinker.smartfox.enums.GameState;
   import flash.events.*;
   import flash.utils.Dictionary;
   import it.gotoandplay.smartfoxserver.*;
   import it.gotoandplay.smartfoxserver.data.*;
   
   public class SmartFoxBattleGameService extends AbstractSmartFoxGameService implements IBattleGameService, IGameServiceInvitationManagerConsumer
   {
      
      private static const EXTENSION_NAME:String = "gameXt";
      
      private var _gameCreator:String;
      
      private var _players:Array;
      
      private var _gameCreatorId:String;
      
      private var _battleName:String = "";
      
      private var _pendingInvites:Array = new Array();
      
      private var _autoCreate:String;
      
      private var _invitationManager:IGameServiceInvitationManager;
      
      private var _createdBattle:Boolean = false;
      
      public function SmartFoxBattleGameService(param1:IUserProfile, param2:SmartFoxConnection)
      {
         super(param1,param2,EXTENSION_NAME);
         _players = new Array();
         registerGameEventHandlers();
         resetGame();
      }
      
      private function onEvent(param1:SFSEvent) : void
      {
         trace("Event: " + param1.type);
      }
      
      public function removeBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void
      {
         removeHandler(IBattleInvitationResponseHandler,param1);
      }
      
      public function removeGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void
      {
         removeHandler(IGameSwarmValueSetHandler,param1);
      }
      
      public function removeRoundCompletedHandler(param1:IRoundCompletedHandler) : void
      {
         removeHandler(IRoundCompletedHandler,param1);
      }
      
      public function addRoundCompletedHandler(param1:IRoundCompletedHandler) : void
      {
         addHandler(IRoundCompletedHandler,param1);
      }
      
      public function removeBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void
      {
         removeHandler(IBattleInvitationAcceptHandler,param1);
      }
      
      private function battleInvitationError(param1:String = "") : void
      {
         var _loc2_:String = "Error sending battle invitation\nPlease try again";
         if(param1 == "Player Offline")
         {
            _loc2_ = "This User is no longer online. Please choose a different User.";
         }
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Battle Invitation Error",_loc2_,0,handleBattleInvitationErrorDialogClose,handleBattleInvitationErrorDialogClose);
      }
      
      public function removeEnemySelectedHandler(param1:IEnemySelectedHandler) : void
      {
         removeHandler(IEnemySelectedHandler,param1);
      }
      
      public function addRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void
      {
         addHandler(IRoomDestroyedHandler,param1);
      }
      
      public function removeBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void
      {
         removeHandler(IBattleInvitationRequestHandler,param1);
      }
      
      public function addBattleInvitationResponseHandler(param1:IBattleInvitationResponseHandler) : void
      {
         addHandler(IBattleInvitationResponseHandler,param1);
      }
      
      public function getBadgeList(param1:String, param2:String) : void
      {
         sendRequestToServer(GameState.REQUEST_GET_BADGE_LIST,{
            "ownerId":param1,
            "nanovorId":param2
         });
      }
      
      public function isGame() : Boolean
      {
         return SmartFoxConnection(_gameServiceConnection).getActiveRoom().isGame();
      }
      
      public function setSwarm(param1:Array) : void
      {
         var _loc2_:String = param1.toString();
         sendRequestToServer(GameState.REQUEST_SET_SWARM,{"nanovorIds":_loc2_});
      }
      
      public function handleInvitationTimeout(param1:Object) : void
      {
         replyGameInvitation(param1.battleName,false,Const.REPLY_CODE_TIMEOUT);
      }
      
      public function addPerformAttackHandler(param1:IPerformAttackHandler) : void
      {
         addHandler(IPerformAttackHandler,param1);
      }
      
      private function playerJoinGame(param1:Object) : void
      {
         var _loc3_:IOtherPlayerJoinBattleHandler = null;
         var _loc4_:Object = null;
         _battleName = param1.battleName;
         if(param1.username != _gameCreator)
         {
            _loc4_ = {
               "username":param1.username,
               "userRefId":param1.userRefId
            };
            _players.push(_loc4_);
         }
         var _loc2_:Boolean = Boolean(IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).isAutoBattle());
         log("Total Players: " + _players.length + " : " + _loc2_);
         for each(_loc3_ in _handlers[IOtherPlayerJoinBattleHandler])
         {
            _loc3_.handleOtherPlayerJoinBattle({
               "battleName":param1.battleName,
               "userRefId":param1.userRefId,
               "username":param1.username,
               "avatarId":param1.avatarId,
               "nmp":param1.nmp,
               "creator":param1.username == _gameCreator && !_loc2_
            });
         }
      }
      
      public function setEnemy(param1:String) : void
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < _players.length)
         {
            if(_players[_loc3_].userRefId == param1)
            {
               _loc2_ = _players[_loc3_].username;
               break;
            }
            _loc3_++;
         }
         sendRequestToServer(GameState.REQUEST_SET_ENEMY,{"enemyUsername":_loc2_});
      }
      
      private function enemySelected(param1:Object) : void
      {
         var _loc2_:IEnemySelectedHandler = null;
         for each(_loc2_ in _handlers[IEnemySelectedHandler])
         {
            _loc2_.handleEnemySelected(_battleName,param1.userRefId,param1.targetUserRefId,param1.attackId);
         }
      }
      
      private function swarmSelected(param1:Object) : void
      {
         var _loc2_:IGameSwarmSelectedHandler = null;
         log("swarmSelected()");
         for each(_loc2_ in _handlers[IGameSwarmSelectedHandler])
         {
            _loc2_.handleGameSwarmSelected(_battleName,param1.swarmCount,param1.username,param1.userRefId);
         }
      }
      
      public function handleInvitationAccept(param1:Object) : void
      {
         var _loc2_:IBattleInvitationAcceptHandler = null;
         GameServiceProvider.getInstance().chatGameService.exitChatRoom();
         GameServiceProvider.getInstance().tradeGameService.quitTrade();
         _battleName = param1.battleName;
         _gameCreator = param1.inviter.username;
         _gameCreatorId = param1.inviter.userRefId;
         replyGameInvitation(param1.battleName,true,Const.REPLY_CODE_ACCEPT);
         for each(_loc2_ in _handlers[IBattleInvitationAcceptHandler])
         {
            _loc2_.handleBattleInvitationAccept(param1.battleName,param1.inviter.username,param1.gameSwarmValue,param1.convertedChatRoom);
         }
      }
      
      private function handleExtensionResponse(param1:SFSEvent) : void
      {
         var _loc2_:String = param1.params.type;
         var _loc3_:Object = param1.params.dataObj;
         var _loc4_:String = _loc3_._cmd;
         log("handling response: command: " + _loc4_);
         var _loc5_:Boolean = true;
         switch(_loc4_)
         {
            case GameState.RESPONSE_GAME_ERROR:
            case GameState.RESPONSE_GAME_ERROR_CAPITAL:
               gameError();
               break;
            case GameState.RESPONSE_GAME_CREATED:
               gameCreated(_loc3_);
               break;
            case GameState.RESPONSE_GAME_CREATION_ERROR:
               gameCreationError();
               break;
            case GameState.SERVER_INVITATION_REQUEST:
               invitationRequest(_loc3_);
               break;
            case GameState.SERVER_INVITATION_RESPONSE:
               invitationResponse(_loc3_);
               break;
            case GameState.RESPONSE_GAME_INVITATION_ERROR:
               trace("invitation error: " + _loc3_.errorMessage);
               battleInvitationError(_loc3_.errorMessage);
               break;
            case GameState.SERVER_PLAYER_JOIN_GAME:
               playerJoinGame(_loc3_);
               break;
            case GameState.SERVER_PLAYER_JOIN_AUTO_BATTLE:
               playerJoinAutoBattle(_loc3_);
               break;
            case GameState.RESPONSE_JOIN_GAME_ERROR:
               joinBattleError();
               break;
            case GameState.SERVER_WAITING_FOR_PLAYERS:
               trace("Waiting for Players...");
               break;
            case GameState.SERVER_GAME_SWARM_VALUE_SET:
               gameSwarmValueSet(_loc3_);
               break;
            case GameState.RESPONSE_SELECTED_NANOVOR_ERROR:
               selectedNanovorError();
               break;
            case GameState.SERVER_GAME_STARTED:
               battleStarted(_loc3_);
               break;
            case GameState.SERVER_SWARM_SELECTED:
               swarmSelected(_loc3_);
               break;
            case GameState.SERVER_TARGET_SELECTED:
               enemySelected(_loc3_);
               break;
            case GameState.SERVER_READY_FOR_TURN:
               readyForTurn(_loc3_);
               break;
            case GameState.SERVER_SET_ROUND_INFO:
               setRoundInfo(_loc3_);
               break;
            case GameState.SERVER_PERFORM_ATTACK:
               performAttack(_loc3_);
               break;
            case GameState.SERVER_ROUND_COMPLETED:
               roundCompleted(_loc3_);
               break;
            case GameState.SERVER_PLAYER_KICKED_OUT:
               trace("Player kicked out from battle");
               playerKickedOut(_loc3_);
               break;
            case GameState.SERVER_PLAYER_QUIT_GAME:
               playerQuitGame(_loc3_);
               break;
            case GameState.SERVER_GAME_OVER:
               trace("Battle over");
               gameOver(_loc3_);
               break;
            case GameState.RESPONSE_BADGE_LIST:
               trace("Badge list received");
               badgeList(_loc3_);
               break;
            case GameState.SERVER_ROOM_DESTROYED:
               roomDestroyed(_loc3_);
               break;
            default:
               _loc5_ = false;
         }
         if(_loc5_)
         {
            log(">>SMF>><< handleExtensionResponse [" + EXTENSION_NAME + "]: found case for: " + _loc4_);
         }
      }
      
      public function addBattleCreatedHandler(param1:IBattleCreatedHandler) : void
      {
         addHandler(IBattleCreatedHandler,param1);
      }
      
      private function roundCompleted(param1:Object) : void
      {
         var _loc2_:IRoundCompletedHandler = null;
         for each(_loc2_ in _handlers[IRoundCompletedHandler])
         {
            _loc2_.handleRoundCompleted(param1);
         }
      }
      
      private function debugDataObject(param1:Object) : void
      {
         var _loc2_:String = null;
         log("---------------------------------------------------------------------------------------------------");
         for(_loc2_ in param1)
         {
            log("key: " + _loc2_ + " data[key]: " + param1[_loc2_]);
         }
         log("---------------------------------------------------------------------------------------------------");
      }
      
      public function removePlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void
      {
         removeHandler(IPlayerJoinBattleHandler,param1);
      }
      
      public function createQuickBattle(param1:int = 1000, param2:int = 2) : void
      {
         log("SmartFoxBattleGameService.createQuickBattle()");
         sendRequestToServer(GameState.REQUEST_CREATE_QUICK_BATTLE,{
            "gameSwarmValue":param1,
            "totalPlayers":param2
         });
      }
      
      public function addSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void
      {
         addHandler(ISelectedNanovorErrorHandler,param1);
      }
      
      public function addSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void
      {
         addHandler(ISetRoundInfoHandler,param1);
      }
      
      public function addGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void
      {
         addHandler(IGameSwarmSelectedHandler,param1);
      }
      
      public function addBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void
      {
         addHandler(IBattleInvitationErrorHandler,param1);
      }
      
      public function cancelMatchMaking() : void
      {
         resetGame();
         sendRequestToServer(GameState.REQUEST_CANCEL_QUICK_BATTLE,{"userRefId":_userProfile.id});
      }
      
      public function addBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void
      {
         addHandler(IBattlePlayerKickedOutHandler,param1);
      }
      
      public function inviteUser(param1:String, param2:Boolean = false) : void
      {
         if(!_createdBattle)
         {
            createGame(1000,param2);
            _autoCreate = param1;
            _pendingInvites.push(param1);
         }
         else
         {
            sendRequestToServer(GameState.REQUEST_INVITE_USER,{
               "buddy":param1,
               "battleName":_battleName
            });
         }
      }
      
      private function handleBattleCreationErrorDialogClose(param1:Object) : void
      {
         var _loc2_:IBattleCreationErrorHandler = null;
         for each(_loc2_ in _handlers[IBattleCreationErrorHandler])
         {
            _loc2_.handleBattleCreationError();
         }
      }
      
      public function getDialogText(param1:Object) : String
      {
         var _loc2_:String = "User " + String(param1.inviter.username).toUpperCase() + " has invited you to battle. Swarm size is " + param1.gameSwarmValue + " points.";
         if(Managers.stateManager.getStateByName(StateType.COLLECTION.name) != null && Boolean(ICollectionState(Managers.stateManager.getStateByName(StateType.COLLECTION.name)).pendingChanges))
         {
            _loc2_ += "\nWarning! You have made changes to your Nanovor\'s stats.  If you go in to battle now, these changes will go unsaved.  ";
         }
         return _loc2_ + "Do you accept?";
      }
      
      public function removeRoomDestroyedHandler(param1:IRoomDestroyedHandler) : void
      {
         removeHandler(IRoomDestroyedHandler,param1);
      }
      
      public function addQuittingGameHandler(param1:IQuittingGameHandler) : void
      {
         addHandler(IQuittingGameHandler,param1);
      }
      
      private function gameCreated(param1:Object) : void
      {
         var _loc3_:IBattleCreatedHandler = null;
         var _loc4_:String = null;
         _createdBattle = true;
         _battleName = param1.battleName;
         _gameCreator = _userProfile.screenname;
         _gameCreatorId = String(_userProfile.id);
         var _loc2_:Object = {
            "username":_gameCreator,
            "userRefId":_userProfile.id
         };
         _players.push(_loc2_);
         log("gameCreated() -- battleName: " + _battleName + ", gameCreator: " + _gameCreator);
         for each(_loc3_ in _handlers[IBattleCreatedHandler])
         {
            _loc3_.handleBattleCreated({"battleName":_battleName});
         }
         while(_pendingInvites.length > 0)
         {
            _loc4_ = _pendingInvites.pop();
            sendRequestToServer(GameState.REQUEST_INVITE_USER,{
               "buddy":_loc4_,
               "battleName":_battleName,
               "convertedChatRoom":param1.convertedChatRoom
            });
         }
      }
      
      public function removeBattleErrorHandler(param1:IBattleErrorHandler) : void
      {
         removeHandler(IBattleErrorHandler,param1);
      }
      
      public function addBattleStartedHandler(param1:IBattleStartedHandler) : void
      {
         addHandler(IBattleStartedHandler,param1);
      }
      
      private function joinBattleError() : void
      {
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Join Battle Error","Error joining battle",0,handleJoinBattleErrorDialogClose,handleJoinBattleErrorDialogClose);
      }
      
      public function removePerformAttackHandler(param1:IPerformAttackHandler) : void
      {
         removeHandler(IPerformAttackHandler,param1);
      }
      
      public function removeSelectedNanovorErrorHandler(param1:ISelectedNanovorErrorHandler) : void
      {
         removeHandler(ISelectedNanovorErrorHandler,param1);
      }
      
      private function battleStarted(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:IBattleStartedHandler = null;
         for each(_loc2_ in players)
         {
            debugDataObject(_loc2_);
         }
         _invitationManager.declineAllInvitations(true);
         for each(_loc3_ in _handlers[IBattleStartedHandler])
         {
            _loc3_.handleBattleStarted({
               "battleName":_battleName,
               "players":param1.players,
               "gameCreator":_gameCreator
            });
         }
         Managers.serviceRequestBrokerManager.stopTokenRefresh();
      }
      
      private function debugTrace(param1:String) : void
      {
         trace("[ LOG ] " + param1);
      }
      
      public function replyGameInvitation(param1:String, param2:Boolean, param3:String) : void
      {
         var _loc4_:Object = null;
         log("replyGameInvitation() : battleName=" + _battleName + ". accepted=" + (param2 ? "accepted" : "declined") + " Creator=" + _gameCreator);
         sendRequestToServer(GameState.REQUEST_REPLY_INVITATION,{
            "accept":param2,
            "battleName":param1,
            "gameCreator":_gameCreator,
            "replyReason":param3
         });
         if(!param2)
         {
            resetGame();
         }
         else
         {
            _battleName = param1;
            _loc4_ = {
               "username":_gameCreator,
               "userRefId":_gameCreatorId
            };
            _players.push(_loc4_);
         }
      }
      
      private function invitationRequest(param1:Object) : void
      {
         if("" != _battleName)
         {
            replyGameInvitation(param1.battleName,false,Const.REPLY_CODE_BUSY);
            return;
         }
         if(!_invitationManager.checkCanAcceptInvitations())
         {
            replyGameInvitation(param1.battleName,false,Const.REPLY_CODE_BUSY);
            return;
         }
         _invitationManager.handleInvitation(param1,IGameServiceInvitationManagerConsumer(this),param1.battleName,30,true);
      }
      
      public function getDialogTitle() : String
      {
         return "Invite To Battle";
      }
      
      public function removeBattleCreatedHandler(param1:IBattleCreatedHandler) : void
      {
         removeHandler(IBattleCreatedHandler,param1);
      }
      
      private function badgeList(param1:Object) : void
      {
      }
      
      private function playerQuitGame(param1:Object) : void
      {
         var _loc3_:IPlayerQuitGameHandler = null;
         var _loc2_:int = 0;
         while(_loc2_ < _players.length)
         {
            if(_players[_loc2_].userRefId == param1.userRefId)
            {
               _players.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         debugDataObject(param1);
         log("playerQuitGame - Players in game: " + _players.length);
         for each(_loc3_ in _handlers[IPlayerQuitGameHandler])
         {
            _loc3_.handlePlayerQuitGame(param1.userRefId,param1.username);
         }
      }
      
      public function removeReadyForTurnHandler(param1:IReadyForTurnHandler) : void
      {
         removeHandler(IReadyForTurnHandler,param1);
      }
      
      public function quitGame() : void
      {
         var _loc1_:IQuittingGameHandler = null;
         resetGame();
         sendRequestToServer(GameState.REQUEST_QUIT_GAME,{"userRefId":_userProfile.id});
         for each(_loc1_ in _handlers[IQuittingGameHandler])
         {
            _loc1_.handleQuittingGame();
         }
         Managers.serviceRequestBrokerManager.startTokenRefresh();
      }
      
      public function addBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void
      {
         addHandler(IBattleCreationErrorHandler,param1);
      }
      
      public function removeOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void
      {
         removeHandler(IOtherPlayerJoinBattleHandler,param1);
      }
      
      private function invitationResponse(param1:Object) : void
      {
         var _loc2_:IPlayerJoinBattleHandler = null;
         var _loc3_:int = 0;
         var _loc4_:IBattleInvitationResponseHandler = null;
         if(_gameCreator == _userProfile.screenname)
         {
            for each(_loc4_ in _handlers[IBattleInvitationResponseHandler])
            {
               _loc4_.handleBattleInvitationResponse({
                  "battleName":param1.battleName,
                  "player":param1.player,
                  "inviterName":param1.inviterName,
                  "inviterId":param1.inviterId
               });
            }
            return;
         }
         for each(_loc2_ in _handlers[IPlayerJoinBattleHandler])
         {
            _loc2_.handlePlayerJoinBattle(param1);
         }
         _loc3_ = 0;
         while(_loc3_ < param1.otherPlayers.length)
         {
            param1.otherPlayers[_loc3_].battleName = param1.battleName;
            playerJoinGame(param1.otherPlayers[_loc3_]);
            _loc3_++;
         }
      }
      
      public function removeBattleStartedHandler(param1:IBattleStartedHandler) : void
      {
         removeHandler(IBattleStartedHandler,param1);
      }
      
      public function kickPlayerOut(param1:String) : void
      {
         log("kickPlayerOut: kicking " + param1);
         sendRequestToServer(GameState.REQUEST_KICK_PLAYER_OUT,{
            "username":param1,
            "userRefId":""
         });
      }
      
      private function performAttack(param1:Object) : void
      {
         var _loc2_:IPerformAttackHandler = null;
         for each(_loc2_ in _handlers[IPerformAttackHandler])
         {
            _loc2_.handlePerformAttack(param1.attackResults);
         }
      }
      
      public function createGame(param1:int = 1000, param2:Boolean = false) : void
      {
         var inValue:int = param1;
         var convertedChatRoom:Boolean = param2;
         log("SmartFoxBattleGameService.createGame()");
         try
         {
            sendRequestToServer(GameState.REQUEST_CREATE_GAME,{
               "gameSwarmValue":inValue,
               "convertedChatRoom":convertedChatRoom
            });
         }
         catch(e:Error)
         {
            logError("SmartFoxBattleGameService.createGame(): error: " + e.getStackTrace());
         }
      }
      
      public function addBattleInvitationAcceptHandler(param1:IBattleInvitationAcceptHandler) : void
      {
         addHandler(IBattleInvitationAcceptHandler,param1);
      }
      
      public function addGameSwarmValueSetHandler(param1:IGameSwarmValueSetHandler) : void
      {
         addHandler(IGameSwarmValueSetHandler,param1);
      }
      
      public function setAttackInfo(param1:ICombatTurnData) : void
      {
         sendRequestToServer(GameState.REQUEST_SET_ATTACK_INFO,{
            "enemyUsername":param1.TargetedPlayerName,
            "nanovorId":param1.MyActiveNanovorId,
            "attackId":param1.AttackId,
            "swapNanovorId":param1.MyNextNanovorId
         });
      }
      
      private function setRoundInfo(param1:Object) : void
      {
         var _loc3_:ISetRoundInfoHandler = null;
         var _loc2_:RoundInfo = new RoundInfo(param1);
         for each(_loc3_ in _handlers[ISetRoundInfoHandler])
         {
            _loc3_.handleSetRoundInfo(_loc2_);
         }
      }
      
      public function removeBattleCreationErrorHandler(param1:IBattleCreationErrorHandler) : void
      {
         removeHandler(IBattleCreationErrorHandler,param1);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         debugTrace("Security error: " + param1.text);
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("[SmartFoxBattleGameService]          " + param1,_userProfile.screenname);
      }
      
      private function gameError() : void
      {
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Battle Error","Error during battle\nClick OK to quit battle",0,handleBattleErrorDialogClose,handleBattleErrorDialogClose);
      }
      
      private function handleBattleInvitationErrorDialogClose(param1:Object) : void
      {
         var _loc2_:IBattleInvitationErrorHandler = null;
         for each(_loc2_ in _handlers[IBattleInvitationErrorHandler])
         {
            _loc2_.handleBattleInvitationError();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("[SmartFoxBattleGameService]          " + param1,_userProfile.screenname);
      }
      
      public function setAttack(param1:int) : void
      {
         sendRequestToServer(GameState.REQUEST_SET_ATTACK,{"attackId":param1});
      }
      
      public function get numPlayers() : int
      {
         return _players.length;
      }
      
      private function playerJoinAutoBattle(param1:Object) : void
      {
         _battleName = param1.battleName;
         _gameCreator = param1.gameCreator;
         _gameCreatorId = param1.gameCreatorId;
         var _loc2_:Object = {
            "username":_gameCreator,
            "userRefId":_gameCreatorId
         };
         _players.push(_loc2_);
         var _loc3_:Object = {
            "username":param1.username,
            "userRefId":param1.userRefId
         };
         _players.push(_loc3_);
      }
      
      public function removeGameSwarmSelectedHandler(param1:IGameSwarmSelectedHandler) : void
      {
         removeHandler(IGameSwarmSelectedHandler,param1);
      }
      
      private function handleJoinBattleErrorDialogClose(param1:Object) : void
      {
         var _loc2_:IJoinBattleErrorHandler = null;
         for each(_loc2_ in _handlers[IJoinBattleErrorHandler])
         {
            _loc2_.handleJoinBattleError();
         }
      }
      
      public function removeGameOverHandler(param1:IGameOverHandler) : void
      {
         removeHandler(IGameOverHandler,param1);
      }
      
      public function get battleName() : String
      {
         return _battleName;
      }
      
      public function removeJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void
      {
         removeHandler(IJoinBattleErrorHandler,param1);
      }
      
      public function setGameSwarmValue(param1:int = 1000) : void
      {
         sendRequestToServer(GameState.REQUEST_SET_GAME_SWARM_VALUE,{"gameSwarmValue":param1});
      }
      
      public function endRound() : void
      {
         sendRequestToServer(GameState.REQUEST_END_ROUND,{});
      }
      
      private function unregisterGameEventHandlers() : void
      {
         _gameServiceConnection.removeEventListener(SFSEvent.onExtensionResponse,handleExtensionResponse);
         _gameServiceConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         _gameServiceConnection.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
      }
      
      public function addBattleErrorHandler(param1:IBattleErrorHandler) : void
      {
         addHandler(IBattleErrorHandler,param1);
      }
      
      private function roomDestroyed(param1:Object) : void
      {
         var _loc2_:IRoomDestroyedHandler = null;
         for each(_loc2_ in _handlers[IRoomDestroyedHandler])
         {
            _loc2_.handleRoomDestroyed();
         }
      }
      
      public function handleInvitationBusy(param1:Object) : void
      {
         replyGameInvitation(param1.battleName,false,Const.REPLY_CODE_BUSY);
      }
      
      public function startGame() : void
      {
         sendRequestToServer(GameState.REQUEST_START_GAME,{"battleName":_battleName});
      }
      
      private function handleBattleErrorDialogClose(param1:Object) : void
      {
         var _loc2_:IBattleErrorHandler = null;
         for each(_loc2_ in _handlers[IBattleErrorHandler])
         {
            _loc2_.handleBattleError();
         }
      }
      
      public function addBattleInvitationRequestHandler(param1:IBattleInvitationRequestHandler) : void
      {
         addHandler(IBattleInvitationRequestHandler,param1);
      }
      
      private function gameCreationError() : void
      {
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Battle Creation Error","Error creating battle\nPlease try again",0,handleBattleCreationErrorDialogClose,handleBattleCreationErrorDialogClose);
      }
      
      public function addOtherPlayerJoinBattleHandler(param1:IOtherPlayerJoinBattleHandler) : void
      {
         addHandler(IOtherPlayerJoinBattleHandler,param1);
      }
      
      private function selectedNanovorError() : void
      {
         CommonDialogBox.MakeAndForce(CommonDialogBox.TYPE_INFO,"Battle Error","Error during battle\nClick OK to quit battle",0,handleSelectedNanovorErrorDialogClose,handleSelectedNanovorErrorDialogClose);
      }
      
      public function getCreatorName() : String
      {
         return _gameCreator;
      }
      
      public function get isCreator() : Boolean
      {
         return _gameCreator.toLowerCase() == _userProfile.screenname.toLowerCase();
      }
      
      public function addGameOverHandler(param1:IGameOverHandler) : void
      {
         addHandler(IGameOverHandler,param1);
      }
      
      public function addPlayerJoinBattleHandler(param1:IPlayerJoinBattleHandler) : void
      {
         addHandler(IPlayerJoinBattleHandler,param1);
      }
      
      public function setNextSwap(param1:int) : void
      {
         sendRequestToServer(GameState.REQUEST_SET_NEXT_SWAP,{"nanovorId":param1});
      }
      
      public function removeSetRoundInfoHandler(param1:ISetRoundInfoHandler) : void
      {
         removeHandler(ISetRoundInfoHandler,param1);
      }
      
      public function addReadyForTurnHandler(param1:IReadyForTurnHandler) : void
      {
         addHandler(IReadyForTurnHandler,param1);
      }
      
      public function setGameServiceInivitationManager(param1:IGameServiceInvitationManager) : void
      {
         _invitationManager = param1;
      }
      
      public function getCreatorId() : String
      {
         return _gameCreatorId;
      }
      
      public function get players() : Array
      {
         return _players;
      }
      
      private function readyForTurn(param1:Object) : void
      {
         var _loc2_:IReadyForTurnHandler = null;
         log("SmartFoxBattleGameService::readyForTurn");
         for each(_loc2_ in _handlers[IReadyForTurnHandler])
         {
            log("I have a handler!!  " + _loc2_);
            _loc2_.handleReadyForTurn(_battleName,param1.nanovorId,param1.isDead);
         }
      }
      
      public function addJoinBattleErrorHandler(param1:IJoinBattleErrorHandler) : void
      {
         addHandler(IJoinBattleErrorHandler,param1);
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         debugTrace("I/O Error: " + param1.text);
      }
      
      private function playerKickedOut(param1:Object) : void
      {
         var _loc2_:IBattlePlayerKickedOutHandler = null;
         resetGame();
         for each(_loc2_ in _handlers[IBattlePlayerKickedOutHandler])
         {
            _loc2_.handleBattlePlayerKickedOut({"userRefId":int(param1.userRefId)});
         }
      }
      
      private function handleSelectedNanovorErrorDialogClose(param1:Object) : void
      {
         var _loc2_:ISelectedNanovorErrorHandler = null;
         for each(_loc2_ in _handlers[ISelectedNanovorErrorHandler])
         {
            _loc2_.handleSelectedNanovorError();
         }
      }
      
      public function handleInvitationDecline(param1:Object) : void
      {
         replyGameInvitation(param1.battleName,false,Const.REPLY_CODE_DECLINE);
         log("data.convertedChat " + param1.convertedChatRoom);
         if("true" == param1.convertedChatRoom)
         {
            IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).reset();
            GameServiceProvider.getInstance().chatGameService.exitChatRoom();
         }
      }
      
      public function addEnemySelectedHandler(param1:IEnemySelectedHandler) : void
      {
         addHandler(IEnemySelectedHandler,param1);
      }
      
      public function removeBattleInvitationErrorHandler(param1:IBattleInvitationErrorHandler) : void
      {
         removeHandler(IBattleInvitationErrorHandler,param1);
      }
      
      private function resetGame() : void
      {
         _players = new Array();
         _gameCreator = "";
         _battleName = "";
         _createdBattle = false;
      }
      
      public function removePlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void
      {
         removeHandler(IPlayerQuitGameHandler,param1);
      }
      
      public function removeBattlePlayerKickedOutHandler(param1:IBattlePlayerKickedOutHandler) : void
      {
         removeHandler(IBattlePlayerKickedOutHandler,param1);
      }
      
      private function gameOver(param1:Object) : void
      {
         var _loc2_:IGameOverHandler = null;
         log("gameOver(): winnerId: " + param1.winnerId + ", results: " + param1.results);
         resetGame();
         for each(_loc2_ in _handlers[IGameOverHandler])
         {
            _loc2_.handleGameOver(param1.winnerId,param1.results);
         }
         Managers.serviceRequestBrokerManager.startTokenRefresh();
      }
      
      public function setSelectedNanovor(param1:int) : void
      {
         sendRequestToServer(GameState.REQUEST_SET_SELECTED_NANOVOR,{"nanovorId":param1});
      }
      
      public function playerDeclinedToWatch(param1:String) : void
      {
         sendRequestToServer(GameState.REQUEST_DECLINED_TO_WATCH,{"userRefId":param1});
         quitGame();
      }
      
      public function addPlayerQuitGameHandler(param1:IPlayerQuitGameHandler) : void
      {
         addHandler(IPlayerQuitGameHandler,param1);
      }
      
      private function registerGameEventHandlers() : void
      {
         log("registerGameEventHandlers()");
         _gameServiceConnection.addEventListener(SFSEvent.onExtensionResponse,handleExtensionResponse);
         _gameServiceConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         _gameServiceConnection.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
      }
      
      private function gameSwarmValueSet(param1:Object) : void
      {
         var _loc2_:IGameSwarmValueSetHandler = null;
         for each(_loc2_ in _handlers[IGameSwarmValueSetHandler])
         {
            _loc2_.handleGameSwarmValueSet(_battleName,param1.gameSwarmValue);
         }
      }
      
      public function removeQuittingGameHandler(param1:IQuittingGameHandler) : void
      {
         removeHandler(IQuittingGameHandler,param1);
      }
      
      override protected function createHandlersDictionary() : void
      {
         _handlers = new Dictionary();
         _handlers[IBattleCreatedHandler] = new Dictionary(true);
         _handlers[IBattleCreationErrorHandler] = new Dictionary(true);
         _handlers[IBattleInvitationErrorHandler] = new Dictionary(true);
         _handlers[IJoinBattleErrorHandler] = new Dictionary(true);
         _handlers[ISelectedNanovorErrorHandler] = new Dictionary(true);
         _handlers[IBattleErrorHandler] = new Dictionary(true);
         _handlers[IBattleInvitationRequestHandler] = new Dictionary(true);
         _handlers[IBattleInvitationResponseHandler] = new Dictionary(true);
         _handlers[IBattlePlayerKickedOutHandler] = new Dictionary(true);
         _handlers[IPlayerJoinBattleHandler] = new Dictionary(true);
         _handlers[IOtherPlayerJoinBattleHandler] = new Dictionary(true);
         _handlers[IBattleStartedHandler] = new Dictionary(true);
         _handlers[IGameSwarmValueSetHandler] = new Dictionary(true);
         _handlers[IGameSwarmSelectedHandler] = new Dictionary(true);
         _handlers[IReadyForTurnHandler] = new Dictionary(true);
         _handlers[IEnemySelectedHandler] = new Dictionary(true);
         _handlers[ISetRoundInfoHandler] = new Dictionary(true);
         _handlers[IPerformAttackHandler] = new Dictionary(true);
         _handlers[IRoundCompletedHandler] = new Dictionary(true);
         _handlers[IPlayerQuitGameHandler] = new Dictionary(true);
         _handlers[IGameOverHandler] = new Dictionary(true);
         _handlers[IQuittingGameHandler] = new Dictionary(true);
         _handlers[IRoomDestroyedHandler] = new Dictionary(true);
         _handlers[IBattleInvitationAcceptHandler] = new Dictionary(true);
      }
   }
}

