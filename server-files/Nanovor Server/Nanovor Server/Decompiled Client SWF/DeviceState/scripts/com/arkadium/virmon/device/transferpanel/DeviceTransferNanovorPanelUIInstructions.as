package com.arkadium.virmon.device.transferpanel
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.device.ui.DeviceUIInstructionsBase;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class DeviceTransferNanovorPanelUIInstructions extends DeviceUIInstructionsBase
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      private static const SPINNER_POSITION:Point = new Point(512,384);
      
      private static const CONSOLE_POSITION:Number = 820;
      
      private static const CONSOLE_WIDTH:Number = 200;
      
      private var _greenTextFormat:TextFormat;
      
      private var _whiteTextFormat:TextFormat;
      
      public function DeviceTransferNanovorPanelUIInstructions(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super(param1,param2);
         _whiteTextFormat = new TextFormat();
         _whiteTextFormat.font = _deviceUIController.getConsole().defaultTextFormat.font;
         _whiteTextFormat.size = _deviceUIController.getConsole().defaultTextFormat.size;
         _whiteTextFormat.bold = _deviceUIController.getConsole().defaultTextFormat.bold;
         _whiteTextFormat.color = 16777215;
      }
      
      private function spinnerOpened() : void
      {
         _deviceUIController.getSpinner().setCenterObject(_deviceUIController.getNanoscope());
         _deviceUIController.getSpinner().toggleTimer(true);
         _deviceUIController.openBGBlock();
         _deviceUIController.moveSpinner(SPINNER_POSITION,setUIFinished);
      }
      
      override public function unsetUI() : void
      {
         log("unsetUI()");
         Tweener.addTween(_deviceUIController.getTitleTransferingNanoscope(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":unsetUIFinished
         });
         _deviceUIController.getConsole().visible = false;
         _deviceUIController.getConsole().x = 720;
         _deviceUIController.getConsole().width = 300;
         _deviceUIController.getSpinner().toggleTimer(false);
         _deviceUIController.closeBGBlock();
         _deviceUIController.getCenterStripe().hide();
      }
      
      override public function setUI() : void
      {
         log("setUI()");
         _deviceUIController.getSpinner().setTimer(0,1);
         Tweener.addTween(_deviceUIController.getTitleTransferingNanoscope(),{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         _deviceUIController.getConsole().x = CONSOLE_POSITION;
         _deviceUIController.getConsole().width = CONSOLE_WIDTH;
         _deviceUIController.getConsole().text = "";
         _deviceUIController.getConsole().visible = true;
         _deviceUIController.getCenterStripe().setText("","");
         _deviceUIController.getCenterStripe().setText("","");
         _deviceUIController.openSpinner(spinnerOpened);
      }
      
      public function consoleAddText(param1:String) : void
      {
         _deviceUIController.getConsole().setTextFormat(_deviceUIController.getConsole().defaultTextFormat);
         if(0 == param1.length)
         {
            return;
         }
         var _loc2_:int = int(_deviceUIController.getConsole().text.length);
         _deviceUIController.getConsole().appendText(param1);
         _deviceUIController.getConsole().setTextFormat(_whiteTextFormat,_loc2_,_loc2_ + param1.length);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceTransferNanovorPanelUIInstructions>>\t" + param1);
      }
   }
}

