package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import flash.utils.Dictionary;
   
   public interface IApplicationPackageList
   {
      
      function getPackage(param1:PackageType) : IApplicationPackage;
      
      function get packages() : Dictionary;
      
      function addPackage(param1:IApplicationPackage) : void;
   }
}

