package com.arkadium.virmon.senseibattle.ai
{
   public class SenseiAIType
   {
      
      private var _revealed:Boolean;
      
      private var _nanovors:Array;
      
      private var _aiName:String;
      
      private var _aiUserRefId:int;
      
      public function SenseiAIType(param1:String, param2:int, param3:Array, param4:Boolean)
      {
         super();
         _aiName = param1;
         _aiUserRefId = param2;
         _nanovors = param3;
         _revealed = param4;
      }
      
      public function get revealed() : Boolean
      {
         return _revealed;
      }
      
      public function get nanovors() : Array
      {
         return _nanovors;
      }
      
      public function get aiName() : String
      {
         return _aiName;
      }
      
      public function get aiUserRefId() : int
      {
         return _aiUserRefId;
      }
   }
}

