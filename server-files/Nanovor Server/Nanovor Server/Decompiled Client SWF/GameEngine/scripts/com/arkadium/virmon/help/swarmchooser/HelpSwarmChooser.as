package com.arkadium.virmon.help.swarmchooser
{
   import com.arkadium.virmon.help.swarmchooser.addnanovor.HelpSwarmChooserAddNanovor;
   import com.arkadium.virmon.help.swarmchooser.gotobattle.HelpSwarmChooserGoToBattleHelp;
   import com.arkadium.virmon.help.swarmchooser.nanovorselect.HelpSwarmChooserNanovorSelect;
   import com.arkadium.virmon.help.swarmchooser.treeselect.HelpSwarmChooserTreeSelect;
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   
   public class HelpSwarmChooser extends MovieClip implements IHelpSwarmChooser
   {
      
      private var _nanovorSelectHelp:HelpSwarmChooserNanovorSelect;
      
      private var _addNanovorHelp:HelpSwarmChooserAddNanovor;
      
      private var _treeSelectHelp:HelpSwarmChooserTreeSelect;
      
      private var _goToBattleHelp:HelpSwarmChooserGoToBattleHelp;
      
      public function HelpSwarmChooser()
      {
         super();
      }
      
      public function destroy() : void
      {
         if(Boolean(_treeSelectHelp))
         {
            _treeSelectHelp.destroy();
            removeChild(_treeSelectHelp);
            _treeSelectHelp = null;
         }
         if(Boolean(_nanovorSelectHelp))
         {
            _nanovorSelectHelp.destroy();
            removeChild(_nanovorSelectHelp);
            _nanovorSelectHelp = null;
         }
         if(Boolean(_addNanovorHelp))
         {
            _addNanovorHelp.destroy();
            removeChild(_addNanovorHelp);
            _addNanovorHelp = null;
         }
         if(Boolean(_goToBattleHelp))
         {
            _goToBattleHelp.destroy();
            removeChild(_goToBattleHelp);
            _goToBattleHelp = null;
         }
      }
      
      public function showAddNanovorHelp(param1:int = 0) : void
      {
         if(Boolean(_nanovorSelectHelp))
         {
            _nanovorSelectHelp.destroy();
            removeChild(_nanovorSelectHelp);
            _nanovorSelectHelp = null;
         }
         _addNanovorHelp = new HelpSwarmChooserAddNanovor();
         addChild(_addNanovorHelp);
         _addNanovorHelp.start(param1);
      }
      
      public function showNanovorSelectHelp(param1:TreeViewMenu, param2:int = 0) : void
      {
         if(Boolean(_treeSelectHelp))
         {
            _treeSelectHelp.destroy();
            removeChild(_treeSelectHelp);
            _treeSelectHelp = null;
         }
         _nanovorSelectHelp = new HelpSwarmChooserNanovorSelect(param1);
         addChild(_nanovorSelectHelp);
         _nanovorSelectHelp.start(param2);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("HelpSwarmChooser>> " + param1);
      }
      
      public function showGoToBattleHelp(param1:int = 0) : void
      {
         if(Boolean(_addNanovorHelp))
         {
            _addNanovorHelp.destroy();
            removeChild(_addNanovorHelp);
            _addNanovorHelp = null;
         }
         _goToBattleHelp = new HelpSwarmChooserGoToBattleHelp();
         addChild(_goToBattleHelp);
         _goToBattleHelp.start(param1);
      }
      
      public function showTreeSelectHelp(param1:TreeViewMenu, param2:int = 0) : void
      {
         _treeSelectHelp = new HelpSwarmChooserTreeSelect(param1);
         addChild(_treeSelectHelp);
         _treeSelectHelp.start(param2);
      }
   }
}

