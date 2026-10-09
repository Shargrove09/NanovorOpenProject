package com.arkadium.virmon.help.swarmchooser.nanovorselect
{
   import com.arkadium.virmon.shared.final.components.treeviewmenu.TreeViewMenu;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4")]
   public class HelpSwarmChooserNanovorSelectBG extends MovieClip
   {
      
      private static const BLOCKER_WIDTH:int = 73;
      
      private static const BLOCKER_HEIGHT:int = 98;
      
      private static const COLLECTION_SLOTS:int = 12;
      
      public var mcCutOut10:MovieClip;
      
      public var mcCutOut12:MovieClip;
      
      private var _treeViewMenu:TreeViewMenu;
      
      public var mcCutOut11:MovieClip;
      
      public var mcCutOut1:MovieClip;
      
      public var mcCutOut2:MovieClip;
      
      public var mcCutOut3:MovieClip;
      
      public var mcCutOut4:MovieClip;
      
      public var mcCutOut5:MovieClip;
      
      public var mcCutOut6:MovieClip;
      
      public var mcCutOut7:MovieClip;
      
      public var mcCutOut8:MovieClip;
      
      public var mcCutOut9:MovieClip;
      
      private var _collectionTiles:Array;
      
      public function HelpSwarmChooserNanovorSelectBG()
      {
         super();
      }
      
      public function setCutOuts(param1:Array) : void
      {
         _collectionTiles = param1;
         var _loc2_:* = 1;
         while(_loc2_ <= _collectionTiles.length)
         {
            this["mcCutOut" + _loc2_].visible = false;
            if(_loc2_ == COLLECTION_SLOTS)
            {
               break;
            }
            _loc2_++;
         }
      }
   }
}

