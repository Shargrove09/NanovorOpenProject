package com.arkadium.communications
{
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GameServiceInvitation
   {
      
      private var _timeoutTimer:Timer;
      
      private var _acceptClearsQueue:Boolean;
      
      private var _invitationKey:String;
      
      private var _data:Object;
      
      private var _consumer:IGameServiceInvitationManagerConsumer;
      
      private var _invitationManager:IGameServiceInvitationManager;
      
      public var callingCDB:CommonDialogBox;
      
      public function GameServiceInvitation(param1:Object, param2:IGameServiceInvitationManagerConsumer, param3:IGameServiceInvitationManager, param4:String, param5:int, param6:Boolean)
      {
         super();
         this._data = param1;
         this._consumer = param2;
         this._invitationManager = param3;
         this._invitationKey = param4;
         this._acceptClearsQueue = param6;
         this._timeoutTimer = new Timer(param5 * 1000,1);
         this._timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleTimerComplete);
         this._timeoutTimer.start();
      }
      
      public function getDialogTitle() : String
      {
         return this._consumer.getDialogTitle();
      }
      
      public function getDialogText() : String
      {
         return this._consumer.getDialogText(this._data);
      }
      
      public function invitationDecline() : void
      {
         this._timeoutTimer.stop();
         this._consumer.handleInvitationDecline(this._data);
      }
      
      public function get invitationKey() : String
      {
         return this._invitationKey;
      }
      
      public function invitationTimeout() : void
      {
         this._timeoutTimer.stop();
         this._consumer.handleInvitationTimeout(this._data);
      }
      
      public function invitationAccept() : void
      {
         this._timeoutTimer.stop();
         this._consumer.handleInvitationAccept(this._data);
      }
      
      private function handleTimerComplete(param1:TimerEvent) : void
      {
         this._invitationManager.removeInvitationByKey(this._invitationKey);
         this.invitationTimeout();
      }
      
      public function invitationBusy() : void
      {
         this._timeoutTimer.stop();
         this._consumer.handleInvitationBusy(this._data);
      }
      
      public function get acceptClearsQueue() : Boolean
      {
         return this._acceptClearsQueue;
      }
   }
}

