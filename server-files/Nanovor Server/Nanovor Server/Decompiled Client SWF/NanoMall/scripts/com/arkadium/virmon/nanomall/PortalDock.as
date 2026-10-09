package com.arkadium.virmon.nanomall
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol236")]
   public class PortalDock extends MovieClip
   {
      
      public var mcSpinner:MovieClip;
      
      public var mcLights:MovieClip;
      
      public var mcBG:MovieClip;
      
      public function PortalDock()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function flashLights() : void
      {
         mcLights.gotoAndPlay("flash");
      }
      
      public function altStrobeLights() : void
      {
         mcLights.gotoAndPlay("alt_strobe");
      }
      
      public function cwStrobeLights() : void
      {
         mcLights.gotoAndPlay("cw_strobe");
      }
      
      public function stopLights() : void
      {
         mcLights.gotoAndStop(1);
      }
   }
}

