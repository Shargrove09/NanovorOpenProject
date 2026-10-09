package com.arkadium.virmon.shared.widgets.header
{
   import caurina.transitions.Tweener;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.state.StateType;
   import com.arkadium.virmon.wrapper.statepackagestatusupdater.IStatePackageReadyHandler;
   import com.arkadium.virmon.wrapper.statepackagestatusupdater.IStatePackageStatusUpdater;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class HeaderButtonRenderer implements IHeaderButtonRenderer, IStatePackageReadyHandler
   {
      
      private static const DASHBOARD_LINKS:Array = [{
         "buttonText":"HOME",
         "stateType":StateType.HOME
      },{
         "buttonText":"COLLECTION",
         "stateType":StateType.COLLECTION
      },{
         "buttonText":"EVOLVE",
         "stateType":StateType.EVOTREE
      },{
         "buttonText":"NANOLOG",
         "stateType":StateType.NANOLOG
      },{
         "buttonText":"PROFILE",
         "stateType":StateType.PROFILE
      },{
         "buttonText":"GET NANOVOR",
         "stateType":StateType.NANOMALL,
         "frameLabel":MainButton.ORANGE_LABEL
      },{
         "buttonText":"NANOSCOPE",
         "stateType":StateType.DEVICEMANAGER
      }];
      
      private static const MAIN_BUTTONS_TOTAL_WIDTH:Number = 600;
      
      private static const YELLOW_BAR_CHASER_OFFSET:Number = -28;
      
      private static const YELLOW_BAR_CHASER_TWEEN_SECONDS:Number = 1;
      
      private static const YELLOW_BAR_CHASER_START_X:Number = 240;
      
      private static const YELLOW_BAR_CHASER_TWEEN_EASING:String = "easeInOutQuad";
      
      private var _buttonByStateType:Dictionary;
      
      private var _handlers:Dictionary;
      
      private var _currentButton:MainButton;
      
      private var _statePackageUpdater:IStatePackageStatusUpdater;
      
      private var _yellowBarChaser:MovieClip;
      
      private var _wantMoreClickHereButton:MovieClip;
      
      private var _mainButtonContainer:MovieClip;
      
      public function HeaderButtonRenderer(param1:IStatePackageStatusUpdater, param2:MovieClip, param3:MovieClip, param4:MovieClip)
      {
         super();
         _mainButtonContainer = param2;
         _yellowBarChaser = param3;
         _wantMoreClickHereButton = param4;
         _buttonByStateType = new Dictionary();
         _wantMoreClickHereButton.buttonMode = true;
         _wantMoreClickHereButton.addEventListener(MouseEvent.CLICK,handleWantMoreClickHereClick);
         _wantMoreClickHereButton.gotoAndStop("Disabled");
         _wantMoreClickHereButton.mouseEnabled = false;
         _handlers = new Dictionary();
         _handlers[IHeaderButtonClickHandler] = new Dictionary(true);
         _statePackageUpdater = param1;
      }
      
      public function showButtons(param1:Number = 1) : void
      {
         var _loc2_:Rectangle = null;
         _mainButtonContainer.mouseChildren = true;
         Tweener.addTween(_mainButtonContainer,{
            "_autoAlpha":1,
            "time":param1
         });
         if(_currentButton != null)
         {
            _loc2_ = _currentButton.getBounds(_yellowBarChaser.parent);
            Tweener.addTween(_yellowBarChaser,{
               "x":_loc2_.x + _loc2_.width + YELLOW_BAR_CHASER_OFFSET,
               "time":YELLOW_BAR_CHASER_TWEEN_SECONDS,
               "transition":YELLOW_BAR_CHASER_TWEEN_EASING
            });
         }
         else
         {
            Tweener.addTween(_yellowBarChaser,{
               "x":YELLOW_BAR_CHASER_START_X,
               "time":YELLOW_BAR_CHASER_TWEEN_SECONDS,
               "transition":YELLOW_BAR_CHASER_TWEEN_EASING
            });
         }
         _wantMoreClickHereButton.visible = true;
      }
      
      private function getMenuItemByStateType(param1:StateType) : MainButton
      {
         return _buttonByStateType[param1];
      }
      
      public function enableDeviceButton() : void
      {
         getMenuItemByStateType(StateType.DEVICEMANAGER).show();
      }
      
      private function onMainButtonRollOver(param1:MouseEvent) : void
      {
         if(false == _mainButtonContainer.mouseChildren)
         {
            return;
         }
         var _loc2_:Rectangle = (param1.target as MovieClip).getBounds(_yellowBarChaser.parent);
         Tweener.addTween(_yellowBarChaser,{
            "x":_loc2_.x + _loc2_.width + YELLOW_BAR_CHASER_OFFSET,
            "time":YELLOW_BAR_CHASER_TWEEN_SECONDS,
            "transition":YELLOW_BAR_CHASER_TWEEN_EASING
         });
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<HeaderButtonRenderer>> " + param1);
      }
      
      private function onMainButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:IHeaderButtonClickHandler = null;
         for each(_loc2_ in _handlers[IHeaderButtonClickHandler])
         {
            _loc2_.handleHeaderButtonClick(param1.target as MainButton);
         }
      }
      
      public function setStateButton(param1:StateType) : void
      {
         if(_currentButton != null)
         {
            _currentButton.active = false;
            _currentButton.mouseEnabled = true;
         }
         var _loc2_:MainButton = getMenuItemByStateType(param1);
         if(_loc2_ == null)
         {
            return;
         }
         _currentButton = _loc2_;
         _currentButton.active = true;
         _currentButton.mouseEnabled = false;
         if(StateType.NANOMALL != param1)
         {
            if(false == _wantMoreClickHereButton.hasEventListener(MouseEvent.CLICK))
            {
               _wantMoreClickHereButton.addEventListener(MouseEvent.CLICK,handleWantMoreClickHereClick);
            }
         }
      }
      
      public function addHeaderButtonClickHandler(param1:IHeaderButtonClickHandler) : void
      {
         _handlers[IHeaderButtonClickHandler][param1] = param1;
      }
      
      public function hideButtons(param1:Number = 1) : void
      {
         _mainButtonContainer.mouseChildren = false;
         Tweener.addTween(_mainButtonContainer,{
            "_autoAlpha":0,
            "time":param1
         });
         Tweener.addTween(_yellowBarChaser,{
            "x":YELLOW_BAR_CHASER_START_X,
            "time":YELLOW_BAR_CHASER_TWEEN_SECONDS,
            "transition":YELLOW_BAR_CHASER_TWEEN_EASING
         });
         _wantMoreClickHereButton.visible = false;
      }
      
      private function onMainButtonRollOut(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = null;
         if(false == _mainButtonContainer.mouseChildren)
         {
            return;
         }
         if(null != _currentButton)
         {
            _loc2_ = _currentButton.getBounds(_yellowBarChaser.parent);
            Tweener.addTween(_yellowBarChaser,{
               "x":_loc2_.x + _loc2_.width + YELLOW_BAR_CHASER_OFFSET,
               "time":YELLOW_BAR_CHASER_TWEEN_SECONDS,
               "transition":YELLOW_BAR_CHASER_TWEEN_EASING
            });
         }
         else
         {
            Tweener.addTween(_yellowBarChaser,{
               "x":YELLOW_BAR_CHASER_START_X,
               "time":YELLOW_BAR_CHASER_TWEEN_SECONDS,
               "transition":YELLOW_BAR_CHASER_TWEEN_EASING
            });
         }
      }
      
      private function logError(param1:String) : void
      {
         DebugLog.instance.error(">>HeaderButtonRenderer<< " + param1);
      }
      
      public function handleStatePackageReady(param1:StateType) : void
      {
         log("handleStatePackageReady() - stateType: " + param1);
         disableButton(param1,false);
      }
      
      public function disableDeviceButton() : void
      {
         getMenuItemByStateType(StateType.DEVICEMANAGER).hide();
      }
      
      public function showLastButtonClickedAsCurrent(param1:MainButton) : void
      {
         if(_currentButton == param1)
         {
            return;
         }
         if(_currentButton != null)
         {
            _currentButton.active = false;
            _currentButton.mouseEnabled = true;
         }
         _currentButton = param1;
         if(param1 != null)
         {
            _currentButton.active = true;
            _currentButton.mouseEnabled = false;
         }
      }
      
      private function handleWantMoreClickHereClick(param1:MouseEvent) : void
      {
         IEventDispatcher(param1.currentTarget).removeEventListener(param1.type,arguments.callee);
         Managers.stateManager.setState(StateType.NANOMALL);
      }
      
      public function disableButton(param1:StateType, param2:Boolean) : void
      {
         if(StateType.NANOMALL == param1)
         {
            if(param2)
            {
               _wantMoreClickHereButton.gotoAndStop("Disabled");
               _wantMoreClickHereButton.mouseEnabled = false;
            }
            else
            {
               _wantMoreClickHereButton.gotoAndStop("Normal");
               _wantMoreClickHereButton.mouseEnabled = true;
            }
         }
         var _loc3_:MainButton = _buttonByStateType[param1];
         if(null == _loc3_)
         {
            log("disableButton() - null button for stateType: " + param1.name);
            return;
         }
         _loc3_.toggleDisabled(param2);
      }
      
      public function createMainButtons() : void
      {
         var _loc2_:Object = null;
         var _loc3_:StateType = null;
         var _loc4_:Object = null;
         var _loc5_:MainButton = null;
         var _loc6_:DummyButton = null;
         log("Creating buttons");
         var _loc1_:Number = 0;
         for each(_loc2_ in DASHBOARD_LINKS)
         {
            _loc3_ = _loc2_.stateType;
            _loc4_ = new Object();
            _loc4_.buttonText = _loc2_.buttonText;
            _loc4_.stateType = _loc3_;
            if(StateType.NANOMALL == _loc3_)
            {
               _loc4_.frameLabel = MainButton.ORANGE_LABEL;
            }
            _loc5_ = new MainButton(_loc4_);
            _loc5_.x = _loc1_;
            _loc5_.addEventListener(MouseEvent.CLICK,onMainButtonClick);
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,onMainButtonRollOver);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,onMainButtonRollOut);
            _loc1_ += _loc5_.width - MainButton.PADDING;
            _mainButtonContainer.addChild(_loc5_);
            _buttonByStateType[_loc3_] = _loc5_;
            if(_loc3_ == StateType.DEVICEMANAGER)
            {
               _loc5_.hide();
            }
         }
         if(_loc1_ < MAIN_BUTTONS_TOTAL_WIDTH - 1)
         {
            _loc6_ = new DummyButton(MAIN_BUTTONS_TOTAL_WIDTH - _loc1_);
            _loc6_.x = _loc1_ + MainButton.PADDING;
            _mainButtonContainer.addChild(_loc6_);
         }
         setStateButton(StateType.HOME);
         _statePackageUpdater.addStatePackageReadyHandler(IStatePackageReadyHandler(this));
      }
   }
}

