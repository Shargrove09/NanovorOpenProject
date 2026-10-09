package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TileScrollerWaveTab extends MovieClip
   {
      
      public var mcWaveW:Sprite;
      
      public var mcWaveTitle:Sprite;
      
      public var tfWave:TextField;
      
      public var mcTab:Sprite;
      
      public function TileScrollerWaveTab(param1:Boolean = false)
      {
         super();
         if(param1)
         {
            mcTab.x = mcTab.width;
            mcTab.scaleX = -1;
            mcWaveTitle.x = 51.1 - mcWaveTitle.width;
            mcWaveW.x += 4;
            tfWave.x += 4;
         }
      }
      
      public function updateWave(param1:int) : void
      {
         tfWave.text = String(param1);
      }
   }
}

