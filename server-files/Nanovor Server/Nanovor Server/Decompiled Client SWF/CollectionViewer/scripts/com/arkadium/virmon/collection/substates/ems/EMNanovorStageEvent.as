package com.arkadium.virmon.collection.substates.ems
{
   import flash.events.Event;
   
   public class EMNanovorStageEvent extends Event
   {
      
      public static const NANOVOR_CLICKED:String = "nanovorClicked";
      
      private var _assetTypeId:int;
      
      public function EMNanovorStageEvent(param1:String, param2:int, param3:Boolean = false)
      {
         super(param1,param3);
         _assetTypeId = param2;
      }
      
      public function get assetTypeId() : int
      {
         return _assetTypeId;
      }
   }
}

