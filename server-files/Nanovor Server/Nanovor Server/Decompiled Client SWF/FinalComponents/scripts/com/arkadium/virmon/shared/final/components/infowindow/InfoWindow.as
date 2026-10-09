package com.arkadium.virmon.shared.final.components.infowindow
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol408")]
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
         this.mcTitle.nanovorName = param1;
      }
      
      public function setHealth(param1:int, param2:int) : void
      {
         this.mcStats.setHealth(param1,param2);
      }
      
      public function set sv(param1:int) : void
      {
         this.mcTitle.sv = param1;
      }
      
      public function set faction(param1:String) : void
      {
         this.mcTitle.faction = param1;
      }
      
      public function set baseStrength(param1:int) : void
      {
         this.mcStats.baseStrength = param1;
      }
      
      public function set baseSpeed(param1:int) : void
      {
         this.mcStats.baseSpeed = param1;
      }
      
      public function set nanovorNickName(param1:String) : void
      {
         this.mcTitle.nanovorNickName = param1;
      }
      
      public function get baseArmor() : int
      {
         return this.mcStats.baseArmor;
      }
      
      public function set strength(param1:int) : void
      {
         if(this.mcStats.baseStrength == 0)
         {
            this.mcStats.baseStrength = param1;
         }
         this.mcStats.strength = param1;
      }
      
      public function clearDisplay() : void
      {
         this.sv = 0;
         this.nanovorName = "";
         this.nanovorNickName = "";
         this.faction = "";
         this.baseStrength = 0;
         this.baseArmor = 0;
         this.baseSpeed = 0;
         this.strength = 0;
         this.armor = 0;
         this.speed = 0;
         this.setHealth(0,0);
      }
      
      public function get baseSpeed() : int
      {
         return this.mcStats.baseSpeed;
      }
      
      public function hideAllButHealth(param1:Boolean) : void
      {
         if(param1)
         {
            Tweener.addTween(this.mcTitle,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.mcIconStrength,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.mcIconArmor,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.mcIconSpeed,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.tfStrength,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.tfArmor,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.tfSpeed,{
               "_autoAlpha":0,
               "time":GENERAL_TWEEN_SECONDS
            });
            this.mcStats.mcIconStrength.mouseChildren = false;
            this.mcStats.mcIconArmor.mouseChildren = false;
            this.mcStats.mcIconSpeed.mouseChildren = false;
         }
         else
         {
            Tweener.addTween(this.mcTitle,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.mcIconStrength,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.mcIconArmor,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.mcIconSpeed,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.tfStrength,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.tfArmor,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            Tweener.addTween(this.mcStats.tfSpeed,{
               "_autoAlpha":1,
               "time":GENERAL_TWEEN_SECONDS
            });
            this.mcStats.mcIconStrength.mouseChildren = true;
            this.mcStats.mcIconArmor.mouseChildren = true;
            this.mcStats.mcIconSpeed.mouseChildren = true;
         }
      }
      
      public function get title() : InfoWindowTitle
      {
         return this.mcTitle;
      }
      
      public function get baseStrength() : int
      {
         return this.mcStats.baseStrength;
      }
      
      public function destroy() : void
      {
         this.mcStats.destroy();
      }
      
      public function set baseArmor(param1:int) : void
      {
         this.mcStats.baseArmor = param1;
      }
      
      public function set speed(param1:int) : void
      {
         if(this.mcStats.baseSpeed == 0)
         {
            this.mcStats.baseSpeed = param1;
         }
         this.mcStats.speed = param1;
      }
      
      public function set armor(param1:int) : void
      {
         if(this.mcStats.baseArmor == 0)
         {
            this.mcStats.baseArmor = param1;
         }
         this.mcStats.armor = param1;
      }
      
      public function get stats() : InfoWindowStats
      {
         return this.mcStats;
      }
   }
}

