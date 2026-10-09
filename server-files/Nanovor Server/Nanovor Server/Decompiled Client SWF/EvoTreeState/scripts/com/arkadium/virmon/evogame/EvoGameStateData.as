package com.arkadium.virmon.evogame
{
   public class EvoGameStateData implements IEvoGameStateData
   {
      
      private var _sourceVirmonId:String;
      
      private var _evolutionId:int;
      
      private var _targetMasterVirmonId:int;
      
      private var _activeTreeId:int;
      
      public function EvoGameStateData(param1:int, param2:String, param3:int, param4:int)
      {
         super();
         _evolutionId = param1;
         _sourceVirmonId = param2;
         _targetMasterVirmonId = param3;
         _activeTreeId = param4;
      }
      
      public function get sourceVirmonId() : String
      {
         return _sourceVirmonId;
      }
      
      public function get evolutionId() : int
      {
         return _evolutionId;
      }
      
      public function get targetMasterVirmonId() : int
      {
         return _targetMasterVirmonId;
      }
      
      public function get activeTreeId() : int
      {
         return _activeTreeId;
      }
   }
}

