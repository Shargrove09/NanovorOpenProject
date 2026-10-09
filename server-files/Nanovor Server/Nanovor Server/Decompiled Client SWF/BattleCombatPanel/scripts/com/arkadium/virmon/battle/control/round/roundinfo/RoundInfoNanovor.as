package com.arkadium.virmon.battle.control.round.roundinfo
{
   public class RoundInfoNanovor
   {
      
      private var _armor:int;
      
      private var _assetTypeId:int;
      
      private var _speed:int;
      
      private var _assetId:String;
      
      private var _nickName:String;
      
      private var _strength:int;
      
      private var _health:int;
      
      public function RoundInfoNanovor(param1:Object)
      {
         super();
         if(null == param1)
         {
            throw new Error("selectedNanovorObject is null");
         }
         if(null == param1.instanceId)
         {
            throw new Error("selectedNanovorObject.instanceId is null");
         }
         if(null == param1.assetTypeId)
         {
            throw new Error("selectedNanovorObject.assetTypeId is null");
         }
         if(null == param1.nickname)
         {
            throw new Error("selectedNanovorObject.nickname is null");
         }
         if(null == param1.speed)
         {
            throw new Error("selectedNanovorObject.speed is null");
         }
         if(null == param1.strength)
         {
            throw new Error("selectedNanovorObject.strength is null");
         }
         if(null == param1.armor)
         {
            throw new Error("selectedNanovorObject.armor is null");
         }
         if(null == param1.health)
         {
            throw new Error("selectedNanovorObject.health is null");
         }
         _assetId = param1.instanceId;
         _assetTypeId = param1.assetTypeId;
         _nickName = param1.nickname;
         _speed = param1.speed;
         _strength = param1.strength;
         _armor = param1.armor;
         _health = param1.health;
      }
      
      public function get strength() : int
      {
         return _strength;
      }
      
      public function get assetTypeId() : int
      {
         return _assetTypeId;
      }
      
      public function get nickName() : String
      {
         return _nickName;
      }
      
      public function get assetId() : String
      {
         return _assetId;
      }
      
      public function get armor() : int
      {
         return _armor;
      }
      
      public function get health() : int
      {
         return _health;
      }
      
      public function get speed() : int
      {
         return _speed;
      }
   }
}

