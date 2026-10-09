package com.arkadium.virmon.downloadmanager.handlers
{
   import com.arkadium.virmon.framework.application.enum.PackageType;
   
   public interface IPackageCompleteHandler
   {
      
      function handlePackageComplete(param1:PackageType) : void;
   }
}

