package com.arkadium.communications
{
   import com.arkadium.virmon.common.IUserProfileLoadCompleteHandler;
   import com.arkadium.virmon.shared.utils.IChainLoader;
   import flash.events.IEventDispatcher;
   
   public interface IUserProfile extends IEventDispatcher
   {
      
      function getBattleCount() : int;
      
      function updateAvatar(param1:int) : void;
      
      function updateBreadcrumbCount(param1:int = 0) : void;
      
      function setJolts(param1:int, param2:int, param3:int, param4:int) : void;
      
      function get strengthJolts() : int;
      
      function get armorJolts() : int;
      
      function get healthJolts() : int;
      
      function get name() : String;
      
      function get breadcrumbCount() : int;
      
      function addUserProfileLoadCompleteHandler(param1:IUserProfileLoadCompleteHandler) : void;
      
      function get nmp() : int;
      
      function get ems() : int;
      
      function get avatarId() : int;
      
      function get gamesWon() : int;
      
      function getBreadcrumbCount() : int;
      
      function retrieveProfileData(param1:Boolean = false) : void;
      
      function get memberHistory() : Number;
      
      function get nanovorCountUnique() : int;
      
      function get email() : String;
      
      function setId(param1:int) : void;
      
      function get phoneNumber() : String;
      
      function get velocitronKills() : int;
      
      function get fourPlayerGames() : int;
      
      function get id() : int;
      
      function get accountInfoXML() : XML;
      
      function setUserGameService(param1:IUserGameService) : void;
      
      function load() : void;
      
      function get nanocash() : int;
      
      function get threePlayerGames() : int;
      
      function get nanovorCount() : int;
      
      function updateBattleCount() : void;
      
      function removeUserProfileLoadCompleteHandler(param1:IUserProfileLoadCompleteHandler) : void;
      
      function setChainLoader(param1:IChainLoader) : void;
      
      function get gamesPlayed() : int;
      
      function get hexiteKills() : int;
      
      function get screenname() : String;
      
      function get totalKills() : int;
      
      function get magnamodKills() : int;
      
      function get twoPlayerGames() : int;
      
      function resetBreadcrumbCount() : void;
      
      function get loaded() : Boolean;
      
      function get speedJolts() : int;
   }
}

