package com.arkadium.virmon.framework.asset
{
   public class CharacterAsset extends Asset implements ICharacterAsset
   {
      
      private var _characterTypeId:int;
      
      public function CharacterAsset(param1:int, param2:String, param3:uint, param4:String, param5:String, param6:Boolean, param7:String, param8:IAssetGroup, param9:Boolean)
      {
         super(param2,param3,param4,param5,param6,param7,param8,param9);
         _characterTypeId = param1;
      }
      
      public function get characterTypeId() : int
      {
         return _characterTypeId;
      }
   }
}

