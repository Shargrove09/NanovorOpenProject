package com.arkadium.virmon.battle.control
{
   import com.arkadium.virmon.framework.IVirmonManager;
   
   public class AttackStatementFactory implements IAttackStatementFactory
   {
      
      private var _virmonManager:IVirmonManager;
      
      public function AttackStatementFactory(param1:IVirmonManager)
      {
         super();
         this._virmonManager = param1;
      }
      
      public function createAttackStatementById(param1:int) : IAttackStatement
      {
         var _loc2_:Object = this._virmonManager.getAttackStatementById(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:AttackStatement = new AttackStatement();
         _loc3_.initializeWithStatementObject(_loc2_);
         return _loc3_;
      }
      
      public function clone(param1:IAttackStatement) : IAttackStatement
      {
         if(param1 == null)
         {
            return null;
         }
         return this.createAttackStatementById(param1.id);
      }
   }
}

