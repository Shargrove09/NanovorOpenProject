package com.arkadium.virmon.shared.data
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.IPlayer;
   import com.arkadium.virmon.battle.control.Player;
   
   public class PlayerFactory implements IPlayerFactory
   {
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _userProfile:IUserProfile;
      
      public function PlayerFactory(param1:INanovorFactory, param2:IUserProfile)
      {
         super();
         this._nanovorFactory = param1;
         this._userProfile = param2;
      }
      
      public function createMyPlayer() : IPlayer
      {
         return new Player(this._userProfile.screenname,this._userProfile.id,this._nanovorFactory);
      }
      
      public function createPlayer(param1:String, param2:int) : IPlayer
      {
         return new Player(param1,param2,this._nanovorFactory);
      }
   }
}

