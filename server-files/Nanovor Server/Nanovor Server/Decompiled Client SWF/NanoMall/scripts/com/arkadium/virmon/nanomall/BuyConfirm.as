package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol224")]
   public class BuyConfirm extends MovieClip
   {
      
      public var mcBuyCancelBtn:MovieClip;
      
      public var txPrice:TextField;
      
      public var mcBuyNowBtn:MovieClip;
      
      public function BuyConfirm()
      {
         super();
         addFrameScript(11,frame12);
         mcBuyNowBtn.useHandCursor = true;
         mcBuyNowBtn.buttonMode = true;
         mcBuyNowBtn.mouseChildren = false;
         mcBuyNowBtn.addEventListener(MouseEvent.CLICK,onBuyNowClick,false,0,true);
         mcBuyCancelBtn.useHandCursor = true;
         mcBuyCancelBtn.buttonMode = true;
         mcBuyCancelBtn.mouseChildren = false;
         mcBuyCancelBtn.addEventListener(MouseEvent.CLICK,onBuyCancelClick,false,0,true);
      }
      
      public function updatePrice(param1:String) : void
      {
         txPrice.text = param1;
      }
      
      public function destroy() : void
      {
         mcBuyNowBtn.removeEventListener(MouseEvent.CLICK,onBuyNowClick);
         mcBuyCancelBtn.removeEventListener(MouseEvent.CLICK,onBuyCancelClick);
      }
      
      private function onBuyCancelClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("BUY_CANCEL"));
      }
      
      private function onBuyNowClick(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("BUY_CONFIRM"));
      }
      
      internal function frame12() : *
      {
         stop();
      }
   }
}

