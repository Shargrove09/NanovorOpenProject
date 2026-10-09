package com.arkadium.communications
{
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.arkadium.virmon.state.ICanAcceptInvitationChecker;
   import com.arkadium.virmon.state.IStateManager;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GameServiceInvitationManager implements IGameServiceInvitationManager
   {
      
      private static const DIALOG_TIMEOUT_SECONDS:int = -30;
      
      private static const DIALOG_QUEUE_SECONDS:int = 1;
      
      private var _dialogTimer:Timer;
      
      private var _currentDialog:CommonDialogBox;
      
      private var _invitationQueue:Array;
      
      private var _currentInvitation:GameServiceInvitation;
      
      private var _stateManager:IStateManager;
      
      public function GameServiceInvitationManager(param1:IStateManager)
      {
         super();
         this._stateManager = param1;
         this._invitationQueue = new Array();
         this._dialogTimer = new Timer(DIALOG_QUEUE_SECONDS * 1000,1);
         this._dialogTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDialogTimerComplete);
      }
      
      private function handleAcceptInvitation(param1:Object) : void
      {
         var _loc2_:GameServiceInvitation = param1.invitation;
         if(_loc2_.acceptClearsQueue)
         {
            this.declineAllInvitations();
         }
         else
         {
            this.processQueueWithWait();
         }
         _loc2_.invitationAccept();
      }
      
      public function checkCanAcceptInvitations() : Boolean
      {
         if(null == this._stateManager)
         {
            throw new Error("GameServiceInvitationManager\'s reference to StateManager cannot be null");
         }
         var _loc1_:String = this._stateManager.state;
         var _loc2_:Boolean = true;
         var _loc3_:ICanAcceptInvitationChecker = this._stateManager.getStateByName(_loc1_) as ICanAcceptInvitationChecker;
         if(null != _loc3_)
         {
            _loc2_ = Boolean(_loc3_.checkCanAcceptInvitations());
         }
         return _loc1_ != StateType.DEVICEMANAGER.name && _loc1_ != StateType.LOGIN.name && _loc2_;
      }
      
      public function removeInvitationByKey(param1:String) : void
      {
         var _loc3_:GameServiceInvitation = null;
         if(null != this._currentInvitation && this._currentInvitation.invitationKey == param1)
         {
            if(null != this._currentDialog)
            {
               this._currentDialog.kill();
            }
            this._currentDialog = null;
            this._currentInvitation == null;
            this.processQueue();
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._invitationQueue.length)
         {
            _loc3_ = this._invitationQueue[_loc2_] as GameServiceInvitation;
            if(_loc3_.invitationKey == param1)
            {
               this._invitationQueue.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<GameServiceInvitationManager>>\t" + param1);
      }
      
      private function onDialogTimerComplete(param1:TimerEvent) : void
      {
         this.log("onDialogTimerComplete()");
         this._currentDialog = null;
         this._currentInvitation = null;
         this.processQueue();
      }
      
      private function handleTimeoutInvitation(param1:Object) : void
      {
         var _loc2_:GameServiceInvitation = param1.invitation;
         var _loc3_:CommonDialogBox = param1.callingCDB;
         _loc3_.kill();
         _loc2_.invitationTimeout();
         this.processQueueWithWait();
      }
      
      private function processQueueWithWait() : void
      {
         this.log("processQueueWithWait()");
         this._dialogTimer.reset();
         this._dialogTimer.start();
      }
      
      public function handleInvitation(param1:Object, param2:IGameServiceInvitationManagerConsumer, param3:String, param4:int, param5:Boolean = true) : void
      {
         this._invitationQueue.push(new GameServiceInvitation(param1,param2,IGameServiceInvitationManager(this),param3,param4,param5));
         if(null == this._currentDialog)
         {
            this.processQueue();
         }
      }
      
      private function handleDeclineInvitation(param1:Object) : void
      {
         var _loc2_:GameServiceInvitation = param1.invitation;
         _loc2_.invitationDecline();
         this.processQueueWithWait();
      }
      
      private function processQueue() : void
      {
         this.log("processQueue()");
         if(0 == this._invitationQueue.length)
         {
            return;
         }
         this._currentInvitation = this._invitationQueue.shift() as GameServiceInvitation;
         this._currentDialog = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,this._currentInvitation.getDialogTitle(),this._currentInvitation.getDialogText(),DIALOG_TIMEOUT_SECONDS,this.handleAcceptInvitation,this.handleDeclineInvitation,this.handleDeclineInvitation,{"invitation":this._currentInvitation},this.handleTimeoutInvitation);
      }
      
      public function cancelInvitation(param1:String, param2:String, param3:String) : void
      {
         var _loc5_:GameServiceInvitation = null;
         if(null != this._currentInvitation && this._currentInvitation.invitationKey == param1)
         {
            if(null != this._currentDialog)
            {
               this._currentDialog.kill();
            }
            this._currentDialog = null;
            this._currentInvitation == null;
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,param2,param3);
            this.processQueue();
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._invitationQueue.length)
         {
            _loc5_ = this._invitationQueue[_loc4_] as GameServiceInvitation;
            if(_loc5_.invitationKey == param1)
            {
               this._invitationQueue.splice(_loc4_,1);
               return;
            }
            _loc4_++;
         }
      }
      
      public function declineAllInvitations(param1:Boolean = false) : void
      {
         var _loc2_:GameServiceInvitation = null;
         this.log("declineAllInvitations()");
         for each(_loc2_ in this._invitationQueue)
         {
            _loc2_.invitationBusy();
         }
         if(param1)
         {
            if(null != this._currentDialog)
            {
               this._currentDialog.kill();
            }
            if(null != this._currentInvitation)
            {
               this._currentInvitation.invitationBusy();
            }
         }
         this._invitationQueue = new Array();
         this._currentDialog = null;
         this._currentInvitation = null;
      }
   }
}

