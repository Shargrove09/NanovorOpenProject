package com.arkadium.virmon.profilemanager
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.GUIManager;
   import com.arkadium.virmon.common.GUIPanel;
   import com.arkadium.virmon.common.ProjectEvent;
   import com.smithandtinker.nanovor.common.event.PanelEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol317")]
   public class ProfileManagerPanel extends GUIPanel
   {
      
      public const PANEL_NAME:String = "PROFILE_MANAGER_PANEL";
      
      public var profileManagerUI:ProfileManagerUI;
      
      public function ProfileManagerPanel()
      {
         super();
         log("Created");
         super.registerPanel(this,PANEL_NAME,GUIManager(parent));
      }
      
      override public function registerPanel(param1:GUIPanel, param2:String, param3:GUIManager) : *
      {
         super.registerPanel(param1,param2,param3);
      }
      
      override public function hidePanel() : *
      {
         this.visible = false;
         super.hidePanel();
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> ProfileManagerPanel: " + param1);
      }
      
      override public function showPanel() : *
      {
         super.showPanel();
      }
      
      override public function unRegisterPanel(param1:GUIPanel, param2:String) : *
      {
         log("unRegisterPanel... YIPPEE!");
         profileManagerUI.dispose();
         super.unRegisterPanel(param1,param2);
      }
      
      protected function logError(param1:String) : void
      {
         DebugLog.instance.error(">> ProfileManagerPanel: ** " + param1 + " **");
      }
      
      protected function _unregisterHandler(param1:PanelEvent) : void
      {
         profileManagerUI.removeEventListener(PanelEvent.UNREGISTER,_unregisterHandler);
         unRegisterPanel(this,PANEL_NAME);
         EventManager.getInstance().dispatchEvent(new ProjectEvent("HIDE_PROFILEMANAGER"));
      }
      
      override public function showMe(param1:Boolean) : *
      {
         super.showMe(param1);
      }
      
      override public function onInitialize() : *
      {
         log("Initialized");
         showMe(true);
      }
      
      protected function comment(param1:String) : void
      {
         DebugLog.instance.comment(param1);
      }
   }
}

