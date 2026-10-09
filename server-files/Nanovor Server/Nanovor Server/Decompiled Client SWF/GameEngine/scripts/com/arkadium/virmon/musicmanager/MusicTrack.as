package com.arkadium.virmon.musicmanager
{
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   
   public class MusicTrack
   {
      
      public static var FightTheme01Track:String = "FightTheme01Track";
      
      public static var FightTheme02Track:String = "FightTheme02Track";
      
      public static var FightTheme03Track:String = "FightTheme03Track";
      
      public static var SecondaryMenuTrack:String = "SecondaryMenuTrack";
      
      public static var TertiaryMenuTrack:String = "TertiaryMenuTrack";
      
      public static var TrainingTrack:String = "TrainingTrack";
      
      public function MusicTrack()
      {
         super();
      }
      
      private static function log(param1:String) : void
      {
         DebugLog.instance.log(">> MusicTrack: " + param1);
      }
      
      public static function GetComponentMusicTrack(param1:StateType) : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         log("getting music track for : " + param1);
         switch(param1)
         {
            case StateType.LOGIN:
               return SecondaryMenuTrack;
            case StateType.HOME:
               return SecondaryMenuTrack;
            case StateType.NANOMALL:
               return TertiaryMenuTrack;
            case StateType.EVOGAME:
               return TrainingTrack;
            case StateType.EVOTREE:
               return TertiaryMenuTrack;
            case StateType.COLLECTION:
               return TertiaryMenuTrack;
            case StateType.PROFILE:
               return TertiaryMenuTrack;
            case StateType.TRADEGAME:
               return TertiaryMenuTrack;
            case StateType.SENSEI_BATTLE:
            case StateType.SENSEI_SELECT:
            case StateType.BATTLE:
               _loc2_ = Math.floor(Math.random() * 3);
               return _loc2_ < 1 ? FightTheme02Track : (_loc2_ < 2 ? FightTheme03Track : FightTheme01Track);
            default:
               logError("Attempted to get file name for unknown state: " + param1);
               return SecondaryMenuTrack;
         }
      }
      
      private static function logError(param1:String) : void
      {
         DebugLog.instance.error(">> MusicTrack: ** " + param1 + " **");
      }
   }
}

