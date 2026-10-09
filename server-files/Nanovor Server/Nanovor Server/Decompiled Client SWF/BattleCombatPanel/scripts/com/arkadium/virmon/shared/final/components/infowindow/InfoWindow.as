package com.arkadium.virmon.shared.final.components.infowindow
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class InfoWindow extends MovieClip
   {
      
      public static const FAMILY_MAGNAMOD:String = "Magnamod";
      
      public static const FAMILY_VELOCITRON:String = "Velocitron";
      
      public static const FAMILY_HEXITE:String = "Hexite";
      
      private static const FORMATION_GROUP_TITLE:Point = new Point(33,0);
      
      private static const FORMATION_GROUP_STATS:Point = new Point(0,14);
      
      private static const FORMATION_VERTICAL_TITLE:Point = new Point(0,0);
      
      private static const FORMATION_VERTICAL_STATS:Point = new Point(0,-120);
      
      private static const GENERAL_TWEEN_SECONDS:Number = 0.5;
      
      public var mcTitle:InfoWindowTitle;
      
      public var mcStats:InfoWindowStats;
      
      public function InfoWindow()
      {
         super();
         mouseEnabled = false;
      }
      
      public function set nanovorName(param1:String) : void
      {
         mcTitle.nanovorName = param1;
      }
      
      public function setHealth(param1:int, param2:int) : void
      {
         mcStats.setHealth(param1,param2);
      }
      
      public function set sv(param1:int) : void
      {
         mcTitle.sv = param1;
      }
      
      public function set faction(param1:String) : void
      {
         mcTitle.faction = param1;
      }
      
      public function set baseStrength(param1:int) : void
      {
         mcStats.baseStrength = param1;
      }
      
      public function set baseSpeed(param1:int) : void
      {
         mcStats.baseSpeed = param1;
      }
      
      public function set nanovorNickName(param1:String) : void
      {
         mcTitle.nanovorNickName = param1;
      }
      
      public function get baseArmor() : int
      {
         return mcStats.baseArmor;
      }
      
      public function set strength(param1:int) : void
      {
         if(mcStats.baseStrength == 0)
         {
            mcStats.baseStrength = param1;
         }
         mcStats.strength = param1;
      }
      
      public function clearDisplay() : void
      {
         sv = 0;
         nanovorName = "";
         nanovorNickName = "";
         faction = "";
         baseStrength = 0;
         baseArmor = 0;
         baseSpeed = 0;
         strength = 0;
         armor = 0;
         speed = 0;
         setHealth(0,0);
      }
      
      public function get baseSpeed() : int
      {
         return mcStats.baseSpeed;
      }
      
      public function hideAllButHealth(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(mcTitle,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.mcIconStrength,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.mcIconArmor,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.mcIconSpeed,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.tfStrength,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.tfArmor,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.tfSpeed,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            mcStats.mcIconStrength.mouseChildren = false;
            mcStats.mcIconArmor.mouseChildren = false;
            mcStats.mcIconSpeed.mouseChildren = false;
         }
         else
         {
            Tweener.addTween(mcTitle,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.mcIconStrength,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.mcIconArmor,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.mcIconSpeed,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.tfStrength,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.tfArmor,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(mcStats.tfSpeed,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            mcStats.mcIconStrength.mouseChildren = true;
            mcStats.mcIconArmor.mouseChildren = true;
            mcStats.mcIconSpeed.mouseChildren = true;
         }
      }
      
      public function get title() : InfoWindowTitle
      {
         return mcTitle;
      }
      
      public function get baseStrength() : int
      {
         return mcStats.baseStrength;
      }
      
      public function destroy() : void
      {
         mcStats.destroy();
      }
      
      public function set baseArmor(param1:int) : void
      {
         mcStats.baseArmor = param1;
      }
      
      public function set speed(param1:int) : void
      {
         if(mcStats.baseSpeed == 0)
         {
            mcStats.baseSpeed = param1;
         }
         mcStats.speed = param1;
      }
      
      public function set armor(param1:int) : void
      {
         if(mcStats.baseArmor == 0)
         {
            mcStats.baseArmor = param1;
         }
         mcStats.armor = param1;
      }
      
      public function get stats() : InfoWindowStats
      {
         return mcStats;
      }
   }
}

