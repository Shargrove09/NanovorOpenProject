package com.arkadium.virmon.framework.asset.retriever
{
   public interface IAssetRetrieverManager
   {
      
      function get avatarAssetRetriever() : IAvatarAssetRetriever;
      
      function get masterDataAssetRetriever() : IMasterDataAssetRetriever;
      
      function get soundAssetRetriever() : ISoundAssetRetriever;
      
      function get boosterAssetRetriever() : IBoosterAssetRetriever;
      
      function get helpAssetRetriever() : IHelpAssetRetriever;
      
      function get badgeAssetRetriever() : IBadgeAssetRetriever;
      
      function get overlayAssetRetriever() : IOverlayAssetRetriever;
      
      function get emAssetRetriever() : IEMAssetRetriever;
      
      function get characterAssetRetriever() : ICharacterAssetRetriever;
   }
}

