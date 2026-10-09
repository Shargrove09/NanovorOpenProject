package com.arkadium.virmon.shared.widgets.header
{
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import flash.display.DisplayObjectContainer;
   
   public interface IHeaderAvatarRenderer
   {
      
      function addEnemyAvatar(param1:IAvatar) : void;
      
      function getAvatarByPlayerID(param1:int) : IAvatar;
      
      function resetNumberOfPlayers(param1:int) : void;
      
      function get myAvatar() : IAvatar;
      
      function setPlayerNMP(param1:int) : void;
      
      function setPlayerNanocash(param1:int) : void;
      
      function setAvatarStatus(param1:String) : void;
      
      function setPlayerName(param1:String) : void;
      
      function setNumberOfPlayers(param1:int) : void;
      
      function get enemyAvatars() : Array;
      
      function createAvatar(param1:int, param2:int, param3:int, param4:DisplayObjectContainer) : void;
      
      function removeEnemyAvatars() : void;
      
      function loadEnemyAvatarPictureById(param1:int, param2:int, param3:int) : void;
      
      function removeEnemyAvatar(param1:IAvatar) : void;
      
      function setAvatarMode(param1:String) : void;
      
      function loadAvatarPicture(param1:int) : void;
   }
}

