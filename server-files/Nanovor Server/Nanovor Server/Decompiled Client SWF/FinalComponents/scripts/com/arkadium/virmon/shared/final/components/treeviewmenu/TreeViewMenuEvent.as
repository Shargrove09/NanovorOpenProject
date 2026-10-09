package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import flash.events.Event;
   
   public class TreeViewMenuEvent extends Event
   {
      
      public static const TREETILE_ROLLOVER:String = "treeTileRollOver";
      
      public static const TREETILE_ROLLOUT:String = "treeTileRollOut";
      
      public static const TREETILE_CLICK:String = "treeTileClick";
      
      public static const COLLECTIONTILE_ROLLOVER:String = "collectionTileRollOver";
      
      public static const COLLECTIONTILE_ROLLOUT:String = "collectionTileRollOut";
      
      public static const COLLECTIONTILE_CLICK:String = "collectionTileClick";
      
      public static const COLLECTION_OPENED:String = "collectionOpened";
      
      public static const SORTTAB_CLICK:String = "sortTabClicked";
      
      public var data:Object;
      
      public function TreeViewMenuEvent(param1:String, param2:Object, param3:Boolean = false)
      {
         super(param1,param3);
         this.data = param2;
      }
   }
}

