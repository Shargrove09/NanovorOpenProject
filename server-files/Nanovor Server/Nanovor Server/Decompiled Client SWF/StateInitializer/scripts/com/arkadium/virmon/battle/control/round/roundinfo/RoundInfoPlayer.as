package com.arkadium.virmon.battle.control.round.roundinfo
{
   public class RoundInfoPlayer
   {
      
      private var _userRefId:int;
      
      private var _selectedNanovor:RoundInfoNanovor;
      
      public function RoundInfoPlayer(param1:Object)
      {
         super();
         if(null == param1)
         {
            throw new Error("playerObject is null");
         }
         if(null == param1.userRefId)
         {
            throw new Error("playerObject.userRefId is null");
         }
         this._userRefId = param1.userRefId;
         if(null != param1.selectedNanovor)
         {
            this._selectedNanovor = new RoundInfoNanovor(param1.selectedNanovor);
         }
      }
      
      public function get selectedNanovor() : RoundInfoNanovor
      {
         return this._selectedNanovor;
      }
      
      public function get userRefId() : int
      {
         return this._userRefId;
      }
   }
}

