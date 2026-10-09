package com.arkadium.virmon.framework.application
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   
   public interface IApplicationPackage extends IDependency
   {
      
      function hasFileDependency(param1:String) : Boolean;
      
      function get priority() : int;
      
      function hasPackageDependency(param1:PackageType) : Boolean;
      
      function get type() : PackageType;
      
      function addDependency(param1:IDependency) : void;
   }
}

