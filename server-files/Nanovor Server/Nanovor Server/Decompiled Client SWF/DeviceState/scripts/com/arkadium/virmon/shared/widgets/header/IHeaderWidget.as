package com.arkadium.virmon.shared.widgets.header
{
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import com.arkadium.virmon.shared.widgets.IWidget;
   import com.arkadium.virmon.state.StateType;
   
   public interface IHeaderWidget extends IWidget
   {
      
      function resetNumberOfPlayers(param1:int) : void;
      
      function enableDeviceButton() : void;
      
      function disableQuickTipsButton() : void;
      
      function set showLogo(param1:Boolean) : void;
      
      function get enemyAvatars() : Array;
      
      function enableQuickTipsButton() : void;
      
      function setNumberOfPlayers(param1:int) : void;
      
      function set playerName(param1:String) : void;
      
      function showLeaveBattle(param1:IHeaderWidgetLeaveBattleHandler) : void;
      
      function setDeviceMode() : void;
      
      function set playerNanocash(param1:*) : void;
      
      function addEnemyAvatar(param1:IAvatar) : void;
      
      function setStateButton(param1:StateType) : void;
      
      function getAvatarByPlayerID(param1:int) : IAvatar;
      
      function get myAvatar() : IAvatar;
      
      function set playerStatus(param1:String) : void;
      
      function disableMenu(param1:Boolean) : void;
      
      function showLastButtonClickedAsCurrent() : void;
      
      function hideLeaveBattle() : void;
      
      function set playerNMP(param1:*) : void;
      
      function disableDeviceButton() : void;
      
      function loadEnemyAvatarPictureById(param1:int, param2:int, param3:int) : void;
      
      function disableButton(param1:StateType, param2:Boolean) : void;
      
      function set splattered(param1:int) : void;
      
      function removeAvatar(param1:IAvatar) : void;
      
      function set minQuickTips(param1:Boolean) : void;
   }
}

