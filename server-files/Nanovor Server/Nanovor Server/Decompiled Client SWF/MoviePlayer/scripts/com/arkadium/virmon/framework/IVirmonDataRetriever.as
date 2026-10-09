package com.arkadium.virmon.framework
{
   public interface IVirmonDataRetriever
   {
      
      function getVirmonDataByAssetTypeId(param1:Number) : IVirmonData;
      
      function getVirmonData(param1:String) : IVirmonData;
      
      function getVirmonMasterData(param1:Number) : IVirmonMasterData;
   }
}

