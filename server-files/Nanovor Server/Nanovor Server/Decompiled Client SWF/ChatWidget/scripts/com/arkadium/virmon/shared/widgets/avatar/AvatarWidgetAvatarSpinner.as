package com.arkadium.virmon.shared.widgets.avatar
{
   import com.arkadium.virmon.avatar.AvatarSpinner;
   import com.arkadium.virmon.framework.IBuddyData;
   import com.arkadium.virmon.shared.data.Managers;
   import com.arkadium.virmon.shared.data.PermissionsManager;
   import com.arkadium.virmon.shared.final.components.spinningbutton.SpinningButtonComponent;
   import com.arkadium.virmon.shared.widgets.WidgetType;
   import com.arkadium.virmon.shared.widgets.megawidget.IMegaWidget;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class AvatarWidgetAvatarSpinner extends AvatarSpinner
   {
      
      public static const BUTTON_DESCRIPTION_TEXT:Array = ["TRADE","CHAT","ADD FRIEND","REMOVE FRIEND","ACCEPT","IGNORE","BATTLE"];
      
      private var _wires:Dictionary;
      
      private var _spinnerBlockBGController:SpinnerBGBlockController;
      
      public function AvatarWidgetAvatarSpinner()
      {
         var _loc2_:SpinningButtonComponent = null;
         super();
         this._wires = new Dictionary(true);
         var _loc1_:Array = this.getButtons();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ = _loc1_[_loc3_] as SpinningButtonComponent;
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onButtonRollOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onButtonRollOut);
            this._wires[_loc2_] = new AvatarSpinnerButtonWire();
            this._wires[_loc2_].text = BUTTON_DESCRIPTION_TEXT[_loc3_];
            this._wires[_loc2_].scaleX = 1 / _loc2_.scaleX;
            this._wires[_loc2_].scaleY = 1 / _loc2_.scaleY;
            _loc2_.addChild(this._wires[_loc2_]);
            _loc3_++;
         }
      }
      
      private function onButtonRollOut(param1:MouseEvent) : void
      {
         var _loc2_:SpinningButtonComponent = param1.currentTarget as SpinningButtonComponent;
         this._wires[_loc2_].close();
      }
      
      private function onButtonRollOver(param1:MouseEvent) : void
      {
         var _loc2_:SpinningButtonComponent = param1.currentTarget as SpinningButtonComponent;
         this._wires[_loc2_].open();
      }
      
      public function updateName(param1:String) : void
      {
         this.playerNameTitle = param1.toUpperCase();
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<AvatarWidgetAvatarSpinner>>\t" + param1);
      }
      
      public function updateNMP(param1:int) : void
      {
         if(-1 == param1)
         {
            this.playerNameSubtitle = "";
         }
         else
         {
            this.playerNameSubtitle = "NMP " + param1.toString();
         }
      }
      
      override public function open() : Boolean
      {
         this.log("open()");
         this._spinnerBlockBGController.moveTo(this.x,this.y);
         this._spinnerBlockBGController.open();
         this.showName = true;
         this.log("open(): Showing Name");
         _battleButton.open();
         _battleButton.visible = true;
         return super.open();
      }
      
      public function getButtons() : Array
      {
         return [_tradeButton,_chatButton,_friendsButton,_removeFriendButton,_addButton,_ignoreButton,_battleButton];
      }
      
      private function disableGameButtons(param1:Boolean) : void
      {
         _battleButton.disable(param1);
         _tradeButton.disable(param1);
         _chatButton.disable(param1);
      }
      
      private function updateText(param1:IBuddyData) : void
      {
         this.playerNameTitle = param1.Name;
         if(param1.NMP != -1)
         {
            this.playerNameSubtitle = "NMP " + param1.NMP;
         }
         else
         {
            this.playerNameSubtitle = "";
         }
      }
      
      override public function close() : Boolean
      {
         this.menuMode = AvatarSpinner.MENU_MODE_NONE;
         this._spinnerBlockBGController.close();
         this.showName = false;
         this.menuMode = AvatarSpinner.MENU_MODE_NONE;
         return super.close();
      }
      
      public function setSpinnerBlockBG(param1:MovieClip) : void
      {
         this._spinnerBlockBGController = new SpinnerBGBlockController(param1);
      }
      
      public function updateButtons(param1:int) : void
      {
         if(param1 != 0 || Managers.stateManager.state == StateType.BATTLE.name)
         {
            this.disableGameButtons(true);
         }
         else
         {
            this.disableGameButtons(false);
            if(IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).canInvitePlayerToChat(this.playerName))
            {
               _chatButton.disable(false);
            }
            else
            {
               _chatButton.disable(true);
            }
            if(IMegaWidget(Managers.widgetManager.getWidgetByName(WidgetType.WIDGET_MEGA_WIDGET.name)).canInvitePlayerToBattle(this.playerName))
            {
               _battleButton.disable(false);
            }
            else
            {
               _battleButton.disable(true);
            }
         }
         if(!PermissionsManager.getInstance().canChat)
         {
            _chatButton.disable(true);
         }
         if(!PermissionsManager.getInstance().canTrade)
         {
            _tradeButton.disable(true);
         }
      }
   }
}

