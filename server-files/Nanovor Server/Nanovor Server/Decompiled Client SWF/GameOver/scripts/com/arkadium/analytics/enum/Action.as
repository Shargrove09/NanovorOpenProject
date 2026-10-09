package com.arkadium.analytics.enum
{
   public class Action
   {
      
      public static const LOGIN_SHARD_LIST_REQUESTED:Action = new Action("/action/login/server-list/requested");
      
      public static const LOGIN_SHARD_LIST_LOADED:Action = new Action("/action/login/server-list/loaded");
      
      public static const LOGIN_SHARD_LIST_LOAD_ERROR:Action = new Action("/action/login/server-list/load-error");
      
      public static const LOGIN_SHARD_LIST_EMPTY:Action = new Action("/action/login/server-list/empty");
      
      public static const LOGIN_SUBMIT:Action = new Action("/action/login/submit");
      
      public static const LOGIN_SRB_RESPONSE_CONNECT:Action = new Action("/action/login/srb-response/connect");
      
      public static const LOGIN_SRB_RESPONSE_BAD_USER_PASS:Action = new Action("/action/login/srb-response/failed/wrong-user-pass");
      
      public static const LOGIN_SRB_RESPONSE_EMPTY_USER_PASS:Action = new Action("/action/login/srb-response/failed/empty-user-pass");
      
      public static const LOGIN_SRB_RESPONSE_ACCT_DISABLED:Action = new Action("/action/login/srb-response/failed/account-disabled");
      
      public static const LOGIN_SRB_RESPONSE_ACCT_NOT_ACTIVATED:Action = new Action("/action/login/srb-response/failed/account-not-activated");
      
      public static const LOGIN_SRB_RESPONSE_FAILED:Action = new Action("/action/login/srb-response/failed");
      
      public static const LOGIN_SRB_RESPONSE_REFRESH:Action = new Action("/action/login/srb-response/refresh");
      
      public static const LOGIN_SRB_RESPONSE_MAINTENANCE:Action = new Action("/action/login/srb-response/maintenance");
      
      public static const LOGIN_SRB_LOAD_ERROR:Action = new Action("/action/login/srb-load-error");
      
      public static const LOGIN_MANIFEST_PARSE_STARTED:Action = new Action("/action/login/manifest-parse-compare/started");
      
      public static const LOGIN_MANIFEST_PARSE_COMPLETE:Action = new Action("/action/login/manifest-parse-compare/completed");
      
      public static const LOGIN_MINSET_DOWNLOAD_STARTED:Action = new Action("/action/login/minset-download/started");
      
      public static const LOGIN_MINSET_DOWNLOAD_COMPLETE:Action = new Action("/action/login/minset-download/complete");
      
      public static const LOGIN_MINSET_DOWNLOAD_FAILED:Action = new Action("/action/login/minset-download/failed");
      
      public static const LOGIN_MASTER_DATA_LOADED:Action = new Action("/action/login/master-data-loaded");
      
      public static const LOGIN_BANK_ASSET_DATA_REQUESTED:Action = new Action("/action/login/bank-asset-data-requested");
      
      public static const LOGIN_BANK_ASSET_DATA_LOADED:Action = new Action("/action/login/bank-asset-data-loaded");
      
      public static const LOGIN_GAMESERVER_LOGIN_OK:Action = new Action("/action/login/gameserver/login-successful");
      
      public static const LOGIN_GAMESERVER_LOGIN_FAILED:Action = new Action("/action/login/gameserver/login-failed");
      
      public static const LOGIN_COMPLETE:Action = new Action("/action/login/complete");
      
      public static const COLLECTION_ASSET_BUFF_SUBMIT:Action = new Action("/action/collection/nanovor-buffing/submit");
      
      public static const COLLECTION_ASSET_BUFF_SUCCESS:Action = new Action("/action/collection/nanovor-buffing/success");
      
      public static const COLLECTION_ASSET_BUFF_FAIL:Action = new Action("/action/collection/nanovor-buffing/fail");
      
      public static const COLLECTION_ASSET_BUFF_LOAD_ERROR:Action = new Action("/action/collection/nanovor-buffing/load-error");
      
      public static const HOME_FRIENDS_ADD_FRIEND:Action = new Action("/action/home/friends/add-friend");
      
      public static const HOME_FRIENDS_REMOVE_FRIEND:Action = new Action("/action/home/friends/remove-friend");
      
      public static const HOME_FRIENDS_ADD_FRIEND_FAILED:Action = new Action("/action/home/friends/add-friend-failed/%REASON%");
      
      public static const HOME_FRIENDS_REQUEST_RECEIVED:Action = new Action("/action/home/friends/add-request-received");
      
      public static const HOME_FRIENDS_ADD_RESPOND_NO:Action = new Action("/action/home/friends/add-friend-respond/no");
      
      public static const HOME_FRIENDS_ADD_RESPOND_YES:Action = new Action("/action/home/friends/add-friend-respond/yes");
      
      public static const HOME_FRIENDS_ADD_RESPOND_TIMEOUT:Action = new Action("/action/home/friends/add-friend-respond/timeout");
      
      public static const HOME_FRIENDS_FRIEND_ADDED:Action = new Action("/action/home/friends/friend-added");
      
      public static const HOME_FRIENDS_FRIEND_REMOVED:Action = new Action("/action/home/friends/friend-removed");
      
      public static const EVOLVE_GAME_SUCCESS:Action = new Action("/action/evolve/game/success");
      
      public static const EVOLVE_GAME_FAIL:Action = new Action("/action/evolve/game/fail");
      
      public static const EVOLVE_GAME_ERROR:Action = new Action("/action/evolve/game/error");
      
      public static const EVOLVE_GAME_LOAD_ERROR:Action = new Action("/action/evolve/game/load-error");
      
      public static const HOME_SWITCH_LOBBY:Action = new Action("/action/home/switch-lobby/%NAME%");
      
      public static const HOME_CONVERT_CHAT_TO_BATTLE:Action = new Action("/action/home/convert-chat-to-battle");
      
      public static const PROFILE_AVATAR_CHANGE:Action = new Action("/action/profile/avatar-change");
      
      public static const NANOMALL_SKU_PURCHASE_SELECT:Action = new Action("/action/nanomall/sku-purchase/select");
      
      public static const NANOMALL_SKU_PURCHASE_CANCEL:Action = new Action("/action/nanomall/sku-purchase/cancel");
      
      public static const NANOMALL_SKU_PURCHASE_SUBMIT:Action = new Action("/action/nanomall/sku-purchase/submit");
      
      public static const NANOMALL_SKU_PURCHASE_SUCCESS:Action = new Action("/action/nanomall/sku-purchase/success");
      
      public static const NANOMALL_SKU_PURCHASE_ERROR:Action = new Action("/action/nanomall/sku-purchase/error");
      
      public static const BATTLE_SWARMCHOOSER_CLOCK_ZERO:Action = new Action("/action/battle/swarm-chooser/countdown-zero");
      
      public static const BATTLE_SWARMCHOOSER_NO_NANOVOR:Action = new Action("/action/battle/swarm-chooser/countdown-zero/no-nanovor");
      
      public static const BATTLE_ATTACKCHOOSER_CLOCK_ZERO:Action = new Action("/action/battle/attack-chooser/countdown-zero");
      
      public static const TRADE_CANCELLED:Action = new Action("/action/trade/cancelled");
      
      public static const TRADE_SUCCESSFUL:Action = new Action("/action/trade/successful");
      
      public static const TRADE_ERROR:Action = new Action("/action/trade/error");
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _name:String;
      
      public function Action(param1:String, param2:Function = null)
      {
         super();
         if(_isLocked && param2 != internalEnforcer)
         {
            throw new Error("Cannot instantiate enum type \'Action\' at runtime.");
         }
         _name = param1;
      }
      
      public static function createDynamic(param1:String) : Action
      {
         return new Action(param1,internalEnforcer);
      }
      
      private static function internalEnforcer() : void
      {
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}

