package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import com.arkadium.virmon.common.StatsDisplayInfo;
   import com.arkadium.virmon.shared.elements.Icon;
   import com.arkadium.virmon.shared.elements.icons.stats.*;
   import flash.display.MovieClip;
   import flash.events.*;
   
   public class TileScrollerSortTab extends MovieClip
   {
      
      private static const SORT_ICON_X:int = 6;
      
      private static const SORT_ICON_Y:int = 15;
      
      private static const SORT_ICONS:Array = [Icon.STAT_SWARMVALUE,Icon.STAT_SPEED,Icon.STAT_ARMOR,Icon.STAT_STRENGTH,Icon.STAT_HEALTH];
      
      private static const STATS:Array = [StatsDisplayInfo.SWARMVALUE,StatsDisplayInfo.SPEED,StatsDisplayInfo.ARMOR,StatsDisplayInfo.STRENGTH,StatsDisplayInfo.HEALTH];
      
      private var icons:Array;
      
      private var curSort:int = 0;
      
      public function TileScrollerSortTab()
      {
         super();
         buttonMode = true;
         useHandCursor = true;
         mouseEnabled = true;
         mouseChildren = false;
         addEventListener(MouseEvent.CLICK,onClick,false,0,true);
         loadStatIcons();
      }
      
      private function loadStatIcons() : void
      {
         var _loc1_:* = undefined;
         icons = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < SORT_ICONS.length)
         {
            switch(SORT_ICONS[_loc2_])
            {
               case Icon.STAT_SWARMVALUE:
                  _loc1_ = new StatSwarmValue();
                  break;
               case Icon.STAT_SPEED:
                  _loc1_ = new StatSpeed();
                  break;
               case Icon.STAT_ARMOR:
                  _loc1_ = new StatArmor();
                  break;
               case Icon.STAT_STRENGTH:
                  _loc1_ = new StatStrength();
                  break;
               case Icon.STAT_HEALTH:
                  _loc1_ = new StatHealth();
            }
            addChild(_loc1_);
            _loc1_.x = SORT_ICON_X;
            _loc1_.y = SORT_ICON_Y;
            _loc1_.visible = false;
            icons.push(_loc1_);
            _loc2_++;
         }
         icons[curSort].visible = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         icons[curSort].visible = false;
         ++curSort;
         if(curSort == STATS.length)
         {
            curSort = 0;
         }
         icons[curSort].visible = true;
         var _loc2_:Object = new Object();
         _loc2_.sort = STATS[curSort];
         dispatchEvent(new TreeViewMenuEvent(TreeViewMenuEvent.SORTTAB_CLICK,_loc2_,true));
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.CLICK,onClick);
      }
   }
}

