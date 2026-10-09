package com.arkadium.virmon.battle
{
   import com.arkadium.communications.IUserGameService;
   import com.arkadium.communications.handlers.user.IBuddyAvatarDataHandler;
   import com.arkadium.virmon.shared.components.ISwarmometer;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import com.arkadium.virmon.shared.data.Const;
   import com.arkadium.virmon.shared.widgets.header.IHeaderWidget;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class BattleHeaderController implements IBattleHeaderController, IBuddyAvatarDataHandler
   {
      
      private var _headerWidget:IHeaderWidget;
      
      private var _playerSwarmCount:Dictionary;
      
      private var _userGameService:IUserGameService;
      
      private var _battleData:IBattleData;
      
      private var _avatarFactory:IBattleHeaderAvatarFactory;
      
      public function BattleHeaderController(param1:IHeaderWidget, param2:IUserGameService, param3:IBattleHeaderAvatarFactory)
      {
         var _loc4_:IAvatar = null;
         super();
         _headerWidget = param1;
         _userGameService = param2;
         _avatarFactory = param3;
         if(null != _userGameService)
         {
            _userGameService.addBuddyAvatarDataHandler(IBuddyAvatarDataHandler(this));
         }
         _playerSwarmCount = new Dictionary();
         for each(_loc4_ in _headerWidget.enemyAvatars)
         {
            _headerWidget.removeAvatar(_loc4_);
         }
      }
      
      public function removePlayerAvatar(param1:int, param2:uint) : void
      {
         var _loc3_:IAvatar = _headerWidget.getAvatarByPlayerID(param1);
         if(null != _loc3_)
         {
            _headerWidget.removeAvatar(_loc3_);
         }
         _headerWidget.resetNumberOfPlayers(param2);
      }
      
      private function setMyAvatarStatus(param1:String) : void
      {
         var _loc2_:IAvatar = _headerWidget.myAvatar;
         _loc2_.status = param1;
      }
      
      public function getAvatarByPlayerId(param1:int) : IAvatar
      {
         return _headerWidget.getAvatarByPlayerID(param1);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<BattleHeaderController>>\t" + param1);
      }
      
      public function getSwarmCountByUserRefId(param1:int) : int
      {
         return null == _playerSwarmCount[param1] ? -1 : int(_playerSwarmCount[param1]);
      }
      
      public function playerSwarmSelected(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:ISwarmometer = null;
         var _loc6_:int = 0;
         var _loc4_:IAvatar = _headerWidget.getAvatarByPlayerID(param1);
         if(null != _loc4_)
         {
            _loc4_.setStatusText(Const.AVATAR_TEXT_READY_FOR_BATTLE,Const.AVATAR_TEXTCOLOR_READY_FOR_BATTLE);
            _loc5_ = _loc4_.swarmometer;
            _loc6_ = param3 ? int(_loc5_.METER_POPUPS_OFFSET_ALT_LEFT) : int(_loc5_.METER_POPUPS_OFFSET_DEFAULT);
            _loc5_.setSwarmCount(param2,_loc6_);
         }
         _playerSwarmCount[param1] = param2;
      }
      
      private function setEnemyAvatarStatus(param1:String) : void
      {
         var _loc3_:IAvatar = null;
         var _loc2_:Array = _headerWidget.enemyAvatars;
         if(null == _loc2_)
         {
            return;
         }
         for each(_loc3_ in _loc2_)
         {
            _loc3_.status = param1;
         }
      }
      
      public function setAllStatusWaiting() : void
      {
         setAllStatus(Const.AVATAR_STATUS_BATTLE_WAITING);
      }
      
      public function updateAllAvatarsAndNMPs() : void
      {
         var _loc1_:BattlePlayer = null;
         if(null == _battleData)
         {
            return;
         }
         for each(_loc1_ in _battleData.playersInBattle)
         {
            if(null != _userGameService)
            {
               _userGameService.getBuddyAvatar(_loc1_.playerName);
            }
         }
      }
      
      public function playerLeftBattle(param1:int) : void
      {
         var _loc2_:IAvatar = _headerWidget.getAvatarByPlayerID(param1);
         if(null != _loc2_)
         {
            _loc2_.setStatusText(Const.AVATAR_STATUS_LEFT_BATTLE);
         }
      }
      
      private function setAllStatus(param1:String) : void
      {
         setMyAvatarStatus(param1);
         setEnemyAvatarStatus(param1);
      }
      
      public function getSwarmometerById(param1:int) : ISwarmometer
      {
         var _loc2_:IAvatar = _headerWidget.getAvatarByPlayerID(param1);
         if(null == _loc2_)
         {
            return null;
         }
         return _loc2_.swarmometer;
      }
      
      public function setCombatMode() : void
      {
         var _loc2_:IAvatar = null;
         var _loc1_:Array = _headerWidget.enemyAvatars.slice();
         _loc1_.push(_headerWidget.myAvatar);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.status = Const.AVATAR_STATUS_BATTLE;
            _loc2_.override = true;
         }
      }
      
      public function handleBuddyAvatarData(param1:Object = null) : void
      {
         log("handleBuddyAvatarData() - Receiving avatar data for userRefId: " + param1.userRefId);
         _headerWidget.loadEnemyAvatarPictureById(param1.userRefId,int(param1.avatarId),int(param1.nmp));
      }
      
      public function setBattleMode(param1:IBattleData, param2:String) : void
      {
         var _loc3_:BattlePlayer = null;
         var _loc4_:IAvatar = null;
         _battleData = param1;
         _headerWidget.setNumberOfPlayers(_battleData.playersInBattle.length);
         for each(_loc3_ in _battleData.playersInBattle)
         {
            if(_loc3_.playerName.toLowerCase() != param2.toLowerCase())
            {
               _loc4_ = _avatarFactory.createAvatar();
               _loc4_.playerName = _loc3_.playerName;
               _loc4_.playerID = _loc3_.playerId;
               _headerWidget.addEnemyAvatar(_loc4_);
               if(null != _userGameService)
               {
                  _userGameService.getBuddyAvatar(_loc3_.playerName);
               }
            }
         }
      }
   }
}

