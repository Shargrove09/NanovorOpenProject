package com.arkadium.virmon.framework.application
{
   import flash.utils.Dictionary;
   
   internal class DependencyList
   {
      
      private var _dependencies:Dictionary;
      
      public function DependencyList()
      {
         super();
         _dependencies = new Dictionary();
      }
      
      public function hasDependency(param1:IDependency) : Boolean
      {
         return Boolean(_dependencies[param1] != null);
      }
      
      public function get dependencies() : Dictionary
      {
         return _dependencies;
      }
      
      public function addDependency(param1:IDependency) : void
      {
         _dependencies[param1] = param1;
      }
      
      public function get hasOutdatedDependency() : Boolean
      {
         var _loc1_:IDependency = null;
         for each(_loc1_ in _dependencies)
         {
            if(_loc1_.isOutdated)
            {
               return true;
            }
         }
         return false;
      }
   }
}

