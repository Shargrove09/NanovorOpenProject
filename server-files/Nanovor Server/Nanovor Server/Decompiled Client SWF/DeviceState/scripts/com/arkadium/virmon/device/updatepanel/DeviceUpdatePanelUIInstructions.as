package com.arkadium.virmon.device.updatepanel
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.device.ui.DeviceUIInstructionsBase;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class DeviceUpdatePanelUIInstructions extends DeviceUIInstructionsBase
   {
      
      private static const DEBUG_SHOW_LOGS:Boolean = true;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      private static const SPINNER_POSITION_CENTER:Point = new Point(512,384);
      
      private var _whiteTextFormat:TextFormat;
      
      private var _consoleTextLines:Array;
      
      public function DeviceUpdatePanelUIInstructions(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super(param1,param2);
         _consoleTextLines = new Array();
         _whiteTextFormat = new TextFormat();
         _whiteTextFormat.font = _deviceUIController.getConsole().defaultTextFormat.font;
         _whiteTextFormat.size = _deviceUIController.getConsole().defaultTextFormat.size;
         _whiteTextFormat.bold = _deviceUIController.getConsole().defaultTextFormat.bold;
         _whiteTextFormat.color = 16777215;
      }
      
      private function showTransmission() : void
      {
         _deviceUIController.getTransferAnimation().play();
         Tweener.addTween(_deviceUIController.getTransferAnimation(),{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         _deviceUIController.getUpdateChevrons().play();
         Tweener.addTween(_deviceUIController.getUpdateChevrons(),{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
      
      private function spinnerOpened() : void
      {
         log("spinnerOpened()");
         _deviceUIController.getSpinner().setCenterObject(_deviceUIController.getNanoscope());
         _deviceUIController.getNanoscope().open();
         if(null != _deviceUIController.getTitleUpdatingNanoscope())
         {
            Tweener.addTween(_deviceUIController.getTitleUpdatingNanoscope(),{
               "alpha":1,
               "base":TWEEN_BASE
            });
         }
         _deviceUIController.getConsole().text = "";
         _deviceUIController.getConsole().visible = true;
         _deviceUIController.moveSpinner(SPINNER_POSITION_CENTER);
         _deviceUIController.openBGBlock();
         _deviceUIController.getSpinner().toggleTimer(true);
         showTransmission();
         setUIFinished();
      }
      
      public function replaceLastStatusTextLine(param1:String) : void
      {
         consoleReplaceLastLineOfText(param1);
      }
      
      private function hideTransmission() : void
      {
         Tweener.addTween(_deviceUIController.getTransferAnimation(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":_deviceUIController.getTransferAnimation().stop
         });
         Tweener.addTween(_deviceUIController.getUpdateChevrons(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":_deviceUIController.getUpdateChevrons().stop
         });
      }
      
      private function consoleReplaceLastLineOfText(param1:String) : void
      {
         _consoleTextLines.pop();
         consoleAddText(param1);
      }
      
      override public function unsetUI() : void
      {
         log("unsetUI()");
         Tweener.addTween(_deviceUIController.getTitleUpdatingNanoscope(),{
            "alpha":0,
            "base":TWEEN_BASE
         });
         _deviceUIController.getConsole().visible = false;
         _deviceUIController.getSpinner().toggleTimer(false);
         _deviceUIController.closeBGBlock();
         Tweener.removeTweens(_deviceUIController.getTitleUpdatingNanoscope(),"_autoAlpha");
         Tweener.addTween(_deviceUIController.getTitleUpdatingNanoscope(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":continueUnsetUI
         });
         hideTransmission();
      }
      
      private function log(param1:String) : void
      {
         if(DEBUG_SHOW_LOGS)
         {
            DebugLog.instance.log("<<DeviceUpdatePanelUIInstructions>>\t" + param1);
         }
      }
      
      public function updateProgress(param1:Number) : void
      {
         if(null == _deviceUIController)
         {
            return;
         }
         if(null == _deviceUIController.getSpinner())
         {
            return;
         }
         _deviceUIController.getSpinner().setTimer(param1,1);
      }
      
      private function consoleAddText(param1:String) : void
      {
         _consoleTextLines.push(param1);
         if(null == _deviceUIController)
         {
            return;
         }
         if(null == _deviceUIController.getConsole())
         {
            return;
         }
         _deviceUIController.getConsole().setTextFormat(_deviceUIController.getConsole().defaultTextFormat);
         _deviceUIController.getConsole().text = _consoleTextLines.join("\n");
         _deviceUIController.getConsole().setTextFormat(_whiteTextFormat,_deviceUIController.getConsole().text.indexOf(param1),_deviceUIController.getConsole().text.length);
      }
      
      private function continueUnsetUI() : void
      {
         unsetUIFinished();
      }
      
      public function addStatusTextLine(param1:String) : void
      {
         consoleAddText(param1);
      }
      
      override public function setUI() : void
      {
         _deviceUIController.openSpinner(spinnerOpened);
      }
   }
}

