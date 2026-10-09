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
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this._avatarSpinnerState = new AvatarSpinnerState();
         this._handlers = new Dictionary();
         this._handlers[IAvatarSpinnerCloseHandler] = new Dictionary(true);
         this._handlers[IAvatarSpinnerOpenHandler] = new Dictionary(true);
         this.mcAvatarSpinnerContainer.mouseEnabled = false;
         this.mcButtonWireContainer.mouseEnabled = false;
         this.mcSpinnerBlock1.mouseEnabled = false;
         this.mcSpinnerBlock2.mouseEnabled = false;
         this.mcSpinnerBlock1.height = 0;
         this.mcSpinnerBlock2.height = 0;
      }
      
      public function addAvatarSpinnerOpenHandler(param1:IAvatarSpinnerOpenHandler) : void
      {
         log("addAvatarSpinnerOpenHandler() - Adding handler null? " + Boolean(null == param1));
         this._handlers[IAvatarSpinnerOpenHandler][param1] = param1;
      }
      
      private function startHandleAvatarSpinnerCloseTimer(param1:int = 150) : void
      {
         if(this._handleAvatarSpinnerCloseTimer == null)
         {
            this._handleAvatarSpinnerCloseTimer = new Timer(param1,1);
            this._handleAvatarSpinnerCloseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHandleAvatarSpinnerCloseTimerComplete);
         }
         else
         {
            this._handleAvatarSpinnerCloseTimer.reset();
         }
         this._handleAvatarSpinnerCloseTimer.start();
      }
      
      private function onAvatarSpinnerButtonRollOver(param1:MouseEvent) : void
      {
         var _loc2_:SpinningButtonComponent = param1.currentTarget as SpinningButtonComponent;
         this._buttonDescriptionWires[_loc2_].open();
      }
      
      public function addAvatarSpinnerCloseHandler(param1:IAvatarSpinnerCloseHandler) : void
      {
         this._handlers[IAvatarSpinnerCloseHandler][param1] = param1;
      }
      
      public function closeAvatarSpinners() : void
      {
         var _loc1_:Boolean = this._spinner1.close();
         this._spinner1.menuMode = AvatarSpinner.MENU_MODE_NONE;
         if(null != this._spinner1.parent)
         {
            this._spinner1.parent.removeChild(this._spinner1);
         }
         _loc1_ ||= this._spinner2.close();
         this._spinner2.menuMode = AvatarSpinner.MENU_MODE_NONE;
         if(null != this._spinner2.parent)
         {
            this._spinner2.parent.removeChild(this._spinner2);
         }
         this._avatarSpinnerState.state = AvatarSpinnerStateType.INACTIVE;
         if(_loc1_)
         {
            log("onStageClick(): one of the spinners was open");
            this.startHandleAvatarSpinnerCloseTimer();
         }
      }
      
      private function clearHandleAvatarSpinnerCloseTimer() : Boolean
      {
         if(this._handleAvatarSpinnerCloseTimer == null)
         {
            log("clearHandleAvatarSpinnerCloseTimer() ... returning false");
            return false;
         }
         this._handleAvatarSpinnerCloseTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onHandleAvatarSpinnerCloseTimerComplete);
         this._handleAvatarSpinnerCloseTimer = null;
         log("clearHandleAvatarSpinnerCloseTimer() ... returning true");
         return true;
      }
      
      private function onHandleAvatarSpinnerCloseTimerComplete(param1:TimerEvent) : void
      {
         var _loc2_:IAvatarSpinnerCloseHandler = null;
         this.clearHandleAvatarSpinnerCloseTimer();
         for each(_loc2_ in this._handlers[IAvatarSpinnerCloseHandler])
         {
            log("onHandleAvatarSpinnerCloseTimerComplete(): ... handler found");
            _loc2_.handleAvatarSpinnerClose();
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageClick,false,0,true);
      }
      
      private function onAvatarSpinnerButtonRollOut(param1:MouseEvent) : void
      {
         var _loc2_:SpinningButtonComponent = param1.currentTarget as SpinningButtonComponent;
         this._buttonDescriptionWires[_loc2_].close();
      }
      
      public function openSpinnerAtLocation(param1:DisplayObject, param2:String, param3:int, param4:int) : void
      {
         this.closePreviousAvatarSpinner();
         this.openNewAvatarSpinner(param1,param2,param3,param4);
      }
      
      private function onStageClick(param1:MouseEvent) : void
      {
         if(this._spinner1.mouseChildren && this._spinner1.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         if(this._spinner2.mouseChildren && this._spinner2.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         this.closeAvatarSpinners();
      }
      
      private function openNewAvatarSpinner(param1:DisplayObject, param2:String, param3:int, param4:int) : void
      {
         var _loc7_:IAvatarSpinnerOpenHandler = null;
         log("openNewAvatarSpinner()");
         var _loc5_:Point = param1.localToGlobal(new Point(0,0));
         this._currentSpinner = this._currentSpinner == this._spinner1 ? this._spinner2 : this._spinner1;
         this._currentSpinner.avatarId = param3;
         this._currentSpinner.loadAvatarPicture();
         this._currentSpinner.showAvatar = true;
         this._currentSpinner.playerName = param2;
         this._spinnerDataController.playerName = param2;
         this._spinnerDataController.avatarId = param3;
         this._spinnerDataController.nmp = param4;
         this._spinnerDataController.associateSpinner(this._currentSpinner);
         this.mcAvatarSpinnerContainer.addChild(this._currentSpinner);
         this._currentSpinner.x = _loc5_.x;
         this._currentSpinner.y = _loc5_.y;
         this._currentSpinner.menuMode = AvatarSpinner.MENU_MODE_GENERAL;
         var _loc6_:Boolean = this._currentSpinner.open();
         if(_loc6_ && !this.clearHandleAvatarSpinnerCloseTimer())
         {
            log("openNewAvatarSpinner(): the current spinner was not open, and the closeTimer was already null");
            for each(_loc7_ in this._handlers[IAvatarSpinnerOpenHandler])
            {
               log("openNewAvatarSpinner(): ... handler found");
               _loc7_.handleAvatarSpinnerOpen();
            }
         }
      }
      
      public function get avatarSpinnerState() : IAvatarSpinnerState
      {
         return this._avatarSpinnerState;
      }
      
      private function closePreviousAvatarSpinner() : void
      {
         this._currentSpinner.killAvatarPicture();
         this._currentSpinner.showAvatar = false;
         this._currentSpinner.close();
         if(null != this._currentSpinner.parent)
         {
            this._currentSpinner.parent.removeChild(this._currentSpinner);
         }
      }
      
      public function closeActiveSpinnerBlock() : void
      {
         this.startHandleAvatarSpinnerCloseTimer();
      }
      
      override public function destroy() : void
      {
         this._spinner1.destroy();
         this._spinner2.destroy();
         super.destroy();
      }
      
      override public function init(param1:Object = null) : void
      {
         AvatarManager.getInstance().setAvatarClickHandler(this.openSpinnerAtLocation);
         this._avatarSpinnerState.state = AvatarSpinnerStateType.INACTIVE;
         this._buttonDescriptionWires = new Dictionary(true);
         this._spinner1 = new AvatarWidgetAvatarSpinner();
         this._spinner1.setSpinnerBlockBG(this.mcSpinnerBlock1);
         this._spinner2 = new AvatarWidgetAvatarSpinner();
         this._spinner2.setSpinnerBlockBG(this.mcSpinnerBlock2);
         this._currentSpinner = this._spinner2;
         this._spinnerDataController = new AvatarSpinnerDataController();
         log("initialized");
      }
   }
}

