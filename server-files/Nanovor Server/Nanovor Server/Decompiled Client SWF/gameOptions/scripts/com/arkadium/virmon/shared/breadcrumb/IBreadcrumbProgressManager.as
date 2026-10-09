package com.arkadium.virmon.shared.breadcrumb
{
   public interface IBreadcrumbProgressManager
   {
      
      function setBreadcrumbAsComplete(param1:BreadcrumbType) : void;
      
      function getIsBreadcrumbComplete(param1:BreadcrumbType) : Boolean;
      
      function getNextBreadcrumbType() : BreadcrumbType;
   }
}

