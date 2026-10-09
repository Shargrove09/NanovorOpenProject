package com.arkadium.virmon.shared.widgets.avatar
{
   import com.arkadium.virmon.avatar.AvatarManager;
   import com.arkadium.virmon.avatar.AvatarSpinner;
   import com.arkadium.virmon.avatar.AvatarSpinnerState;
   import com.arkadium.virmon.avatar.AvatarSpinnerStateType;
   import com.arkadium.virmon.avatar.IAvatarSpinnerCloseHandler;
   import com.arkadium.virmon.avatar.IAvatarSpinnerOpenHandler;
   import com.arkadium.virmon.avatar.IAvatarSpinnerProvider;
   import com.arkadium.virmon.avatar.IAvatarSpinnerState;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.widgets.AbstractWidget;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class AvatarWidget extends AbstractWidget implements IAvatarSpinnerProvider
   {
      
      public static const BUTTON_DESCRIPTION_TEXT:Array = ["BATTLE","TRADE","CHAT","ADD FRIEND","REMOVE FRIEND","ACCEPT","IGNORE"];
      
      public var mcSpinnerBlock1:MovieClip;
      
      private var _handlers:Dictionary;
      
      private var _handleAvatarSpinnerCloseTimer:Timer;
      
      public var mcSpinnerBlock2:MovieClip;
      
      private var _spinner1:AvatarWidgetAvatarSpinner;
      
      private var _spinner2:AvatarWidgetAvatarSpinner;
      
      public var mcAvatarSpinnerContainer:MovieClip;
      
      private var _buttonDescriptionWires:Dictionary;
      
      private var _spinnerDataController:AvatarSpinnerDataController;
      
      private var _avatarSpinnerState:IAvatarSpinnerState;
      
      public var mcButtonWireContainer:MovieClip;
      
      private var _currentSpinner:AvatarWidgetAvatarSpinner;
      
      public function AvatarWidget()
      {
         super(WidgetType.WIDGET_AVATAR);
         addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
         _avatarSpinnerState = new AvatarSpinnerState();
         _handlers = new Dictionary();
         _handlers[IAvatarSpinnerCloseHandler] = new Dictionary(true);
         _handlers[IAvatarSpinnerOpenHandler] = new Dictionary(true);
         mcAvatarSpinnerContainer.mouseEnabled = false;
         mcButtonWireContainer.mouseEnabled = false;
         mcSpinnerBlock1.mouseEnabled = false;
         mcSpinnerBlock2.mouseEnabled = false;
         mcSpinnerBlock1.height = 0;
         mcSpinnerBlock2.height = 0;
      }
      
      public function addAvatarSpinnerOpenHandler(param1:IAvatarSpinnerOpenHandler) : void
      {
         log("addAvatarSpinnerOpenHandler() - Adding handler null? " + Boolean(null == param1));
         _handlers[IAvatarSpinnerOpenHandler][param1] = param1;
      }
      
      private function startHandleAvatarSpinnerCloseTimer(param1:int = 150) : void
      {
         if(_handleAvatarSpinnerCloseTimer == null)
         {
            _handleAvatarSpinnerCloseTimer = new Timer(param1,1);
            _handleAvatarSpinnerCloseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onHandleAvatarSpinnerCloseTimerComplete);
         }
         else
         {
            _handleAvatarSpinnerCloseTimer.reset();
         }
         _handleAvatarSpinnerCloseTimer.start();
      }
      
      private function onAvatarSpinnerButtonRollOver(param1:MouseEvent) : void
      {
         var _loc2_:SpinningButtonComponent = param1.currentTarget as SpinningButtonComponent;
         _buttonDescriptionWires[_loc2_].open();
      }
      
      public function addAvatarSpinnerCloseHandler(param1:IAvatarSpinnerCloseHandler) : void
      {
         _handlers[IAvatarSpinnerCloseHandler][param1] = param1;
      }
      
      public function closeAvatarSpinners() : void
      {
         var _loc1_:Boolean = _spinner1.close();
         _spinner1.menuMode = AvatarSpinner.MENU_MODE_NONE;
         if(null != _spinner1.parent)
         {
            _spinner1.parent.removeChild(_spinner1);
         }
         _loc1_ ||= _spinner2.close();
         _spinner2.menuMode = AvatarSpinner.MENU_MODE_NONE;
         if(null != _spinner2.parent)
         {
            _spinner2.parent.removeChild(_spinner2);
         }
         _avatarSpinnerState.state = AvatarSpinnerStateType.INACTIVE;
         if(_loc1_)
         {
            log("onStageClick(): one of the spinners was open");
            startHandleAvatarSpinnerCloseTimer();
         }
      }
      
      private function clearHandleAvatarSpinnerCloseTimer() : Boolean
      {
         if(_handleAvatarSpinnerCloseTimer == null)
         {
            log("clearHandleAvatarSpinnerCloseTimer() ... returning false");
            return false;
         }
         _handleAvatarSpinnerCloseTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onHandleAvatarSpinnerCloseTimerComplete);
         _handleAvatarSpinnerCloseTimer = null;
         log("clearHandleAvatarSpinnerCloseTimer() ... returning true");
         return true;
      }
      
      private function onHandleAvatarSpinnerCloseTimerComplete(param1:TimerEvent) : void
      {
         var _loc2_:IAvatarSpinnerCloseHandler = null;
         clearHandleAvatarSpinnerCloseTimer();
         for each(_loc2_ in _handlers[IAvatarSpinnerCloseHandler])
         {
            log("onHandleAvatarSpinnerCloseTimerComplete(): ... handler found");
            _loc2_.handleAvatarSpinnerClose();
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageClick,false,0,true);
      }
      
      private function onAvatarSpinnerButtonRollOut(param1:MouseEvent) : void
      {
         var _loc2_:SpinningButtonComponent = param1.currentTarget as SpinningButtonComponent;
         _buttonDescriptionWires[_loc2_].close();
      }
      
      public function openSpinnerAtLocation(param1:DisplayObject, param2:String, param3:int, param4:int) : void
      {
         closePreviousAvatarSpinner();
         openNewAvatarSpinner(param1,param2,param3,param4);
      }
      
      private function onStageClick(param1:MouseEvent) : void
      {
         if(_spinner1.mouseChildren && _spinner1.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         if(_spinner2.mouseChildren && _spinner2.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         closeAvatarSpinners();
      }
      
      private function openNewAvatarSpinner(param1:DisplayObject, param2:String, param3:int, param4:int) : void
      {
         var _loc7_:IAvatarSpinnerOpenHandler = null;
         log("openNewAvatarSpinner()");
         var _loc5_:Point = param1.localToGlobal(new Point(0,0));
         _currentSpinner = _currentSpinner == _spinner1 ? _spinner2 : _spinner1;
         _currentSpinner.avatarId = param3;
         _currentSpinner.loadAvatarPicture();
         _currentSpinner.showAvatar = true;
         _currentSpinner.playerName = param2;
         _spinnerDataController.playerName = param2;
         _spinnerDataController.avatarId = param3;
         _spinnerDataController.nmp = param4;
         _spinnerDataController.associateSpinner(_currentSpinner);
         mcAvatarSpinnerContainer.addChild(_currentSpinner);
         _currentSpinner.x = _loc5_.x;
         _currentSpinner.y = _loc5_.y;
         _currentSpinner.menuMode = AvatarSpinner.MENU_MODE_GENERAL;
         var _loc6_:Boolean = _currentSpinner.open();
         if(_loc6_ && !clearHandleAvatarSpinnerCloseTimer())
         {
            log("openNewAvatarSpinner(): the current spinner was not open, and the closeTimer was already null");
            for each(_loc7_ in _handlers[IAvatarSpinnerOpenHandler])
            {
               log("openNewAvatarSpinner(): ... handler found");
               _loc7_.handleAvatarSpinnerOpen();
            }
         }
      }
      
      public function get avatarSpinnerState() : IAvatarSpinnerState
      {
         return _avatarSpinnerState;
      }
      
      private function closePreviousAvatarSpinner() : void
      {
         _currentSpinner.killAvatarPicture();
         _currentSpinner.showAvatar = false;
         _currentSpinner.close();
         if(null != _currentSpinner.parent)
         {
            _currentSpinner.parent.removeChild(_currentSpinner);
         }
      }
      
      public function closeActiveSpinnerBlock() : void
      {
         startHandleAvatarSpinnerCloseTimer();
      }
      
      override public function destroy() : void
      {
         _spinner1.destroy();
         _spinner2.destroy();
         super.destroy();
      }
      
      override public function init(param1:Object = null) : void
      {
         AvatarManager.getInstance().setAvatarClickHandler(openSpinnerAtLocation);
         _avatarSpinnerState.state = AvatarSpinnerStateType.INACTIVE;
         _buttonDescriptionWires = new Dictionary(true);
         _spinner1 = new AvatarWidgetAvatarSpinner();
         _spinner1.setSpinnerBlockBG(mcSpinnerBlock1);
         _spinner2 = new AvatarWidgetAvatarSpinner();
         _spinner2.setSpinnerBlockBG(mcSpinnerBlock2);
         _currentSpinner = _spinner2;
         _spinnerDataController = new AvatarSpinnerDataController();
         log("initialized");
      }
   }
}

