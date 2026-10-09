package com.arkadium.virmon.movieplayer
{
   public dynamic class DataManager
   {
      
      public static var _cInstance:DataManager = null;
      
      public var _aVirmonData:Array;
      
      public var _nScore:Number;
      
      public var _aLevelData:Array;
      
      public var _nLevel:Number;
      
      public var _nRangeSteps:Number = 5;
      
      public function DataManager()
      {
         super();
         initVars();
      }
      
      public static function getInstance() : DataManager
      {
         if(_cInstance == null)
         {
            _cInstance = new DataManager();
         }
         return _cInstance;
      }
      
      public function deleteInstance() : *
      {
         if(Boolean(_cInstance))
         {
            _cInstance = null;
         }
      }
      
      public function initVars() : *
      {
         _aLevelData = new Array();
         _aVirmonData = new Array();
         _nScore = 0;
         _nLevel = 0;
      }
   }
}

