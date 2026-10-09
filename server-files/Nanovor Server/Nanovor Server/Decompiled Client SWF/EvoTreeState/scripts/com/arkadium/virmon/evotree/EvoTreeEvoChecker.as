package com.arkadium.virmon.evotree
{
   import com.arkadium.communications.IUserProfile;
   import com.arkadium.virmon.battle.control.INanovor;
   import com.arkadium.virmon.framework.IBadgeManager;
   import com.arkadium.virmon.framework.IEMManager;
   import com.arkadium.virmon.framework.IEvoManager;
   import com.arkadium.virmon.framework.IVirmonData;
   import com.arkadium.virmon.framework.IVirmonManager;
   import com.arkadium.virmon.framework.events.VirmonDataEvent;
   import com.arkadium.virmon.shared.data.INanovorFactory;
   import com.arkadium.virmon.shared.data.IPedigreeBadge;
   import com.arkadium.virmon.shared.data.IPedigreeData;
   import com.arkadium.virmon.shared.data.IPedigreeEm;
   import com.arkadium.virmon.shared.data.Pedigree;
   import com.smithandtinker.nanovor.debug.DebugLog;
   import flash.events.Event;
   
   public class EvoTreeEvoChecker implements IEvoTreeEvoChecker
   {
      
      private var _nanovorFactory:INanovorFactory;
      
      private var _evoManager:IEvoManager;
      
      private var _consumer:IEvoTreeEvoCheckerConsumer;
      
      private var _userProfile:IUserProfile;
      
      private var _virmonManager:IVirmonManager;
      
      private var _nanovor:INanovor;
      
      private var _badgeManager:IBadgeManager;
      
      private var _pedigreeData:Array;
      
      private var _emManager:IEMManager;
      
      public function EvoTreeEvoChecker(param1:IVirmonManager, param2:INanovorFactory, param3:IEvoManager, param4:IBadgeManager, param5:IEMManager, param6:IUserProfile)
      {
         super();
         _virmonManager = param1;
         _nanovorFactory = param2;
         _evoManager = param3;
         _badgeManager = param4;
         _emManager = param5;
         _userProfile = param6;
      }
      
      private function getEMsNeeded(param1:Array, param2:Array, param3:Array) : void
      {
         var _loc4_:IPedigreeEm = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         if(null == param1)
         {
            return;
         }
         for each(_loc4_ in param1)
         {
            _loc5_ = Boolean(_loc4_.isOwned) ? param2 : param3;
            _loc6_ = _loc4_.name;
            _loc5_.push(_loc6_);
         }
      }
      
      private function log(param1:String) : void
      {
         DebugLog.instance.log("<<EvoTreeEvoChecker>>\t" + param1);
      }
      
      private function formatResponse() : void
      {
         var _loc2_:IPedigreeData = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:EvoTreeCanEvolveResponse = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in _pedigreeData)
         {
            _loc3_ = int(_loc2_.destId);
            _loc4_ = _loc2_.destName;
            _loc5_ = new Array();
            _loc6_ = new Array();
            _loc7_ = new Array();
            _loc8_ = new Array();
            _loc9_ = new Array();
            _loc10_ = new Array();
            getBadgesNeeded(_loc2_.badges,_loc5_,_loc6_);
            getBadgesNeeded(_loc2_.accountBadges,_loc7_,_loc8_);
            getEMsNeeded(_loc2_.ems,_loc9_,_loc10_);
            _loc11_ = new EvoTreeCanEvolveResponse(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
            _loc1_.push(_loc11_);
         }
         if(null != _consumer)
         {
            _consumer.handleCanEvolve(_loc1_);
         }
      }
      
      private function handleBadgesLoaded(param1:Event) : void
      {
         var _loc2_:Pedigree = new Pedigree(_nanovorFactory,_evoManager,_badgeManager,_emManager,_userProfile,_nanovor.assetId);
         _pedigreeData = _loc2_.getPedigree();
         formatResponse();
      }
      
      public function canEvolve(param1:INanovor) : void
      {
         _nanovor = param1;
         var _loc2_:IVirmonData = _virmonManager.getVirmonData(_nanovor.assetId);
         _loc2_.addEventListener(VirmonDataEvent.ASSET_BADGES_LOADED,handleBadgesLoaded,false,0,true);
         _loc2_.loadBadges();
      }
      
      private function getBadgesNeeded(param1:Array, param2:Array, param3:Array) : void
      {
         var _loc4_:IPedigreeBadge = null;
         var _loc5_:Array = null;
         if(null == param1)
         {
            return;
         }
         for each(_loc4_ in param1)
         {
            if(_loc4_.isOwned)
            {
               _loc5_ = param2;
            }
            else
            {
               _loc5_ = param3;
            }
            _loc5_.push(_loc4_.prereqDesc + " (" + _loc4_.progress + "/" + _loc4_.goal + ")");
         }
      }
      
      public function setConsumer(param1:IEvoTreeEvoCheckerConsumer) : void
      {
         _consumer = param1;
      }
   }
}

