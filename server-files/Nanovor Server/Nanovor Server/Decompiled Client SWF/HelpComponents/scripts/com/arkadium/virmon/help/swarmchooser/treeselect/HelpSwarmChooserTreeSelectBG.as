package com.arkadium.virmon.help.swarmchooser.treeselect
{
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol57")]
   public class HelpSwarmChooserTreeSelectBG extends MovieClip
   {
      
      private static const BLOCKER_WIDTH:int = 73;
      
      private static const BLOCKER_HEIGHT:int = 98;
      
      private var _treeViewMenu:TreeViewMenu;
      
      private var _treeTiles:Array;
      
      public function HelpSwarmChooserTreeSelectBG()
      {
         super();
      }
      
      public function setCutOuts(param1:TreeViewMenu) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Shape = null;
         _treeViewMenu = param1;
         _treeTiles = _treeViewMenu.getTreeTiles();
         var _loc2_:* = 0;
         while(_loc2_ < _treeTiles.length)
         {
            _loc3_ = _treeViewMenu.x + _treeTiles[_loc2_].x;
            _loc4_ = _treeViewMenu.y + _treeTiles[_loc2_].y;
            if(!_treeTiles[_loc2_].getHasMembers())
            {
               _loc5_ = getCutOutBlocker();
               addChild(_loc5_);
               _loc5_.x = _loc3_;
               _loc5_.y = _loc4_;
            }
            _loc2_++;
         }
      }
      
      private function getCutOutBlocker() : Shape
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawRect(0,0,BLOCKER_WIDTH,BLOCKER_HEIGHT);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
   }
}

