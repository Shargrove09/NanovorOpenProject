package com.arkadium.virmon.nanomall
{
   [Embed(source="/_assets/assets.swf", symbol="symbol311")]
   public class ShopBtn extends CollectionPanelUIBtn
   {
      
      public function ShopBtn()
      {
         super();
         addFrameScript(3,frame4,8,frame9);
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
   }
}

