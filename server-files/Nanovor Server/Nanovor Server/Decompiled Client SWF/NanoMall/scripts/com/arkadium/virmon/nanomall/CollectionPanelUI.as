package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol313")]
   public class CollectionPanelUI extends MovieClip
   {
      
      public var mcShopBtn:ShopBtn;
      
      public var mcViewCollectionBtn:ViewCollectionBtn;
      
      public function CollectionPanelUI()
      {
         super();
         mcShopBtn.addEventListener("BTN_CLICK",onShopBtnClick);
         mcViewCollectionBtn.addEventListener("BTN_CLICK",onViewCollectionBtnClick);
      }
      
      public function destroy() : void
      {
         mcShopBtn.removeEventListener("BTN_CLICK",onShopBtnClick);
         mcViewCollectionBtn.removeEventListener("BTN_CLICK",onViewCollectionBtnClick);
         mcShopBtn.clearListeners();
         mcViewCollectionBtn.clearListeners();
      }
      
      public function enable() : void
      {
         mcShopBtn.enable();
         mcViewCollectionBtn.enable();
      }
      
      public function disable() : void
      {
         mcShopBtn.disable();
         mcViewCollectionBtn.disable();
      }
      
      private function onShopBtnClick(param1:Event) : void
      {
         dispatchEvent(new Event("KEEP_SHOPPING",true));
      }
      
      private function onViewCollectionBtnClick(param1:Event) : void
      {
         dispatchEvent(new Event("VIEW_COLLECTION",true));
      }
   }
}

