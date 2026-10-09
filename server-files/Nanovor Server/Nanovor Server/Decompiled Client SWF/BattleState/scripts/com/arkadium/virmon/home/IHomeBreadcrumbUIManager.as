package com.arkadium.virmon.home
{
   import com.arkadium.virmon.shared.breadcrumb.BreadcrumbType;
   
   public interface IHomeBreadcrumbUIManager
   {
      
      function showBreadcrumb() : void;
      
      function get isNewsBlockerActive() : Boolean;
      
      function registerNewsBlocker(param1:IHomeNewsBlocker) : *;
      
      function stopBreadcrumb() : void;
      
      function get currentBreadcrumbType() : BreadcrumbType;
      
      function playBreadcrumb() : void;
      
      function unregisterNewsBlocker(param1:IHomeNewsBlocker) : *;
      
      function hideBreadcrumb() : void;
      
      function get activeNewsBlockerCount() : int;
   }
}

