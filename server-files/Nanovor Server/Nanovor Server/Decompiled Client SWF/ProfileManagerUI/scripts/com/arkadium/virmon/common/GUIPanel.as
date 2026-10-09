package com.arkadium.virmon.common
{
   import flash.display.MovieClip;
   
   public class GUIPanel extends MovieClip
   {
      
      protected var _rGUIManager:GUIManager;
      
      private var _sPanelName:String;
      
      public function GUIPanel()
      {
         super();
         _sPanelName = null;
      }
      
      public function registerPanel(param1:GUIPanel, param2:String, param3:GUIManager) : *
      {
         _rGUIManager = param3;
         _sPanelName = param2;
         _rGUIManager.registerPanel(param1,param2);
      }
      
      public function hidePanel() : *
      {
      }
      
      public function showPanel() : *
      {
      }
      
      public function unRegisterPanel(param1:GUIPanel, param2:String) : *
      {
         _rGUIManager.unRegisterPanel(param1,param2);
      }
      
      public function getPanelName() : String
      {
         return _sPanelName;
      }
      
      public function showMe(param1:Boolean) : *
      {
         if(param1)
         {
            _rGUIManager.showPanel(_sPanelName);
         }
         else
         {
            _rGUIManager.hidePanel(_sPanelName);
         }
      }
      
      public function onInitialize() : *
      {
      }
   }
}

