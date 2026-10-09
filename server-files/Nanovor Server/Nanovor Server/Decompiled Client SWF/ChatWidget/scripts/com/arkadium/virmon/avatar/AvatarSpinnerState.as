package com.arkadium.virmon.avatar
{
   public class AvatarSpinnerState implements IAvatarSpinnerState
   {
      
      private var _state:AvatarSpinnerStateType;
      
      public function AvatarSpinnerState(param1:AvatarSpinnerStateType = null)
      {
         super();
         this._state = null == param1 ? AvatarSpinnerStateType.INACTIVE : param1;
      }
      
      public function get state() : AvatarSpinnerStateType
      {
         return this._state;
      }
      
      public function set state(param1:AvatarSpinnerStateType) : void
      {
         this._state = param1;
      }
   }
}

