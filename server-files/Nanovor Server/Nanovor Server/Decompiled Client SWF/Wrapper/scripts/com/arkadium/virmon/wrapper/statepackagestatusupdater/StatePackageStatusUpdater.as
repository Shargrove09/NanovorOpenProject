package com.arkadium.virmon.wrapper.statepackagestatusupdater
{
   import com.arkadium.virmon.downloadmanager.IDownloadManager;
   import com.arkadium.virmon.downloadmanager.handlers.IDownloadManagerStatusMediator;
   import com.arkadium.virmon.downloadmanager.handlers.IPackageCompleteHandler;
   import com.arkadium.virmon.framework.application.enum.PackageType;
   import com.arkadium.virmon.state.StateType;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.utils.Dictionary;
   
   public class StatePackageStatusUpdater implements IStatePackageStatusUpdater, IPackageCompleteHandler
   {
      
      private static const STATE_BY_PACKAGE:Dictionary = new Dictionary();
      
      STATE_BY_PACKAGE[PackageType.LOGIN_STATE] = StateType.LOGIN;
      STATE_BY_PACKAGE[PackageType.HOME_STATE] = StateType.HOME;
      STATE_BY_PACKAGE[PackageType.BATTLE_STATE] = StateType.BATTLE;
      STATE_BY_PACKAGE[PackageType.COLLECTION_STATE] = StateType.COLLECTION;
      STATE_BY_PACKAGE[PackageType.EVO_TREE_STATE] = StateType.EVOTREE;
      STATE_BY_PACKAGE[PackageType.NANOMALL_STATE] = StateType.NANOMALL;
      STATE_BY_PACKAGE[PackageType.NONE] = StateType.NANOLOG;
      STATE_BY_PACKAGE[PackageType.DEVICE_STATE] = StateType.DEVICEMANAGER;
      STATE_BY_PACKAGE[PackageType.TRADE_STATE] = StateType.TRADEGAME;
      STATE_BY_PACKAGE[PackageType.PROFILE_STATE] = StateType.PROFILE;
      STATE_BY_PACKAGE[PackageType.SENSEI_BATTLE_STATE] = StateType.SENSEI_BATTLE;
      STATE_BY_PACKAGE[PackageType.SENSEI_SELECT_STATE] = StateType.SENSEI_SELECT;
      
      private var _handlers:Dictionary;
      
      private var _readyStateTypes:Array;
      
      public function StatePackageStatusUpdater(param1:IDownloadManagerStatusMediator, param2:IDownloadManager)
      {
         super();
         param1.addPackageCompleteHandler(IPackageCompleteHandler(this));
         _handlers = new Dictionary();
         _handlers[IStatePackageReadyHandler] = new Dictionary(true);
         populateReadyStates(param2);
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<StatePackageStatusUpdater>>\t" + param1);
      }
      
      public function handlePackageComplete(param1:PackageType) : void
      {
         var _loc3_:IStatePackageReadyHandler = null;
         log("handlePackageComplete() - package: " + param1);
         var _loc2_:StateType = STATE_BY_PACKAGE[param1];
         if(null == _loc2_)
         {
            return;
         }
         log("handlePackageComplete() - found associated state: " + _loc2_);
         _readyStateTypes.push(_loc2_);
         for each(_loc3_ in _handlers[IStatePackageReadyHandler])
         {
            _loc3_.handleStatePackageReady(_loc2_);
         }
      }
      
      private function populateReadyStates(param1:IDownloadManager) : void
      {
         var _loc2_:Object = null;
         var _loc3_:PackageType = null;
         log("populateReadyStates()");
         _readyStateTypes = new Array();
         for(_loc2_ in STATE_BY_PACKAGE)
         {
            _loc3_ = _loc2_ as PackageType;
            if(PackageType.NONE === _loc3_ || !param1.isPackageOutdated(_loc3_))
            {
               log("populateReadyStates() - Adding ready state: " + STATE_BY_PACKAGE[_loc2_]);
               _readyStateTypes.push(STATE_BY_PACKAGE[_loc2_]);
            }
         }
      }
      
      public function addStatePackageReadyHandler(param1:IStatePackageReadyHandler) : void
      {
         var _loc2_:StateType = null;
         _handlers[IStatePackageReadyHandler][param1] = param1;
         for each(_loc2_ in _readyStateTypes)
         {
            log("addStatePackageReadyHandler() - state is ready: " + _loc2_);
            param1.handleStatePackageReady(_loc2_);
         }
      }
   }
}

