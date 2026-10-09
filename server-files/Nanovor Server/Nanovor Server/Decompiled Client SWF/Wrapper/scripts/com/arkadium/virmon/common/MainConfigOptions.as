package com.arkadium.virmon.common
{
   public class MainConfigOptions
   {
      
      public static const LAUNCH_WEB_ON_FIRST_SFS:String = "launchWebOnFirstSFS";
      
      public static const FILTER_CANNED_CHAT_MESSAGES:String = "filterCannedChatMessages";
      
      public static const ANALYTICS_ENABLED:String = "analyticsEnabled";
      
      public static const SKIP_REQUIRED_APP_DOWNLOADS:String = "skipRequiredAppDownloads";
      
      public static const SKIP_BACKGROUND_APP_DOWNLOADS:String = "skipBackgroundAppDownloads";
      
      public static const SKIP_BACKGROUND_ASSET_DOWNLOADS:String = "skipBackgroundAssetDownloads";
      
      public function MainConfigOptions()
      {
         super();
         throw new Error("ENUM CLASS -- NO INSTANTIATION NECESSARY.");
      }
   }
}

