package com.arkadium.virmon.shared.data
{
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.battle.control.Nanovor;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   
   public class NanovorFactory implements INanovorFactory
   {
      
      private static var _baseResultNanovor:INanovor;
      
      private var _virmonManager:IVirmonManager;
      
      public function NanovorFactory(param1:IVirmonManager)
      {
         super();
         this._virmonManager = param1;
      }
      
      public function createNanovorInstanceById(param1:String) : INanovor
      {
         var _loc2_:Nanovor = null;
         var _loc3_:IVirmonData = this.findNanovorInstanceById(param1);
         if(Boolean(_loc3_))
         {
            _loc2_ = new Nanovor();
            _loc2_.initializeWithVirmonData(_loc3_);
         }
         return _loc2_;
      }
      
      public function createNanovorTypeById(param1:int) : INanovor
      {
         var _loc2_:Nanovor = null;
         var _loc3_:IVirmonMasterData = this._virmonManager.getVirmonMasterData(param1);
         if(Boolean(_loc3_))
         {
            _loc2_ = new Nanovor();
            _loc2_.initializeWithMasterData(_loc3_);
         }
         return _loc2_;
      }
      
      public function findNanovorInstanceById(param1:String) : IVirmonData
      {
         return this._virmonManager.getVirmonData(param1);
      }
      
      public function get baseResultNanovor() : INanovor
      {
         if(_baseResultNanovor == null)
         {
            _baseResultNanovor = new BaseResultNanovor();
         }
         return _baseResultNanovor;
      }
   }
}

