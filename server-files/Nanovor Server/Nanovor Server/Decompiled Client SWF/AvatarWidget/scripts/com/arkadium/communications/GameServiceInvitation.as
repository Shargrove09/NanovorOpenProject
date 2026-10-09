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
         _data = param1;
         _consumer = param2;
         _invitationManager = param3;
         _invitationKey = param4;
         _acceptClearsQueue = param6;
         _timeoutTimer = new Timer(param5 * 1000,1);
         _timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handleTimerComplete);
         _timeoutTimer.start();
      }
      
      public function getDialogTitle() : String
      {
         return _consumer.getDialogTitle();
      }
      
      public function getDialogText() : String
      {
         return _consumer.getDialogText(_data);
      }
      
      public function invitationDecline() : void
      {
         _timeoutTimer.stop();
         _consumer.handleInvitationDecline(_data);
      }
      
      public function get invitationKey() : String
      {
         return _invitationKey;
      }
      
      public function invitationTimeout() : void
      {
         _timeoutTimer.stop();
         _consumer.handleInvitationTimeout(_data);
      }
      
      public function invitationAccept() : void
      {
         _timeoutTimer.stop();
         _consumer.handleInvitationAccept(_data);
      }
      
      private function handleTimerComplete(param1:TimerEvent) : void
      {
         _invitationManager.removeInvitationByKey(_invitationKey);
         invitationTimeout();
      }
      
      public function invitationBusy() : void
      {
         _timeoutTimer.stop();
         _consumer.handleInvitationBusy(_data);
      }
      
      public function get acceptClearsQueue() : Boolean
      {
         return _acceptClearsQueue;
      }
   }
}

