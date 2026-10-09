package com.arkadium.virmon.device.footer
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol60")]
   public class DeviceFooter extends Sprite
   {
      
      private static const DEVICE_SWARM_METER_X:int = 110;
      
      private static const DEVICE_SWARM_METER_Y:int = -5;
      
      public var mcPulse:MovieClip;
      
      private var _deviceSwarmMeter:DeviceSwarmMeter;
      
      public var btnRedButton:SimpleButton;
      
      public var tfBigText:TextField;
      
      public function DeviceFooter()
      {
         super();
         mcPulse.stop();
         mcPulse.mouseEnabled = false;
         mcPulse.mouseChildren = false;
         tfBigText.mouseEnabled = false;
      }
      
      public function removeNanovor() : void
      {
         _deviceSwarmMeter.removeItem();
      }
      
      public function addNanovor() : void
      {
         _deviceSwarmMeter.addItem();
      }
      
      public function getButton() : DisplayObject
      {
         return btnRedButton;
      }
      
      private function createDeviceSwarmMeter() : void
      {
         if(_deviceSwarmMeter != null)
         {
            return;
         }
         _deviceSwarmMeter = new DeviceSwarmMeter();
         _deviceSwarmMeter.x = DEVICE_SWARM_METER_X;
         _deviceSwarmMeter.y = DEVICE_SWARM_METER_Y;
         addChild(_deviceSwarmMeter);
      }
      
      public function setText(param1:String) : void
      {
         tfBigText.text = param1;
      }
      
      public function init() : void
      {
         mcPulse.alpha = 0;
         mcPulse.stop();
         createDeviceSwarmMeter();
      }
      
      public function stopPulse() : void
      {
         Tweener.addTween(mcPulse,{
            "alpha":0,
            "time":0.5,
            "transition":Equations.easeOutInQuad,
            "onComplete":mcPulse.stop
         });
      }
      
      public function destroy() : void
      {
         if(null != _deviceSwarmMeter)
         {
            removeChild(_deviceSwarmMeter);
            _deviceSwarmMeter.destroy();
         }
         mcPulse.stop();
      }
      
      public function resetDeviceSwarmMeter() : void
      {
         _deviceSwarmMeter.reset();
      }
      
      public function startPulse() : void
      {
         Tweener.addTween(mcPulse,{
            "alpha":1,
            "time":0.5,
            "transition":Equations.easeOutInQuad
         });
         mcPulse.gotoAndPlay(1);
      }
   }
}

