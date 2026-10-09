package com.arkadium.virmon.collection.substates.nanovor
{
   import com.arkadium.analytics.IAnalyticsManager;
   import com.arkadium.analytics.enum.Action;
   import com.arkadium.communications.IServiceRequestBrokerManager;
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonMasterData;
   import com.arkadium.virmon.shared.utils.CommonDialogBox;
   import com.smithandtinker.nanovor.common.Stat;
   import com.smithandtinker.nanovor.common.utils.Utils;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   
   public class NanovorBuffController implements INanovorBuffController
   {
      
      private var _iPendingSpeed:int;
      
      private var _iPendingJoltsArmor:int;
      
      private var _iPendingHealth:int;
      
      private var _iPendingJoltsSpeed:int;
      
      private var _iPendingJoltsStrength:int;
      
      private var _userProfile:IUserProfile;
      
      private var _analyticsManager:IAnalyticsManager;
      
      private var _iPendingStrength:int;
      
      private var _virmonMaster:IVirmonMasterData;
      
      private var _statsPanel:NanovorStatsPanel = null;
      
      private var _szTree:String;
      
      private var _serviceRequestBrokerManager:IServiceRequestBrokerManager;
      
      private var _nanovor:NanovorSpotlightView = null;
      
      private var _iPendingArmor:int;
      
      private var _iPendingJoltsHealth:int;
      
      private var _bPendingChanges:Boolean = false;
      
      private var _virmonData:IVirmonData = null;
      
      public function NanovorBuffController(param1:NanovorStatsPanel, param2:NanovorSpotlightView, param3:IUserProfile, param4:IServiceRequestBrokerManager, param5:IAnalyticsManager)
      {
         super();
         _statsPanel = param1;
         _nanovor = param2;
         _userProfile = param3;
         _serviceRequestBrokerManager = param4;
         _analyticsManager = param5;
         _statsPanel.addEventListener(NanovorStatsPanelEvent.BUFF_UP,onPanelBuffUp,false,0,true);
         _statsPanel.addEventListener(NanovorStatsPanelEvent.BUFF_DOWN,onPanelBuffDown,false,0,true);
         _statsPanel.addEventListener(NanovorStatsPanelEvent.CONFIRM_SPEND,onPanelConfirmSpend,false,0,true);
      }
      
      private function updatePendingStat(param1:String, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         switch(param1)
         {
            case Stat.ARMOR:
               _loc3_ = _virmonMaster.getArmorBuffFormula();
               _loc8_ = int(_virmonMaster.getMaxArmor());
               _loc10_ = int(_virmonMaster.getBaseArmor());
               _loc9_ = int(_virmonData.getArmor());
               _loc7_ = Math.max(_loc10_,_iPendingArmor);
               _loc4_ = "_iPendingArmor";
               _loc5_ = "_iPendingJoltsArmor";
               _loc6_ = "armorJolts";
               break;
            case Stat.SPEED:
               _loc3_ = _virmonMaster.getSpeedBuffFormula();
               _loc8_ = int(_virmonMaster.getMaxSpeed());
               _loc10_ = int(_virmonMaster.getBaseSpeed());
               _loc9_ = int(_virmonData.getSpeed());
               _loc7_ = Math.max(_loc10_,_iPendingSpeed);
               _loc4_ = "_iPendingSpeed";
               _loc5_ = "_iPendingJoltsSpeed";
               _loc6_ = "speedJolts";
               break;
            case Stat.STRENGTH:
               _loc3_ = _virmonMaster.getStrengthBuffFormula();
               _loc8_ = int(_virmonMaster.getMaxStrength());
               _loc10_ = int(_virmonMaster.getBaseStrength());
               _loc9_ = int(_virmonData.getStrength());
               _loc7_ = Math.max(_loc10_,_iPendingStrength);
               _loc4_ = "_iPendingStrength";
               _loc5_ = "_iPendingJoltsStrength";
               _loc6_ = "strengthJolts";
               break;
            case Stat.HEALTH:
               _loc3_ = _virmonMaster.getHealthBuffFormula();
               _loc8_ = int(_virmonMaster.getMaxHealth());
               _loc10_ = int(_virmonMaster.getBaseHealth());
               _loc9_ = int(_virmonData.getHealth());
               _loc7_ = Math.max(_loc10_,_iPendingHealth);
               _loc4_ = "_iPendingHealth";
               _loc5_ = "_iPendingJoltsHealth";
               _loc6_ = "healthJolts";
               log("health buff " + _loc7_ + " : " + _loc9_ + " : " + _loc8_ + " : " + _loc10_);
         }
         if(param2 == -1)
         {
            _loc7_ = _loc9_;
         }
         else
         {
            _loc7_ += param2;
         }
         if(_loc7_ >= _loc9_ && _loc7_ <= _loc8_)
         {
            this[_loc4_] = _loc7_;
            if(param2 == -1)
            {
               this[_loc5_] = _userProfile[_loc6_];
            }
            else
            {
               this[_loc5_] += -1 * param2 * _loc3_[_loc7_ - _loc10_ - (param2 == 1 ? 1 : 0)];
            }
            _bPendingChanges = checkPending();
            _loc11_ = _loc7_ == _loc8_ ? -1 : int(_loc3_[_loc7_ - _loc10_]);
            _statsPanel.setStat(param1,_loc7_,_loc11_,this[_loc5_]);
         }
      }
      
      private function onPanelConfirmSpend(param1:NanovorStatsPanelEvent) : void
      {
         if(checkPending())
         {
            sendBankRequest();
         }
      }
      
      private function sendBankRequest() : void
      {
         var _loc1_:Object = _statsPanel.getBuffObject();
         _serviceRequestBrokerManager.requestJoltSpendOnNanovor(_virmonData,_loc1_,onJoltSuccess,onJoltFailed);
         _analyticsManager.trackAction(Action.COLLECTION_ASSET_BUFF_SUBMIT);
      }
      
      private function onPanelBuffUp(param1:NanovorStatsPanelEvent) : void
      {
         updatePendingStat(param1.stat,1);
         _statsPanel.enableSpendButton(_bPendingChanges);
      }
      
      private function onPanelBuffDown(param1:NanovorStatsPanelEvent) : void
      {
         updatePendingStat(param1.stat,-1);
         _statsPanel.enableSpendButton(_bPendingChanges);
      }
      
      protected function logError(param1:String) : void
      {
         DebugLog.instance.error("** NanovorBuffController: " + param1);
      }
      
      public function get currentVirmonData() : IVirmonData
      {
         return _virmonData;
      }
      
      public function get currentTree() : String
      {
         return _szTree;
      }
      
      public function get pendingChanges() : Boolean
      {
         return _bPendingChanges;
      }
      
      protected function log(param1:String) : void
      {
         DebugLog.instance.log(">> NanovorBuffController: " + param1);
      }
      
      private function onJoltSuccess(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,onJoltSuccess);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,onJoltFailed);
         var _loc2_:String = String(param1.target.data);
         var _loc3_:XML = new XML(_loc2_);
         _loc3_ = Utils.StripXmlNamespace(_loc3_);
         if(_loc3_.name().localName == "error")
         {
            logError("requestBuff FAIL - Error returned in XML: \n" + "      type: " + _loc3_.type + "\n" + "      message: " + _loc3_.message);
            _analyticsManager.trackAction(Action.COLLECTION_ASSET_BUFF_FAIL);
         }
         else
         {
            _loc4_ = String(_loc3_.child("asset-stat").@id);
            _loc5_ = int(_loc3_.child("asset-stat").armor);
            _loc6_ = int(_loc3_.child("asset-stat").health);
            _loc7_ = int(_loc3_.child("asset-stat").speed);
            _loc8_ = int(_loc3_.child("asset-stat").strength);
            _loc9_ = int(_loc3_.child("account").@id);
            _loc11_ = int(_loc3_.child("account").jolt_health_balance);
            _loc10_ = int(_loc3_.child("account").jolt_armor_balance);
            _loc13_ = int(_loc3_.child("account").jolt_strength_balance);
            _loc12_ = int(_loc3_.child("account").jolt_speed_balance);
            log("JOLT REQUEST SUCCEEDED!!!!!!!!!!!!!!!!!!!!!!!!");
            _analyticsManager.trackAction(Action.COLLECTION_ASSET_BUFF_SUCCESS);
            if(_virmonData.getAssetID() == _loc4_)
            {
               _virmonData.setStats(_loc6_,_loc5_,_loc7_,_loc8_);
            }
            if(_userProfile.id == _loc9_)
            {
               _userProfile.setJolts(_loc11_,_loc10_,_loc12_,_loc13_);
            }
            _statsPanel.setNanovor(_virmonData,null);
            _statsPanel.buffSuccess();
            _nanovor.buffSuccess();
            _bPendingChanges = false;
         }
      }
      
      public function setNanovor(param1:IVirmonData, param2:String) : void
      {
         _bPendingChanges = false;
         _virmonData = param1;
         _szTree = param2;
         _iPendingArmor = _virmonData.getArmor();
         _iPendingSpeed = _virmonData.getSpeed();
         _iPendingStrength = _virmonData.getStrength();
         _iPendingHealth = _virmonData.getHealth();
         _iPendingJoltsArmor = _userProfile.armorJolts;
         _iPendingJoltsSpeed = _userProfile.speedJolts;
         _iPendingJoltsStrength = _userProfile.strengthJolts;
         _iPendingJoltsHealth = _userProfile.healthJolts;
         _virmonMaster = _virmonData.getVirmonMasterData();
         _statsPanel.setNanovor(_virmonData,param2);
      }
      
      private function errorDialogClose(param1:Object) : void
      {
      }
      
      private function onJoltFailed(param1:Event) : void
      {
         IEventDispatcher(param1.target).removeEventListener(Event.COMPLETE,onJoltSuccess);
         IEventDispatcher(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,onJoltFailed);
         CommonDialogBox.MakeAndQueue(CommonDialogBox.TYPE_INFO,"A server error occurred","This buff cannot be completed at this time, due to a server error.  Please try a different Nanovor, or try again later.",0,errorDialogClose,errorDialogClose);
         log("JOLT REQUEST FAILED");
         _analyticsManager.trackAction(Action.COLLECTION_ASSET_BUFF_LOAD_ERROR);
      }
      
      private function checkPending() : Boolean
      {
         if(_iPendingArmor != _virmonData.getArmor() || _iPendingSpeed != _virmonData.getSpeed() || _iPendingStrength != _virmonData.getStrength() || _iPendingHealth != _virmonData.getHealth())
         {
            return true;
         }
         return false;
      }
      
      public function destroy() : void
      {
         _statsPanel.removeEventListener(NanovorStatsPanelEvent.BUFF_UP,onPanelBuffUp);
         _statsPanel.removeEventListener(NanovorStatsPanelEvent.BUFF_DOWN,onPanelBuffDown);
         _statsPanel.removeEventListener(NanovorStatsPanelEvent.CONFIRM_SPEND,onPanelConfirmSpend);
      }
   }
}

