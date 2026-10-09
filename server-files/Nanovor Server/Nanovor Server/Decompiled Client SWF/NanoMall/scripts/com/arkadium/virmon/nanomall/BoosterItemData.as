package com.arkadium.virmon.nanomall
{
   internal class BoosterItemData implements IBoosterItemData
   {
      
      private var _index:Number;
      
      private var _familyIconURL:String;
      
      private var _price:String;
      
      private var _name:String;
      
      private var _id:int;
      
      public function BoosterItemData(param1:int, param2:String, param3:String, param4:Number, param5:String)
      {
         super();
         _id = param1;
         _name = param2;
         _price = param3;
         _index = param4;
         _familyIconURL = param5;
      }
      
      public function get index() : Number
      {
         return _index;
      }
      
      public function get price() : String
      {
         return _price;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get familyIconURL() : String
      {
         return _familyIconURL;
      }
   }
}

