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
         this._assetId = param1.instanceId;
         this._assetTypeId = param1.assetTypeId;
         this._nickName = param1.nickname;
         this._speed = param1.speed;
         this._strength = param1.strength;
         this._armor = param1.armor;
         this._health = param1.health;
      }
      
      public function get strength() : int
      {
         return this._strength;
      }
      
      public function get assetTypeId() : int
      {
         return this._assetTypeId;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function get assetId() : String
      {
         return this._assetId;
      }
      
      public function get armor() : int
      {
         return this._armor;
      }
      
      public function get health() : int
      {
         return this._health;
      }
      
      public function get speed() : int
      {
         return this._speed;
      }
   }
}

