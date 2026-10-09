package com.arkadium.virmon.battle.control.round.roundinfo
{
   public class RoundInfo
   {
      
      private var _roundInfoPlayers:Array;
      
      public function RoundInfo(param1:Object)
      {
         var _loc2_:Object = null;
         super();
         if(null == param1)
         {
            throw new Error("roundInfo is null");
         }
         if(null == param1.players)
         {
            throw new Error("roundInfo.players is null");
         }
         _roundInfoPlayers = new Array();
         for each(_loc2_ in param1.players)
         {
            _roundInfoPlayers.push(new RoundInfoPlayer(_loc2_));
         }
      }
      
      public function get roundInfoPlayers() : Array
      {
         return _roundInfoPlayers;
      }
   }
}

