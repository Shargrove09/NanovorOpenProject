package com.arkadium.virmon.framework.asset.retriever
{
   import com.arkadium.virmon.framework.asset.IAssetManager;
   
   public class AssetRetrieverManager implements IAssetRetrieverManager
   {
      
      private var _emAssetRetriever:IEMAssetRetriever;
      
      private var _masterDataAssetRetriever:IMasterDataAssetRetriever;
      
      private var _overlayAssetRetriever:IOverlayAssetRetriever;
      
      private var _soundAssetRetriever:ISoundAssetRetriever;
      
      private var _boosterAssetRetriever:IBoosterAssetRetriever;
      
      private var _helpAssetRetriever:IHelpAssetRetriever;
      
      private var _badgeAssetRetriever:IBadgeAssetRetriever;
      
      private var _characterAssetRetriever:ICharacterAssetRetriever;
      
      private var _avatarAssetRetriever:IAvatarAssetRetriever;
      
      public function AssetRetrieverManager(param1:IAssetManager)
      {
         super();
         _avatarAssetRetriever = new AvatarAssetRetriever(param1);
         _badgeAssetRetriever = new BadgeAssetRetriever(param1);
         _boosterAssetRetriever = new BoosterAssetRetriever(param1);
         _characterAssetRetriever = new CharacterAssetRetriever(param1);
         _emAssetRetriever = new EMAssetRetriever(param1);
         _helpAssetRetriever = new HelpAssetRetriever(param1);
         _masterDataAssetRetriever = new MasterDataAssetRetriever(param1);
         _overlayAssetRetriever = new OverlayAssetRetriever(param1);
         _soundAssetRetriever = new SoundAssetRetriever(param1);
      }
      
      public function get overlayAssetRetriever() : IOverlayAssetRetriever
      {
         return _overlayAssetRetriever;
      }
      
      public function get helpAssetRetriever() : IHelpAssetRetriever
      {
         return _helpAssetRetriever;
      }
      
      public function get soundAssetRetriever() : ISoundAssetRetriever
      {
         return _soundAssetRetriever;
      }
      
      public function get boosterAssetRetriever() : IBoosterAssetRetriever
      {
         return _boosterAssetRetriever;
      }
      
      public function get badgeAssetRetriever() : IBadgeAssetRetriever
      {
         return _badgeAssetRetriever;
      }
      
      public function get characterAssetRetriever() : ICharacterAssetRetriever
      {
         return _characterAssetRetriever;
      }
      
      public function get masterDataAssetRetriever() : IMasterDataAssetRetriever
      {
         return _masterDataAssetRetriever;
      }
      
      public function get avatarAssetRetriever() : IAvatarAssetRetriever
      {
         return _avatarAssetRetriever;
      }
      
      public function get emAssetRetriever() : IEMAssetRetriever
      {
         return _emAssetRetriever;
      }
   }
}

