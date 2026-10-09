package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import flash.utils.Dictionary;
   
   public class ApplicationPackageList implements IApplicationPackageList
   {
      
      private var _packages:Dictionary;
      
      public function ApplicationPackageList()
      {
         super();
         _packages = new Dictionary();
      }
      
      public function getPackage(param1:PackageType) : IApplicationPackage
      {
         return _packages[param1] as IApplicationPackage;
      }
      
      public function addPackage(param1:IApplicationPackage) : void
      {
         _packages[param1.type] = param1;
      }
      
      public function get packages() : Dictionary
      {
         return _packages;
      }
   }
}

