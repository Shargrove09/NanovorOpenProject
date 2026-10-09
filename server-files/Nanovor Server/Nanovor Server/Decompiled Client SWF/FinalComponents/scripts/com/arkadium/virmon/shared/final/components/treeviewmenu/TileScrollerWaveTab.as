package com.arkadium.virmon.shared.final.components.treeviewmenu
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol460")]
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
            this.mcTab.x = this.mcTab.width;
            this.mcTab.scaleX = -1;
            this.mcWaveTitle.x = 51.1 - this.mcWaveTitle.width;
            this.mcWaveW.x += 4;
            this.tfWave.x += 4;
         }
      }
      
      public function updateWave(param1:int) : void
      {
         this.tfWave.text = String(param1);
      }
   }
}

