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
         _stateManager = param1;
         _invitationQueue = new Array();
         _dialogTimer = new Timer(DIALOG_QUEUE_SECONDS * 1000,1);
         _dialogTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onDialogTimerComplete);
      }
      
      private function handleAcceptInvitation(param1:Object) : void
      {
         var _loc2_:GameServiceInvitation = param1.invitation;
         if(_loc2_.acceptClearsQueue)
         {
            declineAllInvitations();
         }
         else
         {
            processQueueWithWait();
         }
         _loc2_.invitationAccept();
      }
      
      public function checkCanAcceptInvitations() : Boolean
      {
         if(null == _stateManager)
         {
            throw new Error("GameServiceInvitationManager\'s reference to StateManager cannot be null");
         }
         var _loc1_:String = _stateManager.state;
         var _loc2_:Boolean = true;
         var _loc3_:ICanAcceptInvitationChecker = _stateManager.getStateByName(_loc1_) as ICanAcceptInvitationChecker;
         if(null != _loc3_)
         {
            _loc2_ = Boolean(_loc3_.checkCanAcceptInvitations());
         }
         return _loc1_ != StateType.DEVICEMANAGER.name && _loc1_ != StateType.LOGIN.name && _loc2_;
      }
      
      public function removeInvitationByKey(param1:String) : void
      {
         var _loc3_:GameServiceInvitation = null;
         if(null != _currentInvitation && _currentInvitation.invitationKey == param1)
         {
            if(null != _currentDialog)
            {
               _currentDialog.kill();
            }
            _currentDialog = null;
            _currentInvitation == null;
            processQueue();
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _invitationQueue.length)
         {
            _loc3_ = _invitationQueue[_loc2_] as GameServiceInvitation;
            if(_loc3_.invitationKey == param1)
            {
               _invitationQueue.splice(_loc2_,1);
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
         log("onDialogTimerComplete()");
         _currentDialog = null;
         _currentInvitation = null;
         processQueue();
      }
      
      private function handleTimeoutInvitation(param1:Object) : void
      {
         var _loc2_:GameServiceInvitation = param1.invitation;
         var _loc3_:CommonDialogBox = param1.callingCDB;
         _loc3_.kill();
         _loc2_.invitationTimeout();
         processQueueWithWait();
      }
      
      private function processQueueWithWait() : void
      {
         log("processQueueWithWait()");
         _dialogTimer.reset();
         _dialogTimer.start();
      }
      
      public function handleInvitation(param1:Object, param2:IGameServiceInvitationManagerConsumer, param3:String, param4:int, param5:Boolean = true) : void
      {
         _invitationQueue.push(new GameServiceInvitation(param1,param2,IGameServiceInvitationManager(this),param3,param4,param5));
         if(null == _currentDialog)
         {
            processQueue();
         }
      }
      
      private function handleDeclineInvitation(param1:Object) : void
      {
         var _loc2_:GameServiceInvitation = param1.invitation;
         _loc2_.invitationDecline();
         processQueueWithWait();
      }
      
      private function processQueue() : void
      {
         log("processQueue()");
         if(0 == _invitationQueue.length)
         {
            return;
         }
         _currentInvitation = _invitationQueue.shift() as GameServiceInvitation;
         _currentDialog = CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_CONFIRM,_currentInvitation.getDialogTitle(),_currentInvitation.getDialogText(),DIALOG_TIMEOUT_SECONDS,handleAcceptInvitation,handleDeclineInvitation,handleDeclineInvitation,{"invitation":_currentInvitation},handleTimeoutInvitation);
      }
      
      public function cancelInvitation(param1:String, param2:String, param3:String) : void
      {
         var _loc5_:GameServiceInvitation = null;
         if(null != _currentInvitation && _currentInvitation.invitationKey == param1)
         {
            if(null != _currentDialog)
            {
               _currentDialog.kill();
            }
            _currentDialog = null;
            _currentInvitation == null;
            CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,param2,param3);
            processQueue();
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _invitationQueue.length)
         {
            _loc5_ = _invitationQueue[_loc4_] as GameServiceInvitation;
            if(_loc5_.invitationKey == param1)
            {
               _invitationQueue.splice(_loc4_,1);
               return;
            }
            _loc4_++;
         }
      }
      
      public function declineAllInvitations(param1:Boolean = false) : void
      {
         var _loc2_:GameServiceInvitation = null;
         log("declineAllInvitations()");
         for each(_loc2_ in _invitationQueue)
         {
            _loc2_.invitationBusy();
         }
         if(param1)
         {
            if(null != _currentDialog)
            {
               _currentDialog.kill();
            }
            if(null != _currentInvitation)
            {
               _currentInvitation.invitationBusy();
            }
         }
         _invitationQueue = new Array();
         _currentDialog = null;
         _currentInvitation = null;
      }
   }
}

