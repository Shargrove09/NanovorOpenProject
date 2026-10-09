package com.arkadium.analytics.enum
{
   public class View
   {
      
      public static const APP_LAUNCH:View = new View("/view/app/launch");
      
      public static const APP_EXIT:View = new View("/view/app/exit");
      
      public static const LOGIN_LANDING:View = new View("/view/login/landing");
      
      public static const HOME_LANDING:View = new View("/view/home/landing");
      
      public static const HOME_BREADCRUMB:View = new View("/view/home/breadcrumb/%NAME%");
      
      public static const HOME_MEGAWIDGET_BATTLE_AUTO:View = new View("/view/home/megawidget/battle/auto");
      
      public static const HOME_MEGAWIDGET_BATTLE_ARRANGE:View = new View("/view/home/megawidget/battle/arrange");
      
      public static const HOME_MEGAWIDGET_PRIVATE_CHAT:View = new View("/view/home/megawidget/private-chat");
      
      public static const HOME_FRIENDS:View = new View("/view/home/friends");
      
      public static const HOME_LAST_BATTLED:View = new View("/view/home/last-battled");
      
      public static const BATTLE_LANDING_ARRANGED:View = new View("/view/battle/landing/arranged");
      
      public static const BATTLE_LANDING_AUTO:View = new View("/view/battle/landing/auto");
      
      public static const BATTLE_SWARM_CHOOSER:View = new View("/view/battle/swarm-chooser");
      
      public static const BATTLE_ATTACK_CHOOSER:View = new View("/view/battle/attack-chooser");
      
      public static const BATTLE_ANIMATION_MODE:View = new View("/view/battle/animation-mode");
      
      public static const BATTLE_GAMEOVER_PLACES:View = new View("/view/battle/gameover/places");
      
      public static const BATTLE_GAMEOVER_BADGES:View = new View("/view/battle/gameover/badges");
      
      public static const PROFILEMANAGER_LANDING:View = new View("/view/profile/landing");
      
      public static const PROFILEMANAGER_AVATARS:View = new View("/view/profile/avatars");
      
      public static const PROFILEMANAGER_BADGES:View = new View("/view/profile/badges");
      
      public static const PROFILEMANAGER_DETAILS:View = new View("/view/profile/details");
      
      public static const PROFILEMANAGER_REWARDS:View = new View("/view/profile/rewards");
      
      public static const PROFILEMANAGER_COUPON_CODE:View = new View("/view/profile/coupon-code");
      
      public static const PROFILEMANAGER_NANOCASH_CARDS:View = new View("/view/profile/nanocash-cards");
      
      public static const COLLECTION_LANDING:View = new View("/view/collection/landing");
      
      public static const COLLECTION_NANOVOR_STATS:View = new View("/view/collection/nanovor/stats");
      
      public static const COLLECTION_NANOVOR_ATTACKS:View = new View("/view/collection/nanovor/attacks");
      
      public static const COLLECTION_NANOVOR_BADGES:View = new View("/view/collection/nanovor/badges");
      
      public static const COLLECTION_EMS:View = new View("/view/collection/ems");
      
      public static const EVOLVE_LANDING:View = new View("/view/evolve/landing");
      
      public static const EVOLVE_TREE:View = new View("/view/evolve/tree");
      
      public static const EVOLVE_GAME:View = new View("/view/evolve/game");
      
      public static const NANOMALL_LANDING:View = new View("/view/nanomall/landing");
      
      public static const NANOMALL_SKU_LIST:View = new View("/view/nanomall/sku-list");
      
      public static const NANOMALL_SKU_PACKS:View = new View("/view/nanomall/sku-packs");
      
      public static const NANOMALL_SKU_PURCHASED:View = new View("/view/nanomall/sku-purchased");
      
      public static const NANOMALL_NEW_ASSET_INSPECTED:View = new View("/view/nanomall/new-asset-inspected");
      
      public static const DEVICE_LANDING:View = new View("/view/device/landing");
      
      public static const DEVICE_UNKNOWN_DETECTED:View = new View("/view/device/unknown-detected");
      
      public static const DEVICE_CONFIRM_ASSOCIATION:View = new View("/view/device/confirm-association");
      
      public static const DEVICE_UPDATING:View = new View("/view/device/updating");
      
      public static const DEVICE_INVENTORY_HOME:View = new View("/view/device/inventory-home");
      
      public static const DEVICE_SWARM_CHOOSER:View = new View("/view/device/swarm-chooser");
      
      public static const DEVICE_SWARM_TRANSFER:View = new View("/view/device/swarm-transfer");
      
      public static const TRADE_LANDING:View = new View("/view/trade/landing");
      
      public static const SENSEI_BATTLE_LANDING:View = new View("/view/solo-battle/landing/ai-player%AI_PLAYER_ID%");
      
      public static const SENSEI_GAMEOVER_WIN:View = new View("/view/solo-battle/gameover/win/ai-player%AI_PLAYER_ID%");
      
      public static const SENSEI_GAMEOVER_LOSE:View = new View("/view/solo-battle/gameover/lose/ai-player%AI_PLAYER_ID%");
      
      public static const SENSEI_SWARM_CHOOSER:View = new View("/view/solo-battle/swarm-chooser");
      
      public static const SENSEI_ATTACK_CHOOSER:View = new View("/view/solo-battle/attack-chooser");
      
      public static const SENSEI_ANIMATION_MODE:View = new View("/view/solo-battle/animation-mode");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function View(param1:String, param2:Function = null)
      {
         super();
         if(_isLocked && param2 != internalEnforcer)
         {
            throw new Error("Cannot instantiate enum type \'View\' at runtime.");
         }
         this._name = param1;
      }
      
      public static function createDynamic(param1:String) : View
      {
         return new View(param1,internalEnforcer);
      }
      
      private static function internalEnforcer() : void
      {
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}

