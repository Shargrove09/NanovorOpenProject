package com.arkadium.virmon.shared.breadcrumb
{
   import com.arkadium.virmon.state.StateType;
   
   public class BreadcrumbType
   {
      
      public static const INTRO_EPISODE:BreadcrumbType = new BreadcrumbType(1,"IntroEpisode.swf",[StateType.NONE]);
      
      public static const FIRST_SOLO_BATTLE:BreadcrumbType = new BreadcrumbType(2,"FirstSoloBattle.swf",[StateType.SENSEI_BATTLE]);
      
      public static const SECOND_SOLO_BATTLE:BreadcrumbType = new BreadcrumbType(4,"SecondSoloBattle.swf",[StateType.SENSEI_BATTLE]);
      
      public static const FIRST_MULTIPLAYER_BATTLE:BreadcrumbType = new BreadcrumbType(8,"FirstMultiBattle.swf",[StateType.BATTLE]);
      
      public static const EVOLVE:BreadcrumbType = new BreadcrumbType(16,"Evolve.swf",[StateType.EVOGAME]);
      
      public static const REWARDS:BreadcrumbType = new BreadcrumbType(32,"Rewards.swf",[StateType.NONE]);
      
      public static const NANOLOG:BreadcrumbType = new BreadcrumbType(64,"Nanolog.swf",[StateType.NANOLOG]);
      
      public static const COLLECT_AND_TRADE:BreadcrumbType = new BreadcrumbType(128,"CollectAndTrade.swf",[StateType.TRADEGAME,StateType.NANOMALL]);
      
      public static const NEWS:BreadcrumbType = new BreadcrumbType(256,"NewsCrumb.swf",[StateType.NONE]);
      
      public static const breadcrumbTypes:Array = [NEWS];
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _url:String;
      
      private var _bitKey:int;
      
      private var _stateTypeTriggers:Array;
      
      public function BreadcrumbType(param1:int, param2:String, param3:Array)
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instsantiate enum type \'BreadcrumbType\' at runtime.");
         }
         this._bitKey = param1;
         this._url = param2;
         this._stateTypeTriggers = param3 == null ? [] : param3;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get bitKey() : int
      {
         return this._bitKey;
      }
      
      public function get name() : int
      {
         return this._bitKey;
      }
      
      public function get stateTypeTriggers() : Array
      {
         return this._stateTypeTriggers;
      }
   }
}

