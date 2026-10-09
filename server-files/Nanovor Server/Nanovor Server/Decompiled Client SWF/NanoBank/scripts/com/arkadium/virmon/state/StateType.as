package com.arkadium.virmon.state
{
   import com.arkadium.virmon.shared.data.Const;
   
   public class StateType
   {
      
      public static const MODE_HOME:String = "modeHome";
      
      public static const MODE_BATTLE:String = "modeBattle";
      
      public static const MODE_HIDDEN:String = "modeHidden";
      
      public static const MODE_MINIMIZED:String = "modeMinimized";
      
      public static const LOGIN:StateType = new StateType("Login","LoginPanel.swf");
      
      public static const HOME:StateType = new StateType("Home","HomeState.swf",Const.QUICKTIP_DASHBOARD);
      
      public static const BATTLE:StateType = new StateType("Battle","BattleState.swf",Const.QUICKTIP_ATTACK_SWAP);
      
      public static const COLLECTION:StateType = new StateType("Collection","CollectionViewer.swf",Const.QUICKTIP_COLLECTION);
      
      public static const EVOTREE:StateType = new StateType("EvoTree","EvoTreeState.swf");
      
      public static const FRIENDS:StateType = new StateType("Friends","",Const.QUICKTIP_DASHBOARD);
      
      public static const EVOGAME:StateType = new StateType("EvoGame","EvoGameState.swf",Const.QUICKTIP_EVOLUTION_GAME);
      
      public static const NANOMALL:StateType = new StateType("Nanomall","NanoMall.swf",Const.QUICKTIP_NANOMALL);
      
      public static const NANOLOG:StateType = new StateType("Nanolog","");
      
      public static const DEVICEMANAGER:StateType = new StateType("DeviceManager","DeviceState.swf");
      
      public static const TRADEGAME:StateType = new StateType("Tradegame","Trade.swf",Const.QUICKTIP_TRADE);
      
      public static const PROFILE:StateType = new StateType("Profile","ProfileManagerUI.swf",Const.QUICKTIP_PROFILE);
      
      public static const SENSEI_BATTLE:StateType = new StateType("SenseiBattle","SenseiBattleState.swf");
      
      public static const SENSEI_SELECT:StateType = new StateType("SenseiSelect","SenseiSelectState.swf");
      
      public static const BLANK:StateType = new StateType("Blank","BlankState.swf",Const.QUICKTIP_PROFILE);
      
      public static const NONE:StateType = new StateType("NONE","");
      
      public static const NEWUSER:StateType = new StateType("NewUser","NewUserState.swf");
      
      private static const stateTypes:Array = [LOGIN,HOME,BATTLE,COLLECTION,EVOTREE,FRIENDS,EVOGAME,NANOMALL,DEVICEMANAGER,TRADEGAME,PROFILE,SENSEI_BATTLE,SENSEI_SELECT,BLANK,NONE,NEWUSER];
      
      private static var _isLocked:Boolean = false;
      
      _isLocked = true;
      
      private var _quickTipsURL:String;
      
      private var _url:String;
      
      private var _name:String;
      
      private var _transition:String;
      
      public function StateType(param1:String, param2:String, param3:String = null, param4:String = "GenericTransition.swf")
      {
         super();
         if(_isLocked)
         {
            throw new Error("Cannot instsantiate enum type \'StateType\'.");
         }
         this._name = param1;
         this._url = param2;
         this._quickTipsURL = param3;
         this._transition = param4;
      }
      
      public static function getStateTypeByName(param1:String) : StateType
      {
         var _loc2_:* = undefined;
         for(_loc2_ in stateTypes)
         {
            if(stateTypes[_loc2_].name == param1)
            {
               return stateTypes[_loc2_];
            }
         }
         return null;
      }
      
      public function get quickTipsURL() : String
      {
         return this._quickTipsURL;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function toString() : String
      {
         return "[StateType: " + this._name + "] url: " + this._url + ", transition: " + this._transition;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get transition() : String
      {
         return this._transition;
      }
   }
}

