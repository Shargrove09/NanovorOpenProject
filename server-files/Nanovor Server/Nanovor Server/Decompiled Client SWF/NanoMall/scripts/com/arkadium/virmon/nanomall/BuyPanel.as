package com.arkadium.virmon.nanomall
{
   import caurina.transitions.Tweener;
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.virmon.framework.asset.retriever.IBoosterAssetRetriever;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol297")]
   public class BuyPanel extends MovieClip
   {
      
      private const PORTAL_OUT_Y:int = 755;
      
      public var mcBG:MovieClip;
      
      public var mcPortal:Portal;
      
      public var mcPackSelect:PackSelect;
      
      private const PORTAL_IN_Y:int = 315;
      
      public var mcPortalDock:PortalDock;
      
      public function BuyPanel()
      {
         super();
         mouseEnabled = false;
         mcPortalDock.visible = false;
         mcPortalDock.rotation = -90;
      }
      
      public function cwStrobeLights() : void
      {
         mcPortalDock.cwStrobeLights();
      }
      
      public function openBoosterSelect(param1:Number = 0) : void
      {
         mcPackSelect.openBoosterSelect(param1);
      }
      
      public function disableBoosterSelectItems() : void
      {
         mcPackSelect.disableBoosterSelectItems();
      }
      
      public function showBoosterSelectBackBtn() : void
      {
         mcPackSelect.showBoosterSelectBackBtn();
      }
      
      public function destroy() : void
      {
         mcPackSelect.destroy();
      }
      
      public function closePortal(param1:Number = 0) : void
      {
         mcPortalDock.stopLights();
         mcPortal.close();
         Tweener.addTween(mcPortal,{
            "scaleX":1.08,
            "scaleY":1.08,
            "time":0.5,
            "delay":param1,
            "transition":"easeInQuint",
            "onComplete":onRaisePortal
         });
      }
      
      public function enableBoosterSelectBackBtn() : void
      {
         mcPackSelect.enableBoosterSelectBackBtn();
      }
      
      public function init(param1:IAnalyticsManager, param2:IBoosterAssetRetriever, param3:XML) : void
      {
         mcPackSelect.init(param1,param2,param3);
      }
      
      public function hideBoosterSelectBackBtn() : void
      {
         mcPackSelect.hideBoosterSelectBackBtn();
      }
      
      public function closeBoosterSelect(param1:Number = 0) : void
      {
         mcPackSelect.closeBoosterSelect(param1);
      }
      
      public function openPortal(param1:Number = 0) : void
      {
         mcPortal.scaleX = mcPortal.scaleY = 1.08;
         Tweener.addTween(mcPortal,{
            "y":PORTAL_IN_Y,
            "time":0.5,
            "delay":param1,
            "transition":"easeOutQuint",
            "onComplete":dropPortal
         });
      }
      
      public function enableBoosterSelectItems() : void
      {
         mcPackSelect.enableBoosterSelectItems();
      }
      
      private function onRaisePortal() : void
      {
         Tweener.addTween(mcPortal,{
            "y":PORTAL_OUT_Y,
            "time":0.5,
            "transition":"easeInQuint"
         });
      }
      
      private function onDropPortal() : void
      {
         mcPortal.open();
         mcPortalDock.flashLights();
      }
      
      public function areBoosterItemsExhausted() : Boolean
      {
         return mcPackSelect.areBoosterItemsExhausted();
      }
      
      public function altStrobeLights() : void
      {
         mcPortalDock.altStrobeLights();
      }
      
      public function openPortalDock(param1:Number = 0) : void
      {
         mcPortalDock.visible = true;
         Tweener.addTween(mcPortalDock,{
            "rotation":0,
            "time":0.5,
            "delay":param1,
            "transition":"easeOutBack"
         });
      }
      
      public function replenishBoosterItems() : void
      {
         mcPackSelect.replenishBoosterItems();
      }
      
      public function disableBoosterSelectBackBtn() : void
      {
         mcPackSelect.disableBoosterSelectBackBtn();
      }
      
      public function showBoosterSelectItem(param1:int) : void
      {
         mcPackSelect.showBoosterSelectItem(param1);
      }
      
      private function dropPortal() : void
      {
         Tweener.addTween(mcPortal,{
            "scaleX":1,
            "scaleY":1,
            "time":0.5,
            "transition":"easeOutQuint",
            "onComplete":onDropPortal
         });
      }
      
      public function initBoosterSelect(param1:IBoosterItemData) : void
      {
         mcPackSelect.initBoosterSelect(param1);
      }
      
      public function hideBoosterSelectItem(param1:int) : void
      {
         mcPackSelect.hideBoosterSelectItem(param1);
      }
   }
}

