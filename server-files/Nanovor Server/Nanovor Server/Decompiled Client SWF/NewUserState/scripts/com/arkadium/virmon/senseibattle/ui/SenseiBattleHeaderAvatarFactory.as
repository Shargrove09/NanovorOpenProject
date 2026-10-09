package com.arkadium.virmon.senseibattle.ui
{
   import com.arkadium.virmon.battle.IBattleHeaderAvatarFactory;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   
   public class SenseiBattleHeaderAvatarFactory implements IBattleHeaderAvatarFactory
   {
      
      public function SenseiBattleHeaderAvatarFactory()
      {
         super();
      }
      
      public function createAvatar() : IAvatar
      {
         return new SenseiAvatar();
      }
   }
}

