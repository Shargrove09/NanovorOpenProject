package com.arkadium.virmon.gameengine.buytokens
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.shared.mdm.IMDMManager;
   import com.arkadium.virmon.wrapper.BuyTokens;
   import com.arkadium.virmon.wrapper.IBuyNanocashUIManager;
   import flash.events.IEventDispatcher;
   
   public class GameEngineBuyTokens implements IBuyNanocashUIManager
   {
      
      private var _buyTokensUI:BuyTokens;
      
      public function GameEngineBuyTokens(param1:IEventDispatcher, param2:BuyTokens, param3:IMDMManager, param4:*, param5:*, param6:IUserProfile)
      {
         super();
         _buyTokensUI = param2;
         _buyTokensUI.init(param1,param3,param4,param5,param6);
         param2.hide();
      }
      
      public function showBuyNanocash() : void
      {
         _buyTokensUI.show();
      }
      
      public function hideBuyNanocash() : void
      {
         _buyTokensUI.hide();
      }
   }
}

