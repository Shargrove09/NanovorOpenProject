package com.arkadium.virmon.nanomall
{
   import com.arkadium.virmon.framework.asset.retriever.IBoosterAssetRetriever;
   import flash.display.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol268")]
   public class WaveList extends MovieClip
   {
      
      private const VIS_HEIGHT:int = 400;
      
      private var mcItems:MovieClip;
      
      private var aSKUs:Array;
      
      public var mcScrollBar:ScrollBar;
      
      private var curX:int = 0;
      
      private var curY:int = 0;
      
      private const ITEM_SPACING:int = 3;
      
      public function WaveList()
      {
         super();
      }
      
      private function makeListItem(param1:IBoosterItemData) : void
      {
         var _loc2_:WaveListItem = new WaveListItem(param1);
         mcItems.addChild(_loc2_);
         _loc2_.x = curX;
         _loc2_.y = curY;
         curY += _loc2_.height + ITEM_SPACING;
      }
      
      private function checkForScrollable() : void
      {
         mcScrollBar.visible = false;
         if(this.height >= VIS_HEIGHT + 20)
         {
            mcScrollBar.visible = true;
            mcScrollBar.init(mcItems,VIS_HEIGHT);
         }
      }
      
      public function reset() : void
      {
         if(mcScrollBar.visible)
         {
            mcScrollBar.reset();
            mcItems.y = 0;
            mcScrollBar.init(mcItems,VIS_HEIGHT);
         }
      }
      
      public function destroy() : void
      {
         var i:int;
         mcScrollBar.destroy();
         i = 0;
         while(i < mcItems.numChildren)
         {
            try
            {
               (mcItems.getChildAt(i) as WaveListItem).destroy();
            }
            catch(e:*)
            {
            }
            i++;
         }
      }
      
      public function sortList(param1:IBoosterItemData, param2:IBoosterItemData) : Number
      {
         var _loc3_:Number = Number(param1.index);
         var _loc4_:Number = Number(param2.index);
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         var _loc5_:Number = Number(param1.name);
         var _loc6_:Number = Number(param2.name);
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         return 0;
      }
      
      public function init(param1:IBoosterAssetRetriever, param2:XML) : void
      {
         var _loc5_:IBoosterItemData = null;
         var _loc6_:XML = null;
         var _loc7_:int = 0;
         var _loc8_:BoosterItemData = null;
         aSKUs = new Array();
         mcItems = new MovieClip();
         addChild(mcItems);
         var _loc3_:int = int(param2.child("sku").length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = param2.child("sku")[_loc4_];
            _loc7_ = int(_loc6_.@id);
            _loc8_ = new BoosterItemData(_loc7_,_loc6_.child("name")[0],_loc6_.child("price")[0],_loc6_.child("image-url") == null ? 1000000 : Number(_loc6_.child("image-url")[0]),param1.getBoosterFamilyIconURL(_loc7_).url);
            aSKUs.push(_loc8_);
            _loc4_++;
         }
         aSKUs.sortOn(sortList);
         for each(_loc5_ in aSKUs)
         {
            makeListItem(_loc5_);
         }
         checkForScrollable();
      }
   }
}

