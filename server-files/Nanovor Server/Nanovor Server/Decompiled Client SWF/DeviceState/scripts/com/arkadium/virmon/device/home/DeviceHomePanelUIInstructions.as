package com.arkadium.virmon.device.home
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.device.footer.DeviceFooter;
   import com.arkadium.virmon.device.ui.DeviceUIInstructionsBase;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class DeviceHomePanelUIInstructions extends DeviceUIInstructionsBase
   {
      
      private static const SHOW_DEBUG_LOGS:Boolean = true;
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      private static const SPINNER_POSITION:Point = new Point(712,384);
      
      private static const FOOTER_POSITION_SHOW:Number = 700;
      
      private static const FOOTER_POSITION_HIDE:Number = 850;
      
      private var _footer:DeviceFooter;
      
      public function DeviceHomePanelUIInstructions(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super(param1,param2);
         createFooter();
      }
      
      override public function destroy() : void
      {
         _footer.destroy();
         _deviceUIController = null;
         _setUIConsumer = null;
      }
      
      public function getFooterButton() : DisplayObject
      {
         return _footer.getButton();
      }
      
      override public function setUI() : void
      {
         log("setUI()");
         if(_footer != null)
         {
            toggleFooter(true);
         }
         if(_deviceUIController != null)
         {
            _deviceUIController.getActionPicker().open();
            Tweener.addTween(_deviceUIController.getSwarmChooserInstructions(),{
               "_autoAlpha":1,
               "delay":1,
               "base":TWEEN_BASE
            });
            Tweener.addTween(_deviceUIController.getTitleHome(),{
               "_autoAlpha":1,
               "base":TWEEN_BASE
            });
            _deviceUIController.getJoltsAwards().open();
         }
      }
      
      private function createFooter() : void
      {
         _footer = new DeviceFooter();
         _footer.setText("DISCONNECT");
         _footer.y = FOOTER_POSITION_HIDE;
         _deviceUIController.addUILayer(_footer);
      }
      
      private function log(param1:String) : void
      {
         if(SHOW_DEBUG_LOGS)
         {
            DebugLog.instance.log("<<DeviceHomePanelUIInstructions>>\t" + param1);
         }
      }
      
      override public function unsetUI() : void
      {
         toggleFooter(false);
         _deviceUIController.getActionPicker().close();
         Tweener.addTween(_deviceUIController.getSwarmChooserInstructions(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _deviceUIController.getSpinner().toggleMainButtonWire(false);
         Tweener.addTween(_deviceUIController.getJoltsAwards(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_deviceUIController.getTitleHome(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE,
            "onComplete":unsetUIFinished
         });
      }
      
      public function toggleFooter(param1:Boolean) : void
      {
         if(param1)
         {
            _footer.startPulse();
            Tweener.addTween(_footer,{
               "y":FOOTER_POSITION_SHOW,
               "base":TWEEN_BASE
            });
         }
         else
         {
            Tweener.addTween(_footer,{
               "y":FOOTER_POSITION_HIDE,
               "base":TWEEN_BASE,
               "onComplete":_footer.stopPulse
            });
         }
      }
   }
}

