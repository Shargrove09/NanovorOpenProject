package com.arkadium.virmon.framework.asset.migration
{
   public interface IMigrationWizard
   {
      
      function addMigrationWizardCompleteHandler(param1:IMigrationWizardCompleteHandler) : void;
      
      function start() : void;
      
      function removeMigrationWizardCompleteHandler(param1:IMigrationWizardCompleteHandler) : void;
      
      function destroy() : void;
   }
}

