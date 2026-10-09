package com.arkadium.virmon.shared.elements.viewer
{
   import caurina.transitions.*;
   import com.arkadium.virmon.common.CustomEvent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.Dictionary;
   
   public class TopTabsPane extends MovieClip
   {
      
      public static const PEDIGREE:String = "pedigree";
      
      public static const ATTACKS:String = "attacks";
      
      public static const EVENT_TAB_CHANGED:String = "tabChanged";
      
      private var _btnPedigree:SimpleButton;
      
      private var _tabsOutY:Number = 40;
      
      private var _szCurrentTab:String = null;
      
      public var AttacksTab:MovieClip;
      
      private var _btnAttacks:SimpleButton;
      
      private const _TOGGLE_MODE:Boolean = true;
      
      public var PedigreeTab:MovieClip;
      
      private var _mcCurrentTab:MovieClip = null;
      
      private var _bActivated:Boolean = false;
      
      private var _tabsInY:Number = 0;
      
      private var _dictTabs:Dictionary = new Dictionary();
      
      public function TopTabsPane()
      {
         super();
         _dictTabs[PEDIGREE] = PedigreeTab;
         _dictTabs[ATTACKS] = AttacksTab;
         PedigreeTab.y = _tabsOutY;
         AttacksTab.y = _tabsOutY;
         _btnPedigree = PedigreeTab.btnHit;
         _btnAttacks = AttacksTab.btnHit;
      }
      
      private function onBtnAttacksClick(param1:MouseEvent) : void
      {
         if(_TOGGLE_MODE && _szCurrentTab == ATTACKS)
         {
            switchTabSelectedTo(null);
         }
         else
         {
            switchTabSelectedTo(ATTACKS);
         }
         dispatchEvent(new CustomEvent(EVENT_TAB_CHANGED,{"tabName":_szCurrentTab}));
      }
      
      private function onBtnPedigreeClick(param1:MouseEvent) : void
      {
         if(_TOGGLE_MODE && _szCurrentTab == PEDIGREE)
         {
            switchTabSelectedTo(null);
         }
         else
         {
            switchTabSelectedTo(PEDIGREE);
         }
         dispatchEvent(new CustomEvent(EVENT_TAB_CHANGED,{"tabName":_szCurrentTab}));
      }
      
      public function Activate(param1:String = "pedigree", param2:Number = 0.2, param3:Boolean = true) : void
      {
         if(param1 != _szCurrentTab)
         {
            switchTabSelectedTo(param1);
         }
         if(_bActivated)
         {
            return;
         }
         _bActivated = true;
         Tweener.removeTweens(PedigreeTab,y);
         Tweener.removeTweens(AttacksTab,y);
         Tweener.addTween(PedigreeTab,{
            "y":_tabsInY,
            "time":0.3,
            "delay":param2,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(AttacksTab,{
            "y":_tabsInY,
            "time":0.3,
            "delay":param2,
            "transition":"easeOutQuad"
         });
         if(param3)
         {
            EnableClicks();
         }
      }
      
      private function switchTabSelectedTo(param1:String) : void
      {
         if(_mcCurrentTab !== null)
         {
            _mcCurrentTab.gotoAndStop("off");
            _mcCurrentTab.btnHit.enabled = true;
         }
         _szCurrentTab = param1;
         _mcCurrentTab = _dictTabs[param1];
         if(_mcCurrentTab !== null)
         {
            _mcCurrentTab.gotoAndStop("selected");
            if(!_TOGGLE_MODE)
            {
               _mcCurrentTab.btnHit.enabled = false;
            }
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log(">> CVV: TopTabsPane: " + param1);
      }
      
      public function DisableClicks() : void
      {
         _btnPedigree.removeEventListener(MouseEvent.CLICK,onBtnPedigreeClick);
         _btnAttacks.removeEventListener(MouseEvent.CLICK,onBtnAttacksClick);
      }
      
      public function Deactivate() : void
      {
         if(!_bActivated)
         {
            return;
         }
         _bActivated = false;
         Tweener.removeTweens(PedigreeTab,y);
         Tweener.removeTweens(AttacksTab,y);
         Tweener.addTween(PedigreeTab,{
            "y":_tabsOutY,
            "time":0.3,
            "transition":"easeOutQuad"
         });
         Tweener.addTween(AttacksTab,{
            "y":_tabsOutY,
            "time":0.3,
            "transition":"easeOutQuad"
         });
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error("** CVV: TopTabsPane: " + param1);
      }
      
      public function get Activated() : Boolean
      {
         return _bActivated;
      }
      
      public function EnableClicks() : void
      {
         if(_TOGGLE_MODE || _szCurrentTab != PEDIGREE)
         {
            _btnPedigree.addEventListener(MouseEvent.CLICK,onBtnPedigreeClick,false,0,true);
         }
         if(_TOGGLE_MODE || _szCurrentTab != ATTACKS)
         {
            _btnAttacks.addEventListener(MouseEvent.CLICK,onBtnAttacksClick,false,0,true);
         }
      }
   }
}

