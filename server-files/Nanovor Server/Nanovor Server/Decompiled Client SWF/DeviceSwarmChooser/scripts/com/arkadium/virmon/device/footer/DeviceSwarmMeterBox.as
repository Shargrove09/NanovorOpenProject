package com.arkadium.virmon.device.footer
{
   import caurina.transitions.Tweener;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol10")]
   public class DeviceSwarmMeterBox extends MovieClip
   {
      
      public function DeviceSwarmMeterBox()
      {
         super();
         this.alpha = 0;
      }
      
      public function activate() : void
      {
         Tweener.addTween(this,{
            "alpha":1,
            "time":1,
            "transition":"easeOutQuad"
         });
      }
      
      public function deactivate() : void
      {
         Tweener.addTween(this,{
            "alpha":0,
            "time":1,
            "transition":"easeOutQuad"
         });
      }
   }
}

