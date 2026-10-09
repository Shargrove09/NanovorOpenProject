package com.arkadium.virmon.shared.elements.nanobank
{
   import com.arkadium.virmon.common.EventManager;
   import com.arkadium.virmon.common.UserProfile;
   import com.arkadium.virmon.shared.data.Managers;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class NanoBank extends MovieClip
   {
      
      public var mcNanoCashLogo:MovieClip;
      
      public var mcBuyBtn:BuyBtn;
      
      public var mcBalanceLabel:MovieClip;
      
      public var txBalance:TextField;
      
      private var userProfile:UserProfile;
      
      public function NanoBank()
      {
         super();
         mcBuyBtn.addEventListener(BuyBtn.EVENT_CLICK,onBuyBtnClick,false,0,true);
         EventManager.getInstance().addEventListener("NANOCASH_BALANCE_UPDATED",updateBalance,false,0,true);
      }
      
      public function updateBalance(param1:Event = null) : void
      {
         txBalance.text = String(UserProfile.getInstance().nanocash);
         mcBalanceLabel.x = txBalance.x + txBalance.textWidth + 15;
      }
      
      private function onBuyBtnClick(param1:Event) : void
      {
         Managers.buyNanocashUIManager.showBuyNanocash();
      }
      
      public function destroy() : void
      {
         mcBuyBtn.removeEventListener(BuyBtn.EVENT_CLICK,onBuyBtnClick);
         EventManager.getInstance().removeEventListener("NANOCASH_BALANCE_UPDATED",updateBalance);
         mcBuyBtn.destroy();
      }
   }
}

