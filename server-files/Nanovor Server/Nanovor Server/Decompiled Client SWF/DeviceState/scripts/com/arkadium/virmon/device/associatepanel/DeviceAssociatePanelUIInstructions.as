package com.arkadium.virmon.device.associatepanel
{
   import caurina.transitions.Equations;
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.device.ui.DeviceUIInstructionsBase;
   import com.arkadium.virmon.device.ui.IDeviceUIController;
   import com.arkadium.virmon.device.ui.IDeviceUIInstructionsConsumer;
   import com.arkadium.virmon.device.ui.spinner.DeviceSpinner;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconPlus;
   import com.arkadium.virmon.shared.elements.icons.spinner.SpinnerIconX;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import fl.motion.AdjustColor;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   
   public class DeviceAssociatePanelUIInstructions extends DeviceUIInstructionsBase
   {
      
      private static const TWEEN_BASE:Object = {
         "time":0.5,
         "transition":Equations.easeInOutQuad
      };
      
      private static const BUTTON_LOCATION_1:Point = new Point(546,356);
      
      private static const BUTTON_LOCATION_2:Point = new Point(546,412);
      
      private static const SPINNER_POSITION_LEFT:Point = new Point(312,384);
      
      private static const SPINNER_POSITION_CENTER:Point = new Point(512,384);
      
      private static const SPINNER_POSITION:Point = new Point(512,384);
      
      private var _colorMatrixGreen:ColorMatrixFilter;
      
      private var _button2Handler:Function;
      
      private var _colorMatrixRed:ColorMatrixFilter;
      
      private var _mcButtonTitleIgnoreNanoscope:Sprite;
      
      private var _uiLayer:Sprite;
      
      private var _mcButtonTitleEraseData:Sprite;
      
      private var _spinningButton1:SpinningButtonComponent;
      
      private var _spinningButton2:SpinningButtonComponent;
      
      private var _mcButtonTitleAddNanoscope:Sprite;
      
      private var _button1Handler:Function;
      
      private var _mcButtonTitleCancel:Sprite;
      
      private var _colorMatrixRedNanoscope:ColorMatrixFilter;
      
      private var _titleUnknownNanoscopeController:AssociatePanelTitleController;
      
      private var _titleAddNanoscopeController:AssociatePanelTitleController;
      
      public function DeviceAssociatePanelUIInstructions(param1:IDeviceUIController, param2:IDeviceUIInstructionsConsumer)
      {
         super(param1,param2);
         createSpinningButtons();
         createColorFilters();
         initializeTitles();
      }
      
      private function openButtonsAndTitles() : void
      {
         _spinningButton1.color = SpinningButtonComponent.COLOR_BLUE;
         _spinningButton1.icon = new SpinnerIconPlus();
         _spinningButton1.open();
         _spinningButton2.color = SpinningButtonComponent.COLOR_RED;
         _spinningButton2.icon = new SpinnerIconX();
         _spinningButton2.open();
         _deviceUIController.getSpinner().setCenterObject(_deviceUIController.getNanoscope());
         _titleAddNanoscopeController.close();
         _titleUnknownNanoscopeController.open();
         Tweener.removeTweens(_mcButtonTitleAddNanoscope);
         Tweener.removeTweens(_mcButtonTitleIgnoreNanoscope);
         Tweener.removeTweens(_mcButtonTitleCancel);
         Tweener.removeTweens(_mcButtonTitleEraseData);
         Tweener.addTween(_mcButtonTitleAddNanoscope,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleIgnoreNanoscope,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleCancel,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleEraseData,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _deviceUIController.getSpinner().showButtonHolder();
         setUIFinished();
      }
      
      override public function unsetUI() : void
      {
         log("unsetUI()");
         if(null == _uiLayer.parent)
         {
            _uiLayer.parent.removeChild(_uiLayer);
         }
         _uiLayer = null;
         _spinningButton1.close();
         _spinningButton2.close();
         _spinningButton1 = null;
         _spinningButton2 = null;
         _deviceUIController.getNanoscope().applyFilter([_colorMatrixGreen]);
         _deviceUIController.getBGBlock().filters = [_colorMatrixGreen];
         _deviceUIController.getSpinner().setColor(DeviceSpinner.COLOR_GREEN);
         Tweener.removeTweens(_mcButtonTitleAddNanoscope);
         Tweener.removeTweens(_mcButtonTitleIgnoreNanoscope);
         Tweener.removeTweens(_mcButtonTitleCancel);
         Tweener.removeTweens(_mcButtonTitleEraseData);
         Tweener.addTween(_mcButtonTitleAddNanoscope,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleIgnoreNanoscope,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleCancel,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleEraseData,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.removeTweens(_deviceUIController.getTitleWarning());
         Tweener.addTween(_deviceUIController.getTitleWarning(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _deviceUIController.getSpinner().hideButtonHolder();
         _titleUnknownNanoscopeController.close();
         _titleAddNanoscopeController.close(false,unsetUIFinished);
      }
      
      private function createColorFilters() : void
      {
         var _loc1_:AdjustColor = new AdjustColor();
         _loc1_.brightness = -6;
         _loc1_.contrast = 27;
         _loc1_.saturation = 18;
         _loc1_.hue = -99;
         var _loc2_:AdjustColor = new AdjustColor();
         _loc2_.brightness = -60;
         _loc2_.contrast = 0;
         _loc2_.saturation = 100;
         _loc2_.hue = 180;
         _colorMatrixGreen = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
         _colorMatrixRed = new ColorMatrixFilter(_loc2_.CalculateFinalFlatArray());
         var _loc3_:AdjustColor = new AdjustColor();
         _loc3_.brightness = -100;
         _loc3_.contrast = -21;
         _loc3_.saturation = 43;
         _loc3_.hue = 180;
         _colorMatrixRedNanoscope = new ColorMatrixFilter(_loc3_.CalculateFinalFlatArray());
      }
      
      public function getSpinningButton1() : Sprite
      {
         return _spinningButton1 as Sprite;
      }
      
      public function setButton1Handler(param1:Function) : void
      {
         _button1Handler = param1;
      }
      
      private function finishSetUnknownUI() : void
      {
         _spinningButton1.open();
         _spinningButton1.icon = new SpinnerIconPlus();
         _spinningButton2.open();
         _spinningButton2.icon = new SpinnerIconX();
         _deviceUIController.getSpinner().setCenterObject(_deviceUIController.getNanoscope());
         _titleAddNanoscopeController.close();
         _titleUnknownNanoscopeController.open();
         Tweener.removeTweens(_mcButtonTitleAddNanoscope);
         Tweener.removeTweens(_mcButtonTitleIgnoreNanoscope);
         Tweener.removeTweens(_mcButtonTitleCancel);
         Tweener.removeTweens(_mcButtonTitleEraseData);
         Tweener.addTween(_mcButtonTitleAddNanoscope,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleIgnoreNanoscope,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleCancel,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleEraseData,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _deviceUIController.getSpinner().showButtonHolder();
      }
      
      private function onSpinningButton2Click(param1:MouseEvent) : void
      {
         if(null != _button2Handler)
         {
            _button2Handler();
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<DeviceAssociatePanelUIInstructions>>\t" + param1);
      }
      
      public function setConfirmUI() : void
      {
         _spinningButton1.color = SpinningButtonComponent.COLOR_RED;
         _spinningButton1.icon = new SpinnerIconX();
         _spinningButton2.color = SpinningButtonComponent.COLOR_BLUE;
         _spinningButton2.icon = new SpinnerIconPlus();
         _deviceUIController.getNanoscope().applyFilter([_colorMatrixRedNanoscope]);
         _deviceUIController.getBGBlock().filters = [_colorMatrixRed];
         _deviceUIController.getSpinner().setColor(DeviceSpinner.COLOR_RED);
         _titleAddNanoscopeController.open();
         _titleUnknownNanoscopeController.close();
         Tweener.removeTweens(_deviceUIController.getTitleWarning());
         Tweener.addTween(_deviceUIController.getTitleWarning(),{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.removeTweens(_mcButtonTitleAddNanoscope);
         Tweener.removeTweens(_mcButtonTitleIgnoreNanoscope);
         Tweener.removeTweens(_mcButtonTitleCancel);
         Tweener.removeTweens(_mcButtonTitleEraseData);
         Tweener.addTween(_mcButtonTitleAddNanoscope,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleIgnoreNanoscope,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleCancel,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleEraseData,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
      }
      
      private function initializeTitles() : void
      {
         _titleUnknownNanoscopeController = new AssociatePanelTitleController(_deviceUIController.getWireTitleUnknownNanoscope());
         _titleAddNanoscopeController = new AssociatePanelTitleController(_deviceUIController.getWireTitleAddNanoscope());
         _mcButtonTitleAddNanoscope = _deviceUIController.getButtonTitleAddNanoscope();
         _mcButtonTitleIgnoreNanoscope = _deviceUIController.getButtonTitleIgnoreNanoscope();
         _mcButtonTitleCancel = _deviceUIController.getButtonTitleCancel();
         _mcButtonTitleEraseData = _deviceUIController.getButtonTitleEraseData();
      }
      
      public function setUnknownUI() : void
      {
         Tweener.removeTweens(_deviceUIController.getTitleWarning());
         Tweener.addTween(_deviceUIController.getTitleWarning(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _spinningButton1.color = SpinningButtonComponent.COLOR_BLUE;
         _spinningButton2.color = SpinningButtonComponent.COLOR_RED;
         _deviceUIController.getNanoscope().applyFilter([_colorMatrixGreen]);
         _deviceUIController.getBGBlock().filters = [_colorMatrixGreen];
         _deviceUIController.getSpinner().setColor(DeviceSpinner.COLOR_GREEN);
         _deviceUIController.moveSpinner(SPINNER_POSITION_LEFT,finishSetUnknownUI);
      }
      
      public function getSpinningButton2() : Sprite
      {
         return _spinningButton2 as Sprite;
      }
      
      private function spinnerOpened() : void
      {
         _deviceUIController.openBGBlock();
         Tweener.removeTweens(_deviceUIController.getTitleWarning());
         Tweener.addTween(_deviceUIController.getTitleWarning(),{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _spinningButton1.color = SpinningButtonComponent.COLOR_BLUE;
         _spinningButton1.icon = new SpinnerIconPlus();
         _spinningButton1.open();
         _spinningButton2.color = SpinningButtonComponent.COLOR_RED;
         _spinningButton2.icon = new SpinnerIconX();
         _spinningButton2.open();
         _deviceUIController.getSpinner().setCenterObject(_deviceUIController.getNanoscope());
         _deviceUIController.getNanoscope().open();
         _titleAddNanoscopeController.close();
         _titleUnknownNanoscopeController.open();
         Tweener.removeTweens(_mcButtonTitleAddNanoscope);
         Tweener.removeTweens(_mcButtonTitleIgnoreNanoscope);
         Tweener.removeTweens(_mcButtonTitleCancel);
         Tweener.removeTweens(_mcButtonTitleEraseData);
         Tweener.addTween(_mcButtonTitleAddNanoscope,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleIgnoreNanoscope,{
            "_autoAlpha":1,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleCancel,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         Tweener.addTween(_mcButtonTitleEraseData,{
            "_autoAlpha":0,
            "base":TWEEN_BASE
         });
         _deviceUIController.getSpinner().showButtonHolder();
         setUIFinished();
      }
      
      public function createSpinningButtons() : void
      {
         _uiLayer = new Sprite();
         _spinningButton1 = new SpinningButtonComponent();
         _spinningButton1.x = BUTTON_LOCATION_1.x;
         _spinningButton1.y = BUTTON_LOCATION_1.y;
         _spinningButton1.addEventListener(MouseEvent.CLICK,onSpinningButton1Click,false,0,true);
         _spinningButton2 = new SpinningButtonComponent();
         _spinningButton2.x = BUTTON_LOCATION_2.x;
         _spinningButton2.y = BUTTON_LOCATION_2.y;
         _spinningButton2.addEventListener(MouseEvent.CLICK,onSpinningButton2Click,false,0,true);
         _spinningButton1.color = SpinningButtonComponent.COLOR_BLUE;
         _spinningButton2.color = SpinningButtonComponent.COLOR_RED;
         _uiLayer.addChild(_spinningButton1);
         _uiLayer.addChild(_spinningButton2);
         _deviceUIController.addUILayer(_uiLayer);
      }
      
      public function setButton2Handler(param1:Function) : void
      {
         _button2Handler = param1;
      }
      
      private function onSpinningButton1Click(param1:MouseEvent) : void
      {
         if(null != _button1Handler)
         {
            _button1Handler();
         }
      }
      
      override public function setUI() : void
      {
         log("setUI()");
         _deviceUIController.getSpinner().x = SPINNER_POSITION_LEFT.x;
         _deviceUIController.getSpinner().y = SPINNER_POSITION_LEFT.y;
         _deviceUIController.getNanoscope().applyFilter([_colorMatrixGreen]);
         _deviceUIController.getBGBlock().filters = [_colorMatrixGreen];
         _deviceUIController.getSpinner().setColor(DeviceSpinner.COLOR_GREEN);
         _deviceUIController.openSpinner(spinnerOpened);
      }
   }
}

