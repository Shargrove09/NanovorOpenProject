package com.arkadium.virmon.framework
{
   import flash.events.Event;
   
   public class FrameWorkEvent extends Event
   {
      
      public static const CM_CONNECTED_TO_9S:String = "connected_to_9s";
      
      public static const CM_IOERROR:String = "9sError";
      
      public static const CM_VIRMON_MASTER_RECEIVED:String = "virmon_master_received";
      
      public static const CM_EM_MASTER_RECEIVED:String = "em_master_received";
      
      public static const CM_BADGE_MASTER_RECEIVED:String = "badge_master_received";
      
      public static const CM_ASSET_LIST_RECEIVED:String = "asset_list_received";
      
      public static const CM_ASSET_STAT_RECEIVED:String = "asset_stat_received";
      
      public static const CM_SWARM_LIST_RECEIVED:String = "swarm_list_received";
      
      public static const CM_EVO_LIST_RECEIVED:String = "evo_list_received";
      
      public static const CM_EVOLVE_RESULT:String = "evolve_result";
      
      public static const CM_EVOLVE_SUCCESS:String = "evolve_success";
      
      public static const DM_DATA_UPDATED:String = "data_updated";
      
      public static const BM_ACCOUNT_BADGES_UPDATED:String = "account_badges_updated";
      
      public static const MDM_OPEN_BROWSER_HOOK:String = "mdmBrowserOpenHook";
      
      public static const USER_AVATAR_UPDATED:String = "userAvatarUpdated";
      
      public static const USER_STATS_UPDATED:String = "userStatsUpdated";
      
      public static const NAV_QUICKTIPS_CLICK:String = "quickTipsClicked";
      
      public static const NAV_QUICKTIPS_CHANGE:String = "quickTipsChange";
      
      public static const GAME_INVITE_ACCEPTED:String = "gameInviteAccepted";
      
      private var _oData:*;
      
      public function FrameWorkEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:* = null)
      {
         super(param1,param2,param3);
         this._oData = param4;
      }
      
      public function get data() : *
      {
         return this._oData;
      }
      
      public function set data(param1:*) : *
      {
         this._oData = param1;
      }
      
      override public function toString() : String
      {
         return formatToString("FrameWorkEvent","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new FrameWorkEvent(type,bubbles,cancelable);
      }
   }
}

