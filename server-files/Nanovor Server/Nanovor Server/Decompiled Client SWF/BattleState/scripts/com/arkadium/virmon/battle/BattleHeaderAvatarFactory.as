package com.arkadium.virmon.battle
{
   import com.arkadium.virmon.framework.asset.retriever.IAvatarAssetRetriever;
   import com.arkadium.virmon.shared.components.avatar.Avatar;
   import com.arkadium.virmon.shared.components.avatar.IAvatar;
   import com.arkadium.virmon.shared.data.Const;
   
   public class BattleHeaderAvatarFactory implements IBattleHeaderAvatarFactory
   {
      
      private var _avatarAssetRetriever:IAvatarAssetRetriever;
      
      public function BattleHeaderAvatarFactory(param1:IAvatarAssetRetriever)
      {
         super();
         _avatarAssetRetriever = param1;
      }
      
      public function createAvatar() : IAvatar
      {
         var _loc1_:Avatar = new Avatar(_avatarAssetRetriever);
         _loc1_.color = Const.AVATAR_WIDGET_COLOR_RED;
         _loc1_.mode = Const.AVATAR_MODE_BATTLE;
         _loc1_.status = Const.AVATAR_STATUS_BATTLE;
         _loc1_.mcSlider.gotoAndStop("masked");
         return _loc1_;
      }
   }
}

