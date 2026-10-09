package com.arkadium.virmon.help.swarmchooser
{
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   
   public interface IHelpSwarmChooser
   {
      
      function showAddNanovorHelp(param1:int = 0) : void;
      
      function showNanovorSelectHelp(param1:TreeViewMenu, param2:int = 0) : void;
      
      function showTreeSelectHelp(param1:TreeViewMenu, param2:int = 0) : void;
      
      function showGoToBattleHelp(param1:int = 0) : void;
      
      function destroy() : void;
   }
}

