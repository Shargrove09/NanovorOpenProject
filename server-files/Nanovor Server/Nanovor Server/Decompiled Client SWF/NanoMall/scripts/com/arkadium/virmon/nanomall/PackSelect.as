package com.arkadium.virmon.nanomall
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.View;
   import com.arkadium.virmon.framework.asset.retriever.IBoosterAssetRetriever;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol296")]
   public class PackSelect extends MovieClip
   {
      
      private var _boosterAssetRetriever:IBoosterAssetRetriever;
      
      public var mcBG:MovieClip;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private const BOOSTER_IN_X:int = 3;
      
      public var mcWaveList:WaveList;
      
      private const BOOSTER_OUT_X:int = -395;
      
      public var mcWaveListMask:MovieClip;
      
      public var mcBoosterSelect:BoosterSelect;
      
      public function PackSelect()
      {
         super();
         mcWaveList.mask = mcWaveListMask;
      }
      
      public function openBoosterSelect(param1:Number) : void
      {
         mcWaveList.reset();
         Tweener.addTween(mcBoosterSelect,{
            "x":BOOSTER_IN_X,
            "time":0.5,
            "delay":param1,
            "transition":"easeOutQuint"
         });
         _analyticsManager.trackView(View.NANOMALL_SKU_PACKS);
      }
      
      public function disableBoosterSelectItems() : void
      {
         mcBoosterSelect.disableItems();
      }
      
      public function hideBoosterSelectItem(param1:int) : void
      {
         mcBoosterSelect.hideItem(param1);
      }
      
      public function showBoosterSelectBackBtn() : void
      {
         mcBoosterSelect.showBackBtn();
      }
      
      public function hideBoosterSelectBackBtn() : void
      {
         mcBoosterSelect.hideBackBtn();
      }
      
      public function enableBoosterSelectBackBtn() : void
      {
         mcBoosterSelect.enableBackBtn();
      }
      
      public function init(param1:IAnalyticsManager, param2:IBoosterAssetRetriever, param3:XML) : void
      {
         _analyticsManager = param1;
         _boosterAssetRetriever = param2;
         mcWaveList.init(_boosterAssetRetriever,param3);
         _analyticsManager.trackView(View.NANOMALL_SKU_LIST);
      }
      
      public function closeBoosterSelect(param1:Number) : void
      {
         Tweener.addTween(mcBoosterSelect,{
            "x":BOOSTER_OUT_X,
            "time":0.5,
            "delay":param1,
            "transition":"easeOutQuint"
         });
         _analyticsManager.trackView(View.NANOMALL_SKU_LIST);
      }
      
      public function replenishBoosterItems() : void
      {
         mcBoosterSelect.replenishItems();
      }
      
      public function enableBoosterSelectItems() : void
      {
         mcBoosterSelect.enableItems();
      }
      
      public function showBoosterSelectItem(param1:int) : void
      {
         mcBoosterSelect.showItem(param1);
      }
      
      public function areBoosterItemsExhausted() : Boolean
      {
         return mcBoosterSelect.areItemsExhausted();
      }
      
      public function disableBoosterSelectBackBtn() : void
      {
         mcBoosterSelect.disbleBackBtn();
      }
      
      public function destroy() : void
      {
         mcBoosterSelect.destroy();
         mcWaveList.destroy();
      }
      
      public function initBoosterSelect(param1:IBoosterItemData) : void
      {
         mcBoosterSelect.initBoosterSelect(param1,_boosterAssetRetriever);
      }
   }
}

